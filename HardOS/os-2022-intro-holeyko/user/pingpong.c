#include "kernel/types.h"
#include "user/user.h"

#define BUF_SIZE 1024

#define PING "ping"
#define PONG "pong"

void read_pipe(int *pipefd) {
  char *message = malloc(BUF_SIZE);
  int count_read = 1, cur_pos = 0;
  while (count_read != 0 && cur_pos < BUF_SIZE) {
    count_read = read(*pipefd, message + cur_pos, BUF_SIZE - cur_pos);
    if (count_read == -1) {
      printf("error while reading from pipe\n");
      exit(1);
    }
    cur_pos += count_read;
  }

  printf("%d: got %s\n", getpid(), message);
}

void write_pipe(int *pipefd, char *message) {
  int count_write = 0;
  int cur_pos = 0;
  int mess_len = strlen(message) + 1;
  while (mess_len > cur_pos) {
    count_write = write(*pipefd, message + cur_pos, mess_len - cur_pos);
    if (count_write == -1) {
      printf("error while writing from pipe\n");
      exit(1);
    }

    cur_pos += count_write;
  }
}

int main() {
  int pipefd1[2];
  int pipefd2[2];

  if (pipe(pipefd1) == -1 || pipe(pipefd2) == -1) {
    printf("pipe error\n");
    exit(1);
  }

  int pid = fork();
  if (pid < 0) {
    printf("fork error\n");
    exit(1);
  } else if (pid == 0) {
    close(pipefd1[1]);
    read_pipe(&pipefd1[0]);
    close(pipefd1[0]);

    close(pipefd2[0]);
    write_pipe(&pipefd2[1], PONG);
    close(pipefd2[1]);
  } else {
    close(pipefd1[0]);
    write_pipe(&pipefd1[1], PING);
    close(pipefd1[1]);
    wait(0);

    close(pipefd2[1]);
    read_pipe(&pipefd2[0]);
    close(pipefd2[0]);
  }

  exit(0);
}
