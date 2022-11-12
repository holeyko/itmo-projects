
user/_pingpong:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <read_pipe>:
#define BUF_SIZE 1024

#define PING "ping"
#define PONG "pong"

void read_pipe(int *pipefd) {
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	e05a                	sd	s6,0(sp)
  12:	0080                	addi	s0,sp,64
  14:	89aa                	mv	s3,a0
  char *message = malloc(BUF_SIZE);
  16:	40000513          	li	a0,1024
  1a:	00001097          	auipc	ra,0x1
  1e:	8e2080e7          	jalr	-1822(ra) # 8fc <malloc>
  22:	892a                	mv	s2,a0
  int count_read = 1, cur_pos = 0;
  24:	4481                	li	s1,0
  while (count_read != 0 && cur_pos < BUF_SIZE) {
    count_read = read(*pipefd, message + cur_pos, BUF_SIZE - cur_pos);
  26:	40000a93          	li	s5,1024
    if (count_read == -1) {
  2a:	5a7d                	li	s4,-1
  while (count_read != 0 && cur_pos < BUF_SIZE) {
  2c:	3ff00b13          	li	s6,1023
    count_read = read(*pipefd, message + cur_pos, BUF_SIZE - cur_pos);
  30:	409a863b          	subw	a2,s5,s1
  34:	009905b3          	add	a1,s2,s1
  38:	0009a503          	lw	a0,0(s3)
  3c:	00000097          	auipc	ra,0x0
  40:	496080e7          	jalr	1174(ra) # 4d2 <read>
    if (count_read == -1) {
  44:	03450e63          	beq	a0,s4,80 <read_pipe+0x80>
      printf("error while reading from pipe\n");
      exit(1);
    }
    cur_pos += count_read;
  48:	9ca9                	addw	s1,s1,a0
  while (count_read != 0 && cur_pos < BUF_SIZE) {
  4a:	c119                	beqz	a0,50 <read_pipe+0x50>
  4c:	fe9b52e3          	bge	s6,s1,30 <read_pipe+0x30>
  }

  printf("%d: got %s\n", getpid(), message);
  50:	00000097          	auipc	ra,0x0
  54:	4ea080e7          	jalr	1258(ra) # 53a <getpid>
  58:	85aa                	mv	a1,a0
  5a:	864a                	mv	a2,s2
  5c:	00001517          	auipc	a0,0x1
  60:	aa450513          	addi	a0,a0,-1372 # b00 <loop+0x30>
  64:	00000097          	auipc	ra,0x0
  68:	7e0080e7          	jalr	2016(ra) # 844 <printf>
}
  6c:	70e2                	ld	ra,56(sp)
  6e:	7442                	ld	s0,48(sp)
  70:	74a2                	ld	s1,40(sp)
  72:	7902                	ld	s2,32(sp)
  74:	69e2                	ld	s3,24(sp)
  76:	6a42                	ld	s4,16(sp)
  78:	6aa2                	ld	s5,8(sp)
  7a:	6b02                	ld	s6,0(sp)
  7c:	6121                	addi	sp,sp,64
  7e:	8082                	ret
      printf("error while reading from pipe\n");
  80:	00001517          	auipc	a0,0x1
  84:	a6050513          	addi	a0,a0,-1440 # ae0 <loop+0x10>
  88:	00000097          	auipc	ra,0x0
  8c:	7bc080e7          	jalr	1980(ra) # 844 <printf>
      exit(1);
  90:	4505                	li	a0,1
  92:	00000097          	auipc	ra,0x0
  96:	428080e7          	jalr	1064(ra) # 4ba <exit>

000000000000009a <write_pipe>:

void write_pipe(int *pipefd, char *message) {
  9a:	7139                	addi	sp,sp,-64
  9c:	fc06                	sd	ra,56(sp)
  9e:	f822                	sd	s0,48(sp)
  a0:	f426                	sd	s1,40(sp)
  a2:	f04a                	sd	s2,32(sp)
  a4:	ec4e                	sd	s3,24(sp)
  a6:	e852                	sd	s4,16(sp)
  a8:	e456                	sd	s5,8(sp)
  aa:	0080                	addi	s0,sp,64
  ac:	8a2a                	mv	s4,a0
  ae:	89ae                	mv	s3,a1
  int count_write = 0;
  int cur_pos = 0;
  int mess_len = strlen(message) + 1;
  b0:	852e                	mv	a0,a1
  b2:	00000097          	auipc	ra,0x0
  b6:	1e4080e7          	jalr	484(ra) # 296 <strlen>
  ba:	0015091b          	addiw	s2,a0,1
  while (mess_len > cur_pos) {
  be:	03205363          	blez	s2,e4 <write_pipe+0x4a>
  int cur_pos = 0;
  c2:	4481                	li	s1,0
    count_write = write(*pipefd, message + cur_pos, mess_len - cur_pos);
    if (count_write == -1) {
  c4:	5afd                	li	s5,-1
    count_write = write(*pipefd, message + cur_pos, mess_len - cur_pos);
  c6:	4099063b          	subw	a2,s2,s1
  ca:	009985b3          	add	a1,s3,s1
  ce:	000a2503          	lw	a0,0(s4)
  d2:	00000097          	auipc	ra,0x0
  d6:	408080e7          	jalr	1032(ra) # 4da <write>
    if (count_write == -1) {
  da:	01550e63          	beq	a0,s5,f6 <write_pipe+0x5c>
      printf("error while writing from pipe\n");
      exit(1);
    }

    cur_pos += count_write;
  de:	9ca9                	addw	s1,s1,a0
  while (mess_len > cur_pos) {
  e0:	ff24c3e3          	blt	s1,s2,c6 <write_pipe+0x2c>
  }
}
  e4:	70e2                	ld	ra,56(sp)
  e6:	7442                	ld	s0,48(sp)
  e8:	74a2                	ld	s1,40(sp)
  ea:	7902                	ld	s2,32(sp)
  ec:	69e2                	ld	s3,24(sp)
  ee:	6a42                	ld	s4,16(sp)
  f0:	6aa2                	ld	s5,8(sp)
  f2:	6121                	addi	sp,sp,64
  f4:	8082                	ret
      printf("error while writing from pipe\n");
  f6:	00001517          	auipc	a0,0x1
  fa:	a1a50513          	addi	a0,a0,-1510 # b10 <loop+0x40>
  fe:	00000097          	auipc	ra,0x0
 102:	746080e7          	jalr	1862(ra) # 844 <printf>
      exit(1);
 106:	4505                	li	a0,1
 108:	00000097          	auipc	ra,0x0
 10c:	3b2080e7          	jalr	946(ra) # 4ba <exit>

0000000000000110 <main>:

int main() {
 110:	1101                	addi	sp,sp,-32
 112:	ec06                	sd	ra,24(sp)
 114:	e822                	sd	s0,16(sp)
 116:	1000                	addi	s0,sp,32
  int pipefd1[2];
  int pipefd2[2];

  if (pipe(pipefd1) == -1 || pipe(pipefd2) == -1) {
 118:	fe840513          	addi	a0,s0,-24
 11c:	00000097          	auipc	ra,0x0
 120:	3ae080e7          	jalr	942(ra) # 4ca <pipe>
 124:	57fd                	li	a5,-1
 126:	00f50b63          	beq	a0,a5,13c <main+0x2c>
 12a:	fe040513          	addi	a0,s0,-32
 12e:	00000097          	auipc	ra,0x0
 132:	39c080e7          	jalr	924(ra) # 4ca <pipe>
 136:	57fd                	li	a5,-1
 138:	00f51f63          	bne	a0,a5,156 <main+0x46>
    printf("pipe error\n");
 13c:	00001517          	auipc	a0,0x1
 140:	9f450513          	addi	a0,a0,-1548 # b30 <loop+0x60>
 144:	00000097          	auipc	ra,0x0
 148:	700080e7          	jalr	1792(ra) # 844 <printf>
    exit(1);
 14c:	4505                	li	a0,1
 14e:	00000097          	auipc	ra,0x0
 152:	36c080e7          	jalr	876(ra) # 4ba <exit>
  }

  int pid = fork();
 156:	00000097          	auipc	ra,0x0
 15a:	35c080e7          	jalr	860(ra) # 4b2 <fork>
  if (pid < 0) {
 15e:	06054063          	bltz	a0,1be <main+0xae>
    printf("fork error\n");
    exit(1);
  } else if (pid == 0) {
 162:	e93d                	bnez	a0,1d8 <main+0xc8>
    close(pipefd1[1]);
 164:	fec42503          	lw	a0,-20(s0)
 168:	00000097          	auipc	ra,0x0
 16c:	37a080e7          	jalr	890(ra) # 4e2 <close>
    read_pipe(&pipefd1[0]);
 170:	fe840513          	addi	a0,s0,-24
 174:	00000097          	auipc	ra,0x0
 178:	e8c080e7          	jalr	-372(ra) # 0 <read_pipe>
    close(pipefd1[0]);
 17c:	fe842503          	lw	a0,-24(s0)
 180:	00000097          	auipc	ra,0x0
 184:	362080e7          	jalr	866(ra) # 4e2 <close>

    close(pipefd2[0]);
 188:	fe042503          	lw	a0,-32(s0)
 18c:	00000097          	auipc	ra,0x0
 190:	356080e7          	jalr	854(ra) # 4e2 <close>
    write_pipe(&pipefd2[1], PONG);
 194:	00001597          	auipc	a1,0x1
 198:	9bc58593          	addi	a1,a1,-1604 # b50 <loop+0x80>
 19c:	fe440513          	addi	a0,s0,-28
 1a0:	00000097          	auipc	ra,0x0
 1a4:	efa080e7          	jalr	-262(ra) # 9a <write_pipe>
    close(pipefd2[1]);
 1a8:	fe442503          	lw	a0,-28(s0)
 1ac:	00000097          	auipc	ra,0x0
 1b0:	336080e7          	jalr	822(ra) # 4e2 <close>
    close(pipefd2[1]);
    read_pipe(&pipefd2[0]);
    close(pipefd2[0]);
  }

  exit(0);
 1b4:	4501                	li	a0,0
 1b6:	00000097          	auipc	ra,0x0
 1ba:	304080e7          	jalr	772(ra) # 4ba <exit>
    printf("fork error\n");
 1be:	00001517          	auipc	a0,0x1
 1c2:	98250513          	addi	a0,a0,-1662 # b40 <loop+0x70>
 1c6:	00000097          	auipc	ra,0x0
 1ca:	67e080e7          	jalr	1662(ra) # 844 <printf>
    exit(1);
 1ce:	4505                	li	a0,1
 1d0:	00000097          	auipc	ra,0x0
 1d4:	2ea080e7          	jalr	746(ra) # 4ba <exit>
    close(pipefd1[0]);
 1d8:	fe842503          	lw	a0,-24(s0)
 1dc:	00000097          	auipc	ra,0x0
 1e0:	306080e7          	jalr	774(ra) # 4e2 <close>
    write_pipe(&pipefd1[1], PING);
 1e4:	00001597          	auipc	a1,0x1
 1e8:	97458593          	addi	a1,a1,-1676 # b58 <loop+0x88>
 1ec:	fec40513          	addi	a0,s0,-20
 1f0:	00000097          	auipc	ra,0x0
 1f4:	eaa080e7          	jalr	-342(ra) # 9a <write_pipe>
    close(pipefd1[1]);
 1f8:	fec42503          	lw	a0,-20(s0)
 1fc:	00000097          	auipc	ra,0x0
 200:	2e6080e7          	jalr	742(ra) # 4e2 <close>
    wait(0);
 204:	4501                	li	a0,0
 206:	00000097          	auipc	ra,0x0
 20a:	2bc080e7          	jalr	700(ra) # 4c2 <wait>
    close(pipefd2[1]);
 20e:	fe442503          	lw	a0,-28(s0)
 212:	00000097          	auipc	ra,0x0
 216:	2d0080e7          	jalr	720(ra) # 4e2 <close>
    read_pipe(&pipefd2[0]);
 21a:	fe040513          	addi	a0,s0,-32
 21e:	00000097          	auipc	ra,0x0
 222:	de2080e7          	jalr	-542(ra) # 0 <read_pipe>
    close(pipefd2[0]);
 226:	fe042503          	lw	a0,-32(s0)
 22a:	00000097          	auipc	ra,0x0
 22e:	2b8080e7          	jalr	696(ra) # 4e2 <close>
 232:	b749                	j	1b4 <main+0xa4>

0000000000000234 <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
 234:	1141                	addi	sp,sp,-16
 236:	e406                	sd	ra,8(sp)
 238:	e022                	sd	s0,0(sp)
 23a:	0800                	addi	s0,sp,16
  extern int main();
  main();
 23c:	00000097          	auipc	ra,0x0
 240:	ed4080e7          	jalr	-300(ra) # 110 <main>
  exit(0);
 244:	4501                	li	a0,0
 246:	00000097          	auipc	ra,0x0
 24a:	274080e7          	jalr	628(ra) # 4ba <exit>

000000000000024e <strcpy>:
}

char *strcpy(char *s, const char *t) {
 24e:	1141                	addi	sp,sp,-16
 250:	e422                	sd	s0,8(sp)
 252:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 254:	87aa                	mv	a5,a0
 256:	0585                	addi	a1,a1,1
 258:	0785                	addi	a5,a5,1
 25a:	fff5c703          	lbu	a4,-1(a1)
 25e:	fee78fa3          	sb	a4,-1(a5)
 262:	fb75                	bnez	a4,256 <strcpy+0x8>
    ;
  return os;
}
 264:	6422                	ld	s0,8(sp)
 266:	0141                	addi	sp,sp,16
 268:	8082                	ret

000000000000026a <strcmp>:

int strcmp(const char *p, const char *q) {
 26a:	1141                	addi	sp,sp,-16
 26c:	e422                	sd	s0,8(sp)
 26e:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
 270:	00054783          	lbu	a5,0(a0)
 274:	cb91                	beqz	a5,288 <strcmp+0x1e>
 276:	0005c703          	lbu	a4,0(a1)
 27a:	00f71763          	bne	a4,a5,288 <strcmp+0x1e>
 27e:	0505                	addi	a0,a0,1
 280:	0585                	addi	a1,a1,1
 282:	00054783          	lbu	a5,0(a0)
 286:	fbe5                	bnez	a5,276 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 288:	0005c503          	lbu	a0,0(a1)
}
 28c:	40a7853b          	subw	a0,a5,a0
 290:	6422                	ld	s0,8(sp)
 292:	0141                	addi	sp,sp,16
 294:	8082                	ret

0000000000000296 <strlen>:

uint strlen(const char *s) {
 296:	1141                	addi	sp,sp,-16
 298:	e422                	sd	s0,8(sp)
 29a:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 29c:	00054783          	lbu	a5,0(a0)
 2a0:	cf91                	beqz	a5,2bc <strlen+0x26>
 2a2:	0505                	addi	a0,a0,1
 2a4:	87aa                	mv	a5,a0
 2a6:	4685                	li	a3,1
 2a8:	9e89                	subw	a3,a3,a0
 2aa:	00f6853b          	addw	a0,a3,a5
 2ae:	0785                	addi	a5,a5,1
 2b0:	fff7c703          	lbu	a4,-1(a5)
 2b4:	fb7d                	bnez	a4,2aa <strlen+0x14>
    ;
  return n;
}
 2b6:	6422                	ld	s0,8(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret
  for (n = 0; s[n]; n++)
 2bc:	4501                	li	a0,0
 2be:	bfe5                	j	2b6 <strlen+0x20>

00000000000002c0 <memset>:

void *memset(void *dst, int c, uint n) {
 2c0:	1141                	addi	sp,sp,-16
 2c2:	e422                	sd	s0,8(sp)
 2c4:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 2c6:	ca19                	beqz	a2,2dc <memset+0x1c>
 2c8:	87aa                	mv	a5,a0
 2ca:	1602                	slli	a2,a2,0x20
 2cc:	9201                	srli	a2,a2,0x20
 2ce:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2d2:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 2d6:	0785                	addi	a5,a5,1
 2d8:	fee79de3          	bne	a5,a4,2d2 <memset+0x12>
  }
  return dst;
}
 2dc:	6422                	ld	s0,8(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret

00000000000002e2 <strchr>:

char *strchr(const char *s, char c) {
 2e2:	1141                	addi	sp,sp,-16
 2e4:	e422                	sd	s0,8(sp)
 2e6:	0800                	addi	s0,sp,16
  for (; *s; s++)
 2e8:	00054783          	lbu	a5,0(a0)
 2ec:	cb99                	beqz	a5,302 <strchr+0x20>
    if (*s == c) return (char *)s;
 2ee:	00f58763          	beq	a1,a5,2fc <strchr+0x1a>
  for (; *s; s++)
 2f2:	0505                	addi	a0,a0,1
 2f4:	00054783          	lbu	a5,0(a0)
 2f8:	fbfd                	bnez	a5,2ee <strchr+0xc>
  return 0;
 2fa:	4501                	li	a0,0
}
 2fc:	6422                	ld	s0,8(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret
  return 0;
 302:	4501                	li	a0,0
 304:	bfe5                	j	2fc <strchr+0x1a>

0000000000000306 <gets>:

char *gets(char *buf, int max) {
 306:	711d                	addi	sp,sp,-96
 308:	ec86                	sd	ra,88(sp)
 30a:	e8a2                	sd	s0,80(sp)
 30c:	e4a6                	sd	s1,72(sp)
 30e:	e0ca                	sd	s2,64(sp)
 310:	fc4e                	sd	s3,56(sp)
 312:	f852                	sd	s4,48(sp)
 314:	f456                	sd	s5,40(sp)
 316:	f05a                	sd	s6,32(sp)
 318:	ec5e                	sd	s7,24(sp)
 31a:	1080                	addi	s0,sp,96
 31c:	8baa                	mv	s7,a0
 31e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 320:	892a                	mv	s2,a0
 322:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
 324:	4aa9                	li	s5,10
 326:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 328:	89a6                	mv	s3,s1
 32a:	2485                	addiw	s1,s1,1
 32c:	0344d863          	bge	s1,s4,35c <gets+0x56>
    cc = read(0, &c, 1);
 330:	4605                	li	a2,1
 332:	faf40593          	addi	a1,s0,-81
 336:	4501                	li	a0,0
 338:	00000097          	auipc	ra,0x0
 33c:	19a080e7          	jalr	410(ra) # 4d2 <read>
    if (cc < 1) break;
 340:	00a05e63          	blez	a0,35c <gets+0x56>
    buf[i++] = c;
 344:	faf44783          	lbu	a5,-81(s0)
 348:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r') break;
 34c:	01578763          	beq	a5,s5,35a <gets+0x54>
 350:	0905                	addi	s2,s2,1
 352:	fd679be3          	bne	a5,s6,328 <gets+0x22>
  for (i = 0; i + 1 < max;) {
 356:	89a6                	mv	s3,s1
 358:	a011                	j	35c <gets+0x56>
 35a:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
 35c:	99de                	add	s3,s3,s7
 35e:	00098023          	sb	zero,0(s3)
  return buf;
}
 362:	855e                	mv	a0,s7
 364:	60e6                	ld	ra,88(sp)
 366:	6446                	ld	s0,80(sp)
 368:	64a6                	ld	s1,72(sp)
 36a:	6906                	ld	s2,64(sp)
 36c:	79e2                	ld	s3,56(sp)
 36e:	7a42                	ld	s4,48(sp)
 370:	7aa2                	ld	s5,40(sp)
 372:	7b02                	ld	s6,32(sp)
 374:	6be2                	ld	s7,24(sp)
 376:	6125                	addi	sp,sp,96
 378:	8082                	ret

000000000000037a <stat>:

int stat(const char *n, struct stat *st) {
 37a:	1101                	addi	sp,sp,-32
 37c:	ec06                	sd	ra,24(sp)
 37e:	e822                	sd	s0,16(sp)
 380:	e426                	sd	s1,8(sp)
 382:	e04a                	sd	s2,0(sp)
 384:	1000                	addi	s0,sp,32
 386:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 388:	4581                	li	a1,0
 38a:	00000097          	auipc	ra,0x0
 38e:	170080e7          	jalr	368(ra) # 4fa <open>
  if (fd < 0) return -1;
 392:	02054563          	bltz	a0,3bc <stat+0x42>
 396:	84aa                	mv	s1,a0
  r = fstat(fd, st);
 398:	85ca                	mv	a1,s2
 39a:	00000097          	auipc	ra,0x0
 39e:	178080e7          	jalr	376(ra) # 512 <fstat>
 3a2:	892a                	mv	s2,a0
  close(fd);
 3a4:	8526                	mv	a0,s1
 3a6:	00000097          	auipc	ra,0x0
 3aa:	13c080e7          	jalr	316(ra) # 4e2 <close>
  return r;
}
 3ae:	854a                	mv	a0,s2
 3b0:	60e2                	ld	ra,24(sp)
 3b2:	6442                	ld	s0,16(sp)
 3b4:	64a2                	ld	s1,8(sp)
 3b6:	6902                	ld	s2,0(sp)
 3b8:	6105                	addi	sp,sp,32
 3ba:	8082                	ret
  if (fd < 0) return -1;
 3bc:	597d                	li	s2,-1
 3be:	bfc5                	j	3ae <stat+0x34>

00000000000003c0 <atoi>:

int atoi(const char *s) {
 3c0:	1141                	addi	sp,sp,-16
 3c2:	e422                	sd	s0,8(sp)
 3c4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 3c6:	00054683          	lbu	a3,0(a0)
 3ca:	fd06879b          	addiw	a5,a3,-48
 3ce:	0ff7f793          	zext.b	a5,a5
 3d2:	4625                	li	a2,9
 3d4:	02f66863          	bltu	a2,a5,404 <atoi+0x44>
 3d8:	872a                	mv	a4,a0
  n = 0;
 3da:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 3dc:	0705                	addi	a4,a4,1
 3de:	0025179b          	slliw	a5,a0,0x2
 3e2:	9fa9                	addw	a5,a5,a0
 3e4:	0017979b          	slliw	a5,a5,0x1
 3e8:	9fb5                	addw	a5,a5,a3
 3ea:	fd07851b          	addiw	a0,a5,-48
 3ee:	00074683          	lbu	a3,0(a4)
 3f2:	fd06879b          	addiw	a5,a3,-48
 3f6:	0ff7f793          	zext.b	a5,a5
 3fa:	fef671e3          	bgeu	a2,a5,3dc <atoi+0x1c>
  return n;
}
 3fe:	6422                	ld	s0,8(sp)
 400:	0141                	addi	sp,sp,16
 402:	8082                	ret
  n = 0;
 404:	4501                	li	a0,0
 406:	bfe5                	j	3fe <atoi+0x3e>

0000000000000408 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
 408:	1141                	addi	sp,sp,-16
 40a:	e422                	sd	s0,8(sp)
 40c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 40e:	02b57463          	bgeu	a0,a1,436 <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
 412:	00c05f63          	blez	a2,430 <memmove+0x28>
 416:	1602                	slli	a2,a2,0x20
 418:	9201                	srli	a2,a2,0x20
 41a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 41e:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
 420:	0585                	addi	a1,a1,1
 422:	0705                	addi	a4,a4,1
 424:	fff5c683          	lbu	a3,-1(a1)
 428:	fed70fa3          	sb	a3,-1(a4)
 42c:	fee79ae3          	bne	a5,a4,420 <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
 430:	6422                	ld	s0,8(sp)
 432:	0141                	addi	sp,sp,16
 434:	8082                	ret
    dst += n;
 436:	00c50733          	add	a4,a0,a2
    src += n;
 43a:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
 43c:	fec05ae3          	blez	a2,430 <memmove+0x28>
 440:	fff6079b          	addiw	a5,a2,-1
 444:	1782                	slli	a5,a5,0x20
 446:	9381                	srli	a5,a5,0x20
 448:	fff7c793          	not	a5,a5
 44c:	97ba                	add	a5,a5,a4
 44e:	15fd                	addi	a1,a1,-1
 450:	177d                	addi	a4,a4,-1
 452:	0005c683          	lbu	a3,0(a1)
 456:	00d70023          	sb	a3,0(a4)
 45a:	fee79ae3          	bne	a5,a4,44e <memmove+0x46>
 45e:	bfc9                	j	430 <memmove+0x28>

0000000000000460 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
 460:	1141                	addi	sp,sp,-16
 462:	e422                	sd	s0,8(sp)
 464:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 466:	ca05                	beqz	a2,496 <memcmp+0x36>
 468:	fff6069b          	addiw	a3,a2,-1
 46c:	1682                	slli	a3,a3,0x20
 46e:	9281                	srli	a3,a3,0x20
 470:	0685                	addi	a3,a3,1
 472:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 474:	00054783          	lbu	a5,0(a0)
 478:	0005c703          	lbu	a4,0(a1)
 47c:	00e79863          	bne	a5,a4,48c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 480:	0505                	addi	a0,a0,1
    p2++;
 482:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 484:	fed518e3          	bne	a0,a3,474 <memcmp+0x14>
  }
  return 0;
 488:	4501                	li	a0,0
 48a:	a019                	j	490 <memcmp+0x30>
      return *p1 - *p2;
 48c:	40e7853b          	subw	a0,a5,a4
}
 490:	6422                	ld	s0,8(sp)
 492:	0141                	addi	sp,sp,16
 494:	8082                	ret
  return 0;
 496:	4501                	li	a0,0
 498:	bfe5                	j	490 <memcmp+0x30>

000000000000049a <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
 49a:	1141                	addi	sp,sp,-16
 49c:	e406                	sd	ra,8(sp)
 49e:	e022                	sd	s0,0(sp)
 4a0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4a2:	00000097          	auipc	ra,0x0
 4a6:	f66080e7          	jalr	-154(ra) # 408 <memmove>
}
 4aa:	60a2                	ld	ra,8(sp)
 4ac:	6402                	ld	s0,0(sp)
 4ae:	0141                	addi	sp,sp,16
 4b0:	8082                	ret

00000000000004b2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4b2:	4885                	li	a7,1
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <exit>:
.global exit
exit:
 li a7, SYS_exit
 4ba:	4889                	li	a7,2
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4c2:	488d                	li	a7,3
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4ca:	4891                	li	a7,4
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <read>:
.global read
read:
 li a7, SYS_read
 4d2:	4895                	li	a7,5
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <write>:
.global write
write:
 li a7, SYS_write
 4da:	48c1                	li	a7,16
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <close>:
.global close
close:
 li a7, SYS_close
 4e2:	48d5                	li	a7,21
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <kill>:
.global kill
kill:
 li a7, SYS_kill
 4ea:	4899                	li	a7,6
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4f2:	489d                	li	a7,7
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <open>:
.global open
open:
 li a7, SYS_open
 4fa:	48bd                	li	a7,15
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 502:	48c5                	li	a7,17
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 50a:	48c9                	li	a7,18
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 512:	48a1                	li	a7,8
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <link>:
.global link
link:
 li a7, SYS_link
 51a:	48cd                	li	a7,19
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 522:	48d1                	li	a7,20
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 52a:	48a5                	li	a7,9
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <dup>:
.global dup
dup:
 li a7, SYS_dup
 532:	48a9                	li	a7,10
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 53a:	48ad                	li	a7,11
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 542:	48b1                	li	a7,12
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 54a:	48b5                	li	a7,13
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 552:	48b9                	li	a7,14
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <dump>:
.global dump
dump:
 li a7, SYS_dump
 55a:	48d9                	li	a7,22
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <dump2>:
.global dump2
dump2:
 li a7, SYS_dump2
 562:	48dd                	li	a7,23
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <putc>:

#include <stdarg.h>

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 56a:	1101                	addi	sp,sp,-32
 56c:	ec06                	sd	ra,24(sp)
 56e:	e822                	sd	s0,16(sp)
 570:	1000                	addi	s0,sp,32
 572:	feb407a3          	sb	a1,-17(s0)
 576:	4605                	li	a2,1
 578:	fef40593          	addi	a1,s0,-17
 57c:	00000097          	auipc	ra,0x0
 580:	f5e080e7          	jalr	-162(ra) # 4da <write>
 584:	60e2                	ld	ra,24(sp)
 586:	6442                	ld	s0,16(sp)
 588:	6105                	addi	sp,sp,32
 58a:	8082                	ret

000000000000058c <printint>:

static void printint(int fd, int xx, int base, int sgn) {
 58c:	7139                	addi	sp,sp,-64
 58e:	fc06                	sd	ra,56(sp)
 590:	f822                	sd	s0,48(sp)
 592:	f426                	sd	s1,40(sp)
 594:	f04a                	sd	s2,32(sp)
 596:	ec4e                	sd	s3,24(sp)
 598:	0080                	addi	s0,sp,64
 59a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0) {
 59c:	c299                	beqz	a3,5a2 <printint+0x16>
 59e:	0805c963          	bltz	a1,630 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5a2:	2581                	sext.w	a1,a1
  neg = 0;
 5a4:	4881                	li	a7,0
 5a6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5aa:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 5ac:	2601                	sext.w	a2,a2
 5ae:	00000517          	auipc	a0,0x0
 5b2:	61250513          	addi	a0,a0,1554 # bc0 <digits>
 5b6:	883a                	mv	a6,a4
 5b8:	2705                	addiw	a4,a4,1
 5ba:	02c5f7bb          	remuw	a5,a1,a2
 5be:	1782                	slli	a5,a5,0x20
 5c0:	9381                	srli	a5,a5,0x20
 5c2:	97aa                	add	a5,a5,a0
 5c4:	0007c783          	lbu	a5,0(a5)
 5c8:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 5cc:	0005879b          	sext.w	a5,a1
 5d0:	02c5d5bb          	divuw	a1,a1,a2
 5d4:	0685                	addi	a3,a3,1
 5d6:	fec7f0e3          	bgeu	a5,a2,5b6 <printint+0x2a>
  if (neg) buf[i++] = '-';
 5da:	00088c63          	beqz	a7,5f2 <printint+0x66>
 5de:	fd070793          	addi	a5,a4,-48
 5e2:	00878733          	add	a4,a5,s0
 5e6:	02d00793          	li	a5,45
 5ea:	fef70823          	sb	a5,-16(a4)
 5ee:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) putc(fd, buf[i]);
 5f2:	02e05863          	blez	a4,622 <printint+0x96>
 5f6:	fc040793          	addi	a5,s0,-64
 5fa:	00e78933          	add	s2,a5,a4
 5fe:	fff78993          	addi	s3,a5,-1
 602:	99ba                	add	s3,s3,a4
 604:	377d                	addiw	a4,a4,-1
 606:	1702                	slli	a4,a4,0x20
 608:	9301                	srli	a4,a4,0x20
 60a:	40e989b3          	sub	s3,s3,a4
 60e:	fff94583          	lbu	a1,-1(s2)
 612:	8526                	mv	a0,s1
 614:	00000097          	auipc	ra,0x0
 618:	f56080e7          	jalr	-170(ra) # 56a <putc>
 61c:	197d                	addi	s2,s2,-1
 61e:	ff3918e3          	bne	s2,s3,60e <printint+0x82>
}
 622:	70e2                	ld	ra,56(sp)
 624:	7442                	ld	s0,48(sp)
 626:	74a2                	ld	s1,40(sp)
 628:	7902                	ld	s2,32(sp)
 62a:	69e2                	ld	s3,24(sp)
 62c:	6121                	addi	sp,sp,64
 62e:	8082                	ret
    x = -xx;
 630:	40b005bb          	negw	a1,a1
    neg = 1;
 634:	4885                	li	a7,1
    x = -xx;
 636:	bf85                	j	5a6 <printint+0x1a>

0000000000000638 <vprintf>:
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap) {
 638:	7119                	addi	sp,sp,-128
 63a:	fc86                	sd	ra,120(sp)
 63c:	f8a2                	sd	s0,112(sp)
 63e:	f4a6                	sd	s1,104(sp)
 640:	f0ca                	sd	s2,96(sp)
 642:	ecce                	sd	s3,88(sp)
 644:	e8d2                	sd	s4,80(sp)
 646:	e4d6                	sd	s5,72(sp)
 648:	e0da                	sd	s6,64(sp)
 64a:	fc5e                	sd	s7,56(sp)
 64c:	f862                	sd	s8,48(sp)
 64e:	f466                	sd	s9,40(sp)
 650:	f06a                	sd	s10,32(sp)
 652:	ec6e                	sd	s11,24(sp)
 654:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 656:	0005c903          	lbu	s2,0(a1)
 65a:	18090f63          	beqz	s2,7f8 <vprintf+0x1c0>
 65e:	8aaa                	mv	s5,a0
 660:	8b32                	mv	s6,a2
 662:	00158493          	addi	s1,a1,1
  state = 0;
 666:	4981                	li	s3,0
      if (c == '%') {
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if (state == '%') {
 668:	02500a13          	li	s4,37
 66c:	4c55                	li	s8,21
 66e:	00000c97          	auipc	s9,0x0
 672:	4fac8c93          	addi	s9,s9,1274 # b68 <loop+0x98>
      } else if (c == 'p') {
        printptr(fd, va_arg(ap, uint64));
      } else if (c == 's') {
        s = va_arg(ap, char *);
        if (s == 0) s = "(null)";
        while (*s != 0) {
 676:	02800d93          	li	s11,40
  putc(fd, 'x');
 67a:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 67c:	00000b97          	auipc	s7,0x0
 680:	544b8b93          	addi	s7,s7,1348 # bc0 <digits>
 684:	a839                	j	6a2 <vprintf+0x6a>
        putc(fd, c);
 686:	85ca                	mv	a1,s2
 688:	8556                	mv	a0,s5
 68a:	00000097          	auipc	ra,0x0
 68e:	ee0080e7          	jalr	-288(ra) # 56a <putc>
 692:	a019                	j	698 <vprintf+0x60>
    } else if (state == '%') {
 694:	01498d63          	beq	s3,s4,6ae <vprintf+0x76>
  for (i = 0; fmt[i]; i++) {
 698:	0485                	addi	s1,s1,1
 69a:	fff4c903          	lbu	s2,-1(s1)
 69e:	14090d63          	beqz	s2,7f8 <vprintf+0x1c0>
    if (state == 0) {
 6a2:	fe0999e3          	bnez	s3,694 <vprintf+0x5c>
      if (c == '%') {
 6a6:	ff4910e3          	bne	s2,s4,686 <vprintf+0x4e>
        state = '%';
 6aa:	89d2                	mv	s3,s4
 6ac:	b7f5                	j	698 <vprintf+0x60>
      if (c == 'd') {
 6ae:	11490c63          	beq	s2,s4,7c6 <vprintf+0x18e>
 6b2:	f9d9079b          	addiw	a5,s2,-99
 6b6:	0ff7f793          	zext.b	a5,a5
 6ba:	10fc6e63          	bltu	s8,a5,7d6 <vprintf+0x19e>
 6be:	f9d9079b          	addiw	a5,s2,-99
 6c2:	0ff7f713          	zext.b	a4,a5
 6c6:	10ec6863          	bltu	s8,a4,7d6 <vprintf+0x19e>
 6ca:	00271793          	slli	a5,a4,0x2
 6ce:	97e6                	add	a5,a5,s9
 6d0:	439c                	lw	a5,0(a5)
 6d2:	97e6                	add	a5,a5,s9
 6d4:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 6d6:	008b0913          	addi	s2,s6,8
 6da:	4685                	li	a3,1
 6dc:	4629                	li	a2,10
 6de:	000b2583          	lw	a1,0(s6)
 6e2:	8556                	mv	a0,s5
 6e4:	00000097          	auipc	ra,0x0
 6e8:	ea8080e7          	jalr	-344(ra) # 58c <printint>
 6ec:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6ee:	4981                	li	s3,0
 6f0:	b765                	j	698 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f2:	008b0913          	addi	s2,s6,8
 6f6:	4681                	li	a3,0
 6f8:	4629                	li	a2,10
 6fa:	000b2583          	lw	a1,0(s6)
 6fe:	8556                	mv	a0,s5
 700:	00000097          	auipc	ra,0x0
 704:	e8c080e7          	jalr	-372(ra) # 58c <printint>
 708:	8b4a                	mv	s6,s2
      state = 0;
 70a:	4981                	li	s3,0
 70c:	b771                	j	698 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 70e:	008b0913          	addi	s2,s6,8
 712:	4681                	li	a3,0
 714:	866a                	mv	a2,s10
 716:	000b2583          	lw	a1,0(s6)
 71a:	8556                	mv	a0,s5
 71c:	00000097          	auipc	ra,0x0
 720:	e70080e7          	jalr	-400(ra) # 58c <printint>
 724:	8b4a                	mv	s6,s2
      state = 0;
 726:	4981                	li	s3,0
 728:	bf85                	j	698 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 72a:	008b0793          	addi	a5,s6,8
 72e:	f8f43423          	sd	a5,-120(s0)
 732:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 736:	03000593          	li	a1,48
 73a:	8556                	mv	a0,s5
 73c:	00000097          	auipc	ra,0x0
 740:	e2e080e7          	jalr	-466(ra) # 56a <putc>
  putc(fd, 'x');
 744:	07800593          	li	a1,120
 748:	8556                	mv	a0,s5
 74a:	00000097          	auipc	ra,0x0
 74e:	e20080e7          	jalr	-480(ra) # 56a <putc>
 752:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 754:	03c9d793          	srli	a5,s3,0x3c
 758:	97de                	add	a5,a5,s7
 75a:	0007c583          	lbu	a1,0(a5)
 75e:	8556                	mv	a0,s5
 760:	00000097          	auipc	ra,0x0
 764:	e0a080e7          	jalr	-502(ra) # 56a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 768:	0992                	slli	s3,s3,0x4
 76a:	397d                	addiw	s2,s2,-1
 76c:	fe0914e3          	bnez	s2,754 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 770:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 774:	4981                	li	s3,0
 776:	b70d                	j	698 <vprintf+0x60>
        s = va_arg(ap, char *);
 778:	008b0913          	addi	s2,s6,8
 77c:	000b3983          	ld	s3,0(s6)
        if (s == 0) s = "(null)";
 780:	02098163          	beqz	s3,7a2 <vprintf+0x16a>
        while (*s != 0) {
 784:	0009c583          	lbu	a1,0(s3)
 788:	c5ad                	beqz	a1,7f2 <vprintf+0x1ba>
          putc(fd, *s);
 78a:	8556                	mv	a0,s5
 78c:	00000097          	auipc	ra,0x0
 790:	dde080e7          	jalr	-546(ra) # 56a <putc>
          s++;
 794:	0985                	addi	s3,s3,1
        while (*s != 0) {
 796:	0009c583          	lbu	a1,0(s3)
 79a:	f9e5                	bnez	a1,78a <vprintf+0x152>
        s = va_arg(ap, char *);
 79c:	8b4a                	mv	s6,s2
      state = 0;
 79e:	4981                	li	s3,0
 7a0:	bde5                	j	698 <vprintf+0x60>
        if (s == 0) s = "(null)";
 7a2:	00000997          	auipc	s3,0x0
 7a6:	3be98993          	addi	s3,s3,958 # b60 <loop+0x90>
        while (*s != 0) {
 7aa:	85ee                	mv	a1,s11
 7ac:	bff9                	j	78a <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 7ae:	008b0913          	addi	s2,s6,8
 7b2:	000b4583          	lbu	a1,0(s6)
 7b6:	8556                	mv	a0,s5
 7b8:	00000097          	auipc	ra,0x0
 7bc:	db2080e7          	jalr	-590(ra) # 56a <putc>
 7c0:	8b4a                	mv	s6,s2
      state = 0;
 7c2:	4981                	li	s3,0
 7c4:	bdd1                	j	698 <vprintf+0x60>
        putc(fd, c);
 7c6:	85d2                	mv	a1,s4
 7c8:	8556                	mv	a0,s5
 7ca:	00000097          	auipc	ra,0x0
 7ce:	da0080e7          	jalr	-608(ra) # 56a <putc>
      state = 0;
 7d2:	4981                	li	s3,0
 7d4:	b5d1                	j	698 <vprintf+0x60>
        putc(fd, '%');
 7d6:	85d2                	mv	a1,s4
 7d8:	8556                	mv	a0,s5
 7da:	00000097          	auipc	ra,0x0
 7de:	d90080e7          	jalr	-624(ra) # 56a <putc>
        putc(fd, c);
 7e2:	85ca                	mv	a1,s2
 7e4:	8556                	mv	a0,s5
 7e6:	00000097          	auipc	ra,0x0
 7ea:	d84080e7          	jalr	-636(ra) # 56a <putc>
      state = 0;
 7ee:	4981                	li	s3,0
 7f0:	b565                	j	698 <vprintf+0x60>
        s = va_arg(ap, char *);
 7f2:	8b4a                	mv	s6,s2
      state = 0;
 7f4:	4981                	li	s3,0
 7f6:	b54d                	j	698 <vprintf+0x60>
    }
  }
}
 7f8:	70e6                	ld	ra,120(sp)
 7fa:	7446                	ld	s0,112(sp)
 7fc:	74a6                	ld	s1,104(sp)
 7fe:	7906                	ld	s2,96(sp)
 800:	69e6                	ld	s3,88(sp)
 802:	6a46                	ld	s4,80(sp)
 804:	6aa6                	ld	s5,72(sp)
 806:	6b06                	ld	s6,64(sp)
 808:	7be2                	ld	s7,56(sp)
 80a:	7c42                	ld	s8,48(sp)
 80c:	7ca2                	ld	s9,40(sp)
 80e:	7d02                	ld	s10,32(sp)
 810:	6de2                	ld	s11,24(sp)
 812:	6109                	addi	sp,sp,128
 814:	8082                	ret

0000000000000816 <fprintf>:

void fprintf(int fd, const char *fmt, ...) {
 816:	715d                	addi	sp,sp,-80
 818:	ec06                	sd	ra,24(sp)
 81a:	e822                	sd	s0,16(sp)
 81c:	1000                	addi	s0,sp,32
 81e:	e010                	sd	a2,0(s0)
 820:	e414                	sd	a3,8(s0)
 822:	e818                	sd	a4,16(s0)
 824:	ec1c                	sd	a5,24(s0)
 826:	03043023          	sd	a6,32(s0)
 82a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 82e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 832:	8622                	mv	a2,s0
 834:	00000097          	auipc	ra,0x0
 838:	e04080e7          	jalr	-508(ra) # 638 <vprintf>
}
 83c:	60e2                	ld	ra,24(sp)
 83e:	6442                	ld	s0,16(sp)
 840:	6161                	addi	sp,sp,80
 842:	8082                	ret

0000000000000844 <printf>:

void printf(const char *fmt, ...) {
 844:	711d                	addi	sp,sp,-96
 846:	ec06                	sd	ra,24(sp)
 848:	e822                	sd	s0,16(sp)
 84a:	1000                	addi	s0,sp,32
 84c:	e40c                	sd	a1,8(s0)
 84e:	e810                	sd	a2,16(s0)
 850:	ec14                	sd	a3,24(s0)
 852:	f018                	sd	a4,32(s0)
 854:	f41c                	sd	a5,40(s0)
 856:	03043823          	sd	a6,48(s0)
 85a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 85e:	00840613          	addi	a2,s0,8
 862:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 866:	85aa                	mv	a1,a0
 868:	4505                	li	a0,1
 86a:	00000097          	auipc	ra,0x0
 86e:	dce080e7          	jalr	-562(ra) # 638 <vprintf>
}
 872:	60e2                	ld	ra,24(sp)
 874:	6442                	ld	s0,16(sp)
 876:	6125                	addi	sp,sp,96
 878:	8082                	ret

000000000000087a <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
 87a:	1141                	addi	sp,sp,-16
 87c:	e422                	sd	s0,8(sp)
 87e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 880:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 884:	00000797          	auipc	a5,0x0
 888:	77c7b783          	ld	a5,1916(a5) # 1000 <freep>
 88c:	a02d                	j	8b6 <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 88e:	4618                	lw	a4,8(a2)
 890:	9f2d                	addw	a4,a4,a1
 892:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 896:	6398                	ld	a4,0(a5)
 898:	6310                	ld	a2,0(a4)
 89a:	a83d                	j	8d8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 89c:	ff852703          	lw	a4,-8(a0)
 8a0:	9f31                	addw	a4,a4,a2
 8a2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8a4:	ff053683          	ld	a3,-16(a0)
 8a8:	a091                	j	8ec <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 8aa:	6398                	ld	a4,0(a5)
 8ac:	00e7e463          	bltu	a5,a4,8b4 <free+0x3a>
 8b0:	00e6ea63          	bltu	a3,a4,8c4 <free+0x4a>
void free(void *ap) {
 8b4:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b6:	fed7fae3          	bgeu	a5,a3,8aa <free+0x30>
 8ba:	6398                	ld	a4,0(a5)
 8bc:	00e6e463          	bltu	a3,a4,8c4 <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 8c0:	fee7eae3          	bltu	a5,a4,8b4 <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 8c4:	ff852583          	lw	a1,-8(a0)
 8c8:	6390                	ld	a2,0(a5)
 8ca:	02059813          	slli	a6,a1,0x20
 8ce:	01c85713          	srli	a4,a6,0x1c
 8d2:	9736                	add	a4,a4,a3
 8d4:	fae60de3          	beq	a2,a4,88e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8d8:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 8dc:	4790                	lw	a2,8(a5)
 8de:	02061593          	slli	a1,a2,0x20
 8e2:	01c5d713          	srli	a4,a1,0x1c
 8e6:	973e                	add	a4,a4,a5
 8e8:	fae68ae3          	beq	a3,a4,89c <free+0x22>
    p->s.ptr = bp->s.ptr;
 8ec:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8ee:	00000717          	auipc	a4,0x0
 8f2:	70f73923          	sd	a5,1810(a4) # 1000 <freep>
}
 8f6:	6422                	ld	s0,8(sp)
 8f8:	0141                	addi	sp,sp,16
 8fa:	8082                	ret

00000000000008fc <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
 8fc:	7139                	addi	sp,sp,-64
 8fe:	fc06                	sd	ra,56(sp)
 900:	f822                	sd	s0,48(sp)
 902:	f426                	sd	s1,40(sp)
 904:	f04a                	sd	s2,32(sp)
 906:	ec4e                	sd	s3,24(sp)
 908:	e852                	sd	s4,16(sp)
 90a:	e456                	sd	s5,8(sp)
 90c:	e05a                	sd	s6,0(sp)
 90e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 910:	02051493          	slli	s1,a0,0x20
 914:	9081                	srli	s1,s1,0x20
 916:	04bd                	addi	s1,s1,15
 918:	8091                	srli	s1,s1,0x4
 91a:	0014899b          	addiw	s3,s1,1
 91e:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 920:	00000517          	auipc	a0,0x0
 924:	6e053503          	ld	a0,1760(a0) # 1000 <freep>
 928:	c515                	beqz	a0,954 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 92a:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 92c:	4798                	lw	a4,8(a5)
 92e:	02977f63          	bgeu	a4,s1,96c <malloc+0x70>
 932:	8a4e                	mv	s4,s3
 934:	0009871b          	sext.w	a4,s3
 938:	6685                	lui	a3,0x1
 93a:	00d77363          	bgeu	a4,a3,940 <malloc+0x44>
 93e:	6a05                	lui	s4,0x1
 940:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 944:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 948:	00000917          	auipc	s2,0x0
 94c:	6b890913          	addi	s2,s2,1720 # 1000 <freep>
  if (p == (char *)-1) return 0;
 950:	5afd                	li	s5,-1
 952:	a895                	j	9c6 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 954:	00000797          	auipc	a5,0x0
 958:	6bc78793          	addi	a5,a5,1724 # 1010 <base>
 95c:	00000717          	auipc	a4,0x0
 960:	6af73223          	sd	a5,1700(a4) # 1000 <freep>
 964:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 966:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 96a:	b7e1                	j	932 <malloc+0x36>
      if (p->s.size == nunits)
 96c:	02e48c63          	beq	s1,a4,9a4 <malloc+0xa8>
        p->s.size -= nunits;
 970:	4137073b          	subw	a4,a4,s3
 974:	c798                	sw	a4,8(a5)
        p += p->s.size;
 976:	02071693          	slli	a3,a4,0x20
 97a:	01c6d713          	srli	a4,a3,0x1c
 97e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 980:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 984:	00000717          	auipc	a4,0x0
 988:	66a73e23          	sd	a0,1660(a4) # 1000 <freep>
      return (void *)(p + 1);
 98c:	01078513          	addi	a0,a5,16
      if ((p = morecore(nunits)) == 0) return 0;
  }
}
 990:	70e2                	ld	ra,56(sp)
 992:	7442                	ld	s0,48(sp)
 994:	74a2                	ld	s1,40(sp)
 996:	7902                	ld	s2,32(sp)
 998:	69e2                	ld	s3,24(sp)
 99a:	6a42                	ld	s4,16(sp)
 99c:	6aa2                	ld	s5,8(sp)
 99e:	6b02                	ld	s6,0(sp)
 9a0:	6121                	addi	sp,sp,64
 9a2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9a4:	6398                	ld	a4,0(a5)
 9a6:	e118                	sd	a4,0(a0)
 9a8:	bff1                	j	984 <malloc+0x88>
  hp->s.size = nu;
 9aa:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 9ae:	0541                	addi	a0,a0,16
 9b0:	00000097          	auipc	ra,0x0
 9b4:	eca080e7          	jalr	-310(ra) # 87a <free>
  return freep;
 9b8:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0) return 0;
 9bc:	d971                	beqz	a0,990 <malloc+0x94>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 9be:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 9c0:	4798                	lw	a4,8(a5)
 9c2:	fa9775e3          	bgeu	a4,s1,96c <malloc+0x70>
    if (p == freep)
 9c6:	00093703          	ld	a4,0(s2)
 9ca:	853e                	mv	a0,a5
 9cc:	fef719e3          	bne	a4,a5,9be <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 9d0:	8552                	mv	a0,s4
 9d2:	00000097          	auipc	ra,0x0
 9d6:	b70080e7          	jalr	-1168(ra) # 542 <sbrk>
  if (p == (char *)-1) return 0;
 9da:	fd5518e3          	bne	a0,s5,9aa <malloc+0xae>
      if ((p = morecore(nunits)) == 0) return 0;
 9de:	4501                	li	a0,0
 9e0:	bf45                	j	990 <malloc+0x94>

00000000000009e2 <dump_test2_asm>:
#include "kernel/syscall.h"
.globl dump_test2_asm
dump_test2_asm:
  li s2, 2
 9e2:	4909                	li	s2,2
  li s3, 3
 9e4:	498d                	li	s3,3
  li s4, 4
 9e6:	4a11                	li	s4,4
  li s5, 5
 9e8:	4a95                	li	s5,5
  li s6, 6
 9ea:	4b19                	li	s6,6
  li s7, 7
 9ec:	4b9d                	li	s7,7
  li s8, 8
 9ee:	4c21                	li	s8,8
  li s9, 9
 9f0:	4ca5                	li	s9,9
  li s10, 10
 9f2:	4d29                	li	s10,10
  li s11, 11
 9f4:	4dad                	li	s11,11
#ifdef SYS_dump
  li a7, SYS_dump
 9f6:	48d9                	li	a7,22
  ecall
 9f8:	00000073          	ecall
#endif
  ret
 9fc:	8082                	ret

00000000000009fe <dump_test3_asm>:
.globl dump_test3_asm
dump_test3_asm:
  li s2, 1
 9fe:	4905                	li	s2,1
  li s3, -12
 a00:	59d1                	li	s3,-12
  li s4, 123
 a02:	07b00a13          	li	s4,123
  li s5, -1234
 a06:	b2e00a93          	li	s5,-1234
  li s6, 12345
 a0a:	6b0d                	lui	s6,0x3
 a0c:	039b0b1b          	addiw	s6,s6,57 # 3039 <base+0x2029>
  li s7, -123456
 a10:	7b89                	lui	s7,0xfffe2
 a12:	dc0b8b9b          	addiw	s7,s7,-576 # fffffffffffe1dc0 <base+0xfffffffffffe0db0>
  li s8, 1234567
 a16:	0012dc37          	lui	s8,0x12d
 a1a:	687c0c1b          	addiw	s8,s8,1671 # 12d687 <base+0x12c677>
  li s9, -12345678
 a1e:	ff43acb7          	lui	s9,0xff43a
 a22:	eb2c8c9b          	addiw	s9,s9,-334 # ffffffffff439eb2 <base+0xffffffffff438ea2>
  li s10, 123456789
 a26:	075bdd37          	lui	s10,0x75bd
 a2a:	d15d0d1b          	addiw	s10,s10,-747 # 75bcd15 <base+0x75bbd05>
  li s11, -1234567890
 a2e:	b66a0db7          	lui	s11,0xb66a0
 a32:	d2ed8d9b          	addiw	s11,s11,-722 # ffffffffb669fd2e <base+0xffffffffb669ed1e>
#ifdef SYS_dump
  li a7, SYS_dump
 a36:	48d9                	li	a7,22
  ecall
 a38:	00000073          	ecall
#endif
  ret
 a3c:	8082                	ret

0000000000000a3e <dump_test4_asm>:
.globl dump_test4_asm
dump_test4_asm:
  li s2, 2147483647
 a3e:	80000937          	lui	s2,0x80000
 a42:	397d                	addiw	s2,s2,-1 # 7fffffff <base+0x7fffefef>
  li s3, -2147483648
 a44:	800009b7          	lui	s3,0x80000
  li s4, 1337
 a48:	53900a13          	li	s4,1337
  li s5, 2020
 a4c:	7e400a93          	li	s5,2020
  li s6, 3234
 a50:	6b05                	lui	s6,0x1
 a52:	ca2b0b1b          	addiw	s6,s6,-862 # ca2 <digits+0xe2>
  li s7, 3235
 a56:	6b85                	lui	s7,0x1
 a58:	ca3b8b9b          	addiw	s7,s7,-861 # ca3 <digits+0xe3>
  li s8, 3236
 a5c:	6c05                	lui	s8,0x1
 a5e:	ca4c0c1b          	addiw	s8,s8,-860 # ca4 <digits+0xe4>
  li s9, 3237
 a62:	6c85                	lui	s9,0x1
 a64:	ca5c8c9b          	addiw	s9,s9,-859 # ca5 <digits+0xe5>
  li s10, 3238
 a68:	6d05                	lui	s10,0x1
 a6a:	ca6d0d1b          	addiw	s10,s10,-858 # ca6 <digits+0xe6>
  li s11, 3239
 a6e:	6d85                	lui	s11,0x1
 a70:	ca7d8d9b          	addiw	s11,s11,-857 # ca7 <digits+0xe7>
#ifdef SYS_dump
  li a7, SYS_dump
 a74:	48d9                	li	a7,22
  ecall
 a76:	00000073          	ecall
#endif
  ret
 a7a:	8082                	ret

0000000000000a7c <dump2_test1_asm>:
#include "kernel/syscall.h"
.globl dump2_test1_asm
dump2_test1_asm:
  li s2, 2
 a7c:	4909                	li	s2,2
  li s3, 3
 a7e:	498d                	li	s3,3
  li s4, 4
 a80:	4a11                	li	s4,4
  li s5, 5
 a82:	4a95                	li	s5,5
  li s6, 6
 a84:	4b19                	li	s6,6
  li s7, 7
 a86:	4b9d                	li	s7,7
  li s8, 8
 a88:	4c21                	li	s8,8
  li s9, 9
 a8a:	4ca5                	li	s9,9
  li s10, 10
 a8c:	4d29                	li	s10,10
  li s11, 11
 a8e:	4dad                	li	s11,11
  li a7, SYS_write
 a90:	48c1                	li	a7,16
  ecall
 a92:	00000073          	ecall
  j loop
 a96:	a82d                	j	ad0 <loop>

0000000000000a98 <dump2_test2_asm>:

.globl dump2_test2_asm
dump2_test2_asm:
  li s2, 4
 a98:	4911                	li	s2,4
  li s3, 9
 a9a:	49a5                	li	s3,9
  li s4, 16
 a9c:	4a41                	li	s4,16
  li s5, 25
 a9e:	4ae5                	li	s5,25
  li s6, 36
 aa0:	02400b13          	li	s6,36
  li s7, 49
 aa4:	03100b93          	li	s7,49
  li s8, 64
 aa8:	04000c13          	li	s8,64
  li s9, 81
 aac:	05100c93          	li	s9,81
  li s10, 100
 ab0:	06400d13          	li	s10,100
  li s11, 121
 ab4:	07900d93          	li	s11,121
  li a7, SYS_write
 ab8:	48c1                	li	a7,16
  ecall
 aba:	00000073          	ecall
  j loop
 abe:	a809                	j	ad0 <loop>

0000000000000ac0 <dump2_test3_asm>:

.globl dump2_test3_asm
dump2_test3_asm:
  li s2, 1337
 ac0:	53900913          	li	s2,1337
  mv a2, a1
 ac4:	862e                	mv	a2,a1
  li a1, 2
 ac6:	4589                	li	a1,2
#ifdef SYS_dump2
  li a7, SYS_dump2
 ac8:	48dd                	li	a7,23
  ecall
 aca:	00000073          	ecall
#endif
  ret
 ace:	8082                	ret

0000000000000ad0 <loop>:

loop:
  j loop
 ad0:	a001                	j	ad0 <loop>
  ret
 ad2:	8082                	ret
