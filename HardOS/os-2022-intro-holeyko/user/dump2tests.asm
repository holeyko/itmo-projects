
user/_dump2tests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test1>:
}

#ifdef SYS_dump2
int dump2_test1_asm(int pipefd, char *str, int len);

void test1() {
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	f84a                	sd	s2,48(sp)
   a:	f44e                	sd	s3,40(sp)
   c:	f052                	sd	s4,32(sp)
   e:	0880                	addi	s0,sp,80
  printf("test 1 started\n");
  10:	00001517          	auipc	a0,0x1
  14:	d9050513          	addi	a0,a0,-624 # da0 <loop+0x8>
  18:	00001097          	auipc	ra,0x1
  1c:	af4080e7          	jalr	-1292(ra) # b0c <printf>
  int pipefd[2];
  pipe(pipefd);
  20:	fc840513          	addi	a0,s0,-56
  24:	00000097          	auipc	ra,0x0
  28:	76e080e7          	jalr	1902(ra) # 792 <pipe>
  int child_proc = fork();
  2c:	00000097          	auipc	ra,0x0
  30:	74e080e7          	jalr	1870(ra) # 77a <fork>
  34:	892a                	mv	s2,a0
  if (child_proc == 0) {
  36:	e125                	bnez	a0,96 <test1+0x96>
    uint64 a = 34381;
  38:	67a1                	lui	a5,0x8
  3a:	64d78793          	addi	a5,a5,1613 # 864d <base+0x663d>
  3e:	fcf43023          	sd	a5,-64(s0)
    dump2_test1_asm(pipefd[1], (char *)(&a), 8);
  42:	4621                	li	a2,8
  44:	fc040593          	addi	a1,s0,-64
  48:	fcc42503          	lw	a0,-52(s0)
  4c:	00001097          	auipc	ra,0x1
  50:	cf8080e7          	jalr	-776(ra) # d44 <dump2_test1_asm>
        printf("[ERROR] expected: %d, found: %d\n", i, value);
        goto failed;
      }
    }
  }
  printf("[SUCCESS] test 1 passed\n");
  54:	00001517          	auipc	a0,0x1
  58:	db450513          	addi	a0,a0,-588 # e08 <loop+0x70>
  5c:	00001097          	auipc	ra,0x1
  60:	ab0080e7          	jalr	-1360(ra) # b0c <printf>
  success++;
  64:	00002717          	auipc	a4,0x2
  68:	f9c70713          	addi	a4,a4,-100 # 2000 <success>
  6c:	431c                	lw	a5,0(a4)
  6e:	2785                	addiw	a5,a5,1
  70:	c31c                	sw	a5,0(a4)
failed:
  if (child_proc > 0) kill(child_proc);
  72:	09204463          	bgtz	s2,fa <test1+0xfa>
  printf("test 1 finished\n");
  76:	00001517          	auipc	a0,0x1
  7a:	db250513          	addi	a0,a0,-590 # e28 <loop+0x90>
  7e:	00001097          	auipc	ra,0x1
  82:	a8e080e7          	jalr	-1394(ra) # b0c <printf>
}
  86:	60a6                	ld	ra,72(sp)
  88:	6406                	ld	s0,64(sp)
  8a:	74e2                	ld	s1,56(sp)
  8c:	7942                	ld	s2,48(sp)
  8e:	79a2                	ld	s3,40(sp)
  90:	7a02                	ld	s4,32(sp)
  92:	6161                	addi	sp,sp,80
  94:	8082                	ret
    read(pipefd[0], &a, 8);
  96:	4621                	li	a2,8
  98:	fb840593          	addi	a1,s0,-72
  9c:	fc842503          	lw	a0,-56(s0)
  a0:	00000097          	auipc	ra,0x0
  a4:	6fa080e7          	jalr	1786(ra) # 79a <read>
  a8:	4489                	li	s1,2
    for (int i = 2; i < 12; i++) {
  aa:	4a31                	li	s4,12
  ac:	0004899b          	sext.w	s3,s1
      int error = dump2(child_proc, i, &value);
  b0:	fc040613          	addi	a2,s0,-64
  b4:	85ce                	mv	a1,s3
  b6:	854a                	mv	a0,s2
  b8:	00000097          	auipc	ra,0x0
  bc:	772080e7          	jalr	1906(ra) # 82a <dump2>
      if (error != 0) {
  c0:	e909                	bnez	a0,d2 <test1+0xd2>
      if (value != i) {
  c2:	fc043603          	ld	a2,-64(s0)
  c6:	02961063          	bne	a2,s1,e6 <test1+0xe6>
    for (int i = 2; i < 12; i++) {
  ca:	0485                	addi	s1,s1,1
  cc:	ff4490e3          	bne	s1,s4,ac <test1+0xac>
  d0:	b751                	j	54 <test1+0x54>
        printf("[ERROR] dump2 returned unexpected error %d\n", error);
  d2:	85aa                	mv	a1,a0
  d4:	00001517          	auipc	a0,0x1
  d8:	cdc50513          	addi	a0,a0,-804 # db0 <loop+0x18>
  dc:	00001097          	auipc	ra,0x1
  e0:	a30080e7          	jalr	-1488(ra) # b0c <printf>
        goto failed;
  e4:	b779                	j	72 <test1+0x72>
        printf("[ERROR] expected: %d, found: %d\n", i, value);
  e6:	85ce                	mv	a1,s3
  e8:	00001517          	auipc	a0,0x1
  ec:	cf850513          	addi	a0,a0,-776 # de0 <loop+0x48>
  f0:	00001097          	auipc	ra,0x1
  f4:	a1c080e7          	jalr	-1508(ra) # b0c <printf>
        goto failed;
  f8:	bfad                	j	72 <test1+0x72>
  if (child_proc > 0) kill(child_proc);
  fa:	854a                	mv	a0,s2
  fc:	00000097          	auipc	ra,0x0
 100:	6b6080e7          	jalr	1718(ra) # 7b2 <kill>
 104:	bf8d                	j	76 <test1+0x76>

0000000000000106 <test2>:

int dump2_test2_asm(int pipefd, char *str, int len);

void test2() {
 106:	715d                	addi	sp,sp,-80
 108:	e486                	sd	ra,72(sp)
 10a:	e0a2                	sd	s0,64(sp)
 10c:	fc26                	sd	s1,56(sp)
 10e:	f84a                	sd	s2,48(sp)
 110:	f44e                	sd	s3,40(sp)
 112:	0880                	addi	s0,sp,80
  printf("test 2 started\n");
 114:	00001517          	auipc	a0,0x1
 118:	d2c50513          	addi	a0,a0,-724 # e40 <loop+0xa8>
 11c:	00001097          	auipc	ra,0x1
 120:	9f0080e7          	jalr	-1552(ra) # b0c <printf>
  int pipefd[2];
  pipe(pipefd);
 124:	fc840513          	addi	a0,s0,-56
 128:	00000097          	auipc	ra,0x0
 12c:	66a080e7          	jalr	1642(ra) # 792 <pipe>
  int child_proc = fork();
 130:	00000097          	auipc	ra,0x0
 134:	64a080e7          	jalr	1610(ra) # 77a <fork>
 138:	892a                	mv	s2,a0
  if (child_proc == 0) {
 13a:	ed39                	bnez	a0,198 <test2+0x92>
    uint64 a = 34381;
 13c:	67a1                	lui	a5,0x8
 13e:	64d78793          	addi	a5,a5,1613 # 864d <base+0x663d>
 142:	fcf43023          	sd	a5,-64(s0)
    dump2_test2_asm(pipefd[1], (char *)(&a), 8);
 146:	4621                	li	a2,8
 148:	fc040593          	addi	a1,s0,-64
 14c:	fcc42503          	lw	a0,-52(s0)
 150:	00001097          	auipc	ra,0x1
 154:	c10080e7          	jalr	-1008(ra) # d60 <dump2_test2_asm>
        printf("[ERROR] expected: %d, found %d\n", i * i, value);
        goto failed;
      }
    }
  }
  printf("[SUCCESS] test 2 passed\n");
 158:	00001517          	auipc	a0,0x1
 15c:	d1850513          	addi	a0,a0,-744 # e70 <loop+0xd8>
 160:	00001097          	auipc	ra,0x1
 164:	9ac080e7          	jalr	-1620(ra) # b0c <printf>
  success++;
 168:	00002717          	auipc	a4,0x2
 16c:	e9870713          	addi	a4,a4,-360 # 2000 <success>
 170:	431c                	lw	a5,0(a4)
 172:	2785                	addiw	a5,a5,1
 174:	c31c                	sw	a5,0(a4)
failed:
  if (child_proc > 0) kill(child_proc);
 176:	09204263          	bgtz	s2,1fa <test2+0xf4>
  printf("test 2 finished\n");
 17a:	00001517          	auipc	a0,0x1
 17e:	d1650513          	addi	a0,a0,-746 # e90 <loop+0xf8>
 182:	00001097          	auipc	ra,0x1
 186:	98a080e7          	jalr	-1654(ra) # b0c <printf>
}
 18a:	60a6                	ld	ra,72(sp)
 18c:	6406                	ld	s0,64(sp)
 18e:	74e2                	ld	s1,56(sp)
 190:	7942                	ld	s2,48(sp)
 192:	79a2                	ld	s3,40(sp)
 194:	6161                	addi	sp,sp,80
 196:	8082                	ret
    read(pipefd[0], &a, 8);
 198:	4621                	li	a2,8
 19a:	fb840593          	addi	a1,s0,-72
 19e:	fc842503          	lw	a0,-56(s0)
 1a2:	00000097          	auipc	ra,0x0
 1a6:	5f8080e7          	jalr	1528(ra) # 79a <read>
    for (int i = 2; i < 12; i++) {
 1aa:	4489                	li	s1,2
 1ac:	49b1                	li	s3,12
      int error = dump2(child_proc, i, &value);
 1ae:	fc040613          	addi	a2,s0,-64
 1b2:	85a6                	mv	a1,s1
 1b4:	854a                	mv	a0,s2
 1b6:	00000097          	auipc	ra,0x0
 1ba:	674080e7          	jalr	1652(ra) # 82a <dump2>
      if (error != 0) {
 1be:	e919                	bnez	a0,1d4 <test2+0xce>
      if (value != i * i) {
 1c0:	029485bb          	mulw	a1,s1,s1
 1c4:	fc043603          	ld	a2,-64(s0)
 1c8:	02c59063          	bne	a1,a2,1e8 <test2+0xe2>
    for (int i = 2; i < 12; i++) {
 1cc:	2485                	addiw	s1,s1,1
 1ce:	ff3490e3          	bne	s1,s3,1ae <test2+0xa8>
 1d2:	b759                	j	158 <test2+0x52>
        printf("[ERROR] dump2 returned unexpected error %d\n", error);
 1d4:	85aa                	mv	a1,a0
 1d6:	00001517          	auipc	a0,0x1
 1da:	bda50513          	addi	a0,a0,-1062 # db0 <loop+0x18>
 1de:	00001097          	auipc	ra,0x1
 1e2:	92e080e7          	jalr	-1746(ra) # b0c <printf>
        goto failed;
 1e6:	bf41                	j	176 <test2+0x70>
        printf("[ERROR] expected: %d, found %d\n", i * i, value);
 1e8:	00001517          	auipc	a0,0x1
 1ec:	c6850513          	addi	a0,a0,-920 # e50 <loop+0xb8>
 1f0:	00001097          	auipc	ra,0x1
 1f4:	91c080e7          	jalr	-1764(ra) # b0c <printf>
        goto failed;
 1f8:	bfbd                	j	176 <test2+0x70>
  if (child_proc > 0) kill(child_proc);
 1fa:	854a                	mv	a0,s2
 1fc:	00000097          	auipc	ra,0x0
 200:	5b6080e7          	jalr	1462(ra) # 7b2 <kill>
 204:	bf9d                	j	17a <test2+0x74>

0000000000000206 <test3>:

int dump2_test3_asm(int pid, uint64 *ptr);

void test3() {
 206:	1101                	addi	sp,sp,-32
 208:	ec06                	sd	ra,24(sp)
 20a:	e822                	sd	s0,16(sp)
 20c:	1000                	addi	s0,sp,32
  printf("test 3 started\n");
 20e:	00001517          	auipc	a0,0x1
 212:	c9a50513          	addi	a0,a0,-870 # ea8 <loop+0x110>
 216:	00001097          	auipc	ra,0x1
 21a:	8f6080e7          	jalr	-1802(ra) # b0c <printf>
  uint64 value;
  int result = dump2_test3_asm(getpid(), &value);
 21e:	00000097          	auipc	ra,0x0
 222:	5e4080e7          	jalr	1508(ra) # 802 <getpid>
 226:	fe840593          	addi	a1,s0,-24
 22a:	00001097          	auipc	ra,0x1
 22e:	b5e080e7          	jalr	-1186(ra) # d88 <dump2_test3_asm>
  if (result != 0) {
 232:	e91d                	bnez	a0,268 <test3+0x62>
    printf("[ERROR] dump2 returned unexpected error %d\n", result);
    goto failed;
  }
  if (value != 1337) {
 234:	fe843583          	ld	a1,-24(s0)
 238:	53900793          	li	a5,1337
 23c:	04f58063          	beq	a1,a5,27c <test3+0x76>
    printf("[ERROR] expected: 1337, found: %d", value);
 240:	00001517          	auipc	a0,0x1
 244:	c7850513          	addi	a0,a0,-904 # eb8 <loop+0x120>
 248:	00001097          	auipc	ra,0x1
 24c:	8c4080e7          	jalr	-1852(ra) # b0c <printf>
    goto failed;
  }
  printf("[SUCCESS] test 3 passed\n");
  success++;
failed:
  printf("test 3 finished\n");
 250:	00001517          	auipc	a0,0x1
 254:	cb050513          	addi	a0,a0,-848 # f00 <loop+0x168>
 258:	00001097          	auipc	ra,0x1
 25c:	8b4080e7          	jalr	-1868(ra) # b0c <printf>
}
 260:	60e2                	ld	ra,24(sp)
 262:	6442                	ld	s0,16(sp)
 264:	6105                	addi	sp,sp,32
 266:	8082                	ret
    printf("[ERROR] dump2 returned unexpected error %d\n", result);
 268:	85aa                	mv	a1,a0
 26a:	00001517          	auipc	a0,0x1
 26e:	b4650513          	addi	a0,a0,-1210 # db0 <loop+0x18>
 272:	00001097          	auipc	ra,0x1
 276:	89a080e7          	jalr	-1894(ra) # b0c <printf>
    goto failed;
 27a:	bfd9                	j	250 <test3+0x4a>
  printf("[SUCCESS] test 3 passed\n");
 27c:	00001517          	auipc	a0,0x1
 280:	c6450513          	addi	a0,a0,-924 # ee0 <loop+0x148>
 284:	00001097          	auipc	ra,0x1
 288:	888080e7          	jalr	-1912(ra) # b0c <printf>
  success++;
 28c:	00002717          	auipc	a4,0x2
 290:	d7470713          	addi	a4,a4,-652 # 2000 <success>
 294:	431c                	lw	a5,0(a4)
 296:	2785                	addiw	a5,a5,1
 298:	c31c                	sw	a5,0(a4)
 29a:	bf5d                	j	250 <test3+0x4a>

000000000000029c <test4>:

void test4() {
 29c:	7139                	addi	sp,sp,-64
 29e:	fc06                	sd	ra,56(sp)
 2a0:	f822                	sd	s0,48(sp)
 2a2:	f426                	sd	s1,40(sp)
 2a4:	0080                	addi	s0,sp,64
  printf("test 4 started\n");
 2a6:	00001517          	auipc	a0,0x1
 2aa:	c7250513          	addi	a0,a0,-910 # f18 <loop+0x180>
 2ae:	00001097          	auipc	ra,0x1
 2b2:	85e080e7          	jalr	-1954(ra) # b0c <printf>
  uint64 a;
  printf("[INFO] testing nonexisting proccess\n");
 2b6:	00001517          	auipc	a0,0x1
 2ba:	c7250513          	addi	a0,a0,-910 # f28 <loop+0x190>
 2be:	00001097          	auipc	ra,0x1
 2c2:	84e080e7          	jalr	-1970(ra) # b0c <printf>
  int error = dump2(2147483647, 10, &a);
 2c6:	fd840613          	addi	a2,s0,-40
 2ca:	45a9                	li	a1,10
 2cc:	80000537          	lui	a0,0x80000
 2d0:	fff54513          	not	a0,a0
 2d4:	00000097          	auipc	ra,0x0
 2d8:	556080e7          	jalr	1366(ra) # 82a <dump2>
 2dc:	fca42a23          	sw	a0,-44(s0)
  if (error != -2) {
 2e0:	57f9                	li	a5,-2
 2e2:	02f50863          	beq	a0,a5,312 <test4+0x76>
 2e6:	85aa                	mv	a1,a0
    printf("[ERROR] dump2 returned unexpected value %d, expected -2\n", error);
 2e8:	00001517          	auipc	a0,0x1
 2ec:	c6850513          	addi	a0,a0,-920 # f50 <loop+0x1b8>
 2f0:	00001097          	auipc	ra,0x1
 2f4:	81c080e7          	jalr	-2020(ra) # b0c <printf>
  }
  printf("[OK] invalid memory address\n");
  printf("[SUCCESS] test 4 passed\n");
  success++;
failed:
  printf("test 4 finished\n");
 2f8:	00001517          	auipc	a0,0x1
 2fc:	e9050513          	addi	a0,a0,-368 # 1188 <loop+0x3f0>
 300:	00001097          	auipc	ra,0x1
 304:	80c080e7          	jalr	-2036(ra) # b0c <printf>
}
 308:	70e2                	ld	ra,56(sp)
 30a:	7442                	ld	s0,48(sp)
 30c:	74a2                	ld	s1,40(sp)
 30e:	6121                	addi	sp,sp,64
 310:	8082                	ret
  printf("[OK] nonexisting proccess\n");
 312:	00001517          	auipc	a0,0x1
 316:	c7e50513          	addi	a0,a0,-898 # f90 <loop+0x1f8>
 31a:	00000097          	auipc	ra,0x0
 31e:	7f2080e7          	jalr	2034(ra) # b0c <printf>
  printf("[INFO] testing illegal access to registers\n");
 322:	00001517          	auipc	a0,0x1
 326:	c8e50513          	addi	a0,a0,-882 # fb0 <loop+0x218>
 32a:	00000097          	auipc	ra,0x0
 32e:	7e2080e7          	jalr	2018(ra) # b0c <printf>
  pipe(pipefd);
 332:	fc840513          	addi	a0,s0,-56
 336:	00000097          	auipc	ra,0x0
 33a:	45c080e7          	jalr	1116(ra) # 792 <pipe>
  int parent_pid = getpid();
 33e:	00000097          	auipc	ra,0x0
 342:	4c4080e7          	jalr	1220(ra) # 802 <getpid>
 346:	84aa                	mv	s1,a0
  int child_proc = fork();
 348:	00000097          	auipc	ra,0x0
 34c:	432080e7          	jalr	1074(ra) # 77a <fork>
  if (child_proc == 0) {
 350:	c905                	beqz	a0,380 <test4+0xe4>
    read(pipefd[0], &error, 4);
 352:	4611                	li	a2,4
 354:	fd440593          	addi	a1,s0,-44
 358:	fc842503          	lw	a0,-56(s0)
 35c:	00000097          	auipc	ra,0x0
 360:	43e080e7          	jalr	1086(ra) # 79a <read>
    if (error != -1) {
 364:	fd442583          	lw	a1,-44(s0)
 368:	57fd                	li	a5,-1
 36a:	04f58363          	beq	a1,a5,3b0 <test4+0x114>
      printf("[ERROR] dump2 returned unexpected value %d, expected -1\n",
 36e:	00001517          	auipc	a0,0x1
 372:	c7250513          	addi	a0,a0,-910 # fe0 <loop+0x248>
 376:	00000097          	auipc	ra,0x0
 37a:	796080e7          	jalr	1942(ra) # b0c <printf>
      goto failed;
 37e:	bfad                	j	2f8 <test4+0x5c>
    error = dump2(parent_pid, 10, &a);
 380:	fd840613          	addi	a2,s0,-40
 384:	45a9                	li	a1,10
 386:	8526                	mv	a0,s1
 388:	00000097          	auipc	ra,0x0
 38c:	4a2080e7          	jalr	1186(ra) # 82a <dump2>
 390:	fca42a23          	sw	a0,-44(s0)
    write(pipefd[1], &error, 4);
 394:	4611                	li	a2,4
 396:	fd440593          	addi	a1,s0,-44
 39a:	fcc42503          	lw	a0,-52(s0)
 39e:	00000097          	auipc	ra,0x0
 3a2:	404080e7          	jalr	1028(ra) # 7a2 <write>
    exit(0);
 3a6:	4501                	li	a0,0
 3a8:	00000097          	auipc	ra,0x0
 3ac:	3da080e7          	jalr	986(ra) # 782 <exit>
  printf("[OK] illegal access to registers\n");
 3b0:	00001517          	auipc	a0,0x1
 3b4:	c7050513          	addi	a0,a0,-912 # 1020 <loop+0x288>
 3b8:	00000097          	auipc	ra,0x0
 3bc:	754080e7          	jalr	1876(ra) # b0c <printf>
  printf("[INFO] testing incorrect number of register\n");
 3c0:	00001517          	auipc	a0,0x1
 3c4:	c8850513          	addi	a0,a0,-888 # 1048 <loop+0x2b0>
 3c8:	00000097          	auipc	ra,0x0
 3cc:	744080e7          	jalr	1860(ra) # b0c <printf>
  error = dump2(parent_pid, 1337, &a);
 3d0:	fd840613          	addi	a2,s0,-40
 3d4:	53900593          	li	a1,1337
 3d8:	8526                	mv	a0,s1
 3da:	00000097          	auipc	ra,0x0
 3de:	450080e7          	jalr	1104(ra) # 82a <dump2>
 3e2:	fca42a23          	sw	a0,-44(s0)
  if (error != -3) {
 3e6:	57f5                	li	a5,-3
 3e8:	00f50c63          	beq	a0,a5,400 <test4+0x164>
    printf("[ERROR] dump2 returned unexpected value %d, expected -3\n", error);
 3ec:	85aa                	mv	a1,a0
 3ee:	00001517          	auipc	a0,0x1
 3f2:	c8a50513          	addi	a0,a0,-886 # 1078 <loop+0x2e0>
 3f6:	00000097          	auipc	ra,0x0
 3fa:	716080e7          	jalr	1814(ra) # b0c <printf>
    goto failed;
 3fe:	bded                	j	2f8 <test4+0x5c>
  printf("[OK] incorrect number of register\n");
 400:	00001517          	auipc	a0,0x1
 404:	cb850513          	addi	a0,a0,-840 # 10b8 <loop+0x320>
 408:	00000097          	auipc	ra,0x0
 40c:	704080e7          	jalr	1796(ra) # b0c <printf>
  printf("[INFO] testing invalid memory address\n");
 410:	00001517          	auipc	a0,0x1
 414:	cd050513          	addi	a0,a0,-816 # 10e0 <loop+0x348>
 418:	00000097          	auipc	ra,0x0
 41c:	6f4080e7          	jalr	1780(ra) # b0c <printf>
  error = dump2(parent_pid, 10, &a + 123456789);
 420:	3ade7637          	lui	a2,0x3ade7
 424:	fe060793          	addi	a5,a2,-32 # 3ade6fe0 <base+0x3ade4fd0>
 428:	00878633          	add	a2,a5,s0
 42c:	8a060613          	addi	a2,a2,-1888
 430:	45a9                	li	a1,10
 432:	8526                	mv	a0,s1
 434:	00000097          	auipc	ra,0x0
 438:	3f6080e7          	jalr	1014(ra) # 82a <dump2>
 43c:	85aa                	mv	a1,a0
 43e:	fca42a23          	sw	a0,-44(s0)
  if (error != -4) {
 442:	57f1                	li	a5,-4
 444:	00f50b63          	beq	a0,a5,45a <test4+0x1be>
    printf("[ERROR] dump2 returned unexpected value %d, expected -4\n", error);
 448:	00001517          	auipc	a0,0x1
 44c:	cc050513          	addi	a0,a0,-832 # 1108 <loop+0x370>
 450:	00000097          	auipc	ra,0x0
 454:	6bc080e7          	jalr	1724(ra) # b0c <printf>
    goto failed;
 458:	b545                	j	2f8 <test4+0x5c>
  printf("[OK] invalid memory address\n");
 45a:	00001517          	auipc	a0,0x1
 45e:	cee50513          	addi	a0,a0,-786 # 1148 <loop+0x3b0>
 462:	00000097          	auipc	ra,0x0
 466:	6aa080e7          	jalr	1706(ra) # b0c <printf>
  printf("[SUCCESS] test 4 passed\n");
 46a:	00001517          	auipc	a0,0x1
 46e:	cfe50513          	addi	a0,a0,-770 # 1168 <loop+0x3d0>
 472:	00000097          	auipc	ra,0x0
 476:	69a080e7          	jalr	1690(ra) # b0c <printf>
  success++;
 47a:	00002717          	auipc	a4,0x2
 47e:	b8670713          	addi	a4,a4,-1146 # 2000 <success>
 482:	431c                	lw	a5,0(a4)
 484:	2785                	addiw	a5,a5,1
 486:	c31c                	sw	a5,0(a4)
 488:	bd85                	j	2f8 <test4+0x5c>

000000000000048a <main>:
int main(void) {
 48a:	1101                	addi	sp,sp,-32
 48c:	ec06                	sd	ra,24(sp)
 48e:	e822                	sd	s0,16(sp)
 490:	e426                	sd	s1,8(sp)
 492:	1000                	addi	s0,sp,32
  printf("dump2 tests started\n");
 494:	00001517          	auipc	a0,0x1
 498:	d0c50513          	addi	a0,a0,-756 # 11a0 <loop+0x408>
 49c:	00000097          	auipc	ra,0x0
 4a0:	670080e7          	jalr	1648(ra) # b0c <printf>
  printf("dump2 syscall found. Start testing\n");
 4a4:	00001517          	auipc	a0,0x1
 4a8:	d1450513          	addi	a0,a0,-748 # 11b8 <loop+0x420>
 4ac:	00000097          	auipc	ra,0x0
 4b0:	660080e7          	jalr	1632(ra) # b0c <printf>
  success = 0;
 4b4:	00002497          	auipc	s1,0x2
 4b8:	b4c48493          	addi	s1,s1,-1204 # 2000 <success>
 4bc:	0004a023          	sw	zero,0(s1)
  test1();
 4c0:	00000097          	auipc	ra,0x0
 4c4:	b40080e7          	jalr	-1216(ra) # 0 <test1>
  test2();
 4c8:	00000097          	auipc	ra,0x0
 4cc:	c3e080e7          	jalr	-962(ra) # 106 <test2>
  test3();
 4d0:	00000097          	auipc	ra,0x0
 4d4:	d36080e7          	jalr	-714(ra) # 206 <test3>
  test4();
 4d8:	00000097          	auipc	ra,0x0
 4dc:	dc4080e7          	jalr	-572(ra) # 29c <test4>
  printf("4 tests were run. %d tests passed\n", success);
 4e0:	408c                	lw	a1,0(s1)
 4e2:	00001517          	auipc	a0,0x1
 4e6:	cfe50513          	addi	a0,a0,-770 # 11e0 <loop+0x448>
 4ea:	00000097          	auipc	ra,0x0
 4ee:	622080e7          	jalr	1570(ra) # b0c <printf>
  exit(0);
 4f2:	4501                	li	a0,0
 4f4:	00000097          	auipc	ra,0x0
 4f8:	28e080e7          	jalr	654(ra) # 782 <exit>

00000000000004fc <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
 4fc:	1141                	addi	sp,sp,-16
 4fe:	e406                	sd	ra,8(sp)
 500:	e022                	sd	s0,0(sp)
 502:	0800                	addi	s0,sp,16
  extern int main();
  main();
 504:	00000097          	auipc	ra,0x0
 508:	f86080e7          	jalr	-122(ra) # 48a <main>
  exit(0);
 50c:	4501                	li	a0,0
 50e:	00000097          	auipc	ra,0x0
 512:	274080e7          	jalr	628(ra) # 782 <exit>

0000000000000516 <strcpy>:
}

char *strcpy(char *s, const char *t) {
 516:	1141                	addi	sp,sp,-16
 518:	e422                	sd	s0,8(sp)
 51a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 51c:	87aa                	mv	a5,a0
 51e:	0585                	addi	a1,a1,1
 520:	0785                	addi	a5,a5,1
 522:	fff5c703          	lbu	a4,-1(a1)
 526:	fee78fa3          	sb	a4,-1(a5)
 52a:	fb75                	bnez	a4,51e <strcpy+0x8>
    ;
  return os;
}
 52c:	6422                	ld	s0,8(sp)
 52e:	0141                	addi	sp,sp,16
 530:	8082                	ret

0000000000000532 <strcmp>:

int strcmp(const char *p, const char *q) {
 532:	1141                	addi	sp,sp,-16
 534:	e422                	sd	s0,8(sp)
 536:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
 538:	00054783          	lbu	a5,0(a0)
 53c:	cb91                	beqz	a5,550 <strcmp+0x1e>
 53e:	0005c703          	lbu	a4,0(a1)
 542:	00f71763          	bne	a4,a5,550 <strcmp+0x1e>
 546:	0505                	addi	a0,a0,1
 548:	0585                	addi	a1,a1,1
 54a:	00054783          	lbu	a5,0(a0)
 54e:	fbe5                	bnez	a5,53e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 550:	0005c503          	lbu	a0,0(a1)
}
 554:	40a7853b          	subw	a0,a5,a0
 558:	6422                	ld	s0,8(sp)
 55a:	0141                	addi	sp,sp,16
 55c:	8082                	ret

000000000000055e <strlen>:

uint strlen(const char *s) {
 55e:	1141                	addi	sp,sp,-16
 560:	e422                	sd	s0,8(sp)
 562:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 564:	00054783          	lbu	a5,0(a0)
 568:	cf91                	beqz	a5,584 <strlen+0x26>
 56a:	0505                	addi	a0,a0,1
 56c:	87aa                	mv	a5,a0
 56e:	4685                	li	a3,1
 570:	9e89                	subw	a3,a3,a0
 572:	00f6853b          	addw	a0,a3,a5
 576:	0785                	addi	a5,a5,1
 578:	fff7c703          	lbu	a4,-1(a5)
 57c:	fb7d                	bnez	a4,572 <strlen+0x14>
    ;
  return n;
}
 57e:	6422                	ld	s0,8(sp)
 580:	0141                	addi	sp,sp,16
 582:	8082                	ret
  for (n = 0; s[n]; n++)
 584:	4501                	li	a0,0
 586:	bfe5                	j	57e <strlen+0x20>

0000000000000588 <memset>:

void *memset(void *dst, int c, uint n) {
 588:	1141                	addi	sp,sp,-16
 58a:	e422                	sd	s0,8(sp)
 58c:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 58e:	ca19                	beqz	a2,5a4 <memset+0x1c>
 590:	87aa                	mv	a5,a0
 592:	1602                	slli	a2,a2,0x20
 594:	9201                	srli	a2,a2,0x20
 596:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 59a:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 59e:	0785                	addi	a5,a5,1
 5a0:	fee79de3          	bne	a5,a4,59a <memset+0x12>
  }
  return dst;
}
 5a4:	6422                	ld	s0,8(sp)
 5a6:	0141                	addi	sp,sp,16
 5a8:	8082                	ret

00000000000005aa <strchr>:

char *strchr(const char *s, char c) {
 5aa:	1141                	addi	sp,sp,-16
 5ac:	e422                	sd	s0,8(sp)
 5ae:	0800                	addi	s0,sp,16
  for (; *s; s++)
 5b0:	00054783          	lbu	a5,0(a0)
 5b4:	cb99                	beqz	a5,5ca <strchr+0x20>
    if (*s == c) return (char *)s;
 5b6:	00f58763          	beq	a1,a5,5c4 <strchr+0x1a>
  for (; *s; s++)
 5ba:	0505                	addi	a0,a0,1
 5bc:	00054783          	lbu	a5,0(a0)
 5c0:	fbfd                	bnez	a5,5b6 <strchr+0xc>
  return 0;
 5c2:	4501                	li	a0,0
}
 5c4:	6422                	ld	s0,8(sp)
 5c6:	0141                	addi	sp,sp,16
 5c8:	8082                	ret
  return 0;
 5ca:	4501                	li	a0,0
 5cc:	bfe5                	j	5c4 <strchr+0x1a>

00000000000005ce <gets>:

char *gets(char *buf, int max) {
 5ce:	711d                	addi	sp,sp,-96
 5d0:	ec86                	sd	ra,88(sp)
 5d2:	e8a2                	sd	s0,80(sp)
 5d4:	e4a6                	sd	s1,72(sp)
 5d6:	e0ca                	sd	s2,64(sp)
 5d8:	fc4e                	sd	s3,56(sp)
 5da:	f852                	sd	s4,48(sp)
 5dc:	f456                	sd	s5,40(sp)
 5de:	f05a                	sd	s6,32(sp)
 5e0:	ec5e                	sd	s7,24(sp)
 5e2:	1080                	addi	s0,sp,96
 5e4:	8baa                	mv	s7,a0
 5e6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 5e8:	892a                	mv	s2,a0
 5ea:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
 5ec:	4aa9                	li	s5,10
 5ee:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 5f0:	89a6                	mv	s3,s1
 5f2:	2485                	addiw	s1,s1,1
 5f4:	0344d863          	bge	s1,s4,624 <gets+0x56>
    cc = read(0, &c, 1);
 5f8:	4605                	li	a2,1
 5fa:	faf40593          	addi	a1,s0,-81
 5fe:	4501                	li	a0,0
 600:	00000097          	auipc	ra,0x0
 604:	19a080e7          	jalr	410(ra) # 79a <read>
    if (cc < 1) break;
 608:	00a05e63          	blez	a0,624 <gets+0x56>
    buf[i++] = c;
 60c:	faf44783          	lbu	a5,-81(s0)
 610:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r') break;
 614:	01578763          	beq	a5,s5,622 <gets+0x54>
 618:	0905                	addi	s2,s2,1
 61a:	fd679be3          	bne	a5,s6,5f0 <gets+0x22>
  for (i = 0; i + 1 < max;) {
 61e:	89a6                	mv	s3,s1
 620:	a011                	j	624 <gets+0x56>
 622:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
 624:	99de                	add	s3,s3,s7
 626:	00098023          	sb	zero,0(s3)
  return buf;
}
 62a:	855e                	mv	a0,s7
 62c:	60e6                	ld	ra,88(sp)
 62e:	6446                	ld	s0,80(sp)
 630:	64a6                	ld	s1,72(sp)
 632:	6906                	ld	s2,64(sp)
 634:	79e2                	ld	s3,56(sp)
 636:	7a42                	ld	s4,48(sp)
 638:	7aa2                	ld	s5,40(sp)
 63a:	7b02                	ld	s6,32(sp)
 63c:	6be2                	ld	s7,24(sp)
 63e:	6125                	addi	sp,sp,96
 640:	8082                	ret

0000000000000642 <stat>:

int stat(const char *n, struct stat *st) {
 642:	1101                	addi	sp,sp,-32
 644:	ec06                	sd	ra,24(sp)
 646:	e822                	sd	s0,16(sp)
 648:	e426                	sd	s1,8(sp)
 64a:	e04a                	sd	s2,0(sp)
 64c:	1000                	addi	s0,sp,32
 64e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 650:	4581                	li	a1,0
 652:	00000097          	auipc	ra,0x0
 656:	170080e7          	jalr	368(ra) # 7c2 <open>
  if (fd < 0) return -1;
 65a:	02054563          	bltz	a0,684 <stat+0x42>
 65e:	84aa                	mv	s1,a0
  r = fstat(fd, st);
 660:	85ca                	mv	a1,s2
 662:	00000097          	auipc	ra,0x0
 666:	178080e7          	jalr	376(ra) # 7da <fstat>
 66a:	892a                	mv	s2,a0
  close(fd);
 66c:	8526                	mv	a0,s1
 66e:	00000097          	auipc	ra,0x0
 672:	13c080e7          	jalr	316(ra) # 7aa <close>
  return r;
}
 676:	854a                	mv	a0,s2
 678:	60e2                	ld	ra,24(sp)
 67a:	6442                	ld	s0,16(sp)
 67c:	64a2                	ld	s1,8(sp)
 67e:	6902                	ld	s2,0(sp)
 680:	6105                	addi	sp,sp,32
 682:	8082                	ret
  if (fd < 0) return -1;
 684:	597d                	li	s2,-1
 686:	bfc5                	j	676 <stat+0x34>

0000000000000688 <atoi>:

int atoi(const char *s) {
 688:	1141                	addi	sp,sp,-16
 68a:	e422                	sd	s0,8(sp)
 68c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 68e:	00054683          	lbu	a3,0(a0)
 692:	fd06879b          	addiw	a5,a3,-48
 696:	0ff7f793          	zext.b	a5,a5
 69a:	4625                	li	a2,9
 69c:	02f66863          	bltu	a2,a5,6cc <atoi+0x44>
 6a0:	872a                	mv	a4,a0
  n = 0;
 6a2:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 6a4:	0705                	addi	a4,a4,1
 6a6:	0025179b          	slliw	a5,a0,0x2
 6aa:	9fa9                	addw	a5,a5,a0
 6ac:	0017979b          	slliw	a5,a5,0x1
 6b0:	9fb5                	addw	a5,a5,a3
 6b2:	fd07851b          	addiw	a0,a5,-48
 6b6:	00074683          	lbu	a3,0(a4)
 6ba:	fd06879b          	addiw	a5,a3,-48
 6be:	0ff7f793          	zext.b	a5,a5
 6c2:	fef671e3          	bgeu	a2,a5,6a4 <atoi+0x1c>
  return n;
}
 6c6:	6422                	ld	s0,8(sp)
 6c8:	0141                	addi	sp,sp,16
 6ca:	8082                	ret
  n = 0;
 6cc:	4501                	li	a0,0
 6ce:	bfe5                	j	6c6 <atoi+0x3e>

00000000000006d0 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
 6d0:	1141                	addi	sp,sp,-16
 6d2:	e422                	sd	s0,8(sp)
 6d4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 6d6:	02b57463          	bgeu	a0,a1,6fe <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
 6da:	00c05f63          	blez	a2,6f8 <memmove+0x28>
 6de:	1602                	slli	a2,a2,0x20
 6e0:	9201                	srli	a2,a2,0x20
 6e2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 6e6:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
 6e8:	0585                	addi	a1,a1,1
 6ea:	0705                	addi	a4,a4,1
 6ec:	fff5c683          	lbu	a3,-1(a1)
 6f0:	fed70fa3          	sb	a3,-1(a4)
 6f4:	fee79ae3          	bne	a5,a4,6e8 <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
 6f8:	6422                	ld	s0,8(sp)
 6fa:	0141                	addi	sp,sp,16
 6fc:	8082                	ret
    dst += n;
 6fe:	00c50733          	add	a4,a0,a2
    src += n;
 702:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
 704:	fec05ae3          	blez	a2,6f8 <memmove+0x28>
 708:	fff6079b          	addiw	a5,a2,-1
 70c:	1782                	slli	a5,a5,0x20
 70e:	9381                	srli	a5,a5,0x20
 710:	fff7c793          	not	a5,a5
 714:	97ba                	add	a5,a5,a4
 716:	15fd                	addi	a1,a1,-1
 718:	177d                	addi	a4,a4,-1
 71a:	0005c683          	lbu	a3,0(a1)
 71e:	00d70023          	sb	a3,0(a4)
 722:	fee79ae3          	bne	a5,a4,716 <memmove+0x46>
 726:	bfc9                	j	6f8 <memmove+0x28>

0000000000000728 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
 728:	1141                	addi	sp,sp,-16
 72a:	e422                	sd	s0,8(sp)
 72c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 72e:	ca05                	beqz	a2,75e <memcmp+0x36>
 730:	fff6069b          	addiw	a3,a2,-1
 734:	1682                	slli	a3,a3,0x20
 736:	9281                	srli	a3,a3,0x20
 738:	0685                	addi	a3,a3,1
 73a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 73c:	00054783          	lbu	a5,0(a0)
 740:	0005c703          	lbu	a4,0(a1)
 744:	00e79863          	bne	a5,a4,754 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 748:	0505                	addi	a0,a0,1
    p2++;
 74a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 74c:	fed518e3          	bne	a0,a3,73c <memcmp+0x14>
  }
  return 0;
 750:	4501                	li	a0,0
 752:	a019                	j	758 <memcmp+0x30>
      return *p1 - *p2;
 754:	40e7853b          	subw	a0,a5,a4
}
 758:	6422                	ld	s0,8(sp)
 75a:	0141                	addi	sp,sp,16
 75c:	8082                	ret
  return 0;
 75e:	4501                	li	a0,0
 760:	bfe5                	j	758 <memcmp+0x30>

0000000000000762 <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
 762:	1141                	addi	sp,sp,-16
 764:	e406                	sd	ra,8(sp)
 766:	e022                	sd	s0,0(sp)
 768:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 76a:	00000097          	auipc	ra,0x0
 76e:	f66080e7          	jalr	-154(ra) # 6d0 <memmove>
}
 772:	60a2                	ld	ra,8(sp)
 774:	6402                	ld	s0,0(sp)
 776:	0141                	addi	sp,sp,16
 778:	8082                	ret

000000000000077a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 77a:	4885                	li	a7,1
 ecall
 77c:	00000073          	ecall
 ret
 780:	8082                	ret

0000000000000782 <exit>:
.global exit
exit:
 li a7, SYS_exit
 782:	4889                	li	a7,2
 ecall
 784:	00000073          	ecall
 ret
 788:	8082                	ret

000000000000078a <wait>:
.global wait
wait:
 li a7, SYS_wait
 78a:	488d                	li	a7,3
 ecall
 78c:	00000073          	ecall
 ret
 790:	8082                	ret

0000000000000792 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 792:	4891                	li	a7,4
 ecall
 794:	00000073          	ecall
 ret
 798:	8082                	ret

000000000000079a <read>:
.global read
read:
 li a7, SYS_read
 79a:	4895                	li	a7,5
 ecall
 79c:	00000073          	ecall
 ret
 7a0:	8082                	ret

00000000000007a2 <write>:
.global write
write:
 li a7, SYS_write
 7a2:	48c1                	li	a7,16
 ecall
 7a4:	00000073          	ecall
 ret
 7a8:	8082                	ret

00000000000007aa <close>:
.global close
close:
 li a7, SYS_close
 7aa:	48d5                	li	a7,21
 ecall
 7ac:	00000073          	ecall
 ret
 7b0:	8082                	ret

00000000000007b2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 7b2:	4899                	li	a7,6
 ecall
 7b4:	00000073          	ecall
 ret
 7b8:	8082                	ret

00000000000007ba <exec>:
.global exec
exec:
 li a7, SYS_exec
 7ba:	489d                	li	a7,7
 ecall
 7bc:	00000073          	ecall
 ret
 7c0:	8082                	ret

00000000000007c2 <open>:
.global open
open:
 li a7, SYS_open
 7c2:	48bd                	li	a7,15
 ecall
 7c4:	00000073          	ecall
 ret
 7c8:	8082                	ret

00000000000007ca <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 7ca:	48c5                	li	a7,17
 ecall
 7cc:	00000073          	ecall
 ret
 7d0:	8082                	ret

00000000000007d2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 7d2:	48c9                	li	a7,18
 ecall
 7d4:	00000073          	ecall
 ret
 7d8:	8082                	ret

00000000000007da <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 7da:	48a1                	li	a7,8
 ecall
 7dc:	00000073          	ecall
 ret
 7e0:	8082                	ret

00000000000007e2 <link>:
.global link
link:
 li a7, SYS_link
 7e2:	48cd                	li	a7,19
 ecall
 7e4:	00000073          	ecall
 ret
 7e8:	8082                	ret

00000000000007ea <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 7ea:	48d1                	li	a7,20
 ecall
 7ec:	00000073          	ecall
 ret
 7f0:	8082                	ret

00000000000007f2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 7f2:	48a5                	li	a7,9
 ecall
 7f4:	00000073          	ecall
 ret
 7f8:	8082                	ret

00000000000007fa <dup>:
.global dup
dup:
 li a7, SYS_dup
 7fa:	48a9                	li	a7,10
 ecall
 7fc:	00000073          	ecall
 ret
 800:	8082                	ret

0000000000000802 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 802:	48ad                	li	a7,11
 ecall
 804:	00000073          	ecall
 ret
 808:	8082                	ret

000000000000080a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 80a:	48b1                	li	a7,12
 ecall
 80c:	00000073          	ecall
 ret
 810:	8082                	ret

0000000000000812 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 812:	48b5                	li	a7,13
 ecall
 814:	00000073          	ecall
 ret
 818:	8082                	ret

000000000000081a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 81a:	48b9                	li	a7,14
 ecall
 81c:	00000073          	ecall
 ret
 820:	8082                	ret

0000000000000822 <dump>:
.global dump
dump:
 li a7, SYS_dump
 822:	48d9                	li	a7,22
 ecall
 824:	00000073          	ecall
 ret
 828:	8082                	ret

000000000000082a <dump2>:
.global dump2
dump2:
 li a7, SYS_dump2
 82a:	48dd                	li	a7,23
 ecall
 82c:	00000073          	ecall
 ret
 830:	8082                	ret

0000000000000832 <putc>:

#include <stdarg.h>

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 832:	1101                	addi	sp,sp,-32
 834:	ec06                	sd	ra,24(sp)
 836:	e822                	sd	s0,16(sp)
 838:	1000                	addi	s0,sp,32
 83a:	feb407a3          	sb	a1,-17(s0)
 83e:	4605                	li	a2,1
 840:	fef40593          	addi	a1,s0,-17
 844:	00000097          	auipc	ra,0x0
 848:	f5e080e7          	jalr	-162(ra) # 7a2 <write>
 84c:	60e2                	ld	ra,24(sp)
 84e:	6442                	ld	s0,16(sp)
 850:	6105                	addi	sp,sp,32
 852:	8082                	ret

0000000000000854 <printint>:

static void printint(int fd, int xx, int base, int sgn) {
 854:	7139                	addi	sp,sp,-64
 856:	fc06                	sd	ra,56(sp)
 858:	f822                	sd	s0,48(sp)
 85a:	f426                	sd	s1,40(sp)
 85c:	f04a                	sd	s2,32(sp)
 85e:	ec4e                	sd	s3,24(sp)
 860:	0080                	addi	s0,sp,64
 862:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0) {
 864:	c299                	beqz	a3,86a <printint+0x16>
 866:	0805c963          	bltz	a1,8f8 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 86a:	2581                	sext.w	a1,a1
  neg = 0;
 86c:	4881                	li	a7,0
 86e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 872:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 874:	2601                	sext.w	a2,a2
 876:	00001517          	auipc	a0,0x1
 87a:	9f250513          	addi	a0,a0,-1550 # 1268 <digits>
 87e:	883a                	mv	a6,a4
 880:	2705                	addiw	a4,a4,1
 882:	02c5f7bb          	remuw	a5,a1,a2
 886:	1782                	slli	a5,a5,0x20
 888:	9381                	srli	a5,a5,0x20
 88a:	97aa                	add	a5,a5,a0
 88c:	0007c783          	lbu	a5,0(a5)
 890:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 894:	0005879b          	sext.w	a5,a1
 898:	02c5d5bb          	divuw	a1,a1,a2
 89c:	0685                	addi	a3,a3,1
 89e:	fec7f0e3          	bgeu	a5,a2,87e <printint+0x2a>
  if (neg) buf[i++] = '-';
 8a2:	00088c63          	beqz	a7,8ba <printint+0x66>
 8a6:	fd070793          	addi	a5,a4,-48
 8aa:	00878733          	add	a4,a5,s0
 8ae:	02d00793          	li	a5,45
 8b2:	fef70823          	sb	a5,-16(a4)
 8b6:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) putc(fd, buf[i]);
 8ba:	02e05863          	blez	a4,8ea <printint+0x96>
 8be:	fc040793          	addi	a5,s0,-64
 8c2:	00e78933          	add	s2,a5,a4
 8c6:	fff78993          	addi	s3,a5,-1
 8ca:	99ba                	add	s3,s3,a4
 8cc:	377d                	addiw	a4,a4,-1
 8ce:	1702                	slli	a4,a4,0x20
 8d0:	9301                	srli	a4,a4,0x20
 8d2:	40e989b3          	sub	s3,s3,a4
 8d6:	fff94583          	lbu	a1,-1(s2)
 8da:	8526                	mv	a0,s1
 8dc:	00000097          	auipc	ra,0x0
 8e0:	f56080e7          	jalr	-170(ra) # 832 <putc>
 8e4:	197d                	addi	s2,s2,-1
 8e6:	ff3918e3          	bne	s2,s3,8d6 <printint+0x82>
}
 8ea:	70e2                	ld	ra,56(sp)
 8ec:	7442                	ld	s0,48(sp)
 8ee:	74a2                	ld	s1,40(sp)
 8f0:	7902                	ld	s2,32(sp)
 8f2:	69e2                	ld	s3,24(sp)
 8f4:	6121                	addi	sp,sp,64
 8f6:	8082                	ret
    x = -xx;
 8f8:	40b005bb          	negw	a1,a1
    neg = 1;
 8fc:	4885                	li	a7,1
    x = -xx;
 8fe:	bf85                	j	86e <printint+0x1a>

0000000000000900 <vprintf>:
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap) {
 900:	7119                	addi	sp,sp,-128
 902:	fc86                	sd	ra,120(sp)
 904:	f8a2                	sd	s0,112(sp)
 906:	f4a6                	sd	s1,104(sp)
 908:	f0ca                	sd	s2,96(sp)
 90a:	ecce                	sd	s3,88(sp)
 90c:	e8d2                	sd	s4,80(sp)
 90e:	e4d6                	sd	s5,72(sp)
 910:	e0da                	sd	s6,64(sp)
 912:	fc5e                	sd	s7,56(sp)
 914:	f862                	sd	s8,48(sp)
 916:	f466                	sd	s9,40(sp)
 918:	f06a                	sd	s10,32(sp)
 91a:	ec6e                	sd	s11,24(sp)
 91c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 91e:	0005c903          	lbu	s2,0(a1)
 922:	18090f63          	beqz	s2,ac0 <vprintf+0x1c0>
 926:	8aaa                	mv	s5,a0
 928:	8b32                	mv	s6,a2
 92a:	00158493          	addi	s1,a1,1
  state = 0;
 92e:	4981                	li	s3,0
      if (c == '%') {
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if (state == '%') {
 930:	02500a13          	li	s4,37
 934:	4c55                	li	s8,21
 936:	00001c97          	auipc	s9,0x1
 93a:	8dac8c93          	addi	s9,s9,-1830 # 1210 <loop+0x478>
      } else if (c == 'p') {
        printptr(fd, va_arg(ap, uint64));
      } else if (c == 's') {
        s = va_arg(ap, char *);
        if (s == 0) s = "(null)";
        while (*s != 0) {
 93e:	02800d93          	li	s11,40
  putc(fd, 'x');
 942:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 944:	00001b97          	auipc	s7,0x1
 948:	924b8b93          	addi	s7,s7,-1756 # 1268 <digits>
 94c:	a839                	j	96a <vprintf+0x6a>
        putc(fd, c);
 94e:	85ca                	mv	a1,s2
 950:	8556                	mv	a0,s5
 952:	00000097          	auipc	ra,0x0
 956:	ee0080e7          	jalr	-288(ra) # 832 <putc>
 95a:	a019                	j	960 <vprintf+0x60>
    } else if (state == '%') {
 95c:	01498d63          	beq	s3,s4,976 <vprintf+0x76>
  for (i = 0; fmt[i]; i++) {
 960:	0485                	addi	s1,s1,1
 962:	fff4c903          	lbu	s2,-1(s1)
 966:	14090d63          	beqz	s2,ac0 <vprintf+0x1c0>
    if (state == 0) {
 96a:	fe0999e3          	bnez	s3,95c <vprintf+0x5c>
      if (c == '%') {
 96e:	ff4910e3          	bne	s2,s4,94e <vprintf+0x4e>
        state = '%';
 972:	89d2                	mv	s3,s4
 974:	b7f5                	j	960 <vprintf+0x60>
      if (c == 'd') {
 976:	11490c63          	beq	s2,s4,a8e <vprintf+0x18e>
 97a:	f9d9079b          	addiw	a5,s2,-99
 97e:	0ff7f793          	zext.b	a5,a5
 982:	10fc6e63          	bltu	s8,a5,a9e <vprintf+0x19e>
 986:	f9d9079b          	addiw	a5,s2,-99
 98a:	0ff7f713          	zext.b	a4,a5
 98e:	10ec6863          	bltu	s8,a4,a9e <vprintf+0x19e>
 992:	00271793          	slli	a5,a4,0x2
 996:	97e6                	add	a5,a5,s9
 998:	439c                	lw	a5,0(a5)
 99a:	97e6                	add	a5,a5,s9
 99c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 99e:	008b0913          	addi	s2,s6,8
 9a2:	4685                	li	a3,1
 9a4:	4629                	li	a2,10
 9a6:	000b2583          	lw	a1,0(s6)
 9aa:	8556                	mv	a0,s5
 9ac:	00000097          	auipc	ra,0x0
 9b0:	ea8080e7          	jalr	-344(ra) # 854 <printint>
 9b4:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 9b6:	4981                	li	s3,0
 9b8:	b765                	j	960 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 9ba:	008b0913          	addi	s2,s6,8
 9be:	4681                	li	a3,0
 9c0:	4629                	li	a2,10
 9c2:	000b2583          	lw	a1,0(s6)
 9c6:	8556                	mv	a0,s5
 9c8:	00000097          	auipc	ra,0x0
 9cc:	e8c080e7          	jalr	-372(ra) # 854 <printint>
 9d0:	8b4a                	mv	s6,s2
      state = 0;
 9d2:	4981                	li	s3,0
 9d4:	b771                	j	960 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 9d6:	008b0913          	addi	s2,s6,8
 9da:	4681                	li	a3,0
 9dc:	866a                	mv	a2,s10
 9de:	000b2583          	lw	a1,0(s6)
 9e2:	8556                	mv	a0,s5
 9e4:	00000097          	auipc	ra,0x0
 9e8:	e70080e7          	jalr	-400(ra) # 854 <printint>
 9ec:	8b4a                	mv	s6,s2
      state = 0;
 9ee:	4981                	li	s3,0
 9f0:	bf85                	j	960 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 9f2:	008b0793          	addi	a5,s6,8
 9f6:	f8f43423          	sd	a5,-120(s0)
 9fa:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 9fe:	03000593          	li	a1,48
 a02:	8556                	mv	a0,s5
 a04:	00000097          	auipc	ra,0x0
 a08:	e2e080e7          	jalr	-466(ra) # 832 <putc>
  putc(fd, 'x');
 a0c:	07800593          	li	a1,120
 a10:	8556                	mv	a0,s5
 a12:	00000097          	auipc	ra,0x0
 a16:	e20080e7          	jalr	-480(ra) # 832 <putc>
 a1a:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a1c:	03c9d793          	srli	a5,s3,0x3c
 a20:	97de                	add	a5,a5,s7
 a22:	0007c583          	lbu	a1,0(a5)
 a26:	8556                	mv	a0,s5
 a28:	00000097          	auipc	ra,0x0
 a2c:	e0a080e7          	jalr	-502(ra) # 832 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 a30:	0992                	slli	s3,s3,0x4
 a32:	397d                	addiw	s2,s2,-1
 a34:	fe0914e3          	bnez	s2,a1c <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 a38:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 a3c:	4981                	li	s3,0
 a3e:	b70d                	j	960 <vprintf+0x60>
        s = va_arg(ap, char *);
 a40:	008b0913          	addi	s2,s6,8
 a44:	000b3983          	ld	s3,0(s6)
        if (s == 0) s = "(null)";
 a48:	02098163          	beqz	s3,a6a <vprintf+0x16a>
        while (*s != 0) {
 a4c:	0009c583          	lbu	a1,0(s3)
 a50:	c5ad                	beqz	a1,aba <vprintf+0x1ba>
          putc(fd, *s);
 a52:	8556                	mv	a0,s5
 a54:	00000097          	auipc	ra,0x0
 a58:	dde080e7          	jalr	-546(ra) # 832 <putc>
          s++;
 a5c:	0985                	addi	s3,s3,1
        while (*s != 0) {
 a5e:	0009c583          	lbu	a1,0(s3)
 a62:	f9e5                	bnez	a1,a52 <vprintf+0x152>
        s = va_arg(ap, char *);
 a64:	8b4a                	mv	s6,s2
      state = 0;
 a66:	4981                	li	s3,0
 a68:	bde5                	j	960 <vprintf+0x60>
        if (s == 0) s = "(null)";
 a6a:	00000997          	auipc	s3,0x0
 a6e:	79e98993          	addi	s3,s3,1950 # 1208 <loop+0x470>
        while (*s != 0) {
 a72:	85ee                	mv	a1,s11
 a74:	bff9                	j	a52 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 a76:	008b0913          	addi	s2,s6,8
 a7a:	000b4583          	lbu	a1,0(s6)
 a7e:	8556                	mv	a0,s5
 a80:	00000097          	auipc	ra,0x0
 a84:	db2080e7          	jalr	-590(ra) # 832 <putc>
 a88:	8b4a                	mv	s6,s2
      state = 0;
 a8a:	4981                	li	s3,0
 a8c:	bdd1                	j	960 <vprintf+0x60>
        putc(fd, c);
 a8e:	85d2                	mv	a1,s4
 a90:	8556                	mv	a0,s5
 a92:	00000097          	auipc	ra,0x0
 a96:	da0080e7          	jalr	-608(ra) # 832 <putc>
      state = 0;
 a9a:	4981                	li	s3,0
 a9c:	b5d1                	j	960 <vprintf+0x60>
        putc(fd, '%');
 a9e:	85d2                	mv	a1,s4
 aa0:	8556                	mv	a0,s5
 aa2:	00000097          	auipc	ra,0x0
 aa6:	d90080e7          	jalr	-624(ra) # 832 <putc>
        putc(fd, c);
 aaa:	85ca                	mv	a1,s2
 aac:	8556                	mv	a0,s5
 aae:	00000097          	auipc	ra,0x0
 ab2:	d84080e7          	jalr	-636(ra) # 832 <putc>
      state = 0;
 ab6:	4981                	li	s3,0
 ab8:	b565                	j	960 <vprintf+0x60>
        s = va_arg(ap, char *);
 aba:	8b4a                	mv	s6,s2
      state = 0;
 abc:	4981                	li	s3,0
 abe:	b54d                	j	960 <vprintf+0x60>
    }
  }
}
 ac0:	70e6                	ld	ra,120(sp)
 ac2:	7446                	ld	s0,112(sp)
 ac4:	74a6                	ld	s1,104(sp)
 ac6:	7906                	ld	s2,96(sp)
 ac8:	69e6                	ld	s3,88(sp)
 aca:	6a46                	ld	s4,80(sp)
 acc:	6aa6                	ld	s5,72(sp)
 ace:	6b06                	ld	s6,64(sp)
 ad0:	7be2                	ld	s7,56(sp)
 ad2:	7c42                	ld	s8,48(sp)
 ad4:	7ca2                	ld	s9,40(sp)
 ad6:	7d02                	ld	s10,32(sp)
 ad8:	6de2                	ld	s11,24(sp)
 ada:	6109                	addi	sp,sp,128
 adc:	8082                	ret

0000000000000ade <fprintf>:

void fprintf(int fd, const char *fmt, ...) {
 ade:	715d                	addi	sp,sp,-80
 ae0:	ec06                	sd	ra,24(sp)
 ae2:	e822                	sd	s0,16(sp)
 ae4:	1000                	addi	s0,sp,32
 ae6:	e010                	sd	a2,0(s0)
 ae8:	e414                	sd	a3,8(s0)
 aea:	e818                	sd	a4,16(s0)
 aec:	ec1c                	sd	a5,24(s0)
 aee:	03043023          	sd	a6,32(s0)
 af2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 af6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 afa:	8622                	mv	a2,s0
 afc:	00000097          	auipc	ra,0x0
 b00:	e04080e7          	jalr	-508(ra) # 900 <vprintf>
}
 b04:	60e2                	ld	ra,24(sp)
 b06:	6442                	ld	s0,16(sp)
 b08:	6161                	addi	sp,sp,80
 b0a:	8082                	ret

0000000000000b0c <printf>:

void printf(const char *fmt, ...) {
 b0c:	711d                	addi	sp,sp,-96
 b0e:	ec06                	sd	ra,24(sp)
 b10:	e822                	sd	s0,16(sp)
 b12:	1000                	addi	s0,sp,32
 b14:	e40c                	sd	a1,8(s0)
 b16:	e810                	sd	a2,16(s0)
 b18:	ec14                	sd	a3,24(s0)
 b1a:	f018                	sd	a4,32(s0)
 b1c:	f41c                	sd	a5,40(s0)
 b1e:	03043823          	sd	a6,48(s0)
 b22:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b26:	00840613          	addi	a2,s0,8
 b2a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 b2e:	85aa                	mv	a1,a0
 b30:	4505                	li	a0,1
 b32:	00000097          	auipc	ra,0x0
 b36:	dce080e7          	jalr	-562(ra) # 900 <vprintf>
}
 b3a:	60e2                	ld	ra,24(sp)
 b3c:	6442                	ld	s0,16(sp)
 b3e:	6125                	addi	sp,sp,96
 b40:	8082                	ret

0000000000000b42 <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
 b42:	1141                	addi	sp,sp,-16
 b44:	e422                	sd	s0,8(sp)
 b46:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 b48:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b4c:	00001797          	auipc	a5,0x1
 b50:	4bc7b783          	ld	a5,1212(a5) # 2008 <freep>
 b54:	a02d                	j	b7e <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 b56:	4618                	lw	a4,8(a2)
 b58:	9f2d                	addw	a4,a4,a1
 b5a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b5e:	6398                	ld	a4,0(a5)
 b60:	6310                	ld	a2,0(a4)
 b62:	a83d                	j	ba0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 b64:	ff852703          	lw	a4,-8(a0)
 b68:	9f31                	addw	a4,a4,a2
 b6a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b6c:	ff053683          	ld	a3,-16(a0)
 b70:	a091                	j	bb4 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 b72:	6398                	ld	a4,0(a5)
 b74:	00e7e463          	bltu	a5,a4,b7c <free+0x3a>
 b78:	00e6ea63          	bltu	a3,a4,b8c <free+0x4a>
void free(void *ap) {
 b7c:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b7e:	fed7fae3          	bgeu	a5,a3,b72 <free+0x30>
 b82:	6398                	ld	a4,0(a5)
 b84:	00e6e463          	bltu	a3,a4,b8c <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 b88:	fee7eae3          	bltu	a5,a4,b7c <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 b8c:	ff852583          	lw	a1,-8(a0)
 b90:	6390                	ld	a2,0(a5)
 b92:	02059813          	slli	a6,a1,0x20
 b96:	01c85713          	srli	a4,a6,0x1c
 b9a:	9736                	add	a4,a4,a3
 b9c:	fae60de3          	beq	a2,a4,b56 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 ba0:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 ba4:	4790                	lw	a2,8(a5)
 ba6:	02061593          	slli	a1,a2,0x20
 baa:	01c5d713          	srli	a4,a1,0x1c
 bae:	973e                	add	a4,a4,a5
 bb0:	fae68ae3          	beq	a3,a4,b64 <free+0x22>
    p->s.ptr = bp->s.ptr;
 bb4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 bb6:	00001717          	auipc	a4,0x1
 bba:	44f73923          	sd	a5,1106(a4) # 2008 <freep>
}
 bbe:	6422                	ld	s0,8(sp)
 bc0:	0141                	addi	sp,sp,16
 bc2:	8082                	ret

0000000000000bc4 <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
 bc4:	7139                	addi	sp,sp,-64
 bc6:	fc06                	sd	ra,56(sp)
 bc8:	f822                	sd	s0,48(sp)
 bca:	f426                	sd	s1,40(sp)
 bcc:	f04a                	sd	s2,32(sp)
 bce:	ec4e                	sd	s3,24(sp)
 bd0:	e852                	sd	s4,16(sp)
 bd2:	e456                	sd	s5,8(sp)
 bd4:	e05a                	sd	s6,0(sp)
 bd6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 bd8:	02051493          	slli	s1,a0,0x20
 bdc:	9081                	srli	s1,s1,0x20
 bde:	04bd                	addi	s1,s1,15
 be0:	8091                	srli	s1,s1,0x4
 be2:	0014899b          	addiw	s3,s1,1
 be6:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 be8:	00001517          	auipc	a0,0x1
 bec:	42053503          	ld	a0,1056(a0) # 2008 <freep>
 bf0:	c515                	beqz	a0,c1c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 bf2:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 bf4:	4798                	lw	a4,8(a5)
 bf6:	02977f63          	bgeu	a4,s1,c34 <malloc+0x70>
 bfa:	8a4e                	mv	s4,s3
 bfc:	0009871b          	sext.w	a4,s3
 c00:	6685                	lui	a3,0x1
 c02:	00d77363          	bgeu	a4,a3,c08 <malloc+0x44>
 c06:	6a05                	lui	s4,0x1
 c08:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c0c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 c10:	00001917          	auipc	s2,0x1
 c14:	3f890913          	addi	s2,s2,1016 # 2008 <freep>
  if (p == (char *)-1) return 0;
 c18:	5afd                	li	s5,-1
 c1a:	a895                	j	c8e <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 c1c:	00001797          	auipc	a5,0x1
 c20:	3f478793          	addi	a5,a5,1012 # 2010 <base>
 c24:	00001717          	auipc	a4,0x1
 c28:	3ef73223          	sd	a5,996(a4) # 2008 <freep>
 c2c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 c2e:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 c32:	b7e1                	j	bfa <malloc+0x36>
      if (p->s.size == nunits)
 c34:	02e48c63          	beq	s1,a4,c6c <malloc+0xa8>
        p->s.size -= nunits;
 c38:	4137073b          	subw	a4,a4,s3
 c3c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c3e:	02071693          	slli	a3,a4,0x20
 c42:	01c6d713          	srli	a4,a3,0x1c
 c46:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c48:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c4c:	00001717          	auipc	a4,0x1
 c50:	3aa73e23          	sd	a0,956(a4) # 2008 <freep>
      return (void *)(p + 1);
 c54:	01078513          	addi	a0,a5,16
      if ((p = morecore(nunits)) == 0) return 0;
  }
}
 c58:	70e2                	ld	ra,56(sp)
 c5a:	7442                	ld	s0,48(sp)
 c5c:	74a2                	ld	s1,40(sp)
 c5e:	7902                	ld	s2,32(sp)
 c60:	69e2                	ld	s3,24(sp)
 c62:	6a42                	ld	s4,16(sp)
 c64:	6aa2                	ld	s5,8(sp)
 c66:	6b02                	ld	s6,0(sp)
 c68:	6121                	addi	sp,sp,64
 c6a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 c6c:	6398                	ld	a4,0(a5)
 c6e:	e118                	sd	a4,0(a0)
 c70:	bff1                	j	c4c <malloc+0x88>
  hp->s.size = nu;
 c72:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 c76:	0541                	addi	a0,a0,16
 c78:	00000097          	auipc	ra,0x0
 c7c:	eca080e7          	jalr	-310(ra) # b42 <free>
  return freep;
 c80:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0) return 0;
 c84:	d971                	beqz	a0,c58 <malloc+0x94>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 c86:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 c88:	4798                	lw	a4,8(a5)
 c8a:	fa9775e3          	bgeu	a4,s1,c34 <malloc+0x70>
    if (p == freep)
 c8e:	00093703          	ld	a4,0(s2)
 c92:	853e                	mv	a0,a5
 c94:	fef719e3          	bne	a4,a5,c86 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 c98:	8552                	mv	a0,s4
 c9a:	00000097          	auipc	ra,0x0
 c9e:	b70080e7          	jalr	-1168(ra) # 80a <sbrk>
  if (p == (char *)-1) return 0;
 ca2:	fd5518e3          	bne	a0,s5,c72 <malloc+0xae>
      if ((p = morecore(nunits)) == 0) return 0;
 ca6:	4501                	li	a0,0
 ca8:	bf45                	j	c58 <malloc+0x94>

0000000000000caa <dump_test2_asm>:
#include "kernel/syscall.h"
.globl dump_test2_asm
dump_test2_asm:
  li s2, 2
 caa:	4909                	li	s2,2
  li s3, 3
 cac:	498d                	li	s3,3
  li s4, 4
 cae:	4a11                	li	s4,4
  li s5, 5
 cb0:	4a95                	li	s5,5
  li s6, 6
 cb2:	4b19                	li	s6,6
  li s7, 7
 cb4:	4b9d                	li	s7,7
  li s8, 8
 cb6:	4c21                	li	s8,8
  li s9, 9
 cb8:	4ca5                	li	s9,9
  li s10, 10
 cba:	4d29                	li	s10,10
  li s11, 11
 cbc:	4dad                	li	s11,11
#ifdef SYS_dump
  li a7, SYS_dump
 cbe:	48d9                	li	a7,22
  ecall
 cc0:	00000073          	ecall
#endif
  ret
 cc4:	8082                	ret

0000000000000cc6 <dump_test3_asm>:
.globl dump_test3_asm
dump_test3_asm:
  li s2, 1
 cc6:	4905                	li	s2,1
  li s3, -12
 cc8:	59d1                	li	s3,-12
  li s4, 123
 cca:	07b00a13          	li	s4,123
  li s5, -1234
 cce:	b2e00a93          	li	s5,-1234
  li s6, 12345
 cd2:	6b0d                	lui	s6,0x3
 cd4:	039b0b1b          	addiw	s6,s6,57 # 3039 <base+0x1029>
  li s7, -123456
 cd8:	7b89                	lui	s7,0xfffe2
 cda:	dc0b8b9b          	addiw	s7,s7,-576 # fffffffffffe1dc0 <base+0xfffffffffffdfdb0>
  li s8, 1234567
 cde:	0012dc37          	lui	s8,0x12d
 ce2:	687c0c1b          	addiw	s8,s8,1671 # 12d687 <base+0x12b677>
  li s9, -12345678
 ce6:	ff43acb7          	lui	s9,0xff43a
 cea:	eb2c8c9b          	addiw	s9,s9,-334 # ffffffffff439eb2 <base+0xffffffffff437ea2>
  li s10, 123456789
 cee:	075bdd37          	lui	s10,0x75bd
 cf2:	d15d0d1b          	addiw	s10,s10,-747 # 75bcd15 <base+0x75bad05>
  li s11, -1234567890
 cf6:	b66a0db7          	lui	s11,0xb66a0
 cfa:	d2ed8d9b          	addiw	s11,s11,-722 # ffffffffb669fd2e <base+0xffffffffb669dd1e>
#ifdef SYS_dump
  li a7, SYS_dump
 cfe:	48d9                	li	a7,22
  ecall
 d00:	00000073          	ecall
#endif
  ret
 d04:	8082                	ret

0000000000000d06 <dump_test4_asm>:
.globl dump_test4_asm
dump_test4_asm:
  li s2, 2147483647
 d06:	80000937          	lui	s2,0x80000
 d0a:	397d                	addiw	s2,s2,-1 # 7fffffff <base+0x7fffdfef>
  li s3, -2147483648
 d0c:	800009b7          	lui	s3,0x80000
  li s4, 1337
 d10:	53900a13          	li	s4,1337
  li s5, 2020
 d14:	7e400a93          	li	s5,2020
  li s6, 3234
 d18:	6b05                	lui	s6,0x1
 d1a:	ca2b0b1b          	addiw	s6,s6,-862 # ca2 <malloc+0xde>
  li s7, 3235
 d1e:	6b85                	lui	s7,0x1
 d20:	ca3b8b9b          	addiw	s7,s7,-861 # ca3 <malloc+0xdf>
  li s8, 3236
 d24:	6c05                	lui	s8,0x1
 d26:	ca4c0c1b          	addiw	s8,s8,-860 # ca4 <malloc+0xe0>
  li s9, 3237
 d2a:	6c85                	lui	s9,0x1
 d2c:	ca5c8c9b          	addiw	s9,s9,-859 # ca5 <malloc+0xe1>
  li s10, 3238
 d30:	6d05                	lui	s10,0x1
 d32:	ca6d0d1b          	addiw	s10,s10,-858 # ca6 <malloc+0xe2>
  li s11, 3239
 d36:	6d85                	lui	s11,0x1
 d38:	ca7d8d9b          	addiw	s11,s11,-857 # ca7 <malloc+0xe3>
#ifdef SYS_dump
  li a7, SYS_dump
 d3c:	48d9                	li	a7,22
  ecall
 d3e:	00000073          	ecall
#endif
  ret
 d42:	8082                	ret

0000000000000d44 <dump2_test1_asm>:
#include "kernel/syscall.h"
.globl dump2_test1_asm
dump2_test1_asm:
  li s2, 2
 d44:	4909                	li	s2,2
  li s3, 3
 d46:	498d                	li	s3,3
  li s4, 4
 d48:	4a11                	li	s4,4
  li s5, 5
 d4a:	4a95                	li	s5,5
  li s6, 6
 d4c:	4b19                	li	s6,6
  li s7, 7
 d4e:	4b9d                	li	s7,7
  li s8, 8
 d50:	4c21                	li	s8,8
  li s9, 9
 d52:	4ca5                	li	s9,9
  li s10, 10
 d54:	4d29                	li	s10,10
  li s11, 11
 d56:	4dad                	li	s11,11
  li a7, SYS_write
 d58:	48c1                	li	a7,16
  ecall
 d5a:	00000073          	ecall
  j loop
 d5e:	a82d                	j	d98 <loop>

0000000000000d60 <dump2_test2_asm>:

.globl dump2_test2_asm
dump2_test2_asm:
  li s2, 4
 d60:	4911                	li	s2,4
  li s3, 9
 d62:	49a5                	li	s3,9
  li s4, 16
 d64:	4a41                	li	s4,16
  li s5, 25
 d66:	4ae5                	li	s5,25
  li s6, 36
 d68:	02400b13          	li	s6,36
  li s7, 49
 d6c:	03100b93          	li	s7,49
  li s8, 64
 d70:	04000c13          	li	s8,64
  li s9, 81
 d74:	05100c93          	li	s9,81
  li s10, 100
 d78:	06400d13          	li	s10,100
  li s11, 121
 d7c:	07900d93          	li	s11,121
  li a7, SYS_write
 d80:	48c1                	li	a7,16
  ecall
 d82:	00000073          	ecall
  j loop
 d86:	a809                	j	d98 <loop>

0000000000000d88 <dump2_test3_asm>:

.globl dump2_test3_asm
dump2_test3_asm:
  li s2, 1337
 d88:	53900913          	li	s2,1337
  mv a2, a1
 d8c:	862e                	mv	a2,a1
  li a1, 2
 d8e:	4589                	li	a1,2
#ifdef SYS_dump2
  li a7, SYS_dump2
 d90:	48dd                	li	a7,23
  ecall
 d92:	00000073          	ecall
#endif
  ret
 d96:	8082                	ret

0000000000000d98 <loop>:

loop:
  j loop
 d98:	a001                	j	d98 <loop>
  ret
 d9a:	8082                	ret
