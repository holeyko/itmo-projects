#include "nwfscalls.h"

#include <linux/fs.h>
#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/slab.h>

#include "http.h"

int get_length_str(const char *str) {
  int size = 0;
  while (1) {
    if (*(str + size) == 0) {
      return size;
    }

    ++size;
  }
}

char *ino2str(ino_t ino) {
  int count_digits = 0;
  ino_t cp = ino;

  while (cp != 0) {
    ++count_digits;
    cp /= 10;
  }

  char *ret = kmalloc(count_digits, GFP_USER);
  sprintf(ret, "%ld", ino);

  return ret;
}

int64_t http_list(const char *token, ino_t inode, struct entries *buf) {
  char *inode_str = ino2str(inode);
  int64_t status = networkfs_http_call(token, "list", (char *)buf, sizeof(*buf),
                                       1, "inode", inode_str);
  kfree(inode_str);

  return status;
}

int64_t http_lookup(const char *token, ino_t parent, const char *name,
                    struct entry_info *buf) {
  char *parent_str = ino2str(parent);
  int64_t status =
      networkfs_http_call(token, "lookup", (char *)buf, sizeof(*buf), 2,
                          "parent", parent_str, "name", name);
  kfree(parent_str);

  return status;
}

int64_t http_create(const char *token, ino_t parent, const char *name,
                    unsigned char entry_type, ino_t *buf) {
  char *parent_str = ino2str(parent);
  char type[16];

  if (entry_type == DT_REG) {
    strcpy(type, "file");
  } else if (entry_type == DT_DIR) {
    strcpy(type, "directory");
  } else {
    return -1;
  }
  int64_t status =
      networkfs_http_call(token, "create", (char *)buf, sizeof(*buf), 3,
                          "parent", parent_str, "name", name, "type", type);
  kfree(parent_str);

  return status;
}

int64_t http_remove(const char *token, ino_t parent, const char *name,
                    unsigned char type) {
  char *parent_str = ino2str(parent);
  char meth_name[16];

  if (type == DT_DIR) {
    strcpy(meth_name, "rmdir");
  } else if (type == DT_REG) {
    strcpy(meth_name, "unlink");
  }

  int64_t status = networkfs_http_call(token, meth_name, NULL, 0, 2, "parent",
                                       parent_str, "name", name);
  kfree(parent_str);

  return status;
}

int64_t http_unlink(const char *token, ino_t parent, const char *name) {
  return http_remove(token, parent, name, DT_REG);
}

int64_t http_rmdir(const char *token, ino_t parent, const char *name) {
  return http_remove(token, parent, name, DT_DIR);
}
