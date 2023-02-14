#ifndef HARD_OS_ENTRYPOINT_H
#define HARD_OS_ENTRYPOINT_H

#define ROOT_INO 1000

struct dentry *networkfs_mount(struct file_system_type *fs_type, int flags,
                               const char *token, void *data);

int networkfs_fill_super(struct super_block *sb, void *data, int silent);

struct inode *networkfs_get_inode(struct super_block *sb,
                                  const struct inode *dir, umode_t mode,
                                  int i_ino);

void networkfs_kill_sb(struct super_block *sb);

struct dentry *networkfs_lookup(struct inode *parent_inode,
                                struct dentry *child_dentry, unsigned int flag);

int networkfs_iterate(struct file *filp, struct dir_context *ctx);

struct dentry *networkfs_lookup(struct inode *parent_inode,
                                struct dentry *child_dentry, unsigned int flag);

int networkfs_create(struct user_namespace *, struct inode *parent_inode,
                     struct dentry *child_dentry, umode_t mode, bool b);

int networkfs_unlink(struct inode *parent_inode, struct dentry *child_dentry);

int networkfs_mkdir(struct user_namespace *, struct inode *, struct dentry *,
                    umode_t);

int networkfs_rmdir(struct inode *, struct dentry *);

#endif  // HARD_OS_ENTRYPOINT_H
