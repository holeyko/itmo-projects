#include "entrypoint.h"

#include <linux/fs.h>
#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/slab.h>
#include <linux/user.h>

#include "nwfscalls.h"

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Ryabov Vadim");
MODULE_VERSION("0.01");

struct file_system_type networkfs_fs_type = {.name = "networkfs",
                                             .mount = networkfs_mount,
                                             .kill_sb = networkfs_kill_sb};

struct inode_operations networkfs_inode_ops = {
    .lookup = networkfs_lookup,
    .create = networkfs_create,
    .unlink = networkfs_unlink,
    .mkdir = networkfs_mkdir,
    .rmdir = networkfs_rmdir,
};

struct file_operations networkfs_dir_ops = {
    .iterate = networkfs_iterate,
};

struct dentry *networkfs_mount(struct file_system_type *fs_type, int flags,
                               const char *token, void *data) {
  struct dentry *ret;
  ret = mount_nodev(fs_type, flags, data, networkfs_fill_super);
  if (ret == NULL) {
    printk(KERN_ERR "Can't mount file system");
  } else {
    ret->d_sb->s_fs_info = kmalloc(get_length_str(token), GFP_USER);
    strcpy(ret->d_sb->s_fs_info, token);

    printk(KERN_INFO "Mounted successfuly");
  }
  return ret;
}

int networkfs_fill_super(struct super_block *sb, void *data, int silent) {
  struct inode *inode;
  inode = networkfs_get_inode(sb, NULL, S_IFDIR, ROOT_INO);
  sb->s_root = d_make_root(inode);
  if (sb->s_root == NULL) {
    return -ENOMEM;
  }
  printk(KERN_INFO "return 0\n");
  return 0;
}

struct inode *networkfs_get_inode(struct super_block *sb,
                                  const struct inode *dir, umode_t mode,
                                  int i_ino) {
  struct inode *inode;
  inode = new_inode(sb);
  inode->i_ino = i_ino;
  inode->i_op = &networkfs_inode_ops;
  if (mode & S_IFDIR) {
    inode->i_fop = &networkfs_dir_ops;
  }
  if (inode != NULL) {
    inode_init_owner(&init_user_ns, inode, dir, mode | 0777);
  }
  return inode;
}

void networkfs_kill_sb(struct super_block *sb) {
  kfree(sb->s_fs_info);
  printk(KERN_INFO
         "networkfs super block is destroyed. Unmount successfully.\n");
}

int networkfs_iterate(struct file *filp, struct dir_context *ctx) {
  char fsname[256];
  struct dentry *dentry;
  struct inode *inode;
  unsigned long offset;
  int stored;
  unsigned char ftype;
  ino_t ino;
  ino_t dino;
  dentry = filp->f_path.dentry;
  inode = dentry->d_inode;
  offset = filp->f_pos;
  stored = 0;
  ino = inode->i_ino;

  char *token = (char *)inode->i_sb->s_fs_info;
  struct entries *entries = kmalloc(sizeof(struct entries), GFP_USER);
  if (http_list(token, ino, entries) == 0) {
    size_t count_entries = entries->entries_count;
    while (true) {
      if (offset == 0) {
        strcpy(fsname, ".");
        ftype = DT_DIR;
        dino = ino;
      } else if (offset == 1) {
        strcpy(fsname, "..");
        ftype = DT_DIR;
        dino = dentry->d_parent->d_inode->i_ino;
      } else if (offset < count_entries + 2) {
        int i = offset - 2;
        struct entry entry = entries->entries[i];
        strcpy(fsname, entry.name);
        ftype = entry.entry_type;
        dino = entry.ino;
      } else {
        break;
      }

      dir_emit(ctx, fsname, strlen(fsname), dino, ftype);
      stored++;
      offset++;
      ctx->pos = offset;
    }
  } else {
    stored = -1;
  }

  kfree(entries);

  return stored;
}

struct dentry *networkfs_lookup(struct inode *parent_inode,
                                struct dentry *child_dentry,
                                unsigned int flag) {
  struct inode *inode;
  ino_t parent = parent_inode->i_ino;
  ;
  const char *child_name = child_dentry->d_name.name;

  char *token = (char *)parent_inode->i_sb->s_fs_info;
  struct entry_info *entry_info = kmalloc(sizeof(struct entry_info), GFP_USER);
  if (http_lookup(token, parent, child_name, entry_info) == 0) {
    if (entry_info->entry_type == DT_DIR) {
      inode = networkfs_get_inode(parent_inode->i_sb, NULL, S_IFDIR,
                                  entry_info->ino);
    } else if (entry_info->entry_type == DT_REG) {
      inode = networkfs_get_inode(parent_inode->i_sb, NULL, S_IFREG,
                                  entry_info->ino);
    }

    d_add(child_dentry, inode);
  }

  kfree(entry_info);

  return NULL;
}

int networkfs_create_entry(struct user_namespace *, struct inode *parent_inode,
                           struct dentry *child_dentry, umode_t mode) {
  int ret = 0;
  struct inode *inode;
  unsigned char type;
  unsigned int mask;
  ino_t parent = parent_inode->i_ino;
  const char *name = child_dentry->d_name.name;

  if (mode & S_IFREG) {
    type = DT_REG;
    mask = S_IFREG;
  } else {
    type = DT_DIR;
    mask = S_IFDIR;
  }

  char *token = (char *)parent_inode->i_sb->s_fs_info;
  ino_t *ino = kmalloc(sizeof(ino), GFP_USER);

  if (http_create(token, parent, name, type, ino) == 0) {
    inode =
        networkfs_get_inode(parent_inode->i_sb, NULL, mask | S_IRWXUGO, *ino);
    d_add(child_dentry, inode);
  } else {
    ret = -1;
  }

  kfree(ino);

  return ret;
}

int networkfs_create(struct user_namespace *us, struct inode *parent_inode,
                     struct dentry *child_dentry, umode_t mode, bool b) {
  return networkfs_create_entry(us, parent_inode, child_dentry, mode);
}

int networkfs_mkdir(struct user_namespace *us, struct inode *parent_inode,
                    struct dentry *child_dentry, umode_t mode) {
  return networkfs_create_entry(us, parent_inode, child_dentry, mode);
}

int networkfs_rm_entry(struct inode *parent_inode, struct dentry *child_dentry,
                       unsigned char type) {
  ino_t parent = parent_inode->i_ino;
  const char *name = child_dentry->d_name.name;

  char *token = (char *)parent_inode->i_sb->s_fs_info;
  if (type == DT_REG && http_unlink(token, parent, name) == 0) {
    return 0;
  } else if (type == DT_DIR && http_rmdir(token, parent, name) == 0) {
    return 0;
  }

  return -1;
}

int networkfs_unlink(struct inode *parent_inode, struct dentry *child_dentry) {
  return networkfs_rm_entry(parent_inode, child_dentry, DT_REG);
}

int networkfs_rmdir(struct inode *parent_inode, struct dentry *child_dentry) {
  return networkfs_rm_entry(parent_inode, child_dentry, DT_DIR);
}

int networkfs_init(void) {
  printk(KERN_INFO "Hello, World!\n");
  register_filesystem(&networkfs_fs_type);
  return 0;
}

void networkfs_exit(void) {
  printk(KERN_INFO "Goodbye!\n");
  unregister_filesystem(&networkfs_fs_type);
}

module_init(networkfs_init);
module_exit(networkfs_exit);
