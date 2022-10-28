
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	8b013103          	ld	sp,-1872(sp) # 800088b0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	013050ef          	jal	ra,80005828 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa) {
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	d4078793          	addi	a5,a5,-704 # 80021d70 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run *)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	8b090913          	addi	s2,s2,-1872 # 80008900 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	1ba080e7          	jalr	442(ra) # 80006214 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	25a080e7          	jalr	602(ra) # 800062c8 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	c52080e7          	jalr	-942(ra) # 80005cdc <panic>

0000000080000092 <freerange>:
void freerange(void *pa_start, void *pa_end) {
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char *)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	00e504b3          	add	s1,a0,a4
    800000ac:	777d                	lui	a4,0xfffff
    800000ae:	8cf9                	and	s1,s1,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE) kfree(p);
    800000b0:	94be                	add	s1,s1,a5
    800000b2:	0095ee63          	bltu	a1,s1,800000ce <freerange+0x3c>
    800000b6:	892e                	mv	s2,a1
    800000b8:	7a7d                	lui	s4,0xfffff
    800000ba:	6985                	lui	s3,0x1
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
}
    800000ce:	70a2                	ld	ra,40(sp)
    800000d0:	7402                	ld	s0,32(sp)
    800000d2:	64e2                	ld	s1,24(sp)
    800000d4:	6942                	ld	s2,16(sp)
    800000d6:	69a2                	ld	s3,8(sp)
    800000d8:	6a02                	ld	s4,0(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
void kinit() {
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f3258593          	addi	a1,a1,-206 # 80008018 <etext+0x18>
    800000ee:	00009517          	auipc	a0,0x9
    800000f2:	81250513          	addi	a0,a0,-2030 # 80008900 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	08e080e7          	jalr	142(ra) # 80006184 <initlock>
  freerange(end, (void *)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00022517          	auipc	a0,0x22
    80000106:	c6e50513          	addi	a0,a0,-914 # 80021d70 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *kalloc(void) {
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00008497          	auipc	s1,0x8
    80000128:	7dc48493          	addi	s1,s1,2012 # 80008900 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	0e6080e7          	jalr	230(ra) # 80006214 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if (r) kmem.freelist = r->next;
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00008517          	auipc	a0,0x8
    80000140:	7c450513          	addi	a0,a0,1988 # 80008900 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	182080e7          	jalr	386(ra) # 800062c8 <release>

  if (r) memset((char *)r, 5, PGSIZE);  // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void *)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00008517          	auipc	a0,0x8
    8000016c:	79850513          	addi	a0,a0,1944 # 80008900 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	158080e7          	jalr	344(ra) # 800062c8 <release>
  if (r) memset((char *)r, 5, PGSIZE);  // fill with junk
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void *memset(void *dst, int c, uint n) {
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int memcmp(const void *v1, const void *v2, uint n) {
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while (n-- > 0) {
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if (*s1 != *s2) return *s1 - *s2;
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
    if (*s1 != *s2) return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void *memmove(void *dst, const void *src, uint n) {
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if (n == 0) return dst;
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>

  s = src;
  d = dst;
  if (s < d && s + n > d) {
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while (n-- > 0) *--d = *--s;
  } else
    while (n-- > 0) *d++ = *s++;
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
void *memmove(void *dst, const void *src, uint n) {
    800001ea:	872a                	mv	a4,a0
    while (n-- > 0) *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdd291>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    800001f8:	fef59ae3          	bne	a1,a5,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if (s < d && s + n > d) {
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while (n-- > 0) *--d = *--s;
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    8000022c:	fee79ae3          	bne	a5,a4,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *memcpy(void *dst, const void *src, uint n) {
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int strncmp(const char *p, const char *q, uint n) {
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while (n > 0 && *p && *p == *q) n--, p++, q++;
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if (n == 0) return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a809                	j	8000027c <strncmp+0x32>
    8000026c:	4501                	li	a0,0
    8000026e:	a039                	j	8000027c <strncmp+0x32>
    80000270:	ca09                	beqz	a2,80000282 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000272:	00054503          	lbu	a0,0(a0)
    80000276:	0005c783          	lbu	a5,0(a1)
    8000027a:	9d1d                	subw	a0,a0,a5
}
    8000027c:	6422                	ld	s0,8(sp)
    8000027e:	0141                	addi	sp,sp,16
    80000280:	8082                	ret
  if (n == 0) return 0;
    80000282:	4501                	li	a0,0
    80000284:	bfe5                	j	8000027c <strncmp+0x32>

0000000080000286 <strncpy>:

char *strncpy(char *s, const char *t, int n) {
    80000286:	1141                	addi	sp,sp,-16
    80000288:	e422                	sd	s0,8(sp)
    8000028a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while (n-- > 0 && (*s++ = *t++) != 0)
    8000028c:	872a                	mv	a4,a0
    8000028e:	8832                	mv	a6,a2
    80000290:	367d                	addiw	a2,a2,-1
    80000292:	01005963          	blez	a6,800002a4 <strncpy+0x1e>
    80000296:	0705                	addi	a4,a4,1
    80000298:	0005c783          	lbu	a5,0(a1)
    8000029c:	fef70fa3          	sb	a5,-1(a4)
    800002a0:	0585                	addi	a1,a1,1
    800002a2:	f7f5                	bnez	a5,8000028e <strncpy+0x8>
    ;
  while (n-- > 0) *s++ = 0;
    800002a4:	86ba                	mv	a3,a4
    800002a6:	00c05c63          	blez	a2,800002be <strncpy+0x38>
    800002aa:	0685                	addi	a3,a3,1
    800002ac:	fe068fa3          	sb	zero,-1(a3)
    800002b0:	40d707bb          	subw	a5,a4,a3
    800002b4:	37fd                	addiw	a5,a5,-1
    800002b6:	010787bb          	addw	a5,a5,a6
    800002ba:	fef048e3          	bgtz	a5,800002aa <strncpy+0x24>
  return os;
}
    800002be:	6422                	ld	s0,8(sp)
    800002c0:	0141                	addi	sp,sp,16
    800002c2:	8082                	ret

00000000800002c4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *safestrcpy(char *s, const char *t, int n) {
    800002c4:	1141                	addi	sp,sp,-16
    800002c6:	e422                	sd	s0,8(sp)
    800002c8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if (n <= 0) return os;
    800002ca:	02c05363          	blez	a2,800002f0 <safestrcpy+0x2c>
    800002ce:	fff6069b          	addiw	a3,a2,-1
    800002d2:	1682                	slli	a3,a3,0x20
    800002d4:	9281                	srli	a3,a3,0x20
    800002d6:	96ae                	add	a3,a3,a1
    800002d8:	87aa                	mv	a5,a0
  while (--n > 0 && (*s++ = *t++) != 0)
    800002da:	00d58963          	beq	a1,a3,800002ec <safestrcpy+0x28>
    800002de:	0585                	addi	a1,a1,1
    800002e0:	0785                	addi	a5,a5,1
    800002e2:	fff5c703          	lbu	a4,-1(a1)
    800002e6:	fee78fa3          	sb	a4,-1(a5)
    800002ea:	fb65                	bnez	a4,800002da <safestrcpy+0x16>
    ;
  *s = 0;
    800002ec:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f0:	6422                	ld	s0,8(sp)
    800002f2:	0141                	addi	sp,sp,16
    800002f4:	8082                	ret

00000000800002f6 <strlen>:

int strlen(const char *s) {
    800002f6:	1141                	addi	sp,sp,-16
    800002f8:	e422                	sd	s0,8(sp)
    800002fa:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    800002fc:	00054783          	lbu	a5,0(a0)
    80000300:	cf91                	beqz	a5,8000031c <strlen+0x26>
    80000302:	0505                	addi	a0,a0,1
    80000304:	87aa                	mv	a5,a0
    80000306:	4685                	li	a3,1
    80000308:	9e89                	subw	a3,a3,a0
    8000030a:	00f6853b          	addw	a0,a3,a5
    8000030e:	0785                	addi	a5,a5,1
    80000310:	fff7c703          	lbu	a4,-1(a5)
    80000314:	fb7d                	bnez	a4,8000030a <strlen+0x14>
    ;
  return n;
}
    80000316:	6422                	ld	s0,8(sp)
    80000318:	0141                	addi	sp,sp,16
    8000031a:	8082                	ret
  for (n = 0; s[n]; n++)
    8000031c:	4501                	li	a0,0
    8000031e:	bfe5                	j	80000316 <strlen+0x20>

0000000080000320 <main>:
#include "defs.h"

volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void main() {
    80000320:	1141                	addi	sp,sp,-16
    80000322:	e406                	sd	ra,8(sp)
    80000324:	e022                	sd	s0,0(sp)
    80000326:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    80000328:	00001097          	auipc	ra,0x1
    8000032c:	b00080e7          	jalr	-1280(ra) # 80000e28 <cpuid>
    virtio_disk_init();  // emulated hard disk
    userinit();          // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while (started == 0)
    80000330:	00008717          	auipc	a4,0x8
    80000334:	5a070713          	addi	a4,a4,1440 # 800088d0 <started>
  if (cpuid() == 0) {
    80000338:	c139                	beqz	a0,8000037e <main+0x5e>
    while (started == 0)
    8000033a:	431c                	lw	a5,0(a4)
    8000033c:	2781                	sext.w	a5,a5
    8000033e:	dff5                	beqz	a5,8000033a <main+0x1a>
      ;
    __sync_synchronize();
    80000340:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000344:	00001097          	auipc	ra,0x1
    80000348:	ae4080e7          	jalr	-1308(ra) # 80000e28 <cpuid>
    8000034c:	85aa                	mv	a1,a0
    8000034e:	00008517          	auipc	a0,0x8
    80000352:	cea50513          	addi	a0,a0,-790 # 80008038 <etext+0x38>
    80000356:	00006097          	auipc	ra,0x6
    8000035a:	9d0080e7          	jalr	-1584(ra) # 80005d26 <printf>
    kvminithart();   // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0d8080e7          	jalr	216(ra) # 80000436 <kvminithart>
    trapinithart();  // install kernel trap vector
    80000366:	00002097          	auipc	ra,0x2
    8000036a:	874080e7          	jalr	-1932(ra) # 80001bda <trapinithart>
    plicinithart();  // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	e72080e7          	jalr	-398(ra) # 800051e0 <plicinithart>
  }

  scheduler();
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	fd4080e7          	jalr	-44(ra) # 8000134a <scheduler>
    consoleinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	86e080e7          	jalr	-1938(ra) # 80005bec <consoleinit>
    printfinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	b80080e7          	jalr	-1152(ra) # 80005f06 <printfinit>
    printf("\n");
    8000038e:	00008517          	auipc	a0,0x8
    80000392:	cba50513          	addi	a0,a0,-838 # 80008048 <etext+0x48>
    80000396:	00006097          	auipc	ra,0x6
    8000039a:	990080e7          	jalr	-1648(ra) # 80005d26 <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c8250513          	addi	a0,a0,-894 # 80008020 <etext+0x20>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	980080e7          	jalr	-1664(ra) # 80005d26 <printf>
    printf("\n");
    800003ae:	00008517          	auipc	a0,0x8
    800003b2:	c9a50513          	addi	a0,a0,-870 # 80008048 <etext+0x48>
    800003b6:	00006097          	auipc	ra,0x6
    800003ba:	970080e7          	jalr	-1680(ra) # 80005d26 <printf>
    kinit();             // physical page allocator
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	d20080e7          	jalr	-736(ra) # 800000de <kinit>
    kvminit();           // create kernel page table
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	326080e7          	jalr	806(ra) # 800006ec <kvminit>
    kvminithart();       // turn on paging
    800003ce:	00000097          	auipc	ra,0x0
    800003d2:	068080e7          	jalr	104(ra) # 80000436 <kvminithart>
    procinit();          // process table
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	99e080e7          	jalr	-1634(ra) # 80000d74 <procinit>
    trapinit();          // trap vectors
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	7d4080e7          	jalr	2004(ra) # 80001bb2 <trapinit>
    trapinithart();      // install kernel trap vector
    800003e6:	00001097          	auipc	ra,0x1
    800003ea:	7f4080e7          	jalr	2036(ra) # 80001bda <trapinithart>
    plicinit();          // set up interrupt controller
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	ddc080e7          	jalr	-548(ra) # 800051ca <plicinit>
    plicinithart();      // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	dea080e7          	jalr	-534(ra) # 800051e0 <plicinithart>
    binit();             // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	f7e080e7          	jalr	-130(ra) # 8000237c <binit>
    iinit();             // inode table
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	61e080e7          	jalr	1566(ra) # 80002a24 <iinit>
    fileinit();          // file table
    8000040e:	00003097          	auipc	ra,0x3
    80000412:	5c4080e7          	jalr	1476(ra) # 800039d2 <fileinit>
    virtio_disk_init();  // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	ed2080e7          	jalr	-302(ra) # 800052e8 <virtio_disk_init>
    userinit();          // first user process
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	d0e080e7          	jalr	-754(ra) # 8000112c <userinit>
    __sync_synchronize();
    80000426:	0ff0000f          	fence
    started = 1;
    8000042a:	4785                	li	a5,1
    8000042c:	00008717          	auipc	a4,0x8
    80000430:	4af72223          	sw	a5,1188(a4) # 800088d0 <started>
    80000434:	b789                	j	80000376 <main+0x56>

0000000080000436 <kvminithart>:
// Initialize the one kernel_pagetable
void kvminit(void) { kernel_pagetable = kvmmake(); }

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart() {
    80000436:	1141                	addi	sp,sp,-16
    80000438:	e422                	sd	s0,8(sp)
    8000043a:	0800                	addi	s0,sp,16
}

// flush the TLB.
static inline void sfence_vma() {
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000043c:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000440:	00008797          	auipc	a5,0x8
    80000444:	4987b783          	ld	a5,1176(a5) # 800088d8 <kernel_pagetable>
    80000448:	83b1                	srli	a5,a5,0xc
    8000044a:	577d                	li	a4,-1
    8000044c:	177e                	slli	a4,a4,0x3f
    8000044e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r"(x));
    80000450:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000454:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000458:	6422                	ld	s0,8(sp)
    8000045a:	0141                	addi	sp,sp,16
    8000045c:	8082                	ret

000000008000045e <walk>:
//   39..63 -- must be zero.
//   30..38 -- 9 bits of level-2 index.
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc) {
    8000045e:	7139                	addi	sp,sp,-64
    80000460:	fc06                	sd	ra,56(sp)
    80000462:	f822                	sd	s0,48(sp)
    80000464:	f426                	sd	s1,40(sp)
    80000466:	f04a                	sd	s2,32(sp)
    80000468:	ec4e                	sd	s3,24(sp)
    8000046a:	e852                	sd	s4,16(sp)
    8000046c:	e456                	sd	s5,8(sp)
    8000046e:	e05a                	sd	s6,0(sp)
    80000470:	0080                	addi	s0,sp,64
    80000472:	84aa                	mv	s1,a0
    80000474:	89ae                	mv	s3,a1
    80000476:	8ab2                	mv	s5,a2
  if (va >= MAXVA) panic("walk");
    80000478:	57fd                	li	a5,-1
    8000047a:	83e9                	srli	a5,a5,0x1a
    8000047c:	4a79                	li	s4,30

  for (int level = 2; level > 0; level--) {
    8000047e:	4b31                	li	s6,12
  if (va >= MAXVA) panic("walk");
    80000480:	04b7f263          	bgeu	a5,a1,800004c4 <walk+0x66>
    80000484:	00008517          	auipc	a0,0x8
    80000488:	bcc50513          	addi	a0,a0,-1076 # 80008050 <etext+0x50>
    8000048c:	00006097          	auipc	ra,0x6
    80000490:	850080e7          	jalr	-1968(ra) # 80005cdc <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if (*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0) return 0;
    80000494:	060a8663          	beqz	s5,80000500 <walk+0xa2>
    80000498:	00000097          	auipc	ra,0x0
    8000049c:	c82080e7          	jalr	-894(ra) # 8000011a <kalloc>
    800004a0:	84aa                	mv	s1,a0
    800004a2:	c529                	beqz	a0,800004ec <walk+0x8e>
      memset(pagetable, 0, PGSIZE);
    800004a4:	6605                	lui	a2,0x1
    800004a6:	4581                	li	a1,0
    800004a8:	00000097          	auipc	ra,0x0
    800004ac:	cd2080e7          	jalr	-814(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b0:	00c4d793          	srli	a5,s1,0xc
    800004b4:	07aa                	slli	a5,a5,0xa
    800004b6:	0017e793          	ori	a5,a5,1
    800004ba:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--) {
    800004be:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdd287>
    800004c0:	036a0063          	beq	s4,s6,800004e0 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c4:	0149d933          	srl	s2,s3,s4
    800004c8:	1ff97913          	andi	s2,s2,511
    800004cc:	090e                	slli	s2,s2,0x3
    800004ce:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    800004d0:	00093483          	ld	s1,0(s2)
    800004d4:	0014f793          	andi	a5,s1,1
    800004d8:	dfd5                	beqz	a5,80000494 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004da:	80a9                	srli	s1,s1,0xa
    800004dc:	04b2                	slli	s1,s1,0xc
    800004de:	b7c5                	j	800004be <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e0:	00c9d513          	srli	a0,s3,0xc
    800004e4:	1ff57513          	andi	a0,a0,511
    800004e8:	050e                	slli	a0,a0,0x3
    800004ea:	9526                	add	a0,a0,s1
}
    800004ec:	70e2                	ld	ra,56(sp)
    800004ee:	7442                	ld	s0,48(sp)
    800004f0:	74a2                	ld	s1,40(sp)
    800004f2:	7902                	ld	s2,32(sp)
    800004f4:	69e2                	ld	s3,24(sp)
    800004f6:	6a42                	ld	s4,16(sp)
    800004f8:	6aa2                	ld	s5,8(sp)
    800004fa:	6b02                	ld	s6,0(sp)
    800004fc:	6121                	addi	sp,sp,64
    800004fe:	8082                	ret
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0) return 0;
    80000500:	4501                	li	a0,0
    80000502:	b7ed                	j	800004ec <walk+0x8e>

0000000080000504 <walkaddr>:
// Can only be used to look up user pages.
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA) return 0;
    80000504:	57fd                	li	a5,-1
    80000506:	83e9                	srli	a5,a5,0x1a
    80000508:	00b7f463          	bgeu	a5,a1,80000510 <walkaddr+0xc>
    8000050c:	4501                	li	a0,0
  if (pte == 0) return 0;
  if ((*pte & PTE_V) == 0) return 0;
  if ((*pte & PTE_U) == 0) return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050e:	8082                	ret
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
    80000510:	1141                	addi	sp,sp,-16
    80000512:	e406                	sd	ra,8(sp)
    80000514:	e022                	sd	s0,0(sp)
    80000516:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000518:	4601                	li	a2,0
    8000051a:	00000097          	auipc	ra,0x0
    8000051e:	f44080e7          	jalr	-188(ra) # 8000045e <walk>
  if (pte == 0) return 0;
    80000522:	c105                	beqz	a0,80000542 <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0) return 0;
    80000524:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0) return 0;
    80000526:	0117f693          	andi	a3,a5,17
    8000052a:	4745                	li	a4,17
    8000052c:	4501                	li	a0,0
    8000052e:	00e68663          	beq	a3,a4,8000053a <walkaddr+0x36>
}
    80000532:	60a2                	ld	ra,8(sp)
    80000534:	6402                	ld	s0,0(sp)
    80000536:	0141                	addi	sp,sp,16
    80000538:	8082                	ret
  pa = PTE2PA(*pte);
    8000053a:	83a9                	srli	a5,a5,0xa
    8000053c:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000540:	bfcd                	j	80000532 <walkaddr+0x2e>
  if (pte == 0) return 0;
    80000542:	4501                	li	a0,0
    80000544:	b7fd                	j	80000532 <walkaddr+0x2e>

0000000080000546 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa,
             int perm) {
    80000546:	715d                	addi	sp,sp,-80
    80000548:	e486                	sd	ra,72(sp)
    8000054a:	e0a2                	sd	s0,64(sp)
    8000054c:	fc26                	sd	s1,56(sp)
    8000054e:	f84a                	sd	s2,48(sp)
    80000550:	f44e                	sd	s3,40(sp)
    80000552:	f052                	sd	s4,32(sp)
    80000554:	ec56                	sd	s5,24(sp)
    80000556:	e85a                	sd	s6,16(sp)
    80000558:	e45e                	sd	s7,8(sp)
    8000055a:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if (size == 0) panic("mappages: size");
    8000055c:	c639                	beqz	a2,800005aa <mappages+0x64>
    8000055e:	8aaa                	mv	s5,a0
    80000560:	8b3a                	mv	s6,a4

  a = PGROUNDDOWN(va);
    80000562:	777d                	lui	a4,0xfffff
    80000564:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000568:	fff58993          	addi	s3,a1,-1
    8000056c:	99b2                	add	s3,s3,a2
    8000056e:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000572:	893e                	mv	s2,a5
    80000574:	40f68a33          	sub	s4,a3,a5
  for (;;) {
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    if (*pte & PTE_V) panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last) break;
    a += PGSIZE;
    80000578:	6b85                	lui	s7,0x1
    8000057a:	012a04b3          	add	s1,s4,s2
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    8000057e:	4605                	li	a2,1
    80000580:	85ca                	mv	a1,s2
    80000582:	8556                	mv	a0,s5
    80000584:	00000097          	auipc	ra,0x0
    80000588:	eda080e7          	jalr	-294(ra) # 8000045e <walk>
    8000058c:	cd1d                	beqz	a0,800005ca <mappages+0x84>
    if (*pte & PTE_V) panic("mappages: remap");
    8000058e:	611c                	ld	a5,0(a0)
    80000590:	8b85                	andi	a5,a5,1
    80000592:	e785                	bnez	a5,800005ba <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000594:	80b1                	srli	s1,s1,0xc
    80000596:	04aa                	slli	s1,s1,0xa
    80000598:	0164e4b3          	or	s1,s1,s6
    8000059c:	0014e493          	ori	s1,s1,1
    800005a0:	e104                	sd	s1,0(a0)
    if (a == last) break;
    800005a2:	05390063          	beq	s2,s3,800005e2 <mappages+0x9c>
    a += PGSIZE;
    800005a6:	995e                	add	s2,s2,s7
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    800005a8:	bfc9                	j	8000057a <mappages+0x34>
  if (size == 0) panic("mappages: size");
    800005aa:	00008517          	auipc	a0,0x8
    800005ae:	aae50513          	addi	a0,a0,-1362 # 80008058 <etext+0x58>
    800005b2:	00005097          	auipc	ra,0x5
    800005b6:	72a080e7          	jalr	1834(ra) # 80005cdc <panic>
    if (*pte & PTE_V) panic("mappages: remap");
    800005ba:	00008517          	auipc	a0,0x8
    800005be:	aae50513          	addi	a0,a0,-1362 # 80008068 <etext+0x68>
    800005c2:	00005097          	auipc	ra,0x5
    800005c6:	71a080e7          	jalr	1818(ra) # 80005cdc <panic>
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    800005ca:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005cc:	60a6                	ld	ra,72(sp)
    800005ce:	6406                	ld	s0,64(sp)
    800005d0:	74e2                	ld	s1,56(sp)
    800005d2:	7942                	ld	s2,48(sp)
    800005d4:	79a2                	ld	s3,40(sp)
    800005d6:	7a02                	ld	s4,32(sp)
    800005d8:	6ae2                	ld	s5,24(sp)
    800005da:	6b42                	ld	s6,16(sp)
    800005dc:	6ba2                	ld	s7,8(sp)
    800005de:	6161                	addi	sp,sp,80
    800005e0:	8082                	ret
  return 0;
    800005e2:	4501                	li	a0,0
    800005e4:	b7e5                	j	800005cc <mappages+0x86>

00000000800005e6 <kvmmap>:
void kvmmap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm) {
    800005e6:	1141                	addi	sp,sp,-16
    800005e8:	e406                	sd	ra,8(sp)
    800005ea:	e022                	sd	s0,0(sp)
    800005ec:	0800                	addi	s0,sp,16
    800005ee:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0) panic("kvmmap");
    800005f0:	86b2                	mv	a3,a2
    800005f2:	863e                	mv	a2,a5
    800005f4:	00000097          	auipc	ra,0x0
    800005f8:	f52080e7          	jalr	-174(ra) # 80000546 <mappages>
    800005fc:	e509                	bnez	a0,80000606 <kvmmap+0x20>
}
    800005fe:	60a2                	ld	ra,8(sp)
    80000600:	6402                	ld	s0,0(sp)
    80000602:	0141                	addi	sp,sp,16
    80000604:	8082                	ret
  if (mappages(kpgtbl, va, sz, pa, perm) != 0) panic("kvmmap");
    80000606:	00008517          	auipc	a0,0x8
    8000060a:	a7250513          	addi	a0,a0,-1422 # 80008078 <etext+0x78>
    8000060e:	00005097          	auipc	ra,0x5
    80000612:	6ce080e7          	jalr	1742(ra) # 80005cdc <panic>

0000000080000616 <kvmmake>:
pagetable_t kvmmake(void) {
    80000616:	1101                	addi	sp,sp,-32
    80000618:	ec06                	sd	ra,24(sp)
    8000061a:	e822                	sd	s0,16(sp)
    8000061c:	e426                	sd	s1,8(sp)
    8000061e:	e04a                	sd	s2,0(sp)
    80000620:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    80000622:	00000097          	auipc	ra,0x0
    80000626:	af8080e7          	jalr	-1288(ra) # 8000011a <kalloc>
    8000062a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062c:	6605                	lui	a2,0x1
    8000062e:	4581                	li	a1,0
    80000630:	00000097          	auipc	ra,0x0
    80000634:	b4a080e7          	jalr	-1206(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000638:	4719                	li	a4,6
    8000063a:	6685                	lui	a3,0x1
    8000063c:	10000637          	lui	a2,0x10000
    80000640:	100005b7          	lui	a1,0x10000
    80000644:	8526                	mv	a0,s1
    80000646:	00000097          	auipc	ra,0x0
    8000064a:	fa0080e7          	jalr	-96(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000064e:	4719                	li	a4,6
    80000650:	6685                	lui	a3,0x1
    80000652:	10001637          	lui	a2,0x10001
    80000656:	100015b7          	lui	a1,0x10001
    8000065a:	8526                	mv	a0,s1
    8000065c:	00000097          	auipc	ra,0x0
    80000660:	f8a080e7          	jalr	-118(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000664:	4719                	li	a4,6
    80000666:	004006b7          	lui	a3,0x400
    8000066a:	0c000637          	lui	a2,0xc000
    8000066e:	0c0005b7          	lui	a1,0xc000
    80000672:	8526                	mv	a0,s1
    80000674:	00000097          	auipc	ra,0x0
    80000678:	f72080e7          	jalr	-142(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    8000067c:	00008917          	auipc	s2,0x8
    80000680:	98490913          	addi	s2,s2,-1660 # 80008000 <etext>
    80000684:	4729                	li	a4,10
    80000686:	80008697          	auipc	a3,0x80008
    8000068a:	97a68693          	addi	a3,a3,-1670 # 8000 <_entry-0x7fff8000>
    8000068e:	4605                	li	a2,1
    80000690:	067e                	slli	a2,a2,0x1f
    80000692:	85b2                	mv	a1,a2
    80000694:	8526                	mv	a0,s1
    80000696:	00000097          	auipc	ra,0x0
    8000069a:	f50080e7          	jalr	-176(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext,
    8000069e:	4719                	li	a4,6
    800006a0:	46c5                	li	a3,17
    800006a2:	06ee                	slli	a3,a3,0x1b
    800006a4:	412686b3          	sub	a3,a3,s2
    800006a8:	864a                	mv	a2,s2
    800006aa:	85ca                	mv	a1,s2
    800006ac:	8526                	mv	a0,s1
    800006ae:	00000097          	auipc	ra,0x0
    800006b2:	f38080e7          	jalr	-200(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b6:	4729                	li	a4,10
    800006b8:	6685                	lui	a3,0x1
    800006ba:	00007617          	auipc	a2,0x7
    800006be:	94660613          	addi	a2,a2,-1722 # 80007000 <_trampoline>
    800006c2:	040005b7          	lui	a1,0x4000
    800006c6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006c8:	05b2                	slli	a1,a1,0xc
    800006ca:	8526                	mv	a0,s1
    800006cc:	00000097          	auipc	ra,0x0
    800006d0:	f1a080e7          	jalr	-230(ra) # 800005e6 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d4:	8526                	mv	a0,s1
    800006d6:	00000097          	auipc	ra,0x0
    800006da:	608080e7          	jalr	1544(ra) # 80000cde <proc_mapstacks>
}
    800006de:	8526                	mv	a0,s1
    800006e0:	60e2                	ld	ra,24(sp)
    800006e2:	6442                	ld	s0,16(sp)
    800006e4:	64a2                	ld	s1,8(sp)
    800006e6:	6902                	ld	s2,0(sp)
    800006e8:	6105                	addi	sp,sp,32
    800006ea:	8082                	ret

00000000800006ec <kvminit>:
void kvminit(void) { kernel_pagetable = kvmmake(); }
    800006ec:	1141                	addi	sp,sp,-16
    800006ee:	e406                	sd	ra,8(sp)
    800006f0:	e022                	sd	s0,0(sp)
    800006f2:	0800                	addi	s0,sp,16
    800006f4:	00000097          	auipc	ra,0x0
    800006f8:	f22080e7          	jalr	-222(ra) # 80000616 <kvmmake>
    800006fc:	00008797          	auipc	a5,0x8
    80000700:	1ca7be23          	sd	a0,476(a5) # 800088d8 <kernel_pagetable>
    80000704:	60a2                	ld	ra,8(sp)
    80000706:	6402                	ld	s0,0(sp)
    80000708:	0141                	addi	sp,sp,16
    8000070a:	8082                	ret

000000008000070c <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free) {
    8000070c:	715d                	addi	sp,sp,-80
    8000070e:	e486                	sd	ra,72(sp)
    80000710:	e0a2                	sd	s0,64(sp)
    80000712:	fc26                	sd	s1,56(sp)
    80000714:	f84a                	sd	s2,48(sp)
    80000716:	f44e                	sd	s3,40(sp)
    80000718:	f052                	sd	s4,32(sp)
    8000071a:	ec56                	sd	s5,24(sp)
    8000071c:	e85a                	sd	s6,16(sp)
    8000071e:	e45e                	sd	s7,8(sp)
    80000720:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0) panic("uvmunmap: not aligned");
    80000722:	03459793          	slli	a5,a1,0x34
    80000726:	e795                	bnez	a5,80000752 <uvmunmap+0x46>
    80000728:	8a2a                	mv	s4,a0
    8000072a:	892e                	mv	s2,a1
    8000072c:	8ab6                	mv	s5,a3

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8000072e:	0632                	slli	a2,a2,0xc
    80000730:	00b609b3          	add	s3,a2,a1
    if ((pte = walk(pagetable, a, 0)) == 0) panic("uvmunmap: walk");
    if ((*pte & PTE_V) == 0) panic("uvmunmap: not mapped");
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    80000734:	4b85                	li	s7,1
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80000736:	6b05                	lui	s6,0x1
    80000738:	0735e263          	bltu	a1,s3,8000079c <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
  }
}
    8000073c:	60a6                	ld	ra,72(sp)
    8000073e:	6406                	ld	s0,64(sp)
    80000740:	74e2                	ld	s1,56(sp)
    80000742:	7942                	ld	s2,48(sp)
    80000744:	79a2                	ld	s3,40(sp)
    80000746:	7a02                	ld	s4,32(sp)
    80000748:	6ae2                	ld	s5,24(sp)
    8000074a:	6b42                	ld	s6,16(sp)
    8000074c:	6ba2                	ld	s7,8(sp)
    8000074e:	6161                	addi	sp,sp,80
    80000750:	8082                	ret
  if ((va % PGSIZE) != 0) panic("uvmunmap: not aligned");
    80000752:	00008517          	auipc	a0,0x8
    80000756:	92e50513          	addi	a0,a0,-1746 # 80008080 <etext+0x80>
    8000075a:	00005097          	auipc	ra,0x5
    8000075e:	582080e7          	jalr	1410(ra) # 80005cdc <panic>
    if ((pte = walk(pagetable, a, 0)) == 0) panic("uvmunmap: walk");
    80000762:	00008517          	auipc	a0,0x8
    80000766:	93650513          	addi	a0,a0,-1738 # 80008098 <etext+0x98>
    8000076a:	00005097          	auipc	ra,0x5
    8000076e:	572080e7          	jalr	1394(ra) # 80005cdc <panic>
    if ((*pte & PTE_V) == 0) panic("uvmunmap: not mapped");
    80000772:	00008517          	auipc	a0,0x8
    80000776:	93650513          	addi	a0,a0,-1738 # 800080a8 <etext+0xa8>
    8000077a:	00005097          	auipc	ra,0x5
    8000077e:	562080e7          	jalr	1378(ra) # 80005cdc <panic>
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    80000782:	00008517          	auipc	a0,0x8
    80000786:	93e50513          	addi	a0,a0,-1730 # 800080c0 <etext+0xc0>
    8000078a:	00005097          	auipc	ra,0x5
    8000078e:	552080e7          	jalr	1362(ra) # 80005cdc <panic>
    *pte = 0;
    80000792:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80000796:	995a                	add	s2,s2,s6
    80000798:	fb3972e3          	bgeu	s2,s3,8000073c <uvmunmap+0x30>
    if ((pte = walk(pagetable, a, 0)) == 0) panic("uvmunmap: walk");
    8000079c:	4601                	li	a2,0
    8000079e:	85ca                	mv	a1,s2
    800007a0:	8552                	mv	a0,s4
    800007a2:	00000097          	auipc	ra,0x0
    800007a6:	cbc080e7          	jalr	-836(ra) # 8000045e <walk>
    800007aa:	84aa                	mv	s1,a0
    800007ac:	d95d                	beqz	a0,80000762 <uvmunmap+0x56>
    if ((*pte & PTE_V) == 0) panic("uvmunmap: not mapped");
    800007ae:	6108                	ld	a0,0(a0)
    800007b0:	00157793          	andi	a5,a0,1
    800007b4:	dfdd                	beqz	a5,80000772 <uvmunmap+0x66>
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    800007b6:	3ff57793          	andi	a5,a0,1023
    800007ba:	fd7784e3          	beq	a5,s7,80000782 <uvmunmap+0x76>
    if (do_free) {
    800007be:	fc0a8ae3          	beqz	s5,80000792 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007c2:	8129                	srli	a0,a0,0xa
      kfree((void *)pa);
    800007c4:	0532                	slli	a0,a0,0xc
    800007c6:	00000097          	auipc	ra,0x0
    800007ca:	856080e7          	jalr	-1962(ra) # 8000001c <kfree>
    800007ce:	b7d1                	j	80000792 <uvmunmap+0x86>

00000000800007d0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t uvmcreate() {
    800007d0:	1101                	addi	sp,sp,-32
    800007d2:	ec06                	sd	ra,24(sp)
    800007d4:	e822                	sd	s0,16(sp)
    800007d6:	e426                	sd	s1,8(sp)
    800007d8:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    800007da:	00000097          	auipc	ra,0x0
    800007de:	940080e7          	jalr	-1728(ra) # 8000011a <kalloc>
    800007e2:	84aa                	mv	s1,a0
  if (pagetable == 0) return 0;
    800007e4:	c519                	beqz	a0,800007f2 <uvmcreate+0x22>
  memset(pagetable, 0, PGSIZE);
    800007e6:	6605                	lui	a2,0x1
    800007e8:	4581                	li	a1,0
    800007ea:	00000097          	auipc	ra,0x0
    800007ee:	990080e7          	jalr	-1648(ra) # 8000017a <memset>
  return pagetable;
}
    800007f2:	8526                	mv	a0,s1
    800007f4:	60e2                	ld	ra,24(sp)
    800007f6:	6442                	ld	s0,16(sp)
    800007f8:	64a2                	ld	s1,8(sp)
    800007fa:	6105                	addi	sp,sp,32
    800007fc:	8082                	ret

00000000800007fe <uvmfirst>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvmfirst(pagetable_t pagetable, uchar *src, uint sz) {
    800007fe:	7179                	addi	sp,sp,-48
    80000800:	f406                	sd	ra,40(sp)
    80000802:	f022                	sd	s0,32(sp)
    80000804:	ec26                	sd	s1,24(sp)
    80000806:	e84a                	sd	s2,16(sp)
    80000808:	e44e                	sd	s3,8(sp)
    8000080a:	e052                	sd	s4,0(sp)
    8000080c:	1800                	addi	s0,sp,48
  char *mem;

  if (sz >= PGSIZE) panic("uvmfirst: more than a page");
    8000080e:	6785                	lui	a5,0x1
    80000810:	04f67863          	bgeu	a2,a5,80000860 <uvmfirst+0x62>
    80000814:	8a2a                	mv	s4,a0
    80000816:	89ae                	mv	s3,a1
    80000818:	84b2                	mv	s1,a2
  mem = kalloc();
    8000081a:	00000097          	auipc	ra,0x0
    8000081e:	900080e7          	jalr	-1792(ra) # 8000011a <kalloc>
    80000822:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000824:	6605                	lui	a2,0x1
    80000826:	4581                	li	a1,0
    80000828:	00000097          	auipc	ra,0x0
    8000082c:	952080e7          	jalr	-1710(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    80000830:	4779                	li	a4,30
    80000832:	86ca                	mv	a3,s2
    80000834:	6605                	lui	a2,0x1
    80000836:	4581                	li	a1,0
    80000838:	8552                	mv	a0,s4
    8000083a:	00000097          	auipc	ra,0x0
    8000083e:	d0c080e7          	jalr	-756(ra) # 80000546 <mappages>
  memmove(mem, src, sz);
    80000842:	8626                	mv	a2,s1
    80000844:	85ce                	mv	a1,s3
    80000846:	854a                	mv	a0,s2
    80000848:	00000097          	auipc	ra,0x0
    8000084c:	98e080e7          	jalr	-1650(ra) # 800001d6 <memmove>
}
    80000850:	70a2                	ld	ra,40(sp)
    80000852:	7402                	ld	s0,32(sp)
    80000854:	64e2                	ld	s1,24(sp)
    80000856:	6942                	ld	s2,16(sp)
    80000858:	69a2                	ld	s3,8(sp)
    8000085a:	6a02                	ld	s4,0(sp)
    8000085c:	6145                	addi	sp,sp,48
    8000085e:	8082                	ret
  if (sz >= PGSIZE) panic("uvmfirst: more than a page");
    80000860:	00008517          	auipc	a0,0x8
    80000864:	87850513          	addi	a0,a0,-1928 # 800080d8 <etext+0xd8>
    80000868:	00005097          	auipc	ra,0x5
    8000086c:	474080e7          	jalr	1140(ra) # 80005cdc <panic>

0000000080000870 <uvmdealloc>:

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64 uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz) {
    80000870:	1101                	addi	sp,sp,-32
    80000872:	ec06                	sd	ra,24(sp)
    80000874:	e822                	sd	s0,16(sp)
    80000876:	e426                	sd	s1,8(sp)
    80000878:	1000                	addi	s0,sp,32
  if (newsz >= oldsz) return oldsz;
    8000087a:	84ae                	mv	s1,a1
    8000087c:	00b67d63          	bgeu	a2,a1,80000896 <uvmdealloc+0x26>
    80000880:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    80000882:	6785                	lui	a5,0x1
    80000884:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000886:	00f60733          	add	a4,a2,a5
    8000088a:	76fd                	lui	a3,0xfffff
    8000088c:	8f75                	and	a4,a4,a3
    8000088e:	97ae                	add	a5,a5,a1
    80000890:	8ff5                	and	a5,a5,a3
    80000892:	00f76863          	bltu	a4,a5,800008a2 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000896:	8526                	mv	a0,s1
    80000898:	60e2                	ld	ra,24(sp)
    8000089a:	6442                	ld	s0,16(sp)
    8000089c:	64a2                	ld	s1,8(sp)
    8000089e:	6105                	addi	sp,sp,32
    800008a0:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a2:	8f99                	sub	a5,a5,a4
    800008a4:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a6:	4685                	li	a3,1
    800008a8:	0007861b          	sext.w	a2,a5
    800008ac:	85ba                	mv	a1,a4
    800008ae:	00000097          	auipc	ra,0x0
    800008b2:	e5e080e7          	jalr	-418(ra) # 8000070c <uvmunmap>
    800008b6:	b7c5                	j	80000896 <uvmdealloc+0x26>

00000000800008b8 <uvmalloc>:
  if (newsz < oldsz) return oldsz;
    800008b8:	0ab66563          	bltu	a2,a1,80000962 <uvmalloc+0xaa>
uint64 uvmalloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz, int xperm) {
    800008bc:	7139                	addi	sp,sp,-64
    800008be:	fc06                	sd	ra,56(sp)
    800008c0:	f822                	sd	s0,48(sp)
    800008c2:	f426                	sd	s1,40(sp)
    800008c4:	f04a                	sd	s2,32(sp)
    800008c6:	ec4e                	sd	s3,24(sp)
    800008c8:	e852                	sd	s4,16(sp)
    800008ca:	e456                	sd	s5,8(sp)
    800008cc:	e05a                	sd	s6,0(sp)
    800008ce:	0080                	addi	s0,sp,64
    800008d0:	8aaa                	mv	s5,a0
    800008d2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d4:	6785                	lui	a5,0x1
    800008d6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d8:	95be                	add	a1,a1,a5
    800008da:	77fd                	lui	a5,0xfffff
    800008dc:	00f5f9b3          	and	s3,a1,a5
  for (a = oldsz; a < newsz; a += PGSIZE) {
    800008e0:	08c9f363          	bgeu	s3,a2,80000966 <uvmalloc+0xae>
    800008e4:	894e                	mv	s2,s3
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    800008e6:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800008ea:	00000097          	auipc	ra,0x0
    800008ee:	830080e7          	jalr	-2000(ra) # 8000011a <kalloc>
    800008f2:	84aa                	mv	s1,a0
    if (mem == 0) {
    800008f4:	c51d                	beqz	a0,80000922 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800008f6:	6605                	lui	a2,0x1
    800008f8:	4581                	li	a1,0
    800008fa:	00000097          	auipc	ra,0x0
    800008fe:	880080e7          	jalr	-1920(ra) # 8000017a <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    80000902:	875a                	mv	a4,s6
    80000904:	86a6                	mv	a3,s1
    80000906:	6605                	lui	a2,0x1
    80000908:	85ca                	mv	a1,s2
    8000090a:	8556                	mv	a0,s5
    8000090c:	00000097          	auipc	ra,0x0
    80000910:	c3a080e7          	jalr	-966(ra) # 80000546 <mappages>
    80000914:	e90d                	bnez	a0,80000946 <uvmalloc+0x8e>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    80000916:	6785                	lui	a5,0x1
    80000918:	993e                	add	s2,s2,a5
    8000091a:	fd4968e3          	bltu	s2,s4,800008ea <uvmalloc+0x32>
  return newsz;
    8000091e:	8552                	mv	a0,s4
    80000920:	a809                	j	80000932 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000922:	864e                	mv	a2,s3
    80000924:	85ca                	mv	a1,s2
    80000926:	8556                	mv	a0,s5
    80000928:	00000097          	auipc	ra,0x0
    8000092c:	f48080e7          	jalr	-184(ra) # 80000870 <uvmdealloc>
      return 0;
    80000930:	4501                	li	a0,0
}
    80000932:	70e2                	ld	ra,56(sp)
    80000934:	7442                	ld	s0,48(sp)
    80000936:	74a2                	ld	s1,40(sp)
    80000938:	7902                	ld	s2,32(sp)
    8000093a:	69e2                	ld	s3,24(sp)
    8000093c:	6a42                	ld	s4,16(sp)
    8000093e:	6aa2                	ld	s5,8(sp)
    80000940:	6b02                	ld	s6,0(sp)
    80000942:	6121                	addi	sp,sp,64
    80000944:	8082                	ret
      kfree(mem);
    80000946:	8526                	mv	a0,s1
    80000948:	fffff097          	auipc	ra,0xfffff
    8000094c:	6d4080e7          	jalr	1748(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000950:	864e                	mv	a2,s3
    80000952:	85ca                	mv	a1,s2
    80000954:	8556                	mv	a0,s5
    80000956:	00000097          	auipc	ra,0x0
    8000095a:	f1a080e7          	jalr	-230(ra) # 80000870 <uvmdealloc>
      return 0;
    8000095e:	4501                	li	a0,0
    80000960:	bfc9                	j	80000932 <uvmalloc+0x7a>
  if (newsz < oldsz) return oldsz;
    80000962:	852e                	mv	a0,a1
}
    80000964:	8082                	ret
  return newsz;
    80000966:	8532                	mv	a0,a2
    80000968:	b7e9                	j	80000932 <uvmalloc+0x7a>

000000008000096a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable) {
    8000096a:	7179                	addi	sp,sp,-48
    8000096c:	f406                	sd	ra,40(sp)
    8000096e:	f022                	sd	s0,32(sp)
    80000970:	ec26                	sd	s1,24(sp)
    80000972:	e84a                	sd	s2,16(sp)
    80000974:	e44e                	sd	s3,8(sp)
    80000976:	e052                	sd	s4,0(sp)
    80000978:	1800                	addi	s0,sp,48
    8000097a:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    8000097c:	84aa                	mv	s1,a0
    8000097e:	6905                	lui	s2,0x1
    80000980:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80000982:	4985                	li	s3,1
    80000984:	a829                	j	8000099e <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000986:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000988:	00c79513          	slli	a0,a5,0xc
    8000098c:	00000097          	auipc	ra,0x0
    80000990:	fde080e7          	jalr	-34(ra) # 8000096a <freewalk>
      pagetable[i] = 0;
    80000994:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++) {
    80000998:	04a1                	addi	s1,s1,8
    8000099a:	03248163          	beq	s1,s2,800009bc <freewalk+0x52>
    pte_t pte = pagetable[i];
    8000099e:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    800009a0:	00f7f713          	andi	a4,a5,15
    800009a4:	ff3701e3          	beq	a4,s3,80000986 <freewalk+0x1c>
    } else if (pte & PTE_V) {
    800009a8:	8b85                	andi	a5,a5,1
    800009aa:	d7fd                	beqz	a5,80000998 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009ac:	00007517          	auipc	a0,0x7
    800009b0:	74c50513          	addi	a0,a0,1868 # 800080f8 <etext+0xf8>
    800009b4:	00005097          	auipc	ra,0x5
    800009b8:	328080e7          	jalr	808(ra) # 80005cdc <panic>
    }
  }
  kfree((void *)pagetable);
    800009bc:	8552                	mv	a0,s4
    800009be:	fffff097          	auipc	ra,0xfffff
    800009c2:	65e080e7          	jalr	1630(ra) # 8000001c <kfree>
}
    800009c6:	70a2                	ld	ra,40(sp)
    800009c8:	7402                	ld	s0,32(sp)
    800009ca:	64e2                	ld	s1,24(sp)
    800009cc:	6942                	ld	s2,16(sp)
    800009ce:	69a2                	ld	s3,8(sp)
    800009d0:	6a02                	ld	s4,0(sp)
    800009d2:	6145                	addi	sp,sp,48
    800009d4:	8082                	ret

00000000800009d6 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz) {
    800009d6:	1101                	addi	sp,sp,-32
    800009d8:	ec06                	sd	ra,24(sp)
    800009da:	e822                	sd	s0,16(sp)
    800009dc:	e426                	sd	s1,8(sp)
    800009de:	1000                	addi	s0,sp,32
    800009e0:	84aa                	mv	s1,a0
  if (sz > 0) uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    800009e2:	e999                	bnez	a1,800009f8 <uvmfree+0x22>
  freewalk(pagetable);
    800009e4:	8526                	mv	a0,s1
    800009e6:	00000097          	auipc	ra,0x0
    800009ea:	f84080e7          	jalr	-124(ra) # 8000096a <freewalk>
}
    800009ee:	60e2                	ld	ra,24(sp)
    800009f0:	6442                	ld	s0,16(sp)
    800009f2:	64a2                	ld	s1,8(sp)
    800009f4:	6105                	addi	sp,sp,32
    800009f6:	8082                	ret
  if (sz > 0) uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    800009f8:	6785                	lui	a5,0x1
    800009fa:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009fc:	95be                	add	a1,a1,a5
    800009fe:	4685                	li	a3,1
    80000a00:	00c5d613          	srli	a2,a1,0xc
    80000a04:	4581                	li	a1,0
    80000a06:	00000097          	auipc	ra,0x0
    80000a0a:	d06080e7          	jalr	-762(ra) # 8000070c <uvmunmap>
    80000a0e:	bfd9                	j	800009e4 <uvmfree+0xe>

0000000080000a10 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for (i = 0; i < sz; i += PGSIZE) {
    80000a10:	c679                	beqz	a2,80000ade <uvmcopy+0xce>
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
    80000a12:	715d                	addi	sp,sp,-80
    80000a14:	e486                	sd	ra,72(sp)
    80000a16:	e0a2                	sd	s0,64(sp)
    80000a18:	fc26                	sd	s1,56(sp)
    80000a1a:	f84a                	sd	s2,48(sp)
    80000a1c:	f44e                	sd	s3,40(sp)
    80000a1e:	f052                	sd	s4,32(sp)
    80000a20:	ec56                	sd	s5,24(sp)
    80000a22:	e85a                	sd	s6,16(sp)
    80000a24:	e45e                	sd	s7,8(sp)
    80000a26:	0880                	addi	s0,sp,80
    80000a28:	8b2a                	mv	s6,a0
    80000a2a:	8aae                	mv	s5,a1
    80000a2c:	8a32                	mv	s4,a2
  for (i = 0; i < sz; i += PGSIZE) {
    80000a2e:	4981                	li	s3,0
    if ((pte = walk(old, i, 0)) == 0) panic("uvmcopy: pte should exist");
    80000a30:	4601                	li	a2,0
    80000a32:	85ce                	mv	a1,s3
    80000a34:	855a                	mv	a0,s6
    80000a36:	00000097          	auipc	ra,0x0
    80000a3a:	a28080e7          	jalr	-1496(ra) # 8000045e <walk>
    80000a3e:	c531                	beqz	a0,80000a8a <uvmcopy+0x7a>
    if ((*pte & PTE_V) == 0) panic("uvmcopy: page not present");
    80000a40:	6118                	ld	a4,0(a0)
    80000a42:	00177793          	andi	a5,a4,1
    80000a46:	cbb1                	beqz	a5,80000a9a <uvmcopy+0x8a>
    pa = PTE2PA(*pte);
    80000a48:	00a75593          	srli	a1,a4,0xa
    80000a4c:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a50:	3ff77493          	andi	s1,a4,1023
    if ((mem = kalloc()) == 0) goto err;
    80000a54:	fffff097          	auipc	ra,0xfffff
    80000a58:	6c6080e7          	jalr	1734(ra) # 8000011a <kalloc>
    80000a5c:	892a                	mv	s2,a0
    80000a5e:	c939                	beqz	a0,80000ab4 <uvmcopy+0xa4>
    memmove(mem, (char *)pa, PGSIZE);
    80000a60:	6605                	lui	a2,0x1
    80000a62:	85de                	mv	a1,s7
    80000a64:	fffff097          	auipc	ra,0xfffff
    80000a68:	772080e7          	jalr	1906(ra) # 800001d6 <memmove>
    if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0) {
    80000a6c:	8726                	mv	a4,s1
    80000a6e:	86ca                	mv	a3,s2
    80000a70:	6605                	lui	a2,0x1
    80000a72:	85ce                	mv	a1,s3
    80000a74:	8556                	mv	a0,s5
    80000a76:	00000097          	auipc	ra,0x0
    80000a7a:	ad0080e7          	jalr	-1328(ra) # 80000546 <mappages>
    80000a7e:	e515                	bnez	a0,80000aaa <uvmcopy+0x9a>
  for (i = 0; i < sz; i += PGSIZE) {
    80000a80:	6785                	lui	a5,0x1
    80000a82:	99be                	add	s3,s3,a5
    80000a84:	fb49e6e3          	bltu	s3,s4,80000a30 <uvmcopy+0x20>
    80000a88:	a081                	j	80000ac8 <uvmcopy+0xb8>
    if ((pte = walk(old, i, 0)) == 0) panic("uvmcopy: pte should exist");
    80000a8a:	00007517          	auipc	a0,0x7
    80000a8e:	67e50513          	addi	a0,a0,1662 # 80008108 <etext+0x108>
    80000a92:	00005097          	auipc	ra,0x5
    80000a96:	24a080e7          	jalr	586(ra) # 80005cdc <panic>
    if ((*pte & PTE_V) == 0) panic("uvmcopy: page not present");
    80000a9a:	00007517          	auipc	a0,0x7
    80000a9e:	68e50513          	addi	a0,a0,1678 # 80008128 <etext+0x128>
    80000aa2:	00005097          	auipc	ra,0x5
    80000aa6:	23a080e7          	jalr	570(ra) # 80005cdc <panic>
      kfree(mem);
    80000aaa:	854a                	mv	a0,s2
    80000aac:	fffff097          	auipc	ra,0xfffff
    80000ab0:	570080e7          	jalr	1392(ra) # 8000001c <kfree>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ab4:	4685                	li	a3,1
    80000ab6:	00c9d613          	srli	a2,s3,0xc
    80000aba:	4581                	li	a1,0
    80000abc:	8556                	mv	a0,s5
    80000abe:	00000097          	auipc	ra,0x0
    80000ac2:	c4e080e7          	jalr	-946(ra) # 8000070c <uvmunmap>
  return -1;
    80000ac6:	557d                	li	a0,-1
}
    80000ac8:	60a6                	ld	ra,72(sp)
    80000aca:	6406                	ld	s0,64(sp)
    80000acc:	74e2                	ld	s1,56(sp)
    80000ace:	7942                	ld	s2,48(sp)
    80000ad0:	79a2                	ld	s3,40(sp)
    80000ad2:	7a02                	ld	s4,32(sp)
    80000ad4:	6ae2                	ld	s5,24(sp)
    80000ad6:	6b42                	ld	s6,16(sp)
    80000ad8:	6ba2                	ld	s7,8(sp)
    80000ada:	6161                	addi	sp,sp,80
    80000adc:	8082                	ret
  return 0;
    80000ade:	4501                	li	a0,0
}
    80000ae0:	8082                	ret

0000000080000ae2 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va) {
    80000ae2:	1141                	addi	sp,sp,-16
    80000ae4:	e406                	sd	ra,8(sp)
    80000ae6:	e022                	sd	s0,0(sp)
    80000ae8:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80000aea:	4601                	li	a2,0
    80000aec:	00000097          	auipc	ra,0x0
    80000af0:	972080e7          	jalr	-1678(ra) # 8000045e <walk>
  if (pte == 0) panic("uvmclear");
    80000af4:	c901                	beqz	a0,80000b04 <uvmclear+0x22>
  *pte &= ~PTE_U;
    80000af6:	611c                	ld	a5,0(a0)
    80000af8:	9bbd                	andi	a5,a5,-17
    80000afa:	e11c                	sd	a5,0(a0)
}
    80000afc:	60a2                	ld	ra,8(sp)
    80000afe:	6402                	ld	s0,0(sp)
    80000b00:	0141                	addi	sp,sp,16
    80000b02:	8082                	ret
  if (pte == 0) panic("uvmclear");
    80000b04:	00007517          	auipc	a0,0x7
    80000b08:	64450513          	addi	a0,a0,1604 # 80008148 <etext+0x148>
    80000b0c:	00005097          	auipc	ra,0x5
    80000b10:	1d0080e7          	jalr	464(ra) # 80005cdc <panic>

0000000080000b14 <copyout>:
// Copy len bytes from src to virtual address dstva in a given page table.
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
  uint64 n, va0, pa0;

  while (len > 0) {
    80000b14:	c6bd                	beqz	a3,80000b82 <copyout+0x6e>
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
    80000b16:	715d                	addi	sp,sp,-80
    80000b18:	e486                	sd	ra,72(sp)
    80000b1a:	e0a2                	sd	s0,64(sp)
    80000b1c:	fc26                	sd	s1,56(sp)
    80000b1e:	f84a                	sd	s2,48(sp)
    80000b20:	f44e                	sd	s3,40(sp)
    80000b22:	f052                	sd	s4,32(sp)
    80000b24:	ec56                	sd	s5,24(sp)
    80000b26:	e85a                	sd	s6,16(sp)
    80000b28:	e45e                	sd	s7,8(sp)
    80000b2a:	e062                	sd	s8,0(sp)
    80000b2c:	0880                	addi	s0,sp,80
    80000b2e:	8b2a                	mv	s6,a0
    80000b30:	8c2e                	mv	s8,a1
    80000b32:	8a32                	mv	s4,a2
    80000b34:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b36:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0) return -1;
    n = PGSIZE - (dstva - va0);
    80000b38:	6a85                	lui	s5,0x1
    80000b3a:	a015                	j	80000b5e <copyout+0x4a>
    if (n > len) n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b3c:	9562                	add	a0,a0,s8
    80000b3e:	0004861b          	sext.w	a2,s1
    80000b42:	85d2                	mv	a1,s4
    80000b44:	41250533          	sub	a0,a0,s2
    80000b48:	fffff097          	auipc	ra,0xfffff
    80000b4c:	68e080e7          	jalr	1678(ra) # 800001d6 <memmove>

    len -= n;
    80000b50:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b54:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b56:	01590c33          	add	s8,s2,s5
  while (len > 0) {
    80000b5a:	02098263          	beqz	s3,80000b7e <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b5e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b62:	85ca                	mv	a1,s2
    80000b64:	855a                	mv	a0,s6
    80000b66:	00000097          	auipc	ra,0x0
    80000b6a:	99e080e7          	jalr	-1634(ra) # 80000504 <walkaddr>
    if (pa0 == 0) return -1;
    80000b6e:	cd01                	beqz	a0,80000b86 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b70:	418904b3          	sub	s1,s2,s8
    80000b74:	94d6                	add	s1,s1,s5
    80000b76:	fc99f3e3          	bgeu	s3,s1,80000b3c <copyout+0x28>
    80000b7a:	84ce                	mv	s1,s3
    80000b7c:	b7c1                	j	80000b3c <copyout+0x28>
  }
  return 0;
    80000b7e:	4501                	li	a0,0
    80000b80:	a021                	j	80000b88 <copyout+0x74>
    80000b82:	4501                	li	a0,0
}
    80000b84:	8082                	ret
    if (pa0 == 0) return -1;
    80000b86:	557d                	li	a0,-1
}
    80000b88:	60a6                	ld	ra,72(sp)
    80000b8a:	6406                	ld	s0,64(sp)
    80000b8c:	74e2                	ld	s1,56(sp)
    80000b8e:	7942                	ld	s2,48(sp)
    80000b90:	79a2                	ld	s3,40(sp)
    80000b92:	7a02                	ld	s4,32(sp)
    80000b94:	6ae2                	ld	s5,24(sp)
    80000b96:	6b42                	ld	s6,16(sp)
    80000b98:	6ba2                	ld	s7,8(sp)
    80000b9a:	6c02                	ld	s8,0(sp)
    80000b9c:	6161                	addi	sp,sp,80
    80000b9e:	8082                	ret

0000000080000ba0 <copyin>:
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
  uint64 n, va0, pa0;

  while (len > 0) {
    80000ba0:	caa5                	beqz	a3,80000c10 <copyin+0x70>
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
    80000ba2:	715d                	addi	sp,sp,-80
    80000ba4:	e486                	sd	ra,72(sp)
    80000ba6:	e0a2                	sd	s0,64(sp)
    80000ba8:	fc26                	sd	s1,56(sp)
    80000baa:	f84a                	sd	s2,48(sp)
    80000bac:	f44e                	sd	s3,40(sp)
    80000bae:	f052                	sd	s4,32(sp)
    80000bb0:	ec56                	sd	s5,24(sp)
    80000bb2:	e85a                	sd	s6,16(sp)
    80000bb4:	e45e                	sd	s7,8(sp)
    80000bb6:	e062                	sd	s8,0(sp)
    80000bb8:	0880                	addi	s0,sp,80
    80000bba:	8b2a                	mv	s6,a0
    80000bbc:	8a2e                	mv	s4,a1
    80000bbe:	8c32                	mv	s8,a2
    80000bc0:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bc2:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0) return -1;
    n = PGSIZE - (srcva - va0);
    80000bc4:	6a85                	lui	s5,0x1
    80000bc6:	a01d                	j	80000bec <copyin+0x4c>
    if (n > len) n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bc8:	018505b3          	add	a1,a0,s8
    80000bcc:	0004861b          	sext.w	a2,s1
    80000bd0:	412585b3          	sub	a1,a1,s2
    80000bd4:	8552                	mv	a0,s4
    80000bd6:	fffff097          	auipc	ra,0xfffff
    80000bda:	600080e7          	jalr	1536(ra) # 800001d6 <memmove>

    len -= n;
    80000bde:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000be2:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000be4:	01590c33          	add	s8,s2,s5
  while (len > 0) {
    80000be8:	02098263          	beqz	s3,80000c0c <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000bec:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bf0:	85ca                	mv	a1,s2
    80000bf2:	855a                	mv	a0,s6
    80000bf4:	00000097          	auipc	ra,0x0
    80000bf8:	910080e7          	jalr	-1776(ra) # 80000504 <walkaddr>
    if (pa0 == 0) return -1;
    80000bfc:	cd01                	beqz	a0,80000c14 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bfe:	418904b3          	sub	s1,s2,s8
    80000c02:	94d6                	add	s1,s1,s5
    80000c04:	fc99f2e3          	bgeu	s3,s1,80000bc8 <copyin+0x28>
    80000c08:	84ce                	mv	s1,s3
    80000c0a:	bf7d                	j	80000bc8 <copyin+0x28>
  }
  return 0;
    80000c0c:	4501                	li	a0,0
    80000c0e:	a021                	j	80000c16 <copyin+0x76>
    80000c10:	4501                	li	a0,0
}
    80000c12:	8082                	ret
    if (pa0 == 0) return -1;
    80000c14:	557d                	li	a0,-1
}
    80000c16:	60a6                	ld	ra,72(sp)
    80000c18:	6406                	ld	s0,64(sp)
    80000c1a:	74e2                	ld	s1,56(sp)
    80000c1c:	7942                	ld	s2,48(sp)
    80000c1e:	79a2                	ld	s3,40(sp)
    80000c20:	7a02                	ld	s4,32(sp)
    80000c22:	6ae2                	ld	s5,24(sp)
    80000c24:	6b42                	ld	s6,16(sp)
    80000c26:	6ba2                	ld	s7,8(sp)
    80000c28:	6c02                	ld	s8,0(sp)
    80000c2a:	6161                	addi	sp,sp,80
    80000c2c:	8082                	ret

0000000080000c2e <copyinstr>:
// Return 0 on success, -1 on error.
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0) {
    80000c2e:	c2dd                	beqz	a3,80000cd4 <copyinstr+0xa6>
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
    80000c30:	715d                	addi	sp,sp,-80
    80000c32:	e486                	sd	ra,72(sp)
    80000c34:	e0a2                	sd	s0,64(sp)
    80000c36:	fc26                	sd	s1,56(sp)
    80000c38:	f84a                	sd	s2,48(sp)
    80000c3a:	f44e                	sd	s3,40(sp)
    80000c3c:	f052                	sd	s4,32(sp)
    80000c3e:	ec56                	sd	s5,24(sp)
    80000c40:	e85a                	sd	s6,16(sp)
    80000c42:	e45e                	sd	s7,8(sp)
    80000c44:	0880                	addi	s0,sp,80
    80000c46:	8a2a                	mv	s4,a0
    80000c48:	8b2e                	mv	s6,a1
    80000c4a:	8bb2                	mv	s7,a2
    80000c4c:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c4e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0) return -1;
    n = PGSIZE - (srcva - va0);
    80000c50:	6985                	lui	s3,0x1
    80000c52:	a02d                	j	80000c7c <copyinstr+0x4e>
    if (n > max) n = max;

    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0) {
      if (*p == '\0') {
        *dst = '\0';
    80000c54:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c58:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null) {
    80000c5a:	37fd                	addiw	a5,a5,-1
    80000c5c:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c60:	60a6                	ld	ra,72(sp)
    80000c62:	6406                	ld	s0,64(sp)
    80000c64:	74e2                	ld	s1,56(sp)
    80000c66:	7942                	ld	s2,48(sp)
    80000c68:	79a2                	ld	s3,40(sp)
    80000c6a:	7a02                	ld	s4,32(sp)
    80000c6c:	6ae2                	ld	s5,24(sp)
    80000c6e:	6b42                	ld	s6,16(sp)
    80000c70:	6ba2                	ld	s7,8(sp)
    80000c72:	6161                	addi	sp,sp,80
    80000c74:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c76:	01390bb3          	add	s7,s2,s3
  while (got_null == 0 && max > 0) {
    80000c7a:	c8a9                	beqz	s1,80000ccc <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000c7c:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c80:	85ca                	mv	a1,s2
    80000c82:	8552                	mv	a0,s4
    80000c84:	00000097          	auipc	ra,0x0
    80000c88:	880080e7          	jalr	-1920(ra) # 80000504 <walkaddr>
    if (pa0 == 0) return -1;
    80000c8c:	c131                	beqz	a0,80000cd0 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000c8e:	417906b3          	sub	a3,s2,s7
    80000c92:	96ce                	add	a3,a3,s3
    80000c94:	00d4f363          	bgeu	s1,a3,80000c9a <copyinstr+0x6c>
    80000c98:	86a6                	mv	a3,s1
    char *p = (char *)(pa0 + (srcva - va0));
    80000c9a:	955e                	add	a0,a0,s7
    80000c9c:	41250533          	sub	a0,a0,s2
    while (n > 0) {
    80000ca0:	daf9                	beqz	a3,80000c76 <copyinstr+0x48>
    80000ca2:	87da                	mv	a5,s6
      if (*p == '\0') {
    80000ca4:	41650633          	sub	a2,a0,s6
    80000ca8:	fff48593          	addi	a1,s1,-1
    80000cac:	95da                	add	a1,a1,s6
    while (n > 0) {
    80000cae:	96da                	add	a3,a3,s6
      if (*p == '\0') {
    80000cb0:	00f60733          	add	a4,a2,a5
    80000cb4:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdd290>
    80000cb8:	df51                	beqz	a4,80000c54 <copyinstr+0x26>
        *dst = *p;
    80000cba:	00e78023          	sb	a4,0(a5)
      --max;
    80000cbe:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000cc2:	0785                	addi	a5,a5,1
    while (n > 0) {
    80000cc4:	fed796e3          	bne	a5,a3,80000cb0 <copyinstr+0x82>
      dst++;
    80000cc8:	8b3e                	mv	s6,a5
    80000cca:	b775                	j	80000c76 <copyinstr+0x48>
    80000ccc:	4781                	li	a5,0
    80000cce:	b771                	j	80000c5a <copyinstr+0x2c>
    if (pa0 == 0) return -1;
    80000cd0:	557d                	li	a0,-1
    80000cd2:	b779                	j	80000c60 <copyinstr+0x32>
  int got_null = 0;
    80000cd4:	4781                	li	a5,0
  if (got_null) {
    80000cd6:	37fd                	addiw	a5,a5,-1
    80000cd8:	0007851b          	sext.w	a0,a5
}
    80000cdc:	8082                	ret

0000000080000cde <proc_mapstacks>:
struct spinlock wait_lock;

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl) {
    80000cde:	7139                	addi	sp,sp,-64
    80000ce0:	fc06                	sd	ra,56(sp)
    80000ce2:	f822                	sd	s0,48(sp)
    80000ce4:	f426                	sd	s1,40(sp)
    80000ce6:	f04a                	sd	s2,32(sp)
    80000ce8:	ec4e                	sd	s3,24(sp)
    80000cea:	e852                	sd	s4,16(sp)
    80000cec:	e456                	sd	s5,8(sp)
    80000cee:	e05a                	sd	s6,0(sp)
    80000cf0:	0080                	addi	s0,sp,64
    80000cf2:	89aa                	mv	s3,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80000cf4:	00008497          	auipc	s1,0x8
    80000cf8:	05c48493          	addi	s1,s1,92 # 80008d50 <proc>
    char *pa = kalloc();
    if (pa == 0) panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80000cfc:	8b26                	mv	s6,s1
    80000cfe:	00007a97          	auipc	s5,0x7
    80000d02:	302a8a93          	addi	s5,s5,770 # 80008000 <etext>
    80000d06:	04000937          	lui	s2,0x4000
    80000d0a:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d0c:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80000d0e:	0000ea17          	auipc	s4,0xe
    80000d12:	a42a0a13          	addi	s4,s4,-1470 # 8000e750 <tickslock>
    char *pa = kalloc();
    80000d16:	fffff097          	auipc	ra,0xfffff
    80000d1a:	404080e7          	jalr	1028(ra) # 8000011a <kalloc>
    80000d1e:	862a                	mv	a2,a0
    if (pa == 0) panic("kalloc");
    80000d20:	c131                	beqz	a0,80000d64 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int)(p - proc));
    80000d22:	416485b3          	sub	a1,s1,s6
    80000d26:	858d                	srai	a1,a1,0x3
    80000d28:	000ab783          	ld	a5,0(s5)
    80000d2c:	02f585b3          	mul	a1,a1,a5
    80000d30:	2585                	addiw	a1,a1,1
    80000d32:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d36:	4719                	li	a4,6
    80000d38:	6685                	lui	a3,0x1
    80000d3a:	40b905b3          	sub	a1,s2,a1
    80000d3e:	854e                	mv	a0,s3
    80000d40:	00000097          	auipc	ra,0x0
    80000d44:	8a6080e7          	jalr	-1882(ra) # 800005e6 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++) {
    80000d48:	16848493          	addi	s1,s1,360
    80000d4c:	fd4495e3          	bne	s1,s4,80000d16 <proc_mapstacks+0x38>
  }
}
    80000d50:	70e2                	ld	ra,56(sp)
    80000d52:	7442                	ld	s0,48(sp)
    80000d54:	74a2                	ld	s1,40(sp)
    80000d56:	7902                	ld	s2,32(sp)
    80000d58:	69e2                	ld	s3,24(sp)
    80000d5a:	6a42                	ld	s4,16(sp)
    80000d5c:	6aa2                	ld	s5,8(sp)
    80000d5e:	6b02                	ld	s6,0(sp)
    80000d60:	6121                	addi	sp,sp,64
    80000d62:	8082                	ret
    if (pa == 0) panic("kalloc");
    80000d64:	00007517          	auipc	a0,0x7
    80000d68:	3f450513          	addi	a0,a0,1012 # 80008158 <etext+0x158>
    80000d6c:	00005097          	auipc	ra,0x5
    80000d70:	f70080e7          	jalr	-144(ra) # 80005cdc <panic>

0000000080000d74 <procinit>:

// initialize the proc table.
void procinit(void) {
    80000d74:	7139                	addi	sp,sp,-64
    80000d76:	fc06                	sd	ra,56(sp)
    80000d78:	f822                	sd	s0,48(sp)
    80000d7a:	f426                	sd	s1,40(sp)
    80000d7c:	f04a                	sd	s2,32(sp)
    80000d7e:	ec4e                	sd	s3,24(sp)
    80000d80:	e852                	sd	s4,16(sp)
    80000d82:	e456                	sd	s5,8(sp)
    80000d84:	e05a                	sd	s6,0(sp)
    80000d86:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80000d88:	00007597          	auipc	a1,0x7
    80000d8c:	3d858593          	addi	a1,a1,984 # 80008160 <etext+0x160>
    80000d90:	00008517          	auipc	a0,0x8
    80000d94:	b9050513          	addi	a0,a0,-1136 # 80008920 <pid_lock>
    80000d98:	00005097          	auipc	ra,0x5
    80000d9c:	3ec080e7          	jalr	1004(ra) # 80006184 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000da0:	00007597          	auipc	a1,0x7
    80000da4:	3c858593          	addi	a1,a1,968 # 80008168 <etext+0x168>
    80000da8:	00008517          	auipc	a0,0x8
    80000dac:	b9050513          	addi	a0,a0,-1136 # 80008938 <wait_lock>
    80000db0:	00005097          	auipc	ra,0x5
    80000db4:	3d4080e7          	jalr	980(ra) # 80006184 <initlock>
  for (p = proc; p < &proc[NPROC]; p++) {
    80000db8:	00008497          	auipc	s1,0x8
    80000dbc:	f9848493          	addi	s1,s1,-104 # 80008d50 <proc>
    initlock(&p->lock, "proc");
    80000dc0:	00007b17          	auipc	s6,0x7
    80000dc4:	3b8b0b13          	addi	s6,s6,952 # 80008178 <etext+0x178>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80000dc8:	8aa6                	mv	s5,s1
    80000dca:	00007a17          	auipc	s4,0x7
    80000dce:	236a0a13          	addi	s4,s4,566 # 80008000 <etext>
    80000dd2:	04000937          	lui	s2,0x4000
    80000dd6:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000dd8:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80000dda:	0000e997          	auipc	s3,0xe
    80000dde:	97698993          	addi	s3,s3,-1674 # 8000e750 <tickslock>
    initlock(&p->lock, "proc");
    80000de2:	85da                	mv	a1,s6
    80000de4:	8526                	mv	a0,s1
    80000de6:	00005097          	auipc	ra,0x5
    80000dea:	39e080e7          	jalr	926(ra) # 80006184 <initlock>
    p->state = UNUSED;
    80000dee:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    80000df2:	415487b3          	sub	a5,s1,s5
    80000df6:	878d                	srai	a5,a5,0x3
    80000df8:	000a3703          	ld	a4,0(s4)
    80000dfc:	02e787b3          	mul	a5,a5,a4
    80000e00:	2785                	addiw	a5,a5,1
    80000e02:	00d7979b          	slliw	a5,a5,0xd
    80000e06:	40f907b3          	sub	a5,s2,a5
    80000e0a:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++) {
    80000e0c:	16848493          	addi	s1,s1,360
    80000e10:	fd3499e3          	bne	s1,s3,80000de2 <procinit+0x6e>
  }
}
    80000e14:	70e2                	ld	ra,56(sp)
    80000e16:	7442                	ld	s0,48(sp)
    80000e18:	74a2                	ld	s1,40(sp)
    80000e1a:	7902                	ld	s2,32(sp)
    80000e1c:	69e2                	ld	s3,24(sp)
    80000e1e:	6a42                	ld	s4,16(sp)
    80000e20:	6aa2                	ld	s5,8(sp)
    80000e22:	6b02                	ld	s6,0(sp)
    80000e24:	6121                	addi	sp,sp,64
    80000e26:	8082                	ret

0000000080000e28 <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid() {
    80000e28:	1141                	addi	sp,sp,-16
    80000e2a:	e422                	sd	s0,8(sp)
    80000e2c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    80000e2e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e30:	2501                	sext.w	a0,a0
    80000e32:	6422                	ld	s0,8(sp)
    80000e34:	0141                	addi	sp,sp,16
    80000e36:	8082                	ret

0000000080000e38 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *mycpu(void) {
    80000e38:	1141                	addi	sp,sp,-16
    80000e3a:	e422                	sd	s0,8(sp)
    80000e3c:	0800                	addi	s0,sp,16
    80000e3e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e40:	2781                	sext.w	a5,a5
    80000e42:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e44:	00008517          	auipc	a0,0x8
    80000e48:	b0c50513          	addi	a0,a0,-1268 # 80008950 <cpus>
    80000e4c:	953e                	add	a0,a0,a5
    80000e4e:	6422                	ld	s0,8(sp)
    80000e50:	0141                	addi	sp,sp,16
    80000e52:	8082                	ret

0000000080000e54 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *myproc(void) {
    80000e54:	1101                	addi	sp,sp,-32
    80000e56:	ec06                	sd	ra,24(sp)
    80000e58:	e822                	sd	s0,16(sp)
    80000e5a:	e426                	sd	s1,8(sp)
    80000e5c:	1000                	addi	s0,sp,32
  push_off();
    80000e5e:	00005097          	auipc	ra,0x5
    80000e62:	36a080e7          	jalr	874(ra) # 800061c8 <push_off>
    80000e66:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e68:	2781                	sext.w	a5,a5
    80000e6a:	079e                	slli	a5,a5,0x7
    80000e6c:	00008717          	auipc	a4,0x8
    80000e70:	ab470713          	addi	a4,a4,-1356 # 80008920 <pid_lock>
    80000e74:	97ba                	add	a5,a5,a4
    80000e76:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e78:	00005097          	auipc	ra,0x5
    80000e7c:	3f0080e7          	jalr	1008(ra) # 80006268 <pop_off>
  return p;
}
    80000e80:	8526                	mv	a0,s1
    80000e82:	60e2                	ld	ra,24(sp)
    80000e84:	6442                	ld	s0,16(sp)
    80000e86:	64a2                	ld	s1,8(sp)
    80000e88:	6105                	addi	sp,sp,32
    80000e8a:	8082                	ret

0000000080000e8c <forkret>:
  release(&p->lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void) {
    80000e8c:	1141                	addi	sp,sp,-16
    80000e8e:	e406                	sd	ra,8(sp)
    80000e90:	e022                	sd	s0,0(sp)
    80000e92:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e94:	00000097          	auipc	ra,0x0
    80000e98:	fc0080e7          	jalr	-64(ra) # 80000e54 <myproc>
    80000e9c:	00005097          	auipc	ra,0x5
    80000ea0:	42c080e7          	jalr	1068(ra) # 800062c8 <release>

  if (first) {
    80000ea4:	00008797          	auipc	a5,0x8
    80000ea8:	9bc7a783          	lw	a5,-1604(a5) # 80008860 <first.1>
    80000eac:	eb89                	bnez	a5,80000ebe <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000eae:	00001097          	auipc	ra,0x1
    80000eb2:	d44080e7          	jalr	-700(ra) # 80001bf2 <usertrapret>
}
    80000eb6:	60a2                	ld	ra,8(sp)
    80000eb8:	6402                	ld	s0,0(sp)
    80000eba:	0141                	addi	sp,sp,16
    80000ebc:	8082                	ret
    first = 0;
    80000ebe:	00008797          	auipc	a5,0x8
    80000ec2:	9a07a123          	sw	zero,-1630(a5) # 80008860 <first.1>
    fsinit(ROOTDEV);
    80000ec6:	4505                	li	a0,1
    80000ec8:	00002097          	auipc	ra,0x2
    80000ecc:	adc080e7          	jalr	-1316(ra) # 800029a4 <fsinit>
    80000ed0:	bff9                	j	80000eae <forkret+0x22>

0000000080000ed2 <allocpid>:
int allocpid() {
    80000ed2:	1101                	addi	sp,sp,-32
    80000ed4:	ec06                	sd	ra,24(sp)
    80000ed6:	e822                	sd	s0,16(sp)
    80000ed8:	e426                	sd	s1,8(sp)
    80000eda:	e04a                	sd	s2,0(sp)
    80000edc:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ede:	00008917          	auipc	s2,0x8
    80000ee2:	a4290913          	addi	s2,s2,-1470 # 80008920 <pid_lock>
    80000ee6:	854a                	mv	a0,s2
    80000ee8:	00005097          	auipc	ra,0x5
    80000eec:	32c080e7          	jalr	812(ra) # 80006214 <acquire>
  pid = nextpid;
    80000ef0:	00008797          	auipc	a5,0x8
    80000ef4:	97478793          	addi	a5,a5,-1676 # 80008864 <nextpid>
    80000ef8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000efa:	0014871b          	addiw	a4,s1,1
    80000efe:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f00:	854a                	mv	a0,s2
    80000f02:	00005097          	auipc	ra,0x5
    80000f06:	3c6080e7          	jalr	966(ra) # 800062c8 <release>
}
    80000f0a:	8526                	mv	a0,s1
    80000f0c:	60e2                	ld	ra,24(sp)
    80000f0e:	6442                	ld	s0,16(sp)
    80000f10:	64a2                	ld	s1,8(sp)
    80000f12:	6902                	ld	s2,0(sp)
    80000f14:	6105                	addi	sp,sp,32
    80000f16:	8082                	ret

0000000080000f18 <proc_pagetable>:
pagetable_t proc_pagetable(struct proc *p) {
    80000f18:	1101                	addi	sp,sp,-32
    80000f1a:	ec06                	sd	ra,24(sp)
    80000f1c:	e822                	sd	s0,16(sp)
    80000f1e:	e426                	sd	s1,8(sp)
    80000f20:	e04a                	sd	s2,0(sp)
    80000f22:	1000                	addi	s0,sp,32
    80000f24:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f26:	00000097          	auipc	ra,0x0
    80000f2a:	8aa080e7          	jalr	-1878(ra) # 800007d0 <uvmcreate>
    80000f2e:	84aa                	mv	s1,a0
  if (pagetable == 0) return 0;
    80000f30:	c121                	beqz	a0,80000f70 <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    80000f32:	4729                	li	a4,10
    80000f34:	00006697          	auipc	a3,0x6
    80000f38:	0cc68693          	addi	a3,a3,204 # 80007000 <_trampoline>
    80000f3c:	6605                	lui	a2,0x1
    80000f3e:	040005b7          	lui	a1,0x4000
    80000f42:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f44:	05b2                	slli	a1,a1,0xc
    80000f46:	fffff097          	auipc	ra,0xfffff
    80000f4a:	600080e7          	jalr	1536(ra) # 80000546 <mappages>
    80000f4e:	02054863          	bltz	a0,80000f7e <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    80000f52:	4719                	li	a4,6
    80000f54:	05893683          	ld	a3,88(s2)
    80000f58:	6605                	lui	a2,0x1
    80000f5a:	020005b7          	lui	a1,0x2000
    80000f5e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f60:	05b6                	slli	a1,a1,0xd
    80000f62:	8526                	mv	a0,s1
    80000f64:	fffff097          	auipc	ra,0xfffff
    80000f68:	5e2080e7          	jalr	1506(ra) # 80000546 <mappages>
    80000f6c:	02054163          	bltz	a0,80000f8e <proc_pagetable+0x76>
}
    80000f70:	8526                	mv	a0,s1
    80000f72:	60e2                	ld	ra,24(sp)
    80000f74:	6442                	ld	s0,16(sp)
    80000f76:	64a2                	ld	s1,8(sp)
    80000f78:	6902                	ld	s2,0(sp)
    80000f7a:	6105                	addi	sp,sp,32
    80000f7c:	8082                	ret
    uvmfree(pagetable, 0);
    80000f7e:	4581                	li	a1,0
    80000f80:	8526                	mv	a0,s1
    80000f82:	00000097          	auipc	ra,0x0
    80000f86:	a54080e7          	jalr	-1452(ra) # 800009d6 <uvmfree>
    return 0;
    80000f8a:	4481                	li	s1,0
    80000f8c:	b7d5                	j	80000f70 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f8e:	4681                	li	a3,0
    80000f90:	4605                	li	a2,1
    80000f92:	040005b7          	lui	a1,0x4000
    80000f96:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f98:	05b2                	slli	a1,a1,0xc
    80000f9a:	8526                	mv	a0,s1
    80000f9c:	fffff097          	auipc	ra,0xfffff
    80000fa0:	770080e7          	jalr	1904(ra) # 8000070c <uvmunmap>
    uvmfree(pagetable, 0);
    80000fa4:	4581                	li	a1,0
    80000fa6:	8526                	mv	a0,s1
    80000fa8:	00000097          	auipc	ra,0x0
    80000fac:	a2e080e7          	jalr	-1490(ra) # 800009d6 <uvmfree>
    return 0;
    80000fb0:	4481                	li	s1,0
    80000fb2:	bf7d                	j	80000f70 <proc_pagetable+0x58>

0000000080000fb4 <proc_freepagetable>:
void proc_freepagetable(pagetable_t pagetable, uint64 sz) {
    80000fb4:	1101                	addi	sp,sp,-32
    80000fb6:	ec06                	sd	ra,24(sp)
    80000fb8:	e822                	sd	s0,16(sp)
    80000fba:	e426                	sd	s1,8(sp)
    80000fbc:	e04a                	sd	s2,0(sp)
    80000fbe:	1000                	addi	s0,sp,32
    80000fc0:	84aa                	mv	s1,a0
    80000fc2:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fc4:	4681                	li	a3,0
    80000fc6:	4605                	li	a2,1
    80000fc8:	040005b7          	lui	a1,0x4000
    80000fcc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fce:	05b2                	slli	a1,a1,0xc
    80000fd0:	fffff097          	auipc	ra,0xfffff
    80000fd4:	73c080e7          	jalr	1852(ra) # 8000070c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fd8:	4681                	li	a3,0
    80000fda:	4605                	li	a2,1
    80000fdc:	020005b7          	lui	a1,0x2000
    80000fe0:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fe2:	05b6                	slli	a1,a1,0xd
    80000fe4:	8526                	mv	a0,s1
    80000fe6:	fffff097          	auipc	ra,0xfffff
    80000fea:	726080e7          	jalr	1830(ra) # 8000070c <uvmunmap>
  uvmfree(pagetable, sz);
    80000fee:	85ca                	mv	a1,s2
    80000ff0:	8526                	mv	a0,s1
    80000ff2:	00000097          	auipc	ra,0x0
    80000ff6:	9e4080e7          	jalr	-1564(ra) # 800009d6 <uvmfree>
}
    80000ffa:	60e2                	ld	ra,24(sp)
    80000ffc:	6442                	ld	s0,16(sp)
    80000ffe:	64a2                	ld	s1,8(sp)
    80001000:	6902                	ld	s2,0(sp)
    80001002:	6105                	addi	sp,sp,32
    80001004:	8082                	ret

0000000080001006 <freeproc>:
static void freeproc(struct proc *p) {
    80001006:	1101                	addi	sp,sp,-32
    80001008:	ec06                	sd	ra,24(sp)
    8000100a:	e822                	sd	s0,16(sp)
    8000100c:	e426                	sd	s1,8(sp)
    8000100e:	1000                	addi	s0,sp,32
    80001010:	84aa                	mv	s1,a0
  if (p->trapframe) kfree((void *)p->trapframe);
    80001012:	6d28                	ld	a0,88(a0)
    80001014:	c509                	beqz	a0,8000101e <freeproc+0x18>
    80001016:	fffff097          	auipc	ra,0xfffff
    8000101a:	006080e7          	jalr	6(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000101e:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable) proc_freepagetable(p->pagetable, p->sz);
    80001022:	68a8                	ld	a0,80(s1)
    80001024:	c511                	beqz	a0,80001030 <freeproc+0x2a>
    80001026:	64ac                	ld	a1,72(s1)
    80001028:	00000097          	auipc	ra,0x0
    8000102c:	f8c080e7          	jalr	-116(ra) # 80000fb4 <proc_freepagetable>
  p->pagetable = 0;
    80001030:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001034:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001038:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000103c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001040:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001044:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001048:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000104c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001050:	0004ac23          	sw	zero,24(s1)
}
    80001054:	60e2                	ld	ra,24(sp)
    80001056:	6442                	ld	s0,16(sp)
    80001058:	64a2                	ld	s1,8(sp)
    8000105a:	6105                	addi	sp,sp,32
    8000105c:	8082                	ret

000000008000105e <allocproc>:
static struct proc *allocproc(void) {
    8000105e:	1101                	addi	sp,sp,-32
    80001060:	ec06                	sd	ra,24(sp)
    80001062:	e822                	sd	s0,16(sp)
    80001064:	e426                	sd	s1,8(sp)
    80001066:	e04a                	sd	s2,0(sp)
    80001068:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) {
    8000106a:	00008497          	auipc	s1,0x8
    8000106e:	ce648493          	addi	s1,s1,-794 # 80008d50 <proc>
    80001072:	0000d917          	auipc	s2,0xd
    80001076:	6de90913          	addi	s2,s2,1758 # 8000e750 <tickslock>
    acquire(&p->lock);
    8000107a:	8526                	mv	a0,s1
    8000107c:	00005097          	auipc	ra,0x5
    80001080:	198080e7          	jalr	408(ra) # 80006214 <acquire>
    if (p->state == UNUSED) {
    80001084:	4c9c                	lw	a5,24(s1)
    80001086:	cf81                	beqz	a5,8000109e <allocproc+0x40>
      release(&p->lock);
    80001088:	8526                	mv	a0,s1
    8000108a:	00005097          	auipc	ra,0x5
    8000108e:	23e080e7          	jalr	574(ra) # 800062c8 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001092:	16848493          	addi	s1,s1,360
    80001096:	ff2492e3          	bne	s1,s2,8000107a <allocproc+0x1c>
  return 0;
    8000109a:	4481                	li	s1,0
    8000109c:	a889                	j	800010ee <allocproc+0x90>
  p->pid = allocpid();
    8000109e:	00000097          	auipc	ra,0x0
    800010a2:	e34080e7          	jalr	-460(ra) # 80000ed2 <allocpid>
    800010a6:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010a8:	4785                	li	a5,1
    800010aa:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    800010ac:	fffff097          	auipc	ra,0xfffff
    800010b0:	06e080e7          	jalr	110(ra) # 8000011a <kalloc>
    800010b4:	892a                	mv	s2,a0
    800010b6:	eca8                	sd	a0,88(s1)
    800010b8:	c131                	beqz	a0,800010fc <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010ba:	8526                	mv	a0,s1
    800010bc:	00000097          	auipc	ra,0x0
    800010c0:	e5c080e7          	jalr	-420(ra) # 80000f18 <proc_pagetable>
    800010c4:	892a                	mv	s2,a0
    800010c6:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0) {
    800010c8:	c531                	beqz	a0,80001114 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010ca:	07000613          	li	a2,112
    800010ce:	4581                	li	a1,0
    800010d0:	06048513          	addi	a0,s1,96
    800010d4:	fffff097          	auipc	ra,0xfffff
    800010d8:	0a6080e7          	jalr	166(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    800010dc:	00000797          	auipc	a5,0x0
    800010e0:	db078793          	addi	a5,a5,-592 # 80000e8c <forkret>
    800010e4:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010e6:	60bc                	ld	a5,64(s1)
    800010e8:	6705                	lui	a4,0x1
    800010ea:	97ba                	add	a5,a5,a4
    800010ec:	f4bc                	sd	a5,104(s1)
}
    800010ee:	8526                	mv	a0,s1
    800010f0:	60e2                	ld	ra,24(sp)
    800010f2:	6442                	ld	s0,16(sp)
    800010f4:	64a2                	ld	s1,8(sp)
    800010f6:	6902                	ld	s2,0(sp)
    800010f8:	6105                	addi	sp,sp,32
    800010fa:	8082                	ret
    freeproc(p);
    800010fc:	8526                	mv	a0,s1
    800010fe:	00000097          	auipc	ra,0x0
    80001102:	f08080e7          	jalr	-248(ra) # 80001006 <freeproc>
    release(&p->lock);
    80001106:	8526                	mv	a0,s1
    80001108:	00005097          	auipc	ra,0x5
    8000110c:	1c0080e7          	jalr	448(ra) # 800062c8 <release>
    return 0;
    80001110:	84ca                	mv	s1,s2
    80001112:	bff1                	j	800010ee <allocproc+0x90>
    freeproc(p);
    80001114:	8526                	mv	a0,s1
    80001116:	00000097          	auipc	ra,0x0
    8000111a:	ef0080e7          	jalr	-272(ra) # 80001006 <freeproc>
    release(&p->lock);
    8000111e:	8526                	mv	a0,s1
    80001120:	00005097          	auipc	ra,0x5
    80001124:	1a8080e7          	jalr	424(ra) # 800062c8 <release>
    return 0;
    80001128:	84ca                	mv	s1,s2
    8000112a:	b7d1                	j	800010ee <allocproc+0x90>

000000008000112c <userinit>:
void userinit(void) {
    8000112c:	1101                	addi	sp,sp,-32
    8000112e:	ec06                	sd	ra,24(sp)
    80001130:	e822                	sd	s0,16(sp)
    80001132:	e426                	sd	s1,8(sp)
    80001134:	1000                	addi	s0,sp,32
  p = allocproc();
    80001136:	00000097          	auipc	ra,0x0
    8000113a:	f28080e7          	jalr	-216(ra) # 8000105e <allocproc>
    8000113e:	84aa                	mv	s1,a0
  initproc = p;
    80001140:	00007797          	auipc	a5,0x7
    80001144:	7aa7b023          	sd	a0,1952(a5) # 800088e0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001148:	03400613          	li	a2,52
    8000114c:	00007597          	auipc	a1,0x7
    80001150:	72458593          	addi	a1,a1,1828 # 80008870 <initcode>
    80001154:	6928                	ld	a0,80(a0)
    80001156:	fffff097          	auipc	ra,0xfffff
    8000115a:	6a8080e7          	jalr	1704(ra) # 800007fe <uvmfirst>
  p->sz = PGSIZE;
    8000115e:	6785                	lui	a5,0x1
    80001160:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001162:	6cb8                	ld	a4,88(s1)
    80001164:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001168:	6cb8                	ld	a4,88(s1)
    8000116a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000116c:	4641                	li	a2,16
    8000116e:	00007597          	auipc	a1,0x7
    80001172:	01258593          	addi	a1,a1,18 # 80008180 <etext+0x180>
    80001176:	15848513          	addi	a0,s1,344
    8000117a:	fffff097          	auipc	ra,0xfffff
    8000117e:	14a080e7          	jalr	330(ra) # 800002c4 <safestrcpy>
  p->cwd = namei("/");
    80001182:	00007517          	auipc	a0,0x7
    80001186:	00e50513          	addi	a0,a0,14 # 80008190 <etext+0x190>
    8000118a:	00002097          	auipc	ra,0x2
    8000118e:	244080e7          	jalr	580(ra) # 800033ce <namei>
    80001192:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001196:	478d                	li	a5,3
    80001198:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000119a:	8526                	mv	a0,s1
    8000119c:	00005097          	auipc	ra,0x5
    800011a0:	12c080e7          	jalr	300(ra) # 800062c8 <release>
}
    800011a4:	60e2                	ld	ra,24(sp)
    800011a6:	6442                	ld	s0,16(sp)
    800011a8:	64a2                	ld	s1,8(sp)
    800011aa:	6105                	addi	sp,sp,32
    800011ac:	8082                	ret

00000000800011ae <growproc>:
int growproc(int n) {
    800011ae:	1101                	addi	sp,sp,-32
    800011b0:	ec06                	sd	ra,24(sp)
    800011b2:	e822                	sd	s0,16(sp)
    800011b4:	e426                	sd	s1,8(sp)
    800011b6:	e04a                	sd	s2,0(sp)
    800011b8:	1000                	addi	s0,sp,32
    800011ba:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800011bc:	00000097          	auipc	ra,0x0
    800011c0:	c98080e7          	jalr	-872(ra) # 80000e54 <myproc>
    800011c4:	84aa                	mv	s1,a0
  sz = p->sz;
    800011c6:	652c                	ld	a1,72(a0)
  if (n > 0) {
    800011c8:	01204c63          	bgtz	s2,800011e0 <growproc+0x32>
  } else if (n < 0) {
    800011cc:	02094663          	bltz	s2,800011f8 <growproc+0x4a>
  p->sz = sz;
    800011d0:	e4ac                	sd	a1,72(s1)
  return 0;
    800011d2:	4501                	li	a0,0
}
    800011d4:	60e2                	ld	ra,24(sp)
    800011d6:	6442                	ld	s0,16(sp)
    800011d8:	64a2                	ld	s1,8(sp)
    800011da:	6902                	ld	s2,0(sp)
    800011dc:	6105                	addi	sp,sp,32
    800011de:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800011e0:	4691                	li	a3,4
    800011e2:	00b90633          	add	a2,s2,a1
    800011e6:	6928                	ld	a0,80(a0)
    800011e8:	fffff097          	auipc	ra,0xfffff
    800011ec:	6d0080e7          	jalr	1744(ra) # 800008b8 <uvmalloc>
    800011f0:	85aa                	mv	a1,a0
    800011f2:	fd79                	bnez	a0,800011d0 <growproc+0x22>
      return -1;
    800011f4:	557d                	li	a0,-1
    800011f6:	bff9                	j	800011d4 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011f8:	00b90633          	add	a2,s2,a1
    800011fc:	6928                	ld	a0,80(a0)
    800011fe:	fffff097          	auipc	ra,0xfffff
    80001202:	672080e7          	jalr	1650(ra) # 80000870 <uvmdealloc>
    80001206:	85aa                	mv	a1,a0
    80001208:	b7e1                	j	800011d0 <growproc+0x22>

000000008000120a <fork>:
int fork(void) {
    8000120a:	7139                	addi	sp,sp,-64
    8000120c:	fc06                	sd	ra,56(sp)
    8000120e:	f822                	sd	s0,48(sp)
    80001210:	f426                	sd	s1,40(sp)
    80001212:	f04a                	sd	s2,32(sp)
    80001214:	ec4e                	sd	s3,24(sp)
    80001216:	e852                	sd	s4,16(sp)
    80001218:	e456                	sd	s5,8(sp)
    8000121a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000121c:	00000097          	auipc	ra,0x0
    80001220:	c38080e7          	jalr	-968(ra) # 80000e54 <myproc>
    80001224:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    80001226:	00000097          	auipc	ra,0x0
    8000122a:	e38080e7          	jalr	-456(ra) # 8000105e <allocproc>
    8000122e:	10050c63          	beqz	a0,80001346 <fork+0x13c>
    80001232:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    80001234:	048ab603          	ld	a2,72(s5)
    80001238:	692c                	ld	a1,80(a0)
    8000123a:	050ab503          	ld	a0,80(s5)
    8000123e:	fffff097          	auipc	ra,0xfffff
    80001242:	7d2080e7          	jalr	2002(ra) # 80000a10 <uvmcopy>
    80001246:	04054863          	bltz	a0,80001296 <fork+0x8c>
  np->sz = p->sz;
    8000124a:	048ab783          	ld	a5,72(s5)
    8000124e:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001252:	058ab683          	ld	a3,88(s5)
    80001256:	87b6                	mv	a5,a3
    80001258:	058a3703          	ld	a4,88(s4)
    8000125c:	12068693          	addi	a3,a3,288
    80001260:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001264:	6788                	ld	a0,8(a5)
    80001266:	6b8c                	ld	a1,16(a5)
    80001268:	6f90                	ld	a2,24(a5)
    8000126a:	01073023          	sd	a6,0(a4)
    8000126e:	e708                	sd	a0,8(a4)
    80001270:	eb0c                	sd	a1,16(a4)
    80001272:	ef10                	sd	a2,24(a4)
    80001274:	02078793          	addi	a5,a5,32
    80001278:	02070713          	addi	a4,a4,32
    8000127c:	fed792e3          	bne	a5,a3,80001260 <fork+0x56>
  np->trapframe->a0 = 0;
    80001280:	058a3783          	ld	a5,88(s4)
    80001284:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    80001288:	0d0a8493          	addi	s1,s5,208
    8000128c:	0d0a0913          	addi	s2,s4,208
    80001290:	150a8993          	addi	s3,s5,336
    80001294:	a00d                	j	800012b6 <fork+0xac>
    freeproc(np);
    80001296:	8552                	mv	a0,s4
    80001298:	00000097          	auipc	ra,0x0
    8000129c:	d6e080e7          	jalr	-658(ra) # 80001006 <freeproc>
    release(&np->lock);
    800012a0:	8552                	mv	a0,s4
    800012a2:	00005097          	auipc	ra,0x5
    800012a6:	026080e7          	jalr	38(ra) # 800062c8 <release>
    return -1;
    800012aa:	597d                	li	s2,-1
    800012ac:	a059                	j	80001332 <fork+0x128>
  for (i = 0; i < NOFILE; i++)
    800012ae:	04a1                	addi	s1,s1,8
    800012b0:	0921                	addi	s2,s2,8
    800012b2:	01348b63          	beq	s1,s3,800012c8 <fork+0xbe>
    if (p->ofile[i]) np->ofile[i] = filedup(p->ofile[i]);
    800012b6:	6088                	ld	a0,0(s1)
    800012b8:	d97d                	beqz	a0,800012ae <fork+0xa4>
    800012ba:	00002097          	auipc	ra,0x2
    800012be:	7aa080e7          	jalr	1962(ra) # 80003a64 <filedup>
    800012c2:	00a93023          	sd	a0,0(s2)
    800012c6:	b7e5                	j	800012ae <fork+0xa4>
  np->cwd = idup(p->cwd);
    800012c8:	150ab503          	ld	a0,336(s5)
    800012cc:	00002097          	auipc	ra,0x2
    800012d0:	918080e7          	jalr	-1768(ra) # 80002be4 <idup>
    800012d4:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012d8:	4641                	li	a2,16
    800012da:	158a8593          	addi	a1,s5,344
    800012de:	158a0513          	addi	a0,s4,344
    800012e2:	fffff097          	auipc	ra,0xfffff
    800012e6:	fe2080e7          	jalr	-30(ra) # 800002c4 <safestrcpy>
  pid = np->pid;
    800012ea:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800012ee:	8552                	mv	a0,s4
    800012f0:	00005097          	auipc	ra,0x5
    800012f4:	fd8080e7          	jalr	-40(ra) # 800062c8 <release>
  acquire(&wait_lock);
    800012f8:	00007497          	auipc	s1,0x7
    800012fc:	64048493          	addi	s1,s1,1600 # 80008938 <wait_lock>
    80001300:	8526                	mv	a0,s1
    80001302:	00005097          	auipc	ra,0x5
    80001306:	f12080e7          	jalr	-238(ra) # 80006214 <acquire>
  np->parent = p;
    8000130a:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000130e:	8526                	mv	a0,s1
    80001310:	00005097          	auipc	ra,0x5
    80001314:	fb8080e7          	jalr	-72(ra) # 800062c8 <release>
  acquire(&np->lock);
    80001318:	8552                	mv	a0,s4
    8000131a:	00005097          	auipc	ra,0x5
    8000131e:	efa080e7          	jalr	-262(ra) # 80006214 <acquire>
  np->state = RUNNABLE;
    80001322:	478d                	li	a5,3
    80001324:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001328:	8552                	mv	a0,s4
    8000132a:	00005097          	auipc	ra,0x5
    8000132e:	f9e080e7          	jalr	-98(ra) # 800062c8 <release>
}
    80001332:	854a                	mv	a0,s2
    80001334:	70e2                	ld	ra,56(sp)
    80001336:	7442                	ld	s0,48(sp)
    80001338:	74a2                	ld	s1,40(sp)
    8000133a:	7902                	ld	s2,32(sp)
    8000133c:	69e2                	ld	s3,24(sp)
    8000133e:	6a42                	ld	s4,16(sp)
    80001340:	6aa2                	ld	s5,8(sp)
    80001342:	6121                	addi	sp,sp,64
    80001344:	8082                	ret
    return -1;
    80001346:	597d                	li	s2,-1
    80001348:	b7ed                	j	80001332 <fork+0x128>

000000008000134a <scheduler>:
void scheduler(void) {
    8000134a:	7139                	addi	sp,sp,-64
    8000134c:	fc06                	sd	ra,56(sp)
    8000134e:	f822                	sd	s0,48(sp)
    80001350:	f426                	sd	s1,40(sp)
    80001352:	f04a                	sd	s2,32(sp)
    80001354:	ec4e                	sd	s3,24(sp)
    80001356:	e852                	sd	s4,16(sp)
    80001358:	e456                	sd	s5,8(sp)
    8000135a:	e05a                	sd	s6,0(sp)
    8000135c:	0080                	addi	s0,sp,64
    8000135e:	8792                	mv	a5,tp
  int id = r_tp();
    80001360:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001362:	00779a93          	slli	s5,a5,0x7
    80001366:	00007717          	auipc	a4,0x7
    8000136a:	5ba70713          	addi	a4,a4,1466 # 80008920 <pid_lock>
    8000136e:	9756                	add	a4,a4,s5
    80001370:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001374:	00007717          	auipc	a4,0x7
    80001378:	5e470713          	addi	a4,a4,1508 # 80008958 <cpus+0x8>
    8000137c:	9aba                	add	s5,s5,a4
      if (p->state == RUNNABLE) {
    8000137e:	498d                	li	s3,3
        p->state = RUNNING;
    80001380:	4b11                	li	s6,4
        c->proc = p;
    80001382:	079e                	slli	a5,a5,0x7
    80001384:	00007a17          	auipc	s4,0x7
    80001388:	59ca0a13          	addi	s4,s4,1436 # 80008920 <pid_lock>
    8000138c:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++) {
    8000138e:	0000d917          	auipc	s2,0xd
    80001392:	3c290913          	addi	s2,s2,962 # 8000e750 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001396:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    8000139a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    8000139e:	10079073          	csrw	sstatus,a5
    800013a2:	00008497          	auipc	s1,0x8
    800013a6:	9ae48493          	addi	s1,s1,-1618 # 80008d50 <proc>
    800013aa:	a811                	j	800013be <scheduler+0x74>
      release(&p->lock);
    800013ac:	8526                	mv	a0,s1
    800013ae:	00005097          	auipc	ra,0x5
    800013b2:	f1a080e7          	jalr	-230(ra) # 800062c8 <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    800013b6:	16848493          	addi	s1,s1,360
    800013ba:	fd248ee3          	beq	s1,s2,80001396 <scheduler+0x4c>
      acquire(&p->lock);
    800013be:	8526                	mv	a0,s1
    800013c0:	00005097          	auipc	ra,0x5
    800013c4:	e54080e7          	jalr	-428(ra) # 80006214 <acquire>
      if (p->state == RUNNABLE) {
    800013c8:	4c9c                	lw	a5,24(s1)
    800013ca:	ff3791e3          	bne	a5,s3,800013ac <scheduler+0x62>
        p->state = RUNNING;
    800013ce:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013d2:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013d6:	06048593          	addi	a1,s1,96
    800013da:	8556                	mv	a0,s5
    800013dc:	00000097          	auipc	ra,0x0
    800013e0:	76c080e7          	jalr	1900(ra) # 80001b48 <swtch>
        c->proc = 0;
    800013e4:	020a3823          	sd	zero,48(s4)
    800013e8:	b7d1                	j	800013ac <scheduler+0x62>

00000000800013ea <sched>:
void sched(void) {
    800013ea:	7179                	addi	sp,sp,-48
    800013ec:	f406                	sd	ra,40(sp)
    800013ee:	f022                	sd	s0,32(sp)
    800013f0:	ec26                	sd	s1,24(sp)
    800013f2:	e84a                	sd	s2,16(sp)
    800013f4:	e44e                	sd	s3,8(sp)
    800013f6:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013f8:	00000097          	auipc	ra,0x0
    800013fc:	a5c080e7          	jalr	-1444(ra) # 80000e54 <myproc>
    80001400:	84aa                	mv	s1,a0
  if (!holding(&p->lock)) panic("sched p->lock");
    80001402:	00005097          	auipc	ra,0x5
    80001406:	d98080e7          	jalr	-616(ra) # 8000619a <holding>
    8000140a:	c93d                	beqz	a0,80001480 <sched+0x96>
  asm volatile("mv %0, tp" : "=r"(x));
    8000140c:	8792                	mv	a5,tp
  if (mycpu()->noff != 1) panic("sched locks");
    8000140e:	2781                	sext.w	a5,a5
    80001410:	079e                	slli	a5,a5,0x7
    80001412:	00007717          	auipc	a4,0x7
    80001416:	50e70713          	addi	a4,a4,1294 # 80008920 <pid_lock>
    8000141a:	97ba                	add	a5,a5,a4
    8000141c:	0a87a703          	lw	a4,168(a5)
    80001420:	4785                	li	a5,1
    80001422:	06f71763          	bne	a4,a5,80001490 <sched+0xa6>
  if (p->state == RUNNING) panic("sched running");
    80001426:	4c98                	lw	a4,24(s1)
    80001428:	4791                	li	a5,4
    8000142a:	06f70b63          	beq	a4,a5,800014a0 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000142e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001432:	8b89                	andi	a5,a5,2
  if (intr_get()) panic("sched interruptible");
    80001434:	efb5                	bnez	a5,800014b0 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r"(x));
    80001436:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001438:	00007917          	auipc	s2,0x7
    8000143c:	4e890913          	addi	s2,s2,1256 # 80008920 <pid_lock>
    80001440:	2781                	sext.w	a5,a5
    80001442:	079e                	slli	a5,a5,0x7
    80001444:	97ca                	add	a5,a5,s2
    80001446:	0ac7a983          	lw	s3,172(a5)
    8000144a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000144c:	2781                	sext.w	a5,a5
    8000144e:	079e                	slli	a5,a5,0x7
    80001450:	00007597          	auipc	a1,0x7
    80001454:	50858593          	addi	a1,a1,1288 # 80008958 <cpus+0x8>
    80001458:	95be                	add	a1,a1,a5
    8000145a:	06048513          	addi	a0,s1,96
    8000145e:	00000097          	auipc	ra,0x0
    80001462:	6ea080e7          	jalr	1770(ra) # 80001b48 <swtch>
    80001466:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001468:	2781                	sext.w	a5,a5
    8000146a:	079e                	slli	a5,a5,0x7
    8000146c:	993e                	add	s2,s2,a5
    8000146e:	0b392623          	sw	s3,172(s2)
}
    80001472:	70a2                	ld	ra,40(sp)
    80001474:	7402                	ld	s0,32(sp)
    80001476:	64e2                	ld	s1,24(sp)
    80001478:	6942                	ld	s2,16(sp)
    8000147a:	69a2                	ld	s3,8(sp)
    8000147c:	6145                	addi	sp,sp,48
    8000147e:	8082                	ret
  if (!holding(&p->lock)) panic("sched p->lock");
    80001480:	00007517          	auipc	a0,0x7
    80001484:	d1850513          	addi	a0,a0,-744 # 80008198 <etext+0x198>
    80001488:	00005097          	auipc	ra,0x5
    8000148c:	854080e7          	jalr	-1964(ra) # 80005cdc <panic>
  if (mycpu()->noff != 1) panic("sched locks");
    80001490:	00007517          	auipc	a0,0x7
    80001494:	d1850513          	addi	a0,a0,-744 # 800081a8 <etext+0x1a8>
    80001498:	00005097          	auipc	ra,0x5
    8000149c:	844080e7          	jalr	-1980(ra) # 80005cdc <panic>
  if (p->state == RUNNING) panic("sched running");
    800014a0:	00007517          	auipc	a0,0x7
    800014a4:	d1850513          	addi	a0,a0,-744 # 800081b8 <etext+0x1b8>
    800014a8:	00005097          	auipc	ra,0x5
    800014ac:	834080e7          	jalr	-1996(ra) # 80005cdc <panic>
  if (intr_get()) panic("sched interruptible");
    800014b0:	00007517          	auipc	a0,0x7
    800014b4:	d1850513          	addi	a0,a0,-744 # 800081c8 <etext+0x1c8>
    800014b8:	00005097          	auipc	ra,0x5
    800014bc:	824080e7          	jalr	-2012(ra) # 80005cdc <panic>

00000000800014c0 <yield>:
void yield(void) {
    800014c0:	1101                	addi	sp,sp,-32
    800014c2:	ec06                	sd	ra,24(sp)
    800014c4:	e822                	sd	s0,16(sp)
    800014c6:	e426                	sd	s1,8(sp)
    800014c8:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014ca:	00000097          	auipc	ra,0x0
    800014ce:	98a080e7          	jalr	-1654(ra) # 80000e54 <myproc>
    800014d2:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014d4:	00005097          	auipc	ra,0x5
    800014d8:	d40080e7          	jalr	-704(ra) # 80006214 <acquire>
  p->state = RUNNABLE;
    800014dc:	478d                	li	a5,3
    800014de:	cc9c                	sw	a5,24(s1)
  sched();
    800014e0:	00000097          	auipc	ra,0x0
    800014e4:	f0a080e7          	jalr	-246(ra) # 800013ea <sched>
  release(&p->lock);
    800014e8:	8526                	mv	a0,s1
    800014ea:	00005097          	auipc	ra,0x5
    800014ee:	dde080e7          	jalr	-546(ra) # 800062c8 <release>
}
    800014f2:	60e2                	ld	ra,24(sp)
    800014f4:	6442                	ld	s0,16(sp)
    800014f6:	64a2                	ld	s1,8(sp)
    800014f8:	6105                	addi	sp,sp,32
    800014fa:	8082                	ret

00000000800014fc <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk) {
    800014fc:	7179                	addi	sp,sp,-48
    800014fe:	f406                	sd	ra,40(sp)
    80001500:	f022                	sd	s0,32(sp)
    80001502:	ec26                	sd	s1,24(sp)
    80001504:	e84a                	sd	s2,16(sp)
    80001506:	e44e                	sd	s3,8(sp)
    80001508:	1800                	addi	s0,sp,48
    8000150a:	89aa                	mv	s3,a0
    8000150c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000150e:	00000097          	auipc	ra,0x0
    80001512:	946080e7          	jalr	-1722(ra) # 80000e54 <myproc>
    80001516:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  // DOC: sleeplock1
    80001518:	00005097          	auipc	ra,0x5
    8000151c:	cfc080e7          	jalr	-772(ra) # 80006214 <acquire>
  release(lk);
    80001520:	854a                	mv	a0,s2
    80001522:	00005097          	auipc	ra,0x5
    80001526:	da6080e7          	jalr	-602(ra) # 800062c8 <release>

  // Go to sleep.
  p->chan = chan;
    8000152a:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000152e:	4789                	li	a5,2
    80001530:	cc9c                	sw	a5,24(s1)

  sched();
    80001532:	00000097          	auipc	ra,0x0
    80001536:	eb8080e7          	jalr	-328(ra) # 800013ea <sched>

  // Tidy up.
  p->chan = 0;
    8000153a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000153e:	8526                	mv	a0,s1
    80001540:	00005097          	auipc	ra,0x5
    80001544:	d88080e7          	jalr	-632(ra) # 800062c8 <release>
  acquire(lk);
    80001548:	854a                	mv	a0,s2
    8000154a:	00005097          	auipc	ra,0x5
    8000154e:	cca080e7          	jalr	-822(ra) # 80006214 <acquire>
}
    80001552:	70a2                	ld	ra,40(sp)
    80001554:	7402                	ld	s0,32(sp)
    80001556:	64e2                	ld	s1,24(sp)
    80001558:	6942                	ld	s2,16(sp)
    8000155a:	69a2                	ld	s3,8(sp)
    8000155c:	6145                	addi	sp,sp,48
    8000155e:	8082                	ret

0000000080001560 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan) {
    80001560:	7139                	addi	sp,sp,-64
    80001562:	fc06                	sd	ra,56(sp)
    80001564:	f822                	sd	s0,48(sp)
    80001566:	f426                	sd	s1,40(sp)
    80001568:	f04a                	sd	s2,32(sp)
    8000156a:	ec4e                	sd	s3,24(sp)
    8000156c:	e852                	sd	s4,16(sp)
    8000156e:	e456                	sd	s5,8(sp)
    80001570:	0080                	addi	s0,sp,64
    80001572:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80001574:	00007497          	auipc	s1,0x7
    80001578:	7dc48493          	addi	s1,s1,2012 # 80008d50 <proc>
    if (p != myproc()) {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan) {
    8000157c:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000157e:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++) {
    80001580:	0000d917          	auipc	s2,0xd
    80001584:	1d090913          	addi	s2,s2,464 # 8000e750 <tickslock>
    80001588:	a811                	j	8000159c <wakeup+0x3c>
      }
      release(&p->lock);
    8000158a:	8526                	mv	a0,s1
    8000158c:	00005097          	auipc	ra,0x5
    80001590:	d3c080e7          	jalr	-708(ra) # 800062c8 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001594:	16848493          	addi	s1,s1,360
    80001598:	03248663          	beq	s1,s2,800015c4 <wakeup+0x64>
    if (p != myproc()) {
    8000159c:	00000097          	auipc	ra,0x0
    800015a0:	8b8080e7          	jalr	-1864(ra) # 80000e54 <myproc>
    800015a4:	fea488e3          	beq	s1,a0,80001594 <wakeup+0x34>
      acquire(&p->lock);
    800015a8:	8526                	mv	a0,s1
    800015aa:	00005097          	auipc	ra,0x5
    800015ae:	c6a080e7          	jalr	-918(ra) # 80006214 <acquire>
      if (p->state == SLEEPING && p->chan == chan) {
    800015b2:	4c9c                	lw	a5,24(s1)
    800015b4:	fd379be3          	bne	a5,s3,8000158a <wakeup+0x2a>
    800015b8:	709c                	ld	a5,32(s1)
    800015ba:	fd4798e3          	bne	a5,s4,8000158a <wakeup+0x2a>
        p->state = RUNNABLE;
    800015be:	0154ac23          	sw	s5,24(s1)
    800015c2:	b7e1                	j	8000158a <wakeup+0x2a>
    }
  }
}
    800015c4:	70e2                	ld	ra,56(sp)
    800015c6:	7442                	ld	s0,48(sp)
    800015c8:	74a2                	ld	s1,40(sp)
    800015ca:	7902                	ld	s2,32(sp)
    800015cc:	69e2                	ld	s3,24(sp)
    800015ce:	6a42                	ld	s4,16(sp)
    800015d0:	6aa2                	ld	s5,8(sp)
    800015d2:	6121                	addi	sp,sp,64
    800015d4:	8082                	ret

00000000800015d6 <reparent>:
void reparent(struct proc *p) {
    800015d6:	7179                	addi	sp,sp,-48
    800015d8:	f406                	sd	ra,40(sp)
    800015da:	f022                	sd	s0,32(sp)
    800015dc:	ec26                	sd	s1,24(sp)
    800015de:	e84a                	sd	s2,16(sp)
    800015e0:	e44e                	sd	s3,8(sp)
    800015e2:	e052                	sd	s4,0(sp)
    800015e4:	1800                	addi	s0,sp,48
    800015e6:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    800015e8:	00007497          	auipc	s1,0x7
    800015ec:	76848493          	addi	s1,s1,1896 # 80008d50 <proc>
      pp->parent = initproc;
    800015f0:	00007a17          	auipc	s4,0x7
    800015f4:	2f0a0a13          	addi	s4,s4,752 # 800088e0 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    800015f8:	0000d997          	auipc	s3,0xd
    800015fc:	15898993          	addi	s3,s3,344 # 8000e750 <tickslock>
    80001600:	a029                	j	8000160a <reparent+0x34>
    80001602:	16848493          	addi	s1,s1,360
    80001606:	01348d63          	beq	s1,s3,80001620 <reparent+0x4a>
    if (pp->parent == p) {
    8000160a:	7c9c                	ld	a5,56(s1)
    8000160c:	ff279be3          	bne	a5,s2,80001602 <reparent+0x2c>
      pp->parent = initproc;
    80001610:	000a3503          	ld	a0,0(s4)
    80001614:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001616:	00000097          	auipc	ra,0x0
    8000161a:	f4a080e7          	jalr	-182(ra) # 80001560 <wakeup>
    8000161e:	b7d5                	j	80001602 <reparent+0x2c>
}
    80001620:	70a2                	ld	ra,40(sp)
    80001622:	7402                	ld	s0,32(sp)
    80001624:	64e2                	ld	s1,24(sp)
    80001626:	6942                	ld	s2,16(sp)
    80001628:	69a2                	ld	s3,8(sp)
    8000162a:	6a02                	ld	s4,0(sp)
    8000162c:	6145                	addi	sp,sp,48
    8000162e:	8082                	ret

0000000080001630 <exit>:
void exit(int status) {
    80001630:	7179                	addi	sp,sp,-48
    80001632:	f406                	sd	ra,40(sp)
    80001634:	f022                	sd	s0,32(sp)
    80001636:	ec26                	sd	s1,24(sp)
    80001638:	e84a                	sd	s2,16(sp)
    8000163a:	e44e                	sd	s3,8(sp)
    8000163c:	e052                	sd	s4,0(sp)
    8000163e:	1800                	addi	s0,sp,48
    80001640:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001642:	00000097          	auipc	ra,0x0
    80001646:	812080e7          	jalr	-2030(ra) # 80000e54 <myproc>
    8000164a:	89aa                	mv	s3,a0
  if (p == initproc) panic("init exiting");
    8000164c:	00007797          	auipc	a5,0x7
    80001650:	2947b783          	ld	a5,660(a5) # 800088e0 <initproc>
    80001654:	0d050493          	addi	s1,a0,208
    80001658:	15050913          	addi	s2,a0,336
    8000165c:	02a79363          	bne	a5,a0,80001682 <exit+0x52>
    80001660:	00007517          	auipc	a0,0x7
    80001664:	b8050513          	addi	a0,a0,-1152 # 800081e0 <etext+0x1e0>
    80001668:	00004097          	auipc	ra,0x4
    8000166c:	674080e7          	jalr	1652(ra) # 80005cdc <panic>
      fileclose(f);
    80001670:	00002097          	auipc	ra,0x2
    80001674:	446080e7          	jalr	1094(ra) # 80003ab6 <fileclose>
      p->ofile[fd] = 0;
    80001678:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++) {
    8000167c:	04a1                	addi	s1,s1,8
    8000167e:	01248563          	beq	s1,s2,80001688 <exit+0x58>
    if (p->ofile[fd]) {
    80001682:	6088                	ld	a0,0(s1)
    80001684:	f575                	bnez	a0,80001670 <exit+0x40>
    80001686:	bfdd                	j	8000167c <exit+0x4c>
  begin_op();
    80001688:	00002097          	auipc	ra,0x2
    8000168c:	f66080e7          	jalr	-154(ra) # 800035ee <begin_op>
  iput(p->cwd);
    80001690:	1509b503          	ld	a0,336(s3)
    80001694:	00001097          	auipc	ra,0x1
    80001698:	748080e7          	jalr	1864(ra) # 80002ddc <iput>
  end_op();
    8000169c:	00002097          	auipc	ra,0x2
    800016a0:	fd0080e7          	jalr	-48(ra) # 8000366c <end_op>
  p->cwd = 0;
    800016a4:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800016a8:	00007497          	auipc	s1,0x7
    800016ac:	29048493          	addi	s1,s1,656 # 80008938 <wait_lock>
    800016b0:	8526                	mv	a0,s1
    800016b2:	00005097          	auipc	ra,0x5
    800016b6:	b62080e7          	jalr	-1182(ra) # 80006214 <acquire>
  reparent(p);
    800016ba:	854e                	mv	a0,s3
    800016bc:	00000097          	auipc	ra,0x0
    800016c0:	f1a080e7          	jalr	-230(ra) # 800015d6 <reparent>
  wakeup(p->parent);
    800016c4:	0389b503          	ld	a0,56(s3)
    800016c8:	00000097          	auipc	ra,0x0
    800016cc:	e98080e7          	jalr	-360(ra) # 80001560 <wakeup>
  acquire(&p->lock);
    800016d0:	854e                	mv	a0,s3
    800016d2:	00005097          	auipc	ra,0x5
    800016d6:	b42080e7          	jalr	-1214(ra) # 80006214 <acquire>
  p->xstate = status;
    800016da:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800016de:	4795                	li	a5,5
    800016e0:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800016e4:	8526                	mv	a0,s1
    800016e6:	00005097          	auipc	ra,0x5
    800016ea:	be2080e7          	jalr	-1054(ra) # 800062c8 <release>
  sched();
    800016ee:	00000097          	auipc	ra,0x0
    800016f2:	cfc080e7          	jalr	-772(ra) # 800013ea <sched>
  panic("zombie exit");
    800016f6:	00007517          	auipc	a0,0x7
    800016fa:	afa50513          	addi	a0,a0,-1286 # 800081f0 <etext+0x1f0>
    800016fe:	00004097          	auipc	ra,0x4
    80001702:	5de080e7          	jalr	1502(ra) # 80005cdc <panic>

0000000080001706 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid) {
    80001706:	7179                	addi	sp,sp,-48
    80001708:	f406                	sd	ra,40(sp)
    8000170a:	f022                	sd	s0,32(sp)
    8000170c:	ec26                	sd	s1,24(sp)
    8000170e:	e84a                	sd	s2,16(sp)
    80001710:	e44e                	sd	s3,8(sp)
    80001712:	1800                	addi	s0,sp,48
    80001714:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80001716:	00007497          	auipc	s1,0x7
    8000171a:	63a48493          	addi	s1,s1,1594 # 80008d50 <proc>
    8000171e:	0000d997          	auipc	s3,0xd
    80001722:	03298993          	addi	s3,s3,50 # 8000e750 <tickslock>
    acquire(&p->lock);
    80001726:	8526                	mv	a0,s1
    80001728:	00005097          	auipc	ra,0x5
    8000172c:	aec080e7          	jalr	-1300(ra) # 80006214 <acquire>
    if (p->pid == pid) {
    80001730:	589c                	lw	a5,48(s1)
    80001732:	01278d63          	beq	a5,s2,8000174c <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001736:	8526                	mv	a0,s1
    80001738:	00005097          	auipc	ra,0x5
    8000173c:	b90080e7          	jalr	-1136(ra) # 800062c8 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001740:	16848493          	addi	s1,s1,360
    80001744:	ff3491e3          	bne	s1,s3,80001726 <kill+0x20>
  }
  return -1;
    80001748:	557d                	li	a0,-1
    8000174a:	a829                	j	80001764 <kill+0x5e>
      p->killed = 1;
    8000174c:	4785                	li	a5,1
    8000174e:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING) {
    80001750:	4c98                	lw	a4,24(s1)
    80001752:	4789                	li	a5,2
    80001754:	00f70f63          	beq	a4,a5,80001772 <kill+0x6c>
      release(&p->lock);
    80001758:	8526                	mv	a0,s1
    8000175a:	00005097          	auipc	ra,0x5
    8000175e:	b6e080e7          	jalr	-1170(ra) # 800062c8 <release>
      return 0;
    80001762:	4501                	li	a0,0
}
    80001764:	70a2                	ld	ra,40(sp)
    80001766:	7402                	ld	s0,32(sp)
    80001768:	64e2                	ld	s1,24(sp)
    8000176a:	6942                	ld	s2,16(sp)
    8000176c:	69a2                	ld	s3,8(sp)
    8000176e:	6145                	addi	sp,sp,48
    80001770:	8082                	ret
        p->state = RUNNABLE;
    80001772:	478d                	li	a5,3
    80001774:	cc9c                	sw	a5,24(s1)
    80001776:	b7cd                	j	80001758 <kill+0x52>

0000000080001778 <setkilled>:

void setkilled(struct proc *p) {
    80001778:	1101                	addi	sp,sp,-32
    8000177a:	ec06                	sd	ra,24(sp)
    8000177c:	e822                	sd	s0,16(sp)
    8000177e:	e426                	sd	s1,8(sp)
    80001780:	1000                	addi	s0,sp,32
    80001782:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001784:	00005097          	auipc	ra,0x5
    80001788:	a90080e7          	jalr	-1392(ra) # 80006214 <acquire>
  p->killed = 1;
    8000178c:	4785                	li	a5,1
    8000178e:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001790:	8526                	mv	a0,s1
    80001792:	00005097          	auipc	ra,0x5
    80001796:	b36080e7          	jalr	-1226(ra) # 800062c8 <release>
}
    8000179a:	60e2                	ld	ra,24(sp)
    8000179c:	6442                	ld	s0,16(sp)
    8000179e:	64a2                	ld	s1,8(sp)
    800017a0:	6105                	addi	sp,sp,32
    800017a2:	8082                	ret

00000000800017a4 <killed>:

int killed(struct proc *p) {
    800017a4:	1101                	addi	sp,sp,-32
    800017a6:	ec06                	sd	ra,24(sp)
    800017a8:	e822                	sd	s0,16(sp)
    800017aa:	e426                	sd	s1,8(sp)
    800017ac:	e04a                	sd	s2,0(sp)
    800017ae:	1000                	addi	s0,sp,32
    800017b0:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    800017b2:	00005097          	auipc	ra,0x5
    800017b6:	a62080e7          	jalr	-1438(ra) # 80006214 <acquire>
  k = p->killed;
    800017ba:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800017be:	8526                	mv	a0,s1
    800017c0:	00005097          	auipc	ra,0x5
    800017c4:	b08080e7          	jalr	-1272(ra) # 800062c8 <release>
  return k;
}
    800017c8:	854a                	mv	a0,s2
    800017ca:	60e2                	ld	ra,24(sp)
    800017cc:	6442                	ld	s0,16(sp)
    800017ce:	64a2                	ld	s1,8(sp)
    800017d0:	6902                	ld	s2,0(sp)
    800017d2:	6105                	addi	sp,sp,32
    800017d4:	8082                	ret

00000000800017d6 <wait>:
int wait(uint64 addr) {
    800017d6:	715d                	addi	sp,sp,-80
    800017d8:	e486                	sd	ra,72(sp)
    800017da:	e0a2                	sd	s0,64(sp)
    800017dc:	fc26                	sd	s1,56(sp)
    800017de:	f84a                	sd	s2,48(sp)
    800017e0:	f44e                	sd	s3,40(sp)
    800017e2:	f052                	sd	s4,32(sp)
    800017e4:	ec56                	sd	s5,24(sp)
    800017e6:	e85a                	sd	s6,16(sp)
    800017e8:	e45e                	sd	s7,8(sp)
    800017ea:	e062                	sd	s8,0(sp)
    800017ec:	0880                	addi	s0,sp,80
    800017ee:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800017f0:	fffff097          	auipc	ra,0xfffff
    800017f4:	664080e7          	jalr	1636(ra) # 80000e54 <myproc>
    800017f8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800017fa:	00007517          	auipc	a0,0x7
    800017fe:	13e50513          	addi	a0,a0,318 # 80008938 <wait_lock>
    80001802:	00005097          	auipc	ra,0x5
    80001806:	a12080e7          	jalr	-1518(ra) # 80006214 <acquire>
    havekids = 0;
    8000180a:	4b81                	li	s7,0
        if (pp->state == ZOMBIE) {
    8000180c:	4a15                	li	s4,5
        havekids = 1;
    8000180e:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001810:	0000d997          	auipc	s3,0xd
    80001814:	f4098993          	addi	s3,s3,-192 # 8000e750 <tickslock>
    sleep(p, &wait_lock);  // DOC: wait-sleep
    80001818:	00007c17          	auipc	s8,0x7
    8000181c:	120c0c13          	addi	s8,s8,288 # 80008938 <wait_lock>
    havekids = 0;
    80001820:	875e                	mv	a4,s7
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001822:	00007497          	auipc	s1,0x7
    80001826:	52e48493          	addi	s1,s1,1326 # 80008d50 <proc>
    8000182a:	a0bd                	j	80001898 <wait+0xc2>
          pid = pp->pid;
    8000182c:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001830:	000b0e63          	beqz	s6,8000184c <wait+0x76>
    80001834:	4691                	li	a3,4
    80001836:	02c48613          	addi	a2,s1,44
    8000183a:	85da                	mv	a1,s6
    8000183c:	05093503          	ld	a0,80(s2)
    80001840:	fffff097          	auipc	ra,0xfffff
    80001844:	2d4080e7          	jalr	724(ra) # 80000b14 <copyout>
    80001848:	02054563          	bltz	a0,80001872 <wait+0x9c>
          freeproc(pp);
    8000184c:	8526                	mv	a0,s1
    8000184e:	fffff097          	auipc	ra,0xfffff
    80001852:	7b8080e7          	jalr	1976(ra) # 80001006 <freeproc>
          release(&pp->lock);
    80001856:	8526                	mv	a0,s1
    80001858:	00005097          	auipc	ra,0x5
    8000185c:	a70080e7          	jalr	-1424(ra) # 800062c8 <release>
          release(&wait_lock);
    80001860:	00007517          	auipc	a0,0x7
    80001864:	0d850513          	addi	a0,a0,216 # 80008938 <wait_lock>
    80001868:	00005097          	auipc	ra,0x5
    8000186c:	a60080e7          	jalr	-1440(ra) # 800062c8 <release>
          return pid;
    80001870:	a0b5                	j	800018dc <wait+0x106>
            release(&pp->lock);
    80001872:	8526                	mv	a0,s1
    80001874:	00005097          	auipc	ra,0x5
    80001878:	a54080e7          	jalr	-1452(ra) # 800062c8 <release>
            release(&wait_lock);
    8000187c:	00007517          	auipc	a0,0x7
    80001880:	0bc50513          	addi	a0,a0,188 # 80008938 <wait_lock>
    80001884:	00005097          	auipc	ra,0x5
    80001888:	a44080e7          	jalr	-1468(ra) # 800062c8 <release>
            return -1;
    8000188c:	59fd                	li	s3,-1
    8000188e:	a0b9                	j	800018dc <wait+0x106>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001890:	16848493          	addi	s1,s1,360
    80001894:	03348463          	beq	s1,s3,800018bc <wait+0xe6>
      if (pp->parent == p) {
    80001898:	7c9c                	ld	a5,56(s1)
    8000189a:	ff279be3          	bne	a5,s2,80001890 <wait+0xba>
        acquire(&pp->lock);
    8000189e:	8526                	mv	a0,s1
    800018a0:	00005097          	auipc	ra,0x5
    800018a4:	974080e7          	jalr	-1676(ra) # 80006214 <acquire>
        if (pp->state == ZOMBIE) {
    800018a8:	4c9c                	lw	a5,24(s1)
    800018aa:	f94781e3          	beq	a5,s4,8000182c <wait+0x56>
        release(&pp->lock);
    800018ae:	8526                	mv	a0,s1
    800018b0:	00005097          	auipc	ra,0x5
    800018b4:	a18080e7          	jalr	-1512(ra) # 800062c8 <release>
        havekids = 1;
    800018b8:	8756                	mv	a4,s5
    800018ba:	bfd9                	j	80001890 <wait+0xba>
    if (!havekids || killed(p)) {
    800018bc:	c719                	beqz	a4,800018ca <wait+0xf4>
    800018be:	854a                	mv	a0,s2
    800018c0:	00000097          	auipc	ra,0x0
    800018c4:	ee4080e7          	jalr	-284(ra) # 800017a4 <killed>
    800018c8:	c51d                	beqz	a0,800018f6 <wait+0x120>
      release(&wait_lock);
    800018ca:	00007517          	auipc	a0,0x7
    800018ce:	06e50513          	addi	a0,a0,110 # 80008938 <wait_lock>
    800018d2:	00005097          	auipc	ra,0x5
    800018d6:	9f6080e7          	jalr	-1546(ra) # 800062c8 <release>
      return -1;
    800018da:	59fd                	li	s3,-1
}
    800018dc:	854e                	mv	a0,s3
    800018de:	60a6                	ld	ra,72(sp)
    800018e0:	6406                	ld	s0,64(sp)
    800018e2:	74e2                	ld	s1,56(sp)
    800018e4:	7942                	ld	s2,48(sp)
    800018e6:	79a2                	ld	s3,40(sp)
    800018e8:	7a02                	ld	s4,32(sp)
    800018ea:	6ae2                	ld	s5,24(sp)
    800018ec:	6b42                	ld	s6,16(sp)
    800018ee:	6ba2                	ld	s7,8(sp)
    800018f0:	6c02                	ld	s8,0(sp)
    800018f2:	6161                	addi	sp,sp,80
    800018f4:	8082                	ret
    sleep(p, &wait_lock);  // DOC: wait-sleep
    800018f6:	85e2                	mv	a1,s8
    800018f8:	854a                	mv	a0,s2
    800018fa:	00000097          	auipc	ra,0x0
    800018fe:	c02080e7          	jalr	-1022(ra) # 800014fc <sleep>
    havekids = 0;
    80001902:	bf39                	j	80001820 <wait+0x4a>

0000000080001904 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len) {
    80001904:	7179                	addi	sp,sp,-48
    80001906:	f406                	sd	ra,40(sp)
    80001908:	f022                	sd	s0,32(sp)
    8000190a:	ec26                	sd	s1,24(sp)
    8000190c:	e84a                	sd	s2,16(sp)
    8000190e:	e44e                	sd	s3,8(sp)
    80001910:	e052                	sd	s4,0(sp)
    80001912:	1800                	addi	s0,sp,48
    80001914:	84aa                	mv	s1,a0
    80001916:	892e                	mv	s2,a1
    80001918:	89b2                	mv	s3,a2
    8000191a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000191c:	fffff097          	auipc	ra,0xfffff
    80001920:	538080e7          	jalr	1336(ra) # 80000e54 <myproc>
  if (user_dst) {
    80001924:	c08d                	beqz	s1,80001946 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001926:	86d2                	mv	a3,s4
    80001928:	864e                	mv	a2,s3
    8000192a:	85ca                	mv	a1,s2
    8000192c:	6928                	ld	a0,80(a0)
    8000192e:	fffff097          	auipc	ra,0xfffff
    80001932:	1e6080e7          	jalr	486(ra) # 80000b14 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001936:	70a2                	ld	ra,40(sp)
    80001938:	7402                	ld	s0,32(sp)
    8000193a:	64e2                	ld	s1,24(sp)
    8000193c:	6942                	ld	s2,16(sp)
    8000193e:	69a2                	ld	s3,8(sp)
    80001940:	6a02                	ld	s4,0(sp)
    80001942:	6145                	addi	sp,sp,48
    80001944:	8082                	ret
    memmove((char *)dst, src, len);
    80001946:	000a061b          	sext.w	a2,s4
    8000194a:	85ce                	mv	a1,s3
    8000194c:	854a                	mv	a0,s2
    8000194e:	fffff097          	auipc	ra,0xfffff
    80001952:	888080e7          	jalr	-1912(ra) # 800001d6 <memmove>
    return 0;
    80001956:	8526                	mv	a0,s1
    80001958:	bff9                	j	80001936 <either_copyout+0x32>

000000008000195a <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len) {
    8000195a:	7179                	addi	sp,sp,-48
    8000195c:	f406                	sd	ra,40(sp)
    8000195e:	f022                	sd	s0,32(sp)
    80001960:	ec26                	sd	s1,24(sp)
    80001962:	e84a                	sd	s2,16(sp)
    80001964:	e44e                	sd	s3,8(sp)
    80001966:	e052                	sd	s4,0(sp)
    80001968:	1800                	addi	s0,sp,48
    8000196a:	892a                	mv	s2,a0
    8000196c:	84ae                	mv	s1,a1
    8000196e:	89b2                	mv	s3,a2
    80001970:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001972:	fffff097          	auipc	ra,0xfffff
    80001976:	4e2080e7          	jalr	1250(ra) # 80000e54 <myproc>
  if (user_src) {
    8000197a:	c08d                	beqz	s1,8000199c <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000197c:	86d2                	mv	a3,s4
    8000197e:	864e                	mv	a2,s3
    80001980:	85ca                	mv	a1,s2
    80001982:	6928                	ld	a0,80(a0)
    80001984:	fffff097          	auipc	ra,0xfffff
    80001988:	21c080e7          	jalr	540(ra) # 80000ba0 <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    8000198c:	70a2                	ld	ra,40(sp)
    8000198e:	7402                	ld	s0,32(sp)
    80001990:	64e2                	ld	s1,24(sp)
    80001992:	6942                	ld	s2,16(sp)
    80001994:	69a2                	ld	s3,8(sp)
    80001996:	6a02                	ld	s4,0(sp)
    80001998:	6145                	addi	sp,sp,48
    8000199a:	8082                	ret
    memmove(dst, (char *)src, len);
    8000199c:	000a061b          	sext.w	a2,s4
    800019a0:	85ce                	mv	a1,s3
    800019a2:	854a                	mv	a0,s2
    800019a4:	fffff097          	auipc	ra,0xfffff
    800019a8:	832080e7          	jalr	-1998(ra) # 800001d6 <memmove>
    return 0;
    800019ac:	8526                	mv	a0,s1
    800019ae:	bff9                	j	8000198c <either_copyin+0x32>

00000000800019b0 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
    800019b0:	715d                	addi	sp,sp,-80
    800019b2:	e486                	sd	ra,72(sp)
    800019b4:	e0a2                	sd	s0,64(sp)
    800019b6:	fc26                	sd	s1,56(sp)
    800019b8:	f84a                	sd	s2,48(sp)
    800019ba:	f44e                	sd	s3,40(sp)
    800019bc:	f052                	sd	s4,32(sp)
    800019be:	ec56                	sd	s5,24(sp)
    800019c0:	e85a                	sd	s6,16(sp)
    800019c2:	e45e                	sd	s7,8(sp)
    800019c4:	0880                	addi	s0,sp,80
      [UNUSED] "unused",   [USED] "used",      [SLEEPING] "sleep ",
      [RUNNABLE] "runble", [RUNNING] "run   ", [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    800019c6:	00006517          	auipc	a0,0x6
    800019ca:	68250513          	addi	a0,a0,1666 # 80008048 <etext+0x48>
    800019ce:	00004097          	auipc	ra,0x4
    800019d2:	358080e7          	jalr	856(ra) # 80005d26 <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    800019d6:	00007497          	auipc	s1,0x7
    800019da:	4d248493          	addi	s1,s1,1234 # 80008ea8 <proc+0x158>
    800019de:	0000d917          	auipc	s2,0xd
    800019e2:	eca90913          	addi	s2,s2,-310 # 8000e8a8 <bcache+0x140>
    if (p->state == UNUSED) continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e6:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019e8:	00007997          	auipc	s3,0x7
    800019ec:	81898993          	addi	s3,s3,-2024 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019f0:	00007a97          	auipc	s5,0x7
    800019f4:	818a8a93          	addi	s5,s5,-2024 # 80008208 <etext+0x208>
    printf("\n");
    800019f8:	00006a17          	auipc	s4,0x6
    800019fc:	650a0a13          	addi	s4,s4,1616 # 80008048 <etext+0x48>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a00:	00007b97          	auipc	s7,0x7
    80001a04:	858b8b93          	addi	s7,s7,-1960 # 80008258 <states.0>
    80001a08:	a00d                	j	80001a2a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a0a:	ed86a583          	lw	a1,-296(a3)
    80001a0e:	8556                	mv	a0,s5
    80001a10:	00004097          	auipc	ra,0x4
    80001a14:	316080e7          	jalr	790(ra) # 80005d26 <printf>
    printf("\n");
    80001a18:	8552                	mv	a0,s4
    80001a1a:	00004097          	auipc	ra,0x4
    80001a1e:	30c080e7          	jalr	780(ra) # 80005d26 <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001a22:	16848493          	addi	s1,s1,360
    80001a26:	03248263          	beq	s1,s2,80001a4a <procdump+0x9a>
    if (p->state == UNUSED) continue;
    80001a2a:	86a6                	mv	a3,s1
    80001a2c:	ec04a783          	lw	a5,-320(s1)
    80001a30:	dbed                	beqz	a5,80001a22 <procdump+0x72>
      state = "???";
    80001a32:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a34:	fcfb6be3          	bltu	s6,a5,80001a0a <procdump+0x5a>
    80001a38:	02079713          	slli	a4,a5,0x20
    80001a3c:	01d75793          	srli	a5,a4,0x1d
    80001a40:	97de                	add	a5,a5,s7
    80001a42:	6390                	ld	a2,0(a5)
    80001a44:	f279                	bnez	a2,80001a0a <procdump+0x5a>
      state = "???";
    80001a46:	864e                	mv	a2,s3
    80001a48:	b7c9                	j	80001a0a <procdump+0x5a>
  }
}
    80001a4a:	60a6                	ld	ra,72(sp)
    80001a4c:	6406                	ld	s0,64(sp)
    80001a4e:	74e2                	ld	s1,56(sp)
    80001a50:	7942                	ld	s2,48(sp)
    80001a52:	79a2                	ld	s3,40(sp)
    80001a54:	7a02                	ld	s4,32(sp)
    80001a56:	6ae2                	ld	s5,24(sp)
    80001a58:	6b42                	ld	s6,16(sp)
    80001a5a:	6ba2                	ld	s7,8(sp)
    80001a5c:	6161                	addi	sp,sp,80
    80001a5e:	8082                	ret

0000000080001a60 <dump>:

int dump(void) {
    80001a60:	7179                	addi	sp,sp,-48
    80001a62:	f406                	sd	ra,40(sp)
    80001a64:	f022                	sd	s0,32(sp)
    80001a66:	ec26                	sd	s1,24(sp)
    80001a68:	e84a                	sd	s2,16(sp)
    80001a6a:	e44e                	sd	s3,8(sp)
    80001a6c:	e052                	sd	s4,0(sp)
    80001a6e:	1800                	addi	s0,sp,48
  struct proc *processor = myproc();
    80001a70:	fffff097          	auipc	ra,0xfffff
    80001a74:	3e4080e7          	jalr	996(ra) # 80000e54 <myproc>

  uint64 *cur_p = &processor->trapframe->s2;
    80001a78:	05853903          	ld	s2,88(a0)
    80001a7c:	0b090913          	addi	s2,s2,176
  for (int i = 2; i <= 11; ++i, ++cur_p) {
    80001a80:	4489                	li	s1,2
    printf("s%d: %d\n", i, (uint32)*cur_p);
    80001a82:	00006a17          	auipc	s4,0x6
    80001a86:	796a0a13          	addi	s4,s4,1942 # 80008218 <etext+0x218>
  for (int i = 2; i <= 11; ++i, ++cur_p) {
    80001a8a:	49b1                	li	s3,12
    printf("s%d: %d\n", i, (uint32)*cur_p);
    80001a8c:	00092603          	lw	a2,0(s2)
    80001a90:	85a6                	mv	a1,s1
    80001a92:	8552                	mv	a0,s4
    80001a94:	00004097          	auipc	ra,0x4
    80001a98:	292080e7          	jalr	658(ra) # 80005d26 <printf>
  for (int i = 2; i <= 11; ++i, ++cur_p) {
    80001a9c:	2485                	addiw	s1,s1,1
    80001a9e:	0921                	addi	s2,s2,8
    80001aa0:	ff3496e3          	bne	s1,s3,80001a8c <dump+0x2c>
  }

  return 0;
}
    80001aa4:	4501                	li	a0,0
    80001aa6:	70a2                	ld	ra,40(sp)
    80001aa8:	7402                	ld	s0,32(sp)
    80001aaa:	64e2                	ld	s1,24(sp)
    80001aac:	6942                	ld	s2,16(sp)
    80001aae:	69a2                	ld	s3,8(sp)
    80001ab0:	6a02                	ld	s4,0(sp)
    80001ab2:	6145                	addi	sp,sp,48
    80001ab4:	8082                	ret

0000000080001ab6 <dump2>:

int dump2(int pid, int register_num, uint64 *return_value) {
  if (register_num < 2 || register_num > 11) {
    80001ab6:	ffe5871b          	addiw	a4,a1,-2
    80001aba:	47a5                	li	a5,9
    80001abc:	08e7e063          	bltu	a5,a4,80001b3c <dump2+0x86>
int dump2(int pid, int register_num, uint64 *return_value) {
    80001ac0:	7179                	addi	sp,sp,-48
    80001ac2:	f406                	sd	ra,40(sp)
    80001ac4:	f022                	sd	s0,32(sp)
    80001ac6:	ec26                	sd	s1,24(sp)
    80001ac8:	e84a                	sd	s2,16(sp)
    80001aca:	e44e                	sd	s3,8(sp)
    80001acc:	1800                	addi	s0,sp,48
    80001ace:	84aa                	mv	s1,a0
    80001ad0:	892e                	mv	s2,a1
    80001ad2:	89b2                	mv	s3,a2
    return -3;
  }

  struct proc *exec_p = myproc();
    80001ad4:	fffff097          	auipc	ra,0xfffff
    80001ad8:	380080e7          	jalr	896(ra) # 80000e54 <myproc>
  int cur_pid = exec_p->pid;
  for (struct proc *p = proc; p < &proc[NPROC]; p++) {
    80001adc:	00007797          	auipc	a5,0x7
    80001ae0:	27478793          	addi	a5,a5,628 # 80008d50 <proc>
    80001ae4:	0000d697          	auipc	a3,0xd
    80001ae8:	c6c68693          	addi	a3,a3,-916 # 8000e750 <tickslock>
    if (p->pid == pid) {
    80001aec:	5b98                	lw	a4,48(a5)
    80001aee:	00970863          	beq	a4,s1,80001afe <dump2+0x48>
  for (struct proc *p = proc; p < &proc[NPROC]; p++) {
    80001af2:	16878793          	addi	a5,a5,360
    80001af6:	fed79be3          	bne	a5,a3,80001aec <dump2+0x36>

      return 0;
    }
  }

  return -2;
    80001afa:	5579                	li	a0,-2
    80001afc:	a80d                	j	80001b2e <dump2+0x78>
  int cur_pid = exec_p->pid;
    80001afe:	5914                	lw	a3,48(a0)
      if (p->pid != cur_pid && p->parent->pid != cur_pid) {
    80001b00:	00d70663          	beq	a4,a3,80001b0c <dump2+0x56>
    80001b04:	7f98                	ld	a4,56(a5)
    80001b06:	5b18                	lw	a4,48(a4)
    80001b08:	02d71c63          	bne	a4,a3,80001b40 <dump2+0x8a>
      uint64 *register_p = &p->trapframe->s2 + register_num - 2;
    80001b0c:	6fb0                	ld	a2,88(a5)
    80001b0e:	090e                	slli	s2,s2,0x3
    80001b10:	964a                	add	a2,a2,s2
      if (copyout(exec_p->pagetable, *return_value, (char *)register_p,
    80001b12:	46a1                	li	a3,8
    80001b14:	0a060613          	addi	a2,a2,160 # 10a0 <_entry-0x7fffef60>
    80001b18:	0009b583          	ld	a1,0(s3)
    80001b1c:	6928                	ld	a0,80(a0)
    80001b1e:	fffff097          	auipc	ra,0xfffff
    80001b22:	ff6080e7          	jalr	-10(ra) # 80000b14 <copyout>
    80001b26:	57fd                	li	a5,-1
    80001b28:	00f50e63          	beq	a0,a5,80001b44 <dump2+0x8e>
      return 0;
    80001b2c:	4501                	li	a0,0
}
    80001b2e:	70a2                	ld	ra,40(sp)
    80001b30:	7402                	ld	s0,32(sp)
    80001b32:	64e2                	ld	s1,24(sp)
    80001b34:	6942                	ld	s2,16(sp)
    80001b36:	69a2                	ld	s3,8(sp)
    80001b38:	6145                	addi	sp,sp,48
    80001b3a:	8082                	ret
    return -3;
    80001b3c:	5575                	li	a0,-3
}
    80001b3e:	8082                	ret
        return -1;
    80001b40:	557d                	li	a0,-1
    80001b42:	b7f5                	j	80001b2e <dump2+0x78>
        return -4;
    80001b44:	5571                	li	a0,-4
    80001b46:	b7e5                	j	80001b2e <dump2+0x78>

0000000080001b48 <swtch>:
    80001b48:	00153023          	sd	ra,0(a0)
    80001b4c:	00253423          	sd	sp,8(a0)
    80001b50:	e900                	sd	s0,16(a0)
    80001b52:	ed04                	sd	s1,24(a0)
    80001b54:	03253023          	sd	s2,32(a0)
    80001b58:	03353423          	sd	s3,40(a0)
    80001b5c:	03453823          	sd	s4,48(a0)
    80001b60:	03553c23          	sd	s5,56(a0)
    80001b64:	05653023          	sd	s6,64(a0)
    80001b68:	05753423          	sd	s7,72(a0)
    80001b6c:	05853823          	sd	s8,80(a0)
    80001b70:	05953c23          	sd	s9,88(a0)
    80001b74:	07a53023          	sd	s10,96(a0)
    80001b78:	07b53423          	sd	s11,104(a0)
    80001b7c:	0005b083          	ld	ra,0(a1)
    80001b80:	0085b103          	ld	sp,8(a1)
    80001b84:	6980                	ld	s0,16(a1)
    80001b86:	6d84                	ld	s1,24(a1)
    80001b88:	0205b903          	ld	s2,32(a1)
    80001b8c:	0285b983          	ld	s3,40(a1)
    80001b90:	0305ba03          	ld	s4,48(a1)
    80001b94:	0385ba83          	ld	s5,56(a1)
    80001b98:	0405bb03          	ld	s6,64(a1)
    80001b9c:	0485bb83          	ld	s7,72(a1)
    80001ba0:	0505bc03          	ld	s8,80(a1)
    80001ba4:	0585bc83          	ld	s9,88(a1)
    80001ba8:	0605bd03          	ld	s10,96(a1)
    80001bac:	0685bd83          	ld	s11,104(a1)
    80001bb0:	8082                	ret

0000000080001bb2 <trapinit>:
// in kernelvec.S, calls kerneltrap().
void kernelvec();

extern int devintr();

void trapinit(void) { initlock(&tickslock, "time"); }
    80001bb2:	1141                	addi	sp,sp,-16
    80001bb4:	e406                	sd	ra,8(sp)
    80001bb6:	e022                	sd	s0,0(sp)
    80001bb8:	0800                	addi	s0,sp,16
    80001bba:	00006597          	auipc	a1,0x6
    80001bbe:	6ce58593          	addi	a1,a1,1742 # 80008288 <states.0+0x30>
    80001bc2:	0000d517          	auipc	a0,0xd
    80001bc6:	b8e50513          	addi	a0,a0,-1138 # 8000e750 <tickslock>
    80001bca:	00004097          	auipc	ra,0x4
    80001bce:	5ba080e7          	jalr	1466(ra) # 80006184 <initlock>
    80001bd2:	60a2                	ld	ra,8(sp)
    80001bd4:	6402                	ld	s0,0(sp)
    80001bd6:	0141                	addi	sp,sp,16
    80001bd8:	8082                	ret

0000000080001bda <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void) { w_stvec((uint64)kernelvec); }
    80001bda:	1141                	addi	sp,sp,-16
    80001bdc:	e422                	sd	s0,8(sp)
    80001bde:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001be0:	00003797          	auipc	a5,0x3
    80001be4:	53078793          	addi	a5,a5,1328 # 80005110 <kernelvec>
    80001be8:	10579073          	csrw	stvec,a5
    80001bec:	6422                	ld	s0,8(sp)
    80001bee:	0141                	addi	sp,sp,16
    80001bf0:	8082                	ret

0000000080001bf2 <usertrapret>:
}

//
// return to user space
//
void usertrapret(void) {
    80001bf2:	1141                	addi	sp,sp,-16
    80001bf4:	e406                	sd	ra,8(sp)
    80001bf6:	e022                	sd	s0,0(sp)
    80001bf8:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001bfa:	fffff097          	auipc	ra,0xfffff
    80001bfe:	25a080e7          	jalr	602(ra) # 80000e54 <myproc>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001c02:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    80001c06:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001c08:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001c0c:	00005697          	auipc	a3,0x5
    80001c10:	3f468693          	addi	a3,a3,1012 # 80007000 <_trampoline>
    80001c14:	00005717          	auipc	a4,0x5
    80001c18:	3ec70713          	addi	a4,a4,1004 # 80007000 <_trampoline>
    80001c1c:	8f15                	sub	a4,a4,a3
    80001c1e:	040007b7          	lui	a5,0x4000
    80001c22:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001c24:	07b2                	slli	a5,a5,0xc
    80001c26:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001c28:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();          // kernel page table
    80001c2c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80001c2e:	18002673          	csrr	a2,satp
    80001c32:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE;  // process's kernel stack
    80001c34:	6d30                	ld	a2,88(a0)
    80001c36:	6138                	ld	a4,64(a0)
    80001c38:	6585                	lui	a1,0x1
    80001c3a:	972e                	add	a4,a4,a1
    80001c3c:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c3e:	6d38                	ld	a4,88(a0)
    80001c40:	00000617          	auipc	a2,0x0
    80001c44:	13060613          	addi	a2,a2,304 # 80001d70 <usertrap>
    80001c48:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();  // hartid for cpuid()
    80001c4a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    80001c4c:	8612                	mv	a2,tp
    80001c4e:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001c50:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP;  // clear SPP to 0 for user mode
    80001c54:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE;  // enable interrupts in user mode
    80001c58:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001c5c:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c60:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    80001c62:	6f18                	ld	a4,24(a4)
    80001c64:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c68:	6928                	ld	a0,80(a0)
    80001c6a:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001c6c:	00005717          	auipc	a4,0x5
    80001c70:	43070713          	addi	a4,a4,1072 # 8000709c <userret>
    80001c74:	8f15                	sub	a4,a4,a3
    80001c76:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001c78:	577d                	li	a4,-1
    80001c7a:	177e                	slli	a4,a4,0x3f
    80001c7c:	8d59                	or	a0,a0,a4
    80001c7e:	9782                	jalr	a5
}
    80001c80:	60a2                	ld	ra,8(sp)
    80001c82:	6402                	ld	s0,0(sp)
    80001c84:	0141                	addi	sp,sp,16
    80001c86:	8082                	ret

0000000080001c88 <clockintr>:
  // so restore trap registers for use by kernelvec.S's sepc instruction.
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr() {
    80001c88:	1101                	addi	sp,sp,-32
    80001c8a:	ec06                	sd	ra,24(sp)
    80001c8c:	e822                	sd	s0,16(sp)
    80001c8e:	e426                	sd	s1,8(sp)
    80001c90:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c92:	0000d497          	auipc	s1,0xd
    80001c96:	abe48493          	addi	s1,s1,-1346 # 8000e750 <tickslock>
    80001c9a:	8526                	mv	a0,s1
    80001c9c:	00004097          	auipc	ra,0x4
    80001ca0:	578080e7          	jalr	1400(ra) # 80006214 <acquire>
  ticks++;
    80001ca4:	00007517          	auipc	a0,0x7
    80001ca8:	c4450513          	addi	a0,a0,-956 # 800088e8 <ticks>
    80001cac:	411c                	lw	a5,0(a0)
    80001cae:	2785                	addiw	a5,a5,1
    80001cb0:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001cb2:	00000097          	auipc	ra,0x0
    80001cb6:	8ae080e7          	jalr	-1874(ra) # 80001560 <wakeup>
  release(&tickslock);
    80001cba:	8526                	mv	a0,s1
    80001cbc:	00004097          	auipc	ra,0x4
    80001cc0:	60c080e7          	jalr	1548(ra) # 800062c8 <release>
}
    80001cc4:	60e2                	ld	ra,24(sp)
    80001cc6:	6442                	ld	s0,16(sp)
    80001cc8:	64a2                	ld	s1,8(sp)
    80001cca:	6105                	addi	sp,sp,32
    80001ccc:	8082                	ret

0000000080001cce <devintr>:
// check if it's an external interrupt or software interrupt,
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr() {
    80001cce:	1101                	addi	sp,sp,-32
    80001cd0:	ec06                	sd	ra,24(sp)
    80001cd2:	e822                	sd	s0,16(sp)
    80001cd4:	e426                	sd	s1,8(sp)
    80001cd6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    80001cd8:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80001cdc:	00074d63          	bltz	a4,80001cf6 <devintr+0x28>
    // interrupt at a time; tell the PLIC the device is
    // now allowed to interrupt again.
    if (irq) plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000001L) {
    80001ce0:	57fd                	li	a5,-1
    80001ce2:	17fe                	slli	a5,a5,0x3f
    80001ce4:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001ce6:	4501                	li	a0,0
  } else if (scause == 0x8000000000000001L) {
    80001ce8:	06f70363          	beq	a4,a5,80001d4e <devintr+0x80>
  }
}
    80001cec:	60e2                	ld	ra,24(sp)
    80001cee:	6442                	ld	s0,16(sp)
    80001cf0:	64a2                	ld	s1,8(sp)
    80001cf2:	6105                	addi	sp,sp,32
    80001cf4:	8082                	ret
  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80001cf6:	0ff77793          	zext.b	a5,a4
    80001cfa:	46a5                	li	a3,9
    80001cfc:	fed792e3          	bne	a5,a3,80001ce0 <devintr+0x12>
    int irq = plic_claim();
    80001d00:	00003097          	auipc	ra,0x3
    80001d04:	518080e7          	jalr	1304(ra) # 80005218 <plic_claim>
    80001d08:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    80001d0a:	47a9                	li	a5,10
    80001d0c:	02f50763          	beq	a0,a5,80001d3a <devintr+0x6c>
    } else if (irq == VIRTIO0_IRQ) {
    80001d10:	4785                	li	a5,1
    80001d12:	02f50963          	beq	a0,a5,80001d44 <devintr+0x76>
    return 1;
    80001d16:	4505                	li	a0,1
    } else if (irq) {
    80001d18:	d8f1                	beqz	s1,80001cec <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d1a:	85a6                	mv	a1,s1
    80001d1c:	00006517          	auipc	a0,0x6
    80001d20:	57450513          	addi	a0,a0,1396 # 80008290 <states.0+0x38>
    80001d24:	00004097          	auipc	ra,0x4
    80001d28:	002080e7          	jalr	2(ra) # 80005d26 <printf>
    if (irq) plic_complete(irq);
    80001d2c:	8526                	mv	a0,s1
    80001d2e:	00003097          	auipc	ra,0x3
    80001d32:	50e080e7          	jalr	1294(ra) # 8000523c <plic_complete>
    return 1;
    80001d36:	4505                	li	a0,1
    80001d38:	bf55                	j	80001cec <devintr+0x1e>
      uartintr();
    80001d3a:	00004097          	auipc	ra,0x4
    80001d3e:	3fa080e7          	jalr	1018(ra) # 80006134 <uartintr>
    80001d42:	b7ed                	j	80001d2c <devintr+0x5e>
      virtio_disk_intr();
    80001d44:	00004097          	auipc	ra,0x4
    80001d48:	9c0080e7          	jalr	-1600(ra) # 80005704 <virtio_disk_intr>
    80001d4c:	b7c5                	j	80001d2c <devintr+0x5e>
    if (cpuid() == 0) {
    80001d4e:	fffff097          	auipc	ra,0xfffff
    80001d52:	0da080e7          	jalr	218(ra) # 80000e28 <cpuid>
    80001d56:	c901                	beqz	a0,80001d66 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r"(x));
    80001d58:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d5c:	9bf5                	andi	a5,a5,-3
static inline void w_sip(uint64 x) { asm volatile("csrw sip, %0" : : "r"(x)); }
    80001d5e:	14479073          	csrw	sip,a5
    return 2;
    80001d62:	4509                	li	a0,2
    80001d64:	b761                	j	80001cec <devintr+0x1e>
      clockintr();
    80001d66:	00000097          	auipc	ra,0x0
    80001d6a:	f22080e7          	jalr	-222(ra) # 80001c88 <clockintr>
    80001d6e:	b7ed                	j	80001d58 <devintr+0x8a>

0000000080001d70 <usertrap>:
void usertrap(void) {
    80001d70:	1101                	addi	sp,sp,-32
    80001d72:	ec06                	sd	ra,24(sp)
    80001d74:	e822                	sd	s0,16(sp)
    80001d76:	e426                	sd	s1,8(sp)
    80001d78:	e04a                	sd	s2,0(sp)
    80001d7a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001d7c:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0) panic("usertrap: not from user mode");
    80001d80:	1007f793          	andi	a5,a5,256
    80001d84:	e3b1                	bnez	a5,80001dc8 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001d86:	00003797          	auipc	a5,0x3
    80001d8a:	38a78793          	addi	a5,a5,906 # 80005110 <kernelvec>
    80001d8e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d92:	fffff097          	auipc	ra,0xfffff
    80001d96:	0c2080e7          	jalr	194(ra) # 80000e54 <myproc>
    80001d9a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d9c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001d9e:	14102773          	csrr	a4,sepc
    80001da2:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    80001da4:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    80001da8:	47a1                	li	a5,8
    80001daa:	02f70763          	beq	a4,a5,80001dd8 <usertrap+0x68>
  } else if ((which_dev = devintr()) != 0) {
    80001dae:	00000097          	auipc	ra,0x0
    80001db2:	f20080e7          	jalr	-224(ra) # 80001cce <devintr>
    80001db6:	892a                	mv	s2,a0
    80001db8:	c151                	beqz	a0,80001e3c <usertrap+0xcc>
  if (killed(p)) exit(-1);
    80001dba:	8526                	mv	a0,s1
    80001dbc:	00000097          	auipc	ra,0x0
    80001dc0:	9e8080e7          	jalr	-1560(ra) # 800017a4 <killed>
    80001dc4:	c929                	beqz	a0,80001e16 <usertrap+0xa6>
    80001dc6:	a099                	j	80001e0c <usertrap+0x9c>
  if ((r_sstatus() & SSTATUS_SPP) != 0) panic("usertrap: not from user mode");
    80001dc8:	00006517          	auipc	a0,0x6
    80001dcc:	4e850513          	addi	a0,a0,1256 # 800082b0 <states.0+0x58>
    80001dd0:	00004097          	auipc	ra,0x4
    80001dd4:	f0c080e7          	jalr	-244(ra) # 80005cdc <panic>
    if (killed(p)) exit(-1);
    80001dd8:	00000097          	auipc	ra,0x0
    80001ddc:	9cc080e7          	jalr	-1588(ra) # 800017a4 <killed>
    80001de0:	e921                	bnez	a0,80001e30 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001de2:	6cb8                	ld	a4,88(s1)
    80001de4:	6f1c                	ld	a5,24(a4)
    80001de6:	0791                	addi	a5,a5,4
    80001de8:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001dea:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80001dee:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001df2:	10079073          	csrw	sstatus,a5
    syscall();
    80001df6:	00000097          	auipc	ra,0x0
    80001dfa:	2d4080e7          	jalr	724(ra) # 800020ca <syscall>
  if (killed(p)) exit(-1);
    80001dfe:	8526                	mv	a0,s1
    80001e00:	00000097          	auipc	ra,0x0
    80001e04:	9a4080e7          	jalr	-1628(ra) # 800017a4 <killed>
    80001e08:	c911                	beqz	a0,80001e1c <usertrap+0xac>
    80001e0a:	4901                	li	s2,0
    80001e0c:	557d                	li	a0,-1
    80001e0e:	00000097          	auipc	ra,0x0
    80001e12:	822080e7          	jalr	-2014(ra) # 80001630 <exit>
  if (which_dev == 2) yield();
    80001e16:	4789                	li	a5,2
    80001e18:	04f90f63          	beq	s2,a5,80001e76 <usertrap+0x106>
  usertrapret();
    80001e1c:	00000097          	auipc	ra,0x0
    80001e20:	dd6080e7          	jalr	-554(ra) # 80001bf2 <usertrapret>
}
    80001e24:	60e2                	ld	ra,24(sp)
    80001e26:	6442                	ld	s0,16(sp)
    80001e28:	64a2                	ld	s1,8(sp)
    80001e2a:	6902                	ld	s2,0(sp)
    80001e2c:	6105                	addi	sp,sp,32
    80001e2e:	8082                	ret
    if (killed(p)) exit(-1);
    80001e30:	557d                	li	a0,-1
    80001e32:	fffff097          	auipc	ra,0xfffff
    80001e36:	7fe080e7          	jalr	2046(ra) # 80001630 <exit>
    80001e3a:	b765                	j	80001de2 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r"(x));
    80001e3c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e40:	5890                	lw	a2,48(s1)
    80001e42:	00006517          	auipc	a0,0x6
    80001e46:	48e50513          	addi	a0,a0,1166 # 800082d0 <states.0+0x78>
    80001e4a:	00004097          	auipc	ra,0x4
    80001e4e:	edc080e7          	jalr	-292(ra) # 80005d26 <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001e52:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80001e56:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e5a:	00006517          	auipc	a0,0x6
    80001e5e:	4a650513          	addi	a0,a0,1190 # 80008300 <states.0+0xa8>
    80001e62:	00004097          	auipc	ra,0x4
    80001e66:	ec4080e7          	jalr	-316(ra) # 80005d26 <printf>
    setkilled(p);
    80001e6a:	8526                	mv	a0,s1
    80001e6c:	00000097          	auipc	ra,0x0
    80001e70:	90c080e7          	jalr	-1780(ra) # 80001778 <setkilled>
    80001e74:	b769                	j	80001dfe <usertrap+0x8e>
  if (which_dev == 2) yield();
    80001e76:	fffff097          	auipc	ra,0xfffff
    80001e7a:	64a080e7          	jalr	1610(ra) # 800014c0 <yield>
    80001e7e:	bf79                	j	80001e1c <usertrap+0xac>

0000000080001e80 <kerneltrap>:
void kerneltrap() {
    80001e80:	7179                	addi	sp,sp,-48
    80001e82:	f406                	sd	ra,40(sp)
    80001e84:	f022                	sd	s0,32(sp)
    80001e86:	ec26                	sd	s1,24(sp)
    80001e88:	e84a                	sd	s2,16(sp)
    80001e8a:	e44e                	sd	s3,8(sp)
    80001e8c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001e8e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001e92:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    80001e96:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80001e9a:	1004f793          	andi	a5,s1,256
    80001e9e:	cb85                	beqz	a5,80001ece <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001ea0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ea4:	8b89                	andi	a5,a5,2
  if (intr_get() != 0) panic("kerneltrap: interrupts enabled");
    80001ea6:	ef85                	bnez	a5,80001ede <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0) {
    80001ea8:	00000097          	auipc	ra,0x0
    80001eac:	e26080e7          	jalr	-474(ra) # 80001cce <devintr>
    80001eb0:	cd1d                	beqz	a0,80001eee <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING) yield();
    80001eb2:	4789                	li	a5,2
    80001eb4:	06f50a63          	beq	a0,a5,80001f28 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r"(x));
    80001eb8:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001ebc:	10049073          	csrw	sstatus,s1
}
    80001ec0:	70a2                	ld	ra,40(sp)
    80001ec2:	7402                	ld	s0,32(sp)
    80001ec4:	64e2                	ld	s1,24(sp)
    80001ec6:	6942                	ld	s2,16(sp)
    80001ec8:	69a2                	ld	s3,8(sp)
    80001eca:	6145                	addi	sp,sp,48
    80001ecc:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001ece:	00006517          	auipc	a0,0x6
    80001ed2:	45250513          	addi	a0,a0,1106 # 80008320 <states.0+0xc8>
    80001ed6:	00004097          	auipc	ra,0x4
    80001eda:	e06080e7          	jalr	-506(ra) # 80005cdc <panic>
  if (intr_get() != 0) panic("kerneltrap: interrupts enabled");
    80001ede:	00006517          	auipc	a0,0x6
    80001ee2:	46a50513          	addi	a0,a0,1130 # 80008348 <states.0+0xf0>
    80001ee6:	00004097          	auipc	ra,0x4
    80001eea:	df6080e7          	jalr	-522(ra) # 80005cdc <panic>
    printf("scause %p\n", scause);
    80001eee:	85ce                	mv	a1,s3
    80001ef0:	00006517          	auipc	a0,0x6
    80001ef4:	47850513          	addi	a0,a0,1144 # 80008368 <states.0+0x110>
    80001ef8:	00004097          	auipc	ra,0x4
    80001efc:	e2e080e7          	jalr	-466(ra) # 80005d26 <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001f00:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80001f04:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f08:	00006517          	auipc	a0,0x6
    80001f0c:	47050513          	addi	a0,a0,1136 # 80008378 <states.0+0x120>
    80001f10:	00004097          	auipc	ra,0x4
    80001f14:	e16080e7          	jalr	-490(ra) # 80005d26 <printf>
    panic("kerneltrap");
    80001f18:	00006517          	auipc	a0,0x6
    80001f1c:	47850513          	addi	a0,a0,1144 # 80008390 <states.0+0x138>
    80001f20:	00004097          	auipc	ra,0x4
    80001f24:	dbc080e7          	jalr	-580(ra) # 80005cdc <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING) yield();
    80001f28:	fffff097          	auipc	ra,0xfffff
    80001f2c:	f2c080e7          	jalr	-212(ra) # 80000e54 <myproc>
    80001f30:	d541                	beqz	a0,80001eb8 <kerneltrap+0x38>
    80001f32:	fffff097          	auipc	ra,0xfffff
    80001f36:	f22080e7          	jalr	-222(ra) # 80000e54 <myproc>
    80001f3a:	4d18                	lw	a4,24(a0)
    80001f3c:	4791                	li	a5,4
    80001f3e:	f6f71de3          	bne	a4,a5,80001eb8 <kerneltrap+0x38>
    80001f42:	fffff097          	auipc	ra,0xfffff
    80001f46:	57e080e7          	jalr	1406(ra) # 800014c0 <yield>
    80001f4a:	b7bd                	j	80001eb8 <kerneltrap+0x38>

0000000080001f4c <argraw>:
  struct proc *p = myproc();
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
  return strlen(buf);
}

static uint64 argraw(int n) {
    80001f4c:	1101                	addi	sp,sp,-32
    80001f4e:	ec06                	sd	ra,24(sp)
    80001f50:	e822                	sd	s0,16(sp)
    80001f52:	e426                	sd	s1,8(sp)
    80001f54:	1000                	addi	s0,sp,32
    80001f56:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f58:	fffff097          	auipc	ra,0xfffff
    80001f5c:	efc080e7          	jalr	-260(ra) # 80000e54 <myproc>
  switch (n) {
    80001f60:	4795                	li	a5,5
    80001f62:	0497e163          	bltu	a5,s1,80001fa4 <argraw+0x58>
    80001f66:	048a                	slli	s1,s1,0x2
    80001f68:	00006717          	auipc	a4,0x6
    80001f6c:	46070713          	addi	a4,a4,1120 # 800083c8 <states.0+0x170>
    80001f70:	94ba                	add	s1,s1,a4
    80001f72:	409c                	lw	a5,0(s1)
    80001f74:	97ba                	add	a5,a5,a4
    80001f76:	8782                	jr	a5
    case 0:
      return p->trapframe->a0;
    80001f78:	6d3c                	ld	a5,88(a0)
    80001f7a:	7ba8                	ld	a0,112(a5)
    case 5:
      return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f7c:	60e2                	ld	ra,24(sp)
    80001f7e:	6442                	ld	s0,16(sp)
    80001f80:	64a2                	ld	s1,8(sp)
    80001f82:	6105                	addi	sp,sp,32
    80001f84:	8082                	ret
      return p->trapframe->a1;
    80001f86:	6d3c                	ld	a5,88(a0)
    80001f88:	7fa8                	ld	a0,120(a5)
    80001f8a:	bfcd                	j	80001f7c <argraw+0x30>
      return p->trapframe->a2;
    80001f8c:	6d3c                	ld	a5,88(a0)
    80001f8e:	63c8                	ld	a0,128(a5)
    80001f90:	b7f5                	j	80001f7c <argraw+0x30>
      return p->trapframe->a3;
    80001f92:	6d3c                	ld	a5,88(a0)
    80001f94:	67c8                	ld	a0,136(a5)
    80001f96:	b7dd                	j	80001f7c <argraw+0x30>
      return p->trapframe->a4;
    80001f98:	6d3c                	ld	a5,88(a0)
    80001f9a:	6bc8                	ld	a0,144(a5)
    80001f9c:	b7c5                	j	80001f7c <argraw+0x30>
      return p->trapframe->a5;
    80001f9e:	6d3c                	ld	a5,88(a0)
    80001fa0:	6fc8                	ld	a0,152(a5)
    80001fa2:	bfe9                	j	80001f7c <argraw+0x30>
  panic("argraw");
    80001fa4:	00006517          	auipc	a0,0x6
    80001fa8:	3fc50513          	addi	a0,a0,1020 # 800083a0 <states.0+0x148>
    80001fac:	00004097          	auipc	ra,0x4
    80001fb0:	d30080e7          	jalr	-720(ra) # 80005cdc <panic>

0000000080001fb4 <fetchaddr>:
int fetchaddr(uint64 addr, uint64 *ip) {
    80001fb4:	1101                	addi	sp,sp,-32
    80001fb6:	ec06                	sd	ra,24(sp)
    80001fb8:	e822                	sd	s0,16(sp)
    80001fba:	e426                	sd	s1,8(sp)
    80001fbc:	e04a                	sd	s2,0(sp)
    80001fbe:	1000                	addi	s0,sp,32
    80001fc0:	84aa                	mv	s1,a0
    80001fc2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001fc4:	fffff097          	auipc	ra,0xfffff
    80001fc8:	e90080e7          	jalr	-368(ra) # 80000e54 <myproc>
  if (addr >= p->sz ||
    80001fcc:	653c                	ld	a5,72(a0)
    80001fce:	02f4f863          	bgeu	s1,a5,80001ffe <fetchaddr+0x4a>
      addr + sizeof(uint64) > p->sz)  // both tests needed, in case of overflow
    80001fd2:	00848713          	addi	a4,s1,8
  if (addr >= p->sz ||
    80001fd6:	02e7e663          	bltu	a5,a4,80002002 <fetchaddr+0x4e>
  if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0) return -1;
    80001fda:	46a1                	li	a3,8
    80001fdc:	8626                	mv	a2,s1
    80001fde:	85ca                	mv	a1,s2
    80001fe0:	6928                	ld	a0,80(a0)
    80001fe2:	fffff097          	auipc	ra,0xfffff
    80001fe6:	bbe080e7          	jalr	-1090(ra) # 80000ba0 <copyin>
    80001fea:	00a03533          	snez	a0,a0
    80001fee:	40a00533          	neg	a0,a0
}
    80001ff2:	60e2                	ld	ra,24(sp)
    80001ff4:	6442                	ld	s0,16(sp)
    80001ff6:	64a2                	ld	s1,8(sp)
    80001ff8:	6902                	ld	s2,0(sp)
    80001ffa:	6105                	addi	sp,sp,32
    80001ffc:	8082                	ret
    return -1;
    80001ffe:	557d                	li	a0,-1
    80002000:	bfcd                	j	80001ff2 <fetchaddr+0x3e>
    80002002:	557d                	li	a0,-1
    80002004:	b7fd                	j	80001ff2 <fetchaddr+0x3e>

0000000080002006 <fetchstr>:
int fetchstr(uint64 addr, char *buf, int max) {
    80002006:	7179                	addi	sp,sp,-48
    80002008:	f406                	sd	ra,40(sp)
    8000200a:	f022                	sd	s0,32(sp)
    8000200c:	ec26                	sd	s1,24(sp)
    8000200e:	e84a                	sd	s2,16(sp)
    80002010:	e44e                	sd	s3,8(sp)
    80002012:	1800                	addi	s0,sp,48
    80002014:	892a                	mv	s2,a0
    80002016:	84ae                	mv	s1,a1
    80002018:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000201a:	fffff097          	auipc	ra,0xfffff
    8000201e:	e3a080e7          	jalr	-454(ra) # 80000e54 <myproc>
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
    80002022:	86ce                	mv	a3,s3
    80002024:	864a                	mv	a2,s2
    80002026:	85a6                	mv	a1,s1
    80002028:	6928                	ld	a0,80(a0)
    8000202a:	fffff097          	auipc	ra,0xfffff
    8000202e:	c04080e7          	jalr	-1020(ra) # 80000c2e <copyinstr>
    80002032:	00054e63          	bltz	a0,8000204e <fetchstr+0x48>
  return strlen(buf);
    80002036:	8526                	mv	a0,s1
    80002038:	ffffe097          	auipc	ra,0xffffe
    8000203c:	2be080e7          	jalr	702(ra) # 800002f6 <strlen>
}
    80002040:	70a2                	ld	ra,40(sp)
    80002042:	7402                	ld	s0,32(sp)
    80002044:	64e2                	ld	s1,24(sp)
    80002046:	6942                	ld	s2,16(sp)
    80002048:	69a2                	ld	s3,8(sp)
    8000204a:	6145                	addi	sp,sp,48
    8000204c:	8082                	ret
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
    8000204e:	557d                	li	a0,-1
    80002050:	bfc5                	j	80002040 <fetchstr+0x3a>

0000000080002052 <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip) { *ip = argraw(n); }
    80002052:	1101                	addi	sp,sp,-32
    80002054:	ec06                	sd	ra,24(sp)
    80002056:	e822                	sd	s0,16(sp)
    80002058:	e426                	sd	s1,8(sp)
    8000205a:	1000                	addi	s0,sp,32
    8000205c:	84ae                	mv	s1,a1
    8000205e:	00000097          	auipc	ra,0x0
    80002062:	eee080e7          	jalr	-274(ra) # 80001f4c <argraw>
    80002066:	c088                	sw	a0,0(s1)
    80002068:	60e2                	ld	ra,24(sp)
    8000206a:	6442                	ld	s0,16(sp)
    8000206c:	64a2                	ld	s1,8(sp)
    8000206e:	6105                	addi	sp,sp,32
    80002070:	8082                	ret

0000000080002072 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip) { *ip = argraw(n); }
    80002072:	1101                	addi	sp,sp,-32
    80002074:	ec06                	sd	ra,24(sp)
    80002076:	e822                	sd	s0,16(sp)
    80002078:	e426                	sd	s1,8(sp)
    8000207a:	1000                	addi	s0,sp,32
    8000207c:	84ae                	mv	s1,a1
    8000207e:	00000097          	auipc	ra,0x0
    80002082:	ece080e7          	jalr	-306(ra) # 80001f4c <argraw>
    80002086:	e088                	sd	a0,0(s1)
    80002088:	60e2                	ld	ra,24(sp)
    8000208a:	6442                	ld	s0,16(sp)
    8000208c:	64a2                	ld	s1,8(sp)
    8000208e:	6105                	addi	sp,sp,32
    80002090:	8082                	ret

0000000080002092 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max) {
    80002092:	7179                	addi	sp,sp,-48
    80002094:	f406                	sd	ra,40(sp)
    80002096:	f022                	sd	s0,32(sp)
    80002098:	ec26                	sd	s1,24(sp)
    8000209a:	e84a                	sd	s2,16(sp)
    8000209c:	1800                	addi	s0,sp,48
    8000209e:	84ae                	mv	s1,a1
    800020a0:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    800020a2:	fd840593          	addi	a1,s0,-40
    800020a6:	00000097          	auipc	ra,0x0
    800020aa:	fcc080e7          	jalr	-52(ra) # 80002072 <argaddr>
  return fetchstr(addr, buf, max);
    800020ae:	864a                	mv	a2,s2
    800020b0:	85a6                	mv	a1,s1
    800020b2:	fd843503          	ld	a0,-40(s0)
    800020b6:	00000097          	auipc	ra,0x0
    800020ba:	f50080e7          	jalr	-176(ra) # 80002006 <fetchstr>
}
    800020be:	70a2                	ld	ra,40(sp)
    800020c0:	7402                	ld	s0,32(sp)
    800020c2:	64e2                	ld	s1,24(sp)
    800020c4:	6942                	ld	s2,16(sp)
    800020c6:	6145                	addi	sp,sp,48
    800020c8:	8082                	ret

00000000800020ca <syscall>:
    [SYS_write] sys_write, [SYS_mknod] sys_mknod,   [SYS_unlink] sys_unlink,
    [SYS_link] sys_link,   [SYS_mkdir] sys_mkdir,   [SYS_close] sys_close,
    [SYS_dump] sys_dump,   [SYS_dump2] sys_dump2,
};

void syscall(void) {
    800020ca:	1101                	addi	sp,sp,-32
    800020cc:	ec06                	sd	ra,24(sp)
    800020ce:	e822                	sd	s0,16(sp)
    800020d0:	e426                	sd	s1,8(sp)
    800020d2:	e04a                	sd	s2,0(sp)
    800020d4:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800020d6:	fffff097          	auipc	ra,0xfffff
    800020da:	d7e080e7          	jalr	-642(ra) # 80000e54 <myproc>
    800020de:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800020e0:	05853903          	ld	s2,88(a0)
    800020e4:	0a893783          	ld	a5,168(s2)
    800020e8:	0007869b          	sext.w	a3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020ec:	37fd                	addiw	a5,a5,-1
    800020ee:	4759                	li	a4,22
    800020f0:	00f76f63          	bltu	a4,a5,8000210e <syscall+0x44>
    800020f4:	00369713          	slli	a4,a3,0x3
    800020f8:	00006797          	auipc	a5,0x6
    800020fc:	2e878793          	addi	a5,a5,744 # 800083e0 <syscalls>
    80002100:	97ba                	add	a5,a5,a4
    80002102:	639c                	ld	a5,0(a5)
    80002104:	c789                	beqz	a5,8000210e <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002106:	9782                	jalr	a5
    80002108:	06a93823          	sd	a0,112(s2)
    8000210c:	a839                	j	8000212a <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    8000210e:	15848613          	addi	a2,s1,344
    80002112:	588c                	lw	a1,48(s1)
    80002114:	00006517          	auipc	a0,0x6
    80002118:	29450513          	addi	a0,a0,660 # 800083a8 <states.0+0x150>
    8000211c:	00004097          	auipc	ra,0x4
    80002120:	c0a080e7          	jalr	-1014(ra) # 80005d26 <printf>
    p->trapframe->a0 = -1;
    80002124:	6cbc                	ld	a5,88(s1)
    80002126:	577d                	li	a4,-1
    80002128:	fbb8                	sd	a4,112(a5)
  }
}
    8000212a:	60e2                	ld	ra,24(sp)
    8000212c:	6442                	ld	s0,16(sp)
    8000212e:	64a2                	ld	s1,8(sp)
    80002130:	6902                	ld	s2,0(sp)
    80002132:	6105                	addi	sp,sp,32
    80002134:	8082                	ret

0000000080002136 <sys_exit>:
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64 sys_exit(void) {
    80002136:	1101                	addi	sp,sp,-32
    80002138:	ec06                	sd	ra,24(sp)
    8000213a:	e822                	sd	s0,16(sp)
    8000213c:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000213e:	fec40593          	addi	a1,s0,-20
    80002142:	4501                	li	a0,0
    80002144:	00000097          	auipc	ra,0x0
    80002148:	f0e080e7          	jalr	-242(ra) # 80002052 <argint>
  exit(n);
    8000214c:	fec42503          	lw	a0,-20(s0)
    80002150:	fffff097          	auipc	ra,0xfffff
    80002154:	4e0080e7          	jalr	1248(ra) # 80001630 <exit>
  return 0;  // not reached
}
    80002158:	4501                	li	a0,0
    8000215a:	60e2                	ld	ra,24(sp)
    8000215c:	6442                	ld	s0,16(sp)
    8000215e:	6105                	addi	sp,sp,32
    80002160:	8082                	ret

0000000080002162 <sys_getpid>:

uint64 sys_getpid(void) { return myproc()->pid; }
    80002162:	1141                	addi	sp,sp,-16
    80002164:	e406                	sd	ra,8(sp)
    80002166:	e022                	sd	s0,0(sp)
    80002168:	0800                	addi	s0,sp,16
    8000216a:	fffff097          	auipc	ra,0xfffff
    8000216e:	cea080e7          	jalr	-790(ra) # 80000e54 <myproc>
    80002172:	5908                	lw	a0,48(a0)
    80002174:	60a2                	ld	ra,8(sp)
    80002176:	6402                	ld	s0,0(sp)
    80002178:	0141                	addi	sp,sp,16
    8000217a:	8082                	ret

000000008000217c <sys_fork>:

uint64 sys_fork(void) { return fork(); }
    8000217c:	1141                	addi	sp,sp,-16
    8000217e:	e406                	sd	ra,8(sp)
    80002180:	e022                	sd	s0,0(sp)
    80002182:	0800                	addi	s0,sp,16
    80002184:	fffff097          	auipc	ra,0xfffff
    80002188:	086080e7          	jalr	134(ra) # 8000120a <fork>
    8000218c:	60a2                	ld	ra,8(sp)
    8000218e:	6402                	ld	s0,0(sp)
    80002190:	0141                	addi	sp,sp,16
    80002192:	8082                	ret

0000000080002194 <sys_wait>:

uint64 sys_wait(void) {
    80002194:	1101                	addi	sp,sp,-32
    80002196:	ec06                	sd	ra,24(sp)
    80002198:	e822                	sd	s0,16(sp)
    8000219a:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000219c:	fe840593          	addi	a1,s0,-24
    800021a0:	4501                	li	a0,0
    800021a2:	00000097          	auipc	ra,0x0
    800021a6:	ed0080e7          	jalr	-304(ra) # 80002072 <argaddr>
  return wait(p);
    800021aa:	fe843503          	ld	a0,-24(s0)
    800021ae:	fffff097          	auipc	ra,0xfffff
    800021b2:	628080e7          	jalr	1576(ra) # 800017d6 <wait>
}
    800021b6:	60e2                	ld	ra,24(sp)
    800021b8:	6442                	ld	s0,16(sp)
    800021ba:	6105                	addi	sp,sp,32
    800021bc:	8082                	ret

00000000800021be <sys_sbrk>:

uint64 sys_sbrk(void) {
    800021be:	7179                	addi	sp,sp,-48
    800021c0:	f406                	sd	ra,40(sp)
    800021c2:	f022                	sd	s0,32(sp)
    800021c4:	ec26                	sd	s1,24(sp)
    800021c6:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800021c8:	fdc40593          	addi	a1,s0,-36
    800021cc:	4501                	li	a0,0
    800021ce:	00000097          	auipc	ra,0x0
    800021d2:	e84080e7          	jalr	-380(ra) # 80002052 <argint>
  addr = myproc()->sz;
    800021d6:	fffff097          	auipc	ra,0xfffff
    800021da:	c7e080e7          	jalr	-898(ra) # 80000e54 <myproc>
    800021de:	6524                	ld	s1,72(a0)
  if (growproc(n) < 0) return -1;
    800021e0:	fdc42503          	lw	a0,-36(s0)
    800021e4:	fffff097          	auipc	ra,0xfffff
    800021e8:	fca080e7          	jalr	-54(ra) # 800011ae <growproc>
    800021ec:	00054863          	bltz	a0,800021fc <sys_sbrk+0x3e>
  return addr;
}
    800021f0:	8526                	mv	a0,s1
    800021f2:	70a2                	ld	ra,40(sp)
    800021f4:	7402                	ld	s0,32(sp)
    800021f6:	64e2                	ld	s1,24(sp)
    800021f8:	6145                	addi	sp,sp,48
    800021fa:	8082                	ret
  if (growproc(n) < 0) return -1;
    800021fc:	54fd                	li	s1,-1
    800021fe:	bfcd                	j	800021f0 <sys_sbrk+0x32>

0000000080002200 <sys_sleep>:

uint64 sys_sleep(void) {
    80002200:	7139                	addi	sp,sp,-64
    80002202:	fc06                	sd	ra,56(sp)
    80002204:	f822                	sd	s0,48(sp)
    80002206:	f426                	sd	s1,40(sp)
    80002208:	f04a                	sd	s2,32(sp)
    8000220a:	ec4e                	sd	s3,24(sp)
    8000220c:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000220e:	fcc40593          	addi	a1,s0,-52
    80002212:	4501                	li	a0,0
    80002214:	00000097          	auipc	ra,0x0
    80002218:	e3e080e7          	jalr	-450(ra) # 80002052 <argint>
  acquire(&tickslock);
    8000221c:	0000c517          	auipc	a0,0xc
    80002220:	53450513          	addi	a0,a0,1332 # 8000e750 <tickslock>
    80002224:	00004097          	auipc	ra,0x4
    80002228:	ff0080e7          	jalr	-16(ra) # 80006214 <acquire>
  ticks0 = ticks;
    8000222c:	00006917          	auipc	s2,0x6
    80002230:	6bc92903          	lw	s2,1724(s2) # 800088e8 <ticks>
  while (ticks - ticks0 < n) {
    80002234:	fcc42783          	lw	a5,-52(s0)
    80002238:	cf9d                	beqz	a5,80002276 <sys_sleep+0x76>
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000223a:	0000c997          	auipc	s3,0xc
    8000223e:	51698993          	addi	s3,s3,1302 # 8000e750 <tickslock>
    80002242:	00006497          	auipc	s1,0x6
    80002246:	6a648493          	addi	s1,s1,1702 # 800088e8 <ticks>
    if (killed(myproc())) {
    8000224a:	fffff097          	auipc	ra,0xfffff
    8000224e:	c0a080e7          	jalr	-1014(ra) # 80000e54 <myproc>
    80002252:	fffff097          	auipc	ra,0xfffff
    80002256:	552080e7          	jalr	1362(ra) # 800017a4 <killed>
    8000225a:	ed15                	bnez	a0,80002296 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    8000225c:	85ce                	mv	a1,s3
    8000225e:	8526                	mv	a0,s1
    80002260:	fffff097          	auipc	ra,0xfffff
    80002264:	29c080e7          	jalr	668(ra) # 800014fc <sleep>
  while (ticks - ticks0 < n) {
    80002268:	409c                	lw	a5,0(s1)
    8000226a:	412787bb          	subw	a5,a5,s2
    8000226e:	fcc42703          	lw	a4,-52(s0)
    80002272:	fce7ece3          	bltu	a5,a4,8000224a <sys_sleep+0x4a>
  }
  release(&tickslock);
    80002276:	0000c517          	auipc	a0,0xc
    8000227a:	4da50513          	addi	a0,a0,1242 # 8000e750 <tickslock>
    8000227e:	00004097          	auipc	ra,0x4
    80002282:	04a080e7          	jalr	74(ra) # 800062c8 <release>
  return 0;
    80002286:	4501                	li	a0,0
}
    80002288:	70e2                	ld	ra,56(sp)
    8000228a:	7442                	ld	s0,48(sp)
    8000228c:	74a2                	ld	s1,40(sp)
    8000228e:	7902                	ld	s2,32(sp)
    80002290:	69e2                	ld	s3,24(sp)
    80002292:	6121                	addi	sp,sp,64
    80002294:	8082                	ret
      release(&tickslock);
    80002296:	0000c517          	auipc	a0,0xc
    8000229a:	4ba50513          	addi	a0,a0,1210 # 8000e750 <tickslock>
    8000229e:	00004097          	auipc	ra,0x4
    800022a2:	02a080e7          	jalr	42(ra) # 800062c8 <release>
      return -1;
    800022a6:	557d                	li	a0,-1
    800022a8:	b7c5                	j	80002288 <sys_sleep+0x88>

00000000800022aa <sys_kill>:

uint64 sys_kill(void) {
    800022aa:	1101                	addi	sp,sp,-32
    800022ac:	ec06                	sd	ra,24(sp)
    800022ae:	e822                	sd	s0,16(sp)
    800022b0:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800022b2:	fec40593          	addi	a1,s0,-20
    800022b6:	4501                	li	a0,0
    800022b8:	00000097          	auipc	ra,0x0
    800022bc:	d9a080e7          	jalr	-614(ra) # 80002052 <argint>
  return kill(pid);
    800022c0:	fec42503          	lw	a0,-20(s0)
    800022c4:	fffff097          	auipc	ra,0xfffff
    800022c8:	442080e7          	jalr	1090(ra) # 80001706 <kill>
}
    800022cc:	60e2                	ld	ra,24(sp)
    800022ce:	6442                	ld	s0,16(sp)
    800022d0:	6105                	addi	sp,sp,32
    800022d2:	8082                	ret

00000000800022d4 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
    800022d4:	1101                	addi	sp,sp,-32
    800022d6:	ec06                	sd	ra,24(sp)
    800022d8:	e822                	sd	s0,16(sp)
    800022da:	e426                	sd	s1,8(sp)
    800022dc:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022de:	0000c517          	auipc	a0,0xc
    800022e2:	47250513          	addi	a0,a0,1138 # 8000e750 <tickslock>
    800022e6:	00004097          	auipc	ra,0x4
    800022ea:	f2e080e7          	jalr	-210(ra) # 80006214 <acquire>
  xticks = ticks;
    800022ee:	00006497          	auipc	s1,0x6
    800022f2:	5fa4a483          	lw	s1,1530(s1) # 800088e8 <ticks>
  release(&tickslock);
    800022f6:	0000c517          	auipc	a0,0xc
    800022fa:	45a50513          	addi	a0,a0,1114 # 8000e750 <tickslock>
    800022fe:	00004097          	auipc	ra,0x4
    80002302:	fca080e7          	jalr	-54(ra) # 800062c8 <release>
  return xticks;
}
    80002306:	02049513          	slli	a0,s1,0x20
    8000230a:	9101                	srli	a0,a0,0x20
    8000230c:	60e2                	ld	ra,24(sp)
    8000230e:	6442                	ld	s0,16(sp)
    80002310:	64a2                	ld	s1,8(sp)
    80002312:	6105                	addi	sp,sp,32
    80002314:	8082                	ret

0000000080002316 <sys_dump>:

uint64 sys_dump(void) { return dump(); }
    80002316:	1141                	addi	sp,sp,-16
    80002318:	e406                	sd	ra,8(sp)
    8000231a:	e022                	sd	s0,0(sp)
    8000231c:	0800                	addi	s0,sp,16
    8000231e:	fffff097          	auipc	ra,0xfffff
    80002322:	742080e7          	jalr	1858(ra) # 80001a60 <dump>
    80002326:	60a2                	ld	ra,8(sp)
    80002328:	6402                	ld	s0,0(sp)
    8000232a:	0141                	addi	sp,sp,16
    8000232c:	8082                	ret

000000008000232e <sys_dump2>:

uint64 sys_dump2(void) {
    8000232e:	1101                	addi	sp,sp,-32
    80002330:	ec06                	sd	ra,24(sp)
    80002332:	e822                	sd	s0,16(sp)
    80002334:	1000                	addi	s0,sp,32
  int pid, register_num;
  uint64 return_value;

  argint(0, &pid);
    80002336:	fec40593          	addi	a1,s0,-20
    8000233a:	4501                	li	a0,0
    8000233c:	00000097          	auipc	ra,0x0
    80002340:	d16080e7          	jalr	-746(ra) # 80002052 <argint>
  argint(1, &register_num);
    80002344:	fe840593          	addi	a1,s0,-24
    80002348:	4505                	li	a0,1
    8000234a:	00000097          	auipc	ra,0x0
    8000234e:	d08080e7          	jalr	-760(ra) # 80002052 <argint>
  argaddr(2, &return_value);
    80002352:	fe040593          	addi	a1,s0,-32
    80002356:	4509                	li	a0,2
    80002358:	00000097          	auipc	ra,0x0
    8000235c:	d1a080e7          	jalr	-742(ra) # 80002072 <argaddr>

  return dump2(pid, register_num, &return_value);
    80002360:	fe040613          	addi	a2,s0,-32
    80002364:	fe842583          	lw	a1,-24(s0)
    80002368:	fec42503          	lw	a0,-20(s0)
    8000236c:	fffff097          	auipc	ra,0xfffff
    80002370:	74a080e7          	jalr	1866(ra) # 80001ab6 <dump2>
}
    80002374:	60e2                	ld	ra,24(sp)
    80002376:	6442                	ld	s0,16(sp)
    80002378:	6105                	addi	sp,sp,32
    8000237a:	8082                	ret

000000008000237c <binit>:
  // Sorted by how recently the buffer was used.
  // head.next is most recent, head.prev is least.
  struct buf head;
} bcache;

void binit(void) {
    8000237c:	7179                	addi	sp,sp,-48
    8000237e:	f406                	sd	ra,40(sp)
    80002380:	f022                	sd	s0,32(sp)
    80002382:	ec26                	sd	s1,24(sp)
    80002384:	e84a                	sd	s2,16(sp)
    80002386:	e44e                	sd	s3,8(sp)
    80002388:	e052                	sd	s4,0(sp)
    8000238a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000238c:	00006597          	auipc	a1,0x6
    80002390:	11458593          	addi	a1,a1,276 # 800084a0 <syscalls+0xc0>
    80002394:	0000c517          	auipc	a0,0xc
    80002398:	3d450513          	addi	a0,a0,980 # 8000e768 <bcache>
    8000239c:	00004097          	auipc	ra,0x4
    800023a0:	de8080e7          	jalr	-536(ra) # 80006184 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800023a4:	00014797          	auipc	a5,0x14
    800023a8:	3c478793          	addi	a5,a5,964 # 80016768 <bcache+0x8000>
    800023ac:	00014717          	auipc	a4,0x14
    800023b0:	62470713          	addi	a4,a4,1572 # 800169d0 <bcache+0x8268>
    800023b4:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023b8:	2ae7bc23          	sd	a4,696(a5)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    800023bc:	0000c497          	auipc	s1,0xc
    800023c0:	3c448493          	addi	s1,s1,964 # 8000e780 <bcache+0x18>
    b->next = bcache.head.next;
    800023c4:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023c6:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023c8:	00006a17          	auipc	s4,0x6
    800023cc:	0e0a0a13          	addi	s4,s4,224 # 800084a8 <syscalls+0xc8>
    b->next = bcache.head.next;
    800023d0:	2b893783          	ld	a5,696(s2)
    800023d4:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023d6:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023da:	85d2                	mv	a1,s4
    800023dc:	01048513          	addi	a0,s1,16
    800023e0:	00001097          	auipc	ra,0x1
    800023e4:	4c8080e7          	jalr	1224(ra) # 800038a8 <initsleeplock>
    bcache.head.next->prev = b;
    800023e8:	2b893783          	ld	a5,696(s2)
    800023ec:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023ee:	2a993c23          	sd	s1,696(s2)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    800023f2:	45848493          	addi	s1,s1,1112
    800023f6:	fd349de3          	bne	s1,s3,800023d0 <binit+0x54>
  }
}
    800023fa:	70a2                	ld	ra,40(sp)
    800023fc:	7402                	ld	s0,32(sp)
    800023fe:	64e2                	ld	s1,24(sp)
    80002400:	6942                	ld	s2,16(sp)
    80002402:	69a2                	ld	s3,8(sp)
    80002404:	6a02                	ld	s4,0(sp)
    80002406:	6145                	addi	sp,sp,48
    80002408:	8082                	ret

000000008000240a <bread>:
  }
  panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.
struct buf *bread(uint dev, uint blockno) {
    8000240a:	7179                	addi	sp,sp,-48
    8000240c:	f406                	sd	ra,40(sp)
    8000240e:	f022                	sd	s0,32(sp)
    80002410:	ec26                	sd	s1,24(sp)
    80002412:	e84a                	sd	s2,16(sp)
    80002414:	e44e                	sd	s3,8(sp)
    80002416:	1800                	addi	s0,sp,48
    80002418:	892a                	mv	s2,a0
    8000241a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000241c:	0000c517          	auipc	a0,0xc
    80002420:	34c50513          	addi	a0,a0,844 # 8000e768 <bcache>
    80002424:	00004097          	auipc	ra,0x4
    80002428:	df0080e7          	jalr	-528(ra) # 80006214 <acquire>
  for (b = bcache.head.next; b != &bcache.head; b = b->next) {
    8000242c:	00014497          	auipc	s1,0x14
    80002430:	5f44b483          	ld	s1,1524(s1) # 80016a20 <bcache+0x82b8>
    80002434:	00014797          	auipc	a5,0x14
    80002438:	59c78793          	addi	a5,a5,1436 # 800169d0 <bcache+0x8268>
    8000243c:	02f48f63          	beq	s1,a5,8000247a <bread+0x70>
    80002440:	873e                	mv	a4,a5
    80002442:	a021                	j	8000244a <bread+0x40>
    80002444:	68a4                	ld	s1,80(s1)
    80002446:	02e48a63          	beq	s1,a4,8000247a <bread+0x70>
    if (b->dev == dev && b->blockno == blockno) {
    8000244a:	449c                	lw	a5,8(s1)
    8000244c:	ff279ce3          	bne	a5,s2,80002444 <bread+0x3a>
    80002450:	44dc                	lw	a5,12(s1)
    80002452:	ff3799e3          	bne	a5,s3,80002444 <bread+0x3a>
      b->refcnt++;
    80002456:	40bc                	lw	a5,64(s1)
    80002458:	2785                	addiw	a5,a5,1
    8000245a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000245c:	0000c517          	auipc	a0,0xc
    80002460:	30c50513          	addi	a0,a0,780 # 8000e768 <bcache>
    80002464:	00004097          	auipc	ra,0x4
    80002468:	e64080e7          	jalr	-412(ra) # 800062c8 <release>
      acquiresleep(&b->lock);
    8000246c:	01048513          	addi	a0,s1,16
    80002470:	00001097          	auipc	ra,0x1
    80002474:	472080e7          	jalr	1138(ra) # 800038e2 <acquiresleep>
      return b;
    80002478:	a8b9                	j	800024d6 <bread+0xcc>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    8000247a:	00014497          	auipc	s1,0x14
    8000247e:	59e4b483          	ld	s1,1438(s1) # 80016a18 <bcache+0x82b0>
    80002482:	00014797          	auipc	a5,0x14
    80002486:	54e78793          	addi	a5,a5,1358 # 800169d0 <bcache+0x8268>
    8000248a:	00f48863          	beq	s1,a5,8000249a <bread+0x90>
    8000248e:	873e                	mv	a4,a5
    if (b->refcnt == 0) {
    80002490:	40bc                	lw	a5,64(s1)
    80002492:	cf81                	beqz	a5,800024aa <bread+0xa0>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002494:	64a4                	ld	s1,72(s1)
    80002496:	fee49de3          	bne	s1,a4,80002490 <bread+0x86>
  panic("bget: no buffers");
    8000249a:	00006517          	auipc	a0,0x6
    8000249e:	01650513          	addi	a0,a0,22 # 800084b0 <syscalls+0xd0>
    800024a2:	00004097          	auipc	ra,0x4
    800024a6:	83a080e7          	jalr	-1990(ra) # 80005cdc <panic>
      b->dev = dev;
    800024aa:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800024ae:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800024b2:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024b6:	4785                	li	a5,1
    800024b8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024ba:	0000c517          	auipc	a0,0xc
    800024be:	2ae50513          	addi	a0,a0,686 # 8000e768 <bcache>
    800024c2:	00004097          	auipc	ra,0x4
    800024c6:	e06080e7          	jalr	-506(ra) # 800062c8 <release>
      acquiresleep(&b->lock);
    800024ca:	01048513          	addi	a0,s1,16
    800024ce:	00001097          	auipc	ra,0x1
    800024d2:	414080e7          	jalr	1044(ra) # 800038e2 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid) {
    800024d6:	409c                	lw	a5,0(s1)
    800024d8:	cb89                	beqz	a5,800024ea <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024da:	8526                	mv	a0,s1
    800024dc:	70a2                	ld	ra,40(sp)
    800024de:	7402                	ld	s0,32(sp)
    800024e0:	64e2                	ld	s1,24(sp)
    800024e2:	6942                	ld	s2,16(sp)
    800024e4:	69a2                	ld	s3,8(sp)
    800024e6:	6145                	addi	sp,sp,48
    800024e8:	8082                	ret
    virtio_disk_rw(b, 0);
    800024ea:	4581                	li	a1,0
    800024ec:	8526                	mv	a0,s1
    800024ee:	00003097          	auipc	ra,0x3
    800024f2:	fe4080e7          	jalr	-28(ra) # 800054d2 <virtio_disk_rw>
    b->valid = 1;
    800024f6:	4785                	li	a5,1
    800024f8:	c09c                	sw	a5,0(s1)
  return b;
    800024fa:	b7c5                	j	800024da <bread+0xd0>

00000000800024fc <bwrite>:

// Write b's contents to disk.  Must be locked.
void bwrite(struct buf *b) {
    800024fc:	1101                	addi	sp,sp,-32
    800024fe:	ec06                	sd	ra,24(sp)
    80002500:	e822                	sd	s0,16(sp)
    80002502:	e426                	sd	s1,8(sp)
    80002504:	1000                	addi	s0,sp,32
    80002506:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock)) panic("bwrite");
    80002508:	0541                	addi	a0,a0,16
    8000250a:	00001097          	auipc	ra,0x1
    8000250e:	472080e7          	jalr	1138(ra) # 8000397c <holdingsleep>
    80002512:	cd01                	beqz	a0,8000252a <bwrite+0x2e>
  virtio_disk_rw(b, 1);
    80002514:	4585                	li	a1,1
    80002516:	8526                	mv	a0,s1
    80002518:	00003097          	auipc	ra,0x3
    8000251c:	fba080e7          	jalr	-70(ra) # 800054d2 <virtio_disk_rw>
}
    80002520:	60e2                	ld	ra,24(sp)
    80002522:	6442                	ld	s0,16(sp)
    80002524:	64a2                	ld	s1,8(sp)
    80002526:	6105                	addi	sp,sp,32
    80002528:	8082                	ret
  if (!holdingsleep(&b->lock)) panic("bwrite");
    8000252a:	00006517          	auipc	a0,0x6
    8000252e:	f9e50513          	addi	a0,a0,-98 # 800084c8 <syscalls+0xe8>
    80002532:	00003097          	auipc	ra,0x3
    80002536:	7aa080e7          	jalr	1962(ra) # 80005cdc <panic>

000000008000253a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void brelse(struct buf *b) {
    8000253a:	1101                	addi	sp,sp,-32
    8000253c:	ec06                	sd	ra,24(sp)
    8000253e:	e822                	sd	s0,16(sp)
    80002540:	e426                	sd	s1,8(sp)
    80002542:	e04a                	sd	s2,0(sp)
    80002544:	1000                	addi	s0,sp,32
    80002546:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock)) panic("brelse");
    80002548:	01050913          	addi	s2,a0,16
    8000254c:	854a                	mv	a0,s2
    8000254e:	00001097          	auipc	ra,0x1
    80002552:	42e080e7          	jalr	1070(ra) # 8000397c <holdingsleep>
    80002556:	c92d                	beqz	a0,800025c8 <brelse+0x8e>

  releasesleep(&b->lock);
    80002558:	854a                	mv	a0,s2
    8000255a:	00001097          	auipc	ra,0x1
    8000255e:	3de080e7          	jalr	990(ra) # 80003938 <releasesleep>

  acquire(&bcache.lock);
    80002562:	0000c517          	auipc	a0,0xc
    80002566:	20650513          	addi	a0,a0,518 # 8000e768 <bcache>
    8000256a:	00004097          	auipc	ra,0x4
    8000256e:	caa080e7          	jalr	-854(ra) # 80006214 <acquire>
  b->refcnt--;
    80002572:	40bc                	lw	a5,64(s1)
    80002574:	37fd                	addiw	a5,a5,-1
    80002576:	0007871b          	sext.w	a4,a5
    8000257a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000257c:	eb05                	bnez	a4,800025ac <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000257e:	68bc                	ld	a5,80(s1)
    80002580:	64b8                	ld	a4,72(s1)
    80002582:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002584:	64bc                	ld	a5,72(s1)
    80002586:	68b8                	ld	a4,80(s1)
    80002588:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000258a:	00014797          	auipc	a5,0x14
    8000258e:	1de78793          	addi	a5,a5,478 # 80016768 <bcache+0x8000>
    80002592:	2b87b703          	ld	a4,696(a5)
    80002596:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002598:	00014717          	auipc	a4,0x14
    8000259c:	43870713          	addi	a4,a4,1080 # 800169d0 <bcache+0x8268>
    800025a0:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800025a2:	2b87b703          	ld	a4,696(a5)
    800025a6:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800025a8:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    800025ac:	0000c517          	auipc	a0,0xc
    800025b0:	1bc50513          	addi	a0,a0,444 # 8000e768 <bcache>
    800025b4:	00004097          	auipc	ra,0x4
    800025b8:	d14080e7          	jalr	-748(ra) # 800062c8 <release>
}
    800025bc:	60e2                	ld	ra,24(sp)
    800025be:	6442                	ld	s0,16(sp)
    800025c0:	64a2                	ld	s1,8(sp)
    800025c2:	6902                	ld	s2,0(sp)
    800025c4:	6105                	addi	sp,sp,32
    800025c6:	8082                	ret
  if (!holdingsleep(&b->lock)) panic("brelse");
    800025c8:	00006517          	auipc	a0,0x6
    800025cc:	f0850513          	addi	a0,a0,-248 # 800084d0 <syscalls+0xf0>
    800025d0:	00003097          	auipc	ra,0x3
    800025d4:	70c080e7          	jalr	1804(ra) # 80005cdc <panic>

00000000800025d8 <bpin>:

void bpin(struct buf *b) {
    800025d8:	1101                	addi	sp,sp,-32
    800025da:	ec06                	sd	ra,24(sp)
    800025dc:	e822                	sd	s0,16(sp)
    800025de:	e426                	sd	s1,8(sp)
    800025e0:	1000                	addi	s0,sp,32
    800025e2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025e4:	0000c517          	auipc	a0,0xc
    800025e8:	18450513          	addi	a0,a0,388 # 8000e768 <bcache>
    800025ec:	00004097          	auipc	ra,0x4
    800025f0:	c28080e7          	jalr	-984(ra) # 80006214 <acquire>
  b->refcnt++;
    800025f4:	40bc                	lw	a5,64(s1)
    800025f6:	2785                	addiw	a5,a5,1
    800025f8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025fa:	0000c517          	auipc	a0,0xc
    800025fe:	16e50513          	addi	a0,a0,366 # 8000e768 <bcache>
    80002602:	00004097          	auipc	ra,0x4
    80002606:	cc6080e7          	jalr	-826(ra) # 800062c8 <release>
}
    8000260a:	60e2                	ld	ra,24(sp)
    8000260c:	6442                	ld	s0,16(sp)
    8000260e:	64a2                	ld	s1,8(sp)
    80002610:	6105                	addi	sp,sp,32
    80002612:	8082                	ret

0000000080002614 <bunpin>:

void bunpin(struct buf *b) {
    80002614:	1101                	addi	sp,sp,-32
    80002616:	ec06                	sd	ra,24(sp)
    80002618:	e822                	sd	s0,16(sp)
    8000261a:	e426                	sd	s1,8(sp)
    8000261c:	1000                	addi	s0,sp,32
    8000261e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002620:	0000c517          	auipc	a0,0xc
    80002624:	14850513          	addi	a0,a0,328 # 8000e768 <bcache>
    80002628:	00004097          	auipc	ra,0x4
    8000262c:	bec080e7          	jalr	-1044(ra) # 80006214 <acquire>
  b->refcnt--;
    80002630:	40bc                	lw	a5,64(s1)
    80002632:	37fd                	addiw	a5,a5,-1
    80002634:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002636:	0000c517          	auipc	a0,0xc
    8000263a:	13250513          	addi	a0,a0,306 # 8000e768 <bcache>
    8000263e:	00004097          	auipc	ra,0x4
    80002642:	c8a080e7          	jalr	-886(ra) # 800062c8 <release>
}
    80002646:	60e2                	ld	ra,24(sp)
    80002648:	6442                	ld	s0,16(sp)
    8000264a:	64a2                	ld	s1,8(sp)
    8000264c:	6105                	addi	sp,sp,32
    8000264e:	8082                	ret

0000000080002650 <bfree>:
  printf("balloc: out of blocks\n");
  return 0;
}

// Free a disk block.
static void bfree(int dev, uint b) {
    80002650:	1101                	addi	sp,sp,-32
    80002652:	ec06                	sd	ra,24(sp)
    80002654:	e822                	sd	s0,16(sp)
    80002656:	e426                	sd	s1,8(sp)
    80002658:	e04a                	sd	s2,0(sp)
    8000265a:	1000                	addi	s0,sp,32
    8000265c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000265e:	00d5d59b          	srliw	a1,a1,0xd
    80002662:	00014797          	auipc	a5,0x14
    80002666:	7e27a783          	lw	a5,2018(a5) # 80016e44 <sb+0x1c>
    8000266a:	9dbd                	addw	a1,a1,a5
    8000266c:	00000097          	auipc	ra,0x0
    80002670:	d9e080e7          	jalr	-610(ra) # 8000240a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002674:	0074f713          	andi	a4,s1,7
    80002678:	4785                	li	a5,1
    8000267a:	00e797bb          	sllw	a5,a5,a4
  if ((bp->data[bi / 8] & m) == 0) panic("freeing free block");
    8000267e:	14ce                	slli	s1,s1,0x33
    80002680:	90d9                	srli	s1,s1,0x36
    80002682:	00950733          	add	a4,a0,s1
    80002686:	05874703          	lbu	a4,88(a4)
    8000268a:	00e7f6b3          	and	a3,a5,a4
    8000268e:	c69d                	beqz	a3,800026bc <bfree+0x6c>
    80002690:	892a                	mv	s2,a0
  bp->data[bi / 8] &= ~m;
    80002692:	94aa                	add	s1,s1,a0
    80002694:	fff7c793          	not	a5,a5
    80002698:	8f7d                	and	a4,a4,a5
    8000269a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000269e:	00001097          	auipc	ra,0x1
    800026a2:	126080e7          	jalr	294(ra) # 800037c4 <log_write>
  brelse(bp);
    800026a6:	854a                	mv	a0,s2
    800026a8:	00000097          	auipc	ra,0x0
    800026ac:	e92080e7          	jalr	-366(ra) # 8000253a <brelse>
}
    800026b0:	60e2                	ld	ra,24(sp)
    800026b2:	6442                	ld	s0,16(sp)
    800026b4:	64a2                	ld	s1,8(sp)
    800026b6:	6902                	ld	s2,0(sp)
    800026b8:	6105                	addi	sp,sp,32
    800026ba:	8082                	ret
  if ((bp->data[bi / 8] & m) == 0) panic("freeing free block");
    800026bc:	00006517          	auipc	a0,0x6
    800026c0:	e1c50513          	addi	a0,a0,-484 # 800084d8 <syscalls+0xf8>
    800026c4:	00003097          	auipc	ra,0x3
    800026c8:	618080e7          	jalr	1560(ra) # 80005cdc <panic>

00000000800026cc <balloc>:
static uint balloc(uint dev) {
    800026cc:	711d                	addi	sp,sp,-96
    800026ce:	ec86                	sd	ra,88(sp)
    800026d0:	e8a2                	sd	s0,80(sp)
    800026d2:	e4a6                	sd	s1,72(sp)
    800026d4:	e0ca                	sd	s2,64(sp)
    800026d6:	fc4e                	sd	s3,56(sp)
    800026d8:	f852                	sd	s4,48(sp)
    800026da:	f456                	sd	s5,40(sp)
    800026dc:	f05a                	sd	s6,32(sp)
    800026de:	ec5e                	sd	s7,24(sp)
    800026e0:	e862                	sd	s8,16(sp)
    800026e2:	e466                	sd	s9,8(sp)
    800026e4:	1080                	addi	s0,sp,96
  for (b = 0; b < sb.size; b += BPB) {
    800026e6:	00014797          	auipc	a5,0x14
    800026ea:	7467a783          	lw	a5,1862(a5) # 80016e2c <sb+0x4>
    800026ee:	cff5                	beqz	a5,800027ea <balloc+0x11e>
    800026f0:	8baa                	mv	s7,a0
    800026f2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026f4:	00014b17          	auipc	s6,0x14
    800026f8:	734b0b13          	addi	s6,s6,1844 # 80016e28 <sb>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800026fc:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026fe:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002700:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB) {
    80002702:	6c89                	lui	s9,0x2
    80002704:	a061                	j	8000278c <balloc+0xc0>
        bp->data[bi / 8] |= m;            // Mark block in use.
    80002706:	97ca                	add	a5,a5,s2
    80002708:	8e55                	or	a2,a2,a3
    8000270a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000270e:	854a                	mv	a0,s2
    80002710:	00001097          	auipc	ra,0x1
    80002714:	0b4080e7          	jalr	180(ra) # 800037c4 <log_write>
        brelse(bp);
    80002718:	854a                	mv	a0,s2
    8000271a:	00000097          	auipc	ra,0x0
    8000271e:	e20080e7          	jalr	-480(ra) # 8000253a <brelse>
  bp = bread(dev, bno);
    80002722:	85a6                	mv	a1,s1
    80002724:	855e                	mv	a0,s7
    80002726:	00000097          	auipc	ra,0x0
    8000272a:	ce4080e7          	jalr	-796(ra) # 8000240a <bread>
    8000272e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002730:	40000613          	li	a2,1024
    80002734:	4581                	li	a1,0
    80002736:	05850513          	addi	a0,a0,88
    8000273a:	ffffe097          	auipc	ra,0xffffe
    8000273e:	a40080e7          	jalr	-1472(ra) # 8000017a <memset>
  log_write(bp);
    80002742:	854a                	mv	a0,s2
    80002744:	00001097          	auipc	ra,0x1
    80002748:	080080e7          	jalr	128(ra) # 800037c4 <log_write>
  brelse(bp);
    8000274c:	854a                	mv	a0,s2
    8000274e:	00000097          	auipc	ra,0x0
    80002752:	dec080e7          	jalr	-532(ra) # 8000253a <brelse>
}
    80002756:	8526                	mv	a0,s1
    80002758:	60e6                	ld	ra,88(sp)
    8000275a:	6446                	ld	s0,80(sp)
    8000275c:	64a6                	ld	s1,72(sp)
    8000275e:	6906                	ld	s2,64(sp)
    80002760:	79e2                	ld	s3,56(sp)
    80002762:	7a42                	ld	s4,48(sp)
    80002764:	7aa2                	ld	s5,40(sp)
    80002766:	7b02                	ld	s6,32(sp)
    80002768:	6be2                	ld	s7,24(sp)
    8000276a:	6c42                	ld	s8,16(sp)
    8000276c:	6ca2                	ld	s9,8(sp)
    8000276e:	6125                	addi	sp,sp,96
    80002770:	8082                	ret
    brelse(bp);
    80002772:	854a                	mv	a0,s2
    80002774:	00000097          	auipc	ra,0x0
    80002778:	dc6080e7          	jalr	-570(ra) # 8000253a <brelse>
  for (b = 0; b < sb.size; b += BPB) {
    8000277c:	015c87bb          	addw	a5,s9,s5
    80002780:	00078a9b          	sext.w	s5,a5
    80002784:	004b2703          	lw	a4,4(s6)
    80002788:	06eaf163          	bgeu	s5,a4,800027ea <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    8000278c:	41fad79b          	sraiw	a5,s5,0x1f
    80002790:	0137d79b          	srliw	a5,a5,0x13
    80002794:	015787bb          	addw	a5,a5,s5
    80002798:	40d7d79b          	sraiw	a5,a5,0xd
    8000279c:	01cb2583          	lw	a1,28(s6)
    800027a0:	9dbd                	addw	a1,a1,a5
    800027a2:	855e                	mv	a0,s7
    800027a4:	00000097          	auipc	ra,0x0
    800027a8:	c66080e7          	jalr	-922(ra) # 8000240a <bread>
    800027ac:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800027ae:	004b2503          	lw	a0,4(s6)
    800027b2:	000a849b          	sext.w	s1,s5
    800027b6:	8762                	mv	a4,s8
    800027b8:	faa4fde3          	bgeu	s1,a0,80002772 <balloc+0xa6>
      m = 1 << (bi % 8);
    800027bc:	00777693          	andi	a3,a4,7
    800027c0:	00d996bb          	sllw	a3,s3,a3
      if ((bp->data[bi / 8] & m) == 0) {  // Is block free?
    800027c4:	41f7579b          	sraiw	a5,a4,0x1f
    800027c8:	01d7d79b          	srliw	a5,a5,0x1d
    800027cc:	9fb9                	addw	a5,a5,a4
    800027ce:	4037d79b          	sraiw	a5,a5,0x3
    800027d2:	00f90633          	add	a2,s2,a5
    800027d6:	05864603          	lbu	a2,88(a2)
    800027da:	00c6f5b3          	and	a1,a3,a2
    800027de:	d585                	beqz	a1,80002706 <balloc+0x3a>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800027e0:	2705                	addiw	a4,a4,1
    800027e2:	2485                	addiw	s1,s1,1
    800027e4:	fd471ae3          	bne	a4,s4,800027b8 <balloc+0xec>
    800027e8:	b769                	j	80002772 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    800027ea:	00006517          	auipc	a0,0x6
    800027ee:	d0650513          	addi	a0,a0,-762 # 800084f0 <syscalls+0x110>
    800027f2:	00003097          	auipc	ra,0x3
    800027f6:	534080e7          	jalr	1332(ra) # 80005d26 <printf>
  return 0;
    800027fa:	4481                	li	s1,0
    800027fc:	bfa9                	j	80002756 <balloc+0x8a>

00000000800027fe <bmap>:
// listed in block ip->addrs[NDIRECT].

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint bmap(struct inode *ip, uint bn) {
    800027fe:	7179                	addi	sp,sp,-48
    80002800:	f406                	sd	ra,40(sp)
    80002802:	f022                	sd	s0,32(sp)
    80002804:	ec26                	sd	s1,24(sp)
    80002806:	e84a                	sd	s2,16(sp)
    80002808:	e44e                	sd	s3,8(sp)
    8000280a:	e052                	sd	s4,0(sp)
    8000280c:	1800                	addi	s0,sp,48
    8000280e:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT) {
    80002810:	47ad                	li	a5,11
    80002812:	02b7e863          	bltu	a5,a1,80002842 <bmap+0x44>
    if ((addr = ip->addrs[bn]) == 0) {
    80002816:	02059793          	slli	a5,a1,0x20
    8000281a:	01e7d593          	srli	a1,a5,0x1e
    8000281e:	00b504b3          	add	s1,a0,a1
    80002822:	0504a903          	lw	s2,80(s1)
    80002826:	06091e63          	bnez	s2,800028a2 <bmap+0xa4>
      addr = balloc(ip->dev);
    8000282a:	4108                	lw	a0,0(a0)
    8000282c:	00000097          	auipc	ra,0x0
    80002830:	ea0080e7          	jalr	-352(ra) # 800026cc <balloc>
    80002834:	0005091b          	sext.w	s2,a0
      if (addr == 0) return 0;
    80002838:	06090563          	beqz	s2,800028a2 <bmap+0xa4>
      ip->addrs[bn] = addr;
    8000283c:	0524a823          	sw	s2,80(s1)
    80002840:	a08d                	j	800028a2 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002842:	ff45849b          	addiw	s1,a1,-12
    80002846:	0004871b          	sext.w	a4,s1

  if (bn < NINDIRECT) {
    8000284a:	0ff00793          	li	a5,255
    8000284e:	08e7e563          	bltu	a5,a4,800028d8 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0) {
    80002852:	08052903          	lw	s2,128(a0)
    80002856:	00091d63          	bnez	s2,80002870 <bmap+0x72>
      addr = balloc(ip->dev);
    8000285a:	4108                	lw	a0,0(a0)
    8000285c:	00000097          	auipc	ra,0x0
    80002860:	e70080e7          	jalr	-400(ra) # 800026cc <balloc>
    80002864:	0005091b          	sext.w	s2,a0
      if (addr == 0) return 0;
    80002868:	02090d63          	beqz	s2,800028a2 <bmap+0xa4>
      ip->addrs[NDIRECT] = addr;
    8000286c:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002870:	85ca                	mv	a1,s2
    80002872:	0009a503          	lw	a0,0(s3)
    80002876:	00000097          	auipc	ra,0x0
    8000287a:	b94080e7          	jalr	-1132(ra) # 8000240a <bread>
    8000287e:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    80002880:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0) {
    80002884:	02049713          	slli	a4,s1,0x20
    80002888:	01e75593          	srli	a1,a4,0x1e
    8000288c:	00b784b3          	add	s1,a5,a1
    80002890:	0004a903          	lw	s2,0(s1)
    80002894:	02090063          	beqz	s2,800028b4 <bmap+0xb6>
      if (addr) {
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002898:	8552                	mv	a0,s4
    8000289a:	00000097          	auipc	ra,0x0
    8000289e:	ca0080e7          	jalr	-864(ra) # 8000253a <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800028a2:	854a                	mv	a0,s2
    800028a4:	70a2                	ld	ra,40(sp)
    800028a6:	7402                	ld	s0,32(sp)
    800028a8:	64e2                	ld	s1,24(sp)
    800028aa:	6942                	ld	s2,16(sp)
    800028ac:	69a2                	ld	s3,8(sp)
    800028ae:	6a02                	ld	s4,0(sp)
    800028b0:	6145                	addi	sp,sp,48
    800028b2:	8082                	ret
      addr = balloc(ip->dev);
    800028b4:	0009a503          	lw	a0,0(s3)
    800028b8:	00000097          	auipc	ra,0x0
    800028bc:	e14080e7          	jalr	-492(ra) # 800026cc <balloc>
    800028c0:	0005091b          	sext.w	s2,a0
      if (addr) {
    800028c4:	fc090ae3          	beqz	s2,80002898 <bmap+0x9a>
        a[bn] = addr;
    800028c8:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800028cc:	8552                	mv	a0,s4
    800028ce:	00001097          	auipc	ra,0x1
    800028d2:	ef6080e7          	jalr	-266(ra) # 800037c4 <log_write>
    800028d6:	b7c9                	j	80002898 <bmap+0x9a>
  panic("bmap: out of range");
    800028d8:	00006517          	auipc	a0,0x6
    800028dc:	c3050513          	addi	a0,a0,-976 # 80008508 <syscalls+0x128>
    800028e0:	00003097          	auipc	ra,0x3
    800028e4:	3fc080e7          	jalr	1020(ra) # 80005cdc <panic>

00000000800028e8 <iget>:
static struct inode *iget(uint dev, uint inum) {
    800028e8:	7179                	addi	sp,sp,-48
    800028ea:	f406                	sd	ra,40(sp)
    800028ec:	f022                	sd	s0,32(sp)
    800028ee:	ec26                	sd	s1,24(sp)
    800028f0:	e84a                	sd	s2,16(sp)
    800028f2:	e44e                	sd	s3,8(sp)
    800028f4:	e052                	sd	s4,0(sp)
    800028f6:	1800                	addi	s0,sp,48
    800028f8:	89aa                	mv	s3,a0
    800028fa:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028fc:	00014517          	auipc	a0,0x14
    80002900:	54c50513          	addi	a0,a0,1356 # 80016e48 <itable>
    80002904:	00004097          	auipc	ra,0x4
    80002908:	910080e7          	jalr	-1776(ra) # 80006214 <acquire>
  empty = 0;
    8000290c:	4901                	li	s2,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    8000290e:	00014497          	auipc	s1,0x14
    80002912:	55248493          	addi	s1,s1,1362 # 80016e60 <itable+0x18>
    80002916:	00016697          	auipc	a3,0x16
    8000291a:	fda68693          	addi	a3,a3,-38 # 800188f0 <log>
    8000291e:	a039                	j	8000292c <iget+0x44>
    if (empty == 0 && ip->ref == 0)  // Remember empty slot.
    80002920:	02090b63          	beqz	s2,80002956 <iget+0x6e>
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80002924:	08848493          	addi	s1,s1,136
    80002928:	02d48a63          	beq	s1,a3,8000295c <iget+0x74>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    8000292c:	449c                	lw	a5,8(s1)
    8000292e:	fef059e3          	blez	a5,80002920 <iget+0x38>
    80002932:	4098                	lw	a4,0(s1)
    80002934:	ff3716e3          	bne	a4,s3,80002920 <iget+0x38>
    80002938:	40d8                	lw	a4,4(s1)
    8000293a:	ff4713e3          	bne	a4,s4,80002920 <iget+0x38>
      ip->ref++;
    8000293e:	2785                	addiw	a5,a5,1
    80002940:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002942:	00014517          	auipc	a0,0x14
    80002946:	50650513          	addi	a0,a0,1286 # 80016e48 <itable>
    8000294a:	00004097          	auipc	ra,0x4
    8000294e:	97e080e7          	jalr	-1666(ra) # 800062c8 <release>
      return ip;
    80002952:	8926                	mv	s2,s1
    80002954:	a03d                	j	80002982 <iget+0x9a>
    if (empty == 0 && ip->ref == 0)  // Remember empty slot.
    80002956:	f7f9                	bnez	a5,80002924 <iget+0x3c>
    80002958:	8926                	mv	s2,s1
    8000295a:	b7e9                	j	80002924 <iget+0x3c>
  if (empty == 0) panic("iget: no inodes");
    8000295c:	02090c63          	beqz	s2,80002994 <iget+0xac>
  ip->dev = dev;
    80002960:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002964:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002968:	4785                	li	a5,1
    8000296a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000296e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002972:	00014517          	auipc	a0,0x14
    80002976:	4d650513          	addi	a0,a0,1238 # 80016e48 <itable>
    8000297a:	00004097          	auipc	ra,0x4
    8000297e:	94e080e7          	jalr	-1714(ra) # 800062c8 <release>
}
    80002982:	854a                	mv	a0,s2
    80002984:	70a2                	ld	ra,40(sp)
    80002986:	7402                	ld	s0,32(sp)
    80002988:	64e2                	ld	s1,24(sp)
    8000298a:	6942                	ld	s2,16(sp)
    8000298c:	69a2                	ld	s3,8(sp)
    8000298e:	6a02                	ld	s4,0(sp)
    80002990:	6145                	addi	sp,sp,48
    80002992:	8082                	ret
  if (empty == 0) panic("iget: no inodes");
    80002994:	00006517          	auipc	a0,0x6
    80002998:	b8c50513          	addi	a0,a0,-1140 # 80008520 <syscalls+0x140>
    8000299c:	00003097          	auipc	ra,0x3
    800029a0:	340080e7          	jalr	832(ra) # 80005cdc <panic>

00000000800029a4 <fsinit>:
void fsinit(int dev) {
    800029a4:	7179                	addi	sp,sp,-48
    800029a6:	f406                	sd	ra,40(sp)
    800029a8:	f022                	sd	s0,32(sp)
    800029aa:	ec26                	sd	s1,24(sp)
    800029ac:	e84a                	sd	s2,16(sp)
    800029ae:	e44e                	sd	s3,8(sp)
    800029b0:	1800                	addi	s0,sp,48
    800029b2:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800029b4:	4585                	li	a1,1
    800029b6:	00000097          	auipc	ra,0x0
    800029ba:	a54080e7          	jalr	-1452(ra) # 8000240a <bread>
    800029be:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800029c0:	00014997          	auipc	s3,0x14
    800029c4:	46898993          	addi	s3,s3,1128 # 80016e28 <sb>
    800029c8:	02000613          	li	a2,32
    800029cc:	05850593          	addi	a1,a0,88
    800029d0:	854e                	mv	a0,s3
    800029d2:	ffffe097          	auipc	ra,0xffffe
    800029d6:	804080e7          	jalr	-2044(ra) # 800001d6 <memmove>
  brelse(bp);
    800029da:	8526                	mv	a0,s1
    800029dc:	00000097          	auipc	ra,0x0
    800029e0:	b5e080e7          	jalr	-1186(ra) # 8000253a <brelse>
  if (sb.magic != FSMAGIC) panic("invalid file system");
    800029e4:	0009a703          	lw	a4,0(s3)
    800029e8:	102037b7          	lui	a5,0x10203
    800029ec:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029f0:	02f71263          	bne	a4,a5,80002a14 <fsinit+0x70>
  initlog(dev, &sb);
    800029f4:	00014597          	auipc	a1,0x14
    800029f8:	43458593          	addi	a1,a1,1076 # 80016e28 <sb>
    800029fc:	854a                	mv	a0,s2
    800029fe:	00001097          	auipc	ra,0x1
    80002a02:	b4a080e7          	jalr	-1206(ra) # 80003548 <initlog>
}
    80002a06:	70a2                	ld	ra,40(sp)
    80002a08:	7402                	ld	s0,32(sp)
    80002a0a:	64e2                	ld	s1,24(sp)
    80002a0c:	6942                	ld	s2,16(sp)
    80002a0e:	69a2                	ld	s3,8(sp)
    80002a10:	6145                	addi	sp,sp,48
    80002a12:	8082                	ret
  if (sb.magic != FSMAGIC) panic("invalid file system");
    80002a14:	00006517          	auipc	a0,0x6
    80002a18:	b1c50513          	addi	a0,a0,-1252 # 80008530 <syscalls+0x150>
    80002a1c:	00003097          	auipc	ra,0x3
    80002a20:	2c0080e7          	jalr	704(ra) # 80005cdc <panic>

0000000080002a24 <iinit>:
void iinit() {
    80002a24:	7179                	addi	sp,sp,-48
    80002a26:	f406                	sd	ra,40(sp)
    80002a28:	f022                	sd	s0,32(sp)
    80002a2a:	ec26                	sd	s1,24(sp)
    80002a2c:	e84a                	sd	s2,16(sp)
    80002a2e:	e44e                	sd	s3,8(sp)
    80002a30:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a32:	00006597          	auipc	a1,0x6
    80002a36:	b1658593          	addi	a1,a1,-1258 # 80008548 <syscalls+0x168>
    80002a3a:	00014517          	auipc	a0,0x14
    80002a3e:	40e50513          	addi	a0,a0,1038 # 80016e48 <itable>
    80002a42:	00003097          	auipc	ra,0x3
    80002a46:	742080e7          	jalr	1858(ra) # 80006184 <initlock>
  for (i = 0; i < NINODE; i++) {
    80002a4a:	00014497          	auipc	s1,0x14
    80002a4e:	42648493          	addi	s1,s1,1062 # 80016e70 <itable+0x28>
    80002a52:	00016997          	auipc	s3,0x16
    80002a56:	eae98993          	addi	s3,s3,-338 # 80018900 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a5a:	00006917          	auipc	s2,0x6
    80002a5e:	af690913          	addi	s2,s2,-1290 # 80008550 <syscalls+0x170>
    80002a62:	85ca                	mv	a1,s2
    80002a64:	8526                	mv	a0,s1
    80002a66:	00001097          	auipc	ra,0x1
    80002a6a:	e42080e7          	jalr	-446(ra) # 800038a8 <initsleeplock>
  for (i = 0; i < NINODE; i++) {
    80002a6e:	08848493          	addi	s1,s1,136
    80002a72:	ff3498e3          	bne	s1,s3,80002a62 <iinit+0x3e>
}
    80002a76:	70a2                	ld	ra,40(sp)
    80002a78:	7402                	ld	s0,32(sp)
    80002a7a:	64e2                	ld	s1,24(sp)
    80002a7c:	6942                	ld	s2,16(sp)
    80002a7e:	69a2                	ld	s3,8(sp)
    80002a80:	6145                	addi	sp,sp,48
    80002a82:	8082                	ret

0000000080002a84 <ialloc>:
struct inode *ialloc(uint dev, short type) {
    80002a84:	715d                	addi	sp,sp,-80
    80002a86:	e486                	sd	ra,72(sp)
    80002a88:	e0a2                	sd	s0,64(sp)
    80002a8a:	fc26                	sd	s1,56(sp)
    80002a8c:	f84a                	sd	s2,48(sp)
    80002a8e:	f44e                	sd	s3,40(sp)
    80002a90:	f052                	sd	s4,32(sp)
    80002a92:	ec56                	sd	s5,24(sp)
    80002a94:	e85a                	sd	s6,16(sp)
    80002a96:	e45e                	sd	s7,8(sp)
    80002a98:	0880                	addi	s0,sp,80
  for (inum = 1; inum < sb.ninodes; inum++) {
    80002a9a:	00014717          	auipc	a4,0x14
    80002a9e:	39a72703          	lw	a4,922(a4) # 80016e34 <sb+0xc>
    80002aa2:	4785                	li	a5,1
    80002aa4:	04e7fa63          	bgeu	a5,a4,80002af8 <ialloc+0x74>
    80002aa8:	8aaa                	mv	s5,a0
    80002aaa:	8bae                	mv	s7,a1
    80002aac:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002aae:	00014a17          	auipc	s4,0x14
    80002ab2:	37aa0a13          	addi	s4,s4,890 # 80016e28 <sb>
    80002ab6:	00048b1b          	sext.w	s6,s1
    80002aba:	0044d593          	srli	a1,s1,0x4
    80002abe:	018a2783          	lw	a5,24(s4)
    80002ac2:	9dbd                	addw	a1,a1,a5
    80002ac4:	8556                	mv	a0,s5
    80002ac6:	00000097          	auipc	ra,0x0
    80002aca:	944080e7          	jalr	-1724(ra) # 8000240a <bread>
    80002ace:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    80002ad0:	05850993          	addi	s3,a0,88
    80002ad4:	00f4f793          	andi	a5,s1,15
    80002ad8:	079a                	slli	a5,a5,0x6
    80002ada:	99be                	add	s3,s3,a5
    if (dip->type == 0) {  // a free inode
    80002adc:	00099783          	lh	a5,0(s3)
    80002ae0:	c3a1                	beqz	a5,80002b20 <ialloc+0x9c>
    brelse(bp);
    80002ae2:	00000097          	auipc	ra,0x0
    80002ae6:	a58080e7          	jalr	-1448(ra) # 8000253a <brelse>
  for (inum = 1; inum < sb.ninodes; inum++) {
    80002aea:	0485                	addi	s1,s1,1
    80002aec:	00ca2703          	lw	a4,12(s4)
    80002af0:	0004879b          	sext.w	a5,s1
    80002af4:	fce7e1e3          	bltu	a5,a4,80002ab6 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002af8:	00006517          	auipc	a0,0x6
    80002afc:	a6050513          	addi	a0,a0,-1440 # 80008558 <syscalls+0x178>
    80002b00:	00003097          	auipc	ra,0x3
    80002b04:	226080e7          	jalr	550(ra) # 80005d26 <printf>
  return 0;
    80002b08:	4501                	li	a0,0
}
    80002b0a:	60a6                	ld	ra,72(sp)
    80002b0c:	6406                	ld	s0,64(sp)
    80002b0e:	74e2                	ld	s1,56(sp)
    80002b10:	7942                	ld	s2,48(sp)
    80002b12:	79a2                	ld	s3,40(sp)
    80002b14:	7a02                	ld	s4,32(sp)
    80002b16:	6ae2                	ld	s5,24(sp)
    80002b18:	6b42                	ld	s6,16(sp)
    80002b1a:	6ba2                	ld	s7,8(sp)
    80002b1c:	6161                	addi	sp,sp,80
    80002b1e:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002b20:	04000613          	li	a2,64
    80002b24:	4581                	li	a1,0
    80002b26:	854e                	mv	a0,s3
    80002b28:	ffffd097          	auipc	ra,0xffffd
    80002b2c:	652080e7          	jalr	1618(ra) # 8000017a <memset>
      dip->type = type;
    80002b30:	01799023          	sh	s7,0(s3)
      log_write(bp);  // mark it allocated on the disk
    80002b34:	854a                	mv	a0,s2
    80002b36:	00001097          	auipc	ra,0x1
    80002b3a:	c8e080e7          	jalr	-882(ra) # 800037c4 <log_write>
      brelse(bp);
    80002b3e:	854a                	mv	a0,s2
    80002b40:	00000097          	auipc	ra,0x0
    80002b44:	9fa080e7          	jalr	-1542(ra) # 8000253a <brelse>
      return iget(dev, inum);
    80002b48:	85da                	mv	a1,s6
    80002b4a:	8556                	mv	a0,s5
    80002b4c:	00000097          	auipc	ra,0x0
    80002b50:	d9c080e7          	jalr	-612(ra) # 800028e8 <iget>
    80002b54:	bf5d                	j	80002b0a <ialloc+0x86>

0000000080002b56 <iupdate>:
void iupdate(struct inode *ip) {
    80002b56:	1101                	addi	sp,sp,-32
    80002b58:	ec06                	sd	ra,24(sp)
    80002b5a:	e822                	sd	s0,16(sp)
    80002b5c:	e426                	sd	s1,8(sp)
    80002b5e:	e04a                	sd	s2,0(sp)
    80002b60:	1000                	addi	s0,sp,32
    80002b62:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b64:	415c                	lw	a5,4(a0)
    80002b66:	0047d79b          	srliw	a5,a5,0x4
    80002b6a:	00014597          	auipc	a1,0x14
    80002b6e:	2d65a583          	lw	a1,726(a1) # 80016e40 <sb+0x18>
    80002b72:	9dbd                	addw	a1,a1,a5
    80002b74:	4108                	lw	a0,0(a0)
    80002b76:	00000097          	auipc	ra,0x0
    80002b7a:	894080e7          	jalr	-1900(ra) # 8000240a <bread>
    80002b7e:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002b80:	05850793          	addi	a5,a0,88
    80002b84:	40d8                	lw	a4,4(s1)
    80002b86:	8b3d                	andi	a4,a4,15
    80002b88:	071a                	slli	a4,a4,0x6
    80002b8a:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b8c:	04449703          	lh	a4,68(s1)
    80002b90:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b94:	04649703          	lh	a4,70(s1)
    80002b98:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002b9c:	04849703          	lh	a4,72(s1)
    80002ba0:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002ba4:	04a49703          	lh	a4,74(s1)
    80002ba8:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002bac:	44f8                	lw	a4,76(s1)
    80002bae:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002bb0:	03400613          	li	a2,52
    80002bb4:	05048593          	addi	a1,s1,80
    80002bb8:	00c78513          	addi	a0,a5,12
    80002bbc:	ffffd097          	auipc	ra,0xffffd
    80002bc0:	61a080e7          	jalr	1562(ra) # 800001d6 <memmove>
  log_write(bp);
    80002bc4:	854a                	mv	a0,s2
    80002bc6:	00001097          	auipc	ra,0x1
    80002bca:	bfe080e7          	jalr	-1026(ra) # 800037c4 <log_write>
  brelse(bp);
    80002bce:	854a                	mv	a0,s2
    80002bd0:	00000097          	auipc	ra,0x0
    80002bd4:	96a080e7          	jalr	-1686(ra) # 8000253a <brelse>
}
    80002bd8:	60e2                	ld	ra,24(sp)
    80002bda:	6442                	ld	s0,16(sp)
    80002bdc:	64a2                	ld	s1,8(sp)
    80002bde:	6902                	ld	s2,0(sp)
    80002be0:	6105                	addi	sp,sp,32
    80002be2:	8082                	ret

0000000080002be4 <idup>:
struct inode *idup(struct inode *ip) {
    80002be4:	1101                	addi	sp,sp,-32
    80002be6:	ec06                	sd	ra,24(sp)
    80002be8:	e822                	sd	s0,16(sp)
    80002bea:	e426                	sd	s1,8(sp)
    80002bec:	1000                	addi	s0,sp,32
    80002bee:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002bf0:	00014517          	auipc	a0,0x14
    80002bf4:	25850513          	addi	a0,a0,600 # 80016e48 <itable>
    80002bf8:	00003097          	auipc	ra,0x3
    80002bfc:	61c080e7          	jalr	1564(ra) # 80006214 <acquire>
  ip->ref++;
    80002c00:	449c                	lw	a5,8(s1)
    80002c02:	2785                	addiw	a5,a5,1
    80002c04:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c06:	00014517          	auipc	a0,0x14
    80002c0a:	24250513          	addi	a0,a0,578 # 80016e48 <itable>
    80002c0e:	00003097          	auipc	ra,0x3
    80002c12:	6ba080e7          	jalr	1722(ra) # 800062c8 <release>
}
    80002c16:	8526                	mv	a0,s1
    80002c18:	60e2                	ld	ra,24(sp)
    80002c1a:	6442                	ld	s0,16(sp)
    80002c1c:	64a2                	ld	s1,8(sp)
    80002c1e:	6105                	addi	sp,sp,32
    80002c20:	8082                	ret

0000000080002c22 <ilock>:
void ilock(struct inode *ip) {
    80002c22:	1101                	addi	sp,sp,-32
    80002c24:	ec06                	sd	ra,24(sp)
    80002c26:	e822                	sd	s0,16(sp)
    80002c28:	e426                	sd	s1,8(sp)
    80002c2a:	e04a                	sd	s2,0(sp)
    80002c2c:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1) panic("ilock");
    80002c2e:	c115                	beqz	a0,80002c52 <ilock+0x30>
    80002c30:	84aa                	mv	s1,a0
    80002c32:	451c                	lw	a5,8(a0)
    80002c34:	00f05f63          	blez	a5,80002c52 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c38:	0541                	addi	a0,a0,16
    80002c3a:	00001097          	auipc	ra,0x1
    80002c3e:	ca8080e7          	jalr	-856(ra) # 800038e2 <acquiresleep>
  if (ip->valid == 0) {
    80002c42:	40bc                	lw	a5,64(s1)
    80002c44:	cf99                	beqz	a5,80002c62 <ilock+0x40>
}
    80002c46:	60e2                	ld	ra,24(sp)
    80002c48:	6442                	ld	s0,16(sp)
    80002c4a:	64a2                	ld	s1,8(sp)
    80002c4c:	6902                	ld	s2,0(sp)
    80002c4e:	6105                	addi	sp,sp,32
    80002c50:	8082                	ret
  if (ip == 0 || ip->ref < 1) panic("ilock");
    80002c52:	00006517          	auipc	a0,0x6
    80002c56:	91e50513          	addi	a0,a0,-1762 # 80008570 <syscalls+0x190>
    80002c5a:	00003097          	auipc	ra,0x3
    80002c5e:	082080e7          	jalr	130(ra) # 80005cdc <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c62:	40dc                	lw	a5,4(s1)
    80002c64:	0047d79b          	srliw	a5,a5,0x4
    80002c68:	00014597          	auipc	a1,0x14
    80002c6c:	1d85a583          	lw	a1,472(a1) # 80016e40 <sb+0x18>
    80002c70:	9dbd                	addw	a1,a1,a5
    80002c72:	4088                	lw	a0,0(s1)
    80002c74:	fffff097          	auipc	ra,0xfffff
    80002c78:	796080e7          	jalr	1942(ra) # 8000240a <bread>
    80002c7c:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002c7e:	05850593          	addi	a1,a0,88
    80002c82:	40dc                	lw	a5,4(s1)
    80002c84:	8bbd                	andi	a5,a5,15
    80002c86:	079a                	slli	a5,a5,0x6
    80002c88:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c8a:	00059783          	lh	a5,0(a1)
    80002c8e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c92:	00259783          	lh	a5,2(a1)
    80002c96:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c9a:	00459783          	lh	a5,4(a1)
    80002c9e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002ca2:	00659783          	lh	a5,6(a1)
    80002ca6:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002caa:	459c                	lw	a5,8(a1)
    80002cac:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002cae:	03400613          	li	a2,52
    80002cb2:	05b1                	addi	a1,a1,12
    80002cb4:	05048513          	addi	a0,s1,80
    80002cb8:	ffffd097          	auipc	ra,0xffffd
    80002cbc:	51e080e7          	jalr	1310(ra) # 800001d6 <memmove>
    brelse(bp);
    80002cc0:	854a                	mv	a0,s2
    80002cc2:	00000097          	auipc	ra,0x0
    80002cc6:	878080e7          	jalr	-1928(ra) # 8000253a <brelse>
    ip->valid = 1;
    80002cca:	4785                	li	a5,1
    80002ccc:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0) panic("ilock: no type");
    80002cce:	04449783          	lh	a5,68(s1)
    80002cd2:	fbb5                	bnez	a5,80002c46 <ilock+0x24>
    80002cd4:	00006517          	auipc	a0,0x6
    80002cd8:	8a450513          	addi	a0,a0,-1884 # 80008578 <syscalls+0x198>
    80002cdc:	00003097          	auipc	ra,0x3
    80002ce0:	000080e7          	jalr	ra # 80005cdc <panic>

0000000080002ce4 <iunlock>:
void iunlock(struct inode *ip) {
    80002ce4:	1101                	addi	sp,sp,-32
    80002ce6:	ec06                	sd	ra,24(sp)
    80002ce8:	e822                	sd	s0,16(sp)
    80002cea:	e426                	sd	s1,8(sp)
    80002cec:	e04a                	sd	s2,0(sp)
    80002cee:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) panic("iunlock");
    80002cf0:	c905                	beqz	a0,80002d20 <iunlock+0x3c>
    80002cf2:	84aa                	mv	s1,a0
    80002cf4:	01050913          	addi	s2,a0,16
    80002cf8:	854a                	mv	a0,s2
    80002cfa:	00001097          	auipc	ra,0x1
    80002cfe:	c82080e7          	jalr	-894(ra) # 8000397c <holdingsleep>
    80002d02:	cd19                	beqz	a0,80002d20 <iunlock+0x3c>
    80002d04:	449c                	lw	a5,8(s1)
    80002d06:	00f05d63          	blez	a5,80002d20 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d0a:	854a                	mv	a0,s2
    80002d0c:	00001097          	auipc	ra,0x1
    80002d10:	c2c080e7          	jalr	-980(ra) # 80003938 <releasesleep>
}
    80002d14:	60e2                	ld	ra,24(sp)
    80002d16:	6442                	ld	s0,16(sp)
    80002d18:	64a2                	ld	s1,8(sp)
    80002d1a:	6902                	ld	s2,0(sp)
    80002d1c:	6105                	addi	sp,sp,32
    80002d1e:	8082                	ret
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) panic("iunlock");
    80002d20:	00006517          	auipc	a0,0x6
    80002d24:	86850513          	addi	a0,a0,-1944 # 80008588 <syscalls+0x1a8>
    80002d28:	00003097          	auipc	ra,0x3
    80002d2c:	fb4080e7          	jalr	-76(ra) # 80005cdc <panic>

0000000080002d30 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void itrunc(struct inode *ip) {
    80002d30:	7179                	addi	sp,sp,-48
    80002d32:	f406                	sd	ra,40(sp)
    80002d34:	f022                	sd	s0,32(sp)
    80002d36:	ec26                	sd	s1,24(sp)
    80002d38:	e84a                	sd	s2,16(sp)
    80002d3a:	e44e                	sd	s3,8(sp)
    80002d3c:	e052                	sd	s4,0(sp)
    80002d3e:	1800                	addi	s0,sp,48
    80002d40:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++) {
    80002d42:	05050493          	addi	s1,a0,80
    80002d46:	08050913          	addi	s2,a0,128
    80002d4a:	a021                	j	80002d52 <itrunc+0x22>
    80002d4c:	0491                	addi	s1,s1,4
    80002d4e:	01248d63          	beq	s1,s2,80002d68 <itrunc+0x38>
    if (ip->addrs[i]) {
    80002d52:	408c                	lw	a1,0(s1)
    80002d54:	dde5                	beqz	a1,80002d4c <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d56:	0009a503          	lw	a0,0(s3)
    80002d5a:	00000097          	auipc	ra,0x0
    80002d5e:	8f6080e7          	jalr	-1802(ra) # 80002650 <bfree>
      ip->addrs[i] = 0;
    80002d62:	0004a023          	sw	zero,0(s1)
    80002d66:	b7dd                	j	80002d4c <itrunc+0x1c>
    }
  }

  if (ip->addrs[NDIRECT]) {
    80002d68:	0809a583          	lw	a1,128(s3)
    80002d6c:	e185                	bnez	a1,80002d8c <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d6e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d72:	854e                	mv	a0,s3
    80002d74:	00000097          	auipc	ra,0x0
    80002d78:	de2080e7          	jalr	-542(ra) # 80002b56 <iupdate>
}
    80002d7c:	70a2                	ld	ra,40(sp)
    80002d7e:	7402                	ld	s0,32(sp)
    80002d80:	64e2                	ld	s1,24(sp)
    80002d82:	6942                	ld	s2,16(sp)
    80002d84:	69a2                	ld	s3,8(sp)
    80002d86:	6a02                	ld	s4,0(sp)
    80002d88:	6145                	addi	sp,sp,48
    80002d8a:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d8c:	0009a503          	lw	a0,0(s3)
    80002d90:	fffff097          	auipc	ra,0xfffff
    80002d94:	67a080e7          	jalr	1658(ra) # 8000240a <bread>
    80002d98:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++) {
    80002d9a:	05850493          	addi	s1,a0,88
    80002d9e:	45850913          	addi	s2,a0,1112
    80002da2:	a021                	j	80002daa <itrunc+0x7a>
    80002da4:	0491                	addi	s1,s1,4
    80002da6:	01248b63          	beq	s1,s2,80002dbc <itrunc+0x8c>
      if (a[j]) bfree(ip->dev, a[j]);
    80002daa:	408c                	lw	a1,0(s1)
    80002dac:	dde5                	beqz	a1,80002da4 <itrunc+0x74>
    80002dae:	0009a503          	lw	a0,0(s3)
    80002db2:	00000097          	auipc	ra,0x0
    80002db6:	89e080e7          	jalr	-1890(ra) # 80002650 <bfree>
    80002dba:	b7ed                	j	80002da4 <itrunc+0x74>
    brelse(bp);
    80002dbc:	8552                	mv	a0,s4
    80002dbe:	fffff097          	auipc	ra,0xfffff
    80002dc2:	77c080e7          	jalr	1916(ra) # 8000253a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002dc6:	0809a583          	lw	a1,128(s3)
    80002dca:	0009a503          	lw	a0,0(s3)
    80002dce:	00000097          	auipc	ra,0x0
    80002dd2:	882080e7          	jalr	-1918(ra) # 80002650 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002dd6:	0809a023          	sw	zero,128(s3)
    80002dda:	bf51                	j	80002d6e <itrunc+0x3e>

0000000080002ddc <iput>:
void iput(struct inode *ip) {
    80002ddc:	1101                	addi	sp,sp,-32
    80002dde:	ec06                	sd	ra,24(sp)
    80002de0:	e822                	sd	s0,16(sp)
    80002de2:	e426                	sd	s1,8(sp)
    80002de4:	e04a                	sd	s2,0(sp)
    80002de6:	1000                	addi	s0,sp,32
    80002de8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dea:	00014517          	auipc	a0,0x14
    80002dee:	05e50513          	addi	a0,a0,94 # 80016e48 <itable>
    80002df2:	00003097          	auipc	ra,0x3
    80002df6:	422080e7          	jalr	1058(ra) # 80006214 <acquire>
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80002dfa:	4498                	lw	a4,8(s1)
    80002dfc:	4785                	li	a5,1
    80002dfe:	02f70363          	beq	a4,a5,80002e24 <iput+0x48>
  ip->ref--;
    80002e02:	449c                	lw	a5,8(s1)
    80002e04:	37fd                	addiw	a5,a5,-1
    80002e06:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e08:	00014517          	auipc	a0,0x14
    80002e0c:	04050513          	addi	a0,a0,64 # 80016e48 <itable>
    80002e10:	00003097          	auipc	ra,0x3
    80002e14:	4b8080e7          	jalr	1208(ra) # 800062c8 <release>
}
    80002e18:	60e2                	ld	ra,24(sp)
    80002e1a:	6442                	ld	s0,16(sp)
    80002e1c:	64a2                	ld	s1,8(sp)
    80002e1e:	6902                	ld	s2,0(sp)
    80002e20:	6105                	addi	sp,sp,32
    80002e22:	8082                	ret
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80002e24:	40bc                	lw	a5,64(s1)
    80002e26:	dff1                	beqz	a5,80002e02 <iput+0x26>
    80002e28:	04a49783          	lh	a5,74(s1)
    80002e2c:	fbf9                	bnez	a5,80002e02 <iput+0x26>
    acquiresleep(&ip->lock);
    80002e2e:	01048913          	addi	s2,s1,16
    80002e32:	854a                	mv	a0,s2
    80002e34:	00001097          	auipc	ra,0x1
    80002e38:	aae080e7          	jalr	-1362(ra) # 800038e2 <acquiresleep>
    release(&itable.lock);
    80002e3c:	00014517          	auipc	a0,0x14
    80002e40:	00c50513          	addi	a0,a0,12 # 80016e48 <itable>
    80002e44:	00003097          	auipc	ra,0x3
    80002e48:	484080e7          	jalr	1156(ra) # 800062c8 <release>
    itrunc(ip);
    80002e4c:	8526                	mv	a0,s1
    80002e4e:	00000097          	auipc	ra,0x0
    80002e52:	ee2080e7          	jalr	-286(ra) # 80002d30 <itrunc>
    ip->type = 0;
    80002e56:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e5a:	8526                	mv	a0,s1
    80002e5c:	00000097          	auipc	ra,0x0
    80002e60:	cfa080e7          	jalr	-774(ra) # 80002b56 <iupdate>
    ip->valid = 0;
    80002e64:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e68:	854a                	mv	a0,s2
    80002e6a:	00001097          	auipc	ra,0x1
    80002e6e:	ace080e7          	jalr	-1330(ra) # 80003938 <releasesleep>
    acquire(&itable.lock);
    80002e72:	00014517          	auipc	a0,0x14
    80002e76:	fd650513          	addi	a0,a0,-42 # 80016e48 <itable>
    80002e7a:	00003097          	auipc	ra,0x3
    80002e7e:	39a080e7          	jalr	922(ra) # 80006214 <acquire>
    80002e82:	b741                	j	80002e02 <iput+0x26>

0000000080002e84 <iunlockput>:
void iunlockput(struct inode *ip) {
    80002e84:	1101                	addi	sp,sp,-32
    80002e86:	ec06                	sd	ra,24(sp)
    80002e88:	e822                	sd	s0,16(sp)
    80002e8a:	e426                	sd	s1,8(sp)
    80002e8c:	1000                	addi	s0,sp,32
    80002e8e:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e90:	00000097          	auipc	ra,0x0
    80002e94:	e54080e7          	jalr	-428(ra) # 80002ce4 <iunlock>
  iput(ip);
    80002e98:	8526                	mv	a0,s1
    80002e9a:	00000097          	auipc	ra,0x0
    80002e9e:	f42080e7          	jalr	-190(ra) # 80002ddc <iput>
}
    80002ea2:	60e2                	ld	ra,24(sp)
    80002ea4:	6442                	ld	s0,16(sp)
    80002ea6:	64a2                	ld	s1,8(sp)
    80002ea8:	6105                	addi	sp,sp,32
    80002eaa:	8082                	ret

0000000080002eac <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st) {
    80002eac:	1141                	addi	sp,sp,-16
    80002eae:	e422                	sd	s0,8(sp)
    80002eb0:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002eb2:	411c                	lw	a5,0(a0)
    80002eb4:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002eb6:	415c                	lw	a5,4(a0)
    80002eb8:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002eba:	04451783          	lh	a5,68(a0)
    80002ebe:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002ec2:	04a51783          	lh	a5,74(a0)
    80002ec6:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002eca:	04c56783          	lwu	a5,76(a0)
    80002ece:	e99c                	sd	a5,16(a1)
}
    80002ed0:	6422                	ld	s0,8(sp)
    80002ed2:	0141                	addi	sp,sp,16
    80002ed4:	8082                	ret

0000000080002ed6 <readi>:
// otherwise, dst is a kernel address.
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n) {
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off) return 0;
    80002ed6:	457c                	lw	a5,76(a0)
    80002ed8:	0ed7e963          	bltu	a5,a3,80002fca <readi+0xf4>
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n) {
    80002edc:	7159                	addi	sp,sp,-112
    80002ede:	f486                	sd	ra,104(sp)
    80002ee0:	f0a2                	sd	s0,96(sp)
    80002ee2:	eca6                	sd	s1,88(sp)
    80002ee4:	e8ca                	sd	s2,80(sp)
    80002ee6:	e4ce                	sd	s3,72(sp)
    80002ee8:	e0d2                	sd	s4,64(sp)
    80002eea:	fc56                	sd	s5,56(sp)
    80002eec:	f85a                	sd	s6,48(sp)
    80002eee:	f45e                	sd	s7,40(sp)
    80002ef0:	f062                	sd	s8,32(sp)
    80002ef2:	ec66                	sd	s9,24(sp)
    80002ef4:	e86a                	sd	s10,16(sp)
    80002ef6:	e46e                	sd	s11,8(sp)
    80002ef8:	1880                	addi	s0,sp,112
    80002efa:	8b2a                	mv	s6,a0
    80002efc:	8bae                	mv	s7,a1
    80002efe:	8a32                	mv	s4,a2
    80002f00:	84b6                	mv	s1,a3
    80002f02:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off) return 0;
    80002f04:	9f35                	addw	a4,a4,a3
    80002f06:	4501                	li	a0,0
    80002f08:	0ad76063          	bltu	a4,a3,80002fa8 <readi+0xd2>
  if (off + n > ip->size) n = ip->size - off;
    80002f0c:	00e7f463          	bgeu	a5,a4,80002f14 <readi+0x3e>
    80002f10:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80002f14:	0a0a8963          	beqz	s5,80002fc6 <readi+0xf0>
    80002f18:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0) break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80002f1a:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f1e:	5c7d                	li	s8,-1
    80002f20:	a82d                	j	80002f5a <readi+0x84>
    80002f22:	020d1d93          	slli	s11,s10,0x20
    80002f26:	020ddd93          	srli	s11,s11,0x20
    80002f2a:	05890613          	addi	a2,s2,88
    80002f2e:	86ee                	mv	a3,s11
    80002f30:	963a                	add	a2,a2,a4
    80002f32:	85d2                	mv	a1,s4
    80002f34:	855e                	mv	a0,s7
    80002f36:	fffff097          	auipc	ra,0xfffff
    80002f3a:	9ce080e7          	jalr	-1586(ra) # 80001904 <either_copyout>
    80002f3e:	05850d63          	beq	a0,s8,80002f98 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f42:	854a                	mv	a0,s2
    80002f44:	fffff097          	auipc	ra,0xfffff
    80002f48:	5f6080e7          	jalr	1526(ra) # 8000253a <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80002f4c:	013d09bb          	addw	s3,s10,s3
    80002f50:	009d04bb          	addw	s1,s10,s1
    80002f54:	9a6e                	add	s4,s4,s11
    80002f56:	0559f763          	bgeu	s3,s5,80002fa4 <readi+0xce>
    uint addr = bmap(ip, off / BSIZE);
    80002f5a:	00a4d59b          	srliw	a1,s1,0xa
    80002f5e:	855a                	mv	a0,s6
    80002f60:	00000097          	auipc	ra,0x0
    80002f64:	89e080e7          	jalr	-1890(ra) # 800027fe <bmap>
    80002f68:	0005059b          	sext.w	a1,a0
    if (addr == 0) break;
    80002f6c:	cd85                	beqz	a1,80002fa4 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002f6e:	000b2503          	lw	a0,0(s6)
    80002f72:	fffff097          	auipc	ra,0xfffff
    80002f76:	498080e7          	jalr	1176(ra) # 8000240a <bread>
    80002f7a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80002f7c:	3ff4f713          	andi	a4,s1,1023
    80002f80:	40ec87bb          	subw	a5,s9,a4
    80002f84:	413a86bb          	subw	a3,s5,s3
    80002f88:	8d3e                	mv	s10,a5
    80002f8a:	2781                	sext.w	a5,a5
    80002f8c:	0006861b          	sext.w	a2,a3
    80002f90:	f8f679e3          	bgeu	a2,a5,80002f22 <readi+0x4c>
    80002f94:	8d36                	mv	s10,a3
    80002f96:	b771                	j	80002f22 <readi+0x4c>
      brelse(bp);
    80002f98:	854a                	mv	a0,s2
    80002f9a:	fffff097          	auipc	ra,0xfffff
    80002f9e:	5a0080e7          	jalr	1440(ra) # 8000253a <brelse>
      tot = -1;
    80002fa2:	59fd                	li	s3,-1
  }
  return tot;
    80002fa4:	0009851b          	sext.w	a0,s3
}
    80002fa8:	70a6                	ld	ra,104(sp)
    80002faa:	7406                	ld	s0,96(sp)
    80002fac:	64e6                	ld	s1,88(sp)
    80002fae:	6946                	ld	s2,80(sp)
    80002fb0:	69a6                	ld	s3,72(sp)
    80002fb2:	6a06                	ld	s4,64(sp)
    80002fb4:	7ae2                	ld	s5,56(sp)
    80002fb6:	7b42                	ld	s6,48(sp)
    80002fb8:	7ba2                	ld	s7,40(sp)
    80002fba:	7c02                	ld	s8,32(sp)
    80002fbc:	6ce2                	ld	s9,24(sp)
    80002fbe:	6d42                	ld	s10,16(sp)
    80002fc0:	6da2                	ld	s11,8(sp)
    80002fc2:	6165                	addi	sp,sp,112
    80002fc4:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80002fc6:	89d6                	mv	s3,s5
    80002fc8:	bff1                	j	80002fa4 <readi+0xce>
  if (off > ip->size || off + n < off) return 0;
    80002fca:	4501                	li	a0,0
}
    80002fcc:	8082                	ret

0000000080002fce <writei>:
// there was an error of some kind.
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n) {
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off) return -1;
    80002fce:	457c                	lw	a5,76(a0)
    80002fd0:	10d7e863          	bltu	a5,a3,800030e0 <writei+0x112>
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n) {
    80002fd4:	7159                	addi	sp,sp,-112
    80002fd6:	f486                	sd	ra,104(sp)
    80002fd8:	f0a2                	sd	s0,96(sp)
    80002fda:	eca6                	sd	s1,88(sp)
    80002fdc:	e8ca                	sd	s2,80(sp)
    80002fde:	e4ce                	sd	s3,72(sp)
    80002fe0:	e0d2                	sd	s4,64(sp)
    80002fe2:	fc56                	sd	s5,56(sp)
    80002fe4:	f85a                	sd	s6,48(sp)
    80002fe6:	f45e                	sd	s7,40(sp)
    80002fe8:	f062                	sd	s8,32(sp)
    80002fea:	ec66                	sd	s9,24(sp)
    80002fec:	e86a                	sd	s10,16(sp)
    80002fee:	e46e                	sd	s11,8(sp)
    80002ff0:	1880                	addi	s0,sp,112
    80002ff2:	8aaa                	mv	s5,a0
    80002ff4:	8bae                	mv	s7,a1
    80002ff6:	8a32                	mv	s4,a2
    80002ff8:	8936                	mv	s2,a3
    80002ffa:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off) return -1;
    80002ffc:	00e687bb          	addw	a5,a3,a4
    80003000:	0ed7e263          	bltu	a5,a3,800030e4 <writei+0x116>
  if (off + n > MAXFILE * BSIZE) return -1;
    80003004:	00043737          	lui	a4,0x43
    80003008:	0ef76063          	bltu	a4,a5,800030e8 <writei+0x11a>

  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    8000300c:	0c0b0863          	beqz	s6,800030dc <writei+0x10e>
    80003010:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0) break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80003012:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003016:	5c7d                	li	s8,-1
    80003018:	a091                	j	8000305c <writei+0x8e>
    8000301a:	020d1d93          	slli	s11,s10,0x20
    8000301e:	020ddd93          	srli	s11,s11,0x20
    80003022:	05848513          	addi	a0,s1,88
    80003026:	86ee                	mv	a3,s11
    80003028:	8652                	mv	a2,s4
    8000302a:	85de                	mv	a1,s7
    8000302c:	953a                	add	a0,a0,a4
    8000302e:	fffff097          	auipc	ra,0xfffff
    80003032:	92c080e7          	jalr	-1748(ra) # 8000195a <either_copyin>
    80003036:	07850263          	beq	a0,s8,8000309a <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000303a:	8526                	mv	a0,s1
    8000303c:	00000097          	auipc	ra,0x0
    80003040:	788080e7          	jalr	1928(ra) # 800037c4 <log_write>
    brelse(bp);
    80003044:	8526                	mv	a0,s1
    80003046:	fffff097          	auipc	ra,0xfffff
    8000304a:	4f4080e7          	jalr	1268(ra) # 8000253a <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    8000304e:	013d09bb          	addw	s3,s10,s3
    80003052:	012d093b          	addw	s2,s10,s2
    80003056:	9a6e                	add	s4,s4,s11
    80003058:	0569f663          	bgeu	s3,s6,800030a4 <writei+0xd6>
    uint addr = bmap(ip, off / BSIZE);
    8000305c:	00a9559b          	srliw	a1,s2,0xa
    80003060:	8556                	mv	a0,s5
    80003062:	fffff097          	auipc	ra,0xfffff
    80003066:	79c080e7          	jalr	1948(ra) # 800027fe <bmap>
    8000306a:	0005059b          	sext.w	a1,a0
    if (addr == 0) break;
    8000306e:	c99d                	beqz	a1,800030a4 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003070:	000aa503          	lw	a0,0(s5)
    80003074:	fffff097          	auipc	ra,0xfffff
    80003078:	396080e7          	jalr	918(ra) # 8000240a <bread>
    8000307c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    8000307e:	3ff97713          	andi	a4,s2,1023
    80003082:	40ec87bb          	subw	a5,s9,a4
    80003086:	413b06bb          	subw	a3,s6,s3
    8000308a:	8d3e                	mv	s10,a5
    8000308c:	2781                	sext.w	a5,a5
    8000308e:	0006861b          	sext.w	a2,a3
    80003092:	f8f674e3          	bgeu	a2,a5,8000301a <writei+0x4c>
    80003096:	8d36                	mv	s10,a3
    80003098:	b749                	j	8000301a <writei+0x4c>
      brelse(bp);
    8000309a:	8526                	mv	a0,s1
    8000309c:	fffff097          	auipc	ra,0xfffff
    800030a0:	49e080e7          	jalr	1182(ra) # 8000253a <brelse>
  }

  if (off > ip->size) ip->size = off;
    800030a4:	04caa783          	lw	a5,76(s5)
    800030a8:	0127f463          	bgeu	a5,s2,800030b0 <writei+0xe2>
    800030ac:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800030b0:	8556                	mv	a0,s5
    800030b2:	00000097          	auipc	ra,0x0
    800030b6:	aa4080e7          	jalr	-1372(ra) # 80002b56 <iupdate>

  return tot;
    800030ba:	0009851b          	sext.w	a0,s3
}
    800030be:	70a6                	ld	ra,104(sp)
    800030c0:	7406                	ld	s0,96(sp)
    800030c2:	64e6                	ld	s1,88(sp)
    800030c4:	6946                	ld	s2,80(sp)
    800030c6:	69a6                	ld	s3,72(sp)
    800030c8:	6a06                	ld	s4,64(sp)
    800030ca:	7ae2                	ld	s5,56(sp)
    800030cc:	7b42                	ld	s6,48(sp)
    800030ce:	7ba2                	ld	s7,40(sp)
    800030d0:	7c02                	ld	s8,32(sp)
    800030d2:	6ce2                	ld	s9,24(sp)
    800030d4:	6d42                	ld	s10,16(sp)
    800030d6:	6da2                	ld	s11,8(sp)
    800030d8:	6165                	addi	sp,sp,112
    800030da:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    800030dc:	89da                	mv	s3,s6
    800030de:	bfc9                	j	800030b0 <writei+0xe2>
  if (off > ip->size || off + n < off) return -1;
    800030e0:	557d                	li	a0,-1
}
    800030e2:	8082                	ret
  if (off > ip->size || off + n < off) return -1;
    800030e4:	557d                	li	a0,-1
    800030e6:	bfe1                	j	800030be <writei+0xf0>
  if (off + n > MAXFILE * BSIZE) return -1;
    800030e8:	557d                	li	a0,-1
    800030ea:	bfd1                	j	800030be <writei+0xf0>

00000000800030ec <namecmp>:

// Directories

int namecmp(const char *s, const char *t) { return strncmp(s, t, DIRSIZ); }
    800030ec:	1141                	addi	sp,sp,-16
    800030ee:	e406                	sd	ra,8(sp)
    800030f0:	e022                	sd	s0,0(sp)
    800030f2:	0800                	addi	s0,sp,16
    800030f4:	4639                	li	a2,14
    800030f6:	ffffd097          	auipc	ra,0xffffd
    800030fa:	154080e7          	jalr	340(ra) # 8000024a <strncmp>
    800030fe:	60a2                	ld	ra,8(sp)
    80003100:	6402                	ld	s0,0(sp)
    80003102:	0141                	addi	sp,sp,16
    80003104:	8082                	ret

0000000080003106 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *dirlookup(struct inode *dp, char *name, uint *poff) {
    80003106:	7139                	addi	sp,sp,-64
    80003108:	fc06                	sd	ra,56(sp)
    8000310a:	f822                	sd	s0,48(sp)
    8000310c:	f426                	sd	s1,40(sp)
    8000310e:	f04a                	sd	s2,32(sp)
    80003110:	ec4e                	sd	s3,24(sp)
    80003112:	e852                	sd	s4,16(sp)
    80003114:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR) panic("dirlookup not DIR");
    80003116:	04451703          	lh	a4,68(a0)
    8000311a:	4785                	li	a5,1
    8000311c:	00f71a63          	bne	a4,a5,80003130 <dirlookup+0x2a>
    80003120:	892a                	mv	s2,a0
    80003122:	89ae                	mv	s3,a1
    80003124:	8a32                	mv	s4,a2

  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003126:	457c                	lw	a5,76(a0)
    80003128:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000312a:	4501                	li	a0,0
  for (off = 0; off < dp->size; off += sizeof(de)) {
    8000312c:	e79d                	bnez	a5,8000315a <dirlookup+0x54>
    8000312e:	a8a5                	j	800031a6 <dirlookup+0xa0>
  if (dp->type != T_DIR) panic("dirlookup not DIR");
    80003130:	00005517          	auipc	a0,0x5
    80003134:	46050513          	addi	a0,a0,1120 # 80008590 <syscalls+0x1b0>
    80003138:	00003097          	auipc	ra,0x3
    8000313c:	ba4080e7          	jalr	-1116(ra) # 80005cdc <panic>
      panic("dirlookup read");
    80003140:	00005517          	auipc	a0,0x5
    80003144:	46850513          	addi	a0,a0,1128 # 800085a8 <syscalls+0x1c8>
    80003148:	00003097          	auipc	ra,0x3
    8000314c:	b94080e7          	jalr	-1132(ra) # 80005cdc <panic>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003150:	24c1                	addiw	s1,s1,16
    80003152:	04c92783          	lw	a5,76(s2)
    80003156:	04f4f763          	bgeu	s1,a5,800031a4 <dirlookup+0x9e>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000315a:	4741                	li	a4,16
    8000315c:	86a6                	mv	a3,s1
    8000315e:	fc040613          	addi	a2,s0,-64
    80003162:	4581                	li	a1,0
    80003164:	854a                	mv	a0,s2
    80003166:	00000097          	auipc	ra,0x0
    8000316a:	d70080e7          	jalr	-656(ra) # 80002ed6 <readi>
    8000316e:	47c1                	li	a5,16
    80003170:	fcf518e3          	bne	a0,a5,80003140 <dirlookup+0x3a>
    if (de.inum == 0) continue;
    80003174:	fc045783          	lhu	a5,-64(s0)
    80003178:	dfe1                	beqz	a5,80003150 <dirlookup+0x4a>
    if (namecmp(name, de.name) == 0) {
    8000317a:	fc240593          	addi	a1,s0,-62
    8000317e:	854e                	mv	a0,s3
    80003180:	00000097          	auipc	ra,0x0
    80003184:	f6c080e7          	jalr	-148(ra) # 800030ec <namecmp>
    80003188:	f561                	bnez	a0,80003150 <dirlookup+0x4a>
      if (poff) *poff = off;
    8000318a:	000a0463          	beqz	s4,80003192 <dirlookup+0x8c>
    8000318e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003192:	fc045583          	lhu	a1,-64(s0)
    80003196:	00092503          	lw	a0,0(s2)
    8000319a:	fffff097          	auipc	ra,0xfffff
    8000319e:	74e080e7          	jalr	1870(ra) # 800028e8 <iget>
    800031a2:	a011                	j	800031a6 <dirlookup+0xa0>
  return 0;
    800031a4:	4501                	li	a0,0
}
    800031a6:	70e2                	ld	ra,56(sp)
    800031a8:	7442                	ld	s0,48(sp)
    800031aa:	74a2                	ld	s1,40(sp)
    800031ac:	7902                	ld	s2,32(sp)
    800031ae:	69e2                	ld	s3,24(sp)
    800031b0:	6a42                	ld	s4,16(sp)
    800031b2:	6121                	addi	sp,sp,64
    800031b4:	8082                	ret

00000000800031b6 <namex>:

// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *namex(char *path, int nameiparent, char *name) {
    800031b6:	711d                	addi	sp,sp,-96
    800031b8:	ec86                	sd	ra,88(sp)
    800031ba:	e8a2                	sd	s0,80(sp)
    800031bc:	e4a6                	sd	s1,72(sp)
    800031be:	e0ca                	sd	s2,64(sp)
    800031c0:	fc4e                	sd	s3,56(sp)
    800031c2:	f852                	sd	s4,48(sp)
    800031c4:	f456                	sd	s5,40(sp)
    800031c6:	f05a                	sd	s6,32(sp)
    800031c8:	ec5e                	sd	s7,24(sp)
    800031ca:	e862                	sd	s8,16(sp)
    800031cc:	e466                	sd	s9,8(sp)
    800031ce:	e06a                	sd	s10,0(sp)
    800031d0:	1080                	addi	s0,sp,96
    800031d2:	84aa                	mv	s1,a0
    800031d4:	8b2e                	mv	s6,a1
    800031d6:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if (*path == '/')
    800031d8:	00054703          	lbu	a4,0(a0)
    800031dc:	02f00793          	li	a5,47
    800031e0:	02f70363          	beq	a4,a5,80003206 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031e4:	ffffe097          	auipc	ra,0xffffe
    800031e8:	c70080e7          	jalr	-912(ra) # 80000e54 <myproc>
    800031ec:	15053503          	ld	a0,336(a0)
    800031f0:	00000097          	auipc	ra,0x0
    800031f4:	9f4080e7          	jalr	-1548(ra) # 80002be4 <idup>
    800031f8:	8a2a                	mv	s4,a0
  while (*path == '/') path++;
    800031fa:	02f00913          	li	s2,47
  if (len >= DIRSIZ)
    800031fe:	4cb5                	li	s9,13
  len = path - s;
    80003200:	4b81                	li	s7,0

  while ((path = skipelem(path, name)) != 0) {
    ilock(ip);
    if (ip->type != T_DIR) {
    80003202:	4c05                	li	s8,1
    80003204:	a87d                	j	800032c2 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80003206:	4585                	li	a1,1
    80003208:	4505                	li	a0,1
    8000320a:	fffff097          	auipc	ra,0xfffff
    8000320e:	6de080e7          	jalr	1758(ra) # 800028e8 <iget>
    80003212:	8a2a                	mv	s4,a0
    80003214:	b7dd                	j	800031fa <namex+0x44>
      iunlockput(ip);
    80003216:	8552                	mv	a0,s4
    80003218:	00000097          	auipc	ra,0x0
    8000321c:	c6c080e7          	jalr	-916(ra) # 80002e84 <iunlockput>
      return 0;
    80003220:	4a01                	li	s4,0
  if (nameiparent) {
    iput(ip);
    return 0;
  }
  return ip;
}
    80003222:	8552                	mv	a0,s4
    80003224:	60e6                	ld	ra,88(sp)
    80003226:	6446                	ld	s0,80(sp)
    80003228:	64a6                	ld	s1,72(sp)
    8000322a:	6906                	ld	s2,64(sp)
    8000322c:	79e2                	ld	s3,56(sp)
    8000322e:	7a42                	ld	s4,48(sp)
    80003230:	7aa2                	ld	s5,40(sp)
    80003232:	7b02                	ld	s6,32(sp)
    80003234:	6be2                	ld	s7,24(sp)
    80003236:	6c42                	ld	s8,16(sp)
    80003238:	6ca2                	ld	s9,8(sp)
    8000323a:	6d02                	ld	s10,0(sp)
    8000323c:	6125                	addi	sp,sp,96
    8000323e:	8082                	ret
      iunlock(ip);
    80003240:	8552                	mv	a0,s4
    80003242:	00000097          	auipc	ra,0x0
    80003246:	aa2080e7          	jalr	-1374(ra) # 80002ce4 <iunlock>
      return ip;
    8000324a:	bfe1                	j	80003222 <namex+0x6c>
      iunlockput(ip);
    8000324c:	8552                	mv	a0,s4
    8000324e:	00000097          	auipc	ra,0x0
    80003252:	c36080e7          	jalr	-970(ra) # 80002e84 <iunlockput>
      return 0;
    80003256:	8a4e                	mv	s4,s3
    80003258:	b7e9                	j	80003222 <namex+0x6c>
  len = path - s;
    8000325a:	40998633          	sub	a2,s3,s1
    8000325e:	00060d1b          	sext.w	s10,a2
  if (len >= DIRSIZ)
    80003262:	09acd863          	bge	s9,s10,800032f2 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003266:	4639                	li	a2,14
    80003268:	85a6                	mv	a1,s1
    8000326a:	8556                	mv	a0,s5
    8000326c:	ffffd097          	auipc	ra,0xffffd
    80003270:	f6a080e7          	jalr	-150(ra) # 800001d6 <memmove>
    80003274:	84ce                	mv	s1,s3
  while (*path == '/') path++;
    80003276:	0004c783          	lbu	a5,0(s1)
    8000327a:	01279763          	bne	a5,s2,80003288 <namex+0xd2>
    8000327e:	0485                	addi	s1,s1,1
    80003280:	0004c783          	lbu	a5,0(s1)
    80003284:	ff278de3          	beq	a5,s2,8000327e <namex+0xc8>
    ilock(ip);
    80003288:	8552                	mv	a0,s4
    8000328a:	00000097          	auipc	ra,0x0
    8000328e:	998080e7          	jalr	-1640(ra) # 80002c22 <ilock>
    if (ip->type != T_DIR) {
    80003292:	044a1783          	lh	a5,68(s4)
    80003296:	f98790e3          	bne	a5,s8,80003216 <namex+0x60>
    if (nameiparent && *path == '\0') {
    8000329a:	000b0563          	beqz	s6,800032a4 <namex+0xee>
    8000329e:	0004c783          	lbu	a5,0(s1)
    800032a2:	dfd9                	beqz	a5,80003240 <namex+0x8a>
    if ((next = dirlookup(ip, name, 0)) == 0) {
    800032a4:	865e                	mv	a2,s7
    800032a6:	85d6                	mv	a1,s5
    800032a8:	8552                	mv	a0,s4
    800032aa:	00000097          	auipc	ra,0x0
    800032ae:	e5c080e7          	jalr	-420(ra) # 80003106 <dirlookup>
    800032b2:	89aa                	mv	s3,a0
    800032b4:	dd41                	beqz	a0,8000324c <namex+0x96>
    iunlockput(ip);
    800032b6:	8552                	mv	a0,s4
    800032b8:	00000097          	auipc	ra,0x0
    800032bc:	bcc080e7          	jalr	-1076(ra) # 80002e84 <iunlockput>
    ip = next;
    800032c0:	8a4e                	mv	s4,s3
  while (*path == '/') path++;
    800032c2:	0004c783          	lbu	a5,0(s1)
    800032c6:	01279763          	bne	a5,s2,800032d4 <namex+0x11e>
    800032ca:	0485                	addi	s1,s1,1
    800032cc:	0004c783          	lbu	a5,0(s1)
    800032d0:	ff278de3          	beq	a5,s2,800032ca <namex+0x114>
  if (*path == 0) return 0;
    800032d4:	cb9d                	beqz	a5,8000330a <namex+0x154>
  while (*path != '/' && *path != 0) path++;
    800032d6:	0004c783          	lbu	a5,0(s1)
    800032da:	89a6                	mv	s3,s1
  len = path - s;
    800032dc:	8d5e                	mv	s10,s7
    800032de:	865e                	mv	a2,s7
  while (*path != '/' && *path != 0) path++;
    800032e0:	01278963          	beq	a5,s2,800032f2 <namex+0x13c>
    800032e4:	dbbd                	beqz	a5,8000325a <namex+0xa4>
    800032e6:	0985                	addi	s3,s3,1
    800032e8:	0009c783          	lbu	a5,0(s3)
    800032ec:	ff279ce3          	bne	a5,s2,800032e4 <namex+0x12e>
    800032f0:	b7ad                	j	8000325a <namex+0xa4>
    memmove(name, s, len);
    800032f2:	2601                	sext.w	a2,a2
    800032f4:	85a6                	mv	a1,s1
    800032f6:	8556                	mv	a0,s5
    800032f8:	ffffd097          	auipc	ra,0xffffd
    800032fc:	ede080e7          	jalr	-290(ra) # 800001d6 <memmove>
    name[len] = 0;
    80003300:	9d56                	add	s10,s10,s5
    80003302:	000d0023          	sb	zero,0(s10)
    80003306:	84ce                	mv	s1,s3
    80003308:	b7bd                	j	80003276 <namex+0xc0>
  if (nameiparent) {
    8000330a:	f00b0ce3          	beqz	s6,80003222 <namex+0x6c>
    iput(ip);
    8000330e:	8552                	mv	a0,s4
    80003310:	00000097          	auipc	ra,0x0
    80003314:	acc080e7          	jalr	-1332(ra) # 80002ddc <iput>
    return 0;
    80003318:	4a01                	li	s4,0
    8000331a:	b721                	j	80003222 <namex+0x6c>

000000008000331c <dirlink>:
int dirlink(struct inode *dp, char *name, uint inum) {
    8000331c:	7139                	addi	sp,sp,-64
    8000331e:	fc06                	sd	ra,56(sp)
    80003320:	f822                	sd	s0,48(sp)
    80003322:	f426                	sd	s1,40(sp)
    80003324:	f04a                	sd	s2,32(sp)
    80003326:	ec4e                	sd	s3,24(sp)
    80003328:	e852                	sd	s4,16(sp)
    8000332a:	0080                	addi	s0,sp,64
    8000332c:	892a                	mv	s2,a0
    8000332e:	8a2e                	mv	s4,a1
    80003330:	89b2                	mv	s3,a2
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80003332:	4601                	li	a2,0
    80003334:	00000097          	auipc	ra,0x0
    80003338:	dd2080e7          	jalr	-558(ra) # 80003106 <dirlookup>
    8000333c:	e93d                	bnez	a0,800033b2 <dirlink+0x96>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    8000333e:	04c92483          	lw	s1,76(s2)
    80003342:	c49d                	beqz	s1,80003370 <dirlink+0x54>
    80003344:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003346:	4741                	li	a4,16
    80003348:	86a6                	mv	a3,s1
    8000334a:	fc040613          	addi	a2,s0,-64
    8000334e:	4581                	li	a1,0
    80003350:	854a                	mv	a0,s2
    80003352:	00000097          	auipc	ra,0x0
    80003356:	b84080e7          	jalr	-1148(ra) # 80002ed6 <readi>
    8000335a:	47c1                	li	a5,16
    8000335c:	06f51163          	bne	a0,a5,800033be <dirlink+0xa2>
    if (de.inum == 0) break;
    80003360:	fc045783          	lhu	a5,-64(s0)
    80003364:	c791                	beqz	a5,80003370 <dirlink+0x54>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003366:	24c1                	addiw	s1,s1,16
    80003368:	04c92783          	lw	a5,76(s2)
    8000336c:	fcf4ede3          	bltu	s1,a5,80003346 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003370:	4639                	li	a2,14
    80003372:	85d2                	mv	a1,s4
    80003374:	fc240513          	addi	a0,s0,-62
    80003378:	ffffd097          	auipc	ra,0xffffd
    8000337c:	f0e080e7          	jalr	-242(ra) # 80000286 <strncpy>
  de.inum = inum;
    80003380:	fd341023          	sh	s3,-64(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de)) return -1;
    80003384:	4741                	li	a4,16
    80003386:	86a6                	mv	a3,s1
    80003388:	fc040613          	addi	a2,s0,-64
    8000338c:	4581                	li	a1,0
    8000338e:	854a                	mv	a0,s2
    80003390:	00000097          	auipc	ra,0x0
    80003394:	c3e080e7          	jalr	-962(ra) # 80002fce <writei>
    80003398:	1541                	addi	a0,a0,-16
    8000339a:	00a03533          	snez	a0,a0
    8000339e:	40a00533          	neg	a0,a0
}
    800033a2:	70e2                	ld	ra,56(sp)
    800033a4:	7442                	ld	s0,48(sp)
    800033a6:	74a2                	ld	s1,40(sp)
    800033a8:	7902                	ld	s2,32(sp)
    800033aa:	69e2                	ld	s3,24(sp)
    800033ac:	6a42                	ld	s4,16(sp)
    800033ae:	6121                	addi	sp,sp,64
    800033b0:	8082                	ret
    iput(ip);
    800033b2:	00000097          	auipc	ra,0x0
    800033b6:	a2a080e7          	jalr	-1494(ra) # 80002ddc <iput>
    return -1;
    800033ba:	557d                	li	a0,-1
    800033bc:	b7dd                	j	800033a2 <dirlink+0x86>
      panic("dirlink read");
    800033be:	00005517          	auipc	a0,0x5
    800033c2:	1fa50513          	addi	a0,a0,506 # 800085b8 <syscalls+0x1d8>
    800033c6:	00003097          	auipc	ra,0x3
    800033ca:	916080e7          	jalr	-1770(ra) # 80005cdc <panic>

00000000800033ce <namei>:

struct inode *namei(char *path) {
    800033ce:	1101                	addi	sp,sp,-32
    800033d0:	ec06                	sd	ra,24(sp)
    800033d2:	e822                	sd	s0,16(sp)
    800033d4:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033d6:	fe040613          	addi	a2,s0,-32
    800033da:	4581                	li	a1,0
    800033dc:	00000097          	auipc	ra,0x0
    800033e0:	dda080e7          	jalr	-550(ra) # 800031b6 <namex>
}
    800033e4:	60e2                	ld	ra,24(sp)
    800033e6:	6442                	ld	s0,16(sp)
    800033e8:	6105                	addi	sp,sp,32
    800033ea:	8082                	ret

00000000800033ec <nameiparent>:

struct inode *nameiparent(char *path, char *name) {
    800033ec:	1141                	addi	sp,sp,-16
    800033ee:	e406                	sd	ra,8(sp)
    800033f0:	e022                	sd	s0,0(sp)
    800033f2:	0800                	addi	s0,sp,16
    800033f4:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033f6:	4585                	li	a1,1
    800033f8:	00000097          	auipc	ra,0x0
    800033fc:	dbe080e7          	jalr	-578(ra) # 800031b6 <namex>
}
    80003400:	60a2                	ld	ra,8(sp)
    80003402:	6402                	ld	s0,0(sp)
    80003404:	0141                	addi	sp,sp,16
    80003406:	8082                	ret

0000000080003408 <write_head>:
}

// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void write_head(void) {
    80003408:	1101                	addi	sp,sp,-32
    8000340a:	ec06                	sd	ra,24(sp)
    8000340c:	e822                	sd	s0,16(sp)
    8000340e:	e426                	sd	s1,8(sp)
    80003410:	e04a                	sd	s2,0(sp)
    80003412:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003414:	00015917          	auipc	s2,0x15
    80003418:	4dc90913          	addi	s2,s2,1244 # 800188f0 <log>
    8000341c:	01892583          	lw	a1,24(s2)
    80003420:	02892503          	lw	a0,40(s2)
    80003424:	fffff097          	auipc	ra,0xfffff
    80003428:	fe6080e7          	jalr	-26(ra) # 8000240a <bread>
    8000342c:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *)(buf->data);
  int i;
  hb->n = log.lh.n;
    8000342e:	02c92683          	lw	a3,44(s2)
    80003432:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003434:	02d05863          	blez	a3,80003464 <write_head+0x5c>
    80003438:	00015797          	auipc	a5,0x15
    8000343c:	4e878793          	addi	a5,a5,1256 # 80018920 <log+0x30>
    80003440:	05c50713          	addi	a4,a0,92
    80003444:	36fd                	addiw	a3,a3,-1
    80003446:	02069613          	slli	a2,a3,0x20
    8000344a:	01e65693          	srli	a3,a2,0x1e
    8000344e:	00015617          	auipc	a2,0x15
    80003452:	4d660613          	addi	a2,a2,1238 # 80018924 <log+0x34>
    80003456:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003458:	4390                	lw	a2,0(a5)
    8000345a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000345c:	0791                	addi	a5,a5,4
    8000345e:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    80003460:	fed79ce3          	bne	a5,a3,80003458 <write_head+0x50>
  }
  bwrite(buf);
    80003464:	8526                	mv	a0,s1
    80003466:	fffff097          	auipc	ra,0xfffff
    8000346a:	096080e7          	jalr	150(ra) # 800024fc <bwrite>
  brelse(buf);
    8000346e:	8526                	mv	a0,s1
    80003470:	fffff097          	auipc	ra,0xfffff
    80003474:	0ca080e7          	jalr	202(ra) # 8000253a <brelse>
}
    80003478:	60e2                	ld	ra,24(sp)
    8000347a:	6442                	ld	s0,16(sp)
    8000347c:	64a2                	ld	s1,8(sp)
    8000347e:	6902                	ld	s2,0(sp)
    80003480:	6105                	addi	sp,sp,32
    80003482:	8082                	ret

0000000080003484 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003484:	00015797          	auipc	a5,0x15
    80003488:	4987a783          	lw	a5,1176(a5) # 8001891c <log+0x2c>
    8000348c:	0af05d63          	blez	a5,80003546 <install_trans+0xc2>
static void install_trans(int recovering) {
    80003490:	7139                	addi	sp,sp,-64
    80003492:	fc06                	sd	ra,56(sp)
    80003494:	f822                	sd	s0,48(sp)
    80003496:	f426                	sd	s1,40(sp)
    80003498:	f04a                	sd	s2,32(sp)
    8000349a:	ec4e                	sd	s3,24(sp)
    8000349c:	e852                	sd	s4,16(sp)
    8000349e:	e456                	sd	s5,8(sp)
    800034a0:	e05a                	sd	s6,0(sp)
    800034a2:	0080                	addi	s0,sp,64
    800034a4:	8b2a                	mv	s6,a0
    800034a6:	00015a97          	auipc	s5,0x15
    800034aa:	47aa8a93          	addi	s5,s5,1146 # 80018920 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034ae:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start + tail + 1);  // read log block
    800034b0:	00015997          	auipc	s3,0x15
    800034b4:	44098993          	addi	s3,s3,1088 # 800188f0 <log>
    800034b8:	a00d                	j	800034da <install_trans+0x56>
    brelse(lbuf);
    800034ba:	854a                	mv	a0,s2
    800034bc:	fffff097          	auipc	ra,0xfffff
    800034c0:	07e080e7          	jalr	126(ra) # 8000253a <brelse>
    brelse(dbuf);
    800034c4:	8526                	mv	a0,s1
    800034c6:	fffff097          	auipc	ra,0xfffff
    800034ca:	074080e7          	jalr	116(ra) # 8000253a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034ce:	2a05                	addiw	s4,s4,1
    800034d0:	0a91                	addi	s5,s5,4
    800034d2:	02c9a783          	lw	a5,44(s3)
    800034d6:	04fa5e63          	bge	s4,a5,80003532 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1);  // read log block
    800034da:	0189a583          	lw	a1,24(s3)
    800034de:	014585bb          	addw	a1,a1,s4
    800034e2:	2585                	addiw	a1,a1,1
    800034e4:	0289a503          	lw	a0,40(s3)
    800034e8:	fffff097          	auipc	ra,0xfffff
    800034ec:	f22080e7          	jalr	-222(ra) # 8000240a <bread>
    800034f0:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);    // read dst
    800034f2:	000aa583          	lw	a1,0(s5)
    800034f6:	0289a503          	lw	a0,40(s3)
    800034fa:	fffff097          	auipc	ra,0xfffff
    800034fe:	f10080e7          	jalr	-240(ra) # 8000240a <bread>
    80003502:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003504:	40000613          	li	a2,1024
    80003508:	05890593          	addi	a1,s2,88
    8000350c:	05850513          	addi	a0,a0,88
    80003510:	ffffd097          	auipc	ra,0xffffd
    80003514:	cc6080e7          	jalr	-826(ra) # 800001d6 <memmove>
    bwrite(dbuf);                            // write dst to disk
    80003518:	8526                	mv	a0,s1
    8000351a:	fffff097          	auipc	ra,0xfffff
    8000351e:	fe2080e7          	jalr	-30(ra) # 800024fc <bwrite>
    if (recovering == 0) bunpin(dbuf);
    80003522:	f80b1ce3          	bnez	s6,800034ba <install_trans+0x36>
    80003526:	8526                	mv	a0,s1
    80003528:	fffff097          	auipc	ra,0xfffff
    8000352c:	0ec080e7          	jalr	236(ra) # 80002614 <bunpin>
    80003530:	b769                	j	800034ba <install_trans+0x36>
}
    80003532:	70e2                	ld	ra,56(sp)
    80003534:	7442                	ld	s0,48(sp)
    80003536:	74a2                	ld	s1,40(sp)
    80003538:	7902                	ld	s2,32(sp)
    8000353a:	69e2                	ld	s3,24(sp)
    8000353c:	6a42                	ld	s4,16(sp)
    8000353e:	6aa2                	ld	s5,8(sp)
    80003540:	6b02                	ld	s6,0(sp)
    80003542:	6121                	addi	sp,sp,64
    80003544:	8082                	ret
    80003546:	8082                	ret

0000000080003548 <initlog>:
void initlog(int dev, struct superblock *sb) {
    80003548:	7179                	addi	sp,sp,-48
    8000354a:	f406                	sd	ra,40(sp)
    8000354c:	f022                	sd	s0,32(sp)
    8000354e:	ec26                	sd	s1,24(sp)
    80003550:	e84a                	sd	s2,16(sp)
    80003552:	e44e                	sd	s3,8(sp)
    80003554:	1800                	addi	s0,sp,48
    80003556:	892a                	mv	s2,a0
    80003558:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000355a:	00015497          	auipc	s1,0x15
    8000355e:	39648493          	addi	s1,s1,918 # 800188f0 <log>
    80003562:	00005597          	auipc	a1,0x5
    80003566:	06658593          	addi	a1,a1,102 # 800085c8 <syscalls+0x1e8>
    8000356a:	8526                	mv	a0,s1
    8000356c:	00003097          	auipc	ra,0x3
    80003570:	c18080e7          	jalr	-1000(ra) # 80006184 <initlock>
  log.start = sb->logstart;
    80003574:	0149a583          	lw	a1,20(s3)
    80003578:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000357a:	0109a783          	lw	a5,16(s3)
    8000357e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003580:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003584:	854a                	mv	a0,s2
    80003586:	fffff097          	auipc	ra,0xfffff
    8000358a:	e84080e7          	jalr	-380(ra) # 8000240a <bread>
  log.lh.n = lh->n;
    8000358e:	4d34                	lw	a3,88(a0)
    80003590:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003592:	02d05663          	blez	a3,800035be <initlog+0x76>
    80003596:	05c50793          	addi	a5,a0,92
    8000359a:	00015717          	auipc	a4,0x15
    8000359e:	38670713          	addi	a4,a4,902 # 80018920 <log+0x30>
    800035a2:	36fd                	addiw	a3,a3,-1
    800035a4:	02069613          	slli	a2,a3,0x20
    800035a8:	01e65693          	srli	a3,a2,0x1e
    800035ac:	06050613          	addi	a2,a0,96
    800035b0:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800035b2:	4390                	lw	a2,0(a5)
    800035b4:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035b6:	0791                	addi	a5,a5,4
    800035b8:	0711                	addi	a4,a4,4
    800035ba:	fed79ce3          	bne	a5,a3,800035b2 <initlog+0x6a>
  brelse(buf);
    800035be:	fffff097          	auipc	ra,0xfffff
    800035c2:	f7c080e7          	jalr	-132(ra) # 8000253a <brelse>

static void recover_from_log(void) {
  read_head();
  install_trans(1);  // if committed, copy from log to disk
    800035c6:	4505                	li	a0,1
    800035c8:	00000097          	auipc	ra,0x0
    800035cc:	ebc080e7          	jalr	-324(ra) # 80003484 <install_trans>
  log.lh.n = 0;
    800035d0:	00015797          	auipc	a5,0x15
    800035d4:	3407a623          	sw	zero,844(a5) # 8001891c <log+0x2c>
  write_head();  // clear the log
    800035d8:	00000097          	auipc	ra,0x0
    800035dc:	e30080e7          	jalr	-464(ra) # 80003408 <write_head>
}
    800035e0:	70a2                	ld	ra,40(sp)
    800035e2:	7402                	ld	s0,32(sp)
    800035e4:	64e2                	ld	s1,24(sp)
    800035e6:	6942                	ld	s2,16(sp)
    800035e8:	69a2                	ld	s3,8(sp)
    800035ea:	6145                	addi	sp,sp,48
    800035ec:	8082                	ret

00000000800035ee <begin_op>:
}

// called at the start of each FS system call.
void begin_op(void) {
    800035ee:	1101                	addi	sp,sp,-32
    800035f0:	ec06                	sd	ra,24(sp)
    800035f2:	e822                	sd	s0,16(sp)
    800035f4:	e426                	sd	s1,8(sp)
    800035f6:	e04a                	sd	s2,0(sp)
    800035f8:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035fa:	00015517          	auipc	a0,0x15
    800035fe:	2f650513          	addi	a0,a0,758 # 800188f0 <log>
    80003602:	00003097          	auipc	ra,0x3
    80003606:	c12080e7          	jalr	-1006(ra) # 80006214 <acquire>
  while (1) {
    if (log.committing) {
    8000360a:	00015497          	auipc	s1,0x15
    8000360e:	2e648493          	addi	s1,s1,742 # 800188f0 <log>
      sleep(&log, &log.lock);
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
    80003612:	4979                	li	s2,30
    80003614:	a039                	j	80003622 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003616:	85a6                	mv	a1,s1
    80003618:	8526                	mv	a0,s1
    8000361a:	ffffe097          	auipc	ra,0xffffe
    8000361e:	ee2080e7          	jalr	-286(ra) # 800014fc <sleep>
    if (log.committing) {
    80003622:	50dc                	lw	a5,36(s1)
    80003624:	fbed                	bnez	a5,80003616 <begin_op+0x28>
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
    80003626:	5098                	lw	a4,32(s1)
    80003628:	2705                	addiw	a4,a4,1
    8000362a:	0007069b          	sext.w	a3,a4
    8000362e:	0027179b          	slliw	a5,a4,0x2
    80003632:	9fb9                	addw	a5,a5,a4
    80003634:	0017979b          	slliw	a5,a5,0x1
    80003638:	54d8                	lw	a4,44(s1)
    8000363a:	9fb9                	addw	a5,a5,a4
    8000363c:	00f95963          	bge	s2,a5,8000364e <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003640:	85a6                	mv	a1,s1
    80003642:	8526                	mv	a0,s1
    80003644:	ffffe097          	auipc	ra,0xffffe
    80003648:	eb8080e7          	jalr	-328(ra) # 800014fc <sleep>
    8000364c:	bfd9                	j	80003622 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000364e:	00015517          	auipc	a0,0x15
    80003652:	2a250513          	addi	a0,a0,674 # 800188f0 <log>
    80003656:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003658:	00003097          	auipc	ra,0x3
    8000365c:	c70080e7          	jalr	-912(ra) # 800062c8 <release>
      break;
    }
  }
}
    80003660:	60e2                	ld	ra,24(sp)
    80003662:	6442                	ld	s0,16(sp)
    80003664:	64a2                	ld	s1,8(sp)
    80003666:	6902                	ld	s2,0(sp)
    80003668:	6105                	addi	sp,sp,32
    8000366a:	8082                	ret

000000008000366c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void end_op(void) {
    8000366c:	7139                	addi	sp,sp,-64
    8000366e:	fc06                	sd	ra,56(sp)
    80003670:	f822                	sd	s0,48(sp)
    80003672:	f426                	sd	s1,40(sp)
    80003674:	f04a                	sd	s2,32(sp)
    80003676:	ec4e                	sd	s3,24(sp)
    80003678:	e852                	sd	s4,16(sp)
    8000367a:	e456                	sd	s5,8(sp)
    8000367c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000367e:	00015497          	auipc	s1,0x15
    80003682:	27248493          	addi	s1,s1,626 # 800188f0 <log>
    80003686:	8526                	mv	a0,s1
    80003688:	00003097          	auipc	ra,0x3
    8000368c:	b8c080e7          	jalr	-1140(ra) # 80006214 <acquire>
  log.outstanding -= 1;
    80003690:	509c                	lw	a5,32(s1)
    80003692:	37fd                	addiw	a5,a5,-1
    80003694:	0007891b          	sext.w	s2,a5
    80003698:	d09c                	sw	a5,32(s1)
  if (log.committing) panic("log.committing");
    8000369a:	50dc                	lw	a5,36(s1)
    8000369c:	e7b9                	bnez	a5,800036ea <end_op+0x7e>
  if (log.outstanding == 0) {
    8000369e:	04091e63          	bnez	s2,800036fa <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800036a2:	00015497          	auipc	s1,0x15
    800036a6:	24e48493          	addi	s1,s1,590 # 800188f0 <log>
    800036aa:	4785                	li	a5,1
    800036ac:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800036ae:	8526                	mv	a0,s1
    800036b0:	00003097          	auipc	ra,0x3
    800036b4:	c18080e7          	jalr	-1000(ra) # 800062c8 <release>
    brelse(to);
  }
}

static void commit() {
  if (log.lh.n > 0) {
    800036b8:	54dc                	lw	a5,44(s1)
    800036ba:	06f04763          	bgtz	a5,80003728 <end_op+0xbc>
    acquire(&log.lock);
    800036be:	00015497          	auipc	s1,0x15
    800036c2:	23248493          	addi	s1,s1,562 # 800188f0 <log>
    800036c6:	8526                	mv	a0,s1
    800036c8:	00003097          	auipc	ra,0x3
    800036cc:	b4c080e7          	jalr	-1204(ra) # 80006214 <acquire>
    log.committing = 0;
    800036d0:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036d4:	8526                	mv	a0,s1
    800036d6:	ffffe097          	auipc	ra,0xffffe
    800036da:	e8a080e7          	jalr	-374(ra) # 80001560 <wakeup>
    release(&log.lock);
    800036de:	8526                	mv	a0,s1
    800036e0:	00003097          	auipc	ra,0x3
    800036e4:	be8080e7          	jalr	-1048(ra) # 800062c8 <release>
}
    800036e8:	a03d                	j	80003716 <end_op+0xaa>
  if (log.committing) panic("log.committing");
    800036ea:	00005517          	auipc	a0,0x5
    800036ee:	ee650513          	addi	a0,a0,-282 # 800085d0 <syscalls+0x1f0>
    800036f2:	00002097          	auipc	ra,0x2
    800036f6:	5ea080e7          	jalr	1514(ra) # 80005cdc <panic>
    wakeup(&log);
    800036fa:	00015497          	auipc	s1,0x15
    800036fe:	1f648493          	addi	s1,s1,502 # 800188f0 <log>
    80003702:	8526                	mv	a0,s1
    80003704:	ffffe097          	auipc	ra,0xffffe
    80003708:	e5c080e7          	jalr	-420(ra) # 80001560 <wakeup>
  release(&log.lock);
    8000370c:	8526                	mv	a0,s1
    8000370e:	00003097          	auipc	ra,0x3
    80003712:	bba080e7          	jalr	-1094(ra) # 800062c8 <release>
}
    80003716:	70e2                	ld	ra,56(sp)
    80003718:	7442                	ld	s0,48(sp)
    8000371a:	74a2                	ld	s1,40(sp)
    8000371c:	7902                	ld	s2,32(sp)
    8000371e:	69e2                	ld	s3,24(sp)
    80003720:	6a42                	ld	s4,16(sp)
    80003722:	6aa2                	ld	s5,8(sp)
    80003724:	6121                	addi	sp,sp,64
    80003726:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003728:	00015a97          	auipc	s5,0x15
    8000372c:	1f8a8a93          	addi	s5,s5,504 # 80018920 <log+0x30>
    struct buf *to = bread(log.dev, log.start + tail + 1);  // log block
    80003730:	00015a17          	auipc	s4,0x15
    80003734:	1c0a0a13          	addi	s4,s4,448 # 800188f0 <log>
    80003738:	018a2583          	lw	a1,24(s4)
    8000373c:	012585bb          	addw	a1,a1,s2
    80003740:	2585                	addiw	a1,a1,1
    80003742:	028a2503          	lw	a0,40(s4)
    80003746:	fffff097          	auipc	ra,0xfffff
    8000374a:	cc4080e7          	jalr	-828(ra) # 8000240a <bread>
    8000374e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]);  // cache block
    80003750:	000aa583          	lw	a1,0(s5)
    80003754:	028a2503          	lw	a0,40(s4)
    80003758:	fffff097          	auipc	ra,0xfffff
    8000375c:	cb2080e7          	jalr	-846(ra) # 8000240a <bread>
    80003760:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003762:	40000613          	li	a2,1024
    80003766:	05850593          	addi	a1,a0,88
    8000376a:	05848513          	addi	a0,s1,88
    8000376e:	ffffd097          	auipc	ra,0xffffd
    80003772:	a68080e7          	jalr	-1432(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003776:	8526                	mv	a0,s1
    80003778:	fffff097          	auipc	ra,0xfffff
    8000377c:	d84080e7          	jalr	-636(ra) # 800024fc <bwrite>
    brelse(from);
    80003780:	854e                	mv	a0,s3
    80003782:	fffff097          	auipc	ra,0xfffff
    80003786:	db8080e7          	jalr	-584(ra) # 8000253a <brelse>
    brelse(to);
    8000378a:	8526                	mv	a0,s1
    8000378c:	fffff097          	auipc	ra,0xfffff
    80003790:	dae080e7          	jalr	-594(ra) # 8000253a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003794:	2905                	addiw	s2,s2,1
    80003796:	0a91                	addi	s5,s5,4
    80003798:	02ca2783          	lw	a5,44(s4)
    8000379c:	f8f94ee3          	blt	s2,a5,80003738 <end_op+0xcc>
    write_log();       // Write modified blocks from cache to log
    write_head();      // Write header to disk -- the real commit
    800037a0:	00000097          	auipc	ra,0x0
    800037a4:	c68080e7          	jalr	-920(ra) # 80003408 <write_head>
    install_trans(0);  // Now install writes to home locations
    800037a8:	4501                	li	a0,0
    800037aa:	00000097          	auipc	ra,0x0
    800037ae:	cda080e7          	jalr	-806(ra) # 80003484 <install_trans>
    log.lh.n = 0;
    800037b2:	00015797          	auipc	a5,0x15
    800037b6:	1607a523          	sw	zero,362(a5) # 8001891c <log+0x2c>
    write_head();  // Erase the transaction from the log
    800037ba:	00000097          	auipc	ra,0x0
    800037be:	c4e080e7          	jalr	-946(ra) # 80003408 <write_head>
    800037c2:	bdf5                	j	800036be <end_op+0x52>

00000000800037c4 <log_write>:
// log_write() replaces bwrite(); a typical use is:
//   bp = bread(...)
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void log_write(struct buf *b) {
    800037c4:	1101                	addi	sp,sp,-32
    800037c6:	ec06                	sd	ra,24(sp)
    800037c8:	e822                	sd	s0,16(sp)
    800037ca:	e426                	sd	s1,8(sp)
    800037cc:	e04a                	sd	s2,0(sp)
    800037ce:	1000                	addi	s0,sp,32
    800037d0:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037d2:	00015917          	auipc	s2,0x15
    800037d6:	11e90913          	addi	s2,s2,286 # 800188f0 <log>
    800037da:	854a                	mv	a0,s2
    800037dc:	00003097          	auipc	ra,0x3
    800037e0:	a38080e7          	jalr	-1480(ra) # 80006214 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037e4:	02c92603          	lw	a2,44(s2)
    800037e8:	47f5                	li	a5,29
    800037ea:	06c7c563          	blt	a5,a2,80003854 <log_write+0x90>
    800037ee:	00015797          	auipc	a5,0x15
    800037f2:	11e7a783          	lw	a5,286(a5) # 8001890c <log+0x1c>
    800037f6:	37fd                	addiw	a5,a5,-1
    800037f8:	04f65e63          	bge	a2,a5,80003854 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1) panic("log_write outside of trans");
    800037fc:	00015797          	auipc	a5,0x15
    80003800:	1147a783          	lw	a5,276(a5) # 80018910 <log+0x20>
    80003804:	06f05063          	blez	a5,80003864 <log_write+0xa0>

  for (i = 0; i < log.lh.n; i++) {
    80003808:	4781                	li	a5,0
    8000380a:	06c05563          	blez	a2,80003874 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)  // log absorption
    8000380e:	44cc                	lw	a1,12(s1)
    80003810:	00015717          	auipc	a4,0x15
    80003814:	11070713          	addi	a4,a4,272 # 80018920 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003818:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)  // log absorption
    8000381a:	4314                	lw	a3,0(a4)
    8000381c:	04b68c63          	beq	a3,a1,80003874 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003820:	2785                	addiw	a5,a5,1
    80003822:	0711                	addi	a4,a4,4
    80003824:	fef61be3          	bne	a2,a5,8000381a <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003828:	0621                	addi	a2,a2,8
    8000382a:	060a                	slli	a2,a2,0x2
    8000382c:	00015797          	auipc	a5,0x15
    80003830:	0c478793          	addi	a5,a5,196 # 800188f0 <log>
    80003834:	97b2                	add	a5,a5,a2
    80003836:	44d8                	lw	a4,12(s1)
    80003838:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000383a:	8526                	mv	a0,s1
    8000383c:	fffff097          	auipc	ra,0xfffff
    80003840:	d9c080e7          	jalr	-612(ra) # 800025d8 <bpin>
    log.lh.n++;
    80003844:	00015717          	auipc	a4,0x15
    80003848:	0ac70713          	addi	a4,a4,172 # 800188f0 <log>
    8000384c:	575c                	lw	a5,44(a4)
    8000384e:	2785                	addiw	a5,a5,1
    80003850:	d75c                	sw	a5,44(a4)
    80003852:	a82d                	j	8000388c <log_write+0xc8>
    panic("too big a transaction");
    80003854:	00005517          	auipc	a0,0x5
    80003858:	d8c50513          	addi	a0,a0,-628 # 800085e0 <syscalls+0x200>
    8000385c:	00002097          	auipc	ra,0x2
    80003860:	480080e7          	jalr	1152(ra) # 80005cdc <panic>
  if (log.outstanding < 1) panic("log_write outside of trans");
    80003864:	00005517          	auipc	a0,0x5
    80003868:	d9450513          	addi	a0,a0,-620 # 800085f8 <syscalls+0x218>
    8000386c:	00002097          	auipc	ra,0x2
    80003870:	470080e7          	jalr	1136(ra) # 80005cdc <panic>
  log.lh.block[i] = b->blockno;
    80003874:	00878693          	addi	a3,a5,8
    80003878:	068a                	slli	a3,a3,0x2
    8000387a:	00015717          	auipc	a4,0x15
    8000387e:	07670713          	addi	a4,a4,118 # 800188f0 <log>
    80003882:	9736                	add	a4,a4,a3
    80003884:	44d4                	lw	a3,12(s1)
    80003886:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003888:	faf609e3          	beq	a2,a5,8000383a <log_write+0x76>
  }
  release(&log.lock);
    8000388c:	00015517          	auipc	a0,0x15
    80003890:	06450513          	addi	a0,a0,100 # 800188f0 <log>
    80003894:	00003097          	auipc	ra,0x3
    80003898:	a34080e7          	jalr	-1484(ra) # 800062c8 <release>
}
    8000389c:	60e2                	ld	ra,24(sp)
    8000389e:	6442                	ld	s0,16(sp)
    800038a0:	64a2                	ld	s1,8(sp)
    800038a2:	6902                	ld	s2,0(sp)
    800038a4:	6105                	addi	sp,sp,32
    800038a6:	8082                	ret

00000000800038a8 <initsleeplock>:
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "sleeplock.h"

void initsleeplock(struct sleeplock *lk, char *name) {
    800038a8:	1101                	addi	sp,sp,-32
    800038aa:	ec06                	sd	ra,24(sp)
    800038ac:	e822                	sd	s0,16(sp)
    800038ae:	e426                	sd	s1,8(sp)
    800038b0:	e04a                	sd	s2,0(sp)
    800038b2:	1000                	addi	s0,sp,32
    800038b4:	84aa                	mv	s1,a0
    800038b6:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800038b8:	00005597          	auipc	a1,0x5
    800038bc:	d6058593          	addi	a1,a1,-672 # 80008618 <syscalls+0x238>
    800038c0:	0521                	addi	a0,a0,8
    800038c2:	00003097          	auipc	ra,0x3
    800038c6:	8c2080e7          	jalr	-1854(ra) # 80006184 <initlock>
  lk->name = name;
    800038ca:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038ce:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038d2:	0204a423          	sw	zero,40(s1)
}
    800038d6:	60e2                	ld	ra,24(sp)
    800038d8:	6442                	ld	s0,16(sp)
    800038da:	64a2                	ld	s1,8(sp)
    800038dc:	6902                	ld	s2,0(sp)
    800038de:	6105                	addi	sp,sp,32
    800038e0:	8082                	ret

00000000800038e2 <acquiresleep>:

void acquiresleep(struct sleeplock *lk) {
    800038e2:	1101                	addi	sp,sp,-32
    800038e4:	ec06                	sd	ra,24(sp)
    800038e6:	e822                	sd	s0,16(sp)
    800038e8:	e426                	sd	s1,8(sp)
    800038ea:	e04a                	sd	s2,0(sp)
    800038ec:	1000                	addi	s0,sp,32
    800038ee:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038f0:	00850913          	addi	s2,a0,8
    800038f4:	854a                	mv	a0,s2
    800038f6:	00003097          	auipc	ra,0x3
    800038fa:	91e080e7          	jalr	-1762(ra) # 80006214 <acquire>
  while (lk->locked) {
    800038fe:	409c                	lw	a5,0(s1)
    80003900:	cb89                	beqz	a5,80003912 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003902:	85ca                	mv	a1,s2
    80003904:	8526                	mv	a0,s1
    80003906:	ffffe097          	auipc	ra,0xffffe
    8000390a:	bf6080e7          	jalr	-1034(ra) # 800014fc <sleep>
  while (lk->locked) {
    8000390e:	409c                	lw	a5,0(s1)
    80003910:	fbed                	bnez	a5,80003902 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003912:	4785                	li	a5,1
    80003914:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003916:	ffffd097          	auipc	ra,0xffffd
    8000391a:	53e080e7          	jalr	1342(ra) # 80000e54 <myproc>
    8000391e:	591c                	lw	a5,48(a0)
    80003920:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003922:	854a                	mv	a0,s2
    80003924:	00003097          	auipc	ra,0x3
    80003928:	9a4080e7          	jalr	-1628(ra) # 800062c8 <release>
}
    8000392c:	60e2                	ld	ra,24(sp)
    8000392e:	6442                	ld	s0,16(sp)
    80003930:	64a2                	ld	s1,8(sp)
    80003932:	6902                	ld	s2,0(sp)
    80003934:	6105                	addi	sp,sp,32
    80003936:	8082                	ret

0000000080003938 <releasesleep>:

void releasesleep(struct sleeplock *lk) {
    80003938:	1101                	addi	sp,sp,-32
    8000393a:	ec06                	sd	ra,24(sp)
    8000393c:	e822                	sd	s0,16(sp)
    8000393e:	e426                	sd	s1,8(sp)
    80003940:	e04a                	sd	s2,0(sp)
    80003942:	1000                	addi	s0,sp,32
    80003944:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003946:	00850913          	addi	s2,a0,8
    8000394a:	854a                	mv	a0,s2
    8000394c:	00003097          	auipc	ra,0x3
    80003950:	8c8080e7          	jalr	-1848(ra) # 80006214 <acquire>
  lk->locked = 0;
    80003954:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003958:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000395c:	8526                	mv	a0,s1
    8000395e:	ffffe097          	auipc	ra,0xffffe
    80003962:	c02080e7          	jalr	-1022(ra) # 80001560 <wakeup>
  release(&lk->lk);
    80003966:	854a                	mv	a0,s2
    80003968:	00003097          	auipc	ra,0x3
    8000396c:	960080e7          	jalr	-1696(ra) # 800062c8 <release>
}
    80003970:	60e2                	ld	ra,24(sp)
    80003972:	6442                	ld	s0,16(sp)
    80003974:	64a2                	ld	s1,8(sp)
    80003976:	6902                	ld	s2,0(sp)
    80003978:	6105                	addi	sp,sp,32
    8000397a:	8082                	ret

000000008000397c <holdingsleep>:

int holdingsleep(struct sleeplock *lk) {
    8000397c:	7179                	addi	sp,sp,-48
    8000397e:	f406                	sd	ra,40(sp)
    80003980:	f022                	sd	s0,32(sp)
    80003982:	ec26                	sd	s1,24(sp)
    80003984:	e84a                	sd	s2,16(sp)
    80003986:	e44e                	sd	s3,8(sp)
    80003988:	1800                	addi	s0,sp,48
    8000398a:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    8000398c:	00850913          	addi	s2,a0,8
    80003990:	854a                	mv	a0,s2
    80003992:	00003097          	auipc	ra,0x3
    80003996:	882080e7          	jalr	-1918(ra) # 80006214 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000399a:	409c                	lw	a5,0(s1)
    8000399c:	ef99                	bnez	a5,800039ba <holdingsleep+0x3e>
    8000399e:	4481                	li	s1,0
  release(&lk->lk);
    800039a0:	854a                	mv	a0,s2
    800039a2:	00003097          	auipc	ra,0x3
    800039a6:	926080e7          	jalr	-1754(ra) # 800062c8 <release>
  return r;
}
    800039aa:	8526                	mv	a0,s1
    800039ac:	70a2                	ld	ra,40(sp)
    800039ae:	7402                	ld	s0,32(sp)
    800039b0:	64e2                	ld	s1,24(sp)
    800039b2:	6942                	ld	s2,16(sp)
    800039b4:	69a2                	ld	s3,8(sp)
    800039b6:	6145                	addi	sp,sp,48
    800039b8:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800039ba:	0284a983          	lw	s3,40(s1)
    800039be:	ffffd097          	auipc	ra,0xffffd
    800039c2:	496080e7          	jalr	1174(ra) # 80000e54 <myproc>
    800039c6:	5904                	lw	s1,48(a0)
    800039c8:	413484b3          	sub	s1,s1,s3
    800039cc:	0014b493          	seqz	s1,s1
    800039d0:	bfc1                	j	800039a0 <holdingsleep+0x24>

00000000800039d2 <fileinit>:
struct {
  struct spinlock lock;
  struct file file[NFILE];
} ftable;

void fileinit(void) { initlock(&ftable.lock, "ftable"); }
    800039d2:	1141                	addi	sp,sp,-16
    800039d4:	e406                	sd	ra,8(sp)
    800039d6:	e022                	sd	s0,0(sp)
    800039d8:	0800                	addi	s0,sp,16
    800039da:	00005597          	auipc	a1,0x5
    800039de:	c4e58593          	addi	a1,a1,-946 # 80008628 <syscalls+0x248>
    800039e2:	00015517          	auipc	a0,0x15
    800039e6:	05650513          	addi	a0,a0,86 # 80018a38 <ftable>
    800039ea:	00002097          	auipc	ra,0x2
    800039ee:	79a080e7          	jalr	1946(ra) # 80006184 <initlock>
    800039f2:	60a2                	ld	ra,8(sp)
    800039f4:	6402                	ld	s0,0(sp)
    800039f6:	0141                	addi	sp,sp,16
    800039f8:	8082                	ret

00000000800039fa <filealloc>:

// Allocate a file structure.
struct file *filealloc(void) {
    800039fa:	1101                	addi	sp,sp,-32
    800039fc:	ec06                	sd	ra,24(sp)
    800039fe:	e822                	sd	s0,16(sp)
    80003a00:	e426                	sd	s1,8(sp)
    80003a02:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a04:	00015517          	auipc	a0,0x15
    80003a08:	03450513          	addi	a0,a0,52 # 80018a38 <ftable>
    80003a0c:	00003097          	auipc	ra,0x3
    80003a10:	808080e7          	jalr	-2040(ra) # 80006214 <acquire>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80003a14:	00015497          	auipc	s1,0x15
    80003a18:	03c48493          	addi	s1,s1,60 # 80018a50 <ftable+0x18>
    80003a1c:	00016717          	auipc	a4,0x16
    80003a20:	fd470713          	addi	a4,a4,-44 # 800199f0 <disk>
    if (f->ref == 0) {
    80003a24:	40dc                	lw	a5,4(s1)
    80003a26:	cf99                	beqz	a5,80003a44 <filealloc+0x4a>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80003a28:	02848493          	addi	s1,s1,40
    80003a2c:	fee49ce3          	bne	s1,a4,80003a24 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a30:	00015517          	auipc	a0,0x15
    80003a34:	00850513          	addi	a0,a0,8 # 80018a38 <ftable>
    80003a38:	00003097          	auipc	ra,0x3
    80003a3c:	890080e7          	jalr	-1904(ra) # 800062c8 <release>
  return 0;
    80003a40:	4481                	li	s1,0
    80003a42:	a819                	j	80003a58 <filealloc+0x5e>
      f->ref = 1;
    80003a44:	4785                	li	a5,1
    80003a46:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a48:	00015517          	auipc	a0,0x15
    80003a4c:	ff050513          	addi	a0,a0,-16 # 80018a38 <ftable>
    80003a50:	00003097          	auipc	ra,0x3
    80003a54:	878080e7          	jalr	-1928(ra) # 800062c8 <release>
}
    80003a58:	8526                	mv	a0,s1
    80003a5a:	60e2                	ld	ra,24(sp)
    80003a5c:	6442                	ld	s0,16(sp)
    80003a5e:	64a2                	ld	s1,8(sp)
    80003a60:	6105                	addi	sp,sp,32
    80003a62:	8082                	ret

0000000080003a64 <filedup>:

// Increment ref count for file f.
struct file *filedup(struct file *f) {
    80003a64:	1101                	addi	sp,sp,-32
    80003a66:	ec06                	sd	ra,24(sp)
    80003a68:	e822                	sd	s0,16(sp)
    80003a6a:	e426                	sd	s1,8(sp)
    80003a6c:	1000                	addi	s0,sp,32
    80003a6e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a70:	00015517          	auipc	a0,0x15
    80003a74:	fc850513          	addi	a0,a0,-56 # 80018a38 <ftable>
    80003a78:	00002097          	auipc	ra,0x2
    80003a7c:	79c080e7          	jalr	1948(ra) # 80006214 <acquire>
  if (f->ref < 1) panic("filedup");
    80003a80:	40dc                	lw	a5,4(s1)
    80003a82:	02f05263          	blez	a5,80003aa6 <filedup+0x42>
  f->ref++;
    80003a86:	2785                	addiw	a5,a5,1
    80003a88:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a8a:	00015517          	auipc	a0,0x15
    80003a8e:	fae50513          	addi	a0,a0,-82 # 80018a38 <ftable>
    80003a92:	00003097          	auipc	ra,0x3
    80003a96:	836080e7          	jalr	-1994(ra) # 800062c8 <release>
  return f;
}
    80003a9a:	8526                	mv	a0,s1
    80003a9c:	60e2                	ld	ra,24(sp)
    80003a9e:	6442                	ld	s0,16(sp)
    80003aa0:	64a2                	ld	s1,8(sp)
    80003aa2:	6105                	addi	sp,sp,32
    80003aa4:	8082                	ret
  if (f->ref < 1) panic("filedup");
    80003aa6:	00005517          	auipc	a0,0x5
    80003aaa:	b8a50513          	addi	a0,a0,-1142 # 80008630 <syscalls+0x250>
    80003aae:	00002097          	auipc	ra,0x2
    80003ab2:	22e080e7          	jalr	558(ra) # 80005cdc <panic>

0000000080003ab6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f) {
    80003ab6:	7139                	addi	sp,sp,-64
    80003ab8:	fc06                	sd	ra,56(sp)
    80003aba:	f822                	sd	s0,48(sp)
    80003abc:	f426                	sd	s1,40(sp)
    80003abe:	f04a                	sd	s2,32(sp)
    80003ac0:	ec4e                	sd	s3,24(sp)
    80003ac2:	e852                	sd	s4,16(sp)
    80003ac4:	e456                	sd	s5,8(sp)
    80003ac6:	0080                	addi	s0,sp,64
    80003ac8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003aca:	00015517          	auipc	a0,0x15
    80003ace:	f6e50513          	addi	a0,a0,-146 # 80018a38 <ftable>
    80003ad2:	00002097          	auipc	ra,0x2
    80003ad6:	742080e7          	jalr	1858(ra) # 80006214 <acquire>
  if (f->ref < 1) panic("fileclose");
    80003ada:	40dc                	lw	a5,4(s1)
    80003adc:	06f05163          	blez	a5,80003b3e <fileclose+0x88>
  if (--f->ref > 0) {
    80003ae0:	37fd                	addiw	a5,a5,-1
    80003ae2:	0007871b          	sext.w	a4,a5
    80003ae6:	c0dc                	sw	a5,4(s1)
    80003ae8:	06e04363          	bgtz	a4,80003b4e <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003aec:	0004a903          	lw	s2,0(s1)
    80003af0:	0094ca83          	lbu	s5,9(s1)
    80003af4:	0104ba03          	ld	s4,16(s1)
    80003af8:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003afc:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b00:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b04:	00015517          	auipc	a0,0x15
    80003b08:	f3450513          	addi	a0,a0,-204 # 80018a38 <ftable>
    80003b0c:	00002097          	auipc	ra,0x2
    80003b10:	7bc080e7          	jalr	1980(ra) # 800062c8 <release>

  if (ff.type == FD_PIPE) {
    80003b14:	4785                	li	a5,1
    80003b16:	04f90d63          	beq	s2,a5,80003b70 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if (ff.type == FD_INODE || ff.type == FD_DEVICE) {
    80003b1a:	3979                	addiw	s2,s2,-2
    80003b1c:	4785                	li	a5,1
    80003b1e:	0527e063          	bltu	a5,s2,80003b5e <fileclose+0xa8>
    begin_op();
    80003b22:	00000097          	auipc	ra,0x0
    80003b26:	acc080e7          	jalr	-1332(ra) # 800035ee <begin_op>
    iput(ff.ip);
    80003b2a:	854e                	mv	a0,s3
    80003b2c:	fffff097          	auipc	ra,0xfffff
    80003b30:	2b0080e7          	jalr	688(ra) # 80002ddc <iput>
    end_op();
    80003b34:	00000097          	auipc	ra,0x0
    80003b38:	b38080e7          	jalr	-1224(ra) # 8000366c <end_op>
    80003b3c:	a00d                	j	80003b5e <fileclose+0xa8>
  if (f->ref < 1) panic("fileclose");
    80003b3e:	00005517          	auipc	a0,0x5
    80003b42:	afa50513          	addi	a0,a0,-1286 # 80008638 <syscalls+0x258>
    80003b46:	00002097          	auipc	ra,0x2
    80003b4a:	196080e7          	jalr	406(ra) # 80005cdc <panic>
    release(&ftable.lock);
    80003b4e:	00015517          	auipc	a0,0x15
    80003b52:	eea50513          	addi	a0,a0,-278 # 80018a38 <ftable>
    80003b56:	00002097          	auipc	ra,0x2
    80003b5a:	772080e7          	jalr	1906(ra) # 800062c8 <release>
  }
}
    80003b5e:	70e2                	ld	ra,56(sp)
    80003b60:	7442                	ld	s0,48(sp)
    80003b62:	74a2                	ld	s1,40(sp)
    80003b64:	7902                	ld	s2,32(sp)
    80003b66:	69e2                	ld	s3,24(sp)
    80003b68:	6a42                	ld	s4,16(sp)
    80003b6a:	6aa2                	ld	s5,8(sp)
    80003b6c:	6121                	addi	sp,sp,64
    80003b6e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b70:	85d6                	mv	a1,s5
    80003b72:	8552                	mv	a0,s4
    80003b74:	00000097          	auipc	ra,0x0
    80003b78:	34c080e7          	jalr	844(ra) # 80003ec0 <pipeclose>
    80003b7c:	b7cd                	j	80003b5e <fileclose+0xa8>

0000000080003b7e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int filestat(struct file *f, uint64 addr) {
    80003b7e:	715d                	addi	sp,sp,-80
    80003b80:	e486                	sd	ra,72(sp)
    80003b82:	e0a2                	sd	s0,64(sp)
    80003b84:	fc26                	sd	s1,56(sp)
    80003b86:	f84a                	sd	s2,48(sp)
    80003b88:	f44e                	sd	s3,40(sp)
    80003b8a:	0880                	addi	s0,sp,80
    80003b8c:	84aa                	mv	s1,a0
    80003b8e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b90:	ffffd097          	auipc	ra,0xffffd
    80003b94:	2c4080e7          	jalr	708(ra) # 80000e54 <myproc>
  struct stat st;

  if (f->type == FD_INODE || f->type == FD_DEVICE) {
    80003b98:	409c                	lw	a5,0(s1)
    80003b9a:	37f9                	addiw	a5,a5,-2
    80003b9c:	4705                	li	a4,1
    80003b9e:	04f76763          	bltu	a4,a5,80003bec <filestat+0x6e>
    80003ba2:	892a                	mv	s2,a0
    ilock(f->ip);
    80003ba4:	6c88                	ld	a0,24(s1)
    80003ba6:	fffff097          	auipc	ra,0xfffff
    80003baa:	07c080e7          	jalr	124(ra) # 80002c22 <ilock>
    stati(f->ip, &st);
    80003bae:	fb840593          	addi	a1,s0,-72
    80003bb2:	6c88                	ld	a0,24(s1)
    80003bb4:	fffff097          	auipc	ra,0xfffff
    80003bb8:	2f8080e7          	jalr	760(ra) # 80002eac <stati>
    iunlock(f->ip);
    80003bbc:	6c88                	ld	a0,24(s1)
    80003bbe:	fffff097          	auipc	ra,0xfffff
    80003bc2:	126080e7          	jalr	294(ra) # 80002ce4 <iunlock>
    if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0) return -1;
    80003bc6:	46e1                	li	a3,24
    80003bc8:	fb840613          	addi	a2,s0,-72
    80003bcc:	85ce                	mv	a1,s3
    80003bce:	05093503          	ld	a0,80(s2)
    80003bd2:	ffffd097          	auipc	ra,0xffffd
    80003bd6:	f42080e7          	jalr	-190(ra) # 80000b14 <copyout>
    80003bda:	41f5551b          	sraiw	a0,a0,0x1f
    return 0;
  }
  return -1;
}
    80003bde:	60a6                	ld	ra,72(sp)
    80003be0:	6406                	ld	s0,64(sp)
    80003be2:	74e2                	ld	s1,56(sp)
    80003be4:	7942                	ld	s2,48(sp)
    80003be6:	79a2                	ld	s3,40(sp)
    80003be8:	6161                	addi	sp,sp,80
    80003bea:	8082                	ret
  return -1;
    80003bec:	557d                	li	a0,-1
    80003bee:	bfc5                	j	80003bde <filestat+0x60>

0000000080003bf0 <fileread>:

// Read from file f.
// addr is a user virtual address.
int fileread(struct file *f, uint64 addr, int n) {
    80003bf0:	7179                	addi	sp,sp,-48
    80003bf2:	f406                	sd	ra,40(sp)
    80003bf4:	f022                	sd	s0,32(sp)
    80003bf6:	ec26                	sd	s1,24(sp)
    80003bf8:	e84a                	sd	s2,16(sp)
    80003bfa:	e44e                	sd	s3,8(sp)
    80003bfc:	1800                	addi	s0,sp,48
  int r = 0;

  if (f->readable == 0) return -1;
    80003bfe:	00854783          	lbu	a5,8(a0)
    80003c02:	c3d5                	beqz	a5,80003ca6 <fileread+0xb6>
    80003c04:	84aa                	mv	s1,a0
    80003c06:	89ae                	mv	s3,a1
    80003c08:	8932                	mv	s2,a2

  if (f->type == FD_PIPE) {
    80003c0a:	411c                	lw	a5,0(a0)
    80003c0c:	4705                	li	a4,1
    80003c0e:	04e78963          	beq	a5,a4,80003c60 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80003c12:	470d                	li	a4,3
    80003c14:	04e78d63          	beq	a5,a4,80003c6e <fileread+0x7e>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if (f->type == FD_INODE) {
    80003c18:	4709                	li	a4,2
    80003c1a:	06e79e63          	bne	a5,a4,80003c96 <fileread+0xa6>
    ilock(f->ip);
    80003c1e:	6d08                	ld	a0,24(a0)
    80003c20:	fffff097          	auipc	ra,0xfffff
    80003c24:	002080e7          	jalr	2(ra) # 80002c22 <ilock>
    if ((r = readi(f->ip, 1, addr, f->off, n)) > 0) f->off += r;
    80003c28:	874a                	mv	a4,s2
    80003c2a:	5094                	lw	a3,32(s1)
    80003c2c:	864e                	mv	a2,s3
    80003c2e:	4585                	li	a1,1
    80003c30:	6c88                	ld	a0,24(s1)
    80003c32:	fffff097          	auipc	ra,0xfffff
    80003c36:	2a4080e7          	jalr	676(ra) # 80002ed6 <readi>
    80003c3a:	892a                	mv	s2,a0
    80003c3c:	00a05563          	blez	a0,80003c46 <fileread+0x56>
    80003c40:	509c                	lw	a5,32(s1)
    80003c42:	9fa9                	addw	a5,a5,a0
    80003c44:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c46:	6c88                	ld	a0,24(s1)
    80003c48:	fffff097          	auipc	ra,0xfffff
    80003c4c:	09c080e7          	jalr	156(ra) # 80002ce4 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c50:	854a                	mv	a0,s2
    80003c52:	70a2                	ld	ra,40(sp)
    80003c54:	7402                	ld	s0,32(sp)
    80003c56:	64e2                	ld	s1,24(sp)
    80003c58:	6942                	ld	s2,16(sp)
    80003c5a:	69a2                	ld	s3,8(sp)
    80003c5c:	6145                	addi	sp,sp,48
    80003c5e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c60:	6908                	ld	a0,16(a0)
    80003c62:	00000097          	auipc	ra,0x0
    80003c66:	3c6080e7          	jalr	966(ra) # 80004028 <piperead>
    80003c6a:	892a                	mv	s2,a0
    80003c6c:	b7d5                	j	80003c50 <fileread+0x60>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    80003c6e:	02451783          	lh	a5,36(a0)
    80003c72:	03079693          	slli	a3,a5,0x30
    80003c76:	92c1                	srli	a3,a3,0x30
    80003c78:	4725                	li	a4,9
    80003c7a:	02d76863          	bltu	a4,a3,80003caa <fileread+0xba>
    80003c7e:	0792                	slli	a5,a5,0x4
    80003c80:	00015717          	auipc	a4,0x15
    80003c84:	d1870713          	addi	a4,a4,-744 # 80018998 <devsw>
    80003c88:	97ba                	add	a5,a5,a4
    80003c8a:	639c                	ld	a5,0(a5)
    80003c8c:	c38d                	beqz	a5,80003cae <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c8e:	4505                	li	a0,1
    80003c90:	9782                	jalr	a5
    80003c92:	892a                	mv	s2,a0
    80003c94:	bf75                	j	80003c50 <fileread+0x60>
    panic("fileread");
    80003c96:	00005517          	auipc	a0,0x5
    80003c9a:	9b250513          	addi	a0,a0,-1614 # 80008648 <syscalls+0x268>
    80003c9e:	00002097          	auipc	ra,0x2
    80003ca2:	03e080e7          	jalr	62(ra) # 80005cdc <panic>
  if (f->readable == 0) return -1;
    80003ca6:	597d                	li	s2,-1
    80003ca8:	b765                	j	80003c50 <fileread+0x60>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    80003caa:	597d                	li	s2,-1
    80003cac:	b755                	j	80003c50 <fileread+0x60>
    80003cae:	597d                	li	s2,-1
    80003cb0:	b745                	j	80003c50 <fileread+0x60>

0000000080003cb2 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int filewrite(struct file *f, uint64 addr, int n) {
    80003cb2:	715d                	addi	sp,sp,-80
    80003cb4:	e486                	sd	ra,72(sp)
    80003cb6:	e0a2                	sd	s0,64(sp)
    80003cb8:	fc26                	sd	s1,56(sp)
    80003cba:	f84a                	sd	s2,48(sp)
    80003cbc:	f44e                	sd	s3,40(sp)
    80003cbe:	f052                	sd	s4,32(sp)
    80003cc0:	ec56                	sd	s5,24(sp)
    80003cc2:	e85a                	sd	s6,16(sp)
    80003cc4:	e45e                	sd	s7,8(sp)
    80003cc6:	e062                	sd	s8,0(sp)
    80003cc8:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if (f->writable == 0) return -1;
    80003cca:	00954783          	lbu	a5,9(a0)
    80003cce:	10078663          	beqz	a5,80003dda <filewrite+0x128>
    80003cd2:	892a                	mv	s2,a0
    80003cd4:	8b2e                	mv	s6,a1
    80003cd6:	8a32                	mv	s4,a2

  if (f->type == FD_PIPE) {
    80003cd8:	411c                	lw	a5,0(a0)
    80003cda:	4705                	li	a4,1
    80003cdc:	02e78263          	beq	a5,a4,80003d00 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80003ce0:	470d                	li	a4,3
    80003ce2:	02e78663          	beq	a5,a4,80003d0e <filewrite+0x5c>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if (f->type == FD_INODE) {
    80003ce6:	4709                	li	a4,2
    80003ce8:	0ee79163          	bne	a5,a4,80003dca <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    int i = 0;
    while (i < n) {
    80003cec:	0ac05d63          	blez	a2,80003da6 <filewrite+0xf4>
    int i = 0;
    80003cf0:	4981                	li	s3,0
    80003cf2:	6b85                	lui	s7,0x1
    80003cf4:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003cf8:	6c05                	lui	s8,0x1
    80003cfa:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003cfe:	a861                	j	80003d96 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003d00:	6908                	ld	a0,16(a0)
    80003d02:	00000097          	auipc	ra,0x0
    80003d06:	22e080e7          	jalr	558(ra) # 80003f30 <pipewrite>
    80003d0a:	8a2a                	mv	s4,a0
    80003d0c:	a045                	j	80003dac <filewrite+0xfa>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) return -1;
    80003d0e:	02451783          	lh	a5,36(a0)
    80003d12:	03079693          	slli	a3,a5,0x30
    80003d16:	92c1                	srli	a3,a3,0x30
    80003d18:	4725                	li	a4,9
    80003d1a:	0cd76263          	bltu	a4,a3,80003dde <filewrite+0x12c>
    80003d1e:	0792                	slli	a5,a5,0x4
    80003d20:	00015717          	auipc	a4,0x15
    80003d24:	c7870713          	addi	a4,a4,-904 # 80018998 <devsw>
    80003d28:	97ba                	add	a5,a5,a4
    80003d2a:	679c                	ld	a5,8(a5)
    80003d2c:	cbdd                	beqz	a5,80003de2 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d2e:	4505                	li	a0,1
    80003d30:	9782                	jalr	a5
    80003d32:	8a2a                	mv	s4,a0
    80003d34:	a8a5                	j	80003dac <filewrite+0xfa>
    80003d36:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if (n1 > max) n1 = max;

      begin_op();
    80003d3a:	00000097          	auipc	ra,0x0
    80003d3e:	8b4080e7          	jalr	-1868(ra) # 800035ee <begin_op>
      ilock(f->ip);
    80003d42:	01893503          	ld	a0,24(s2)
    80003d46:	fffff097          	auipc	ra,0xfffff
    80003d4a:	edc080e7          	jalr	-292(ra) # 80002c22 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0) f->off += r;
    80003d4e:	8756                	mv	a4,s5
    80003d50:	02092683          	lw	a3,32(s2)
    80003d54:	01698633          	add	a2,s3,s6
    80003d58:	4585                	li	a1,1
    80003d5a:	01893503          	ld	a0,24(s2)
    80003d5e:	fffff097          	auipc	ra,0xfffff
    80003d62:	270080e7          	jalr	624(ra) # 80002fce <writei>
    80003d66:	84aa                	mv	s1,a0
    80003d68:	00a05763          	blez	a0,80003d76 <filewrite+0xc4>
    80003d6c:	02092783          	lw	a5,32(s2)
    80003d70:	9fa9                	addw	a5,a5,a0
    80003d72:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d76:	01893503          	ld	a0,24(s2)
    80003d7a:	fffff097          	auipc	ra,0xfffff
    80003d7e:	f6a080e7          	jalr	-150(ra) # 80002ce4 <iunlock>
      end_op();
    80003d82:	00000097          	auipc	ra,0x0
    80003d86:	8ea080e7          	jalr	-1814(ra) # 8000366c <end_op>

      if (r != n1) {
    80003d8a:	009a9f63          	bne	s5,s1,80003da8 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d8e:	013489bb          	addw	s3,s1,s3
    while (i < n) {
    80003d92:	0149db63          	bge	s3,s4,80003da8 <filewrite+0xf6>
      int n1 = n - i;
    80003d96:	413a04bb          	subw	s1,s4,s3
    80003d9a:	0004879b          	sext.w	a5,s1
    80003d9e:	f8fbdce3          	bge	s7,a5,80003d36 <filewrite+0x84>
    80003da2:	84e2                	mv	s1,s8
    80003da4:	bf49                	j	80003d36 <filewrite+0x84>
    int i = 0;
    80003da6:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003da8:	013a1f63          	bne	s4,s3,80003dc6 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003dac:	8552                	mv	a0,s4
    80003dae:	60a6                	ld	ra,72(sp)
    80003db0:	6406                	ld	s0,64(sp)
    80003db2:	74e2                	ld	s1,56(sp)
    80003db4:	7942                	ld	s2,48(sp)
    80003db6:	79a2                	ld	s3,40(sp)
    80003db8:	7a02                	ld	s4,32(sp)
    80003dba:	6ae2                	ld	s5,24(sp)
    80003dbc:	6b42                	ld	s6,16(sp)
    80003dbe:	6ba2                	ld	s7,8(sp)
    80003dc0:	6c02                	ld	s8,0(sp)
    80003dc2:	6161                	addi	sp,sp,80
    80003dc4:	8082                	ret
    ret = (i == n ? n : -1);
    80003dc6:	5a7d                	li	s4,-1
    80003dc8:	b7d5                	j	80003dac <filewrite+0xfa>
    panic("filewrite");
    80003dca:	00005517          	auipc	a0,0x5
    80003dce:	88e50513          	addi	a0,a0,-1906 # 80008658 <syscalls+0x278>
    80003dd2:	00002097          	auipc	ra,0x2
    80003dd6:	f0a080e7          	jalr	-246(ra) # 80005cdc <panic>
  if (f->writable == 0) return -1;
    80003dda:	5a7d                	li	s4,-1
    80003ddc:	bfc1                	j	80003dac <filewrite+0xfa>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) return -1;
    80003dde:	5a7d                	li	s4,-1
    80003de0:	b7f1                	j	80003dac <filewrite+0xfa>
    80003de2:	5a7d                	li	s4,-1
    80003de4:	b7e1                	j	80003dac <filewrite+0xfa>

0000000080003de6 <pipealloc>:
  uint nwrite;    // number of bytes written
  int readopen;   // read fd is still open
  int writeopen;  // write fd is still open
};

int pipealloc(struct file **f0, struct file **f1) {
    80003de6:	7179                	addi	sp,sp,-48
    80003de8:	f406                	sd	ra,40(sp)
    80003dea:	f022                	sd	s0,32(sp)
    80003dec:	ec26                	sd	s1,24(sp)
    80003dee:	e84a                	sd	s2,16(sp)
    80003df0:	e44e                	sd	s3,8(sp)
    80003df2:	e052                	sd	s4,0(sp)
    80003df4:	1800                	addi	s0,sp,48
    80003df6:	84aa                	mv	s1,a0
    80003df8:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003dfa:	0005b023          	sd	zero,0(a1)
    80003dfe:	00053023          	sd	zero,0(a0)
  if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0) goto bad;
    80003e02:	00000097          	auipc	ra,0x0
    80003e06:	bf8080e7          	jalr	-1032(ra) # 800039fa <filealloc>
    80003e0a:	e088                	sd	a0,0(s1)
    80003e0c:	c551                	beqz	a0,80003e98 <pipealloc+0xb2>
    80003e0e:	00000097          	auipc	ra,0x0
    80003e12:	bec080e7          	jalr	-1044(ra) # 800039fa <filealloc>
    80003e16:	00aa3023          	sd	a0,0(s4)
    80003e1a:	c92d                	beqz	a0,80003e8c <pipealloc+0xa6>
  if ((pi = (struct pipe *)kalloc()) == 0) goto bad;
    80003e1c:	ffffc097          	auipc	ra,0xffffc
    80003e20:	2fe080e7          	jalr	766(ra) # 8000011a <kalloc>
    80003e24:	892a                	mv	s2,a0
    80003e26:	c125                	beqz	a0,80003e86 <pipealloc+0xa0>
  pi->readopen = 1;
    80003e28:	4985                	li	s3,1
    80003e2a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e2e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e32:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e36:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e3a:	00005597          	auipc	a1,0x5
    80003e3e:	82e58593          	addi	a1,a1,-2002 # 80008668 <syscalls+0x288>
    80003e42:	00002097          	auipc	ra,0x2
    80003e46:	342080e7          	jalr	834(ra) # 80006184 <initlock>
  (*f0)->type = FD_PIPE;
    80003e4a:	609c                	ld	a5,0(s1)
    80003e4c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e50:	609c                	ld	a5,0(s1)
    80003e52:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e56:	609c                	ld	a5,0(s1)
    80003e58:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e5c:	609c                	ld	a5,0(s1)
    80003e5e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e62:	000a3783          	ld	a5,0(s4)
    80003e66:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e6a:	000a3783          	ld	a5,0(s4)
    80003e6e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e72:	000a3783          	ld	a5,0(s4)
    80003e76:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e7a:	000a3783          	ld	a5,0(s4)
    80003e7e:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e82:	4501                	li	a0,0
    80003e84:	a025                	j	80003eac <pipealloc+0xc6>

bad:
  if (pi) kfree((char *)pi);
  if (*f0) fileclose(*f0);
    80003e86:	6088                	ld	a0,0(s1)
    80003e88:	e501                	bnez	a0,80003e90 <pipealloc+0xaa>
    80003e8a:	a039                	j	80003e98 <pipealloc+0xb2>
    80003e8c:	6088                	ld	a0,0(s1)
    80003e8e:	c51d                	beqz	a0,80003ebc <pipealloc+0xd6>
    80003e90:	00000097          	auipc	ra,0x0
    80003e94:	c26080e7          	jalr	-986(ra) # 80003ab6 <fileclose>
  if (*f1) fileclose(*f1);
    80003e98:	000a3783          	ld	a5,0(s4)
  return -1;
    80003e9c:	557d                	li	a0,-1
  if (*f1) fileclose(*f1);
    80003e9e:	c799                	beqz	a5,80003eac <pipealloc+0xc6>
    80003ea0:	853e                	mv	a0,a5
    80003ea2:	00000097          	auipc	ra,0x0
    80003ea6:	c14080e7          	jalr	-1004(ra) # 80003ab6 <fileclose>
  return -1;
    80003eaa:	557d                	li	a0,-1
}
    80003eac:	70a2                	ld	ra,40(sp)
    80003eae:	7402                	ld	s0,32(sp)
    80003eb0:	64e2                	ld	s1,24(sp)
    80003eb2:	6942                	ld	s2,16(sp)
    80003eb4:	69a2                	ld	s3,8(sp)
    80003eb6:	6a02                	ld	s4,0(sp)
    80003eb8:	6145                	addi	sp,sp,48
    80003eba:	8082                	ret
  return -1;
    80003ebc:	557d                	li	a0,-1
    80003ebe:	b7fd                	j	80003eac <pipealloc+0xc6>

0000000080003ec0 <pipeclose>:

void pipeclose(struct pipe *pi, int writable) {
    80003ec0:	1101                	addi	sp,sp,-32
    80003ec2:	ec06                	sd	ra,24(sp)
    80003ec4:	e822                	sd	s0,16(sp)
    80003ec6:	e426                	sd	s1,8(sp)
    80003ec8:	e04a                	sd	s2,0(sp)
    80003eca:	1000                	addi	s0,sp,32
    80003ecc:	84aa                	mv	s1,a0
    80003ece:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003ed0:	00002097          	auipc	ra,0x2
    80003ed4:	344080e7          	jalr	836(ra) # 80006214 <acquire>
  if (writable) {
    80003ed8:	02090d63          	beqz	s2,80003f12 <pipeclose+0x52>
    pi->writeopen = 0;
    80003edc:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003ee0:	21848513          	addi	a0,s1,536
    80003ee4:	ffffd097          	auipc	ra,0xffffd
    80003ee8:	67c080e7          	jalr	1660(ra) # 80001560 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if (pi->readopen == 0 && pi->writeopen == 0) {
    80003eec:	2204b783          	ld	a5,544(s1)
    80003ef0:	eb95                	bnez	a5,80003f24 <pipeclose+0x64>
    release(&pi->lock);
    80003ef2:	8526                	mv	a0,s1
    80003ef4:	00002097          	auipc	ra,0x2
    80003ef8:	3d4080e7          	jalr	980(ra) # 800062c8 <release>
    kfree((char *)pi);
    80003efc:	8526                	mv	a0,s1
    80003efe:	ffffc097          	auipc	ra,0xffffc
    80003f02:	11e080e7          	jalr	286(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f06:	60e2                	ld	ra,24(sp)
    80003f08:	6442                	ld	s0,16(sp)
    80003f0a:	64a2                	ld	s1,8(sp)
    80003f0c:	6902                	ld	s2,0(sp)
    80003f0e:	6105                	addi	sp,sp,32
    80003f10:	8082                	ret
    pi->readopen = 0;
    80003f12:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f16:	21c48513          	addi	a0,s1,540
    80003f1a:	ffffd097          	auipc	ra,0xffffd
    80003f1e:	646080e7          	jalr	1606(ra) # 80001560 <wakeup>
    80003f22:	b7e9                	j	80003eec <pipeclose+0x2c>
    release(&pi->lock);
    80003f24:	8526                	mv	a0,s1
    80003f26:	00002097          	auipc	ra,0x2
    80003f2a:	3a2080e7          	jalr	930(ra) # 800062c8 <release>
}
    80003f2e:	bfe1                	j	80003f06 <pipeclose+0x46>

0000000080003f30 <pipewrite>:

int pipewrite(struct pipe *pi, uint64 addr, int n) {
    80003f30:	711d                	addi	sp,sp,-96
    80003f32:	ec86                	sd	ra,88(sp)
    80003f34:	e8a2                	sd	s0,80(sp)
    80003f36:	e4a6                	sd	s1,72(sp)
    80003f38:	e0ca                	sd	s2,64(sp)
    80003f3a:	fc4e                	sd	s3,56(sp)
    80003f3c:	f852                	sd	s4,48(sp)
    80003f3e:	f456                	sd	s5,40(sp)
    80003f40:	f05a                	sd	s6,32(sp)
    80003f42:	ec5e                	sd	s7,24(sp)
    80003f44:	e862                	sd	s8,16(sp)
    80003f46:	1080                	addi	s0,sp,96
    80003f48:	84aa                	mv	s1,a0
    80003f4a:	8aae                	mv	s5,a1
    80003f4c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f4e:	ffffd097          	auipc	ra,0xffffd
    80003f52:	f06080e7          	jalr	-250(ra) # 80000e54 <myproc>
    80003f56:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f58:	8526                	mv	a0,s1
    80003f5a:	00002097          	auipc	ra,0x2
    80003f5e:	2ba080e7          	jalr	698(ra) # 80006214 <acquire>
  while (i < n) {
    80003f62:	0b405663          	blez	s4,8000400e <pipewrite+0xde>
  int i = 0;
    80003f66:	4901                	li	s2,0
    if (pi->nwrite == pi->nread + PIPESIZE) {  // DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1) break;
    80003f68:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f6a:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f6e:	21c48b93          	addi	s7,s1,540
    80003f72:	a089                	j	80003fb4 <pipewrite+0x84>
      release(&pi->lock);
    80003f74:	8526                	mv	a0,s1
    80003f76:	00002097          	auipc	ra,0x2
    80003f7a:	352080e7          	jalr	850(ra) # 800062c8 <release>
      return -1;
    80003f7e:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f80:	854a                	mv	a0,s2
    80003f82:	60e6                	ld	ra,88(sp)
    80003f84:	6446                	ld	s0,80(sp)
    80003f86:	64a6                	ld	s1,72(sp)
    80003f88:	6906                	ld	s2,64(sp)
    80003f8a:	79e2                	ld	s3,56(sp)
    80003f8c:	7a42                	ld	s4,48(sp)
    80003f8e:	7aa2                	ld	s5,40(sp)
    80003f90:	7b02                	ld	s6,32(sp)
    80003f92:	6be2                	ld	s7,24(sp)
    80003f94:	6c42                	ld	s8,16(sp)
    80003f96:	6125                	addi	sp,sp,96
    80003f98:	8082                	ret
      wakeup(&pi->nread);
    80003f9a:	8562                	mv	a0,s8
    80003f9c:	ffffd097          	auipc	ra,0xffffd
    80003fa0:	5c4080e7          	jalr	1476(ra) # 80001560 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003fa4:	85a6                	mv	a1,s1
    80003fa6:	855e                	mv	a0,s7
    80003fa8:	ffffd097          	auipc	ra,0xffffd
    80003fac:	554080e7          	jalr	1364(ra) # 800014fc <sleep>
  while (i < n) {
    80003fb0:	07495063          	bge	s2,s4,80004010 <pipewrite+0xe0>
    if (pi->readopen == 0 || killed(pr)) {
    80003fb4:	2204a783          	lw	a5,544(s1)
    80003fb8:	dfd5                	beqz	a5,80003f74 <pipewrite+0x44>
    80003fba:	854e                	mv	a0,s3
    80003fbc:	ffffd097          	auipc	ra,0xffffd
    80003fc0:	7e8080e7          	jalr	2024(ra) # 800017a4 <killed>
    80003fc4:	f945                	bnez	a0,80003f74 <pipewrite+0x44>
    if (pi->nwrite == pi->nread + PIPESIZE) {  // DOC: pipewrite-full
    80003fc6:	2184a783          	lw	a5,536(s1)
    80003fca:	21c4a703          	lw	a4,540(s1)
    80003fce:	2007879b          	addiw	a5,a5,512
    80003fd2:	fcf704e3          	beq	a4,a5,80003f9a <pipewrite+0x6a>
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1) break;
    80003fd6:	4685                	li	a3,1
    80003fd8:	01590633          	add	a2,s2,s5
    80003fdc:	faf40593          	addi	a1,s0,-81
    80003fe0:	0509b503          	ld	a0,80(s3)
    80003fe4:	ffffd097          	auipc	ra,0xffffd
    80003fe8:	bbc080e7          	jalr	-1092(ra) # 80000ba0 <copyin>
    80003fec:	03650263          	beq	a0,s6,80004010 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003ff0:	21c4a783          	lw	a5,540(s1)
    80003ff4:	0017871b          	addiw	a4,a5,1
    80003ff8:	20e4ae23          	sw	a4,540(s1)
    80003ffc:	1ff7f793          	andi	a5,a5,511
    80004000:	97a6                	add	a5,a5,s1
    80004002:	faf44703          	lbu	a4,-81(s0)
    80004006:	00e78c23          	sb	a4,24(a5)
      i++;
    8000400a:	2905                	addiw	s2,s2,1
    8000400c:	b755                	j	80003fb0 <pipewrite+0x80>
  int i = 0;
    8000400e:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004010:	21848513          	addi	a0,s1,536
    80004014:	ffffd097          	auipc	ra,0xffffd
    80004018:	54c080e7          	jalr	1356(ra) # 80001560 <wakeup>
  release(&pi->lock);
    8000401c:	8526                	mv	a0,s1
    8000401e:	00002097          	auipc	ra,0x2
    80004022:	2aa080e7          	jalr	682(ra) # 800062c8 <release>
  return i;
    80004026:	bfa9                	j	80003f80 <pipewrite+0x50>

0000000080004028 <piperead>:

int piperead(struct pipe *pi, uint64 addr, int n) {
    80004028:	715d                	addi	sp,sp,-80
    8000402a:	e486                	sd	ra,72(sp)
    8000402c:	e0a2                	sd	s0,64(sp)
    8000402e:	fc26                	sd	s1,56(sp)
    80004030:	f84a                	sd	s2,48(sp)
    80004032:	f44e                	sd	s3,40(sp)
    80004034:	f052                	sd	s4,32(sp)
    80004036:	ec56                	sd	s5,24(sp)
    80004038:	e85a                	sd	s6,16(sp)
    8000403a:	0880                	addi	s0,sp,80
    8000403c:	84aa                	mv	s1,a0
    8000403e:	892e                	mv	s2,a1
    80004040:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004042:	ffffd097          	auipc	ra,0xffffd
    80004046:	e12080e7          	jalr	-494(ra) # 80000e54 <myproc>
    8000404a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000404c:	8526                	mv	a0,s1
    8000404e:	00002097          	auipc	ra,0x2
    80004052:	1c6080e7          	jalr	454(ra) # 80006214 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    80004056:	2184a703          	lw	a4,536(s1)
    8000405a:	21c4a783          	lw	a5,540(s1)
    if (killed(pr)) {
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock);  // DOC: piperead-sleep
    8000405e:	21848993          	addi	s3,s1,536
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    80004062:	02f71763          	bne	a4,a5,80004090 <piperead+0x68>
    80004066:	2244a783          	lw	a5,548(s1)
    8000406a:	c39d                	beqz	a5,80004090 <piperead+0x68>
    if (killed(pr)) {
    8000406c:	8552                	mv	a0,s4
    8000406e:	ffffd097          	auipc	ra,0xffffd
    80004072:	736080e7          	jalr	1846(ra) # 800017a4 <killed>
    80004076:	e949                	bnez	a0,80004108 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock);  // DOC: piperead-sleep
    80004078:	85a6                	mv	a1,s1
    8000407a:	854e                	mv	a0,s3
    8000407c:	ffffd097          	auipc	ra,0xffffd
    80004080:	480080e7          	jalr	1152(ra) # 800014fc <sleep>
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    80004084:	2184a703          	lw	a4,536(s1)
    80004088:	21c4a783          	lw	a5,540(s1)
    8000408c:	fcf70de3          	beq	a4,a5,80004066 <piperead+0x3e>
  }
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    80004090:	4981                	li	s3,0
    if (pi->nread == pi->nwrite) break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1) break;
    80004092:	5b7d                	li	s6,-1
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    80004094:	05505463          	blez	s5,800040dc <piperead+0xb4>
    if (pi->nread == pi->nwrite) break;
    80004098:	2184a783          	lw	a5,536(s1)
    8000409c:	21c4a703          	lw	a4,540(s1)
    800040a0:	02f70e63          	beq	a4,a5,800040dc <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800040a4:	0017871b          	addiw	a4,a5,1
    800040a8:	20e4ac23          	sw	a4,536(s1)
    800040ac:	1ff7f793          	andi	a5,a5,511
    800040b0:	97a6                	add	a5,a5,s1
    800040b2:	0187c783          	lbu	a5,24(a5)
    800040b6:	faf40fa3          	sb	a5,-65(s0)
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1) break;
    800040ba:	4685                	li	a3,1
    800040bc:	fbf40613          	addi	a2,s0,-65
    800040c0:	85ca                	mv	a1,s2
    800040c2:	050a3503          	ld	a0,80(s4)
    800040c6:	ffffd097          	auipc	ra,0xffffd
    800040ca:	a4e080e7          	jalr	-1458(ra) # 80000b14 <copyout>
    800040ce:	01650763          	beq	a0,s6,800040dc <piperead+0xb4>
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    800040d2:	2985                	addiw	s3,s3,1
    800040d4:	0905                	addi	s2,s2,1
    800040d6:	fd3a91e3          	bne	s5,s3,80004098 <piperead+0x70>
    800040da:	89d6                	mv	s3,s5
  }
  wakeup(&pi->nwrite);  // DOC: piperead-wakeup
    800040dc:	21c48513          	addi	a0,s1,540
    800040e0:	ffffd097          	auipc	ra,0xffffd
    800040e4:	480080e7          	jalr	1152(ra) # 80001560 <wakeup>
  release(&pi->lock);
    800040e8:	8526                	mv	a0,s1
    800040ea:	00002097          	auipc	ra,0x2
    800040ee:	1de080e7          	jalr	478(ra) # 800062c8 <release>
  return i;
}
    800040f2:	854e                	mv	a0,s3
    800040f4:	60a6                	ld	ra,72(sp)
    800040f6:	6406                	ld	s0,64(sp)
    800040f8:	74e2                	ld	s1,56(sp)
    800040fa:	7942                	ld	s2,48(sp)
    800040fc:	79a2                	ld	s3,40(sp)
    800040fe:	7a02                	ld	s4,32(sp)
    80004100:	6ae2                	ld	s5,24(sp)
    80004102:	6b42                	ld	s6,16(sp)
    80004104:	6161                	addi	sp,sp,80
    80004106:	8082                	ret
      release(&pi->lock);
    80004108:	8526                	mv	a0,s1
    8000410a:	00002097          	auipc	ra,0x2
    8000410e:	1be080e7          	jalr	446(ra) # 800062c8 <release>
      return -1;
    80004112:	59fd                	li	s3,-1
    80004114:	bff9                	j	800040f2 <piperead+0xca>

0000000080004116 <flags2perm>:
#include "defs.h"
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags) {
    80004116:	1141                	addi	sp,sp,-16
    80004118:	e422                	sd	s0,8(sp)
    8000411a:	0800                	addi	s0,sp,16
    8000411c:	87aa                	mv	a5,a0
  int perm = 0;
  if (flags & 0x1) perm = PTE_X;
    8000411e:	8905                	andi	a0,a0,1
    80004120:	050e                	slli	a0,a0,0x3
  if (flags & 0x2) perm |= PTE_W;
    80004122:	8b89                	andi	a5,a5,2
    80004124:	c399                	beqz	a5,8000412a <flags2perm+0x14>
    80004126:	00456513          	ori	a0,a0,4
  return perm;
}
    8000412a:	6422                	ld	s0,8(sp)
    8000412c:	0141                	addi	sp,sp,16
    8000412e:	8082                	ret

0000000080004130 <exec>:

int exec(char *path, char **argv) {
    80004130:	de010113          	addi	sp,sp,-544
    80004134:	20113c23          	sd	ra,536(sp)
    80004138:	20813823          	sd	s0,528(sp)
    8000413c:	20913423          	sd	s1,520(sp)
    80004140:	21213023          	sd	s2,512(sp)
    80004144:	ffce                	sd	s3,504(sp)
    80004146:	fbd2                	sd	s4,496(sp)
    80004148:	f7d6                	sd	s5,488(sp)
    8000414a:	f3da                	sd	s6,480(sp)
    8000414c:	efde                	sd	s7,472(sp)
    8000414e:	ebe2                	sd	s8,464(sp)
    80004150:	e7e6                	sd	s9,456(sp)
    80004152:	e3ea                	sd	s10,448(sp)
    80004154:	ff6e                	sd	s11,440(sp)
    80004156:	1400                	addi	s0,sp,544
    80004158:	892a                	mv	s2,a0
    8000415a:	dea43423          	sd	a0,-536(s0)
    8000415e:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004162:	ffffd097          	auipc	ra,0xffffd
    80004166:	cf2080e7          	jalr	-782(ra) # 80000e54 <myproc>
    8000416a:	84aa                	mv	s1,a0

  begin_op();
    8000416c:	fffff097          	auipc	ra,0xfffff
    80004170:	482080e7          	jalr	1154(ra) # 800035ee <begin_op>

  if ((ip = namei(path)) == 0) {
    80004174:	854a                	mv	a0,s2
    80004176:	fffff097          	auipc	ra,0xfffff
    8000417a:	258080e7          	jalr	600(ra) # 800033ce <namei>
    8000417e:	c93d                	beqz	a0,800041f4 <exec+0xc4>
    80004180:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004182:	fffff097          	auipc	ra,0xfffff
    80004186:	aa0080e7          	jalr	-1376(ra) # 80002c22 <ilock>

  // Check ELF header
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf)) goto bad;
    8000418a:	04000713          	li	a4,64
    8000418e:	4681                	li	a3,0
    80004190:	e5040613          	addi	a2,s0,-432
    80004194:	4581                	li	a1,0
    80004196:	8556                	mv	a0,s5
    80004198:	fffff097          	auipc	ra,0xfffff
    8000419c:	d3e080e7          	jalr	-706(ra) # 80002ed6 <readi>
    800041a0:	04000793          	li	a5,64
    800041a4:	00f51a63          	bne	a0,a5,800041b8 <exec+0x88>

  if (elf.magic != ELF_MAGIC) goto bad;
    800041a8:	e5042703          	lw	a4,-432(s0)
    800041ac:	464c47b7          	lui	a5,0x464c4
    800041b0:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041b4:	04f70663          	beq	a4,a5,80004200 <exec+0xd0>
  return argc;  // this ends up in a0, the first argument to main(argc, argv)

bad:
  if (pagetable) proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    800041b8:	8556                	mv	a0,s5
    800041ba:	fffff097          	auipc	ra,0xfffff
    800041be:	cca080e7          	jalr	-822(ra) # 80002e84 <iunlockput>
    end_op();
    800041c2:	fffff097          	auipc	ra,0xfffff
    800041c6:	4aa080e7          	jalr	1194(ra) # 8000366c <end_op>
  }
  return -1;
    800041ca:	557d                	li	a0,-1
}
    800041cc:	21813083          	ld	ra,536(sp)
    800041d0:	21013403          	ld	s0,528(sp)
    800041d4:	20813483          	ld	s1,520(sp)
    800041d8:	20013903          	ld	s2,512(sp)
    800041dc:	79fe                	ld	s3,504(sp)
    800041de:	7a5e                	ld	s4,496(sp)
    800041e0:	7abe                	ld	s5,488(sp)
    800041e2:	7b1e                	ld	s6,480(sp)
    800041e4:	6bfe                	ld	s7,472(sp)
    800041e6:	6c5e                	ld	s8,464(sp)
    800041e8:	6cbe                	ld	s9,456(sp)
    800041ea:	6d1e                	ld	s10,448(sp)
    800041ec:	7dfa                	ld	s11,440(sp)
    800041ee:	22010113          	addi	sp,sp,544
    800041f2:	8082                	ret
    end_op();
    800041f4:	fffff097          	auipc	ra,0xfffff
    800041f8:	478080e7          	jalr	1144(ra) # 8000366c <end_op>
    return -1;
    800041fc:	557d                	li	a0,-1
    800041fe:	b7f9                	j	800041cc <exec+0x9c>
  if ((pagetable = proc_pagetable(p)) == 0) goto bad;
    80004200:	8526                	mv	a0,s1
    80004202:	ffffd097          	auipc	ra,0xffffd
    80004206:	d16080e7          	jalr	-746(ra) # 80000f18 <proc_pagetable>
    8000420a:	8b2a                	mv	s6,a0
    8000420c:	d555                	beqz	a0,800041b8 <exec+0x88>
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    8000420e:	e7042783          	lw	a5,-400(s0)
    80004212:	e8845703          	lhu	a4,-376(s0)
    80004216:	c735                	beqz	a4,80004282 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004218:	4901                	li	s2,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    8000421a:	e0043423          	sd	zero,-504(s0)
    if (ph.vaddr % PGSIZE != 0) goto bad;
    8000421e:	6a05                	lui	s4,0x1
    80004220:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004224:	dee43023          	sd	a4,-544(s0)
static int loadseg(pagetable_t pagetable, uint64 va, struct inode *ip,
                   uint offset, uint sz) {
  uint i, n;
  uint64 pa;

  for (i = 0; i < sz; i += PGSIZE) {
    80004228:	6d85                	lui	s11,0x1
    8000422a:	7d7d                	lui	s10,0xfffff
    8000422c:	ac3d                	j	8000446a <exec+0x33a>
    pa = walkaddr(pagetable, va + i);
    if (pa == 0) panic("loadseg: address should exist");
    8000422e:	00004517          	auipc	a0,0x4
    80004232:	44250513          	addi	a0,a0,1090 # 80008670 <syscalls+0x290>
    80004236:	00002097          	auipc	ra,0x2
    8000423a:	aa6080e7          	jalr	-1370(ra) # 80005cdc <panic>
    if (sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n) return -1;
    8000423e:	874a                	mv	a4,s2
    80004240:	009c86bb          	addw	a3,s9,s1
    80004244:	4581                	li	a1,0
    80004246:	8556                	mv	a0,s5
    80004248:	fffff097          	auipc	ra,0xfffff
    8000424c:	c8e080e7          	jalr	-882(ra) # 80002ed6 <readi>
    80004250:	2501                	sext.w	a0,a0
    80004252:	1aa91963          	bne	s2,a0,80004404 <exec+0x2d4>
  for (i = 0; i < sz; i += PGSIZE) {
    80004256:	009d84bb          	addw	s1,s11,s1
    8000425a:	013d09bb          	addw	s3,s10,s3
    8000425e:	1f74f663          	bgeu	s1,s7,8000444a <exec+0x31a>
    pa = walkaddr(pagetable, va + i);
    80004262:	02049593          	slli	a1,s1,0x20
    80004266:	9181                	srli	a1,a1,0x20
    80004268:	95e2                	add	a1,a1,s8
    8000426a:	855a                	mv	a0,s6
    8000426c:	ffffc097          	auipc	ra,0xffffc
    80004270:	298080e7          	jalr	664(ra) # 80000504 <walkaddr>
    80004274:	862a                	mv	a2,a0
    if (pa == 0) panic("loadseg: address should exist");
    80004276:	dd45                	beqz	a0,8000422e <exec+0xfe>
      n = PGSIZE;
    80004278:	8952                	mv	s2,s4
    if (sz - i < PGSIZE)
    8000427a:	fd49f2e3          	bgeu	s3,s4,8000423e <exec+0x10e>
      n = sz - i;
    8000427e:	894e                	mv	s2,s3
    80004280:	bf7d                	j	8000423e <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004282:	4901                	li	s2,0
  iunlockput(ip);
    80004284:	8556                	mv	a0,s5
    80004286:	fffff097          	auipc	ra,0xfffff
    8000428a:	bfe080e7          	jalr	-1026(ra) # 80002e84 <iunlockput>
  end_op();
    8000428e:	fffff097          	auipc	ra,0xfffff
    80004292:	3de080e7          	jalr	990(ra) # 8000366c <end_op>
  p = myproc();
    80004296:	ffffd097          	auipc	ra,0xffffd
    8000429a:	bbe080e7          	jalr	-1090(ra) # 80000e54 <myproc>
    8000429e:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800042a0:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800042a4:	6785                	lui	a5,0x1
    800042a6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800042a8:	97ca                	add	a5,a5,s2
    800042aa:	777d                	lui	a4,0xfffff
    800042ac:	8ff9                	and	a5,a5,a4
    800042ae:	def43c23          	sd	a5,-520(s0)
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE, PTE_W)) == 0) goto bad;
    800042b2:	4691                	li	a3,4
    800042b4:	6609                	lui	a2,0x2
    800042b6:	963e                	add	a2,a2,a5
    800042b8:	85be                	mv	a1,a5
    800042ba:	855a                	mv	a0,s6
    800042bc:	ffffc097          	auipc	ra,0xffffc
    800042c0:	5fc080e7          	jalr	1532(ra) # 800008b8 <uvmalloc>
    800042c4:	8c2a                	mv	s8,a0
  ip = 0;
    800042c6:	4a81                	li	s5,0
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE, PTE_W)) == 0) goto bad;
    800042c8:	12050e63          	beqz	a0,80004404 <exec+0x2d4>
  uvmclear(pagetable, sz - 2 * PGSIZE);
    800042cc:	75f9                	lui	a1,0xffffe
    800042ce:	95aa                	add	a1,a1,a0
    800042d0:	855a                	mv	a0,s6
    800042d2:	ffffd097          	auipc	ra,0xffffd
    800042d6:	810080e7          	jalr	-2032(ra) # 80000ae2 <uvmclear>
  stackbase = sp - PGSIZE;
    800042da:	7afd                	lui	s5,0xfffff
    800042dc:	9ae2                	add	s5,s5,s8
  for (argc = 0; argv[argc]; argc++) {
    800042de:	df043783          	ld	a5,-528(s0)
    800042e2:	6388                	ld	a0,0(a5)
    800042e4:	c925                	beqz	a0,80004354 <exec+0x224>
    800042e6:	e9040993          	addi	s3,s0,-368
    800042ea:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800042ee:	8962                	mv	s2,s8
  for (argc = 0; argv[argc]; argc++) {
    800042f0:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800042f2:	ffffc097          	auipc	ra,0xffffc
    800042f6:	004080e7          	jalr	4(ra) # 800002f6 <strlen>
    800042fa:	0015079b          	addiw	a5,a0,1
    800042fe:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16;  // riscv sp must be 16-byte aligned
    80004302:	ff07f913          	andi	s2,a5,-16
    if (sp < stackbase) goto bad;
    80004306:	13596663          	bltu	s2,s5,80004432 <exec+0x302>
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000430a:	df043d83          	ld	s11,-528(s0)
    8000430e:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004312:	8552                	mv	a0,s4
    80004314:	ffffc097          	auipc	ra,0xffffc
    80004318:	fe2080e7          	jalr	-30(ra) # 800002f6 <strlen>
    8000431c:	0015069b          	addiw	a3,a0,1
    80004320:	8652                	mv	a2,s4
    80004322:	85ca                	mv	a1,s2
    80004324:	855a                	mv	a0,s6
    80004326:	ffffc097          	auipc	ra,0xffffc
    8000432a:	7ee080e7          	jalr	2030(ra) # 80000b14 <copyout>
    8000432e:	10054663          	bltz	a0,8000443a <exec+0x30a>
    ustack[argc] = sp;
    80004332:	0129b023          	sd	s2,0(s3)
  for (argc = 0; argv[argc]; argc++) {
    80004336:	0485                	addi	s1,s1,1
    80004338:	008d8793          	addi	a5,s11,8
    8000433c:	def43823          	sd	a5,-528(s0)
    80004340:	008db503          	ld	a0,8(s11)
    80004344:	c911                	beqz	a0,80004358 <exec+0x228>
    if (argc >= MAXARG) goto bad;
    80004346:	09a1                	addi	s3,s3,8
    80004348:	fb3c95e3          	bne	s9,s3,800042f2 <exec+0x1c2>
  sz = sz1;
    8000434c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004350:	4a81                	li	s5,0
    80004352:	a84d                	j	80004404 <exec+0x2d4>
  sp = sz;
    80004354:	8962                	mv	s2,s8
  for (argc = 0; argv[argc]; argc++) {
    80004356:	4481                	li	s1,0
  ustack[argc] = 0;
    80004358:	00349793          	slli	a5,s1,0x3
    8000435c:	f9078793          	addi	a5,a5,-112
    80004360:	97a2                	add	a5,a5,s0
    80004362:	f007b023          	sd	zero,-256(a5)
  sp -= (argc + 1) * sizeof(uint64);
    80004366:	00148693          	addi	a3,s1,1
    8000436a:	068e                	slli	a3,a3,0x3
    8000436c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004370:	ff097913          	andi	s2,s2,-16
  if (sp < stackbase) goto bad;
    80004374:	01597663          	bgeu	s2,s5,80004380 <exec+0x250>
  sz = sz1;
    80004378:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000437c:	4a81                	li	s5,0
    8000437e:	a059                	j	80004404 <exec+0x2d4>
  if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    80004380:	e9040613          	addi	a2,s0,-368
    80004384:	85ca                	mv	a1,s2
    80004386:	855a                	mv	a0,s6
    80004388:	ffffc097          	auipc	ra,0xffffc
    8000438c:	78c080e7          	jalr	1932(ra) # 80000b14 <copyout>
    80004390:	0a054963          	bltz	a0,80004442 <exec+0x312>
  p->trapframe->a1 = sp;
    80004394:	058bb783          	ld	a5,88(s7)
    80004398:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    8000439c:	de843783          	ld	a5,-536(s0)
    800043a0:	0007c703          	lbu	a4,0(a5)
    800043a4:	cf11                	beqz	a4,800043c0 <exec+0x290>
    800043a6:	0785                	addi	a5,a5,1
    if (*s == '/') last = s + 1;
    800043a8:	02f00693          	li	a3,47
    800043ac:	a039                	j	800043ba <exec+0x28a>
    800043ae:	def43423          	sd	a5,-536(s0)
  for (last = s = path; *s; s++)
    800043b2:	0785                	addi	a5,a5,1
    800043b4:	fff7c703          	lbu	a4,-1(a5)
    800043b8:	c701                	beqz	a4,800043c0 <exec+0x290>
    if (*s == '/') last = s + 1;
    800043ba:	fed71ce3          	bne	a4,a3,800043b2 <exec+0x282>
    800043be:	bfc5                	j	800043ae <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    800043c0:	4641                	li	a2,16
    800043c2:	de843583          	ld	a1,-536(s0)
    800043c6:	158b8513          	addi	a0,s7,344
    800043ca:	ffffc097          	auipc	ra,0xffffc
    800043ce:	efa080e7          	jalr	-262(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    800043d2:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    800043d6:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    800043da:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800043de:	058bb783          	ld	a5,88(s7)
    800043e2:	e6843703          	ld	a4,-408(s0)
    800043e6:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;          // initial stack pointer
    800043e8:	058bb783          	ld	a5,88(s7)
    800043ec:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800043f0:	85ea                	mv	a1,s10
    800043f2:	ffffd097          	auipc	ra,0xffffd
    800043f6:	bc2080e7          	jalr	-1086(ra) # 80000fb4 <proc_freepagetable>
  return argc;  // this ends up in a0, the first argument to main(argc, argv)
    800043fa:	0004851b          	sext.w	a0,s1
    800043fe:	b3f9                	j	800041cc <exec+0x9c>
    80004400:	df243c23          	sd	s2,-520(s0)
  if (pagetable) proc_freepagetable(pagetable, sz);
    80004404:	df843583          	ld	a1,-520(s0)
    80004408:	855a                	mv	a0,s6
    8000440a:	ffffd097          	auipc	ra,0xffffd
    8000440e:	baa080e7          	jalr	-1110(ra) # 80000fb4 <proc_freepagetable>
  if (ip) {
    80004412:	da0a93e3          	bnez	s5,800041b8 <exec+0x88>
  return -1;
    80004416:	557d                	li	a0,-1
    80004418:	bb55                	j	800041cc <exec+0x9c>
    8000441a:	df243c23          	sd	s2,-520(s0)
    8000441e:	b7dd                	j	80004404 <exec+0x2d4>
    80004420:	df243c23          	sd	s2,-520(s0)
    80004424:	b7c5                	j	80004404 <exec+0x2d4>
    80004426:	df243c23          	sd	s2,-520(s0)
    8000442a:	bfe9                	j	80004404 <exec+0x2d4>
    8000442c:	df243c23          	sd	s2,-520(s0)
    80004430:	bfd1                	j	80004404 <exec+0x2d4>
  sz = sz1;
    80004432:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004436:	4a81                	li	s5,0
    80004438:	b7f1                	j	80004404 <exec+0x2d4>
  sz = sz1;
    8000443a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000443e:	4a81                	li	s5,0
    80004440:	b7d1                	j	80004404 <exec+0x2d4>
  sz = sz1;
    80004442:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004446:	4a81                	li	s5,0
    80004448:	bf75                	j	80004404 <exec+0x2d4>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    8000444a:	df843903          	ld	s2,-520(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    8000444e:	e0843783          	ld	a5,-504(s0)
    80004452:	0017869b          	addiw	a3,a5,1
    80004456:	e0d43423          	sd	a3,-504(s0)
    8000445a:	e0043783          	ld	a5,-512(s0)
    8000445e:	0387879b          	addiw	a5,a5,56
    80004462:	e8845703          	lhu	a4,-376(s0)
    80004466:	e0e6dfe3          	bge	a3,a4,80004284 <exec+0x154>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph)) goto bad;
    8000446a:	2781                	sext.w	a5,a5
    8000446c:	e0f43023          	sd	a5,-512(s0)
    80004470:	03800713          	li	a4,56
    80004474:	86be                	mv	a3,a5
    80004476:	e1840613          	addi	a2,s0,-488
    8000447a:	4581                	li	a1,0
    8000447c:	8556                	mv	a0,s5
    8000447e:	fffff097          	auipc	ra,0xfffff
    80004482:	a58080e7          	jalr	-1448(ra) # 80002ed6 <readi>
    80004486:	03800793          	li	a5,56
    8000448a:	f6f51be3          	bne	a0,a5,80004400 <exec+0x2d0>
    if (ph.type != ELF_PROG_LOAD) continue;
    8000448e:	e1842783          	lw	a5,-488(s0)
    80004492:	4705                	li	a4,1
    80004494:	fae79de3          	bne	a5,a4,8000444e <exec+0x31e>
    if (ph.memsz < ph.filesz) goto bad;
    80004498:	e4043483          	ld	s1,-448(s0)
    8000449c:	e3843783          	ld	a5,-456(s0)
    800044a0:	f6f4ede3          	bltu	s1,a5,8000441a <exec+0x2ea>
    if (ph.vaddr + ph.memsz < ph.vaddr) goto bad;
    800044a4:	e2843783          	ld	a5,-472(s0)
    800044a8:	94be                	add	s1,s1,a5
    800044aa:	f6f4ebe3          	bltu	s1,a5,80004420 <exec+0x2f0>
    if (ph.vaddr % PGSIZE != 0) goto bad;
    800044ae:	de043703          	ld	a4,-544(s0)
    800044b2:	8ff9                	and	a5,a5,a4
    800044b4:	fbad                	bnez	a5,80004426 <exec+0x2f6>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    800044b6:	e1c42503          	lw	a0,-484(s0)
    800044ba:	00000097          	auipc	ra,0x0
    800044be:	c5c080e7          	jalr	-932(ra) # 80004116 <flags2perm>
    800044c2:	86aa                	mv	a3,a0
    800044c4:	8626                	mv	a2,s1
    800044c6:	85ca                	mv	a1,s2
    800044c8:	855a                	mv	a0,s6
    800044ca:	ffffc097          	auipc	ra,0xffffc
    800044ce:	3ee080e7          	jalr	1006(ra) # 800008b8 <uvmalloc>
    800044d2:	dea43c23          	sd	a0,-520(s0)
    800044d6:	d939                	beqz	a0,8000442c <exec+0x2fc>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0) goto bad;
    800044d8:	e2843c03          	ld	s8,-472(s0)
    800044dc:	e2042c83          	lw	s9,-480(s0)
    800044e0:	e3842b83          	lw	s7,-456(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    800044e4:	f60b83e3          	beqz	s7,8000444a <exec+0x31a>
    800044e8:	89de                	mv	s3,s7
    800044ea:	4481                	li	s1,0
    800044ec:	bb9d                	j	80004262 <exec+0x132>

00000000800044ee <argfd>:
#include "file.h"
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int argfd(int n, int *pfd, struct file **pf) {
    800044ee:	7179                	addi	sp,sp,-48
    800044f0:	f406                	sd	ra,40(sp)
    800044f2:	f022                	sd	s0,32(sp)
    800044f4:	ec26                	sd	s1,24(sp)
    800044f6:	e84a                	sd	s2,16(sp)
    800044f8:	1800                	addi	s0,sp,48
    800044fa:	892e                	mv	s2,a1
    800044fc:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800044fe:	fdc40593          	addi	a1,s0,-36
    80004502:	ffffe097          	auipc	ra,0xffffe
    80004506:	b50080e7          	jalr	-1200(ra) # 80002052 <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) return -1;
    8000450a:	fdc42703          	lw	a4,-36(s0)
    8000450e:	47bd                	li	a5,15
    80004510:	02e7eb63          	bltu	a5,a4,80004546 <argfd+0x58>
    80004514:	ffffd097          	auipc	ra,0xffffd
    80004518:	940080e7          	jalr	-1728(ra) # 80000e54 <myproc>
    8000451c:	fdc42703          	lw	a4,-36(s0)
    80004520:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffdd2aa>
    80004524:	078e                	slli	a5,a5,0x3
    80004526:	953e                	add	a0,a0,a5
    80004528:	611c                	ld	a5,0(a0)
    8000452a:	c385                	beqz	a5,8000454a <argfd+0x5c>
  if (pfd) *pfd = fd;
    8000452c:	00090463          	beqz	s2,80004534 <argfd+0x46>
    80004530:	00e92023          	sw	a4,0(s2)
  if (pf) *pf = f;
  return 0;
    80004534:	4501                	li	a0,0
  if (pf) *pf = f;
    80004536:	c091                	beqz	s1,8000453a <argfd+0x4c>
    80004538:	e09c                	sd	a5,0(s1)
}
    8000453a:	70a2                	ld	ra,40(sp)
    8000453c:	7402                	ld	s0,32(sp)
    8000453e:	64e2                	ld	s1,24(sp)
    80004540:	6942                	ld	s2,16(sp)
    80004542:	6145                	addi	sp,sp,48
    80004544:	8082                	ret
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) return -1;
    80004546:	557d                	li	a0,-1
    80004548:	bfcd                	j	8000453a <argfd+0x4c>
    8000454a:	557d                	li	a0,-1
    8000454c:	b7fd                	j	8000453a <argfd+0x4c>

000000008000454e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int fdalloc(struct file *f) {
    8000454e:	1101                	addi	sp,sp,-32
    80004550:	ec06                	sd	ra,24(sp)
    80004552:	e822                	sd	s0,16(sp)
    80004554:	e426                	sd	s1,8(sp)
    80004556:	1000                	addi	s0,sp,32
    80004558:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000455a:	ffffd097          	auipc	ra,0xffffd
    8000455e:	8fa080e7          	jalr	-1798(ra) # 80000e54 <myproc>
    80004562:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++) {
    80004564:	0d050793          	addi	a5,a0,208
    80004568:	4501                	li	a0,0
    8000456a:	46c1                	li	a3,16
    if (p->ofile[fd] == 0) {
    8000456c:	6398                	ld	a4,0(a5)
    8000456e:	cb19                	beqz	a4,80004584 <fdalloc+0x36>
  for (fd = 0; fd < NOFILE; fd++) {
    80004570:	2505                	addiw	a0,a0,1
    80004572:	07a1                	addi	a5,a5,8
    80004574:	fed51ce3          	bne	a0,a3,8000456c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004578:	557d                	li	a0,-1
}
    8000457a:	60e2                	ld	ra,24(sp)
    8000457c:	6442                	ld	s0,16(sp)
    8000457e:	64a2                	ld	s1,8(sp)
    80004580:	6105                	addi	sp,sp,32
    80004582:	8082                	ret
      p->ofile[fd] = f;
    80004584:	01a50793          	addi	a5,a0,26
    80004588:	078e                	slli	a5,a5,0x3
    8000458a:	963e                	add	a2,a2,a5
    8000458c:	e204                	sd	s1,0(a2)
      return fd;
    8000458e:	b7f5                	j	8000457a <fdalloc+0x2c>

0000000080004590 <create>:
  iunlockput(dp);
  end_op();
  return -1;
}

static struct inode *create(char *path, short type, short major, short minor) {
    80004590:	715d                	addi	sp,sp,-80
    80004592:	e486                	sd	ra,72(sp)
    80004594:	e0a2                	sd	s0,64(sp)
    80004596:	fc26                	sd	s1,56(sp)
    80004598:	f84a                	sd	s2,48(sp)
    8000459a:	f44e                	sd	s3,40(sp)
    8000459c:	f052                	sd	s4,32(sp)
    8000459e:	ec56                	sd	s5,24(sp)
    800045a0:	e85a                	sd	s6,16(sp)
    800045a2:	0880                	addi	s0,sp,80
    800045a4:	8b2e                	mv	s6,a1
    800045a6:	89b2                	mv	s3,a2
    800045a8:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0) return 0;
    800045aa:	fb040593          	addi	a1,s0,-80
    800045ae:	fffff097          	auipc	ra,0xfffff
    800045b2:	e3e080e7          	jalr	-450(ra) # 800033ec <nameiparent>
    800045b6:	84aa                	mv	s1,a0
    800045b8:	14050f63          	beqz	a0,80004716 <create+0x186>

  ilock(dp);
    800045bc:	ffffe097          	auipc	ra,0xffffe
    800045c0:	666080e7          	jalr	1638(ra) # 80002c22 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0) {
    800045c4:	4601                	li	a2,0
    800045c6:	fb040593          	addi	a1,s0,-80
    800045ca:	8526                	mv	a0,s1
    800045cc:	fffff097          	auipc	ra,0xfffff
    800045d0:	b3a080e7          	jalr	-1222(ra) # 80003106 <dirlookup>
    800045d4:	8aaa                	mv	s5,a0
    800045d6:	c931                	beqz	a0,8000462a <create+0x9a>
    iunlockput(dp);
    800045d8:	8526                	mv	a0,s1
    800045da:	fffff097          	auipc	ra,0xfffff
    800045de:	8aa080e7          	jalr	-1878(ra) # 80002e84 <iunlockput>
    ilock(ip);
    800045e2:	8556                	mv	a0,s5
    800045e4:	ffffe097          	auipc	ra,0xffffe
    800045e8:	63e080e7          	jalr	1598(ra) # 80002c22 <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800045ec:	000b059b          	sext.w	a1,s6
    800045f0:	4789                	li	a5,2
    800045f2:	02f59563          	bne	a1,a5,8000461c <create+0x8c>
    800045f6:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdd2d4>
    800045fa:	37f9                	addiw	a5,a5,-2
    800045fc:	17c2                	slli	a5,a5,0x30
    800045fe:	93c1                	srli	a5,a5,0x30
    80004600:	4705                	li	a4,1
    80004602:	00f76d63          	bltu	a4,a5,8000461c <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004606:	8556                	mv	a0,s5
    80004608:	60a6                	ld	ra,72(sp)
    8000460a:	6406                	ld	s0,64(sp)
    8000460c:	74e2                	ld	s1,56(sp)
    8000460e:	7942                	ld	s2,48(sp)
    80004610:	79a2                	ld	s3,40(sp)
    80004612:	7a02                	ld	s4,32(sp)
    80004614:	6ae2                	ld	s5,24(sp)
    80004616:	6b42                	ld	s6,16(sp)
    80004618:	6161                	addi	sp,sp,80
    8000461a:	8082                	ret
    iunlockput(ip);
    8000461c:	8556                	mv	a0,s5
    8000461e:	fffff097          	auipc	ra,0xfffff
    80004622:	866080e7          	jalr	-1946(ra) # 80002e84 <iunlockput>
    return 0;
    80004626:	4a81                	li	s5,0
    80004628:	bff9                	j	80004606 <create+0x76>
  if ((ip = ialloc(dp->dev, type)) == 0) {
    8000462a:	85da                	mv	a1,s6
    8000462c:	4088                	lw	a0,0(s1)
    8000462e:	ffffe097          	auipc	ra,0xffffe
    80004632:	456080e7          	jalr	1110(ra) # 80002a84 <ialloc>
    80004636:	8a2a                	mv	s4,a0
    80004638:	c539                	beqz	a0,80004686 <create+0xf6>
  ilock(ip);
    8000463a:	ffffe097          	auipc	ra,0xffffe
    8000463e:	5e8080e7          	jalr	1512(ra) # 80002c22 <ilock>
  ip->major = major;
    80004642:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004646:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000464a:	4905                	li	s2,1
    8000464c:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004650:	8552                	mv	a0,s4
    80004652:	ffffe097          	auipc	ra,0xffffe
    80004656:	504080e7          	jalr	1284(ra) # 80002b56 <iupdate>
  if (type == T_DIR) {  // Create . and .. entries.
    8000465a:	000b059b          	sext.w	a1,s6
    8000465e:	03258b63          	beq	a1,s2,80004694 <create+0x104>
  if (dirlink(dp, name, ip->inum) < 0) goto fail;
    80004662:	004a2603          	lw	a2,4(s4)
    80004666:	fb040593          	addi	a1,s0,-80
    8000466a:	8526                	mv	a0,s1
    8000466c:	fffff097          	auipc	ra,0xfffff
    80004670:	cb0080e7          	jalr	-848(ra) # 8000331c <dirlink>
    80004674:	06054f63          	bltz	a0,800046f2 <create+0x162>
  iunlockput(dp);
    80004678:	8526                	mv	a0,s1
    8000467a:	fffff097          	auipc	ra,0xfffff
    8000467e:	80a080e7          	jalr	-2038(ra) # 80002e84 <iunlockput>
  return ip;
    80004682:	8ad2                	mv	s5,s4
    80004684:	b749                	j	80004606 <create+0x76>
    iunlockput(dp);
    80004686:	8526                	mv	a0,s1
    80004688:	ffffe097          	auipc	ra,0xffffe
    8000468c:	7fc080e7          	jalr	2044(ra) # 80002e84 <iunlockput>
    return 0;
    80004690:	8ad2                	mv	s5,s4
    80004692:	bf95                	j	80004606 <create+0x76>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004694:	004a2603          	lw	a2,4(s4)
    80004698:	00004597          	auipc	a1,0x4
    8000469c:	ff858593          	addi	a1,a1,-8 # 80008690 <syscalls+0x2b0>
    800046a0:	8552                	mv	a0,s4
    800046a2:	fffff097          	auipc	ra,0xfffff
    800046a6:	c7a080e7          	jalr	-902(ra) # 8000331c <dirlink>
    800046aa:	04054463          	bltz	a0,800046f2 <create+0x162>
    800046ae:	40d0                	lw	a2,4(s1)
    800046b0:	00004597          	auipc	a1,0x4
    800046b4:	fe858593          	addi	a1,a1,-24 # 80008698 <syscalls+0x2b8>
    800046b8:	8552                	mv	a0,s4
    800046ba:	fffff097          	auipc	ra,0xfffff
    800046be:	c62080e7          	jalr	-926(ra) # 8000331c <dirlink>
    800046c2:	02054863          	bltz	a0,800046f2 <create+0x162>
  if (dirlink(dp, name, ip->inum) < 0) goto fail;
    800046c6:	004a2603          	lw	a2,4(s4)
    800046ca:	fb040593          	addi	a1,s0,-80
    800046ce:	8526                	mv	a0,s1
    800046d0:	fffff097          	auipc	ra,0xfffff
    800046d4:	c4c080e7          	jalr	-948(ra) # 8000331c <dirlink>
    800046d8:	00054d63          	bltz	a0,800046f2 <create+0x162>
    dp->nlink++;  // for ".."
    800046dc:	04a4d783          	lhu	a5,74(s1)
    800046e0:	2785                	addiw	a5,a5,1
    800046e2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800046e6:	8526                	mv	a0,s1
    800046e8:	ffffe097          	auipc	ra,0xffffe
    800046ec:	46e080e7          	jalr	1134(ra) # 80002b56 <iupdate>
    800046f0:	b761                	j	80004678 <create+0xe8>
  ip->nlink = 0;
    800046f2:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800046f6:	8552                	mv	a0,s4
    800046f8:	ffffe097          	auipc	ra,0xffffe
    800046fc:	45e080e7          	jalr	1118(ra) # 80002b56 <iupdate>
  iunlockput(ip);
    80004700:	8552                	mv	a0,s4
    80004702:	ffffe097          	auipc	ra,0xffffe
    80004706:	782080e7          	jalr	1922(ra) # 80002e84 <iunlockput>
  iunlockput(dp);
    8000470a:	8526                	mv	a0,s1
    8000470c:	ffffe097          	auipc	ra,0xffffe
    80004710:	778080e7          	jalr	1912(ra) # 80002e84 <iunlockput>
  return 0;
    80004714:	bdcd                	j	80004606 <create+0x76>
  if ((dp = nameiparent(path, name)) == 0) return 0;
    80004716:	8aaa                	mv	s5,a0
    80004718:	b5fd                	j	80004606 <create+0x76>

000000008000471a <sys_dup>:
uint64 sys_dup(void) {
    8000471a:	7179                	addi	sp,sp,-48
    8000471c:	f406                	sd	ra,40(sp)
    8000471e:	f022                	sd	s0,32(sp)
    80004720:	ec26                	sd	s1,24(sp)
    80004722:	e84a                	sd	s2,16(sp)
    80004724:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0) return -1;
    80004726:	fd840613          	addi	a2,s0,-40
    8000472a:	4581                	li	a1,0
    8000472c:	4501                	li	a0,0
    8000472e:	00000097          	auipc	ra,0x0
    80004732:	dc0080e7          	jalr	-576(ra) # 800044ee <argfd>
    80004736:	57fd                	li	a5,-1
    80004738:	02054363          	bltz	a0,8000475e <sys_dup+0x44>
  if ((fd = fdalloc(f)) < 0) return -1;
    8000473c:	fd843903          	ld	s2,-40(s0)
    80004740:	854a                	mv	a0,s2
    80004742:	00000097          	auipc	ra,0x0
    80004746:	e0c080e7          	jalr	-500(ra) # 8000454e <fdalloc>
    8000474a:	84aa                	mv	s1,a0
    8000474c:	57fd                	li	a5,-1
    8000474e:	00054863          	bltz	a0,8000475e <sys_dup+0x44>
  filedup(f);
    80004752:	854a                	mv	a0,s2
    80004754:	fffff097          	auipc	ra,0xfffff
    80004758:	310080e7          	jalr	784(ra) # 80003a64 <filedup>
  return fd;
    8000475c:	87a6                	mv	a5,s1
}
    8000475e:	853e                	mv	a0,a5
    80004760:	70a2                	ld	ra,40(sp)
    80004762:	7402                	ld	s0,32(sp)
    80004764:	64e2                	ld	s1,24(sp)
    80004766:	6942                	ld	s2,16(sp)
    80004768:	6145                	addi	sp,sp,48
    8000476a:	8082                	ret

000000008000476c <sys_read>:
uint64 sys_read(void) {
    8000476c:	7179                	addi	sp,sp,-48
    8000476e:	f406                	sd	ra,40(sp)
    80004770:	f022                	sd	s0,32(sp)
    80004772:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004774:	fd840593          	addi	a1,s0,-40
    80004778:	4505                	li	a0,1
    8000477a:	ffffe097          	auipc	ra,0xffffe
    8000477e:	8f8080e7          	jalr	-1800(ra) # 80002072 <argaddr>
  argint(2, &n);
    80004782:	fe440593          	addi	a1,s0,-28
    80004786:	4509                	li	a0,2
    80004788:	ffffe097          	auipc	ra,0xffffe
    8000478c:	8ca080e7          	jalr	-1846(ra) # 80002052 <argint>
  if (argfd(0, 0, &f) < 0) return -1;
    80004790:	fe840613          	addi	a2,s0,-24
    80004794:	4581                	li	a1,0
    80004796:	4501                	li	a0,0
    80004798:	00000097          	auipc	ra,0x0
    8000479c:	d56080e7          	jalr	-682(ra) # 800044ee <argfd>
    800047a0:	87aa                	mv	a5,a0
    800047a2:	557d                	li	a0,-1
    800047a4:	0007cc63          	bltz	a5,800047bc <sys_read+0x50>
  return fileread(f, p, n);
    800047a8:	fe442603          	lw	a2,-28(s0)
    800047ac:	fd843583          	ld	a1,-40(s0)
    800047b0:	fe843503          	ld	a0,-24(s0)
    800047b4:	fffff097          	auipc	ra,0xfffff
    800047b8:	43c080e7          	jalr	1084(ra) # 80003bf0 <fileread>
}
    800047bc:	70a2                	ld	ra,40(sp)
    800047be:	7402                	ld	s0,32(sp)
    800047c0:	6145                	addi	sp,sp,48
    800047c2:	8082                	ret

00000000800047c4 <sys_write>:
uint64 sys_write(void) {
    800047c4:	7179                	addi	sp,sp,-48
    800047c6:	f406                	sd	ra,40(sp)
    800047c8:	f022                	sd	s0,32(sp)
    800047ca:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800047cc:	fd840593          	addi	a1,s0,-40
    800047d0:	4505                	li	a0,1
    800047d2:	ffffe097          	auipc	ra,0xffffe
    800047d6:	8a0080e7          	jalr	-1888(ra) # 80002072 <argaddr>
  argint(2, &n);
    800047da:	fe440593          	addi	a1,s0,-28
    800047de:	4509                	li	a0,2
    800047e0:	ffffe097          	auipc	ra,0xffffe
    800047e4:	872080e7          	jalr	-1934(ra) # 80002052 <argint>
  if (argfd(0, 0, &f) < 0) return -1;
    800047e8:	fe840613          	addi	a2,s0,-24
    800047ec:	4581                	li	a1,0
    800047ee:	4501                	li	a0,0
    800047f0:	00000097          	auipc	ra,0x0
    800047f4:	cfe080e7          	jalr	-770(ra) # 800044ee <argfd>
    800047f8:	87aa                	mv	a5,a0
    800047fa:	557d                	li	a0,-1
    800047fc:	0007cc63          	bltz	a5,80004814 <sys_write+0x50>
  return filewrite(f, p, n);
    80004800:	fe442603          	lw	a2,-28(s0)
    80004804:	fd843583          	ld	a1,-40(s0)
    80004808:	fe843503          	ld	a0,-24(s0)
    8000480c:	fffff097          	auipc	ra,0xfffff
    80004810:	4a6080e7          	jalr	1190(ra) # 80003cb2 <filewrite>
}
    80004814:	70a2                	ld	ra,40(sp)
    80004816:	7402                	ld	s0,32(sp)
    80004818:	6145                	addi	sp,sp,48
    8000481a:	8082                	ret

000000008000481c <sys_close>:
uint64 sys_close(void) {
    8000481c:	1101                	addi	sp,sp,-32
    8000481e:	ec06                	sd	ra,24(sp)
    80004820:	e822                	sd	s0,16(sp)
    80004822:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0) return -1;
    80004824:	fe040613          	addi	a2,s0,-32
    80004828:	fec40593          	addi	a1,s0,-20
    8000482c:	4501                	li	a0,0
    8000482e:	00000097          	auipc	ra,0x0
    80004832:	cc0080e7          	jalr	-832(ra) # 800044ee <argfd>
    80004836:	57fd                	li	a5,-1
    80004838:	02054463          	bltz	a0,80004860 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000483c:	ffffc097          	auipc	ra,0xffffc
    80004840:	618080e7          	jalr	1560(ra) # 80000e54 <myproc>
    80004844:	fec42783          	lw	a5,-20(s0)
    80004848:	07e9                	addi	a5,a5,26
    8000484a:	078e                	slli	a5,a5,0x3
    8000484c:	953e                	add	a0,a0,a5
    8000484e:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004852:	fe043503          	ld	a0,-32(s0)
    80004856:	fffff097          	auipc	ra,0xfffff
    8000485a:	260080e7          	jalr	608(ra) # 80003ab6 <fileclose>
  return 0;
    8000485e:	4781                	li	a5,0
}
    80004860:	853e                	mv	a0,a5
    80004862:	60e2                	ld	ra,24(sp)
    80004864:	6442                	ld	s0,16(sp)
    80004866:	6105                	addi	sp,sp,32
    80004868:	8082                	ret

000000008000486a <sys_fstat>:
uint64 sys_fstat(void) {
    8000486a:	1101                	addi	sp,sp,-32
    8000486c:	ec06                	sd	ra,24(sp)
    8000486e:	e822                	sd	s0,16(sp)
    80004870:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004872:	fe040593          	addi	a1,s0,-32
    80004876:	4505                	li	a0,1
    80004878:	ffffd097          	auipc	ra,0xffffd
    8000487c:	7fa080e7          	jalr	2042(ra) # 80002072 <argaddr>
  if (argfd(0, 0, &f) < 0) return -1;
    80004880:	fe840613          	addi	a2,s0,-24
    80004884:	4581                	li	a1,0
    80004886:	4501                	li	a0,0
    80004888:	00000097          	auipc	ra,0x0
    8000488c:	c66080e7          	jalr	-922(ra) # 800044ee <argfd>
    80004890:	87aa                	mv	a5,a0
    80004892:	557d                	li	a0,-1
    80004894:	0007ca63          	bltz	a5,800048a8 <sys_fstat+0x3e>
  return filestat(f, st);
    80004898:	fe043583          	ld	a1,-32(s0)
    8000489c:	fe843503          	ld	a0,-24(s0)
    800048a0:	fffff097          	auipc	ra,0xfffff
    800048a4:	2de080e7          	jalr	734(ra) # 80003b7e <filestat>
}
    800048a8:	60e2                	ld	ra,24(sp)
    800048aa:	6442                	ld	s0,16(sp)
    800048ac:	6105                	addi	sp,sp,32
    800048ae:	8082                	ret

00000000800048b0 <sys_link>:
uint64 sys_link(void) {
    800048b0:	7169                	addi	sp,sp,-304
    800048b2:	f606                	sd	ra,296(sp)
    800048b4:	f222                	sd	s0,288(sp)
    800048b6:	ee26                	sd	s1,280(sp)
    800048b8:	ea4a                	sd	s2,272(sp)
    800048ba:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0) return -1;
    800048bc:	08000613          	li	a2,128
    800048c0:	ed040593          	addi	a1,s0,-304
    800048c4:	4501                	li	a0,0
    800048c6:	ffffd097          	auipc	ra,0xffffd
    800048ca:	7cc080e7          	jalr	1996(ra) # 80002092 <argstr>
    800048ce:	57fd                	li	a5,-1
    800048d0:	10054e63          	bltz	a0,800049ec <sys_link+0x13c>
    800048d4:	08000613          	li	a2,128
    800048d8:	f5040593          	addi	a1,s0,-176
    800048dc:	4505                	li	a0,1
    800048de:	ffffd097          	auipc	ra,0xffffd
    800048e2:	7b4080e7          	jalr	1972(ra) # 80002092 <argstr>
    800048e6:	57fd                	li	a5,-1
    800048e8:	10054263          	bltz	a0,800049ec <sys_link+0x13c>
  begin_op();
    800048ec:	fffff097          	auipc	ra,0xfffff
    800048f0:	d02080e7          	jalr	-766(ra) # 800035ee <begin_op>
  if ((ip = namei(old)) == 0) {
    800048f4:	ed040513          	addi	a0,s0,-304
    800048f8:	fffff097          	auipc	ra,0xfffff
    800048fc:	ad6080e7          	jalr	-1322(ra) # 800033ce <namei>
    80004900:	84aa                	mv	s1,a0
    80004902:	c551                	beqz	a0,8000498e <sys_link+0xde>
  ilock(ip);
    80004904:	ffffe097          	auipc	ra,0xffffe
    80004908:	31e080e7          	jalr	798(ra) # 80002c22 <ilock>
  if (ip->type == T_DIR) {
    8000490c:	04449703          	lh	a4,68(s1)
    80004910:	4785                	li	a5,1
    80004912:	08f70463          	beq	a4,a5,8000499a <sys_link+0xea>
  ip->nlink++;
    80004916:	04a4d783          	lhu	a5,74(s1)
    8000491a:	2785                	addiw	a5,a5,1
    8000491c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004920:	8526                	mv	a0,s1
    80004922:	ffffe097          	auipc	ra,0xffffe
    80004926:	234080e7          	jalr	564(ra) # 80002b56 <iupdate>
  iunlock(ip);
    8000492a:	8526                	mv	a0,s1
    8000492c:	ffffe097          	auipc	ra,0xffffe
    80004930:	3b8080e7          	jalr	952(ra) # 80002ce4 <iunlock>
  if ((dp = nameiparent(new, name)) == 0) goto bad;
    80004934:	fd040593          	addi	a1,s0,-48
    80004938:	f5040513          	addi	a0,s0,-176
    8000493c:	fffff097          	auipc	ra,0xfffff
    80004940:	ab0080e7          	jalr	-1360(ra) # 800033ec <nameiparent>
    80004944:	892a                	mv	s2,a0
    80004946:	c935                	beqz	a0,800049ba <sys_link+0x10a>
  ilock(dp);
    80004948:	ffffe097          	auipc	ra,0xffffe
    8000494c:	2da080e7          	jalr	730(ra) # 80002c22 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    80004950:	00092703          	lw	a4,0(s2)
    80004954:	409c                	lw	a5,0(s1)
    80004956:	04f71d63          	bne	a4,a5,800049b0 <sys_link+0x100>
    8000495a:	40d0                	lw	a2,4(s1)
    8000495c:	fd040593          	addi	a1,s0,-48
    80004960:	854a                	mv	a0,s2
    80004962:	fffff097          	auipc	ra,0xfffff
    80004966:	9ba080e7          	jalr	-1606(ra) # 8000331c <dirlink>
    8000496a:	04054363          	bltz	a0,800049b0 <sys_link+0x100>
  iunlockput(dp);
    8000496e:	854a                	mv	a0,s2
    80004970:	ffffe097          	auipc	ra,0xffffe
    80004974:	514080e7          	jalr	1300(ra) # 80002e84 <iunlockput>
  iput(ip);
    80004978:	8526                	mv	a0,s1
    8000497a:	ffffe097          	auipc	ra,0xffffe
    8000497e:	462080e7          	jalr	1122(ra) # 80002ddc <iput>
  end_op();
    80004982:	fffff097          	auipc	ra,0xfffff
    80004986:	cea080e7          	jalr	-790(ra) # 8000366c <end_op>
  return 0;
    8000498a:	4781                	li	a5,0
    8000498c:	a085                	j	800049ec <sys_link+0x13c>
    end_op();
    8000498e:	fffff097          	auipc	ra,0xfffff
    80004992:	cde080e7          	jalr	-802(ra) # 8000366c <end_op>
    return -1;
    80004996:	57fd                	li	a5,-1
    80004998:	a891                	j	800049ec <sys_link+0x13c>
    iunlockput(ip);
    8000499a:	8526                	mv	a0,s1
    8000499c:	ffffe097          	auipc	ra,0xffffe
    800049a0:	4e8080e7          	jalr	1256(ra) # 80002e84 <iunlockput>
    end_op();
    800049a4:	fffff097          	auipc	ra,0xfffff
    800049a8:	cc8080e7          	jalr	-824(ra) # 8000366c <end_op>
    return -1;
    800049ac:	57fd                	li	a5,-1
    800049ae:	a83d                	j	800049ec <sys_link+0x13c>
    iunlockput(dp);
    800049b0:	854a                	mv	a0,s2
    800049b2:	ffffe097          	auipc	ra,0xffffe
    800049b6:	4d2080e7          	jalr	1234(ra) # 80002e84 <iunlockput>
  ilock(ip);
    800049ba:	8526                	mv	a0,s1
    800049bc:	ffffe097          	auipc	ra,0xffffe
    800049c0:	266080e7          	jalr	614(ra) # 80002c22 <ilock>
  ip->nlink--;
    800049c4:	04a4d783          	lhu	a5,74(s1)
    800049c8:	37fd                	addiw	a5,a5,-1
    800049ca:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049ce:	8526                	mv	a0,s1
    800049d0:	ffffe097          	auipc	ra,0xffffe
    800049d4:	186080e7          	jalr	390(ra) # 80002b56 <iupdate>
  iunlockput(ip);
    800049d8:	8526                	mv	a0,s1
    800049da:	ffffe097          	auipc	ra,0xffffe
    800049de:	4aa080e7          	jalr	1194(ra) # 80002e84 <iunlockput>
  end_op();
    800049e2:	fffff097          	auipc	ra,0xfffff
    800049e6:	c8a080e7          	jalr	-886(ra) # 8000366c <end_op>
  return -1;
    800049ea:	57fd                	li	a5,-1
}
    800049ec:	853e                	mv	a0,a5
    800049ee:	70b2                	ld	ra,296(sp)
    800049f0:	7412                	ld	s0,288(sp)
    800049f2:	64f2                	ld	s1,280(sp)
    800049f4:	6952                	ld	s2,272(sp)
    800049f6:	6155                	addi	sp,sp,304
    800049f8:	8082                	ret

00000000800049fa <sys_unlink>:
uint64 sys_unlink(void) {
    800049fa:	7151                	addi	sp,sp,-240
    800049fc:	f586                	sd	ra,232(sp)
    800049fe:	f1a2                	sd	s0,224(sp)
    80004a00:	eda6                	sd	s1,216(sp)
    80004a02:	e9ca                	sd	s2,208(sp)
    80004a04:	e5ce                	sd	s3,200(sp)
    80004a06:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0) return -1;
    80004a08:	08000613          	li	a2,128
    80004a0c:	f3040593          	addi	a1,s0,-208
    80004a10:	4501                	li	a0,0
    80004a12:	ffffd097          	auipc	ra,0xffffd
    80004a16:	680080e7          	jalr	1664(ra) # 80002092 <argstr>
    80004a1a:	18054163          	bltz	a0,80004b9c <sys_unlink+0x1a2>
  begin_op();
    80004a1e:	fffff097          	auipc	ra,0xfffff
    80004a22:	bd0080e7          	jalr	-1072(ra) # 800035ee <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
    80004a26:	fb040593          	addi	a1,s0,-80
    80004a2a:	f3040513          	addi	a0,s0,-208
    80004a2e:	fffff097          	auipc	ra,0xfffff
    80004a32:	9be080e7          	jalr	-1602(ra) # 800033ec <nameiparent>
    80004a36:	84aa                	mv	s1,a0
    80004a38:	c979                	beqz	a0,80004b0e <sys_unlink+0x114>
  ilock(dp);
    80004a3a:	ffffe097          	auipc	ra,0xffffe
    80004a3e:	1e8080e7          	jalr	488(ra) # 80002c22 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0) goto bad;
    80004a42:	00004597          	auipc	a1,0x4
    80004a46:	c4e58593          	addi	a1,a1,-946 # 80008690 <syscalls+0x2b0>
    80004a4a:	fb040513          	addi	a0,s0,-80
    80004a4e:	ffffe097          	auipc	ra,0xffffe
    80004a52:	69e080e7          	jalr	1694(ra) # 800030ec <namecmp>
    80004a56:	14050a63          	beqz	a0,80004baa <sys_unlink+0x1b0>
    80004a5a:	00004597          	auipc	a1,0x4
    80004a5e:	c3e58593          	addi	a1,a1,-962 # 80008698 <syscalls+0x2b8>
    80004a62:	fb040513          	addi	a0,s0,-80
    80004a66:	ffffe097          	auipc	ra,0xffffe
    80004a6a:	686080e7          	jalr	1670(ra) # 800030ec <namecmp>
    80004a6e:	12050e63          	beqz	a0,80004baa <sys_unlink+0x1b0>
  if ((ip = dirlookup(dp, name, &off)) == 0) goto bad;
    80004a72:	f2c40613          	addi	a2,s0,-212
    80004a76:	fb040593          	addi	a1,s0,-80
    80004a7a:	8526                	mv	a0,s1
    80004a7c:	ffffe097          	auipc	ra,0xffffe
    80004a80:	68a080e7          	jalr	1674(ra) # 80003106 <dirlookup>
    80004a84:	892a                	mv	s2,a0
    80004a86:	12050263          	beqz	a0,80004baa <sys_unlink+0x1b0>
  ilock(ip);
    80004a8a:	ffffe097          	auipc	ra,0xffffe
    80004a8e:	198080e7          	jalr	408(ra) # 80002c22 <ilock>
  if (ip->nlink < 1) panic("unlink: nlink < 1");
    80004a92:	04a91783          	lh	a5,74(s2)
    80004a96:	08f05263          	blez	a5,80004b1a <sys_unlink+0x120>
  if (ip->type == T_DIR && !isdirempty(ip)) {
    80004a9a:	04491703          	lh	a4,68(s2)
    80004a9e:	4785                	li	a5,1
    80004aa0:	08f70563          	beq	a4,a5,80004b2a <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004aa4:	4641                	li	a2,16
    80004aa6:	4581                	li	a1,0
    80004aa8:	fc040513          	addi	a0,s0,-64
    80004aac:	ffffb097          	auipc	ra,0xffffb
    80004ab0:	6ce080e7          	jalr	1742(ra) # 8000017a <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ab4:	4741                	li	a4,16
    80004ab6:	f2c42683          	lw	a3,-212(s0)
    80004aba:	fc040613          	addi	a2,s0,-64
    80004abe:	4581                	li	a1,0
    80004ac0:	8526                	mv	a0,s1
    80004ac2:	ffffe097          	auipc	ra,0xffffe
    80004ac6:	50c080e7          	jalr	1292(ra) # 80002fce <writei>
    80004aca:	47c1                	li	a5,16
    80004acc:	0af51563          	bne	a0,a5,80004b76 <sys_unlink+0x17c>
  if (ip->type == T_DIR) {
    80004ad0:	04491703          	lh	a4,68(s2)
    80004ad4:	4785                	li	a5,1
    80004ad6:	0af70863          	beq	a4,a5,80004b86 <sys_unlink+0x18c>
  iunlockput(dp);
    80004ada:	8526                	mv	a0,s1
    80004adc:	ffffe097          	auipc	ra,0xffffe
    80004ae0:	3a8080e7          	jalr	936(ra) # 80002e84 <iunlockput>
  ip->nlink--;
    80004ae4:	04a95783          	lhu	a5,74(s2)
    80004ae8:	37fd                	addiw	a5,a5,-1
    80004aea:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004aee:	854a                	mv	a0,s2
    80004af0:	ffffe097          	auipc	ra,0xffffe
    80004af4:	066080e7          	jalr	102(ra) # 80002b56 <iupdate>
  iunlockput(ip);
    80004af8:	854a                	mv	a0,s2
    80004afa:	ffffe097          	auipc	ra,0xffffe
    80004afe:	38a080e7          	jalr	906(ra) # 80002e84 <iunlockput>
  end_op();
    80004b02:	fffff097          	auipc	ra,0xfffff
    80004b06:	b6a080e7          	jalr	-1174(ra) # 8000366c <end_op>
  return 0;
    80004b0a:	4501                	li	a0,0
    80004b0c:	a84d                	j	80004bbe <sys_unlink+0x1c4>
    end_op();
    80004b0e:	fffff097          	auipc	ra,0xfffff
    80004b12:	b5e080e7          	jalr	-1186(ra) # 8000366c <end_op>
    return -1;
    80004b16:	557d                	li	a0,-1
    80004b18:	a05d                	j	80004bbe <sys_unlink+0x1c4>
  if (ip->nlink < 1) panic("unlink: nlink < 1");
    80004b1a:	00004517          	auipc	a0,0x4
    80004b1e:	b8650513          	addi	a0,a0,-1146 # 800086a0 <syscalls+0x2c0>
    80004b22:	00001097          	auipc	ra,0x1
    80004b26:	1ba080e7          	jalr	442(ra) # 80005cdc <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004b2a:	04c92703          	lw	a4,76(s2)
    80004b2e:	02000793          	li	a5,32
    80004b32:	f6e7f9e3          	bgeu	a5,a4,80004aa4 <sys_unlink+0xaa>
    80004b36:	02000993          	li	s3,32
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b3a:	4741                	li	a4,16
    80004b3c:	86ce                	mv	a3,s3
    80004b3e:	f1840613          	addi	a2,s0,-232
    80004b42:	4581                	li	a1,0
    80004b44:	854a                	mv	a0,s2
    80004b46:	ffffe097          	auipc	ra,0xffffe
    80004b4a:	390080e7          	jalr	912(ra) # 80002ed6 <readi>
    80004b4e:	47c1                	li	a5,16
    80004b50:	00f51b63          	bne	a0,a5,80004b66 <sys_unlink+0x16c>
    if (de.inum != 0) return 0;
    80004b54:	f1845783          	lhu	a5,-232(s0)
    80004b58:	e7a1                	bnez	a5,80004ba0 <sys_unlink+0x1a6>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004b5a:	29c1                	addiw	s3,s3,16
    80004b5c:	04c92783          	lw	a5,76(s2)
    80004b60:	fcf9ede3          	bltu	s3,a5,80004b3a <sys_unlink+0x140>
    80004b64:	b781                	j	80004aa4 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b66:	00004517          	auipc	a0,0x4
    80004b6a:	b5250513          	addi	a0,a0,-1198 # 800086b8 <syscalls+0x2d8>
    80004b6e:	00001097          	auipc	ra,0x1
    80004b72:	16e080e7          	jalr	366(ra) # 80005cdc <panic>
    panic("unlink: writei");
    80004b76:	00004517          	auipc	a0,0x4
    80004b7a:	b5a50513          	addi	a0,a0,-1190 # 800086d0 <syscalls+0x2f0>
    80004b7e:	00001097          	auipc	ra,0x1
    80004b82:	15e080e7          	jalr	350(ra) # 80005cdc <panic>
    dp->nlink--;
    80004b86:	04a4d783          	lhu	a5,74(s1)
    80004b8a:	37fd                	addiw	a5,a5,-1
    80004b8c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b90:	8526                	mv	a0,s1
    80004b92:	ffffe097          	auipc	ra,0xffffe
    80004b96:	fc4080e7          	jalr	-60(ra) # 80002b56 <iupdate>
    80004b9a:	b781                	j	80004ada <sys_unlink+0xe0>
  if (argstr(0, path, MAXPATH) < 0) return -1;
    80004b9c:	557d                	li	a0,-1
    80004b9e:	a005                	j	80004bbe <sys_unlink+0x1c4>
    iunlockput(ip);
    80004ba0:	854a                	mv	a0,s2
    80004ba2:	ffffe097          	auipc	ra,0xffffe
    80004ba6:	2e2080e7          	jalr	738(ra) # 80002e84 <iunlockput>
  iunlockput(dp);
    80004baa:	8526                	mv	a0,s1
    80004bac:	ffffe097          	auipc	ra,0xffffe
    80004bb0:	2d8080e7          	jalr	728(ra) # 80002e84 <iunlockput>
  end_op();
    80004bb4:	fffff097          	auipc	ra,0xfffff
    80004bb8:	ab8080e7          	jalr	-1352(ra) # 8000366c <end_op>
  return -1;
    80004bbc:	557d                	li	a0,-1
}
    80004bbe:	70ae                	ld	ra,232(sp)
    80004bc0:	740e                	ld	s0,224(sp)
    80004bc2:	64ee                	ld	s1,216(sp)
    80004bc4:	694e                	ld	s2,208(sp)
    80004bc6:	69ae                	ld	s3,200(sp)
    80004bc8:	616d                	addi	sp,sp,240
    80004bca:	8082                	ret

0000000080004bcc <sys_open>:

uint64 sys_open(void) {
    80004bcc:	7131                	addi	sp,sp,-192
    80004bce:	fd06                	sd	ra,184(sp)
    80004bd0:	f922                	sd	s0,176(sp)
    80004bd2:	f526                	sd	s1,168(sp)
    80004bd4:	f14a                	sd	s2,160(sp)
    80004bd6:	ed4e                	sd	s3,152(sp)
    80004bd8:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004bda:	f4c40593          	addi	a1,s0,-180
    80004bde:	4505                	li	a0,1
    80004be0:	ffffd097          	auipc	ra,0xffffd
    80004be4:	472080e7          	jalr	1138(ra) # 80002052 <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0) return -1;
    80004be8:	08000613          	li	a2,128
    80004bec:	f5040593          	addi	a1,s0,-176
    80004bf0:	4501                	li	a0,0
    80004bf2:	ffffd097          	auipc	ra,0xffffd
    80004bf6:	4a0080e7          	jalr	1184(ra) # 80002092 <argstr>
    80004bfa:	87aa                	mv	a5,a0
    80004bfc:	557d                	li	a0,-1
    80004bfe:	0a07c963          	bltz	a5,80004cb0 <sys_open+0xe4>

  begin_op();
    80004c02:	fffff097          	auipc	ra,0xfffff
    80004c06:	9ec080e7          	jalr	-1556(ra) # 800035ee <begin_op>

  if (omode & O_CREATE) {
    80004c0a:	f4c42783          	lw	a5,-180(s0)
    80004c0e:	2007f793          	andi	a5,a5,512
    80004c12:	cfc5                	beqz	a5,80004cca <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c14:	4681                	li	a3,0
    80004c16:	4601                	li	a2,0
    80004c18:	4589                	li	a1,2
    80004c1a:	f5040513          	addi	a0,s0,-176
    80004c1e:	00000097          	auipc	ra,0x0
    80004c22:	972080e7          	jalr	-1678(ra) # 80004590 <create>
    80004c26:	84aa                	mv	s1,a0
    if (ip == 0) {
    80004c28:	c959                	beqz	a0,80004cbe <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    80004c2a:	04449703          	lh	a4,68(s1)
    80004c2e:	478d                	li	a5,3
    80004c30:	00f71763          	bne	a4,a5,80004c3e <sys_open+0x72>
    80004c34:	0464d703          	lhu	a4,70(s1)
    80004c38:	47a5                	li	a5,9
    80004c3a:	0ce7ed63          	bltu	a5,a4,80004d14 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80004c3e:	fffff097          	auipc	ra,0xfffff
    80004c42:	dbc080e7          	jalr	-580(ra) # 800039fa <filealloc>
    80004c46:	89aa                	mv	s3,a0
    80004c48:	10050363          	beqz	a0,80004d4e <sys_open+0x182>
    80004c4c:	00000097          	auipc	ra,0x0
    80004c50:	902080e7          	jalr	-1790(ra) # 8000454e <fdalloc>
    80004c54:	892a                	mv	s2,a0
    80004c56:	0e054763          	bltz	a0,80004d44 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE) {
    80004c5a:	04449703          	lh	a4,68(s1)
    80004c5e:	478d                	li	a5,3
    80004c60:	0cf70563          	beq	a4,a5,80004d2a <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c64:	4789                	li	a5,2
    80004c66:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004c6a:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004c6e:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c72:	f4c42783          	lw	a5,-180(s0)
    80004c76:	0017c713          	xori	a4,a5,1
    80004c7a:	8b05                	andi	a4,a4,1
    80004c7c:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c80:	0037f713          	andi	a4,a5,3
    80004c84:	00e03733          	snez	a4,a4
    80004c88:	00e984a3          	sb	a4,9(s3)

  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    80004c8c:	4007f793          	andi	a5,a5,1024
    80004c90:	c791                	beqz	a5,80004c9c <sys_open+0xd0>
    80004c92:	04449703          	lh	a4,68(s1)
    80004c96:	4789                	li	a5,2
    80004c98:	0af70063          	beq	a4,a5,80004d38 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c9c:	8526                	mv	a0,s1
    80004c9e:	ffffe097          	auipc	ra,0xffffe
    80004ca2:	046080e7          	jalr	70(ra) # 80002ce4 <iunlock>
  end_op();
    80004ca6:	fffff097          	auipc	ra,0xfffff
    80004caa:	9c6080e7          	jalr	-1594(ra) # 8000366c <end_op>

  return fd;
    80004cae:	854a                	mv	a0,s2
}
    80004cb0:	70ea                	ld	ra,184(sp)
    80004cb2:	744a                	ld	s0,176(sp)
    80004cb4:	74aa                	ld	s1,168(sp)
    80004cb6:	790a                	ld	s2,160(sp)
    80004cb8:	69ea                	ld	s3,152(sp)
    80004cba:	6129                	addi	sp,sp,192
    80004cbc:	8082                	ret
      end_op();
    80004cbe:	fffff097          	auipc	ra,0xfffff
    80004cc2:	9ae080e7          	jalr	-1618(ra) # 8000366c <end_op>
      return -1;
    80004cc6:	557d                	li	a0,-1
    80004cc8:	b7e5                	j	80004cb0 <sys_open+0xe4>
    if ((ip = namei(path)) == 0) {
    80004cca:	f5040513          	addi	a0,s0,-176
    80004cce:	ffffe097          	auipc	ra,0xffffe
    80004cd2:	700080e7          	jalr	1792(ra) # 800033ce <namei>
    80004cd6:	84aa                	mv	s1,a0
    80004cd8:	c905                	beqz	a0,80004d08 <sys_open+0x13c>
    ilock(ip);
    80004cda:	ffffe097          	auipc	ra,0xffffe
    80004cde:	f48080e7          	jalr	-184(ra) # 80002c22 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY) {
    80004ce2:	04449703          	lh	a4,68(s1)
    80004ce6:	4785                	li	a5,1
    80004ce8:	f4f711e3          	bne	a4,a5,80004c2a <sys_open+0x5e>
    80004cec:	f4c42783          	lw	a5,-180(s0)
    80004cf0:	d7b9                	beqz	a5,80004c3e <sys_open+0x72>
      iunlockput(ip);
    80004cf2:	8526                	mv	a0,s1
    80004cf4:	ffffe097          	auipc	ra,0xffffe
    80004cf8:	190080e7          	jalr	400(ra) # 80002e84 <iunlockput>
      end_op();
    80004cfc:	fffff097          	auipc	ra,0xfffff
    80004d00:	970080e7          	jalr	-1680(ra) # 8000366c <end_op>
      return -1;
    80004d04:	557d                	li	a0,-1
    80004d06:	b76d                	j	80004cb0 <sys_open+0xe4>
      end_op();
    80004d08:	fffff097          	auipc	ra,0xfffff
    80004d0c:	964080e7          	jalr	-1692(ra) # 8000366c <end_op>
      return -1;
    80004d10:	557d                	li	a0,-1
    80004d12:	bf79                	j	80004cb0 <sys_open+0xe4>
    iunlockput(ip);
    80004d14:	8526                	mv	a0,s1
    80004d16:	ffffe097          	auipc	ra,0xffffe
    80004d1a:	16e080e7          	jalr	366(ra) # 80002e84 <iunlockput>
    end_op();
    80004d1e:	fffff097          	auipc	ra,0xfffff
    80004d22:	94e080e7          	jalr	-1714(ra) # 8000366c <end_op>
    return -1;
    80004d26:	557d                	li	a0,-1
    80004d28:	b761                	j	80004cb0 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004d2a:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004d2e:	04649783          	lh	a5,70(s1)
    80004d32:	02f99223          	sh	a5,36(s3)
    80004d36:	bf25                	j	80004c6e <sys_open+0xa2>
    itrunc(ip);
    80004d38:	8526                	mv	a0,s1
    80004d3a:	ffffe097          	auipc	ra,0xffffe
    80004d3e:	ff6080e7          	jalr	-10(ra) # 80002d30 <itrunc>
    80004d42:	bfa9                	j	80004c9c <sys_open+0xd0>
    if (f) fileclose(f);
    80004d44:	854e                	mv	a0,s3
    80004d46:	fffff097          	auipc	ra,0xfffff
    80004d4a:	d70080e7          	jalr	-656(ra) # 80003ab6 <fileclose>
    iunlockput(ip);
    80004d4e:	8526                	mv	a0,s1
    80004d50:	ffffe097          	auipc	ra,0xffffe
    80004d54:	134080e7          	jalr	308(ra) # 80002e84 <iunlockput>
    end_op();
    80004d58:	fffff097          	auipc	ra,0xfffff
    80004d5c:	914080e7          	jalr	-1772(ra) # 8000366c <end_op>
    return -1;
    80004d60:	557d                	li	a0,-1
    80004d62:	b7b9                	j	80004cb0 <sys_open+0xe4>

0000000080004d64 <sys_mkdir>:

uint64 sys_mkdir(void) {
    80004d64:	7175                	addi	sp,sp,-144
    80004d66:	e506                	sd	ra,136(sp)
    80004d68:	e122                	sd	s0,128(sp)
    80004d6a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d6c:	fffff097          	auipc	ra,0xfffff
    80004d70:	882080e7          	jalr	-1918(ra) # 800035ee <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    80004d74:	08000613          	li	a2,128
    80004d78:	f7040593          	addi	a1,s0,-144
    80004d7c:	4501                	li	a0,0
    80004d7e:	ffffd097          	auipc	ra,0xffffd
    80004d82:	314080e7          	jalr	788(ra) # 80002092 <argstr>
    80004d86:	02054963          	bltz	a0,80004db8 <sys_mkdir+0x54>
    80004d8a:	4681                	li	a3,0
    80004d8c:	4601                	li	a2,0
    80004d8e:	4585                	li	a1,1
    80004d90:	f7040513          	addi	a0,s0,-144
    80004d94:	fffff097          	auipc	ra,0xfffff
    80004d98:	7fc080e7          	jalr	2044(ra) # 80004590 <create>
    80004d9c:	cd11                	beqz	a0,80004db8 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d9e:	ffffe097          	auipc	ra,0xffffe
    80004da2:	0e6080e7          	jalr	230(ra) # 80002e84 <iunlockput>
  end_op();
    80004da6:	fffff097          	auipc	ra,0xfffff
    80004daa:	8c6080e7          	jalr	-1850(ra) # 8000366c <end_op>
  return 0;
    80004dae:	4501                	li	a0,0
}
    80004db0:	60aa                	ld	ra,136(sp)
    80004db2:	640a                	ld	s0,128(sp)
    80004db4:	6149                	addi	sp,sp,144
    80004db6:	8082                	ret
    end_op();
    80004db8:	fffff097          	auipc	ra,0xfffff
    80004dbc:	8b4080e7          	jalr	-1868(ra) # 8000366c <end_op>
    return -1;
    80004dc0:	557d                	li	a0,-1
    80004dc2:	b7fd                	j	80004db0 <sys_mkdir+0x4c>

0000000080004dc4 <sys_mknod>:

uint64 sys_mknod(void) {
    80004dc4:	7135                	addi	sp,sp,-160
    80004dc6:	ed06                	sd	ra,152(sp)
    80004dc8:	e922                	sd	s0,144(sp)
    80004dca:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004dcc:	fffff097          	auipc	ra,0xfffff
    80004dd0:	822080e7          	jalr	-2014(ra) # 800035ee <begin_op>
  argint(1, &major);
    80004dd4:	f6c40593          	addi	a1,s0,-148
    80004dd8:	4505                	li	a0,1
    80004dda:	ffffd097          	auipc	ra,0xffffd
    80004dde:	278080e7          	jalr	632(ra) # 80002052 <argint>
  argint(2, &minor);
    80004de2:	f6840593          	addi	a1,s0,-152
    80004de6:	4509                	li	a0,2
    80004de8:	ffffd097          	auipc	ra,0xffffd
    80004dec:	26a080e7          	jalr	618(ra) # 80002052 <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004df0:	08000613          	li	a2,128
    80004df4:	f7040593          	addi	a1,s0,-144
    80004df8:	4501                	li	a0,0
    80004dfa:	ffffd097          	auipc	ra,0xffffd
    80004dfe:	298080e7          	jalr	664(ra) # 80002092 <argstr>
    80004e02:	02054b63          	bltz	a0,80004e38 <sys_mknod+0x74>
      (ip = create(path, T_DEVICE, major, minor)) == 0) {
    80004e06:	f6841683          	lh	a3,-152(s0)
    80004e0a:	f6c41603          	lh	a2,-148(s0)
    80004e0e:	458d                	li	a1,3
    80004e10:	f7040513          	addi	a0,s0,-144
    80004e14:	fffff097          	auipc	ra,0xfffff
    80004e18:	77c080e7          	jalr	1916(ra) # 80004590 <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004e1c:	cd11                	beqz	a0,80004e38 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e1e:	ffffe097          	auipc	ra,0xffffe
    80004e22:	066080e7          	jalr	102(ra) # 80002e84 <iunlockput>
  end_op();
    80004e26:	fffff097          	auipc	ra,0xfffff
    80004e2a:	846080e7          	jalr	-1978(ra) # 8000366c <end_op>
  return 0;
    80004e2e:	4501                	li	a0,0
}
    80004e30:	60ea                	ld	ra,152(sp)
    80004e32:	644a                	ld	s0,144(sp)
    80004e34:	610d                	addi	sp,sp,160
    80004e36:	8082                	ret
    end_op();
    80004e38:	fffff097          	auipc	ra,0xfffff
    80004e3c:	834080e7          	jalr	-1996(ra) # 8000366c <end_op>
    return -1;
    80004e40:	557d                	li	a0,-1
    80004e42:	b7fd                	j	80004e30 <sys_mknod+0x6c>

0000000080004e44 <sys_chdir>:

uint64 sys_chdir(void) {
    80004e44:	7135                	addi	sp,sp,-160
    80004e46:	ed06                	sd	ra,152(sp)
    80004e48:	e922                	sd	s0,144(sp)
    80004e4a:	e526                	sd	s1,136(sp)
    80004e4c:	e14a                	sd	s2,128(sp)
    80004e4e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e50:	ffffc097          	auipc	ra,0xffffc
    80004e54:	004080e7          	jalr	4(ra) # 80000e54 <myproc>
    80004e58:	892a                	mv	s2,a0

  begin_op();
    80004e5a:	ffffe097          	auipc	ra,0xffffe
    80004e5e:	794080e7          	jalr	1940(ra) # 800035ee <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    80004e62:	08000613          	li	a2,128
    80004e66:	f6040593          	addi	a1,s0,-160
    80004e6a:	4501                	li	a0,0
    80004e6c:	ffffd097          	auipc	ra,0xffffd
    80004e70:	226080e7          	jalr	550(ra) # 80002092 <argstr>
    80004e74:	04054b63          	bltz	a0,80004eca <sys_chdir+0x86>
    80004e78:	f6040513          	addi	a0,s0,-160
    80004e7c:	ffffe097          	auipc	ra,0xffffe
    80004e80:	552080e7          	jalr	1362(ra) # 800033ce <namei>
    80004e84:	84aa                	mv	s1,a0
    80004e86:	c131                	beqz	a0,80004eca <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e88:	ffffe097          	auipc	ra,0xffffe
    80004e8c:	d9a080e7          	jalr	-614(ra) # 80002c22 <ilock>
  if (ip->type != T_DIR) {
    80004e90:	04449703          	lh	a4,68(s1)
    80004e94:	4785                	li	a5,1
    80004e96:	04f71063          	bne	a4,a5,80004ed6 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e9a:	8526                	mv	a0,s1
    80004e9c:	ffffe097          	auipc	ra,0xffffe
    80004ea0:	e48080e7          	jalr	-440(ra) # 80002ce4 <iunlock>
  iput(p->cwd);
    80004ea4:	15093503          	ld	a0,336(s2)
    80004ea8:	ffffe097          	auipc	ra,0xffffe
    80004eac:	f34080e7          	jalr	-204(ra) # 80002ddc <iput>
  end_op();
    80004eb0:	ffffe097          	auipc	ra,0xffffe
    80004eb4:	7bc080e7          	jalr	1980(ra) # 8000366c <end_op>
  p->cwd = ip;
    80004eb8:	14993823          	sd	s1,336(s2)
  return 0;
    80004ebc:	4501                	li	a0,0
}
    80004ebe:	60ea                	ld	ra,152(sp)
    80004ec0:	644a                	ld	s0,144(sp)
    80004ec2:	64aa                	ld	s1,136(sp)
    80004ec4:	690a                	ld	s2,128(sp)
    80004ec6:	610d                	addi	sp,sp,160
    80004ec8:	8082                	ret
    end_op();
    80004eca:	ffffe097          	auipc	ra,0xffffe
    80004ece:	7a2080e7          	jalr	1954(ra) # 8000366c <end_op>
    return -1;
    80004ed2:	557d                	li	a0,-1
    80004ed4:	b7ed                	j	80004ebe <sys_chdir+0x7a>
    iunlockput(ip);
    80004ed6:	8526                	mv	a0,s1
    80004ed8:	ffffe097          	auipc	ra,0xffffe
    80004edc:	fac080e7          	jalr	-84(ra) # 80002e84 <iunlockput>
    end_op();
    80004ee0:	ffffe097          	auipc	ra,0xffffe
    80004ee4:	78c080e7          	jalr	1932(ra) # 8000366c <end_op>
    return -1;
    80004ee8:	557d                	li	a0,-1
    80004eea:	bfd1                	j	80004ebe <sys_chdir+0x7a>

0000000080004eec <sys_exec>:

uint64 sys_exec(void) {
    80004eec:	7145                	addi	sp,sp,-464
    80004eee:	e786                	sd	ra,456(sp)
    80004ef0:	e3a2                	sd	s0,448(sp)
    80004ef2:	ff26                	sd	s1,440(sp)
    80004ef4:	fb4a                	sd	s2,432(sp)
    80004ef6:	f74e                	sd	s3,424(sp)
    80004ef8:	f352                	sd	s4,416(sp)
    80004efa:	ef56                	sd	s5,408(sp)
    80004efc:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004efe:	e3840593          	addi	a1,s0,-456
    80004f02:	4505                	li	a0,1
    80004f04:	ffffd097          	auipc	ra,0xffffd
    80004f08:	16e080e7          	jalr	366(ra) # 80002072 <argaddr>
  if (argstr(0, path, MAXPATH) < 0) {
    80004f0c:	08000613          	li	a2,128
    80004f10:	f4040593          	addi	a1,s0,-192
    80004f14:	4501                	li	a0,0
    80004f16:	ffffd097          	auipc	ra,0xffffd
    80004f1a:	17c080e7          	jalr	380(ra) # 80002092 <argstr>
    80004f1e:	87aa                	mv	a5,a0
    return -1;
    80004f20:	557d                	li	a0,-1
  if (argstr(0, path, MAXPATH) < 0) {
    80004f22:	0c07c363          	bltz	a5,80004fe8 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004f26:	10000613          	li	a2,256
    80004f2a:	4581                	li	a1,0
    80004f2c:	e4040513          	addi	a0,s0,-448
    80004f30:	ffffb097          	auipc	ra,0xffffb
    80004f34:	24a080e7          	jalr	586(ra) # 8000017a <memset>
  for (i = 0;; i++) {
    if (i >= NELEM(argv)) {
    80004f38:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004f3c:	89a6                	mv	s3,s1
    80004f3e:	4901                	li	s2,0
    if (i >= NELEM(argv)) {
    80004f40:	02000a13          	li	s4,32
    80004f44:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    80004f48:	00391513          	slli	a0,s2,0x3
    80004f4c:	e3040593          	addi	a1,s0,-464
    80004f50:	e3843783          	ld	a5,-456(s0)
    80004f54:	953e                	add	a0,a0,a5
    80004f56:	ffffd097          	auipc	ra,0xffffd
    80004f5a:	05e080e7          	jalr	94(ra) # 80001fb4 <fetchaddr>
    80004f5e:	02054a63          	bltz	a0,80004f92 <sys_exec+0xa6>
      goto bad;
    }
    if (uarg == 0) {
    80004f62:	e3043783          	ld	a5,-464(s0)
    80004f66:	c3b9                	beqz	a5,80004fac <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f68:	ffffb097          	auipc	ra,0xffffb
    80004f6c:	1b2080e7          	jalr	434(ra) # 8000011a <kalloc>
    80004f70:	85aa                	mv	a1,a0
    80004f72:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0) goto bad;
    80004f76:	cd11                	beqz	a0,80004f92 <sys_exec+0xa6>
    if (fetchstr(uarg, argv[i], PGSIZE) < 0) goto bad;
    80004f78:	6605                	lui	a2,0x1
    80004f7a:	e3043503          	ld	a0,-464(s0)
    80004f7e:	ffffd097          	auipc	ra,0xffffd
    80004f82:	088080e7          	jalr	136(ra) # 80002006 <fetchstr>
    80004f86:	00054663          	bltz	a0,80004f92 <sys_exec+0xa6>
    if (i >= NELEM(argv)) {
    80004f8a:	0905                	addi	s2,s2,1
    80004f8c:	09a1                	addi	s3,s3,8
    80004f8e:	fb491be3          	bne	s2,s4,80004f44 <sys_exec+0x58>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);
    80004f92:	f4040913          	addi	s2,s0,-192
    80004f96:	6088                	ld	a0,0(s1)
    80004f98:	c539                	beqz	a0,80004fe6 <sys_exec+0xfa>
    80004f9a:	ffffb097          	auipc	ra,0xffffb
    80004f9e:	082080e7          	jalr	130(ra) # 8000001c <kfree>
    80004fa2:	04a1                	addi	s1,s1,8
    80004fa4:	ff2499e3          	bne	s1,s2,80004f96 <sys_exec+0xaa>
  return -1;
    80004fa8:	557d                	li	a0,-1
    80004faa:	a83d                	j	80004fe8 <sys_exec+0xfc>
      argv[i] = 0;
    80004fac:	0a8e                	slli	s5,s5,0x3
    80004fae:	fc0a8793          	addi	a5,s5,-64
    80004fb2:	00878ab3          	add	s5,a5,s0
    80004fb6:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004fba:	e4040593          	addi	a1,s0,-448
    80004fbe:	f4040513          	addi	a0,s0,-192
    80004fc2:	fffff097          	auipc	ra,0xfffff
    80004fc6:	16e080e7          	jalr	366(ra) # 80004130 <exec>
    80004fca:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);
    80004fcc:	f4040993          	addi	s3,s0,-192
    80004fd0:	6088                	ld	a0,0(s1)
    80004fd2:	c901                	beqz	a0,80004fe2 <sys_exec+0xf6>
    80004fd4:	ffffb097          	auipc	ra,0xffffb
    80004fd8:	048080e7          	jalr	72(ra) # 8000001c <kfree>
    80004fdc:	04a1                	addi	s1,s1,8
    80004fde:	ff3499e3          	bne	s1,s3,80004fd0 <sys_exec+0xe4>
  return ret;
    80004fe2:	854a                	mv	a0,s2
    80004fe4:	a011                	j	80004fe8 <sys_exec+0xfc>
  return -1;
    80004fe6:	557d                	li	a0,-1
}
    80004fe8:	60be                	ld	ra,456(sp)
    80004fea:	641e                	ld	s0,448(sp)
    80004fec:	74fa                	ld	s1,440(sp)
    80004fee:	795a                	ld	s2,432(sp)
    80004ff0:	79ba                	ld	s3,424(sp)
    80004ff2:	7a1a                	ld	s4,416(sp)
    80004ff4:	6afa                	ld	s5,408(sp)
    80004ff6:	6179                	addi	sp,sp,464
    80004ff8:	8082                	ret

0000000080004ffa <sys_pipe>:

uint64 sys_pipe(void) {
    80004ffa:	7139                	addi	sp,sp,-64
    80004ffc:	fc06                	sd	ra,56(sp)
    80004ffe:	f822                	sd	s0,48(sp)
    80005000:	f426                	sd	s1,40(sp)
    80005002:	0080                	addi	s0,sp,64
  uint64 fdarray;  // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005004:	ffffc097          	auipc	ra,0xffffc
    80005008:	e50080e7          	jalr	-432(ra) # 80000e54 <myproc>
    8000500c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000500e:	fd840593          	addi	a1,s0,-40
    80005012:	4501                	li	a0,0
    80005014:	ffffd097          	auipc	ra,0xffffd
    80005018:	05e080e7          	jalr	94(ra) # 80002072 <argaddr>
  if (pipealloc(&rf, &wf) < 0) return -1;
    8000501c:	fc840593          	addi	a1,s0,-56
    80005020:	fd040513          	addi	a0,s0,-48
    80005024:	fffff097          	auipc	ra,0xfffff
    80005028:	dc2080e7          	jalr	-574(ra) # 80003de6 <pipealloc>
    8000502c:	57fd                	li	a5,-1
    8000502e:	0c054463          	bltz	a0,800050f6 <sys_pipe+0xfc>
  fd0 = -1;
    80005032:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    80005036:	fd043503          	ld	a0,-48(s0)
    8000503a:	fffff097          	auipc	ra,0xfffff
    8000503e:	514080e7          	jalr	1300(ra) # 8000454e <fdalloc>
    80005042:	fca42223          	sw	a0,-60(s0)
    80005046:	08054b63          	bltz	a0,800050dc <sys_pipe+0xe2>
    8000504a:	fc843503          	ld	a0,-56(s0)
    8000504e:	fffff097          	auipc	ra,0xfffff
    80005052:	500080e7          	jalr	1280(ra) # 8000454e <fdalloc>
    80005056:	fca42023          	sw	a0,-64(s0)
    8000505a:	06054863          	bltz	a0,800050ca <sys_pipe+0xd0>
    if (fd0 >= 0) p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    8000505e:	4691                	li	a3,4
    80005060:	fc440613          	addi	a2,s0,-60
    80005064:	fd843583          	ld	a1,-40(s0)
    80005068:	68a8                	ld	a0,80(s1)
    8000506a:	ffffc097          	auipc	ra,0xffffc
    8000506e:	aaa080e7          	jalr	-1366(ra) # 80000b14 <copyout>
    80005072:	02054063          	bltz	a0,80005092 <sys_pipe+0x98>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) <
    80005076:	4691                	li	a3,4
    80005078:	fc040613          	addi	a2,s0,-64
    8000507c:	fd843583          	ld	a1,-40(s0)
    80005080:	0591                	addi	a1,a1,4
    80005082:	68a8                	ld	a0,80(s1)
    80005084:	ffffc097          	auipc	ra,0xffffc
    80005088:	a90080e7          	jalr	-1392(ra) # 80000b14 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000508c:	4781                	li	a5,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    8000508e:	06055463          	bgez	a0,800050f6 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005092:	fc442783          	lw	a5,-60(s0)
    80005096:	07e9                	addi	a5,a5,26
    80005098:	078e                	slli	a5,a5,0x3
    8000509a:	97a6                	add	a5,a5,s1
    8000509c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800050a0:	fc042783          	lw	a5,-64(s0)
    800050a4:	07e9                	addi	a5,a5,26
    800050a6:	078e                	slli	a5,a5,0x3
    800050a8:	94be                	add	s1,s1,a5
    800050aa:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800050ae:	fd043503          	ld	a0,-48(s0)
    800050b2:	fffff097          	auipc	ra,0xfffff
    800050b6:	a04080e7          	jalr	-1532(ra) # 80003ab6 <fileclose>
    fileclose(wf);
    800050ba:	fc843503          	ld	a0,-56(s0)
    800050be:	fffff097          	auipc	ra,0xfffff
    800050c2:	9f8080e7          	jalr	-1544(ra) # 80003ab6 <fileclose>
    return -1;
    800050c6:	57fd                	li	a5,-1
    800050c8:	a03d                	j	800050f6 <sys_pipe+0xfc>
    if (fd0 >= 0) p->ofile[fd0] = 0;
    800050ca:	fc442783          	lw	a5,-60(s0)
    800050ce:	0007c763          	bltz	a5,800050dc <sys_pipe+0xe2>
    800050d2:	07e9                	addi	a5,a5,26
    800050d4:	078e                	slli	a5,a5,0x3
    800050d6:	97a6                	add	a5,a5,s1
    800050d8:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800050dc:	fd043503          	ld	a0,-48(s0)
    800050e0:	fffff097          	auipc	ra,0xfffff
    800050e4:	9d6080e7          	jalr	-1578(ra) # 80003ab6 <fileclose>
    fileclose(wf);
    800050e8:	fc843503          	ld	a0,-56(s0)
    800050ec:	fffff097          	auipc	ra,0xfffff
    800050f0:	9ca080e7          	jalr	-1590(ra) # 80003ab6 <fileclose>
    return -1;
    800050f4:	57fd                	li	a5,-1
}
    800050f6:	853e                	mv	a0,a5
    800050f8:	70e2                	ld	ra,56(sp)
    800050fa:	7442                	ld	s0,48(sp)
    800050fc:	74a2                	ld	s1,40(sp)
    800050fe:	6121                	addi	sp,sp,64
    80005100:	8082                	ret
	...

0000000080005110 <kernelvec>:
    80005110:	7111                	addi	sp,sp,-256
    80005112:	e006                	sd	ra,0(sp)
    80005114:	e40a                	sd	sp,8(sp)
    80005116:	e80e                	sd	gp,16(sp)
    80005118:	ec12                	sd	tp,24(sp)
    8000511a:	f016                	sd	t0,32(sp)
    8000511c:	f41a                	sd	t1,40(sp)
    8000511e:	f81e                	sd	t2,48(sp)
    80005120:	fc22                	sd	s0,56(sp)
    80005122:	e0a6                	sd	s1,64(sp)
    80005124:	e4aa                	sd	a0,72(sp)
    80005126:	e8ae                	sd	a1,80(sp)
    80005128:	ecb2                	sd	a2,88(sp)
    8000512a:	f0b6                	sd	a3,96(sp)
    8000512c:	f4ba                	sd	a4,104(sp)
    8000512e:	f8be                	sd	a5,112(sp)
    80005130:	fcc2                	sd	a6,120(sp)
    80005132:	e146                	sd	a7,128(sp)
    80005134:	e54a                	sd	s2,136(sp)
    80005136:	e94e                	sd	s3,144(sp)
    80005138:	ed52                	sd	s4,152(sp)
    8000513a:	f156                	sd	s5,160(sp)
    8000513c:	f55a                	sd	s6,168(sp)
    8000513e:	f95e                	sd	s7,176(sp)
    80005140:	fd62                	sd	s8,184(sp)
    80005142:	e1e6                	sd	s9,192(sp)
    80005144:	e5ea                	sd	s10,200(sp)
    80005146:	e9ee                	sd	s11,208(sp)
    80005148:	edf2                	sd	t3,216(sp)
    8000514a:	f1f6                	sd	t4,224(sp)
    8000514c:	f5fa                	sd	t5,232(sp)
    8000514e:	f9fe                	sd	t6,240(sp)
    80005150:	d31fc0ef          	jal	ra,80001e80 <kerneltrap>
    80005154:	6082                	ld	ra,0(sp)
    80005156:	6122                	ld	sp,8(sp)
    80005158:	61c2                	ld	gp,16(sp)
    8000515a:	7282                	ld	t0,32(sp)
    8000515c:	7322                	ld	t1,40(sp)
    8000515e:	73c2                	ld	t2,48(sp)
    80005160:	7462                	ld	s0,56(sp)
    80005162:	6486                	ld	s1,64(sp)
    80005164:	6526                	ld	a0,72(sp)
    80005166:	65c6                	ld	a1,80(sp)
    80005168:	6666                	ld	a2,88(sp)
    8000516a:	7686                	ld	a3,96(sp)
    8000516c:	7726                	ld	a4,104(sp)
    8000516e:	77c6                	ld	a5,112(sp)
    80005170:	7866                	ld	a6,120(sp)
    80005172:	688a                	ld	a7,128(sp)
    80005174:	692a                	ld	s2,136(sp)
    80005176:	69ca                	ld	s3,144(sp)
    80005178:	6a6a                	ld	s4,152(sp)
    8000517a:	7a8a                	ld	s5,160(sp)
    8000517c:	7b2a                	ld	s6,168(sp)
    8000517e:	7bca                	ld	s7,176(sp)
    80005180:	7c6a                	ld	s8,184(sp)
    80005182:	6c8e                	ld	s9,192(sp)
    80005184:	6d2e                	ld	s10,200(sp)
    80005186:	6dce                	ld	s11,208(sp)
    80005188:	6e6e                	ld	t3,216(sp)
    8000518a:	7e8e                	ld	t4,224(sp)
    8000518c:	7f2e                	ld	t5,232(sp)
    8000518e:	7fce                	ld	t6,240(sp)
    80005190:	6111                	addi	sp,sp,256
    80005192:	10200073          	sret
    80005196:	00000013          	nop
    8000519a:	00000013          	nop
    8000519e:	0001                	nop

00000000800051a0 <timervec>:
    800051a0:	34051573          	csrrw	a0,mscratch,a0
    800051a4:	e10c                	sd	a1,0(a0)
    800051a6:	e510                	sd	a2,8(a0)
    800051a8:	e914                	sd	a3,16(a0)
    800051aa:	6d0c                	ld	a1,24(a0)
    800051ac:	7110                	ld	a2,32(a0)
    800051ae:	6194                	ld	a3,0(a1)
    800051b0:	96b2                	add	a3,a3,a2
    800051b2:	e194                	sd	a3,0(a1)
    800051b4:	4589                	li	a1,2
    800051b6:	14459073          	csrw	sip,a1
    800051ba:	6914                	ld	a3,16(a0)
    800051bc:	6510                	ld	a2,8(a0)
    800051be:	610c                	ld	a1,0(a0)
    800051c0:	34051573          	csrrw	a0,mscratch,a0
    800051c4:	30200073          	mret
	...

00000000800051ca <plicinit>:

//
// the riscv Platform Level Interrupt Controller (PLIC).
//

void plicinit(void) {
    800051ca:	1141                	addi	sp,sp,-16
    800051cc:	e422                	sd	s0,8(sp)
    800051ce:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ * 4) = 1;
    800051d0:	0c0007b7          	lui	a5,0xc000
    800051d4:	4705                	li	a4,1
    800051d6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ * 4) = 1;
    800051d8:	c3d8                	sw	a4,4(a5)
}
    800051da:	6422                	ld	s0,8(sp)
    800051dc:	0141                	addi	sp,sp,16
    800051de:	8082                	ret

00000000800051e0 <plicinithart>:

void plicinithart(void) {
    800051e0:	1141                	addi	sp,sp,-16
    800051e2:	e406                	sd	ra,8(sp)
    800051e4:	e022                	sd	s0,0(sp)
    800051e6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051e8:	ffffc097          	auipc	ra,0xffffc
    800051ec:	c40080e7          	jalr	-960(ra) # 80000e28 <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800051f0:	0085171b          	slliw	a4,a0,0x8
    800051f4:	0c0027b7          	lui	a5,0xc002
    800051f8:	97ba                	add	a5,a5,a4
    800051fa:	40200713          	li	a4,1026
    800051fe:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005202:	00d5151b          	slliw	a0,a0,0xd
    80005206:	0c2017b7          	lui	a5,0xc201
    8000520a:	97aa                	add	a5,a5,a0
    8000520c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005210:	60a2                	ld	ra,8(sp)
    80005212:	6402                	ld	s0,0(sp)
    80005214:	0141                	addi	sp,sp,16
    80005216:	8082                	ret

0000000080005218 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int plic_claim(void) {
    80005218:	1141                	addi	sp,sp,-16
    8000521a:	e406                	sd	ra,8(sp)
    8000521c:	e022                	sd	s0,0(sp)
    8000521e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005220:	ffffc097          	auipc	ra,0xffffc
    80005224:	c08080e7          	jalr	-1016(ra) # 80000e28 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005228:	00d5151b          	slliw	a0,a0,0xd
    8000522c:	0c2017b7          	lui	a5,0xc201
    80005230:	97aa                	add	a5,a5,a0
  return irq;
}
    80005232:	43c8                	lw	a0,4(a5)
    80005234:	60a2                	ld	ra,8(sp)
    80005236:	6402                	ld	s0,0(sp)
    80005238:	0141                	addi	sp,sp,16
    8000523a:	8082                	ret

000000008000523c <plic_complete>:

// tell the PLIC we've served this IRQ.
void plic_complete(int irq) {
    8000523c:	1101                	addi	sp,sp,-32
    8000523e:	ec06                	sd	ra,24(sp)
    80005240:	e822                	sd	s0,16(sp)
    80005242:	e426                	sd	s1,8(sp)
    80005244:	1000                	addi	s0,sp,32
    80005246:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005248:	ffffc097          	auipc	ra,0xffffc
    8000524c:	be0080e7          	jalr	-1056(ra) # 80000e28 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005250:	00d5151b          	slliw	a0,a0,0xd
    80005254:	0c2017b7          	lui	a5,0xc201
    80005258:	97aa                	add	a5,a5,a0
    8000525a:	c3c4                	sw	s1,4(a5)
}
    8000525c:	60e2                	ld	ra,24(sp)
    8000525e:	6442                	ld	s0,16(sp)
    80005260:	64a2                	ld	s1,8(sp)
    80005262:	6105                	addi	sp,sp,32
    80005264:	8082                	ret

0000000080005266 <free_desc>:
  }
  return -1;
}

// mark a descriptor as free.
static void free_desc(int i) {
    80005266:	1141                	addi	sp,sp,-16
    80005268:	e406                	sd	ra,8(sp)
    8000526a:	e022                	sd	s0,0(sp)
    8000526c:	0800                	addi	s0,sp,16
  if (i >= NUM) panic("free_desc 1");
    8000526e:	479d                	li	a5,7
    80005270:	04a7cc63          	blt	a5,a0,800052c8 <free_desc+0x62>
  if (disk.free[i]) panic("free_desc 2");
    80005274:	00014797          	auipc	a5,0x14
    80005278:	77c78793          	addi	a5,a5,1916 # 800199f0 <disk>
    8000527c:	97aa                	add	a5,a5,a0
    8000527e:	0187c783          	lbu	a5,24(a5)
    80005282:	ebb9                	bnez	a5,800052d8 <free_desc+0x72>
  disk.desc[i].addr = 0;
    80005284:	00451693          	slli	a3,a0,0x4
    80005288:	00014797          	auipc	a5,0x14
    8000528c:	76878793          	addi	a5,a5,1896 # 800199f0 <disk>
    80005290:	6398                	ld	a4,0(a5)
    80005292:	9736                	add	a4,a4,a3
    80005294:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005298:	6398                	ld	a4,0(a5)
    8000529a:	9736                	add	a4,a4,a3
    8000529c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800052a0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800052a4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800052a8:	97aa                	add	a5,a5,a0
    800052aa:	4705                	li	a4,1
    800052ac:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800052b0:	00014517          	auipc	a0,0x14
    800052b4:	75850513          	addi	a0,a0,1880 # 80019a08 <disk+0x18>
    800052b8:	ffffc097          	auipc	ra,0xffffc
    800052bc:	2a8080e7          	jalr	680(ra) # 80001560 <wakeup>
}
    800052c0:	60a2                	ld	ra,8(sp)
    800052c2:	6402                	ld	s0,0(sp)
    800052c4:	0141                	addi	sp,sp,16
    800052c6:	8082                	ret
  if (i >= NUM) panic("free_desc 1");
    800052c8:	00003517          	auipc	a0,0x3
    800052cc:	41850513          	addi	a0,a0,1048 # 800086e0 <syscalls+0x300>
    800052d0:	00001097          	auipc	ra,0x1
    800052d4:	a0c080e7          	jalr	-1524(ra) # 80005cdc <panic>
  if (disk.free[i]) panic("free_desc 2");
    800052d8:	00003517          	auipc	a0,0x3
    800052dc:	41850513          	addi	a0,a0,1048 # 800086f0 <syscalls+0x310>
    800052e0:	00001097          	auipc	ra,0x1
    800052e4:	9fc080e7          	jalr	-1540(ra) # 80005cdc <panic>

00000000800052e8 <virtio_disk_init>:
void virtio_disk_init(void) {
    800052e8:	1101                	addi	sp,sp,-32
    800052ea:	ec06                	sd	ra,24(sp)
    800052ec:	e822                	sd	s0,16(sp)
    800052ee:	e426                	sd	s1,8(sp)
    800052f0:	e04a                	sd	s2,0(sp)
    800052f2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800052f4:	00003597          	auipc	a1,0x3
    800052f8:	40c58593          	addi	a1,a1,1036 # 80008700 <syscalls+0x320>
    800052fc:	00015517          	auipc	a0,0x15
    80005300:	81c50513          	addi	a0,a0,-2020 # 80019b18 <disk+0x128>
    80005304:	00001097          	auipc	ra,0x1
    80005308:	e80080e7          	jalr	-384(ra) # 80006184 <initlock>
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000530c:	100017b7          	lui	a5,0x10001
    80005310:	4398                	lw	a4,0(a5)
    80005312:	2701                	sext.w	a4,a4
    80005314:	747277b7          	lui	a5,0x74727
    80005318:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000531c:	14f71b63          	bne	a4,a5,80005472 <virtio_disk_init+0x18a>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005320:	100017b7          	lui	a5,0x10001
    80005324:	43dc                	lw	a5,4(a5)
    80005326:	2781                	sext.w	a5,a5
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005328:	4709                	li	a4,2
    8000532a:	14e79463          	bne	a5,a4,80005472 <virtio_disk_init+0x18a>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000532e:	100017b7          	lui	a5,0x10001
    80005332:	479c                	lw	a5,8(a5)
    80005334:	2781                	sext.w	a5,a5
    80005336:	12e79e63          	bne	a5,a4,80005472 <virtio_disk_init+0x18a>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    8000533a:	100017b7          	lui	a5,0x10001
    8000533e:	47d8                	lw	a4,12(a5)
    80005340:	2701                	sext.w	a4,a4
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005342:	554d47b7          	lui	a5,0x554d4
    80005346:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000534a:	12f71463          	bne	a4,a5,80005472 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000534e:	100017b7          	lui	a5,0x10001
    80005352:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005356:	4705                	li	a4,1
    80005358:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000535a:	470d                	li	a4,3
    8000535c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000535e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005360:	c7ffe6b7          	lui	a3,0xc7ffe
    80005364:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc9ef>
    80005368:	8f75                	and	a4,a4,a3
    8000536a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000536c:	472d                	li	a4,11
    8000536e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005370:	5bbc                	lw	a5,112(a5)
    80005372:	0007891b          	sext.w	s2,a5
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005376:	8ba1                	andi	a5,a5,8
    80005378:	10078563          	beqz	a5,80005482 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000537c:	100017b7          	lui	a5,0x10001
    80005380:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if (*R(VIRTIO_MMIO_QUEUE_READY)) panic("virtio disk should not be ready");
    80005384:	43fc                	lw	a5,68(a5)
    80005386:	2781                	sext.w	a5,a5
    80005388:	10079563          	bnez	a5,80005492 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000538c:	100017b7          	lui	a5,0x10001
    80005390:	5bdc                	lw	a5,52(a5)
    80005392:	2781                	sext.w	a5,a5
  if (max == 0) panic("virtio disk has no queue 0");
    80005394:	10078763          	beqz	a5,800054a2 <virtio_disk_init+0x1ba>
  if (max < NUM) panic("virtio disk max queue too short");
    80005398:	471d                	li	a4,7
    8000539a:	10f77c63          	bgeu	a4,a5,800054b2 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000539e:	ffffb097          	auipc	ra,0xffffb
    800053a2:	d7c080e7          	jalr	-644(ra) # 8000011a <kalloc>
    800053a6:	00014497          	auipc	s1,0x14
    800053aa:	64a48493          	addi	s1,s1,1610 # 800199f0 <disk>
    800053ae:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800053b0:	ffffb097          	auipc	ra,0xffffb
    800053b4:	d6a080e7          	jalr	-662(ra) # 8000011a <kalloc>
    800053b8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800053ba:	ffffb097          	auipc	ra,0xffffb
    800053be:	d60080e7          	jalr	-672(ra) # 8000011a <kalloc>
    800053c2:	87aa                	mv	a5,a0
    800053c4:	e888                	sd	a0,16(s1)
  if (!disk.desc || !disk.avail || !disk.used) panic("virtio disk kalloc");
    800053c6:	6088                	ld	a0,0(s1)
    800053c8:	cd6d                	beqz	a0,800054c2 <virtio_disk_init+0x1da>
    800053ca:	00014717          	auipc	a4,0x14
    800053ce:	62e73703          	ld	a4,1582(a4) # 800199f8 <disk+0x8>
    800053d2:	cb65                	beqz	a4,800054c2 <virtio_disk_init+0x1da>
    800053d4:	c7fd                	beqz	a5,800054c2 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    800053d6:	6605                	lui	a2,0x1
    800053d8:	4581                	li	a1,0
    800053da:	ffffb097          	auipc	ra,0xffffb
    800053de:	da0080e7          	jalr	-608(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    800053e2:	00014497          	auipc	s1,0x14
    800053e6:	60e48493          	addi	s1,s1,1550 # 800199f0 <disk>
    800053ea:	6605                	lui	a2,0x1
    800053ec:	4581                	li	a1,0
    800053ee:	6488                	ld	a0,8(s1)
    800053f0:	ffffb097          	auipc	ra,0xffffb
    800053f4:	d8a080e7          	jalr	-630(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    800053f8:	6605                	lui	a2,0x1
    800053fa:	4581                	li	a1,0
    800053fc:	6888                	ld	a0,16(s1)
    800053fe:	ffffb097          	auipc	ra,0xffffb
    80005402:	d7c080e7          	jalr	-644(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005406:	100017b7          	lui	a5,0x10001
    8000540a:	4721                	li	a4,8
    8000540c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000540e:	4098                	lw	a4,0(s1)
    80005410:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005414:	40d8                	lw	a4,4(s1)
    80005416:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000541a:	6498                	ld	a4,8(s1)
    8000541c:	0007069b          	sext.w	a3,a4
    80005420:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005424:	9701                	srai	a4,a4,0x20
    80005426:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000542a:	6898                	ld	a4,16(s1)
    8000542c:	0007069b          	sext.w	a3,a4
    80005430:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005434:	9701                	srai	a4,a4,0x20
    80005436:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000543a:	4705                	li	a4,1
    8000543c:	c3f8                	sw	a4,68(a5)
  for (int i = 0; i < NUM; i++) disk.free[i] = 1;
    8000543e:	00e48c23          	sb	a4,24(s1)
    80005442:	00e48ca3          	sb	a4,25(s1)
    80005446:	00e48d23          	sb	a4,26(s1)
    8000544a:	00e48da3          	sb	a4,27(s1)
    8000544e:	00e48e23          	sb	a4,28(s1)
    80005452:	00e48ea3          	sb	a4,29(s1)
    80005456:	00e48f23          	sb	a4,30(s1)
    8000545a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000545e:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005462:	0727a823          	sw	s2,112(a5)
}
    80005466:	60e2                	ld	ra,24(sp)
    80005468:	6442                	ld	s0,16(sp)
    8000546a:	64a2                	ld	s1,8(sp)
    8000546c:	6902                	ld	s2,0(sp)
    8000546e:	6105                	addi	sp,sp,32
    80005470:	8082                	ret
    panic("could not find virtio disk");
    80005472:	00003517          	auipc	a0,0x3
    80005476:	29e50513          	addi	a0,a0,670 # 80008710 <syscalls+0x330>
    8000547a:	00001097          	auipc	ra,0x1
    8000547e:	862080e7          	jalr	-1950(ra) # 80005cdc <panic>
    panic("virtio disk FEATURES_OK unset");
    80005482:	00003517          	auipc	a0,0x3
    80005486:	2ae50513          	addi	a0,a0,686 # 80008730 <syscalls+0x350>
    8000548a:	00001097          	auipc	ra,0x1
    8000548e:	852080e7          	jalr	-1966(ra) # 80005cdc <panic>
  if (*R(VIRTIO_MMIO_QUEUE_READY)) panic("virtio disk should not be ready");
    80005492:	00003517          	auipc	a0,0x3
    80005496:	2be50513          	addi	a0,a0,702 # 80008750 <syscalls+0x370>
    8000549a:	00001097          	auipc	ra,0x1
    8000549e:	842080e7          	jalr	-1982(ra) # 80005cdc <panic>
  if (max == 0) panic("virtio disk has no queue 0");
    800054a2:	00003517          	auipc	a0,0x3
    800054a6:	2ce50513          	addi	a0,a0,718 # 80008770 <syscalls+0x390>
    800054aa:	00001097          	auipc	ra,0x1
    800054ae:	832080e7          	jalr	-1998(ra) # 80005cdc <panic>
  if (max < NUM) panic("virtio disk max queue too short");
    800054b2:	00003517          	auipc	a0,0x3
    800054b6:	2de50513          	addi	a0,a0,734 # 80008790 <syscalls+0x3b0>
    800054ba:	00001097          	auipc	ra,0x1
    800054be:	822080e7          	jalr	-2014(ra) # 80005cdc <panic>
  if (!disk.desc || !disk.avail || !disk.used) panic("virtio disk kalloc");
    800054c2:	00003517          	auipc	a0,0x3
    800054c6:	2ee50513          	addi	a0,a0,750 # 800087b0 <syscalls+0x3d0>
    800054ca:	00001097          	auipc	ra,0x1
    800054ce:	812080e7          	jalr	-2030(ra) # 80005cdc <panic>

00000000800054d2 <virtio_disk_rw>:
    }
  }
  return 0;
}

void virtio_disk_rw(struct buf *b, int write) {
    800054d2:	7119                	addi	sp,sp,-128
    800054d4:	fc86                	sd	ra,120(sp)
    800054d6:	f8a2                	sd	s0,112(sp)
    800054d8:	f4a6                	sd	s1,104(sp)
    800054da:	f0ca                	sd	s2,96(sp)
    800054dc:	ecce                	sd	s3,88(sp)
    800054de:	e8d2                	sd	s4,80(sp)
    800054e0:	e4d6                	sd	s5,72(sp)
    800054e2:	e0da                	sd	s6,64(sp)
    800054e4:	fc5e                	sd	s7,56(sp)
    800054e6:	f862                	sd	s8,48(sp)
    800054e8:	f466                	sd	s9,40(sp)
    800054ea:	f06a                	sd	s10,32(sp)
    800054ec:	ec6e                	sd	s11,24(sp)
    800054ee:	0100                	addi	s0,sp,128
    800054f0:	8aaa                	mv	s5,a0
    800054f2:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800054f4:	00c52d03          	lw	s10,12(a0)
    800054f8:	001d1d1b          	slliw	s10,s10,0x1
    800054fc:	1d02                	slli	s10,s10,0x20
    800054fe:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80005502:	00014517          	auipc	a0,0x14
    80005506:	61650513          	addi	a0,a0,1558 # 80019b18 <disk+0x128>
    8000550a:	00001097          	auipc	ra,0x1
    8000550e:	d0a080e7          	jalr	-758(ra) # 80006214 <acquire>
  for (int i = 0; i < 3; i++) {
    80005512:	4981                	li	s3,0
  for (int i = 0; i < NUM; i++) {
    80005514:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005516:	00014b97          	auipc	s7,0x14
    8000551a:	4dab8b93          	addi	s7,s7,1242 # 800199f0 <disk>
  for (int i = 0; i < 3; i++) {
    8000551e:	4b0d                	li	s6,3
  int idx[3];
  while (1) {
    if (alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005520:	00014c97          	auipc	s9,0x14
    80005524:	5f8c8c93          	addi	s9,s9,1528 # 80019b18 <disk+0x128>
    80005528:	a08d                	j	8000558a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000552a:	00fb8733          	add	a4,s7,a5
    8000552e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005532:	c19c                	sw	a5,0(a1)
    if (idx[i] < 0) {
    80005534:	0207c563          	bltz	a5,8000555e <virtio_disk_rw+0x8c>
  for (int i = 0; i < 3; i++) {
    80005538:	2905                	addiw	s2,s2,1
    8000553a:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000553c:	05690c63          	beq	s2,s6,80005594 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80005540:	85b2                	mv	a1,a2
  for (int i = 0; i < NUM; i++) {
    80005542:	00014717          	auipc	a4,0x14
    80005546:	4ae70713          	addi	a4,a4,1198 # 800199f0 <disk>
    8000554a:	87ce                	mv	a5,s3
    if (disk.free[i]) {
    8000554c:	01874683          	lbu	a3,24(a4)
    80005550:	fee9                	bnez	a3,8000552a <virtio_disk_rw+0x58>
  for (int i = 0; i < NUM; i++) {
    80005552:	2785                	addiw	a5,a5,1
    80005554:	0705                	addi	a4,a4,1
    80005556:	fe979be3          	bne	a5,s1,8000554c <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    8000555a:	57fd                	li	a5,-1
    8000555c:	c19c                	sw	a5,0(a1)
      for (int j = 0; j < i; j++) free_desc(idx[j]);
    8000555e:	01205d63          	blez	s2,80005578 <virtio_disk_rw+0xa6>
    80005562:	8dce                	mv	s11,s3
    80005564:	000a2503          	lw	a0,0(s4)
    80005568:	00000097          	auipc	ra,0x0
    8000556c:	cfe080e7          	jalr	-770(ra) # 80005266 <free_desc>
    80005570:	2d85                	addiw	s11,s11,1
    80005572:	0a11                	addi	s4,s4,4
    80005574:	ff2d98e3          	bne	s11,s2,80005564 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005578:	85e6                	mv	a1,s9
    8000557a:	00014517          	auipc	a0,0x14
    8000557e:	48e50513          	addi	a0,a0,1166 # 80019a08 <disk+0x18>
    80005582:	ffffc097          	auipc	ra,0xffffc
    80005586:	f7a080e7          	jalr	-134(ra) # 800014fc <sleep>
  for (int i = 0; i < 3; i++) {
    8000558a:	f8040a13          	addi	s4,s0,-128
void virtio_disk_rw(struct buf *b, int write) {
    8000558e:	8652                	mv	a2,s4
  for (int i = 0; i < 3; i++) {
    80005590:	894e                	mv	s2,s3
    80005592:	b77d                	j	80005540 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005594:	f8042503          	lw	a0,-128(s0)
    80005598:	00a50713          	addi	a4,a0,10
    8000559c:	0712                	slli	a4,a4,0x4

  if (write)
    8000559e:	00014797          	auipc	a5,0x14
    800055a2:	45278793          	addi	a5,a5,1106 # 800199f0 <disk>
    800055a6:	00e786b3          	add	a3,a5,a4
    800055aa:	01803633          	snez	a2,s8
    800055ae:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT;  // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN;  // read the disk
  buf0->reserved = 0;
    800055b0:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    800055b4:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64)buf0;
    800055b8:	f6070613          	addi	a2,a4,-160
    800055bc:	6394                	ld	a3,0(a5)
    800055be:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055c0:	00870593          	addi	a1,a4,8
    800055c4:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64)buf0;
    800055c6:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800055c8:	0007b803          	ld	a6,0(a5)
    800055cc:	9642                	add	a2,a2,a6
    800055ce:	46c1                	li	a3,16
    800055d0:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800055d2:	4585                	li	a1,1
    800055d4:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    800055d8:	f8442683          	lw	a3,-124(s0)
    800055dc:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64)b->data;
    800055e0:	0692                	slli	a3,a3,0x4
    800055e2:	9836                	add	a6,a6,a3
    800055e4:	058a8613          	addi	a2,s5,88
    800055e8:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    800055ec:	0007b803          	ld	a6,0(a5)
    800055f0:	96c2                	add	a3,a3,a6
    800055f2:	40000613          	li	a2,1024
    800055f6:	c690                	sw	a2,8(a3)
  if (write)
    800055f8:	001c3613          	seqz	a2,s8
    800055fc:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0;  // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE;  // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005600:	00166613          	ori	a2,a2,1
    80005604:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005608:	f8842603          	lw	a2,-120(s0)
    8000560c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff;  // device writes 0 on success
    80005610:	00250693          	addi	a3,a0,2
    80005614:	0692                	slli	a3,a3,0x4
    80005616:	96be                	add	a3,a3,a5
    80005618:	58fd                	li	a7,-1
    8000561a:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    8000561e:	0612                	slli	a2,a2,0x4
    80005620:	9832                	add	a6,a6,a2
    80005622:	f9070713          	addi	a4,a4,-112
    80005626:	973e                	add	a4,a4,a5
    80005628:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    8000562c:	6398                	ld	a4,0(a5)
    8000562e:	9732                	add	a4,a4,a2
    80005630:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE;  // device writes the status
    80005632:	4609                	li	a2,2
    80005634:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80005638:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000563c:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    80005640:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005644:	6794                	ld	a3,8(a5)
    80005646:	0026d703          	lhu	a4,2(a3)
    8000564a:	8b1d                	andi	a4,a4,7
    8000564c:	0706                	slli	a4,a4,0x1
    8000564e:	96ba                	add	a3,a3,a4
    80005650:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005654:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1;  // not % NUM ...
    80005658:	6798                	ld	a4,8(a5)
    8000565a:	00275783          	lhu	a5,2(a4)
    8000565e:	2785                	addiw	a5,a5,1
    80005660:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005664:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0;  // value is queue number
    80005668:	100017b7          	lui	a5,0x10001
    8000566c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while (b->disk == 1) {
    80005670:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    80005674:	00014917          	auipc	s2,0x14
    80005678:	4a490913          	addi	s2,s2,1188 # 80019b18 <disk+0x128>
  while (b->disk == 1) {
    8000567c:	4485                	li	s1,1
    8000567e:	00b79c63          	bne	a5,a1,80005696 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005682:	85ca                	mv	a1,s2
    80005684:	8556                	mv	a0,s5
    80005686:	ffffc097          	auipc	ra,0xffffc
    8000568a:	e76080e7          	jalr	-394(ra) # 800014fc <sleep>
  while (b->disk == 1) {
    8000568e:	004aa783          	lw	a5,4(s5)
    80005692:	fe9788e3          	beq	a5,s1,80005682 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005696:	f8042903          	lw	s2,-128(s0)
    8000569a:	00290713          	addi	a4,s2,2
    8000569e:	0712                	slli	a4,a4,0x4
    800056a0:	00014797          	auipc	a5,0x14
    800056a4:	35078793          	addi	a5,a5,848 # 800199f0 <disk>
    800056a8:	97ba                	add	a5,a5,a4
    800056aa:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800056ae:	00014997          	auipc	s3,0x14
    800056b2:	34298993          	addi	s3,s3,834 # 800199f0 <disk>
    800056b6:	00491713          	slli	a4,s2,0x4
    800056ba:	0009b783          	ld	a5,0(s3)
    800056be:	97ba                	add	a5,a5,a4
    800056c0:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056c4:	854a                	mv	a0,s2
    800056c6:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056ca:	00000097          	auipc	ra,0x0
    800056ce:	b9c080e7          	jalr	-1124(ra) # 80005266 <free_desc>
    if (flag & VRING_DESC_F_NEXT)
    800056d2:	8885                	andi	s1,s1,1
    800056d4:	f0ed                	bnez	s1,800056b6 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056d6:	00014517          	auipc	a0,0x14
    800056da:	44250513          	addi	a0,a0,1090 # 80019b18 <disk+0x128>
    800056de:	00001097          	auipc	ra,0x1
    800056e2:	bea080e7          	jalr	-1046(ra) # 800062c8 <release>
}
    800056e6:	70e6                	ld	ra,120(sp)
    800056e8:	7446                	ld	s0,112(sp)
    800056ea:	74a6                	ld	s1,104(sp)
    800056ec:	7906                	ld	s2,96(sp)
    800056ee:	69e6                	ld	s3,88(sp)
    800056f0:	6a46                	ld	s4,80(sp)
    800056f2:	6aa6                	ld	s5,72(sp)
    800056f4:	6b06                	ld	s6,64(sp)
    800056f6:	7be2                	ld	s7,56(sp)
    800056f8:	7c42                	ld	s8,48(sp)
    800056fa:	7ca2                	ld	s9,40(sp)
    800056fc:	7d02                	ld	s10,32(sp)
    800056fe:	6de2                	ld	s11,24(sp)
    80005700:	6109                	addi	sp,sp,128
    80005702:	8082                	ret

0000000080005704 <virtio_disk_intr>:

void virtio_disk_intr() {
    80005704:	1101                	addi	sp,sp,-32
    80005706:	ec06                	sd	ra,24(sp)
    80005708:	e822                	sd	s0,16(sp)
    8000570a:	e426                	sd	s1,8(sp)
    8000570c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000570e:	00014497          	auipc	s1,0x14
    80005712:	2e248493          	addi	s1,s1,738 # 800199f0 <disk>
    80005716:	00014517          	auipc	a0,0x14
    8000571a:	40250513          	addi	a0,a0,1026 # 80019b18 <disk+0x128>
    8000571e:	00001097          	auipc	ra,0x1
    80005722:	af6080e7          	jalr	-1290(ra) # 80006214 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005726:	10001737          	lui	a4,0x10001
    8000572a:	533c                	lw	a5,96(a4)
    8000572c:	8b8d                	andi	a5,a5,3
    8000572e:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005730:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while (disk.used_idx != disk.used->idx) {
    80005734:	689c                	ld	a5,16(s1)
    80005736:	0204d703          	lhu	a4,32(s1)
    8000573a:	0027d783          	lhu	a5,2(a5)
    8000573e:	04f70863          	beq	a4,a5,8000578e <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005742:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005746:	6898                	ld	a4,16(s1)
    80005748:	0204d783          	lhu	a5,32(s1)
    8000574c:	8b9d                	andi	a5,a5,7
    8000574e:	078e                	slli	a5,a5,0x3
    80005750:	97ba                	add	a5,a5,a4
    80005752:	43dc                	lw	a5,4(a5)

    if (disk.info[id].status != 0) panic("virtio_disk_intr status");
    80005754:	00278713          	addi	a4,a5,2
    80005758:	0712                	slli	a4,a4,0x4
    8000575a:	9726                	add	a4,a4,s1
    8000575c:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005760:	e721                	bnez	a4,800057a8 <virtio_disk_intr+0xa4>

    struct buf *b = disk.info[id].b;
    80005762:	0789                	addi	a5,a5,2
    80005764:	0792                	slli	a5,a5,0x4
    80005766:	97a6                	add	a5,a5,s1
    80005768:	6788                	ld	a0,8(a5)
    b->disk = 0;  // disk is done with buf
    8000576a:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000576e:	ffffc097          	auipc	ra,0xffffc
    80005772:	df2080e7          	jalr	-526(ra) # 80001560 <wakeup>

    disk.used_idx += 1;
    80005776:	0204d783          	lhu	a5,32(s1)
    8000577a:	2785                	addiw	a5,a5,1
    8000577c:	17c2                	slli	a5,a5,0x30
    8000577e:	93c1                	srli	a5,a5,0x30
    80005780:	02f49023          	sh	a5,32(s1)
  while (disk.used_idx != disk.used->idx) {
    80005784:	6898                	ld	a4,16(s1)
    80005786:	00275703          	lhu	a4,2(a4)
    8000578a:	faf71ce3          	bne	a4,a5,80005742 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000578e:	00014517          	auipc	a0,0x14
    80005792:	38a50513          	addi	a0,a0,906 # 80019b18 <disk+0x128>
    80005796:	00001097          	auipc	ra,0x1
    8000579a:	b32080e7          	jalr	-1230(ra) # 800062c8 <release>
}
    8000579e:	60e2                	ld	ra,24(sp)
    800057a0:	6442                	ld	s0,16(sp)
    800057a2:	64a2                	ld	s1,8(sp)
    800057a4:	6105                	addi	sp,sp,32
    800057a6:	8082                	ret
    if (disk.info[id].status != 0) panic("virtio_disk_intr status");
    800057a8:	00003517          	auipc	a0,0x3
    800057ac:	02050513          	addi	a0,a0,32 # 800087c8 <syscalls+0x3e8>
    800057b0:	00000097          	auipc	ra,0x0
    800057b4:	52c080e7          	jalr	1324(ra) # 80005cdc <panic>

00000000800057b8 <timerinit>:
// arrange to receive timer interrupts.
// they will arrive in machine mode at
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void timerinit() {
    800057b8:	1141                	addi	sp,sp,-16
    800057ba:	e422                	sd	s0,8(sp)
    800057bc:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r"(x));
    800057be:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800057c2:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000;  // cycles; about 1/10th second in qemu.
  *(uint64 *)CLINT_MTIMECMP(id) = *(uint64 *)CLINT_MTIME + interval;
    800057c6:	0037979b          	slliw	a5,a5,0x3
    800057ca:	02004737          	lui	a4,0x2004
    800057ce:	97ba                	add	a5,a5,a4
    800057d0:	0200c737          	lui	a4,0x200c
    800057d4:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800057d8:	000f4637          	lui	a2,0xf4
    800057dc:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800057e0:	9732                	add	a4,a4,a2
    800057e2:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800057e4:	00259693          	slli	a3,a1,0x2
    800057e8:	96ae                	add	a3,a3,a1
    800057ea:	068e                	slli	a3,a3,0x3
    800057ec:	00014717          	auipc	a4,0x14
    800057f0:	34470713          	addi	a4,a4,836 # 80019b30 <timer_scratch>
    800057f4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800057f6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800057f8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r"(x));
    800057fa:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r"(x));
    800057fe:	00000797          	auipc	a5,0x0
    80005802:	9a278793          	addi	a5,a5,-1630 # 800051a0 <timervec>
    80005806:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r"(x));
    8000580a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000580e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80005812:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r"(x));
    80005816:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000581a:	0807e793          	ori	a5,a5,128
static inline void w_mie(uint64 x) { asm volatile("csrw mie, %0" : : "r"(x)); }
    8000581e:	30479073          	csrw	mie,a5
}
    80005822:	6422                	ld	s0,8(sp)
    80005824:	0141                	addi	sp,sp,16
    80005826:	8082                	ret

0000000080005828 <start>:
void start() {
    80005828:	1141                	addi	sp,sp,-16
    8000582a:	e406                	sd	ra,8(sp)
    8000582c:	e022                	sd	s0,0(sp)
    8000582e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r"(x));
    80005830:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005834:	7779                	lui	a4,0xffffe
    80005836:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdca8f>
    8000583a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000583c:	6705                	lui	a4,0x1
    8000583e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005842:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80005844:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    80005848:	ffffb797          	auipc	a5,0xffffb
    8000584c:	ad878793          	addi	a5,a5,-1320 # 80000320 <main>
    80005850:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r"(x));
    80005854:	4781                	li	a5,0
    80005856:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r"(x));
    8000585a:	67c1                	lui	a5,0x10
    8000585c:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000585e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r"(x));
    80005862:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r"(x));
    80005866:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000586a:	2227e793          	ori	a5,a5,546
static inline void w_sie(uint64 x) { asm volatile("csrw sie, %0" : : "r"(x)); }
    8000586e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    80005872:	57fd                	li	a5,-1
    80005874:	83a9                	srli	a5,a5,0xa
    80005876:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    8000587a:	47bd                	li	a5,15
    8000587c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005880:	00000097          	auipc	ra,0x0
    80005884:	f38080e7          	jalr	-200(ra) # 800057b8 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r"(x));
    80005888:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000588c:	2781                	sext.w	a5,a5
static inline void w_tp(uint64 x) { asm volatile("mv tp, %0" : : "r"(x)); }
    8000588e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005890:	30200073          	mret
}
    80005894:	60a2                	ld	ra,8(sp)
    80005896:	6402                	ld	s0,0(sp)
    80005898:	0141                	addi	sp,sp,16
    8000589a:	8082                	ret

000000008000589c <consolewrite>:
} cons;

//
// user write()s to the console go here.
//
int consolewrite(int user_src, uint64 src, int n) {
    8000589c:	715d                	addi	sp,sp,-80
    8000589e:	e486                	sd	ra,72(sp)
    800058a0:	e0a2                	sd	s0,64(sp)
    800058a2:	fc26                	sd	s1,56(sp)
    800058a4:	f84a                	sd	s2,48(sp)
    800058a6:	f44e                	sd	s3,40(sp)
    800058a8:	f052                	sd	s4,32(sp)
    800058aa:	ec56                	sd	s5,24(sp)
    800058ac:	0880                	addi	s0,sp,80
  int i;

  for (i = 0; i < n; i++) {
    800058ae:	04c05763          	blez	a2,800058fc <consolewrite+0x60>
    800058b2:	8a2a                	mv	s4,a0
    800058b4:	84ae                	mv	s1,a1
    800058b6:	89b2                	mv	s3,a2
    800058b8:	4901                	li	s2,0
    char c;
    if (either_copyin(&c, user_src, src + i, 1) == -1) break;
    800058ba:	5afd                	li	s5,-1
    800058bc:	4685                	li	a3,1
    800058be:	8626                	mv	a2,s1
    800058c0:	85d2                	mv	a1,s4
    800058c2:	fbf40513          	addi	a0,s0,-65
    800058c6:	ffffc097          	auipc	ra,0xffffc
    800058ca:	094080e7          	jalr	148(ra) # 8000195a <either_copyin>
    800058ce:	01550d63          	beq	a0,s5,800058e8 <consolewrite+0x4c>
    uartputc(c);
    800058d2:	fbf44503          	lbu	a0,-65(s0)
    800058d6:	00000097          	auipc	ra,0x0
    800058da:	784080e7          	jalr	1924(ra) # 8000605a <uartputc>
  for (i = 0; i < n; i++) {
    800058de:	2905                	addiw	s2,s2,1
    800058e0:	0485                	addi	s1,s1,1
    800058e2:	fd299de3          	bne	s3,s2,800058bc <consolewrite+0x20>
    800058e6:	894e                	mv	s2,s3
  }

  return i;
}
    800058e8:	854a                	mv	a0,s2
    800058ea:	60a6                	ld	ra,72(sp)
    800058ec:	6406                	ld	s0,64(sp)
    800058ee:	74e2                	ld	s1,56(sp)
    800058f0:	7942                	ld	s2,48(sp)
    800058f2:	79a2                	ld	s3,40(sp)
    800058f4:	7a02                	ld	s4,32(sp)
    800058f6:	6ae2                	ld	s5,24(sp)
    800058f8:	6161                	addi	sp,sp,80
    800058fa:	8082                	ret
  for (i = 0; i < n; i++) {
    800058fc:	4901                	li	s2,0
    800058fe:	b7ed                	j	800058e8 <consolewrite+0x4c>

0000000080005900 <consoleread>:
// user read()s from the console go here.
// copy (up to) a whole input line to dst.
// user_dist indicates whether dst is a user
// or kernel address.
//
int consoleread(int user_dst, uint64 dst, int n) {
    80005900:	7159                	addi	sp,sp,-112
    80005902:	f486                	sd	ra,104(sp)
    80005904:	f0a2                	sd	s0,96(sp)
    80005906:	eca6                	sd	s1,88(sp)
    80005908:	e8ca                	sd	s2,80(sp)
    8000590a:	e4ce                	sd	s3,72(sp)
    8000590c:	e0d2                	sd	s4,64(sp)
    8000590e:	fc56                	sd	s5,56(sp)
    80005910:	f85a                	sd	s6,48(sp)
    80005912:	f45e                	sd	s7,40(sp)
    80005914:	f062                	sd	s8,32(sp)
    80005916:	ec66                	sd	s9,24(sp)
    80005918:	e86a                	sd	s10,16(sp)
    8000591a:	1880                	addi	s0,sp,112
    8000591c:	8aaa                	mv	s5,a0
    8000591e:	8a2e                	mv	s4,a1
    80005920:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005922:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005926:	0001c517          	auipc	a0,0x1c
    8000592a:	34a50513          	addi	a0,a0,842 # 80021c70 <cons>
    8000592e:	00001097          	auipc	ra,0x1
    80005932:	8e6080e7          	jalr	-1818(ra) # 80006214 <acquire>
  while (n > 0) {
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while (cons.r == cons.w) {
    80005936:	0001c497          	auipc	s1,0x1c
    8000593a:	33a48493          	addi	s1,s1,826 # 80021c70 <cons>
      if (killed(myproc())) {
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000593e:	0001c917          	auipc	s2,0x1c
    80005942:	3ca90913          	addi	s2,s2,970 # 80021d08 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if (c == C('D')) {  // end-of-file
    80005946:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1) break;
    80005948:	5c7d                	li	s8,-1

    dst++;
    --n;

    if (c == '\n') {
    8000594a:	4ca9                	li	s9,10
  while (n > 0) {
    8000594c:	07305b63          	blez	s3,800059c2 <consoleread+0xc2>
    while (cons.r == cons.w) {
    80005950:	0984a783          	lw	a5,152(s1)
    80005954:	09c4a703          	lw	a4,156(s1)
    80005958:	02f71763          	bne	a4,a5,80005986 <consoleread+0x86>
      if (killed(myproc())) {
    8000595c:	ffffb097          	auipc	ra,0xffffb
    80005960:	4f8080e7          	jalr	1272(ra) # 80000e54 <myproc>
    80005964:	ffffc097          	auipc	ra,0xffffc
    80005968:	e40080e7          	jalr	-448(ra) # 800017a4 <killed>
    8000596c:	e535                	bnez	a0,800059d8 <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    8000596e:	85a6                	mv	a1,s1
    80005970:	854a                	mv	a0,s2
    80005972:	ffffc097          	auipc	ra,0xffffc
    80005976:	b8a080e7          	jalr	-1142(ra) # 800014fc <sleep>
    while (cons.r == cons.w) {
    8000597a:	0984a783          	lw	a5,152(s1)
    8000597e:	09c4a703          	lw	a4,156(s1)
    80005982:	fcf70de3          	beq	a4,a5,8000595c <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005986:	0017871b          	addiw	a4,a5,1
    8000598a:	08e4ac23          	sw	a4,152(s1)
    8000598e:	07f7f713          	andi	a4,a5,127
    80005992:	9726                	add	a4,a4,s1
    80005994:	01874703          	lbu	a4,24(a4)
    80005998:	00070d1b          	sext.w	s10,a4
    if (c == C('D')) {  // end-of-file
    8000599c:	077d0563          	beq	s10,s7,80005a06 <consoleread+0x106>
    cbuf = c;
    800059a0:	f8e40fa3          	sb	a4,-97(s0)
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1) break;
    800059a4:	4685                	li	a3,1
    800059a6:	f9f40613          	addi	a2,s0,-97
    800059aa:	85d2                	mv	a1,s4
    800059ac:	8556                	mv	a0,s5
    800059ae:	ffffc097          	auipc	ra,0xffffc
    800059b2:	f56080e7          	jalr	-170(ra) # 80001904 <either_copyout>
    800059b6:	01850663          	beq	a0,s8,800059c2 <consoleread+0xc2>
    dst++;
    800059ba:	0a05                	addi	s4,s4,1
    --n;
    800059bc:	39fd                	addiw	s3,s3,-1
    if (c == '\n') {
    800059be:	f99d17e3          	bne	s10,s9,8000594c <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800059c2:	0001c517          	auipc	a0,0x1c
    800059c6:	2ae50513          	addi	a0,a0,686 # 80021c70 <cons>
    800059ca:	00001097          	auipc	ra,0x1
    800059ce:	8fe080e7          	jalr	-1794(ra) # 800062c8 <release>

  return target - n;
    800059d2:	413b053b          	subw	a0,s6,s3
    800059d6:	a811                	j	800059ea <consoleread+0xea>
        release(&cons.lock);
    800059d8:	0001c517          	auipc	a0,0x1c
    800059dc:	29850513          	addi	a0,a0,664 # 80021c70 <cons>
    800059e0:	00001097          	auipc	ra,0x1
    800059e4:	8e8080e7          	jalr	-1816(ra) # 800062c8 <release>
        return -1;
    800059e8:	557d                	li	a0,-1
}
    800059ea:	70a6                	ld	ra,104(sp)
    800059ec:	7406                	ld	s0,96(sp)
    800059ee:	64e6                	ld	s1,88(sp)
    800059f0:	6946                	ld	s2,80(sp)
    800059f2:	69a6                	ld	s3,72(sp)
    800059f4:	6a06                	ld	s4,64(sp)
    800059f6:	7ae2                	ld	s5,56(sp)
    800059f8:	7b42                	ld	s6,48(sp)
    800059fa:	7ba2                	ld	s7,40(sp)
    800059fc:	7c02                	ld	s8,32(sp)
    800059fe:	6ce2                	ld	s9,24(sp)
    80005a00:	6d42                	ld	s10,16(sp)
    80005a02:	6165                	addi	sp,sp,112
    80005a04:	8082                	ret
      if (n < target) {
    80005a06:	0009871b          	sext.w	a4,s3
    80005a0a:	fb677ce3          	bgeu	a4,s6,800059c2 <consoleread+0xc2>
        cons.r--;
    80005a0e:	0001c717          	auipc	a4,0x1c
    80005a12:	2ef72d23          	sw	a5,762(a4) # 80021d08 <cons+0x98>
    80005a16:	b775                	j	800059c2 <consoleread+0xc2>

0000000080005a18 <consputc>:
void consputc(int c) {
    80005a18:	1141                	addi	sp,sp,-16
    80005a1a:	e406                	sd	ra,8(sp)
    80005a1c:	e022                	sd	s0,0(sp)
    80005a1e:	0800                	addi	s0,sp,16
  if (c == BACKSPACE) {
    80005a20:	10000793          	li	a5,256
    80005a24:	00f50a63          	beq	a0,a5,80005a38 <consputc+0x20>
    uartputc_sync(c);
    80005a28:	00000097          	auipc	ra,0x0
    80005a2c:	560080e7          	jalr	1376(ra) # 80005f88 <uartputc_sync>
}
    80005a30:	60a2                	ld	ra,8(sp)
    80005a32:	6402                	ld	s0,0(sp)
    80005a34:	0141                	addi	sp,sp,16
    80005a36:	8082                	ret
    uartputc_sync('\b');
    80005a38:	4521                	li	a0,8
    80005a3a:	00000097          	auipc	ra,0x0
    80005a3e:	54e080e7          	jalr	1358(ra) # 80005f88 <uartputc_sync>
    uartputc_sync(' ');
    80005a42:	02000513          	li	a0,32
    80005a46:	00000097          	auipc	ra,0x0
    80005a4a:	542080e7          	jalr	1346(ra) # 80005f88 <uartputc_sync>
    uartputc_sync('\b');
    80005a4e:	4521                	li	a0,8
    80005a50:	00000097          	auipc	ra,0x0
    80005a54:	538080e7          	jalr	1336(ra) # 80005f88 <uartputc_sync>
    80005a58:	bfe1                	j	80005a30 <consputc+0x18>

0000000080005a5a <consoleintr>:
// the console input interrupt handler.
// uartintr() calls this for input character.
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void consoleintr(int c) {
    80005a5a:	1101                	addi	sp,sp,-32
    80005a5c:	ec06                	sd	ra,24(sp)
    80005a5e:	e822                	sd	s0,16(sp)
    80005a60:	e426                	sd	s1,8(sp)
    80005a62:	e04a                	sd	s2,0(sp)
    80005a64:	1000                	addi	s0,sp,32
    80005a66:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005a68:	0001c517          	auipc	a0,0x1c
    80005a6c:	20850513          	addi	a0,a0,520 # 80021c70 <cons>
    80005a70:	00000097          	auipc	ra,0x0
    80005a74:	7a4080e7          	jalr	1956(ra) # 80006214 <acquire>

  switch (c) {
    80005a78:	47d5                	li	a5,21
    80005a7a:	0af48663          	beq	s1,a5,80005b26 <consoleintr+0xcc>
    80005a7e:	0297ca63          	blt	a5,s1,80005ab2 <consoleintr+0x58>
    80005a82:	47a1                	li	a5,8
    80005a84:	0ef48763          	beq	s1,a5,80005b72 <consoleintr+0x118>
    80005a88:	47c1                	li	a5,16
    80005a8a:	10f49a63          	bne	s1,a5,80005b9e <consoleintr+0x144>
    case C('P'):  // Print process list.
      procdump();
    80005a8e:	ffffc097          	auipc	ra,0xffffc
    80005a92:	f22080e7          	jalr	-222(ra) # 800019b0 <procdump>
        }
      }
      break;
  }

  release(&cons.lock);
    80005a96:	0001c517          	auipc	a0,0x1c
    80005a9a:	1da50513          	addi	a0,a0,474 # 80021c70 <cons>
    80005a9e:	00001097          	auipc	ra,0x1
    80005aa2:	82a080e7          	jalr	-2006(ra) # 800062c8 <release>
}
    80005aa6:	60e2                	ld	ra,24(sp)
    80005aa8:	6442                	ld	s0,16(sp)
    80005aaa:	64a2                	ld	s1,8(sp)
    80005aac:	6902                	ld	s2,0(sp)
    80005aae:	6105                	addi	sp,sp,32
    80005ab0:	8082                	ret
  switch (c) {
    80005ab2:	07f00793          	li	a5,127
    80005ab6:	0af48e63          	beq	s1,a5,80005b72 <consoleintr+0x118>
      if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    80005aba:	0001c717          	auipc	a4,0x1c
    80005abe:	1b670713          	addi	a4,a4,438 # 80021c70 <cons>
    80005ac2:	0a072783          	lw	a5,160(a4)
    80005ac6:	09872703          	lw	a4,152(a4)
    80005aca:	9f99                	subw	a5,a5,a4
    80005acc:	07f00713          	li	a4,127
    80005ad0:	fcf763e3          	bltu	a4,a5,80005a96 <consoleintr+0x3c>
        c = (c == '\r') ? '\n' : c;
    80005ad4:	47b5                	li	a5,13
    80005ad6:	0cf48763          	beq	s1,a5,80005ba4 <consoleintr+0x14a>
        consputc(c);
    80005ada:	8526                	mv	a0,s1
    80005adc:	00000097          	auipc	ra,0x0
    80005ae0:	f3c080e7          	jalr	-196(ra) # 80005a18 <consputc>
        cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005ae4:	0001c797          	auipc	a5,0x1c
    80005ae8:	18c78793          	addi	a5,a5,396 # 80021c70 <cons>
    80005aec:	0a07a683          	lw	a3,160(a5)
    80005af0:	0016871b          	addiw	a4,a3,1
    80005af4:	0007061b          	sext.w	a2,a4
    80005af8:	0ae7a023          	sw	a4,160(a5)
    80005afc:	07f6f693          	andi	a3,a3,127
    80005b00:	97b6                	add	a5,a5,a3
    80005b02:	00978c23          	sb	s1,24(a5)
        if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE) {
    80005b06:	47a9                	li	a5,10
    80005b08:	0cf48563          	beq	s1,a5,80005bd2 <consoleintr+0x178>
    80005b0c:	4791                	li	a5,4
    80005b0e:	0cf48263          	beq	s1,a5,80005bd2 <consoleintr+0x178>
    80005b12:	0001c797          	auipc	a5,0x1c
    80005b16:	1f67a783          	lw	a5,502(a5) # 80021d08 <cons+0x98>
    80005b1a:	9f1d                	subw	a4,a4,a5
    80005b1c:	08000793          	li	a5,128
    80005b20:	f6f71be3          	bne	a4,a5,80005a96 <consoleintr+0x3c>
    80005b24:	a07d                	j	80005bd2 <consoleintr+0x178>
      while (cons.e != cons.w &&
    80005b26:	0001c717          	auipc	a4,0x1c
    80005b2a:	14a70713          	addi	a4,a4,330 # 80021c70 <cons>
    80005b2e:	0a072783          	lw	a5,160(a4)
    80005b32:	09c72703          	lw	a4,156(a4)
             cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80005b36:	0001c497          	auipc	s1,0x1c
    80005b3a:	13a48493          	addi	s1,s1,314 # 80021c70 <cons>
      while (cons.e != cons.w &&
    80005b3e:	4929                	li	s2,10
    80005b40:	f4f70be3          	beq	a4,a5,80005a96 <consoleintr+0x3c>
             cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80005b44:	37fd                	addiw	a5,a5,-1
    80005b46:	07f7f713          	andi	a4,a5,127
    80005b4a:	9726                	add	a4,a4,s1
      while (cons.e != cons.w &&
    80005b4c:	01874703          	lbu	a4,24(a4)
    80005b50:	f52703e3          	beq	a4,s2,80005a96 <consoleintr+0x3c>
        cons.e--;
    80005b54:	0af4a023          	sw	a5,160(s1)
        consputc(BACKSPACE);
    80005b58:	10000513          	li	a0,256
    80005b5c:	00000097          	auipc	ra,0x0
    80005b60:	ebc080e7          	jalr	-324(ra) # 80005a18 <consputc>
      while (cons.e != cons.w &&
    80005b64:	0a04a783          	lw	a5,160(s1)
    80005b68:	09c4a703          	lw	a4,156(s1)
    80005b6c:	fcf71ce3          	bne	a4,a5,80005b44 <consoleintr+0xea>
    80005b70:	b71d                	j	80005a96 <consoleintr+0x3c>
      if (cons.e != cons.w) {
    80005b72:	0001c717          	auipc	a4,0x1c
    80005b76:	0fe70713          	addi	a4,a4,254 # 80021c70 <cons>
    80005b7a:	0a072783          	lw	a5,160(a4)
    80005b7e:	09c72703          	lw	a4,156(a4)
    80005b82:	f0f70ae3          	beq	a4,a5,80005a96 <consoleintr+0x3c>
        cons.e--;
    80005b86:	37fd                	addiw	a5,a5,-1
    80005b88:	0001c717          	auipc	a4,0x1c
    80005b8c:	18f72423          	sw	a5,392(a4) # 80021d10 <cons+0xa0>
        consputc(BACKSPACE);
    80005b90:	10000513          	li	a0,256
    80005b94:	00000097          	auipc	ra,0x0
    80005b98:	e84080e7          	jalr	-380(ra) # 80005a18 <consputc>
    80005b9c:	bded                	j	80005a96 <consoleintr+0x3c>
      if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    80005b9e:	ee048ce3          	beqz	s1,80005a96 <consoleintr+0x3c>
    80005ba2:	bf21                	j	80005aba <consoleintr+0x60>
        consputc(c);
    80005ba4:	4529                	li	a0,10
    80005ba6:	00000097          	auipc	ra,0x0
    80005baa:	e72080e7          	jalr	-398(ra) # 80005a18 <consputc>
        cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005bae:	0001c797          	auipc	a5,0x1c
    80005bb2:	0c278793          	addi	a5,a5,194 # 80021c70 <cons>
    80005bb6:	0a07a703          	lw	a4,160(a5)
    80005bba:	0017069b          	addiw	a3,a4,1
    80005bbe:	0006861b          	sext.w	a2,a3
    80005bc2:	0ad7a023          	sw	a3,160(a5)
    80005bc6:	07f77713          	andi	a4,a4,127
    80005bca:	97ba                	add	a5,a5,a4
    80005bcc:	4729                	li	a4,10
    80005bce:	00e78c23          	sb	a4,24(a5)
          cons.w = cons.e;
    80005bd2:	0001c797          	auipc	a5,0x1c
    80005bd6:	12c7ad23          	sw	a2,314(a5) # 80021d0c <cons+0x9c>
          wakeup(&cons.r);
    80005bda:	0001c517          	auipc	a0,0x1c
    80005bde:	12e50513          	addi	a0,a0,302 # 80021d08 <cons+0x98>
    80005be2:	ffffc097          	auipc	ra,0xffffc
    80005be6:	97e080e7          	jalr	-1666(ra) # 80001560 <wakeup>
    80005bea:	b575                	j	80005a96 <consoleintr+0x3c>

0000000080005bec <consoleinit>:

void consoleinit(void) {
    80005bec:	1141                	addi	sp,sp,-16
    80005bee:	e406                	sd	ra,8(sp)
    80005bf0:	e022                	sd	s0,0(sp)
    80005bf2:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005bf4:	00003597          	auipc	a1,0x3
    80005bf8:	bec58593          	addi	a1,a1,-1044 # 800087e0 <syscalls+0x400>
    80005bfc:	0001c517          	auipc	a0,0x1c
    80005c00:	07450513          	addi	a0,a0,116 # 80021c70 <cons>
    80005c04:	00000097          	auipc	ra,0x0
    80005c08:	580080e7          	jalr	1408(ra) # 80006184 <initlock>

  uartinit();
    80005c0c:	00000097          	auipc	ra,0x0
    80005c10:	32c080e7          	jalr	812(ra) # 80005f38 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005c14:	00013797          	auipc	a5,0x13
    80005c18:	d8478793          	addi	a5,a5,-636 # 80018998 <devsw>
    80005c1c:	00000717          	auipc	a4,0x0
    80005c20:	ce470713          	addi	a4,a4,-796 # 80005900 <consoleread>
    80005c24:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005c26:	00000717          	auipc	a4,0x0
    80005c2a:	c7670713          	addi	a4,a4,-906 # 8000589c <consolewrite>
    80005c2e:	ef98                	sd	a4,24(a5)
}
    80005c30:	60a2                	ld	ra,8(sp)
    80005c32:	6402                	ld	s0,0(sp)
    80005c34:	0141                	addi	sp,sp,16
    80005c36:	8082                	ret

0000000080005c38 <printint>:
  int locking;
} pr;

static char digits[] = "0123456789abcdef";

static void printint(int xx, int base, int sign) {
    80005c38:	7179                	addi	sp,sp,-48
    80005c3a:	f406                	sd	ra,40(sp)
    80005c3c:	f022                	sd	s0,32(sp)
    80005c3e:	ec26                	sd	s1,24(sp)
    80005c40:	e84a                	sd	s2,16(sp)
    80005c42:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if (sign && (sign = xx < 0))
    80005c44:	c219                	beqz	a2,80005c4a <printint+0x12>
    80005c46:	08054763          	bltz	a0,80005cd4 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005c4a:	2501                	sext.w	a0,a0
    80005c4c:	4881                	li	a7,0
    80005c4e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005c52:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005c54:	2581                	sext.w	a1,a1
    80005c56:	00003617          	auipc	a2,0x3
    80005c5a:	bba60613          	addi	a2,a2,-1094 # 80008810 <digits>
    80005c5e:	883a                	mv	a6,a4
    80005c60:	2705                	addiw	a4,a4,1
    80005c62:	02b577bb          	remuw	a5,a0,a1
    80005c66:	1782                	slli	a5,a5,0x20
    80005c68:	9381                	srli	a5,a5,0x20
    80005c6a:	97b2                	add	a5,a5,a2
    80005c6c:	0007c783          	lbu	a5,0(a5)
    80005c70:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    80005c74:	0005079b          	sext.w	a5,a0
    80005c78:	02b5553b          	divuw	a0,a0,a1
    80005c7c:	0685                	addi	a3,a3,1
    80005c7e:	feb7f0e3          	bgeu	a5,a1,80005c5e <printint+0x26>

  if (sign) buf[i++] = '-';
    80005c82:	00088c63          	beqz	a7,80005c9a <printint+0x62>
    80005c86:	fe070793          	addi	a5,a4,-32
    80005c8a:	00878733          	add	a4,a5,s0
    80005c8e:	02d00793          	li	a5,45
    80005c92:	fef70823          	sb	a5,-16(a4)
    80005c96:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) consputc(buf[i]);
    80005c9a:	02e05763          	blez	a4,80005cc8 <printint+0x90>
    80005c9e:	fd040793          	addi	a5,s0,-48
    80005ca2:	00e784b3          	add	s1,a5,a4
    80005ca6:	fff78913          	addi	s2,a5,-1
    80005caa:	993a                	add	s2,s2,a4
    80005cac:	377d                	addiw	a4,a4,-1
    80005cae:	1702                	slli	a4,a4,0x20
    80005cb0:	9301                	srli	a4,a4,0x20
    80005cb2:	40e90933          	sub	s2,s2,a4
    80005cb6:	fff4c503          	lbu	a0,-1(s1)
    80005cba:	00000097          	auipc	ra,0x0
    80005cbe:	d5e080e7          	jalr	-674(ra) # 80005a18 <consputc>
    80005cc2:	14fd                	addi	s1,s1,-1
    80005cc4:	ff2499e3          	bne	s1,s2,80005cb6 <printint+0x7e>
}
    80005cc8:	70a2                	ld	ra,40(sp)
    80005cca:	7402                	ld	s0,32(sp)
    80005ccc:	64e2                	ld	s1,24(sp)
    80005cce:	6942                	ld	s2,16(sp)
    80005cd0:	6145                	addi	sp,sp,48
    80005cd2:	8082                	ret
    x = -xx;
    80005cd4:	40a0053b          	negw	a0,a0
  if (sign && (sign = xx < 0))
    80005cd8:	4885                	li	a7,1
    x = -xx;
    80005cda:	bf95                	j	80005c4e <printint+0x16>

0000000080005cdc <panic>:
  va_end(ap);

  if (locking) release(&pr.lock);
}

void panic(char *s) {
    80005cdc:	1101                	addi	sp,sp,-32
    80005cde:	ec06                	sd	ra,24(sp)
    80005ce0:	e822                	sd	s0,16(sp)
    80005ce2:	e426                	sd	s1,8(sp)
    80005ce4:	1000                	addi	s0,sp,32
    80005ce6:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005ce8:	0001c797          	auipc	a5,0x1c
    80005cec:	0407a423          	sw	zero,72(a5) # 80021d30 <pr+0x18>
  printf("panic: ");
    80005cf0:	00003517          	auipc	a0,0x3
    80005cf4:	af850513          	addi	a0,a0,-1288 # 800087e8 <syscalls+0x408>
    80005cf8:	00000097          	auipc	ra,0x0
    80005cfc:	02e080e7          	jalr	46(ra) # 80005d26 <printf>
  printf(s);
    80005d00:	8526                	mv	a0,s1
    80005d02:	00000097          	auipc	ra,0x0
    80005d06:	024080e7          	jalr	36(ra) # 80005d26 <printf>
  printf("\n");
    80005d0a:	00002517          	auipc	a0,0x2
    80005d0e:	33e50513          	addi	a0,a0,830 # 80008048 <etext+0x48>
    80005d12:	00000097          	auipc	ra,0x0
    80005d16:	014080e7          	jalr	20(ra) # 80005d26 <printf>
  panicked = 1;  // freeze uart output from other CPUs
    80005d1a:	4785                	li	a5,1
    80005d1c:	00003717          	auipc	a4,0x3
    80005d20:	bcf72823          	sw	a5,-1072(a4) # 800088ec <panicked>
  for (;;)
    80005d24:	a001                	j	80005d24 <panic+0x48>

0000000080005d26 <printf>:
void printf(char *fmt, ...) {
    80005d26:	7131                	addi	sp,sp,-192
    80005d28:	fc86                	sd	ra,120(sp)
    80005d2a:	f8a2                	sd	s0,112(sp)
    80005d2c:	f4a6                	sd	s1,104(sp)
    80005d2e:	f0ca                	sd	s2,96(sp)
    80005d30:	ecce                	sd	s3,88(sp)
    80005d32:	e8d2                	sd	s4,80(sp)
    80005d34:	e4d6                	sd	s5,72(sp)
    80005d36:	e0da                	sd	s6,64(sp)
    80005d38:	fc5e                	sd	s7,56(sp)
    80005d3a:	f862                	sd	s8,48(sp)
    80005d3c:	f466                	sd	s9,40(sp)
    80005d3e:	f06a                	sd	s10,32(sp)
    80005d40:	ec6e                	sd	s11,24(sp)
    80005d42:	0100                	addi	s0,sp,128
    80005d44:	8a2a                	mv	s4,a0
    80005d46:	e40c                	sd	a1,8(s0)
    80005d48:	e810                	sd	a2,16(s0)
    80005d4a:	ec14                	sd	a3,24(s0)
    80005d4c:	f018                	sd	a4,32(s0)
    80005d4e:	f41c                	sd	a5,40(s0)
    80005d50:	03043823          	sd	a6,48(s0)
    80005d54:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d58:	0001cd97          	auipc	s11,0x1c
    80005d5c:	fd8dad83          	lw	s11,-40(s11) # 80021d30 <pr+0x18>
  if (locking) acquire(&pr.lock);
    80005d60:	020d9b63          	bnez	s11,80005d96 <printf+0x70>
  if (fmt == 0) panic("null fmt");
    80005d64:	040a0263          	beqz	s4,80005da8 <printf+0x82>
  va_start(ap, fmt);
    80005d68:	00840793          	addi	a5,s0,8
    80005d6c:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80005d70:	000a4503          	lbu	a0,0(s4)
    80005d74:	14050f63          	beqz	a0,80005ed2 <printf+0x1ac>
    80005d78:	4981                	li	s3,0
    if (c != '%') {
    80005d7a:	02500a93          	li	s5,37
    switch (c) {
    80005d7e:	07000b93          	li	s7,112
  consputc('x');
    80005d82:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d84:	00003b17          	auipc	s6,0x3
    80005d88:	a8cb0b13          	addi	s6,s6,-1396 # 80008810 <digits>
    switch (c) {
    80005d8c:	07300c93          	li	s9,115
    80005d90:	06400c13          	li	s8,100
    80005d94:	a82d                	j	80005dce <printf+0xa8>
  if (locking) acquire(&pr.lock);
    80005d96:	0001c517          	auipc	a0,0x1c
    80005d9a:	f8250513          	addi	a0,a0,-126 # 80021d18 <pr>
    80005d9e:	00000097          	auipc	ra,0x0
    80005da2:	476080e7          	jalr	1142(ra) # 80006214 <acquire>
    80005da6:	bf7d                	j	80005d64 <printf+0x3e>
  if (fmt == 0) panic("null fmt");
    80005da8:	00003517          	auipc	a0,0x3
    80005dac:	a5050513          	addi	a0,a0,-1456 # 800087f8 <syscalls+0x418>
    80005db0:	00000097          	auipc	ra,0x0
    80005db4:	f2c080e7          	jalr	-212(ra) # 80005cdc <panic>
      consputc(c);
    80005db8:	00000097          	auipc	ra,0x0
    80005dbc:	c60080e7          	jalr	-928(ra) # 80005a18 <consputc>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80005dc0:	2985                	addiw	s3,s3,1
    80005dc2:	013a07b3          	add	a5,s4,s3
    80005dc6:	0007c503          	lbu	a0,0(a5)
    80005dca:	10050463          	beqz	a0,80005ed2 <printf+0x1ac>
    if (c != '%') {
    80005dce:	ff5515e3          	bne	a0,s5,80005db8 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005dd2:	2985                	addiw	s3,s3,1
    80005dd4:	013a07b3          	add	a5,s4,s3
    80005dd8:	0007c783          	lbu	a5,0(a5)
    80005ddc:	0007849b          	sext.w	s1,a5
    if (c == 0) break;
    80005de0:	cbed                	beqz	a5,80005ed2 <printf+0x1ac>
    switch (c) {
    80005de2:	05778a63          	beq	a5,s7,80005e36 <printf+0x110>
    80005de6:	02fbf663          	bgeu	s7,a5,80005e12 <printf+0xec>
    80005dea:	09978863          	beq	a5,s9,80005e7a <printf+0x154>
    80005dee:	07800713          	li	a4,120
    80005df2:	0ce79563          	bne	a5,a4,80005ebc <printf+0x196>
        printint(va_arg(ap, int), 16, 1);
    80005df6:	f8843783          	ld	a5,-120(s0)
    80005dfa:	00878713          	addi	a4,a5,8
    80005dfe:	f8e43423          	sd	a4,-120(s0)
    80005e02:	4605                	li	a2,1
    80005e04:	85ea                	mv	a1,s10
    80005e06:	4388                	lw	a0,0(a5)
    80005e08:	00000097          	auipc	ra,0x0
    80005e0c:	e30080e7          	jalr	-464(ra) # 80005c38 <printint>
        break;
    80005e10:	bf45                	j	80005dc0 <printf+0x9a>
    switch (c) {
    80005e12:	09578f63          	beq	a5,s5,80005eb0 <printf+0x18a>
    80005e16:	0b879363          	bne	a5,s8,80005ebc <printf+0x196>
        printint(va_arg(ap, int), 10, 1);
    80005e1a:	f8843783          	ld	a5,-120(s0)
    80005e1e:	00878713          	addi	a4,a5,8
    80005e22:	f8e43423          	sd	a4,-120(s0)
    80005e26:	4605                	li	a2,1
    80005e28:	45a9                	li	a1,10
    80005e2a:	4388                	lw	a0,0(a5)
    80005e2c:	00000097          	auipc	ra,0x0
    80005e30:	e0c080e7          	jalr	-500(ra) # 80005c38 <printint>
        break;
    80005e34:	b771                	j	80005dc0 <printf+0x9a>
        printptr(va_arg(ap, uint64));
    80005e36:	f8843783          	ld	a5,-120(s0)
    80005e3a:	00878713          	addi	a4,a5,8
    80005e3e:	f8e43423          	sd	a4,-120(s0)
    80005e42:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005e46:	03000513          	li	a0,48
    80005e4a:	00000097          	auipc	ra,0x0
    80005e4e:	bce080e7          	jalr	-1074(ra) # 80005a18 <consputc>
  consputc('x');
    80005e52:	07800513          	li	a0,120
    80005e56:	00000097          	auipc	ra,0x0
    80005e5a:	bc2080e7          	jalr	-1086(ra) # 80005a18 <consputc>
    80005e5e:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e60:	03c95793          	srli	a5,s2,0x3c
    80005e64:	97da                	add	a5,a5,s6
    80005e66:	0007c503          	lbu	a0,0(a5)
    80005e6a:	00000097          	auipc	ra,0x0
    80005e6e:	bae080e7          	jalr	-1106(ra) # 80005a18 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e72:	0912                	slli	s2,s2,0x4
    80005e74:	34fd                	addiw	s1,s1,-1
    80005e76:	f4ed                	bnez	s1,80005e60 <printf+0x13a>
    80005e78:	b7a1                	j	80005dc0 <printf+0x9a>
        if ((s = va_arg(ap, char *)) == 0) s = "(null)";
    80005e7a:	f8843783          	ld	a5,-120(s0)
    80005e7e:	00878713          	addi	a4,a5,8
    80005e82:	f8e43423          	sd	a4,-120(s0)
    80005e86:	6384                	ld	s1,0(a5)
    80005e88:	cc89                	beqz	s1,80005ea2 <printf+0x17c>
        for (; *s; s++) consputc(*s);
    80005e8a:	0004c503          	lbu	a0,0(s1)
    80005e8e:	d90d                	beqz	a0,80005dc0 <printf+0x9a>
    80005e90:	00000097          	auipc	ra,0x0
    80005e94:	b88080e7          	jalr	-1144(ra) # 80005a18 <consputc>
    80005e98:	0485                	addi	s1,s1,1
    80005e9a:	0004c503          	lbu	a0,0(s1)
    80005e9e:	f96d                	bnez	a0,80005e90 <printf+0x16a>
    80005ea0:	b705                	j	80005dc0 <printf+0x9a>
        if ((s = va_arg(ap, char *)) == 0) s = "(null)";
    80005ea2:	00003497          	auipc	s1,0x3
    80005ea6:	94e48493          	addi	s1,s1,-1714 # 800087f0 <syscalls+0x410>
        for (; *s; s++) consputc(*s);
    80005eaa:	02800513          	li	a0,40
    80005eae:	b7cd                	j	80005e90 <printf+0x16a>
        consputc('%');
    80005eb0:	8556                	mv	a0,s5
    80005eb2:	00000097          	auipc	ra,0x0
    80005eb6:	b66080e7          	jalr	-1178(ra) # 80005a18 <consputc>
        break;
    80005eba:	b719                	j	80005dc0 <printf+0x9a>
        consputc('%');
    80005ebc:	8556                	mv	a0,s5
    80005ebe:	00000097          	auipc	ra,0x0
    80005ec2:	b5a080e7          	jalr	-1190(ra) # 80005a18 <consputc>
        consputc(c);
    80005ec6:	8526                	mv	a0,s1
    80005ec8:	00000097          	auipc	ra,0x0
    80005ecc:	b50080e7          	jalr	-1200(ra) # 80005a18 <consputc>
        break;
    80005ed0:	bdc5                	j	80005dc0 <printf+0x9a>
  if (locking) release(&pr.lock);
    80005ed2:	020d9163          	bnez	s11,80005ef4 <printf+0x1ce>
}
    80005ed6:	70e6                	ld	ra,120(sp)
    80005ed8:	7446                	ld	s0,112(sp)
    80005eda:	74a6                	ld	s1,104(sp)
    80005edc:	7906                	ld	s2,96(sp)
    80005ede:	69e6                	ld	s3,88(sp)
    80005ee0:	6a46                	ld	s4,80(sp)
    80005ee2:	6aa6                	ld	s5,72(sp)
    80005ee4:	6b06                	ld	s6,64(sp)
    80005ee6:	7be2                	ld	s7,56(sp)
    80005ee8:	7c42                	ld	s8,48(sp)
    80005eea:	7ca2                	ld	s9,40(sp)
    80005eec:	7d02                	ld	s10,32(sp)
    80005eee:	6de2                	ld	s11,24(sp)
    80005ef0:	6129                	addi	sp,sp,192
    80005ef2:	8082                	ret
  if (locking) release(&pr.lock);
    80005ef4:	0001c517          	auipc	a0,0x1c
    80005ef8:	e2450513          	addi	a0,a0,-476 # 80021d18 <pr>
    80005efc:	00000097          	auipc	ra,0x0
    80005f00:	3cc080e7          	jalr	972(ra) # 800062c8 <release>
}
    80005f04:	bfc9                	j	80005ed6 <printf+0x1b0>

0000000080005f06 <printfinit>:
    ;
}

void printfinit(void) {
    80005f06:	1101                	addi	sp,sp,-32
    80005f08:	ec06                	sd	ra,24(sp)
    80005f0a:	e822                	sd	s0,16(sp)
    80005f0c:	e426                	sd	s1,8(sp)
    80005f0e:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005f10:	0001c497          	auipc	s1,0x1c
    80005f14:	e0848493          	addi	s1,s1,-504 # 80021d18 <pr>
    80005f18:	00003597          	auipc	a1,0x3
    80005f1c:	8f058593          	addi	a1,a1,-1808 # 80008808 <syscalls+0x428>
    80005f20:	8526                	mv	a0,s1
    80005f22:	00000097          	auipc	ra,0x0
    80005f26:	262080e7          	jalr	610(ra) # 80006184 <initlock>
  pr.locking = 1;
    80005f2a:	4785                	li	a5,1
    80005f2c:	cc9c                	sw	a5,24(s1)
}
    80005f2e:	60e2                	ld	ra,24(sp)
    80005f30:	6442                	ld	s0,16(sp)
    80005f32:	64a2                	ld	s1,8(sp)
    80005f34:	6105                	addi	sp,sp,32
    80005f36:	8082                	ret

0000000080005f38 <uartinit>:

extern volatile int panicked;  // from printf.c

void uartstart();

void uartinit(void) {
    80005f38:	1141                	addi	sp,sp,-16
    80005f3a:	e406                	sd	ra,8(sp)
    80005f3c:	e022                	sd	s0,0(sp)
    80005f3e:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f40:	100007b7          	lui	a5,0x10000
    80005f44:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f48:	f8000713          	li	a4,-128
    80005f4c:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f50:	470d                	li	a4,3
    80005f52:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f56:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f5a:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f5e:	469d                	li	a3,7
    80005f60:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f64:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f68:	00003597          	auipc	a1,0x3
    80005f6c:	8c058593          	addi	a1,a1,-1856 # 80008828 <digits+0x18>
    80005f70:	0001c517          	auipc	a0,0x1c
    80005f74:	dc850513          	addi	a0,a0,-568 # 80021d38 <uart_tx_lock>
    80005f78:	00000097          	auipc	ra,0x0
    80005f7c:	20c080e7          	jalr	524(ra) # 80006184 <initlock>
}
    80005f80:	60a2                	ld	ra,8(sp)
    80005f82:	6402                	ld	s0,0(sp)
    80005f84:	0141                	addi	sp,sp,16
    80005f86:	8082                	ret

0000000080005f88 <uartputc_sync>:

// alternate version of uartputc() that doesn't
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void uartputc_sync(int c) {
    80005f88:	1101                	addi	sp,sp,-32
    80005f8a:	ec06                	sd	ra,24(sp)
    80005f8c:	e822                	sd	s0,16(sp)
    80005f8e:	e426                	sd	s1,8(sp)
    80005f90:	1000                	addi	s0,sp,32
    80005f92:	84aa                	mv	s1,a0
  push_off();
    80005f94:	00000097          	auipc	ra,0x0
    80005f98:	234080e7          	jalr	564(ra) # 800061c8 <push_off>

  if (panicked) {
    80005f9c:	00003797          	auipc	a5,0x3
    80005fa0:	9507a783          	lw	a5,-1712(a5) # 800088ec <panicked>
    for (;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005fa4:	10000737          	lui	a4,0x10000
  if (panicked) {
    80005fa8:	c391                	beqz	a5,80005fac <uartputc_sync+0x24>
    for (;;)
    80005faa:	a001                	j	80005faa <uartputc_sync+0x22>
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005fac:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005fb0:	0207f793          	andi	a5,a5,32
    80005fb4:	dfe5                	beqz	a5,80005fac <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005fb6:	0ff4f513          	zext.b	a0,s1
    80005fba:	100007b7          	lui	a5,0x10000
    80005fbe:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005fc2:	00000097          	auipc	ra,0x0
    80005fc6:	2a6080e7          	jalr	678(ra) # 80006268 <pop_off>
}
    80005fca:	60e2                	ld	ra,24(sp)
    80005fcc:	6442                	ld	s0,16(sp)
    80005fce:	64a2                	ld	s1,8(sp)
    80005fd0:	6105                	addi	sp,sp,32
    80005fd2:	8082                	ret

0000000080005fd4 <uartstart>:
// in the transmit buffer, send it.
// caller must hold uart_tx_lock.
// called from both the top- and bottom-half.
void uartstart() {
  while (1) {
    if (uart_tx_w == uart_tx_r) {
    80005fd4:	00003797          	auipc	a5,0x3
    80005fd8:	91c7b783          	ld	a5,-1764(a5) # 800088f0 <uart_tx_r>
    80005fdc:	00003717          	auipc	a4,0x3
    80005fe0:	91c73703          	ld	a4,-1764(a4) # 800088f8 <uart_tx_w>
    80005fe4:	06f70a63          	beq	a4,a5,80006058 <uartstart+0x84>
void uartstart() {
    80005fe8:	7139                	addi	sp,sp,-64
    80005fea:	fc06                	sd	ra,56(sp)
    80005fec:	f822                	sd	s0,48(sp)
    80005fee:	f426                	sd	s1,40(sp)
    80005ff0:	f04a                	sd	s2,32(sp)
    80005ff2:	ec4e                	sd	s3,24(sp)
    80005ff4:	e852                	sd	s4,16(sp)
    80005ff6:	e456                	sd	s5,8(sp)
    80005ff8:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }

    if ((ReadReg(LSR) & LSR_TX_IDLE) == 0) {
    80005ffa:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }

    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005ffe:	0001ca17          	auipc	s4,0x1c
    80006002:	d3aa0a13          	addi	s4,s4,-710 # 80021d38 <uart_tx_lock>
    uart_tx_r += 1;
    80006006:	00003497          	auipc	s1,0x3
    8000600a:	8ea48493          	addi	s1,s1,-1814 # 800088f0 <uart_tx_r>
    if (uart_tx_w == uart_tx_r) {
    8000600e:	00003997          	auipc	s3,0x3
    80006012:	8ea98993          	addi	s3,s3,-1814 # 800088f8 <uart_tx_w>
    if ((ReadReg(LSR) & LSR_TX_IDLE) == 0) {
    80006016:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000601a:	02077713          	andi	a4,a4,32
    8000601e:	c705                	beqz	a4,80006046 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006020:	01f7f713          	andi	a4,a5,31
    80006024:	9752                	add	a4,a4,s4
    80006026:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000602a:	0785                	addi	a5,a5,1
    8000602c:	e09c                	sd	a5,0(s1)

    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000602e:	8526                	mv	a0,s1
    80006030:	ffffb097          	auipc	ra,0xffffb
    80006034:	530080e7          	jalr	1328(ra) # 80001560 <wakeup>

    WriteReg(THR, c);
    80006038:	01590023          	sb	s5,0(s2)
    if (uart_tx_w == uart_tx_r) {
    8000603c:	609c                	ld	a5,0(s1)
    8000603e:	0009b703          	ld	a4,0(s3)
    80006042:	fcf71ae3          	bne	a4,a5,80006016 <uartstart+0x42>
  }
}
    80006046:	70e2                	ld	ra,56(sp)
    80006048:	7442                	ld	s0,48(sp)
    8000604a:	74a2                	ld	s1,40(sp)
    8000604c:	7902                	ld	s2,32(sp)
    8000604e:	69e2                	ld	s3,24(sp)
    80006050:	6a42                	ld	s4,16(sp)
    80006052:	6aa2                	ld	s5,8(sp)
    80006054:	6121                	addi	sp,sp,64
    80006056:	8082                	ret
    80006058:	8082                	ret

000000008000605a <uartputc>:
void uartputc(int c) {
    8000605a:	7179                	addi	sp,sp,-48
    8000605c:	f406                	sd	ra,40(sp)
    8000605e:	f022                	sd	s0,32(sp)
    80006060:	ec26                	sd	s1,24(sp)
    80006062:	e84a                	sd	s2,16(sp)
    80006064:	e44e                	sd	s3,8(sp)
    80006066:	e052                	sd	s4,0(sp)
    80006068:	1800                	addi	s0,sp,48
    8000606a:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000606c:	0001c517          	auipc	a0,0x1c
    80006070:	ccc50513          	addi	a0,a0,-820 # 80021d38 <uart_tx_lock>
    80006074:	00000097          	auipc	ra,0x0
    80006078:	1a0080e7          	jalr	416(ra) # 80006214 <acquire>
  if (panicked) {
    8000607c:	00003797          	auipc	a5,0x3
    80006080:	8707a783          	lw	a5,-1936(a5) # 800088ec <panicked>
    80006084:	e7c9                	bnez	a5,8000610e <uartputc+0xb4>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    80006086:	00003717          	auipc	a4,0x3
    8000608a:	87273703          	ld	a4,-1934(a4) # 800088f8 <uart_tx_w>
    8000608e:	00003797          	auipc	a5,0x3
    80006092:	8627b783          	ld	a5,-1950(a5) # 800088f0 <uart_tx_r>
    80006096:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000609a:	0001c997          	auipc	s3,0x1c
    8000609e:	c9e98993          	addi	s3,s3,-866 # 80021d38 <uart_tx_lock>
    800060a2:	00003497          	auipc	s1,0x3
    800060a6:	84e48493          	addi	s1,s1,-1970 # 800088f0 <uart_tx_r>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    800060aa:	00003917          	auipc	s2,0x3
    800060ae:	84e90913          	addi	s2,s2,-1970 # 800088f8 <uart_tx_w>
    800060b2:	00e79f63          	bne	a5,a4,800060d0 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    800060b6:	85ce                	mv	a1,s3
    800060b8:	8526                	mv	a0,s1
    800060ba:	ffffb097          	auipc	ra,0xffffb
    800060be:	442080e7          	jalr	1090(ra) # 800014fc <sleep>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    800060c2:	00093703          	ld	a4,0(s2)
    800060c6:	609c                	ld	a5,0(s1)
    800060c8:	02078793          	addi	a5,a5,32
    800060cc:	fee785e3          	beq	a5,a4,800060b6 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800060d0:	0001c497          	auipc	s1,0x1c
    800060d4:	c6848493          	addi	s1,s1,-920 # 80021d38 <uart_tx_lock>
    800060d8:	01f77793          	andi	a5,a4,31
    800060dc:	97a6                	add	a5,a5,s1
    800060de:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800060e2:	0705                	addi	a4,a4,1
    800060e4:	00003797          	auipc	a5,0x3
    800060e8:	80e7ba23          	sd	a4,-2028(a5) # 800088f8 <uart_tx_w>
  uartstart();
    800060ec:	00000097          	auipc	ra,0x0
    800060f0:	ee8080e7          	jalr	-280(ra) # 80005fd4 <uartstart>
  release(&uart_tx_lock);
    800060f4:	8526                	mv	a0,s1
    800060f6:	00000097          	auipc	ra,0x0
    800060fa:	1d2080e7          	jalr	466(ra) # 800062c8 <release>
}
    800060fe:	70a2                	ld	ra,40(sp)
    80006100:	7402                	ld	s0,32(sp)
    80006102:	64e2                	ld	s1,24(sp)
    80006104:	6942                	ld	s2,16(sp)
    80006106:	69a2                	ld	s3,8(sp)
    80006108:	6a02                	ld	s4,0(sp)
    8000610a:	6145                	addi	sp,sp,48
    8000610c:	8082                	ret
    for (;;)
    8000610e:	a001                	j	8000610e <uartputc+0xb4>

0000000080006110 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int uartgetc(void) {
    80006110:	1141                	addi	sp,sp,-16
    80006112:	e422                	sd	s0,8(sp)
    80006114:	0800                	addi	s0,sp,16
  if (ReadReg(LSR) & 0x01) {
    80006116:	100007b7          	lui	a5,0x10000
    8000611a:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000611e:	8b85                	andi	a5,a5,1
    80006120:	cb81                	beqz	a5,80006130 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80006122:	100007b7          	lui	a5,0x10000
    80006126:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000612a:	6422                	ld	s0,8(sp)
    8000612c:	0141                	addi	sp,sp,16
    8000612e:	8082                	ret
    return -1;
    80006130:	557d                	li	a0,-1
    80006132:	bfe5                	j	8000612a <uartgetc+0x1a>

0000000080006134 <uartintr>:

// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void uartintr(void) {
    80006134:	1101                	addi	sp,sp,-32
    80006136:	ec06                	sd	ra,24(sp)
    80006138:	e822                	sd	s0,16(sp)
    8000613a:	e426                	sd	s1,8(sp)
    8000613c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while (1) {
    int c = uartgetc();
    if (c == -1) break;
    8000613e:	54fd                	li	s1,-1
    80006140:	a029                	j	8000614a <uartintr+0x16>
    consoleintr(c);
    80006142:	00000097          	auipc	ra,0x0
    80006146:	918080e7          	jalr	-1768(ra) # 80005a5a <consoleintr>
    int c = uartgetc();
    8000614a:	00000097          	auipc	ra,0x0
    8000614e:	fc6080e7          	jalr	-58(ra) # 80006110 <uartgetc>
    if (c == -1) break;
    80006152:	fe9518e3          	bne	a0,s1,80006142 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006156:	0001c497          	auipc	s1,0x1c
    8000615a:	be248493          	addi	s1,s1,-1054 # 80021d38 <uart_tx_lock>
    8000615e:	8526                	mv	a0,s1
    80006160:	00000097          	auipc	ra,0x0
    80006164:	0b4080e7          	jalr	180(ra) # 80006214 <acquire>
  uartstart();
    80006168:	00000097          	auipc	ra,0x0
    8000616c:	e6c080e7          	jalr	-404(ra) # 80005fd4 <uartstart>
  release(&uart_tx_lock);
    80006170:	8526                	mv	a0,s1
    80006172:	00000097          	auipc	ra,0x0
    80006176:	156080e7          	jalr	342(ra) # 800062c8 <release>
}
    8000617a:	60e2                	ld	ra,24(sp)
    8000617c:	6442                	ld	s0,16(sp)
    8000617e:	64a2                	ld	s1,8(sp)
    80006180:	6105                	addi	sp,sp,32
    80006182:	8082                	ret

0000000080006184 <initlock>:
#include "spinlock.h"
#include "riscv.h"
#include "proc.h"
#include "defs.h"

void initlock(struct spinlock *lk, char *name) {
    80006184:	1141                	addi	sp,sp,-16
    80006186:	e422                	sd	s0,8(sp)
    80006188:	0800                	addi	s0,sp,16
  lk->name = name;
    8000618a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000618c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006190:	00053823          	sd	zero,16(a0)
}
    80006194:	6422                	ld	s0,8(sp)
    80006196:	0141                	addi	sp,sp,16
    80006198:	8082                	ret

000000008000619a <holding>:

// Check whether this cpu is holding the lock.
// Interrupts must be off.
int holding(struct spinlock *lk) {
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000619a:	411c                	lw	a5,0(a0)
    8000619c:	e399                	bnez	a5,800061a2 <holding+0x8>
    8000619e:	4501                	li	a0,0
  return r;
}
    800061a0:	8082                	ret
int holding(struct spinlock *lk) {
    800061a2:	1101                	addi	sp,sp,-32
    800061a4:	ec06                	sd	ra,24(sp)
    800061a6:	e822                	sd	s0,16(sp)
    800061a8:	e426                	sd	s1,8(sp)
    800061aa:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800061ac:	6904                	ld	s1,16(a0)
    800061ae:	ffffb097          	auipc	ra,0xffffb
    800061b2:	c8a080e7          	jalr	-886(ra) # 80000e38 <mycpu>
    800061b6:	40a48533          	sub	a0,s1,a0
    800061ba:	00153513          	seqz	a0,a0
}
    800061be:	60e2                	ld	ra,24(sp)
    800061c0:	6442                	ld	s0,16(sp)
    800061c2:	64a2                	ld	s1,8(sp)
    800061c4:	6105                	addi	sp,sp,32
    800061c6:	8082                	ret

00000000800061c8 <push_off>:

// push_off/pop_off are like intr_off()/intr_on() except that they are matched:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void push_off(void) {
    800061c8:	1101                	addi	sp,sp,-32
    800061ca:	ec06                	sd	ra,24(sp)
    800061cc:	e822                	sd	s0,16(sp)
    800061ce:	e426                	sd	s1,8(sp)
    800061d0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800061d2:	100024f3          	csrr	s1,sstatus
    800061d6:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    800061da:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800061dc:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if (mycpu()->noff == 0) mycpu()->intena = old;
    800061e0:	ffffb097          	auipc	ra,0xffffb
    800061e4:	c58080e7          	jalr	-936(ra) # 80000e38 <mycpu>
    800061e8:	5d3c                	lw	a5,120(a0)
    800061ea:	cf89                	beqz	a5,80006204 <push_off+0x3c>
  mycpu()->noff += 1;
    800061ec:	ffffb097          	auipc	ra,0xffffb
    800061f0:	c4c080e7          	jalr	-948(ra) # 80000e38 <mycpu>
    800061f4:	5d3c                	lw	a5,120(a0)
    800061f6:	2785                	addiw	a5,a5,1
    800061f8:	dd3c                	sw	a5,120(a0)
}
    800061fa:	60e2                	ld	ra,24(sp)
    800061fc:	6442                	ld	s0,16(sp)
    800061fe:	64a2                	ld	s1,8(sp)
    80006200:	6105                	addi	sp,sp,32
    80006202:	8082                	ret
  if (mycpu()->noff == 0) mycpu()->intena = old;
    80006204:	ffffb097          	auipc	ra,0xffffb
    80006208:	c34080e7          	jalr	-972(ra) # 80000e38 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000620c:	8085                	srli	s1,s1,0x1
    8000620e:	8885                	andi	s1,s1,1
    80006210:	dd64                	sw	s1,124(a0)
    80006212:	bfe9                	j	800061ec <push_off+0x24>

0000000080006214 <acquire>:
void acquire(struct spinlock *lk) {
    80006214:	1101                	addi	sp,sp,-32
    80006216:	ec06                	sd	ra,24(sp)
    80006218:	e822                	sd	s0,16(sp)
    8000621a:	e426                	sd	s1,8(sp)
    8000621c:	1000                	addi	s0,sp,32
    8000621e:	84aa                	mv	s1,a0
  push_off();  // disable interrupts to avoid deadlock.
    80006220:	00000097          	auipc	ra,0x0
    80006224:	fa8080e7          	jalr	-88(ra) # 800061c8 <push_off>
  if (holding(lk)) panic("acquire");
    80006228:	8526                	mv	a0,s1
    8000622a:	00000097          	auipc	ra,0x0
    8000622e:	f70080e7          	jalr	-144(ra) # 8000619a <holding>
  while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006232:	4705                	li	a4,1
  if (holding(lk)) panic("acquire");
    80006234:	e115                	bnez	a0,80006258 <acquire+0x44>
  while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006236:	87ba                	mv	a5,a4
    80006238:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000623c:	2781                	sext.w	a5,a5
    8000623e:	ffe5                	bnez	a5,80006236 <acquire+0x22>
  __sync_synchronize();
    80006240:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006244:	ffffb097          	auipc	ra,0xffffb
    80006248:	bf4080e7          	jalr	-1036(ra) # 80000e38 <mycpu>
    8000624c:	e888                	sd	a0,16(s1)
}
    8000624e:	60e2                	ld	ra,24(sp)
    80006250:	6442                	ld	s0,16(sp)
    80006252:	64a2                	ld	s1,8(sp)
    80006254:	6105                	addi	sp,sp,32
    80006256:	8082                	ret
  if (holding(lk)) panic("acquire");
    80006258:	00002517          	auipc	a0,0x2
    8000625c:	5d850513          	addi	a0,a0,1496 # 80008830 <digits+0x20>
    80006260:	00000097          	auipc	ra,0x0
    80006264:	a7c080e7          	jalr	-1412(ra) # 80005cdc <panic>

0000000080006268 <pop_off>:

void pop_off(void) {
    80006268:	1141                	addi	sp,sp,-16
    8000626a:	e406                	sd	ra,8(sp)
    8000626c:	e022                	sd	s0,0(sp)
    8000626e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006270:	ffffb097          	auipc	ra,0xffffb
    80006274:	bc8080e7          	jalr	-1080(ra) # 80000e38 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80006278:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000627c:	8b89                	andi	a5,a5,2
  if (intr_get()) panic("pop_off - interruptible");
    8000627e:	e78d                	bnez	a5,800062a8 <pop_off+0x40>
  if (c->noff < 1) panic("pop_off");
    80006280:	5d3c                	lw	a5,120(a0)
    80006282:	02f05b63          	blez	a5,800062b8 <pop_off+0x50>
  c->noff -= 1;
    80006286:	37fd                	addiw	a5,a5,-1
    80006288:	0007871b          	sext.w	a4,a5
    8000628c:	dd3c                	sw	a5,120(a0)
  if (c->noff == 0 && c->intena) intr_on();
    8000628e:	eb09                	bnez	a4,800062a0 <pop_off+0x38>
    80006290:	5d7c                	lw	a5,124(a0)
    80006292:	c799                	beqz	a5,800062a0 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80006294:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80006298:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    8000629c:	10079073          	csrw	sstatus,a5
}
    800062a0:	60a2                	ld	ra,8(sp)
    800062a2:	6402                	ld	s0,0(sp)
    800062a4:	0141                	addi	sp,sp,16
    800062a6:	8082                	ret
  if (intr_get()) panic("pop_off - interruptible");
    800062a8:	00002517          	auipc	a0,0x2
    800062ac:	59050513          	addi	a0,a0,1424 # 80008838 <digits+0x28>
    800062b0:	00000097          	auipc	ra,0x0
    800062b4:	a2c080e7          	jalr	-1492(ra) # 80005cdc <panic>
  if (c->noff < 1) panic("pop_off");
    800062b8:	00002517          	auipc	a0,0x2
    800062bc:	59850513          	addi	a0,a0,1432 # 80008850 <digits+0x40>
    800062c0:	00000097          	auipc	ra,0x0
    800062c4:	a1c080e7          	jalr	-1508(ra) # 80005cdc <panic>

00000000800062c8 <release>:
void release(struct spinlock *lk) {
    800062c8:	1101                	addi	sp,sp,-32
    800062ca:	ec06                	sd	ra,24(sp)
    800062cc:	e822                	sd	s0,16(sp)
    800062ce:	e426                	sd	s1,8(sp)
    800062d0:	1000                	addi	s0,sp,32
    800062d2:	84aa                	mv	s1,a0
  if (!holding(lk)) panic("release");
    800062d4:	00000097          	auipc	ra,0x0
    800062d8:	ec6080e7          	jalr	-314(ra) # 8000619a <holding>
    800062dc:	c115                	beqz	a0,80006300 <release+0x38>
  lk->cpu = 0;
    800062de:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800062e2:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800062e6:	0f50000f          	fence	iorw,ow
    800062ea:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800062ee:	00000097          	auipc	ra,0x0
    800062f2:	f7a080e7          	jalr	-134(ra) # 80006268 <pop_off>
}
    800062f6:	60e2                	ld	ra,24(sp)
    800062f8:	6442                	ld	s0,16(sp)
    800062fa:	64a2                	ld	s1,8(sp)
    800062fc:	6105                	addi	sp,sp,32
    800062fe:	8082                	ret
  if (!holding(lk)) panic("release");
    80006300:	00002517          	auipc	a0,0x2
    80006304:	55850513          	addi	a0,a0,1368 # 80008858 <digits+0x48>
    80006308:	00000097          	auipc	ra,0x0
    8000630c:	9d4080e7          	jalr	-1580(ra) # 80005cdc <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
