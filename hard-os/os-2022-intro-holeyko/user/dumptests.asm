
user/_dumptests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test1>:
  exit(0);
}

#ifdef SYS_dump

void test1() {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  printf("#####################\n");
   8:	00001517          	auipc	a0,0x1
   c:	d7850513          	addi	a0,a0,-648 # d80 <loop+0x12>
  10:	00001097          	auipc	ra,0x1
  14:	ad2080e7          	jalr	-1326(ra) # ae2 <printf>
  printf("#                   #\n");
  18:	00001517          	auipc	a0,0x1
  1c:	d8050513          	addi	a0,a0,-640 # d98 <loop+0x2a>
  20:	00001097          	auipc	ra,0x1
  24:	ac2080e7          	jalr	-1342(ra) # ae2 <printf>
  printf("#   initial state   #\n");
  28:	00001517          	auipc	a0,0x1
  2c:	d8850513          	addi	a0,a0,-632 # db0 <loop+0x42>
  30:	00001097          	auipc	ra,0x1
  34:	ab2080e7          	jalr	-1358(ra) # ae2 <printf>
  printf("#                   #\n");
  38:	00001517          	auipc	a0,0x1
  3c:	d6050513          	addi	a0,a0,-672 # d98 <loop+0x2a>
  40:	00001097          	auipc	ra,0x1
  44:	aa2080e7          	jalr	-1374(ra) # ae2 <printf>
  printf("#####################\n");
  48:	00001517          	auipc	a0,0x1
  4c:	d3850513          	addi	a0,a0,-712 # d80 <loop+0x12>
  50:	00001097          	auipc	ra,0x1
  54:	a92080e7          	jalr	-1390(ra) # ae2 <printf>
  dump();
  58:	00000097          	auipc	ra,0x0
  5c:	7a0080e7          	jalr	1952(ra) # 7f8 <dump>
}
  60:	60a2                	ld	ra,8(sp)
  62:	6402                	ld	s0,0(sp)
  64:	0141                	addi	sp,sp,16
  66:	8082                	ret

0000000000000068 <test2>:

int dump_test2_asm();

void test2() {
  68:	1141                	addi	sp,sp,-16
  6a:	e406                	sd	ra,8(sp)
  6c:	e022                	sd	s0,0(sp)
  6e:	0800                	addi	s0,sp,16
  printf("#####################\n");
  70:	00001517          	auipc	a0,0x1
  74:	d1050513          	addi	a0,a0,-752 # d80 <loop+0x12>
  78:	00001097          	auipc	ra,0x1
  7c:	a6a080e7          	jalr	-1430(ra) # ae2 <printf>
  printf("#                   #\n");
  80:	00001517          	auipc	a0,0x1
  84:	d1850513          	addi	a0,a0,-744 # d98 <loop+0x2a>
  88:	00001097          	auipc	ra,0x1
  8c:	a5a080e7          	jalr	-1446(ra) # ae2 <printf>
  printf("#       test 1      #\n");
  90:	00001517          	auipc	a0,0x1
  94:	d3850513          	addi	a0,a0,-712 # dc8 <loop+0x5a>
  98:	00001097          	auipc	ra,0x1
  9c:	a4a080e7          	jalr	-1462(ra) # ae2 <printf>
  printf("#                   #\n");
  a0:	00001517          	auipc	a0,0x1
  a4:	cf850513          	addi	a0,a0,-776 # d98 <loop+0x2a>
  a8:	00001097          	auipc	ra,0x1
  ac:	a3a080e7          	jalr	-1478(ra) # ae2 <printf>
  printf("#####################\n");
  b0:	00001517          	auipc	a0,0x1
  b4:	cd050513          	addi	a0,a0,-816 # d80 <loop+0x12>
  b8:	00001097          	auipc	ra,0x1
  bc:	a2a080e7          	jalr	-1494(ra) # ae2 <printf>
  printf("#                   #\n");
  c0:	00001517          	auipc	a0,0x1
  c4:	cd850513          	addi	a0,a0,-808 # d98 <loop+0x2a>
  c8:	00001097          	auipc	ra,0x1
  cc:	a1a080e7          	jalr	-1510(ra) # ae2 <printf>
  printf("#  expected values  #\n");
  d0:	00001517          	auipc	a0,0x1
  d4:	d1050513          	addi	a0,a0,-752 # de0 <loop+0x72>
  d8:	00001097          	auipc	ra,0x1
  dc:	a0a080e7          	jalr	-1526(ra) # ae2 <printf>
  printf("#                   #\n");
  e0:	00001517          	auipc	a0,0x1
  e4:	cb850513          	addi	a0,a0,-840 # d98 <loop+0x2a>
  e8:	00001097          	auipc	ra,0x1
  ec:	9fa080e7          	jalr	-1542(ra) # ae2 <printf>
  printf("#####################\n");
  f0:	00001517          	auipc	a0,0x1
  f4:	c9050513          	addi	a0,a0,-880 # d80 <loop+0x12>
  f8:	00001097          	auipc	ra,0x1
  fc:	9ea080e7          	jalr	-1558(ra) # ae2 <printf>
  printf("# s2  = 2           #\n");
 100:	00001517          	auipc	a0,0x1
 104:	cf850513          	addi	a0,a0,-776 # df8 <loop+0x8a>
 108:	00001097          	auipc	ra,0x1
 10c:	9da080e7          	jalr	-1574(ra) # ae2 <printf>
  printf("# s3  = 3           #\n");
 110:	00001517          	auipc	a0,0x1
 114:	d0050513          	addi	a0,a0,-768 # e10 <loop+0xa2>
 118:	00001097          	auipc	ra,0x1
 11c:	9ca080e7          	jalr	-1590(ra) # ae2 <printf>
  printf("# s4  = 4           #\n");
 120:	00001517          	auipc	a0,0x1
 124:	d0850513          	addi	a0,a0,-760 # e28 <loop+0xba>
 128:	00001097          	auipc	ra,0x1
 12c:	9ba080e7          	jalr	-1606(ra) # ae2 <printf>
  printf("# s5  = 5           #\n");
 130:	00001517          	auipc	a0,0x1
 134:	d1050513          	addi	a0,a0,-752 # e40 <loop+0xd2>
 138:	00001097          	auipc	ra,0x1
 13c:	9aa080e7          	jalr	-1622(ra) # ae2 <printf>
  printf("# s6  = 6           #\n");
 140:	00001517          	auipc	a0,0x1
 144:	d1850513          	addi	a0,a0,-744 # e58 <loop+0xea>
 148:	00001097          	auipc	ra,0x1
 14c:	99a080e7          	jalr	-1638(ra) # ae2 <printf>
  printf("# s7  = 7           #\n");
 150:	00001517          	auipc	a0,0x1
 154:	d2050513          	addi	a0,a0,-736 # e70 <loop+0x102>
 158:	00001097          	auipc	ra,0x1
 15c:	98a080e7          	jalr	-1654(ra) # ae2 <printf>
  printf("# s8  = 8           #\n");
 160:	00001517          	auipc	a0,0x1
 164:	d2850513          	addi	a0,a0,-728 # e88 <loop+0x11a>
 168:	00001097          	auipc	ra,0x1
 16c:	97a080e7          	jalr	-1670(ra) # ae2 <printf>
  printf("# s9  = 9           #\n");
 170:	00001517          	auipc	a0,0x1
 174:	d3050513          	addi	a0,a0,-720 # ea0 <loop+0x132>
 178:	00001097          	auipc	ra,0x1
 17c:	96a080e7          	jalr	-1686(ra) # ae2 <printf>
  printf("# s10 = 10          #\n");
 180:	00001517          	auipc	a0,0x1
 184:	d3850513          	addi	a0,a0,-712 # eb8 <loop+0x14a>
 188:	00001097          	auipc	ra,0x1
 18c:	95a080e7          	jalr	-1702(ra) # ae2 <printf>
  printf("# s11 = 11          #\n");
 190:	00001517          	auipc	a0,0x1
 194:	d4050513          	addi	a0,a0,-704 # ed0 <loop+0x162>
 198:	00001097          	auipc	ra,0x1
 19c:	94a080e7          	jalr	-1718(ra) # ae2 <printf>
  printf("#####################\n");
 1a0:	00001517          	auipc	a0,0x1
 1a4:	be050513          	addi	a0,a0,-1056 # d80 <loop+0x12>
 1a8:	00001097          	auipc	ra,0x1
 1ac:	93a080e7          	jalr	-1734(ra) # ae2 <printf>
  dump_test2_asm();
 1b0:	00001097          	auipc	ra,0x1
 1b4:	ad0080e7          	jalr	-1328(ra) # c80 <dump_test2_asm>
}
 1b8:	60a2                	ld	ra,8(sp)
 1ba:	6402                	ld	s0,0(sp)
 1bc:	0141                	addi	sp,sp,16
 1be:	8082                	ret

00000000000001c0 <test3>:

int dump_test3_asm();

void test3() {
 1c0:	1141                	addi	sp,sp,-16
 1c2:	e406                	sd	ra,8(sp)
 1c4:	e022                	sd	s0,0(sp)
 1c6:	0800                	addi	s0,sp,16
  printf("#####################\n");
 1c8:	00001517          	auipc	a0,0x1
 1cc:	bb850513          	addi	a0,a0,-1096 # d80 <loop+0x12>
 1d0:	00001097          	auipc	ra,0x1
 1d4:	912080e7          	jalr	-1774(ra) # ae2 <printf>
  printf("#                   #\n");
 1d8:	00001517          	auipc	a0,0x1
 1dc:	bc050513          	addi	a0,a0,-1088 # d98 <loop+0x2a>
 1e0:	00001097          	auipc	ra,0x1
 1e4:	902080e7          	jalr	-1790(ra) # ae2 <printf>
  printf("#      test 2       #\n");
 1e8:	00001517          	auipc	a0,0x1
 1ec:	d0050513          	addi	a0,a0,-768 # ee8 <loop+0x17a>
 1f0:	00001097          	auipc	ra,0x1
 1f4:	8f2080e7          	jalr	-1806(ra) # ae2 <printf>
  printf("#                   #\n");
 1f8:	00001517          	auipc	a0,0x1
 1fc:	ba050513          	addi	a0,a0,-1120 # d98 <loop+0x2a>
 200:	00001097          	auipc	ra,0x1
 204:	8e2080e7          	jalr	-1822(ra) # ae2 <printf>
  printf("#####################\n");
 208:	00001517          	auipc	a0,0x1
 20c:	b7850513          	addi	a0,a0,-1160 # d80 <loop+0x12>
 210:	00001097          	auipc	ra,0x1
 214:	8d2080e7          	jalr	-1838(ra) # ae2 <printf>
  printf("#                   #\n");
 218:	00001517          	auipc	a0,0x1
 21c:	b8050513          	addi	a0,a0,-1152 # d98 <loop+0x2a>
 220:	00001097          	auipc	ra,0x1
 224:	8c2080e7          	jalr	-1854(ra) # ae2 <printf>
  printf("#  expected values  #\n");
 228:	00001517          	auipc	a0,0x1
 22c:	bb850513          	addi	a0,a0,-1096 # de0 <loop+0x72>
 230:	00001097          	auipc	ra,0x1
 234:	8b2080e7          	jalr	-1870(ra) # ae2 <printf>
  printf("#                   #\n");
 238:	00001517          	auipc	a0,0x1
 23c:	b6050513          	addi	a0,a0,-1184 # d98 <loop+0x2a>
 240:	00001097          	auipc	ra,0x1
 244:	8a2080e7          	jalr	-1886(ra) # ae2 <printf>
  printf("#####################\n");
 248:	00001517          	auipc	a0,0x1
 24c:	b3850513          	addi	a0,a0,-1224 # d80 <loop+0x12>
 250:	00001097          	auipc	ra,0x1
 254:	892080e7          	jalr	-1902(ra) # ae2 <printf>
  printf("# s2 = 1            #\n");
 258:	00001517          	auipc	a0,0x1
 25c:	ca850513          	addi	a0,a0,-856 # f00 <loop+0x192>
 260:	00001097          	auipc	ra,0x1
 264:	882080e7          	jalr	-1918(ra) # ae2 <printf>
  printf("# s3 = -12          #\n");
 268:	00001517          	auipc	a0,0x1
 26c:	cb050513          	addi	a0,a0,-848 # f18 <loop+0x1aa>
 270:	00001097          	auipc	ra,0x1
 274:	872080e7          	jalr	-1934(ra) # ae2 <printf>
  printf("# s4 = 123          #\n");
 278:	00001517          	auipc	a0,0x1
 27c:	cb850513          	addi	a0,a0,-840 # f30 <loop+0x1c2>
 280:	00001097          	auipc	ra,0x1
 284:	862080e7          	jalr	-1950(ra) # ae2 <printf>
  printf("# s5 = -1234        #\n");
 288:	00001517          	auipc	a0,0x1
 28c:	cc050513          	addi	a0,a0,-832 # f48 <loop+0x1da>
 290:	00001097          	auipc	ra,0x1
 294:	852080e7          	jalr	-1966(ra) # ae2 <printf>
  printf("# s6 = 12345        #\n");
 298:	00001517          	auipc	a0,0x1
 29c:	cc850513          	addi	a0,a0,-824 # f60 <loop+0x1f2>
 2a0:	00001097          	auipc	ra,0x1
 2a4:	842080e7          	jalr	-1982(ra) # ae2 <printf>
  printf("# s7 = -123456      #\n");
 2a8:	00001517          	auipc	a0,0x1
 2ac:	cd050513          	addi	a0,a0,-816 # f78 <loop+0x20a>
 2b0:	00001097          	auipc	ra,0x1
 2b4:	832080e7          	jalr	-1998(ra) # ae2 <printf>
  printf("# s8 = 1234567      #\n");
 2b8:	00001517          	auipc	a0,0x1
 2bc:	cd850513          	addi	a0,a0,-808 # f90 <loop+0x222>
 2c0:	00001097          	auipc	ra,0x1
 2c4:	822080e7          	jalr	-2014(ra) # ae2 <printf>
  printf("# s9 = -12345678    #\n");
 2c8:	00001517          	auipc	a0,0x1
 2cc:	ce050513          	addi	a0,a0,-800 # fa8 <loop+0x23a>
 2d0:	00001097          	auipc	ra,0x1
 2d4:	812080e7          	jalr	-2030(ra) # ae2 <printf>
  printf("# s10 = 123456789   #\n");
 2d8:	00001517          	auipc	a0,0x1
 2dc:	ce850513          	addi	a0,a0,-792 # fc0 <loop+0x252>
 2e0:	00001097          	auipc	ra,0x1
 2e4:	802080e7          	jalr	-2046(ra) # ae2 <printf>
  printf("# s11 = -1234567890 #\n");
 2e8:	00001517          	auipc	a0,0x1
 2ec:	cf050513          	addi	a0,a0,-784 # fd8 <loop+0x26a>
 2f0:	00000097          	auipc	ra,0x0
 2f4:	7f2080e7          	jalr	2034(ra) # ae2 <printf>
  printf("#####################\n");
 2f8:	00001517          	auipc	a0,0x1
 2fc:	a8850513          	addi	a0,a0,-1400 # d80 <loop+0x12>
 300:	00000097          	auipc	ra,0x0
 304:	7e2080e7          	jalr	2018(ra) # ae2 <printf>
  dump_test3_asm();
 308:	00001097          	auipc	ra,0x1
 30c:	994080e7          	jalr	-1644(ra) # c9c <dump_test3_asm>
}
 310:	60a2                	ld	ra,8(sp)
 312:	6402                	ld	s0,0(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret

0000000000000318 <test4>:

int dump_test4_asm();

void test4() {
 318:	1141                	addi	sp,sp,-16
 31a:	e406                	sd	ra,8(sp)
 31c:	e022                	sd	s0,0(sp)
 31e:	0800                	addi	s0,sp,16
  printf("#####################\n");
 320:	00001517          	auipc	a0,0x1
 324:	a6050513          	addi	a0,a0,-1440 # d80 <loop+0x12>
 328:	00000097          	auipc	ra,0x0
 32c:	7ba080e7          	jalr	1978(ra) # ae2 <printf>
  printf("#                   #\n");
 330:	00001517          	auipc	a0,0x1
 334:	a6850513          	addi	a0,a0,-1432 # d98 <loop+0x2a>
 338:	00000097          	auipc	ra,0x0
 33c:	7aa080e7          	jalr	1962(ra) # ae2 <printf>
  printf("#      test 3       #\n");
 340:	00001517          	auipc	a0,0x1
 344:	cb050513          	addi	a0,a0,-848 # ff0 <loop+0x282>
 348:	00000097          	auipc	ra,0x0
 34c:	79a080e7          	jalr	1946(ra) # ae2 <printf>
  printf("#                   #\n");
 350:	00001517          	auipc	a0,0x1
 354:	a4850513          	addi	a0,a0,-1464 # d98 <loop+0x2a>
 358:	00000097          	auipc	ra,0x0
 35c:	78a080e7          	jalr	1930(ra) # ae2 <printf>
  printf("#####################\n");
 360:	00001517          	auipc	a0,0x1
 364:	a2050513          	addi	a0,a0,-1504 # d80 <loop+0x12>
 368:	00000097          	auipc	ra,0x0
 36c:	77a080e7          	jalr	1914(ra) # ae2 <printf>
  printf("#                   #\n");
 370:	00001517          	auipc	a0,0x1
 374:	a2850513          	addi	a0,a0,-1496 # d98 <loop+0x2a>
 378:	00000097          	auipc	ra,0x0
 37c:	76a080e7          	jalr	1898(ra) # ae2 <printf>
  printf("#  expected values  #\n");
 380:	00001517          	auipc	a0,0x1
 384:	a6050513          	addi	a0,a0,-1440 # de0 <loop+0x72>
 388:	00000097          	auipc	ra,0x0
 38c:	75a080e7          	jalr	1882(ra) # ae2 <printf>
  printf("#                   #\n");
 390:	00001517          	auipc	a0,0x1
 394:	a0850513          	addi	a0,a0,-1528 # d98 <loop+0x2a>
 398:	00000097          	auipc	ra,0x0
 39c:	74a080e7          	jalr	1866(ra) # ae2 <printf>
  printf("#####################\n");
 3a0:	00001517          	auipc	a0,0x1
 3a4:	9e050513          	addi	a0,a0,-1568 # d80 <loop+0x12>
 3a8:	00000097          	auipc	ra,0x0
 3ac:	73a080e7          	jalr	1850(ra) # ae2 <printf>
  printf("# s2 = 2147483647   #\n");
 3b0:	00001517          	auipc	a0,0x1
 3b4:	c5850513          	addi	a0,a0,-936 # 1008 <loop+0x29a>
 3b8:	00000097          	auipc	ra,0x0
 3bc:	72a080e7          	jalr	1834(ra) # ae2 <printf>
  printf("# s3 = -2147483648  #\n");
 3c0:	00001517          	auipc	a0,0x1
 3c4:	c6050513          	addi	a0,a0,-928 # 1020 <loop+0x2b2>
 3c8:	00000097          	auipc	ra,0x0
 3cc:	71a080e7          	jalr	1818(ra) # ae2 <printf>
  printf("# s4 = 1337         #\n");
 3d0:	00001517          	auipc	a0,0x1
 3d4:	c6850513          	addi	a0,a0,-920 # 1038 <loop+0x2ca>
 3d8:	00000097          	auipc	ra,0x0
 3dc:	70a080e7          	jalr	1802(ra) # ae2 <printf>
  printf("# s5 = 2020         #\n");
 3e0:	00001517          	auipc	a0,0x1
 3e4:	c7050513          	addi	a0,a0,-912 # 1050 <loop+0x2e2>
 3e8:	00000097          	auipc	ra,0x0
 3ec:	6fa080e7          	jalr	1786(ra) # ae2 <printf>
  printf("# s6 = 3234         #\n");
 3f0:	00001517          	auipc	a0,0x1
 3f4:	c7850513          	addi	a0,a0,-904 # 1068 <loop+0x2fa>
 3f8:	00000097          	auipc	ra,0x0
 3fc:	6ea080e7          	jalr	1770(ra) # ae2 <printf>
  printf("# s7 = 3235         #\n");
 400:	00001517          	auipc	a0,0x1
 404:	c8050513          	addi	a0,a0,-896 # 1080 <loop+0x312>
 408:	00000097          	auipc	ra,0x0
 40c:	6da080e7          	jalr	1754(ra) # ae2 <printf>
  printf("# s8 = 3236         #\n");
 410:	00001517          	auipc	a0,0x1
 414:	c8850513          	addi	a0,a0,-888 # 1098 <loop+0x32a>
 418:	00000097          	auipc	ra,0x0
 41c:	6ca080e7          	jalr	1738(ra) # ae2 <printf>
  printf("# s9 = 3237         #\n");
 420:	00001517          	auipc	a0,0x1
 424:	c9050513          	addi	a0,a0,-880 # 10b0 <loop+0x342>
 428:	00000097          	auipc	ra,0x0
 42c:	6ba080e7          	jalr	1722(ra) # ae2 <printf>
  printf("# s10 = 3238        #\n");
 430:	00001517          	auipc	a0,0x1
 434:	c9850513          	addi	a0,a0,-872 # 10c8 <loop+0x35a>
 438:	00000097          	auipc	ra,0x0
 43c:	6aa080e7          	jalr	1706(ra) # ae2 <printf>
  printf("# s11 = 3239        #\n");
 440:	00001517          	auipc	a0,0x1
 444:	ca050513          	addi	a0,a0,-864 # 10e0 <loop+0x372>
 448:	00000097          	auipc	ra,0x0
 44c:	69a080e7          	jalr	1690(ra) # ae2 <printf>
  printf("#####################\n");
 450:	00001517          	auipc	a0,0x1
 454:	93050513          	addi	a0,a0,-1744 # d80 <loop+0x12>
 458:	00000097          	auipc	ra,0x0
 45c:	68a080e7          	jalr	1674(ra) # ae2 <printf>
  dump_test4_asm();
 460:	00001097          	auipc	ra,0x1
 464:	87c080e7          	jalr	-1924(ra) # cdc <dump_test4_asm>
}
 468:	60a2                	ld	ra,8(sp)
 46a:	6402                	ld	s0,0(sp)
 46c:	0141                	addi	sp,sp,16
 46e:	8082                	ret

0000000000000470 <main>:
int main(void) {
 470:	1141                	addi	sp,sp,-16
 472:	e406                	sd	ra,8(sp)
 474:	e022                	sd	s0,0(sp)
 476:	0800                	addi	s0,sp,16
  printf("dump tests started\n");
 478:	00001517          	auipc	a0,0x1
 47c:	c8050513          	addi	a0,a0,-896 # 10f8 <loop+0x38a>
 480:	00000097          	auipc	ra,0x0
 484:	662080e7          	jalr	1634(ra) # ae2 <printf>
  printf("dump syscall found. Start testing\n");
 488:	00001517          	auipc	a0,0x1
 48c:	c8850513          	addi	a0,a0,-888 # 1110 <loop+0x3a2>
 490:	00000097          	auipc	ra,0x0
 494:	652080e7          	jalr	1618(ra) # ae2 <printf>
  test1();
 498:	00000097          	auipc	ra,0x0
 49c:	b68080e7          	jalr	-1176(ra) # 0 <test1>
  test2();
 4a0:	00000097          	auipc	ra,0x0
 4a4:	bc8080e7          	jalr	-1080(ra) # 68 <test2>
  test3();
 4a8:	00000097          	auipc	ra,0x0
 4ac:	d18080e7          	jalr	-744(ra) # 1c0 <test3>
  test4();
 4b0:	00000097          	auipc	ra,0x0
 4b4:	e68080e7          	jalr	-408(ra) # 318 <test4>
  printf("4 tests were ran\n");
 4b8:	00001517          	auipc	a0,0x1
 4bc:	c8050513          	addi	a0,a0,-896 # 1138 <loop+0x3ca>
 4c0:	00000097          	auipc	ra,0x0
 4c4:	622080e7          	jalr	1570(ra) # ae2 <printf>
  exit(0);
 4c8:	4501                	li	a0,0
 4ca:	00000097          	auipc	ra,0x0
 4ce:	28e080e7          	jalr	654(ra) # 758 <exit>

00000000000004d2 <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
 4d2:	1141                	addi	sp,sp,-16
 4d4:	e406                	sd	ra,8(sp)
 4d6:	e022                	sd	s0,0(sp)
 4d8:	0800                	addi	s0,sp,16
  extern int main();
  main();
 4da:	00000097          	auipc	ra,0x0
 4de:	f96080e7          	jalr	-106(ra) # 470 <main>
  exit(0);
 4e2:	4501                	li	a0,0
 4e4:	00000097          	auipc	ra,0x0
 4e8:	274080e7          	jalr	628(ra) # 758 <exit>

00000000000004ec <strcpy>:
}

char *strcpy(char *s, const char *t) {
 4ec:	1141                	addi	sp,sp,-16
 4ee:	e422                	sd	s0,8(sp)
 4f0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 4f2:	87aa                	mv	a5,a0
 4f4:	0585                	addi	a1,a1,1
 4f6:	0785                	addi	a5,a5,1
 4f8:	fff5c703          	lbu	a4,-1(a1)
 4fc:	fee78fa3          	sb	a4,-1(a5)
 500:	fb75                	bnez	a4,4f4 <strcpy+0x8>
    ;
  return os;
}
 502:	6422                	ld	s0,8(sp)
 504:	0141                	addi	sp,sp,16
 506:	8082                	ret

0000000000000508 <strcmp>:

int strcmp(const char *p, const char *q) {
 508:	1141                	addi	sp,sp,-16
 50a:	e422                	sd	s0,8(sp)
 50c:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
 50e:	00054783          	lbu	a5,0(a0)
 512:	cb91                	beqz	a5,526 <strcmp+0x1e>
 514:	0005c703          	lbu	a4,0(a1)
 518:	00f71763          	bne	a4,a5,526 <strcmp+0x1e>
 51c:	0505                	addi	a0,a0,1
 51e:	0585                	addi	a1,a1,1
 520:	00054783          	lbu	a5,0(a0)
 524:	fbe5                	bnez	a5,514 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 526:	0005c503          	lbu	a0,0(a1)
}
 52a:	40a7853b          	subw	a0,a5,a0
 52e:	6422                	ld	s0,8(sp)
 530:	0141                	addi	sp,sp,16
 532:	8082                	ret

0000000000000534 <strlen>:

uint strlen(const char *s) {
 534:	1141                	addi	sp,sp,-16
 536:	e422                	sd	s0,8(sp)
 538:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 53a:	00054783          	lbu	a5,0(a0)
 53e:	cf91                	beqz	a5,55a <strlen+0x26>
 540:	0505                	addi	a0,a0,1
 542:	87aa                	mv	a5,a0
 544:	4685                	li	a3,1
 546:	9e89                	subw	a3,a3,a0
 548:	00f6853b          	addw	a0,a3,a5
 54c:	0785                	addi	a5,a5,1
 54e:	fff7c703          	lbu	a4,-1(a5)
 552:	fb7d                	bnez	a4,548 <strlen+0x14>
    ;
  return n;
}
 554:	6422                	ld	s0,8(sp)
 556:	0141                	addi	sp,sp,16
 558:	8082                	ret
  for (n = 0; s[n]; n++)
 55a:	4501                	li	a0,0
 55c:	bfe5                	j	554 <strlen+0x20>

000000000000055e <memset>:

void *memset(void *dst, int c, uint n) {
 55e:	1141                	addi	sp,sp,-16
 560:	e422                	sd	s0,8(sp)
 562:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 564:	ca19                	beqz	a2,57a <memset+0x1c>
 566:	87aa                	mv	a5,a0
 568:	1602                	slli	a2,a2,0x20
 56a:	9201                	srli	a2,a2,0x20
 56c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 570:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 574:	0785                	addi	a5,a5,1
 576:	fee79de3          	bne	a5,a4,570 <memset+0x12>
  }
  return dst;
}
 57a:	6422                	ld	s0,8(sp)
 57c:	0141                	addi	sp,sp,16
 57e:	8082                	ret

0000000000000580 <strchr>:

char *strchr(const char *s, char c) {
 580:	1141                	addi	sp,sp,-16
 582:	e422                	sd	s0,8(sp)
 584:	0800                	addi	s0,sp,16
  for (; *s; s++)
 586:	00054783          	lbu	a5,0(a0)
 58a:	cb99                	beqz	a5,5a0 <strchr+0x20>
    if (*s == c) return (char *)s;
 58c:	00f58763          	beq	a1,a5,59a <strchr+0x1a>
  for (; *s; s++)
 590:	0505                	addi	a0,a0,1
 592:	00054783          	lbu	a5,0(a0)
 596:	fbfd                	bnez	a5,58c <strchr+0xc>
  return 0;
 598:	4501                	li	a0,0
}
 59a:	6422                	ld	s0,8(sp)
 59c:	0141                	addi	sp,sp,16
 59e:	8082                	ret
  return 0;
 5a0:	4501                	li	a0,0
 5a2:	bfe5                	j	59a <strchr+0x1a>

00000000000005a4 <gets>:

char *gets(char *buf, int max) {
 5a4:	711d                	addi	sp,sp,-96
 5a6:	ec86                	sd	ra,88(sp)
 5a8:	e8a2                	sd	s0,80(sp)
 5aa:	e4a6                	sd	s1,72(sp)
 5ac:	e0ca                	sd	s2,64(sp)
 5ae:	fc4e                	sd	s3,56(sp)
 5b0:	f852                	sd	s4,48(sp)
 5b2:	f456                	sd	s5,40(sp)
 5b4:	f05a                	sd	s6,32(sp)
 5b6:	ec5e                	sd	s7,24(sp)
 5b8:	1080                	addi	s0,sp,96
 5ba:	8baa                	mv	s7,a0
 5bc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 5be:	892a                	mv	s2,a0
 5c0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
 5c2:	4aa9                	li	s5,10
 5c4:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 5c6:	89a6                	mv	s3,s1
 5c8:	2485                	addiw	s1,s1,1
 5ca:	0344d863          	bge	s1,s4,5fa <gets+0x56>
    cc = read(0, &c, 1);
 5ce:	4605                	li	a2,1
 5d0:	faf40593          	addi	a1,s0,-81
 5d4:	4501                	li	a0,0
 5d6:	00000097          	auipc	ra,0x0
 5da:	19a080e7          	jalr	410(ra) # 770 <read>
    if (cc < 1) break;
 5de:	00a05e63          	blez	a0,5fa <gets+0x56>
    buf[i++] = c;
 5e2:	faf44783          	lbu	a5,-81(s0)
 5e6:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r') break;
 5ea:	01578763          	beq	a5,s5,5f8 <gets+0x54>
 5ee:	0905                	addi	s2,s2,1
 5f0:	fd679be3          	bne	a5,s6,5c6 <gets+0x22>
  for (i = 0; i + 1 < max;) {
 5f4:	89a6                	mv	s3,s1
 5f6:	a011                	j	5fa <gets+0x56>
 5f8:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
 5fa:	99de                	add	s3,s3,s7
 5fc:	00098023          	sb	zero,0(s3)
  return buf;
}
 600:	855e                	mv	a0,s7
 602:	60e6                	ld	ra,88(sp)
 604:	6446                	ld	s0,80(sp)
 606:	64a6                	ld	s1,72(sp)
 608:	6906                	ld	s2,64(sp)
 60a:	79e2                	ld	s3,56(sp)
 60c:	7a42                	ld	s4,48(sp)
 60e:	7aa2                	ld	s5,40(sp)
 610:	7b02                	ld	s6,32(sp)
 612:	6be2                	ld	s7,24(sp)
 614:	6125                	addi	sp,sp,96
 616:	8082                	ret

0000000000000618 <stat>:

int stat(const char *n, struct stat *st) {
 618:	1101                	addi	sp,sp,-32
 61a:	ec06                	sd	ra,24(sp)
 61c:	e822                	sd	s0,16(sp)
 61e:	e426                	sd	s1,8(sp)
 620:	e04a                	sd	s2,0(sp)
 622:	1000                	addi	s0,sp,32
 624:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 626:	4581                	li	a1,0
 628:	00000097          	auipc	ra,0x0
 62c:	170080e7          	jalr	368(ra) # 798 <open>
  if (fd < 0) return -1;
 630:	02054563          	bltz	a0,65a <stat+0x42>
 634:	84aa                	mv	s1,a0
  r = fstat(fd, st);
 636:	85ca                	mv	a1,s2
 638:	00000097          	auipc	ra,0x0
 63c:	178080e7          	jalr	376(ra) # 7b0 <fstat>
 640:	892a                	mv	s2,a0
  close(fd);
 642:	8526                	mv	a0,s1
 644:	00000097          	auipc	ra,0x0
 648:	13c080e7          	jalr	316(ra) # 780 <close>
  return r;
}
 64c:	854a                	mv	a0,s2
 64e:	60e2                	ld	ra,24(sp)
 650:	6442                	ld	s0,16(sp)
 652:	64a2                	ld	s1,8(sp)
 654:	6902                	ld	s2,0(sp)
 656:	6105                	addi	sp,sp,32
 658:	8082                	ret
  if (fd < 0) return -1;
 65a:	597d                	li	s2,-1
 65c:	bfc5                	j	64c <stat+0x34>

000000000000065e <atoi>:

int atoi(const char *s) {
 65e:	1141                	addi	sp,sp,-16
 660:	e422                	sd	s0,8(sp)
 662:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 664:	00054683          	lbu	a3,0(a0)
 668:	fd06879b          	addiw	a5,a3,-48
 66c:	0ff7f793          	zext.b	a5,a5
 670:	4625                	li	a2,9
 672:	02f66863          	bltu	a2,a5,6a2 <atoi+0x44>
 676:	872a                	mv	a4,a0
  n = 0;
 678:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 67a:	0705                	addi	a4,a4,1
 67c:	0025179b          	slliw	a5,a0,0x2
 680:	9fa9                	addw	a5,a5,a0
 682:	0017979b          	slliw	a5,a5,0x1
 686:	9fb5                	addw	a5,a5,a3
 688:	fd07851b          	addiw	a0,a5,-48
 68c:	00074683          	lbu	a3,0(a4)
 690:	fd06879b          	addiw	a5,a3,-48
 694:	0ff7f793          	zext.b	a5,a5
 698:	fef671e3          	bgeu	a2,a5,67a <atoi+0x1c>
  return n;
}
 69c:	6422                	ld	s0,8(sp)
 69e:	0141                	addi	sp,sp,16
 6a0:	8082                	ret
  n = 0;
 6a2:	4501                	li	a0,0
 6a4:	bfe5                	j	69c <atoi+0x3e>

00000000000006a6 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
 6a6:	1141                	addi	sp,sp,-16
 6a8:	e422                	sd	s0,8(sp)
 6aa:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 6ac:	02b57463          	bgeu	a0,a1,6d4 <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
 6b0:	00c05f63          	blez	a2,6ce <memmove+0x28>
 6b4:	1602                	slli	a2,a2,0x20
 6b6:	9201                	srli	a2,a2,0x20
 6b8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 6bc:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
 6be:	0585                	addi	a1,a1,1
 6c0:	0705                	addi	a4,a4,1
 6c2:	fff5c683          	lbu	a3,-1(a1)
 6c6:	fed70fa3          	sb	a3,-1(a4)
 6ca:	fee79ae3          	bne	a5,a4,6be <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
 6ce:	6422                	ld	s0,8(sp)
 6d0:	0141                	addi	sp,sp,16
 6d2:	8082                	ret
    dst += n;
 6d4:	00c50733          	add	a4,a0,a2
    src += n;
 6d8:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
 6da:	fec05ae3          	blez	a2,6ce <memmove+0x28>
 6de:	fff6079b          	addiw	a5,a2,-1
 6e2:	1782                	slli	a5,a5,0x20
 6e4:	9381                	srli	a5,a5,0x20
 6e6:	fff7c793          	not	a5,a5
 6ea:	97ba                	add	a5,a5,a4
 6ec:	15fd                	addi	a1,a1,-1
 6ee:	177d                	addi	a4,a4,-1
 6f0:	0005c683          	lbu	a3,0(a1)
 6f4:	00d70023          	sb	a3,0(a4)
 6f8:	fee79ae3          	bne	a5,a4,6ec <memmove+0x46>
 6fc:	bfc9                	j	6ce <memmove+0x28>

00000000000006fe <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
 6fe:	1141                	addi	sp,sp,-16
 700:	e422                	sd	s0,8(sp)
 702:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 704:	ca05                	beqz	a2,734 <memcmp+0x36>
 706:	fff6069b          	addiw	a3,a2,-1
 70a:	1682                	slli	a3,a3,0x20
 70c:	9281                	srli	a3,a3,0x20
 70e:	0685                	addi	a3,a3,1
 710:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 712:	00054783          	lbu	a5,0(a0)
 716:	0005c703          	lbu	a4,0(a1)
 71a:	00e79863          	bne	a5,a4,72a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 71e:	0505                	addi	a0,a0,1
    p2++;
 720:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 722:	fed518e3          	bne	a0,a3,712 <memcmp+0x14>
  }
  return 0;
 726:	4501                	li	a0,0
 728:	a019                	j	72e <memcmp+0x30>
      return *p1 - *p2;
 72a:	40e7853b          	subw	a0,a5,a4
}
 72e:	6422                	ld	s0,8(sp)
 730:	0141                	addi	sp,sp,16
 732:	8082                	ret
  return 0;
 734:	4501                	li	a0,0
 736:	bfe5                	j	72e <memcmp+0x30>

0000000000000738 <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
 738:	1141                	addi	sp,sp,-16
 73a:	e406                	sd	ra,8(sp)
 73c:	e022                	sd	s0,0(sp)
 73e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 740:	00000097          	auipc	ra,0x0
 744:	f66080e7          	jalr	-154(ra) # 6a6 <memmove>
}
 748:	60a2                	ld	ra,8(sp)
 74a:	6402                	ld	s0,0(sp)
 74c:	0141                	addi	sp,sp,16
 74e:	8082                	ret

0000000000000750 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 750:	4885                	li	a7,1
 ecall
 752:	00000073          	ecall
 ret
 756:	8082                	ret

0000000000000758 <exit>:
.global exit
exit:
 li a7, SYS_exit
 758:	4889                	li	a7,2
 ecall
 75a:	00000073          	ecall
 ret
 75e:	8082                	ret

0000000000000760 <wait>:
.global wait
wait:
 li a7, SYS_wait
 760:	488d                	li	a7,3
 ecall
 762:	00000073          	ecall
 ret
 766:	8082                	ret

0000000000000768 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 768:	4891                	li	a7,4
 ecall
 76a:	00000073          	ecall
 ret
 76e:	8082                	ret

0000000000000770 <read>:
.global read
read:
 li a7, SYS_read
 770:	4895                	li	a7,5
 ecall
 772:	00000073          	ecall
 ret
 776:	8082                	ret

0000000000000778 <write>:
.global write
write:
 li a7, SYS_write
 778:	48c1                	li	a7,16
 ecall
 77a:	00000073          	ecall
 ret
 77e:	8082                	ret

0000000000000780 <close>:
.global close
close:
 li a7, SYS_close
 780:	48d5                	li	a7,21
 ecall
 782:	00000073          	ecall
 ret
 786:	8082                	ret

0000000000000788 <kill>:
.global kill
kill:
 li a7, SYS_kill
 788:	4899                	li	a7,6
 ecall
 78a:	00000073          	ecall
 ret
 78e:	8082                	ret

0000000000000790 <exec>:
.global exec
exec:
 li a7, SYS_exec
 790:	489d                	li	a7,7
 ecall
 792:	00000073          	ecall
 ret
 796:	8082                	ret

0000000000000798 <open>:
.global open
open:
 li a7, SYS_open
 798:	48bd                	li	a7,15
 ecall
 79a:	00000073          	ecall
 ret
 79e:	8082                	ret

00000000000007a0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 7a0:	48c5                	li	a7,17
 ecall
 7a2:	00000073          	ecall
 ret
 7a6:	8082                	ret

00000000000007a8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 7a8:	48c9                	li	a7,18
 ecall
 7aa:	00000073          	ecall
 ret
 7ae:	8082                	ret

00000000000007b0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 7b0:	48a1                	li	a7,8
 ecall
 7b2:	00000073          	ecall
 ret
 7b6:	8082                	ret

00000000000007b8 <link>:
.global link
link:
 li a7, SYS_link
 7b8:	48cd                	li	a7,19
 ecall
 7ba:	00000073          	ecall
 ret
 7be:	8082                	ret

00000000000007c0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 7c0:	48d1                	li	a7,20
 ecall
 7c2:	00000073          	ecall
 ret
 7c6:	8082                	ret

00000000000007c8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 7c8:	48a5                	li	a7,9
 ecall
 7ca:	00000073          	ecall
 ret
 7ce:	8082                	ret

00000000000007d0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 7d0:	48a9                	li	a7,10
 ecall
 7d2:	00000073          	ecall
 ret
 7d6:	8082                	ret

00000000000007d8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 7d8:	48ad                	li	a7,11
 ecall
 7da:	00000073          	ecall
 ret
 7de:	8082                	ret

00000000000007e0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 7e0:	48b1                	li	a7,12
 ecall
 7e2:	00000073          	ecall
 ret
 7e6:	8082                	ret

00000000000007e8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 7e8:	48b5                	li	a7,13
 ecall
 7ea:	00000073          	ecall
 ret
 7ee:	8082                	ret

00000000000007f0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 7f0:	48b9                	li	a7,14
 ecall
 7f2:	00000073          	ecall
 ret
 7f6:	8082                	ret

00000000000007f8 <dump>:
.global dump
dump:
 li a7, SYS_dump
 7f8:	48d9                	li	a7,22
 ecall
 7fa:	00000073          	ecall
 ret
 7fe:	8082                	ret

0000000000000800 <dump2>:
.global dump2
dump2:
 li a7, SYS_dump2
 800:	48dd                	li	a7,23
 ecall
 802:	00000073          	ecall
 ret
 806:	8082                	ret

0000000000000808 <putc>:

#include <stdarg.h>

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 808:	1101                	addi	sp,sp,-32
 80a:	ec06                	sd	ra,24(sp)
 80c:	e822                	sd	s0,16(sp)
 80e:	1000                	addi	s0,sp,32
 810:	feb407a3          	sb	a1,-17(s0)
 814:	4605                	li	a2,1
 816:	fef40593          	addi	a1,s0,-17
 81a:	00000097          	auipc	ra,0x0
 81e:	f5e080e7          	jalr	-162(ra) # 778 <write>
 822:	60e2                	ld	ra,24(sp)
 824:	6442                	ld	s0,16(sp)
 826:	6105                	addi	sp,sp,32
 828:	8082                	ret

000000000000082a <printint>:

static void printint(int fd, int xx, int base, int sgn) {
 82a:	7139                	addi	sp,sp,-64
 82c:	fc06                	sd	ra,56(sp)
 82e:	f822                	sd	s0,48(sp)
 830:	f426                	sd	s1,40(sp)
 832:	f04a                	sd	s2,32(sp)
 834:	ec4e                	sd	s3,24(sp)
 836:	0080                	addi	s0,sp,64
 838:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0) {
 83a:	c299                	beqz	a3,840 <printint+0x16>
 83c:	0805c963          	bltz	a1,8ce <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 840:	2581                	sext.w	a1,a1
  neg = 0;
 842:	4881                	li	a7,0
 844:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 848:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 84a:	2601                	sext.w	a2,a2
 84c:	00001517          	auipc	a0,0x1
 850:	96450513          	addi	a0,a0,-1692 # 11b0 <digits>
 854:	883a                	mv	a6,a4
 856:	2705                	addiw	a4,a4,1
 858:	02c5f7bb          	remuw	a5,a1,a2
 85c:	1782                	slli	a5,a5,0x20
 85e:	9381                	srli	a5,a5,0x20
 860:	97aa                	add	a5,a5,a0
 862:	0007c783          	lbu	a5,0(a5)
 866:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 86a:	0005879b          	sext.w	a5,a1
 86e:	02c5d5bb          	divuw	a1,a1,a2
 872:	0685                	addi	a3,a3,1
 874:	fec7f0e3          	bgeu	a5,a2,854 <printint+0x2a>
  if (neg) buf[i++] = '-';
 878:	00088c63          	beqz	a7,890 <printint+0x66>
 87c:	fd070793          	addi	a5,a4,-48
 880:	00878733          	add	a4,a5,s0
 884:	02d00793          	li	a5,45
 888:	fef70823          	sb	a5,-16(a4)
 88c:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) putc(fd, buf[i]);
 890:	02e05863          	blez	a4,8c0 <printint+0x96>
 894:	fc040793          	addi	a5,s0,-64
 898:	00e78933          	add	s2,a5,a4
 89c:	fff78993          	addi	s3,a5,-1
 8a0:	99ba                	add	s3,s3,a4
 8a2:	377d                	addiw	a4,a4,-1
 8a4:	1702                	slli	a4,a4,0x20
 8a6:	9301                	srli	a4,a4,0x20
 8a8:	40e989b3          	sub	s3,s3,a4
 8ac:	fff94583          	lbu	a1,-1(s2)
 8b0:	8526                	mv	a0,s1
 8b2:	00000097          	auipc	ra,0x0
 8b6:	f56080e7          	jalr	-170(ra) # 808 <putc>
 8ba:	197d                	addi	s2,s2,-1
 8bc:	ff3918e3          	bne	s2,s3,8ac <printint+0x82>
}
 8c0:	70e2                	ld	ra,56(sp)
 8c2:	7442                	ld	s0,48(sp)
 8c4:	74a2                	ld	s1,40(sp)
 8c6:	7902                	ld	s2,32(sp)
 8c8:	69e2                	ld	s3,24(sp)
 8ca:	6121                	addi	sp,sp,64
 8cc:	8082                	ret
    x = -xx;
 8ce:	40b005bb          	negw	a1,a1
    neg = 1;
 8d2:	4885                	li	a7,1
    x = -xx;
 8d4:	bf85                	j	844 <printint+0x1a>

00000000000008d6 <vprintf>:
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap) {
 8d6:	7119                	addi	sp,sp,-128
 8d8:	fc86                	sd	ra,120(sp)
 8da:	f8a2                	sd	s0,112(sp)
 8dc:	f4a6                	sd	s1,104(sp)
 8de:	f0ca                	sd	s2,96(sp)
 8e0:	ecce                	sd	s3,88(sp)
 8e2:	e8d2                	sd	s4,80(sp)
 8e4:	e4d6                	sd	s5,72(sp)
 8e6:	e0da                	sd	s6,64(sp)
 8e8:	fc5e                	sd	s7,56(sp)
 8ea:	f862                	sd	s8,48(sp)
 8ec:	f466                	sd	s9,40(sp)
 8ee:	f06a                	sd	s10,32(sp)
 8f0:	ec6e                	sd	s11,24(sp)
 8f2:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 8f4:	0005c903          	lbu	s2,0(a1)
 8f8:	18090f63          	beqz	s2,a96 <vprintf+0x1c0>
 8fc:	8aaa                	mv	s5,a0
 8fe:	8b32                	mv	s6,a2
 900:	00158493          	addi	s1,a1,1
  state = 0;
 904:	4981                	li	s3,0
      if (c == '%') {
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if (state == '%') {
 906:	02500a13          	li	s4,37
 90a:	4c55                	li	s8,21
 90c:	00001c97          	auipc	s9,0x1
 910:	84cc8c93          	addi	s9,s9,-1972 # 1158 <loop+0x3ea>
      } else if (c == 'p') {
        printptr(fd, va_arg(ap, uint64));
      } else if (c == 's') {
        s = va_arg(ap, char *);
        if (s == 0) s = "(null)";
        while (*s != 0) {
 914:	02800d93          	li	s11,40
  putc(fd, 'x');
 918:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 91a:	00001b97          	auipc	s7,0x1
 91e:	896b8b93          	addi	s7,s7,-1898 # 11b0 <digits>
 922:	a839                	j	940 <vprintf+0x6a>
        putc(fd, c);
 924:	85ca                	mv	a1,s2
 926:	8556                	mv	a0,s5
 928:	00000097          	auipc	ra,0x0
 92c:	ee0080e7          	jalr	-288(ra) # 808 <putc>
 930:	a019                	j	936 <vprintf+0x60>
    } else if (state == '%') {
 932:	01498d63          	beq	s3,s4,94c <vprintf+0x76>
  for (i = 0; fmt[i]; i++) {
 936:	0485                	addi	s1,s1,1
 938:	fff4c903          	lbu	s2,-1(s1)
 93c:	14090d63          	beqz	s2,a96 <vprintf+0x1c0>
    if (state == 0) {
 940:	fe0999e3          	bnez	s3,932 <vprintf+0x5c>
      if (c == '%') {
 944:	ff4910e3          	bne	s2,s4,924 <vprintf+0x4e>
        state = '%';
 948:	89d2                	mv	s3,s4
 94a:	b7f5                	j	936 <vprintf+0x60>
      if (c == 'd') {
 94c:	11490c63          	beq	s2,s4,a64 <vprintf+0x18e>
 950:	f9d9079b          	addiw	a5,s2,-99
 954:	0ff7f793          	zext.b	a5,a5
 958:	10fc6e63          	bltu	s8,a5,a74 <vprintf+0x19e>
 95c:	f9d9079b          	addiw	a5,s2,-99
 960:	0ff7f713          	zext.b	a4,a5
 964:	10ec6863          	bltu	s8,a4,a74 <vprintf+0x19e>
 968:	00271793          	slli	a5,a4,0x2
 96c:	97e6                	add	a5,a5,s9
 96e:	439c                	lw	a5,0(a5)
 970:	97e6                	add	a5,a5,s9
 972:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 974:	008b0913          	addi	s2,s6,8
 978:	4685                	li	a3,1
 97a:	4629                	li	a2,10
 97c:	000b2583          	lw	a1,0(s6)
 980:	8556                	mv	a0,s5
 982:	00000097          	auipc	ra,0x0
 986:	ea8080e7          	jalr	-344(ra) # 82a <printint>
 98a:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 98c:	4981                	li	s3,0
 98e:	b765                	j	936 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 990:	008b0913          	addi	s2,s6,8
 994:	4681                	li	a3,0
 996:	4629                	li	a2,10
 998:	000b2583          	lw	a1,0(s6)
 99c:	8556                	mv	a0,s5
 99e:	00000097          	auipc	ra,0x0
 9a2:	e8c080e7          	jalr	-372(ra) # 82a <printint>
 9a6:	8b4a                	mv	s6,s2
      state = 0;
 9a8:	4981                	li	s3,0
 9aa:	b771                	j	936 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 9ac:	008b0913          	addi	s2,s6,8
 9b0:	4681                	li	a3,0
 9b2:	866a                	mv	a2,s10
 9b4:	000b2583          	lw	a1,0(s6)
 9b8:	8556                	mv	a0,s5
 9ba:	00000097          	auipc	ra,0x0
 9be:	e70080e7          	jalr	-400(ra) # 82a <printint>
 9c2:	8b4a                	mv	s6,s2
      state = 0;
 9c4:	4981                	li	s3,0
 9c6:	bf85                	j	936 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 9c8:	008b0793          	addi	a5,s6,8
 9cc:	f8f43423          	sd	a5,-120(s0)
 9d0:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 9d4:	03000593          	li	a1,48
 9d8:	8556                	mv	a0,s5
 9da:	00000097          	auipc	ra,0x0
 9de:	e2e080e7          	jalr	-466(ra) # 808 <putc>
  putc(fd, 'x');
 9e2:	07800593          	li	a1,120
 9e6:	8556                	mv	a0,s5
 9e8:	00000097          	auipc	ra,0x0
 9ec:	e20080e7          	jalr	-480(ra) # 808 <putc>
 9f0:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9f2:	03c9d793          	srli	a5,s3,0x3c
 9f6:	97de                	add	a5,a5,s7
 9f8:	0007c583          	lbu	a1,0(a5)
 9fc:	8556                	mv	a0,s5
 9fe:	00000097          	auipc	ra,0x0
 a02:	e0a080e7          	jalr	-502(ra) # 808 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 a06:	0992                	slli	s3,s3,0x4
 a08:	397d                	addiw	s2,s2,-1
 a0a:	fe0914e3          	bnez	s2,9f2 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 a0e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 a12:	4981                	li	s3,0
 a14:	b70d                	j	936 <vprintf+0x60>
        s = va_arg(ap, char *);
 a16:	008b0913          	addi	s2,s6,8
 a1a:	000b3983          	ld	s3,0(s6)
        if (s == 0) s = "(null)";
 a1e:	02098163          	beqz	s3,a40 <vprintf+0x16a>
        while (*s != 0) {
 a22:	0009c583          	lbu	a1,0(s3)
 a26:	c5ad                	beqz	a1,a90 <vprintf+0x1ba>
          putc(fd, *s);
 a28:	8556                	mv	a0,s5
 a2a:	00000097          	auipc	ra,0x0
 a2e:	dde080e7          	jalr	-546(ra) # 808 <putc>
          s++;
 a32:	0985                	addi	s3,s3,1
        while (*s != 0) {
 a34:	0009c583          	lbu	a1,0(s3)
 a38:	f9e5                	bnez	a1,a28 <vprintf+0x152>
        s = va_arg(ap, char *);
 a3a:	8b4a                	mv	s6,s2
      state = 0;
 a3c:	4981                	li	s3,0
 a3e:	bde5                	j	936 <vprintf+0x60>
        if (s == 0) s = "(null)";
 a40:	00000997          	auipc	s3,0x0
 a44:	71098993          	addi	s3,s3,1808 # 1150 <loop+0x3e2>
        while (*s != 0) {
 a48:	85ee                	mv	a1,s11
 a4a:	bff9                	j	a28 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 a4c:	008b0913          	addi	s2,s6,8
 a50:	000b4583          	lbu	a1,0(s6)
 a54:	8556                	mv	a0,s5
 a56:	00000097          	auipc	ra,0x0
 a5a:	db2080e7          	jalr	-590(ra) # 808 <putc>
 a5e:	8b4a                	mv	s6,s2
      state = 0;
 a60:	4981                	li	s3,0
 a62:	bdd1                	j	936 <vprintf+0x60>
        putc(fd, c);
 a64:	85d2                	mv	a1,s4
 a66:	8556                	mv	a0,s5
 a68:	00000097          	auipc	ra,0x0
 a6c:	da0080e7          	jalr	-608(ra) # 808 <putc>
      state = 0;
 a70:	4981                	li	s3,0
 a72:	b5d1                	j	936 <vprintf+0x60>
        putc(fd, '%');
 a74:	85d2                	mv	a1,s4
 a76:	8556                	mv	a0,s5
 a78:	00000097          	auipc	ra,0x0
 a7c:	d90080e7          	jalr	-624(ra) # 808 <putc>
        putc(fd, c);
 a80:	85ca                	mv	a1,s2
 a82:	8556                	mv	a0,s5
 a84:	00000097          	auipc	ra,0x0
 a88:	d84080e7          	jalr	-636(ra) # 808 <putc>
      state = 0;
 a8c:	4981                	li	s3,0
 a8e:	b565                	j	936 <vprintf+0x60>
        s = va_arg(ap, char *);
 a90:	8b4a                	mv	s6,s2
      state = 0;
 a92:	4981                	li	s3,0
 a94:	b54d                	j	936 <vprintf+0x60>
    }
  }
}
 a96:	70e6                	ld	ra,120(sp)
 a98:	7446                	ld	s0,112(sp)
 a9a:	74a6                	ld	s1,104(sp)
 a9c:	7906                	ld	s2,96(sp)
 a9e:	69e6                	ld	s3,88(sp)
 aa0:	6a46                	ld	s4,80(sp)
 aa2:	6aa6                	ld	s5,72(sp)
 aa4:	6b06                	ld	s6,64(sp)
 aa6:	7be2                	ld	s7,56(sp)
 aa8:	7c42                	ld	s8,48(sp)
 aaa:	7ca2                	ld	s9,40(sp)
 aac:	7d02                	ld	s10,32(sp)
 aae:	6de2                	ld	s11,24(sp)
 ab0:	6109                	addi	sp,sp,128
 ab2:	8082                	ret

0000000000000ab4 <fprintf>:

void fprintf(int fd, const char *fmt, ...) {
 ab4:	715d                	addi	sp,sp,-80
 ab6:	ec06                	sd	ra,24(sp)
 ab8:	e822                	sd	s0,16(sp)
 aba:	1000                	addi	s0,sp,32
 abc:	e010                	sd	a2,0(s0)
 abe:	e414                	sd	a3,8(s0)
 ac0:	e818                	sd	a4,16(s0)
 ac2:	ec1c                	sd	a5,24(s0)
 ac4:	03043023          	sd	a6,32(s0)
 ac8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 acc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 ad0:	8622                	mv	a2,s0
 ad2:	00000097          	auipc	ra,0x0
 ad6:	e04080e7          	jalr	-508(ra) # 8d6 <vprintf>
}
 ada:	60e2                	ld	ra,24(sp)
 adc:	6442                	ld	s0,16(sp)
 ade:	6161                	addi	sp,sp,80
 ae0:	8082                	ret

0000000000000ae2 <printf>:

void printf(const char *fmt, ...) {
 ae2:	711d                	addi	sp,sp,-96
 ae4:	ec06                	sd	ra,24(sp)
 ae6:	e822                	sd	s0,16(sp)
 ae8:	1000                	addi	s0,sp,32
 aea:	e40c                	sd	a1,8(s0)
 aec:	e810                	sd	a2,16(s0)
 aee:	ec14                	sd	a3,24(s0)
 af0:	f018                	sd	a4,32(s0)
 af2:	f41c                	sd	a5,40(s0)
 af4:	03043823          	sd	a6,48(s0)
 af8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 afc:	00840613          	addi	a2,s0,8
 b00:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 b04:	85aa                	mv	a1,a0
 b06:	4505                	li	a0,1
 b08:	00000097          	auipc	ra,0x0
 b0c:	dce080e7          	jalr	-562(ra) # 8d6 <vprintf>
}
 b10:	60e2                	ld	ra,24(sp)
 b12:	6442                	ld	s0,16(sp)
 b14:	6125                	addi	sp,sp,96
 b16:	8082                	ret

0000000000000b18 <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
 b18:	1141                	addi	sp,sp,-16
 b1a:	e422                	sd	s0,8(sp)
 b1c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 b1e:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b22:	00001797          	auipc	a5,0x1
 b26:	4de7b783          	ld	a5,1246(a5) # 2000 <freep>
 b2a:	a02d                	j	b54 <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 b2c:	4618                	lw	a4,8(a2)
 b2e:	9f2d                	addw	a4,a4,a1
 b30:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b34:	6398                	ld	a4,0(a5)
 b36:	6310                	ld	a2,0(a4)
 b38:	a83d                	j	b76 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 b3a:	ff852703          	lw	a4,-8(a0)
 b3e:	9f31                	addw	a4,a4,a2
 b40:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b42:	ff053683          	ld	a3,-16(a0)
 b46:	a091                	j	b8a <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 b48:	6398                	ld	a4,0(a5)
 b4a:	00e7e463          	bltu	a5,a4,b52 <free+0x3a>
 b4e:	00e6ea63          	bltu	a3,a4,b62 <free+0x4a>
void free(void *ap) {
 b52:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b54:	fed7fae3          	bgeu	a5,a3,b48 <free+0x30>
 b58:	6398                	ld	a4,0(a5)
 b5a:	00e6e463          	bltu	a3,a4,b62 <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 b5e:	fee7eae3          	bltu	a5,a4,b52 <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 b62:	ff852583          	lw	a1,-8(a0)
 b66:	6390                	ld	a2,0(a5)
 b68:	02059813          	slli	a6,a1,0x20
 b6c:	01c85713          	srli	a4,a6,0x1c
 b70:	9736                	add	a4,a4,a3
 b72:	fae60de3          	beq	a2,a4,b2c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 b76:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 b7a:	4790                	lw	a2,8(a5)
 b7c:	02061593          	slli	a1,a2,0x20
 b80:	01c5d713          	srli	a4,a1,0x1c
 b84:	973e                	add	a4,a4,a5
 b86:	fae68ae3          	beq	a3,a4,b3a <free+0x22>
    p->s.ptr = bp->s.ptr;
 b8a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b8c:	00001717          	auipc	a4,0x1
 b90:	46f73a23          	sd	a5,1140(a4) # 2000 <freep>
}
 b94:	6422                	ld	s0,8(sp)
 b96:	0141                	addi	sp,sp,16
 b98:	8082                	ret

0000000000000b9a <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
 b9a:	7139                	addi	sp,sp,-64
 b9c:	fc06                	sd	ra,56(sp)
 b9e:	f822                	sd	s0,48(sp)
 ba0:	f426                	sd	s1,40(sp)
 ba2:	f04a                	sd	s2,32(sp)
 ba4:	ec4e                	sd	s3,24(sp)
 ba6:	e852                	sd	s4,16(sp)
 ba8:	e456                	sd	s5,8(sp)
 baa:	e05a                	sd	s6,0(sp)
 bac:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 bae:	02051493          	slli	s1,a0,0x20
 bb2:	9081                	srli	s1,s1,0x20
 bb4:	04bd                	addi	s1,s1,15
 bb6:	8091                	srli	s1,s1,0x4
 bb8:	0014899b          	addiw	s3,s1,1
 bbc:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 bbe:	00001517          	auipc	a0,0x1
 bc2:	44253503          	ld	a0,1090(a0) # 2000 <freep>
 bc6:	c515                	beqz	a0,bf2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 bc8:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 bca:	4798                	lw	a4,8(a5)
 bcc:	02977f63          	bgeu	a4,s1,c0a <malloc+0x70>
 bd0:	8a4e                	mv	s4,s3
 bd2:	0009871b          	sext.w	a4,s3
 bd6:	6685                	lui	a3,0x1
 bd8:	00d77363          	bgeu	a4,a3,bde <malloc+0x44>
 bdc:	6a05                	lui	s4,0x1
 bde:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 be2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 be6:	00001917          	auipc	s2,0x1
 bea:	41a90913          	addi	s2,s2,1050 # 2000 <freep>
  if (p == (char *)-1) return 0;
 bee:	5afd                	li	s5,-1
 bf0:	a895                	j	c64 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 bf2:	00001797          	auipc	a5,0x1
 bf6:	41e78793          	addi	a5,a5,1054 # 2010 <base>
 bfa:	00001717          	auipc	a4,0x1
 bfe:	40f73323          	sd	a5,1030(a4) # 2000 <freep>
 c02:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 c04:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 c08:	b7e1                	j	bd0 <malloc+0x36>
      if (p->s.size == nunits)
 c0a:	02e48c63          	beq	s1,a4,c42 <malloc+0xa8>
        p->s.size -= nunits;
 c0e:	4137073b          	subw	a4,a4,s3
 c12:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c14:	02071693          	slli	a3,a4,0x20
 c18:	01c6d713          	srli	a4,a3,0x1c
 c1c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c1e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c22:	00001717          	auipc	a4,0x1
 c26:	3ca73f23          	sd	a0,990(a4) # 2000 <freep>
      return (void *)(p + 1);
 c2a:	01078513          	addi	a0,a5,16
      if ((p = morecore(nunits)) == 0) return 0;
  }
}
 c2e:	70e2                	ld	ra,56(sp)
 c30:	7442                	ld	s0,48(sp)
 c32:	74a2                	ld	s1,40(sp)
 c34:	7902                	ld	s2,32(sp)
 c36:	69e2                	ld	s3,24(sp)
 c38:	6a42                	ld	s4,16(sp)
 c3a:	6aa2                	ld	s5,8(sp)
 c3c:	6b02                	ld	s6,0(sp)
 c3e:	6121                	addi	sp,sp,64
 c40:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 c42:	6398                	ld	a4,0(a5)
 c44:	e118                	sd	a4,0(a0)
 c46:	bff1                	j	c22 <malloc+0x88>
  hp->s.size = nu;
 c48:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 c4c:	0541                	addi	a0,a0,16
 c4e:	00000097          	auipc	ra,0x0
 c52:	eca080e7          	jalr	-310(ra) # b18 <free>
  return freep;
 c56:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0) return 0;
 c5a:	d971                	beqz	a0,c2e <malloc+0x94>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 c5c:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 c5e:	4798                	lw	a4,8(a5)
 c60:	fa9775e3          	bgeu	a4,s1,c0a <malloc+0x70>
    if (p == freep)
 c64:	00093703          	ld	a4,0(s2)
 c68:	853e                	mv	a0,a5
 c6a:	fef719e3          	bne	a4,a5,c5c <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 c6e:	8552                	mv	a0,s4
 c70:	00000097          	auipc	ra,0x0
 c74:	b70080e7          	jalr	-1168(ra) # 7e0 <sbrk>
  if (p == (char *)-1) return 0;
 c78:	fd5518e3          	bne	a0,s5,c48 <malloc+0xae>
      if ((p = morecore(nunits)) == 0) return 0;
 c7c:	4501                	li	a0,0
 c7e:	bf45                	j	c2e <malloc+0x94>

0000000000000c80 <dump_test2_asm>:
#include "kernel/syscall.h"
.globl dump_test2_asm
dump_test2_asm:
  li s2, 2
 c80:	4909                	li	s2,2
  li s3, 3
 c82:	498d                	li	s3,3
  li s4, 4
 c84:	4a11                	li	s4,4
  li s5, 5
 c86:	4a95                	li	s5,5
  li s6, 6
 c88:	4b19                	li	s6,6
  li s7, 7
 c8a:	4b9d                	li	s7,7
  li s8, 8
 c8c:	4c21                	li	s8,8
  li s9, 9
 c8e:	4ca5                	li	s9,9
  li s10, 10
 c90:	4d29                	li	s10,10
  li s11, 11
 c92:	4dad                	li	s11,11
#ifdef SYS_dump
  li a7, SYS_dump
 c94:	48d9                	li	a7,22
  ecall
 c96:	00000073          	ecall
#endif
  ret
 c9a:	8082                	ret

0000000000000c9c <dump_test3_asm>:
.globl dump_test3_asm
dump_test3_asm:
  li s2, 1
 c9c:	4905                	li	s2,1
  li s3, -12
 c9e:	59d1                	li	s3,-12
  li s4, 123
 ca0:	07b00a13          	li	s4,123
  li s5, -1234
 ca4:	b2e00a93          	li	s5,-1234
  li s6, 12345
 ca8:	6b0d                	lui	s6,0x3
 caa:	039b0b1b          	addiw	s6,s6,57 # 3039 <base+0x1029>
  li s7, -123456
 cae:	7b89                	lui	s7,0xfffe2
 cb0:	dc0b8b9b          	addiw	s7,s7,-576 # fffffffffffe1dc0 <base+0xfffffffffffdfdb0>
  li s8, 1234567
 cb4:	0012dc37          	lui	s8,0x12d
 cb8:	687c0c1b          	addiw	s8,s8,1671 # 12d687 <base+0x12b677>
  li s9, -12345678
 cbc:	ff43acb7          	lui	s9,0xff43a
 cc0:	eb2c8c9b          	addiw	s9,s9,-334 # ffffffffff439eb2 <base+0xffffffffff437ea2>
  li s10, 123456789
 cc4:	075bdd37          	lui	s10,0x75bd
 cc8:	d15d0d1b          	addiw	s10,s10,-747 # 75bcd15 <base+0x75bad05>
  li s11, -1234567890
 ccc:	b66a0db7          	lui	s11,0xb66a0
 cd0:	d2ed8d9b          	addiw	s11,s11,-722 # ffffffffb669fd2e <base+0xffffffffb669dd1e>
#ifdef SYS_dump
  li a7, SYS_dump
 cd4:	48d9                	li	a7,22
  ecall
 cd6:	00000073          	ecall
#endif
  ret
 cda:	8082                	ret

0000000000000cdc <dump_test4_asm>:
.globl dump_test4_asm
dump_test4_asm:
  li s2, 2147483647
 cdc:	80000937          	lui	s2,0x80000
 ce0:	397d                	addiw	s2,s2,-1 # 7fffffff <base+0x7fffdfef>
  li s3, -2147483648
 ce2:	800009b7          	lui	s3,0x80000
  li s4, 1337
 ce6:	53900a13          	li	s4,1337
  li s5, 2020
 cea:	7e400a93          	li	s5,2020
  li s6, 3234
 cee:	6b05                	lui	s6,0x1
 cf0:	ca2b0b1b          	addiw	s6,s6,-862 # ca2 <dump_test3_asm+0x6>
  li s7, 3235
 cf4:	6b85                	lui	s7,0x1
 cf6:	ca3b8b9b          	addiw	s7,s7,-861 # ca3 <dump_test3_asm+0x7>
  li s8, 3236
 cfa:	6c05                	lui	s8,0x1
 cfc:	ca4c0c1b          	addiw	s8,s8,-860 # ca4 <dump_test3_asm+0x8>
  li s9, 3237
 d00:	6c85                	lui	s9,0x1
 d02:	ca5c8c9b          	addiw	s9,s9,-859 # ca5 <dump_test3_asm+0x9>
  li s10, 3238
 d06:	6d05                	lui	s10,0x1
 d08:	ca6d0d1b          	addiw	s10,s10,-858 # ca6 <dump_test3_asm+0xa>
  li s11, 3239
 d0c:	6d85                	lui	s11,0x1
 d0e:	ca7d8d9b          	addiw	s11,s11,-857 # ca7 <dump_test3_asm+0xb>
#ifdef SYS_dump
  li a7, SYS_dump
 d12:	48d9                	li	a7,22
  ecall
 d14:	00000073          	ecall
#endif
  ret
 d18:	8082                	ret

0000000000000d1a <dump2_test1_asm>:
#include "kernel/syscall.h"
.globl dump2_test1_asm
dump2_test1_asm:
  li s2, 2
 d1a:	4909                	li	s2,2
  li s3, 3
 d1c:	498d                	li	s3,3
  li s4, 4
 d1e:	4a11                	li	s4,4
  li s5, 5
 d20:	4a95                	li	s5,5
  li s6, 6
 d22:	4b19                	li	s6,6
  li s7, 7
 d24:	4b9d                	li	s7,7
  li s8, 8
 d26:	4c21                	li	s8,8
  li s9, 9
 d28:	4ca5                	li	s9,9
  li s10, 10
 d2a:	4d29                	li	s10,10
  li s11, 11
 d2c:	4dad                	li	s11,11
  li a7, SYS_write
 d2e:	48c1                	li	a7,16
  ecall
 d30:	00000073          	ecall
  j loop
 d34:	a82d                	j	d6e <loop>

0000000000000d36 <dump2_test2_asm>:

.globl dump2_test2_asm
dump2_test2_asm:
  li s2, 4
 d36:	4911                	li	s2,4
  li s3, 9
 d38:	49a5                	li	s3,9
  li s4, 16
 d3a:	4a41                	li	s4,16
  li s5, 25
 d3c:	4ae5                	li	s5,25
  li s6, 36
 d3e:	02400b13          	li	s6,36
  li s7, 49
 d42:	03100b93          	li	s7,49
  li s8, 64
 d46:	04000c13          	li	s8,64
  li s9, 81
 d4a:	05100c93          	li	s9,81
  li s10, 100
 d4e:	06400d13          	li	s10,100
  li s11, 121
 d52:	07900d93          	li	s11,121
  li a7, SYS_write
 d56:	48c1                	li	a7,16
  ecall
 d58:	00000073          	ecall
  j loop
 d5c:	a809                	j	d6e <loop>

0000000000000d5e <dump2_test3_asm>:

.globl dump2_test3_asm
dump2_test3_asm:
  li s2, 1337
 d5e:	53900913          	li	s2,1337
  mv a2, a1
 d62:	862e                	mv	a2,a1
  li a1, 2
 d64:	4589                	li	a1,2
#ifdef SYS_dump2
  li a7, SYS_dump2
 d66:	48dd                	li	a7,23
  ecall
 d68:	00000073          	ecall
#endif
  ret
 d6c:	8082                	ret

0000000000000d6e <loop>:

loop:
  j loop
 d6e:	a001                	j	d6e <loop>
  ret
 d70:	8082                	ret
