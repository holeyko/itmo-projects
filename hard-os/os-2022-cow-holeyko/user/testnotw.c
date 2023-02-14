#include "kernel/types.h"
#include "user/user.h"

int main() {
  char buf[100];
  int pwd[2];

  pipe(pwd);
  int pid = fork();
  if (pid == 0) {
    sleep(1);
    if (read(pwd[0], buf, 4) != 4) {
      printf("bad\n");
    } else {
      printf("good\n");
    }
  } else {
    write(pwd[1], "pong", 4);
  }

  exit(0);
}