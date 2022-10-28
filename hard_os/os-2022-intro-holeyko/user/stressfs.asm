
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int main(int argc, char *argv[]) {
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	1c00                	addi	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
  16:	00001797          	auipc	a5,0x1
  1a:	9ca78793          	addi	a5,a5,-1590 # 9e0 <loop+0x38>
  1e:	6398                	ld	a4,0(a5)
  20:	fce43823          	sd	a4,-48(s0)
  24:	0087d783          	lhu	a5,8(a5)
  28:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
  2c:	00001517          	auipc	a0,0x1
  30:	98450513          	addi	a0,a0,-1660 # 9b0 <loop+0x8>
  34:	00000097          	auipc	ra,0x0
  38:	6e8080e7          	jalr	1768(ra) # 71c <printf>
  memset(data, 'a', sizeof(data));
  3c:	20000613          	li	a2,512
  40:	06100593          	li	a1,97
  44:	dd040513          	addi	a0,s0,-560
  48:	00000097          	auipc	ra,0x0
  4c:	150080e7          	jalr	336(ra) # 198 <memset>

  for (i = 0; i < 4; i++)
  50:	4481                	li	s1,0
  52:	4911                	li	s2,4
    if (fork() > 0) break;
  54:	00000097          	auipc	ra,0x0
  58:	336080e7          	jalr	822(ra) # 38a <fork>
  5c:	00a04563          	bgtz	a0,66 <main+0x66>
  for (i = 0; i < 4; i++)
  60:	2485                	addiw	s1,s1,1
  62:	ff2499e3          	bne	s1,s2,54 <main+0x54>

  printf("write %d\n", i);
  66:	85a6                	mv	a1,s1
  68:	00001517          	auipc	a0,0x1
  6c:	96050513          	addi	a0,a0,-1696 # 9c8 <loop+0x20>
  70:	00000097          	auipc	ra,0x0
  74:	6ac080e7          	jalr	1708(ra) # 71c <printf>

  path[8] += i;
  78:	fd844783          	lbu	a5,-40(s0)
  7c:	9fa5                	addw	a5,a5,s1
  7e:	fcf40c23          	sb	a5,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
  82:	20200593          	li	a1,514
  86:	fd040513          	addi	a0,s0,-48
  8a:	00000097          	auipc	ra,0x0
  8e:	348080e7          	jalr	840(ra) # 3d2 <open>
  92:	892a                	mv	s2,a0
  94:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    //    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  96:	20000613          	li	a2,512
  9a:	dd040593          	addi	a1,s0,-560
  9e:	854a                	mv	a0,s2
  a0:	00000097          	auipc	ra,0x0
  a4:	312080e7          	jalr	786(ra) # 3b2 <write>
  for (i = 0; i < 20; i++)
  a8:	34fd                	addiw	s1,s1,-1
  aa:	f4f5                	bnez	s1,96 <main+0x96>
  close(fd);
  ac:	854a                	mv	a0,s2
  ae:	00000097          	auipc	ra,0x0
  b2:	30c080e7          	jalr	780(ra) # 3ba <close>

  printf("read\n");
  b6:	00001517          	auipc	a0,0x1
  ba:	92250513          	addi	a0,a0,-1758 # 9d8 <loop+0x30>
  be:	00000097          	auipc	ra,0x0
  c2:	65e080e7          	jalr	1630(ra) # 71c <printf>

  fd = open(path, O_RDONLY);
  c6:	4581                	li	a1,0
  c8:	fd040513          	addi	a0,s0,-48
  cc:	00000097          	auipc	ra,0x0
  d0:	306080e7          	jalr	774(ra) # 3d2 <open>
  d4:	892a                	mv	s2,a0
  d6:	44d1                	li	s1,20
  for (i = 0; i < 20; i++) read(fd, data, sizeof(data));
  d8:	20000613          	li	a2,512
  dc:	dd040593          	addi	a1,s0,-560
  e0:	854a                	mv	a0,s2
  e2:	00000097          	auipc	ra,0x0
  e6:	2c8080e7          	jalr	712(ra) # 3aa <read>
  ea:	34fd                	addiw	s1,s1,-1
  ec:	f4f5                	bnez	s1,d8 <main+0xd8>
  close(fd);
  ee:	854a                	mv	a0,s2
  f0:	00000097          	auipc	ra,0x0
  f4:	2ca080e7          	jalr	714(ra) # 3ba <close>

  wait(0);
  f8:	4501                	li	a0,0
  fa:	00000097          	auipc	ra,0x0
  fe:	2a0080e7          	jalr	672(ra) # 39a <wait>

  exit(0);
 102:	4501                	li	a0,0
 104:	00000097          	auipc	ra,0x0
 108:	28e080e7          	jalr	654(ra) # 392 <exit>

000000000000010c <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
 10c:	1141                	addi	sp,sp,-16
 10e:	e406                	sd	ra,8(sp)
 110:	e022                	sd	s0,0(sp)
 112:	0800                	addi	s0,sp,16
  extern int main();
  main();
 114:	00000097          	auipc	ra,0x0
 118:	eec080e7          	jalr	-276(ra) # 0 <main>
  exit(0);
 11c:	4501                	li	a0,0
 11e:	00000097          	auipc	ra,0x0
 122:	274080e7          	jalr	628(ra) # 392 <exit>

0000000000000126 <strcpy>:
}

char *strcpy(char *s, const char *t) {
 126:	1141                	addi	sp,sp,-16
 128:	e422                	sd	s0,8(sp)
 12a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 12c:	87aa                	mv	a5,a0
 12e:	0585                	addi	a1,a1,1
 130:	0785                	addi	a5,a5,1
 132:	fff5c703          	lbu	a4,-1(a1)
 136:	fee78fa3          	sb	a4,-1(a5)
 13a:	fb75                	bnez	a4,12e <strcpy+0x8>
    ;
  return os;
}
 13c:	6422                	ld	s0,8(sp)
 13e:	0141                	addi	sp,sp,16
 140:	8082                	ret

0000000000000142 <strcmp>:

int strcmp(const char *p, const char *q) {
 142:	1141                	addi	sp,sp,-16
 144:	e422                	sd	s0,8(sp)
 146:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
 148:	00054783          	lbu	a5,0(a0)
 14c:	cb91                	beqz	a5,160 <strcmp+0x1e>
 14e:	0005c703          	lbu	a4,0(a1)
 152:	00f71763          	bne	a4,a5,160 <strcmp+0x1e>
 156:	0505                	addi	a0,a0,1
 158:	0585                	addi	a1,a1,1
 15a:	00054783          	lbu	a5,0(a0)
 15e:	fbe5                	bnez	a5,14e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 160:	0005c503          	lbu	a0,0(a1)
}
 164:	40a7853b          	subw	a0,a5,a0
 168:	6422                	ld	s0,8(sp)
 16a:	0141                	addi	sp,sp,16
 16c:	8082                	ret

000000000000016e <strlen>:

uint strlen(const char *s) {
 16e:	1141                	addi	sp,sp,-16
 170:	e422                	sd	s0,8(sp)
 172:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 174:	00054783          	lbu	a5,0(a0)
 178:	cf91                	beqz	a5,194 <strlen+0x26>
 17a:	0505                	addi	a0,a0,1
 17c:	87aa                	mv	a5,a0
 17e:	4685                	li	a3,1
 180:	9e89                	subw	a3,a3,a0
 182:	00f6853b          	addw	a0,a3,a5
 186:	0785                	addi	a5,a5,1
 188:	fff7c703          	lbu	a4,-1(a5)
 18c:	fb7d                	bnez	a4,182 <strlen+0x14>
    ;
  return n;
}
 18e:	6422                	ld	s0,8(sp)
 190:	0141                	addi	sp,sp,16
 192:	8082                	ret
  for (n = 0; s[n]; n++)
 194:	4501                	li	a0,0
 196:	bfe5                	j	18e <strlen+0x20>

0000000000000198 <memset>:

void *memset(void *dst, int c, uint n) {
 198:	1141                	addi	sp,sp,-16
 19a:	e422                	sd	s0,8(sp)
 19c:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 19e:	ca19                	beqz	a2,1b4 <memset+0x1c>
 1a0:	87aa                	mv	a5,a0
 1a2:	1602                	slli	a2,a2,0x20
 1a4:	9201                	srli	a2,a2,0x20
 1a6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1aa:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 1ae:	0785                	addi	a5,a5,1
 1b0:	fee79de3          	bne	a5,a4,1aa <memset+0x12>
  }
  return dst;
}
 1b4:	6422                	ld	s0,8(sp)
 1b6:	0141                	addi	sp,sp,16
 1b8:	8082                	ret

00000000000001ba <strchr>:

char *strchr(const char *s, char c) {
 1ba:	1141                	addi	sp,sp,-16
 1bc:	e422                	sd	s0,8(sp)
 1be:	0800                	addi	s0,sp,16
  for (; *s; s++)
 1c0:	00054783          	lbu	a5,0(a0)
 1c4:	cb99                	beqz	a5,1da <strchr+0x20>
    if (*s == c) return (char *)s;
 1c6:	00f58763          	beq	a1,a5,1d4 <strchr+0x1a>
  for (; *s; s++)
 1ca:	0505                	addi	a0,a0,1
 1cc:	00054783          	lbu	a5,0(a0)
 1d0:	fbfd                	bnez	a5,1c6 <strchr+0xc>
  return 0;
 1d2:	4501                	li	a0,0
}
 1d4:	6422                	ld	s0,8(sp)
 1d6:	0141                	addi	sp,sp,16
 1d8:	8082                	ret
  return 0;
 1da:	4501                	li	a0,0
 1dc:	bfe5                	j	1d4 <strchr+0x1a>

00000000000001de <gets>:

char *gets(char *buf, int max) {
 1de:	711d                	addi	sp,sp,-96
 1e0:	ec86                	sd	ra,88(sp)
 1e2:	e8a2                	sd	s0,80(sp)
 1e4:	e4a6                	sd	s1,72(sp)
 1e6:	e0ca                	sd	s2,64(sp)
 1e8:	fc4e                	sd	s3,56(sp)
 1ea:	f852                	sd	s4,48(sp)
 1ec:	f456                	sd	s5,40(sp)
 1ee:	f05a                	sd	s6,32(sp)
 1f0:	ec5e                	sd	s7,24(sp)
 1f2:	1080                	addi	s0,sp,96
 1f4:	8baa                	mv	s7,a0
 1f6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1f8:	892a                	mv	s2,a0
 1fa:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
 1fc:	4aa9                	li	s5,10
 1fe:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 200:	89a6                	mv	s3,s1
 202:	2485                	addiw	s1,s1,1
 204:	0344d863          	bge	s1,s4,234 <gets+0x56>
    cc = read(0, &c, 1);
 208:	4605                	li	a2,1
 20a:	faf40593          	addi	a1,s0,-81
 20e:	4501                	li	a0,0
 210:	00000097          	auipc	ra,0x0
 214:	19a080e7          	jalr	410(ra) # 3aa <read>
    if (cc < 1) break;
 218:	00a05e63          	blez	a0,234 <gets+0x56>
    buf[i++] = c;
 21c:	faf44783          	lbu	a5,-81(s0)
 220:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r') break;
 224:	01578763          	beq	a5,s5,232 <gets+0x54>
 228:	0905                	addi	s2,s2,1
 22a:	fd679be3          	bne	a5,s6,200 <gets+0x22>
  for (i = 0; i + 1 < max;) {
 22e:	89a6                	mv	s3,s1
 230:	a011                	j	234 <gets+0x56>
 232:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
 234:	99de                	add	s3,s3,s7
 236:	00098023          	sb	zero,0(s3)
  return buf;
}
 23a:	855e                	mv	a0,s7
 23c:	60e6                	ld	ra,88(sp)
 23e:	6446                	ld	s0,80(sp)
 240:	64a6                	ld	s1,72(sp)
 242:	6906                	ld	s2,64(sp)
 244:	79e2                	ld	s3,56(sp)
 246:	7a42                	ld	s4,48(sp)
 248:	7aa2                	ld	s5,40(sp)
 24a:	7b02                	ld	s6,32(sp)
 24c:	6be2                	ld	s7,24(sp)
 24e:	6125                	addi	sp,sp,96
 250:	8082                	ret

0000000000000252 <stat>:

int stat(const char *n, struct stat *st) {
 252:	1101                	addi	sp,sp,-32
 254:	ec06                	sd	ra,24(sp)
 256:	e822                	sd	s0,16(sp)
 258:	e426                	sd	s1,8(sp)
 25a:	e04a                	sd	s2,0(sp)
 25c:	1000                	addi	s0,sp,32
 25e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 260:	4581                	li	a1,0
 262:	00000097          	auipc	ra,0x0
 266:	170080e7          	jalr	368(ra) # 3d2 <open>
  if (fd < 0) return -1;
 26a:	02054563          	bltz	a0,294 <stat+0x42>
 26e:	84aa                	mv	s1,a0
  r = fstat(fd, st);
 270:	85ca                	mv	a1,s2
 272:	00000097          	auipc	ra,0x0
 276:	178080e7          	jalr	376(ra) # 3ea <fstat>
 27a:	892a                	mv	s2,a0
  close(fd);
 27c:	8526                	mv	a0,s1
 27e:	00000097          	auipc	ra,0x0
 282:	13c080e7          	jalr	316(ra) # 3ba <close>
  return r;
}
 286:	854a                	mv	a0,s2
 288:	60e2                	ld	ra,24(sp)
 28a:	6442                	ld	s0,16(sp)
 28c:	64a2                	ld	s1,8(sp)
 28e:	6902                	ld	s2,0(sp)
 290:	6105                	addi	sp,sp,32
 292:	8082                	ret
  if (fd < 0) return -1;
 294:	597d                	li	s2,-1
 296:	bfc5                	j	286 <stat+0x34>

0000000000000298 <atoi>:

int atoi(const char *s) {
 298:	1141                	addi	sp,sp,-16
 29a:	e422                	sd	s0,8(sp)
 29c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 29e:	00054683          	lbu	a3,0(a0)
 2a2:	fd06879b          	addiw	a5,a3,-48
 2a6:	0ff7f793          	zext.b	a5,a5
 2aa:	4625                	li	a2,9
 2ac:	02f66863          	bltu	a2,a5,2dc <atoi+0x44>
 2b0:	872a                	mv	a4,a0
  n = 0;
 2b2:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 2b4:	0705                	addi	a4,a4,1
 2b6:	0025179b          	slliw	a5,a0,0x2
 2ba:	9fa9                	addw	a5,a5,a0
 2bc:	0017979b          	slliw	a5,a5,0x1
 2c0:	9fb5                	addw	a5,a5,a3
 2c2:	fd07851b          	addiw	a0,a5,-48
 2c6:	00074683          	lbu	a3,0(a4)
 2ca:	fd06879b          	addiw	a5,a3,-48
 2ce:	0ff7f793          	zext.b	a5,a5
 2d2:	fef671e3          	bgeu	a2,a5,2b4 <atoi+0x1c>
  return n;
}
 2d6:	6422                	ld	s0,8(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret
  n = 0;
 2dc:	4501                	li	a0,0
 2de:	bfe5                	j	2d6 <atoi+0x3e>

00000000000002e0 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
 2e0:	1141                	addi	sp,sp,-16
 2e2:	e422                	sd	s0,8(sp)
 2e4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2e6:	02b57463          	bgeu	a0,a1,30e <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
 2ea:	00c05f63          	blez	a2,308 <memmove+0x28>
 2ee:	1602                	slli	a2,a2,0x20
 2f0:	9201                	srli	a2,a2,0x20
 2f2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2f6:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
 2f8:	0585                	addi	a1,a1,1
 2fa:	0705                	addi	a4,a4,1
 2fc:	fff5c683          	lbu	a3,-1(a1)
 300:	fed70fa3          	sb	a3,-1(a4)
 304:	fee79ae3          	bne	a5,a4,2f8 <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
 308:	6422                	ld	s0,8(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret
    dst += n;
 30e:	00c50733          	add	a4,a0,a2
    src += n;
 312:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
 314:	fec05ae3          	blez	a2,308 <memmove+0x28>
 318:	fff6079b          	addiw	a5,a2,-1
 31c:	1782                	slli	a5,a5,0x20
 31e:	9381                	srli	a5,a5,0x20
 320:	fff7c793          	not	a5,a5
 324:	97ba                	add	a5,a5,a4
 326:	15fd                	addi	a1,a1,-1
 328:	177d                	addi	a4,a4,-1
 32a:	0005c683          	lbu	a3,0(a1)
 32e:	00d70023          	sb	a3,0(a4)
 332:	fee79ae3          	bne	a5,a4,326 <memmove+0x46>
 336:	bfc9                	j	308 <memmove+0x28>

0000000000000338 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
 338:	1141                	addi	sp,sp,-16
 33a:	e422                	sd	s0,8(sp)
 33c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 33e:	ca05                	beqz	a2,36e <memcmp+0x36>
 340:	fff6069b          	addiw	a3,a2,-1
 344:	1682                	slli	a3,a3,0x20
 346:	9281                	srli	a3,a3,0x20
 348:	0685                	addi	a3,a3,1
 34a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 34c:	00054783          	lbu	a5,0(a0)
 350:	0005c703          	lbu	a4,0(a1)
 354:	00e79863          	bne	a5,a4,364 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 358:	0505                	addi	a0,a0,1
    p2++;
 35a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 35c:	fed518e3          	bne	a0,a3,34c <memcmp+0x14>
  }
  return 0;
 360:	4501                	li	a0,0
 362:	a019                	j	368 <memcmp+0x30>
      return *p1 - *p2;
 364:	40e7853b          	subw	a0,a5,a4
}
 368:	6422                	ld	s0,8(sp)
 36a:	0141                	addi	sp,sp,16
 36c:	8082                	ret
  return 0;
 36e:	4501                	li	a0,0
 370:	bfe5                	j	368 <memcmp+0x30>

0000000000000372 <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
 372:	1141                	addi	sp,sp,-16
 374:	e406                	sd	ra,8(sp)
 376:	e022                	sd	s0,0(sp)
 378:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 37a:	00000097          	auipc	ra,0x0
 37e:	f66080e7          	jalr	-154(ra) # 2e0 <memmove>
}
 382:	60a2                	ld	ra,8(sp)
 384:	6402                	ld	s0,0(sp)
 386:	0141                	addi	sp,sp,16
 388:	8082                	ret

000000000000038a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 38a:	4885                	li	a7,1
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <exit>:
.global exit
exit:
 li a7, SYS_exit
 392:	4889                	li	a7,2
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <wait>:
.global wait
wait:
 li a7, SYS_wait
 39a:	488d                	li	a7,3
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3a2:	4891                	li	a7,4
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <read>:
.global read
read:
 li a7, SYS_read
 3aa:	4895                	li	a7,5
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <write>:
.global write
write:
 li a7, SYS_write
 3b2:	48c1                	li	a7,16
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <close>:
.global close
close:
 li a7, SYS_close
 3ba:	48d5                	li	a7,21
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3c2:	4899                	li	a7,6
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <exec>:
.global exec
exec:
 li a7, SYS_exec
 3ca:	489d                	li	a7,7
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <open>:
.global open
open:
 li a7, SYS_open
 3d2:	48bd                	li	a7,15
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3da:	48c5                	li	a7,17
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3e2:	48c9                	li	a7,18
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3ea:	48a1                	li	a7,8
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <link>:
.global link
link:
 li a7, SYS_link
 3f2:	48cd                	li	a7,19
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3fa:	48d1                	li	a7,20
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 402:	48a5                	li	a7,9
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <dup>:
.global dup
dup:
 li a7, SYS_dup
 40a:	48a9                	li	a7,10
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 412:	48ad                	li	a7,11
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 41a:	48b1                	li	a7,12
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 422:	48b5                	li	a7,13
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 42a:	48b9                	li	a7,14
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <dump>:
.global dump
dump:
 li a7, SYS_dump
 432:	48d9                	li	a7,22
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <dump2>:
.global dump2
dump2:
 li a7, SYS_dump2
 43a:	48dd                	li	a7,23
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <putc>:

#include <stdarg.h>

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 442:	1101                	addi	sp,sp,-32
 444:	ec06                	sd	ra,24(sp)
 446:	e822                	sd	s0,16(sp)
 448:	1000                	addi	s0,sp,32
 44a:	feb407a3          	sb	a1,-17(s0)
 44e:	4605                	li	a2,1
 450:	fef40593          	addi	a1,s0,-17
 454:	00000097          	auipc	ra,0x0
 458:	f5e080e7          	jalr	-162(ra) # 3b2 <write>
 45c:	60e2                	ld	ra,24(sp)
 45e:	6442                	ld	s0,16(sp)
 460:	6105                	addi	sp,sp,32
 462:	8082                	ret

0000000000000464 <printint>:

static void printint(int fd, int xx, int base, int sgn) {
 464:	7139                	addi	sp,sp,-64
 466:	fc06                	sd	ra,56(sp)
 468:	f822                	sd	s0,48(sp)
 46a:	f426                	sd	s1,40(sp)
 46c:	f04a                	sd	s2,32(sp)
 46e:	ec4e                	sd	s3,24(sp)
 470:	0080                	addi	s0,sp,64
 472:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0) {
 474:	c299                	beqz	a3,47a <printint+0x16>
 476:	0805c963          	bltz	a1,508 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 47a:	2581                	sext.w	a1,a1
  neg = 0;
 47c:	4881                	li	a7,0
 47e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 482:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 484:	2601                	sext.w	a2,a2
 486:	00000517          	auipc	a0,0x0
 48a:	5ca50513          	addi	a0,a0,1482 # a50 <digits>
 48e:	883a                	mv	a6,a4
 490:	2705                	addiw	a4,a4,1
 492:	02c5f7bb          	remuw	a5,a1,a2
 496:	1782                	slli	a5,a5,0x20
 498:	9381                	srli	a5,a5,0x20
 49a:	97aa                	add	a5,a5,a0
 49c:	0007c783          	lbu	a5,0(a5)
 4a0:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 4a4:	0005879b          	sext.w	a5,a1
 4a8:	02c5d5bb          	divuw	a1,a1,a2
 4ac:	0685                	addi	a3,a3,1
 4ae:	fec7f0e3          	bgeu	a5,a2,48e <printint+0x2a>
  if (neg) buf[i++] = '-';
 4b2:	00088c63          	beqz	a7,4ca <printint+0x66>
 4b6:	fd070793          	addi	a5,a4,-48
 4ba:	00878733          	add	a4,a5,s0
 4be:	02d00793          	li	a5,45
 4c2:	fef70823          	sb	a5,-16(a4)
 4c6:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) putc(fd, buf[i]);
 4ca:	02e05863          	blez	a4,4fa <printint+0x96>
 4ce:	fc040793          	addi	a5,s0,-64
 4d2:	00e78933          	add	s2,a5,a4
 4d6:	fff78993          	addi	s3,a5,-1
 4da:	99ba                	add	s3,s3,a4
 4dc:	377d                	addiw	a4,a4,-1
 4de:	1702                	slli	a4,a4,0x20
 4e0:	9301                	srli	a4,a4,0x20
 4e2:	40e989b3          	sub	s3,s3,a4
 4e6:	fff94583          	lbu	a1,-1(s2)
 4ea:	8526                	mv	a0,s1
 4ec:	00000097          	auipc	ra,0x0
 4f0:	f56080e7          	jalr	-170(ra) # 442 <putc>
 4f4:	197d                	addi	s2,s2,-1
 4f6:	ff3918e3          	bne	s2,s3,4e6 <printint+0x82>
}
 4fa:	70e2                	ld	ra,56(sp)
 4fc:	7442                	ld	s0,48(sp)
 4fe:	74a2                	ld	s1,40(sp)
 500:	7902                	ld	s2,32(sp)
 502:	69e2                	ld	s3,24(sp)
 504:	6121                	addi	sp,sp,64
 506:	8082                	ret
    x = -xx;
 508:	40b005bb          	negw	a1,a1
    neg = 1;
 50c:	4885                	li	a7,1
    x = -xx;
 50e:	bf85                	j	47e <printint+0x1a>

0000000000000510 <vprintf>:
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap) {
 510:	7119                	addi	sp,sp,-128
 512:	fc86                	sd	ra,120(sp)
 514:	f8a2                	sd	s0,112(sp)
 516:	f4a6                	sd	s1,104(sp)
 518:	f0ca                	sd	s2,96(sp)
 51a:	ecce                	sd	s3,88(sp)
 51c:	e8d2                	sd	s4,80(sp)
 51e:	e4d6                	sd	s5,72(sp)
 520:	e0da                	sd	s6,64(sp)
 522:	fc5e                	sd	s7,56(sp)
 524:	f862                	sd	s8,48(sp)
 526:	f466                	sd	s9,40(sp)
 528:	f06a                	sd	s10,32(sp)
 52a:	ec6e                	sd	s11,24(sp)
 52c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 52e:	0005c903          	lbu	s2,0(a1)
 532:	18090f63          	beqz	s2,6d0 <vprintf+0x1c0>
 536:	8aaa                	mv	s5,a0
 538:	8b32                	mv	s6,a2
 53a:	00158493          	addi	s1,a1,1
  state = 0;
 53e:	4981                	li	s3,0
      if (c == '%') {
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if (state == '%') {
 540:	02500a13          	li	s4,37
 544:	4c55                	li	s8,21
 546:	00000c97          	auipc	s9,0x0
 54a:	4b2c8c93          	addi	s9,s9,1202 # 9f8 <loop+0x50>
      } else if (c == 'p') {
        printptr(fd, va_arg(ap, uint64));
      } else if (c == 's') {
        s = va_arg(ap, char *);
        if (s == 0) s = "(null)";
        while (*s != 0) {
 54e:	02800d93          	li	s11,40
  putc(fd, 'x');
 552:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 554:	00000b97          	auipc	s7,0x0
 558:	4fcb8b93          	addi	s7,s7,1276 # a50 <digits>
 55c:	a839                	j	57a <vprintf+0x6a>
        putc(fd, c);
 55e:	85ca                	mv	a1,s2
 560:	8556                	mv	a0,s5
 562:	00000097          	auipc	ra,0x0
 566:	ee0080e7          	jalr	-288(ra) # 442 <putc>
 56a:	a019                	j	570 <vprintf+0x60>
    } else if (state == '%') {
 56c:	01498d63          	beq	s3,s4,586 <vprintf+0x76>
  for (i = 0; fmt[i]; i++) {
 570:	0485                	addi	s1,s1,1
 572:	fff4c903          	lbu	s2,-1(s1)
 576:	14090d63          	beqz	s2,6d0 <vprintf+0x1c0>
    if (state == 0) {
 57a:	fe0999e3          	bnez	s3,56c <vprintf+0x5c>
      if (c == '%') {
 57e:	ff4910e3          	bne	s2,s4,55e <vprintf+0x4e>
        state = '%';
 582:	89d2                	mv	s3,s4
 584:	b7f5                	j	570 <vprintf+0x60>
      if (c == 'd') {
 586:	11490c63          	beq	s2,s4,69e <vprintf+0x18e>
 58a:	f9d9079b          	addiw	a5,s2,-99
 58e:	0ff7f793          	zext.b	a5,a5
 592:	10fc6e63          	bltu	s8,a5,6ae <vprintf+0x19e>
 596:	f9d9079b          	addiw	a5,s2,-99
 59a:	0ff7f713          	zext.b	a4,a5
 59e:	10ec6863          	bltu	s8,a4,6ae <vprintf+0x19e>
 5a2:	00271793          	slli	a5,a4,0x2
 5a6:	97e6                	add	a5,a5,s9
 5a8:	439c                	lw	a5,0(a5)
 5aa:	97e6                	add	a5,a5,s9
 5ac:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5ae:	008b0913          	addi	s2,s6,8
 5b2:	4685                	li	a3,1
 5b4:	4629                	li	a2,10
 5b6:	000b2583          	lw	a1,0(s6)
 5ba:	8556                	mv	a0,s5
 5bc:	00000097          	auipc	ra,0x0
 5c0:	ea8080e7          	jalr	-344(ra) # 464 <printint>
 5c4:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5c6:	4981                	li	s3,0
 5c8:	b765                	j	570 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ca:	008b0913          	addi	s2,s6,8
 5ce:	4681                	li	a3,0
 5d0:	4629                	li	a2,10
 5d2:	000b2583          	lw	a1,0(s6)
 5d6:	8556                	mv	a0,s5
 5d8:	00000097          	auipc	ra,0x0
 5dc:	e8c080e7          	jalr	-372(ra) # 464 <printint>
 5e0:	8b4a                	mv	s6,s2
      state = 0;
 5e2:	4981                	li	s3,0
 5e4:	b771                	j	570 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5e6:	008b0913          	addi	s2,s6,8
 5ea:	4681                	li	a3,0
 5ec:	866a                	mv	a2,s10
 5ee:	000b2583          	lw	a1,0(s6)
 5f2:	8556                	mv	a0,s5
 5f4:	00000097          	auipc	ra,0x0
 5f8:	e70080e7          	jalr	-400(ra) # 464 <printint>
 5fc:	8b4a                	mv	s6,s2
      state = 0;
 5fe:	4981                	li	s3,0
 600:	bf85                	j	570 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 602:	008b0793          	addi	a5,s6,8
 606:	f8f43423          	sd	a5,-120(s0)
 60a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 60e:	03000593          	li	a1,48
 612:	8556                	mv	a0,s5
 614:	00000097          	auipc	ra,0x0
 618:	e2e080e7          	jalr	-466(ra) # 442 <putc>
  putc(fd, 'x');
 61c:	07800593          	li	a1,120
 620:	8556                	mv	a0,s5
 622:	00000097          	auipc	ra,0x0
 626:	e20080e7          	jalr	-480(ra) # 442 <putc>
 62a:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 62c:	03c9d793          	srli	a5,s3,0x3c
 630:	97de                	add	a5,a5,s7
 632:	0007c583          	lbu	a1,0(a5)
 636:	8556                	mv	a0,s5
 638:	00000097          	auipc	ra,0x0
 63c:	e0a080e7          	jalr	-502(ra) # 442 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 640:	0992                	slli	s3,s3,0x4
 642:	397d                	addiw	s2,s2,-1
 644:	fe0914e3          	bnez	s2,62c <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 648:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 64c:	4981                	li	s3,0
 64e:	b70d                	j	570 <vprintf+0x60>
        s = va_arg(ap, char *);
 650:	008b0913          	addi	s2,s6,8
 654:	000b3983          	ld	s3,0(s6)
        if (s == 0) s = "(null)";
 658:	02098163          	beqz	s3,67a <vprintf+0x16a>
        while (*s != 0) {
 65c:	0009c583          	lbu	a1,0(s3)
 660:	c5ad                	beqz	a1,6ca <vprintf+0x1ba>
          putc(fd, *s);
 662:	8556                	mv	a0,s5
 664:	00000097          	auipc	ra,0x0
 668:	dde080e7          	jalr	-546(ra) # 442 <putc>
          s++;
 66c:	0985                	addi	s3,s3,1
        while (*s != 0) {
 66e:	0009c583          	lbu	a1,0(s3)
 672:	f9e5                	bnez	a1,662 <vprintf+0x152>
        s = va_arg(ap, char *);
 674:	8b4a                	mv	s6,s2
      state = 0;
 676:	4981                	li	s3,0
 678:	bde5                	j	570 <vprintf+0x60>
        if (s == 0) s = "(null)";
 67a:	00000997          	auipc	s3,0x0
 67e:	37698993          	addi	s3,s3,886 # 9f0 <loop+0x48>
        while (*s != 0) {
 682:	85ee                	mv	a1,s11
 684:	bff9                	j	662 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 686:	008b0913          	addi	s2,s6,8
 68a:	000b4583          	lbu	a1,0(s6)
 68e:	8556                	mv	a0,s5
 690:	00000097          	auipc	ra,0x0
 694:	db2080e7          	jalr	-590(ra) # 442 <putc>
 698:	8b4a                	mv	s6,s2
      state = 0;
 69a:	4981                	li	s3,0
 69c:	bdd1                	j	570 <vprintf+0x60>
        putc(fd, c);
 69e:	85d2                	mv	a1,s4
 6a0:	8556                	mv	a0,s5
 6a2:	00000097          	auipc	ra,0x0
 6a6:	da0080e7          	jalr	-608(ra) # 442 <putc>
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	b5d1                	j	570 <vprintf+0x60>
        putc(fd, '%');
 6ae:	85d2                	mv	a1,s4
 6b0:	8556                	mv	a0,s5
 6b2:	00000097          	auipc	ra,0x0
 6b6:	d90080e7          	jalr	-624(ra) # 442 <putc>
        putc(fd, c);
 6ba:	85ca                	mv	a1,s2
 6bc:	8556                	mv	a0,s5
 6be:	00000097          	auipc	ra,0x0
 6c2:	d84080e7          	jalr	-636(ra) # 442 <putc>
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	b565                	j	570 <vprintf+0x60>
        s = va_arg(ap, char *);
 6ca:	8b4a                	mv	s6,s2
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	b54d                	j	570 <vprintf+0x60>
    }
  }
}
 6d0:	70e6                	ld	ra,120(sp)
 6d2:	7446                	ld	s0,112(sp)
 6d4:	74a6                	ld	s1,104(sp)
 6d6:	7906                	ld	s2,96(sp)
 6d8:	69e6                	ld	s3,88(sp)
 6da:	6a46                	ld	s4,80(sp)
 6dc:	6aa6                	ld	s5,72(sp)
 6de:	6b06                	ld	s6,64(sp)
 6e0:	7be2                	ld	s7,56(sp)
 6e2:	7c42                	ld	s8,48(sp)
 6e4:	7ca2                	ld	s9,40(sp)
 6e6:	7d02                	ld	s10,32(sp)
 6e8:	6de2                	ld	s11,24(sp)
 6ea:	6109                	addi	sp,sp,128
 6ec:	8082                	ret

00000000000006ee <fprintf>:

void fprintf(int fd, const char *fmt, ...) {
 6ee:	715d                	addi	sp,sp,-80
 6f0:	ec06                	sd	ra,24(sp)
 6f2:	e822                	sd	s0,16(sp)
 6f4:	1000                	addi	s0,sp,32
 6f6:	e010                	sd	a2,0(s0)
 6f8:	e414                	sd	a3,8(s0)
 6fa:	e818                	sd	a4,16(s0)
 6fc:	ec1c                	sd	a5,24(s0)
 6fe:	03043023          	sd	a6,32(s0)
 702:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 706:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 70a:	8622                	mv	a2,s0
 70c:	00000097          	auipc	ra,0x0
 710:	e04080e7          	jalr	-508(ra) # 510 <vprintf>
}
 714:	60e2                	ld	ra,24(sp)
 716:	6442                	ld	s0,16(sp)
 718:	6161                	addi	sp,sp,80
 71a:	8082                	ret

000000000000071c <printf>:

void printf(const char *fmt, ...) {
 71c:	711d                	addi	sp,sp,-96
 71e:	ec06                	sd	ra,24(sp)
 720:	e822                	sd	s0,16(sp)
 722:	1000                	addi	s0,sp,32
 724:	e40c                	sd	a1,8(s0)
 726:	e810                	sd	a2,16(s0)
 728:	ec14                	sd	a3,24(s0)
 72a:	f018                	sd	a4,32(s0)
 72c:	f41c                	sd	a5,40(s0)
 72e:	03043823          	sd	a6,48(s0)
 732:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 736:	00840613          	addi	a2,s0,8
 73a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 73e:	85aa                	mv	a1,a0
 740:	4505                	li	a0,1
 742:	00000097          	auipc	ra,0x0
 746:	dce080e7          	jalr	-562(ra) # 510 <vprintf>
}
 74a:	60e2                	ld	ra,24(sp)
 74c:	6442                	ld	s0,16(sp)
 74e:	6125                	addi	sp,sp,96
 750:	8082                	ret

0000000000000752 <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
 752:	1141                	addi	sp,sp,-16
 754:	e422                	sd	s0,8(sp)
 756:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 758:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75c:	00001797          	auipc	a5,0x1
 760:	8a47b783          	ld	a5,-1884(a5) # 1000 <freep>
 764:	a02d                	j	78e <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 766:	4618                	lw	a4,8(a2)
 768:	9f2d                	addw	a4,a4,a1
 76a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 76e:	6398                	ld	a4,0(a5)
 770:	6310                	ld	a2,0(a4)
 772:	a83d                	j	7b0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 774:	ff852703          	lw	a4,-8(a0)
 778:	9f31                	addw	a4,a4,a2
 77a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 77c:	ff053683          	ld	a3,-16(a0)
 780:	a091                	j	7c4 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 782:	6398                	ld	a4,0(a5)
 784:	00e7e463          	bltu	a5,a4,78c <free+0x3a>
 788:	00e6ea63          	bltu	a3,a4,79c <free+0x4a>
void free(void *ap) {
 78c:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78e:	fed7fae3          	bgeu	a5,a3,782 <free+0x30>
 792:	6398                	ld	a4,0(a5)
 794:	00e6e463          	bltu	a3,a4,79c <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 798:	fee7eae3          	bltu	a5,a4,78c <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 79c:	ff852583          	lw	a1,-8(a0)
 7a0:	6390                	ld	a2,0(a5)
 7a2:	02059813          	slli	a6,a1,0x20
 7a6:	01c85713          	srli	a4,a6,0x1c
 7aa:	9736                	add	a4,a4,a3
 7ac:	fae60de3          	beq	a2,a4,766 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7b0:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 7b4:	4790                	lw	a2,8(a5)
 7b6:	02061593          	slli	a1,a2,0x20
 7ba:	01c5d713          	srli	a4,a1,0x1c
 7be:	973e                	add	a4,a4,a5
 7c0:	fae68ae3          	beq	a3,a4,774 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7c4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7c6:	00001717          	auipc	a4,0x1
 7ca:	82f73d23          	sd	a5,-1990(a4) # 1000 <freep>
}
 7ce:	6422                	ld	s0,8(sp)
 7d0:	0141                	addi	sp,sp,16
 7d2:	8082                	ret

00000000000007d4 <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
 7d4:	7139                	addi	sp,sp,-64
 7d6:	fc06                	sd	ra,56(sp)
 7d8:	f822                	sd	s0,48(sp)
 7da:	f426                	sd	s1,40(sp)
 7dc:	f04a                	sd	s2,32(sp)
 7de:	ec4e                	sd	s3,24(sp)
 7e0:	e852                	sd	s4,16(sp)
 7e2:	e456                	sd	s5,8(sp)
 7e4:	e05a                	sd	s6,0(sp)
 7e6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 7e8:	02051493          	slli	s1,a0,0x20
 7ec:	9081                	srli	s1,s1,0x20
 7ee:	04bd                	addi	s1,s1,15
 7f0:	8091                	srli	s1,s1,0x4
 7f2:	0014899b          	addiw	s3,s1,1
 7f6:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 7f8:	00001517          	auipc	a0,0x1
 7fc:	80853503          	ld	a0,-2040(a0) # 1000 <freep>
 800:	c515                	beqz	a0,82c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 802:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 804:	4798                	lw	a4,8(a5)
 806:	02977f63          	bgeu	a4,s1,844 <malloc+0x70>
 80a:	8a4e                	mv	s4,s3
 80c:	0009871b          	sext.w	a4,s3
 810:	6685                	lui	a3,0x1
 812:	00d77363          	bgeu	a4,a3,818 <malloc+0x44>
 816:	6a05                	lui	s4,0x1
 818:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 81c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 820:	00000917          	auipc	s2,0x0
 824:	7e090913          	addi	s2,s2,2016 # 1000 <freep>
  if (p == (char *)-1) return 0;
 828:	5afd                	li	s5,-1
 82a:	a895                	j	89e <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 82c:	00000797          	auipc	a5,0x0
 830:	7e478793          	addi	a5,a5,2020 # 1010 <base>
 834:	00000717          	auipc	a4,0x0
 838:	7cf73623          	sd	a5,1996(a4) # 1000 <freep>
 83c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 83e:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 842:	b7e1                	j	80a <malloc+0x36>
      if (p->s.size == nunits)
 844:	02e48c63          	beq	s1,a4,87c <malloc+0xa8>
        p->s.size -= nunits;
 848:	4137073b          	subw	a4,a4,s3
 84c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 84e:	02071693          	slli	a3,a4,0x20
 852:	01c6d713          	srli	a4,a3,0x1c
 856:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 858:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 85c:	00000717          	auipc	a4,0x0
 860:	7aa73223          	sd	a0,1956(a4) # 1000 <freep>
      return (void *)(p + 1);
 864:	01078513          	addi	a0,a5,16
      if ((p = morecore(nunits)) == 0) return 0;
  }
}
 868:	70e2                	ld	ra,56(sp)
 86a:	7442                	ld	s0,48(sp)
 86c:	74a2                	ld	s1,40(sp)
 86e:	7902                	ld	s2,32(sp)
 870:	69e2                	ld	s3,24(sp)
 872:	6a42                	ld	s4,16(sp)
 874:	6aa2                	ld	s5,8(sp)
 876:	6b02                	ld	s6,0(sp)
 878:	6121                	addi	sp,sp,64
 87a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 87c:	6398                	ld	a4,0(a5)
 87e:	e118                	sd	a4,0(a0)
 880:	bff1                	j	85c <malloc+0x88>
  hp->s.size = nu;
 882:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 886:	0541                	addi	a0,a0,16
 888:	00000097          	auipc	ra,0x0
 88c:	eca080e7          	jalr	-310(ra) # 752 <free>
  return freep;
 890:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0) return 0;
 894:	d971                	beqz	a0,868 <malloc+0x94>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 896:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 898:	4798                	lw	a4,8(a5)
 89a:	fa9775e3          	bgeu	a4,s1,844 <malloc+0x70>
    if (p == freep)
 89e:	00093703          	ld	a4,0(s2)
 8a2:	853e                	mv	a0,a5
 8a4:	fef719e3          	bne	a4,a5,896 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8a8:	8552                	mv	a0,s4
 8aa:	00000097          	auipc	ra,0x0
 8ae:	b70080e7          	jalr	-1168(ra) # 41a <sbrk>
  if (p == (char *)-1) return 0;
 8b2:	fd5518e3          	bne	a0,s5,882 <malloc+0xae>
      if ((p = morecore(nunits)) == 0) return 0;
 8b6:	4501                	li	a0,0
 8b8:	bf45                	j	868 <malloc+0x94>

00000000000008ba <dump_test2_asm>:
#include "kernel/syscall.h"
.globl dump_test2_asm
dump_test2_asm:
  li s2, 2
 8ba:	4909                	li	s2,2
  li s3, 3
 8bc:	498d                	li	s3,3
  li s4, 4
 8be:	4a11                	li	s4,4
  li s5, 5
 8c0:	4a95                	li	s5,5
  li s6, 6
 8c2:	4b19                	li	s6,6
  li s7, 7
 8c4:	4b9d                	li	s7,7
  li s8, 8
 8c6:	4c21                	li	s8,8
  li s9, 9
 8c8:	4ca5                	li	s9,9
  li s10, 10
 8ca:	4d29                	li	s10,10
  li s11, 11
 8cc:	4dad                	li	s11,11
#ifdef SYS_dump
  li a7, SYS_dump
 8ce:	48d9                	li	a7,22
  ecall
 8d0:	00000073          	ecall
#endif
  ret
 8d4:	8082                	ret

00000000000008d6 <dump_test3_asm>:
.globl dump_test3_asm
dump_test3_asm:
  li s2, 1
 8d6:	4905                	li	s2,1
  li s3, -12
 8d8:	59d1                	li	s3,-12
  li s4, 123
 8da:	07b00a13          	li	s4,123
  li s5, -1234
 8de:	b2e00a93          	li	s5,-1234
  li s6, 12345
 8e2:	6b0d                	lui	s6,0x3
 8e4:	039b0b1b          	addiw	s6,s6,57 # 3039 <base+0x2029>
  li s7, -123456
 8e8:	7b89                	lui	s7,0xfffe2
 8ea:	dc0b8b9b          	addiw	s7,s7,-576 # fffffffffffe1dc0 <base+0xfffffffffffe0db0>
  li s8, 1234567
 8ee:	0012dc37          	lui	s8,0x12d
 8f2:	687c0c1b          	addiw	s8,s8,1671 # 12d687 <base+0x12c677>
  li s9, -12345678
 8f6:	ff43acb7          	lui	s9,0xff43a
 8fa:	eb2c8c9b          	addiw	s9,s9,-334 # ffffffffff439eb2 <base+0xffffffffff438ea2>
  li s10, 123456789
 8fe:	075bdd37          	lui	s10,0x75bd
 902:	d15d0d1b          	addiw	s10,s10,-747 # 75bcd15 <base+0x75bbd05>
  li s11, -1234567890
 906:	b66a0db7          	lui	s11,0xb66a0
 90a:	d2ed8d9b          	addiw	s11,s11,-722 # ffffffffb669fd2e <base+0xffffffffb669ed1e>
#ifdef SYS_dump
  li a7, SYS_dump
 90e:	48d9                	li	a7,22
  ecall
 910:	00000073          	ecall
#endif
  ret
 914:	8082                	ret

0000000000000916 <dump_test4_asm>:
.globl dump_test4_asm
dump_test4_asm:
  li s2, 2147483647
 916:	80000937          	lui	s2,0x80000
 91a:	397d                	addiw	s2,s2,-1 # 7fffffff <base+0x7fffefef>
  li s3, -2147483648
 91c:	800009b7          	lui	s3,0x80000
  li s4, 1337
 920:	53900a13          	li	s4,1337
  li s5, 2020
 924:	7e400a93          	li	s5,2020
  li s6, 3234
 928:	6b05                	lui	s6,0x1
 92a:	ca2b0b1b          	addiw	s6,s6,-862 # ca2 <digits+0x252>
  li s7, 3235
 92e:	6b85                	lui	s7,0x1
 930:	ca3b8b9b          	addiw	s7,s7,-861 # ca3 <digits+0x253>
  li s8, 3236
 934:	6c05                	lui	s8,0x1
 936:	ca4c0c1b          	addiw	s8,s8,-860 # ca4 <digits+0x254>
  li s9, 3237
 93a:	6c85                	lui	s9,0x1
 93c:	ca5c8c9b          	addiw	s9,s9,-859 # ca5 <digits+0x255>
  li s10, 3238
 940:	6d05                	lui	s10,0x1
 942:	ca6d0d1b          	addiw	s10,s10,-858 # ca6 <digits+0x256>
  li s11, 3239
 946:	6d85                	lui	s11,0x1
 948:	ca7d8d9b          	addiw	s11,s11,-857 # ca7 <digits+0x257>
#ifdef SYS_dump
  li a7, SYS_dump
 94c:	48d9                	li	a7,22
  ecall
 94e:	00000073          	ecall
#endif
  ret
 952:	8082                	ret

0000000000000954 <dump2_test1_asm>:
#include "kernel/syscall.h"
.globl dump2_test1_asm
dump2_test1_asm:
  li s2, 2
 954:	4909                	li	s2,2
  li s3, 3
 956:	498d                	li	s3,3
  li s4, 4
 958:	4a11                	li	s4,4
  li s5, 5
 95a:	4a95                	li	s5,5
  li s6, 6
 95c:	4b19                	li	s6,6
  li s7, 7
 95e:	4b9d                	li	s7,7
  li s8, 8
 960:	4c21                	li	s8,8
  li s9, 9
 962:	4ca5                	li	s9,9
  li s10, 10
 964:	4d29                	li	s10,10
  li s11, 11
 966:	4dad                	li	s11,11
  li a7, SYS_write
 968:	48c1                	li	a7,16
  ecall
 96a:	00000073          	ecall
  j loop
 96e:	a82d                	j	9a8 <loop>

0000000000000970 <dump2_test2_asm>:

.globl dump2_test2_asm
dump2_test2_asm:
  li s2, 4
 970:	4911                	li	s2,4
  li s3, 9
 972:	49a5                	li	s3,9
  li s4, 16
 974:	4a41                	li	s4,16
  li s5, 25
 976:	4ae5                	li	s5,25
  li s6, 36
 978:	02400b13          	li	s6,36
  li s7, 49
 97c:	03100b93          	li	s7,49
  li s8, 64
 980:	04000c13          	li	s8,64
  li s9, 81
 984:	05100c93          	li	s9,81
  li s10, 100
 988:	06400d13          	li	s10,100
  li s11, 121
 98c:	07900d93          	li	s11,121
  li a7, SYS_write
 990:	48c1                	li	a7,16
  ecall
 992:	00000073          	ecall
  j loop
 996:	a809                	j	9a8 <loop>

0000000000000998 <dump2_test3_asm>:

.globl dump2_test3_asm
dump2_test3_asm:
  li s2, 1337
 998:	53900913          	li	s2,1337
  mv a2, a1
 99c:	862e                	mv	a2,a1
  li a1, 2
 99e:	4589                	li	a1,2
#ifdef SYS_dump2
  li a7, SYS_dump2
 9a0:	48dd                	li	a7,23
  ecall
 9a2:	00000073          	ecall
#endif
  ret
 9a6:	8082                	ret

00000000000009a8 <loop>:

loop:
  j loop
 9a8:	a001                	j	9a8 <loop>
  ret
 9aa:	8082                	ret
