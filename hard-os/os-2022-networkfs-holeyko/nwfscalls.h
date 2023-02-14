//
// Created by hedgehog on 12/18/22.
//

#ifndef HARD_OS_NWFSCALLS_H
#define HARD_OS_NWFSCALLS_H

struct entries {
  size_t entries_count;
  struct entry {
    unsigned char entry_type;  // DT_DIR (4) or DT_REG (8)
    ino_t ino;
    char name[256];
  } entries[16];
};

struct entry_info {
  unsigned char entry_type;  // DT_DIR (4) or DT_REG (8)
  ino_t ino;
};

int get_length_str(const char *);

int64_t http_list(const char *token, ino_t inode, struct entries *buf);

int64_t http_lookup(const char *token, ino_t parent, const char *name,
                    struct entry_info *buf);

int64_t http_create(const char *token, ino_t parent, const char *name,
                    unsigned char entry_type, ino_t *buf);

int64_t http_unlink(const char *token, ino_t parent, const char *name);

int64_t http_rmdir(const char *token, ino_t parent, const char *name);

#endif  // HARD_OS_NWFSCALLS_H
