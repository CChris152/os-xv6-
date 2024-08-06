
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	91013103          	ld	sp,-1776(sp) # 80008910 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	3e7050ef          	jal	ra,80005bfc <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	7139                	addi	sp,sp,-64
    8000001e:	fc06                	sd	ra,56(sp)
    80000020:	f822                	sd	s0,48(sp)
    80000022:	f426                	sd	s1,40(sp)
    80000024:	f04a                	sd	s2,32(sp)
    80000026:	ec4e                	sd	s3,24(sp)
    80000028:	e852                	sd	s4,16(sp)
    8000002a:	e456                	sd	s5,8(sp)
    8000002c:	0080                	addi	s0,sp,64
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000002e:	03451793          	slli	a5,a0,0x34
    80000032:	e3c1                	bnez	a5,800000b2 <kfree+0x96>
    80000034:	84aa                	mv	s1,a0
    80000036:	0002b797          	auipc	a5,0x2b
    8000003a:	21278793          	addi	a5,a5,530 # 8002b248 <end>
    8000003e:	06f56a63          	bltu	a0,a5,800000b2 <kfree+0x96>
    80000042:	47c5                	li	a5,17
    80000044:	07ee                	slli	a5,a5,0x1b
    80000046:	06f57663          	bgeu	a0,a5,800000b2 <kfree+0x96>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    8000004a:	6605                	lui	a2,0x1
    8000004c:	4585                	li	a1,1
    8000004e:	00000097          	auipc	ra,0x0
    80000052:	242080e7          	jalr	578(ra) # 80000290 <memset>

  r = (struct run*)pa;

  push_off(); // need tu interrupt before get cpuid()
    80000056:	00006097          	auipc	ra,0x6
    8000005a:	53e080e7          	jalr	1342(ra) # 80006594 <push_off>
  int id = cpuid();
    8000005e:	00001097          	auipc	ra,0x1
    80000062:	ee6080e7          	jalr	-282(ra) # 80000f44 <cpuid>
  acquire(&kmem[id].lock);
    80000066:	00009a97          	auipc	s5,0x9
    8000006a:	fcaa8a93          	addi	s5,s5,-54 # 80009030 <kmem>
    8000006e:	00251993          	slli	s3,a0,0x2
    80000072:	00a98933          	add	s2,s3,a0
    80000076:	090e                	slli	s2,s2,0x3
    80000078:	9956                	add	s2,s2,s5
    8000007a:	854a                	mv	a0,s2
    8000007c:	00006097          	auipc	ra,0x6
    80000080:	564080e7          	jalr	1380(ra) # 800065e0 <acquire>
  r->next = kmem[id].freelist;
    80000084:	02093783          	ld	a5,32(s2)
    80000088:	e09c                	sd	a5,0(s1)
  kmem[id].freelist = r;
    8000008a:	02993023          	sd	s1,32(s2)
  release(&kmem[id].lock);
    8000008e:	854a                	mv	a0,s2
    80000090:	00006097          	auipc	ra,0x6
    80000094:	620080e7          	jalr	1568(ra) # 800066b0 <release>
  pop_off();
    80000098:	00006097          	auipc	ra,0x6
    8000009c:	5b8080e7          	jalr	1464(ra) # 80006650 <pop_off>
}
    800000a0:	70e2                	ld	ra,56(sp)
    800000a2:	7442                	ld	s0,48(sp)
    800000a4:	74a2                	ld	s1,40(sp)
    800000a6:	7902                	ld	s2,32(sp)
    800000a8:	69e2                	ld	s3,24(sp)
    800000aa:	6a42                	ld	s4,16(sp)
    800000ac:	6aa2                	ld	s5,8(sp)
    800000ae:	6121                	addi	sp,sp,64
    800000b0:	8082                	ret
    panic("kfree");
    800000b2:	00008517          	auipc	a0,0x8
    800000b6:	f5e50513          	addi	a0,a0,-162 # 80008010 <etext+0x10>
    800000ba:	00006097          	auipc	ra,0x6
    800000be:	ff2080e7          	jalr	-14(ra) # 800060ac <panic>

00000000800000c2 <freerange>:
{
    800000c2:	7179                	addi	sp,sp,-48
    800000c4:	f406                	sd	ra,40(sp)
    800000c6:	f022                	sd	s0,32(sp)
    800000c8:	ec26                	sd	s1,24(sp)
    800000ca:	e84a                	sd	s2,16(sp)
    800000cc:	e44e                	sd	s3,8(sp)
    800000ce:	e052                	sd	s4,0(sp)
    800000d0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000d2:	6785                	lui	a5,0x1
    800000d4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000d8:	94aa                	add	s1,s1,a0
    800000da:	757d                	lui	a0,0xfffff
    800000dc:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000de:	94be                	add	s1,s1,a5
    800000e0:	0095ee63          	bltu	a1,s1,800000fc <freerange+0x3a>
    800000e4:	892e                	mv	s2,a1
    kfree(p);
    800000e6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000e8:	6985                	lui	s3,0x1
    kfree(p);
    800000ea:	01448533          	add	a0,s1,s4
    800000ee:	00000097          	auipc	ra,0x0
    800000f2:	f2e080e7          	jalr	-210(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000f6:	94ce                	add	s1,s1,s3
    800000f8:	fe9979e3          	bgeu	s2,s1,800000ea <freerange+0x28>
}
    800000fc:	70a2                	ld	ra,40(sp)
    800000fe:	7402                	ld	s0,32(sp)
    80000100:	64e2                	ld	s1,24(sp)
    80000102:	6942                	ld	s2,16(sp)
    80000104:	69a2                	ld	s3,8(sp)
    80000106:	6a02                	ld	s4,0(sp)
    80000108:	6145                	addi	sp,sp,48
    8000010a:	8082                	ret

000000008000010c <kinit>:
{
    8000010c:	715d                	addi	sp,sp,-80
    8000010e:	e486                	sd	ra,72(sp)
    80000110:	e0a2                	sd	s0,64(sp)
    80000112:	fc26                	sd	s1,56(sp)
    80000114:	f84a                	sd	s2,48(sp)
    80000116:	f44e                	sd	s3,40(sp)
    80000118:	f052                	sd	s4,32(sp)
    8000011a:	ec56                	sd	s5,24(sp)
    8000011c:	0880                	addi	s0,sp,80
  for (int i = 0; i < NCPU; i++){
    8000011e:	00009917          	auipc	s2,0x9
    80000122:	f1290913          	addi	s2,s2,-238 # 80009030 <kmem>
    80000126:	4481                	li	s1,0
    snprintf(lockname, 10, "kmem_CPU%d", i);
    80000128:	00008a97          	auipc	s5,0x8
    8000012c:	ef0a8a93          	addi	s5,s5,-272 # 80008018 <etext+0x18>
    initlock(&kmem[i].lock, "kmem");
    80000130:	00008a17          	auipc	s4,0x8
    80000134:	ef8a0a13          	addi	s4,s4,-264 # 80008028 <etext+0x28>
  for (int i = 0; i < NCPU; i++){
    80000138:	49a1                	li	s3,8
    snprintf(lockname, 10, "kmem_CPU%d", i);
    8000013a:	86a6                	mv	a3,s1
    8000013c:	8656                	mv	a2,s5
    8000013e:	45a9                	li	a1,10
    80000140:	fb040513          	addi	a0,s0,-80
    80000144:	00006097          	auipc	ra,0x6
    80000148:	8ce080e7          	jalr	-1842(ra) # 80005a12 <snprintf>
    initlock(&kmem[i].lock, "kmem");
    8000014c:	85d2                	mv	a1,s4
    8000014e:	854a                	mv	a0,s2
    80000150:	00006097          	auipc	ra,0x6
    80000154:	60c080e7          	jalr	1548(ra) # 8000675c <initlock>
  for (int i = 0; i < NCPU; i++){
    80000158:	2485                	addiw	s1,s1,1
    8000015a:	02890913          	addi	s2,s2,40
    8000015e:	fd349ee3          	bne	s1,s3,8000013a <kinit+0x2e>
  freerange(end, (void*)PHYSTOP);
    80000162:	45c5                	li	a1,17
    80000164:	05ee                	slli	a1,a1,0x1b
    80000166:	0002b517          	auipc	a0,0x2b
    8000016a:	0e250513          	addi	a0,a0,226 # 8002b248 <end>
    8000016e:	00000097          	auipc	ra,0x0
    80000172:	f54080e7          	jalr	-172(ra) # 800000c2 <freerange>
}
    80000176:	60a6                	ld	ra,72(sp)
    80000178:	6406                	ld	s0,64(sp)
    8000017a:	74e2                	ld	s1,56(sp)
    8000017c:	7942                	ld	s2,48(sp)
    8000017e:	79a2                	ld	s3,40(sp)
    80000180:	7a02                	ld	s4,32(sp)
    80000182:	6ae2                	ld	s5,24(sp)
    80000184:	6161                	addi	sp,sp,80
    80000186:	8082                	ret

0000000080000188 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000188:	715d                	addi	sp,sp,-80
    8000018a:	e486                	sd	ra,72(sp)
    8000018c:	e0a2                	sd	s0,64(sp)
    8000018e:	fc26                	sd	s1,56(sp)
    80000190:	f84a                	sd	s2,48(sp)
    80000192:	f44e                	sd	s3,40(sp)
    80000194:	f052                	sd	s4,32(sp)
    80000196:	ec56                	sd	s5,24(sp)
    80000198:	e85a                	sd	s6,16(sp)
    8000019a:	e45e                	sd	s7,8(sp)
    8000019c:	e062                	sd	s8,0(sp)
    8000019e:	0880                	addi	s0,sp,80
  struct run *r;

  push_off();
    800001a0:	00006097          	auipc	ra,0x6
    800001a4:	3f4080e7          	jalr	1012(ra) # 80006594 <push_off>
  int id = cpuid();
    800001a8:	00001097          	auipc	ra,0x1
    800001ac:	d9c080e7          	jalr	-612(ra) # 80000f44 <cpuid>
    800001b0:	892a                	mv	s2,a0
  acquire(&kmem[id].lock);
    800001b2:	00251a13          	slli	s4,a0,0x2
    800001b6:	9a2a                	add	s4,s4,a0
    800001b8:	003a1793          	slli	a5,s4,0x3
    800001bc:	00009a17          	auipc	s4,0x9
    800001c0:	e74a0a13          	addi	s4,s4,-396 # 80009030 <kmem>
    800001c4:	9a3e                	add	s4,s4,a5
    800001c6:	8552                	mv	a0,s4
    800001c8:	00006097          	auipc	ra,0x6
    800001cc:	418080e7          	jalr	1048(ra) # 800065e0 <acquire>
  r = kmem[id].freelist;
    800001d0:	020a3a83          	ld	s5,32(s4)
  if(r)
    800001d4:	040a8363          	beqz	s5,8000021a <kalloc+0x92>
    kmem[id].freelist = r->next;
    800001d8:	000ab703          	ld	a4,0(s5)
    800001dc:	02ea3023          	sd	a4,32(s4)
        break;
      }
      release(&kmem[new_id].lock);
    }
  }
  release(&kmem[id].lock);
    800001e0:	8552                	mv	a0,s4
    800001e2:	00006097          	auipc	ra,0x6
    800001e6:	4ce080e7          	jalr	1230(ra) # 800066b0 <release>
  pop_off();
    800001ea:	00006097          	auipc	ra,0x6
    800001ee:	466080e7          	jalr	1126(ra) # 80006650 <pop_off>


  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    800001f2:	6605                	lui	a2,0x1
    800001f4:	4595                	li	a1,5
    800001f6:	8556                	mv	a0,s5
    800001f8:	00000097          	auipc	ra,0x0
    800001fc:	098080e7          	jalr	152(ra) # 80000290 <memset>
  return (void*)r;
}
    80000200:	8556                	mv	a0,s5
    80000202:	60a6                	ld	ra,72(sp)
    80000204:	6406                	ld	s0,64(sp)
    80000206:	74e2                	ld	s1,56(sp)
    80000208:	7942                	ld	s2,48(sp)
    8000020a:	79a2                	ld	s3,40(sp)
    8000020c:	7a02                	ld	s4,32(sp)
    8000020e:	6ae2                	ld	s5,24(sp)
    80000210:	6b42                	ld	s6,16(sp)
    80000212:	6ba2                	ld	s7,8(sp)
    80000214:	6c02                	ld	s8,0(sp)
    80000216:	6161                	addi	sp,sp,80
    80000218:	8082                	ret
    8000021a:	00009497          	auipc	s1,0x9
    8000021e:	e1648493          	addi	s1,s1,-490 # 80009030 <kmem>
    for (new_id = 0; new_id < NCPU; ++new_id){
    80000222:	4981                	li	s3,0
    80000224:	4ba1                	li	s7,8
    80000226:	a815                	j	8000025a <kalloc+0xd2>
        kmem[new_id].freelist = r->next;
    80000228:	000b3703          	ld	a4,0(s6)
    8000022c:	00299793          	slli	a5,s3,0x2
    80000230:	99be                	add	s3,s3,a5
    80000232:	098e                	slli	s3,s3,0x3
    80000234:	00009797          	auipc	a5,0x9
    80000238:	dfc78793          	addi	a5,a5,-516 # 80009030 <kmem>
    8000023c:	99be                	add	s3,s3,a5
    8000023e:	02e9b023          	sd	a4,32(s3) # 1020 <_entry-0x7fffefe0>
        release(&kmem[new_id].lock);
    80000242:	8526                	mv	a0,s1
    80000244:	00006097          	auipc	ra,0x6
    80000248:	46c080e7          	jalr	1132(ra) # 800066b0 <release>
      r = kmem[new_id].freelist;
    8000024c:	8ada                	mv	s5,s6
        break;
    8000024e:	bf49                	j	800001e0 <kalloc+0x58>
    for (new_id = 0; new_id < NCPU; ++new_id){
    80000250:	2985                	addiw	s3,s3,1
    80000252:	02848493          	addi	s1,s1,40
    80000256:	03798363          	beq	s3,s7,8000027c <kalloc+0xf4>
      if (new_id == id)
    8000025a:	ff390be3          	beq	s2,s3,80000250 <kalloc+0xc8>
      acquire(&kmem[new_id].lock);
    8000025e:	8526                	mv	a0,s1
    80000260:	00006097          	auipc	ra,0x6
    80000264:	380080e7          	jalr	896(ra) # 800065e0 <acquire>
      r = kmem[new_id].freelist;
    80000268:	0204bb03          	ld	s6,32(s1)
      if (r){
    8000026c:	fa0b1ee3          	bnez	s6,80000228 <kalloc+0xa0>
      release(&kmem[new_id].lock);
    80000270:	8526                	mv	a0,s1
    80000272:	00006097          	auipc	ra,0x6
    80000276:	43e080e7          	jalr	1086(ra) # 800066b0 <release>
    8000027a:	bfd9                	j	80000250 <kalloc+0xc8>
  release(&kmem[id].lock);
    8000027c:	8552                	mv	a0,s4
    8000027e:	00006097          	auipc	ra,0x6
    80000282:	432080e7          	jalr	1074(ra) # 800066b0 <release>
  pop_off();
    80000286:	00006097          	auipc	ra,0x6
    8000028a:	3ca080e7          	jalr	970(ra) # 80006650 <pop_off>
  return (void*)r;
    8000028e:	bf8d                	j	80000200 <kalloc+0x78>

0000000080000290 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000290:	1141                	addi	sp,sp,-16
    80000292:	e422                	sd	s0,8(sp)
    80000294:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000296:	ce09                	beqz	a2,800002b0 <memset+0x20>
    80000298:	87aa                	mv	a5,a0
    8000029a:	fff6071b          	addiw	a4,a2,-1
    8000029e:	1702                	slli	a4,a4,0x20
    800002a0:	9301                	srli	a4,a4,0x20
    800002a2:	0705                	addi	a4,a4,1
    800002a4:	972a                	add	a4,a4,a0
    cdst[i] = c;
    800002a6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800002aa:	0785                	addi	a5,a5,1
    800002ac:	fee79de3          	bne	a5,a4,800002a6 <memset+0x16>
  }
  return dst;
}
    800002b0:	6422                	ld	s0,8(sp)
    800002b2:	0141                	addi	sp,sp,16
    800002b4:	8082                	ret

00000000800002b6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800002b6:	1141                	addi	sp,sp,-16
    800002b8:	e422                	sd	s0,8(sp)
    800002ba:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800002bc:	ca05                	beqz	a2,800002ec <memcmp+0x36>
    800002be:	fff6069b          	addiw	a3,a2,-1
    800002c2:	1682                	slli	a3,a3,0x20
    800002c4:	9281                	srli	a3,a3,0x20
    800002c6:	0685                	addi	a3,a3,1
    800002c8:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800002ca:	00054783          	lbu	a5,0(a0)
    800002ce:	0005c703          	lbu	a4,0(a1)
    800002d2:	00e79863          	bne	a5,a4,800002e2 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800002d6:	0505                	addi	a0,a0,1
    800002d8:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800002da:	fed518e3          	bne	a0,a3,800002ca <memcmp+0x14>
  }

  return 0;
    800002de:	4501                	li	a0,0
    800002e0:	a019                	j	800002e6 <memcmp+0x30>
      return *s1 - *s2;
    800002e2:	40e7853b          	subw	a0,a5,a4
}
    800002e6:	6422                	ld	s0,8(sp)
    800002e8:	0141                	addi	sp,sp,16
    800002ea:	8082                	ret
  return 0;
    800002ec:	4501                	li	a0,0
    800002ee:	bfe5                	j	800002e6 <memcmp+0x30>

00000000800002f0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800002f0:	1141                	addi	sp,sp,-16
    800002f2:	e422                	sd	s0,8(sp)
    800002f4:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800002f6:	ca0d                	beqz	a2,80000328 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800002f8:	00a5f963          	bgeu	a1,a0,8000030a <memmove+0x1a>
    800002fc:	02061693          	slli	a3,a2,0x20
    80000300:	9281                	srli	a3,a3,0x20
    80000302:	00d58733          	add	a4,a1,a3
    80000306:	02e56463          	bltu	a0,a4,8000032e <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000030a:	fff6079b          	addiw	a5,a2,-1
    8000030e:	1782                	slli	a5,a5,0x20
    80000310:	9381                	srli	a5,a5,0x20
    80000312:	0785                	addi	a5,a5,1
    80000314:	97ae                	add	a5,a5,a1
    80000316:	872a                	mv	a4,a0
      *d++ = *s++;
    80000318:	0585                	addi	a1,a1,1
    8000031a:	0705                	addi	a4,a4,1
    8000031c:	fff5c683          	lbu	a3,-1(a1)
    80000320:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000324:	fef59ae3          	bne	a1,a5,80000318 <memmove+0x28>

  return dst;
}
    80000328:	6422                	ld	s0,8(sp)
    8000032a:	0141                	addi	sp,sp,16
    8000032c:	8082                	ret
    d += n;
    8000032e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000330:	fff6079b          	addiw	a5,a2,-1
    80000334:	1782                	slli	a5,a5,0x20
    80000336:	9381                	srli	a5,a5,0x20
    80000338:	fff7c793          	not	a5,a5
    8000033c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000033e:	177d                	addi	a4,a4,-1
    80000340:	16fd                	addi	a3,a3,-1
    80000342:	00074603          	lbu	a2,0(a4)
    80000346:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000034a:	fef71ae3          	bne	a4,a5,8000033e <memmove+0x4e>
    8000034e:	bfe9                	j	80000328 <memmove+0x38>

0000000080000350 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000350:	1141                	addi	sp,sp,-16
    80000352:	e406                	sd	ra,8(sp)
    80000354:	e022                	sd	s0,0(sp)
    80000356:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000358:	00000097          	auipc	ra,0x0
    8000035c:	f98080e7          	jalr	-104(ra) # 800002f0 <memmove>
}
    80000360:	60a2                	ld	ra,8(sp)
    80000362:	6402                	ld	s0,0(sp)
    80000364:	0141                	addi	sp,sp,16
    80000366:	8082                	ret

0000000080000368 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000368:	1141                	addi	sp,sp,-16
    8000036a:	e422                	sd	s0,8(sp)
    8000036c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000036e:	ce11                	beqz	a2,8000038a <strncmp+0x22>
    80000370:	00054783          	lbu	a5,0(a0)
    80000374:	cf89                	beqz	a5,8000038e <strncmp+0x26>
    80000376:	0005c703          	lbu	a4,0(a1)
    8000037a:	00f71a63          	bne	a4,a5,8000038e <strncmp+0x26>
    n--, p++, q++;
    8000037e:	367d                	addiw	a2,a2,-1
    80000380:	0505                	addi	a0,a0,1
    80000382:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000384:	f675                	bnez	a2,80000370 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000386:	4501                	li	a0,0
    80000388:	a809                	j	8000039a <strncmp+0x32>
    8000038a:	4501                	li	a0,0
    8000038c:	a039                	j	8000039a <strncmp+0x32>
  if(n == 0)
    8000038e:	ca09                	beqz	a2,800003a0 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000390:	00054503          	lbu	a0,0(a0)
    80000394:	0005c783          	lbu	a5,0(a1)
    80000398:	9d1d                	subw	a0,a0,a5
}
    8000039a:	6422                	ld	s0,8(sp)
    8000039c:	0141                	addi	sp,sp,16
    8000039e:	8082                	ret
    return 0;
    800003a0:	4501                	li	a0,0
    800003a2:	bfe5                	j	8000039a <strncmp+0x32>

00000000800003a4 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800003a4:	1141                	addi	sp,sp,-16
    800003a6:	e422                	sd	s0,8(sp)
    800003a8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800003aa:	872a                	mv	a4,a0
    800003ac:	8832                	mv	a6,a2
    800003ae:	367d                	addiw	a2,a2,-1
    800003b0:	01005963          	blez	a6,800003c2 <strncpy+0x1e>
    800003b4:	0705                	addi	a4,a4,1
    800003b6:	0005c783          	lbu	a5,0(a1)
    800003ba:	fef70fa3          	sb	a5,-1(a4)
    800003be:	0585                	addi	a1,a1,1
    800003c0:	f7f5                	bnez	a5,800003ac <strncpy+0x8>
    ;
  while(n-- > 0)
    800003c2:	00c05d63          	blez	a2,800003dc <strncpy+0x38>
    800003c6:	86ba                	mv	a3,a4
    *s++ = 0;
    800003c8:	0685                	addi	a3,a3,1
    800003ca:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800003ce:	fff6c793          	not	a5,a3
    800003d2:	9fb9                	addw	a5,a5,a4
    800003d4:	010787bb          	addw	a5,a5,a6
    800003d8:	fef048e3          	bgtz	a5,800003c8 <strncpy+0x24>
  return os;
}
    800003dc:	6422                	ld	s0,8(sp)
    800003de:	0141                	addi	sp,sp,16
    800003e0:	8082                	ret

00000000800003e2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800003e2:	1141                	addi	sp,sp,-16
    800003e4:	e422                	sd	s0,8(sp)
    800003e6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800003e8:	02c05363          	blez	a2,8000040e <safestrcpy+0x2c>
    800003ec:	fff6069b          	addiw	a3,a2,-1
    800003f0:	1682                	slli	a3,a3,0x20
    800003f2:	9281                	srli	a3,a3,0x20
    800003f4:	96ae                	add	a3,a3,a1
    800003f6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800003f8:	00d58963          	beq	a1,a3,8000040a <safestrcpy+0x28>
    800003fc:	0585                	addi	a1,a1,1
    800003fe:	0785                	addi	a5,a5,1
    80000400:	fff5c703          	lbu	a4,-1(a1)
    80000404:	fee78fa3          	sb	a4,-1(a5)
    80000408:	fb65                	bnez	a4,800003f8 <safestrcpy+0x16>
    ;
  *s = 0;
    8000040a:	00078023          	sb	zero,0(a5)
  return os;
}
    8000040e:	6422                	ld	s0,8(sp)
    80000410:	0141                	addi	sp,sp,16
    80000412:	8082                	ret

0000000080000414 <strlen>:

int
strlen(const char *s)
{
    80000414:	1141                	addi	sp,sp,-16
    80000416:	e422                	sd	s0,8(sp)
    80000418:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000041a:	00054783          	lbu	a5,0(a0)
    8000041e:	cf91                	beqz	a5,8000043a <strlen+0x26>
    80000420:	0505                	addi	a0,a0,1
    80000422:	87aa                	mv	a5,a0
    80000424:	4685                	li	a3,1
    80000426:	9e89                	subw	a3,a3,a0
    80000428:	00f6853b          	addw	a0,a3,a5
    8000042c:	0785                	addi	a5,a5,1
    8000042e:	fff7c703          	lbu	a4,-1(a5)
    80000432:	fb7d                	bnez	a4,80000428 <strlen+0x14>
    ;
  return n;
}
    80000434:	6422                	ld	s0,8(sp)
    80000436:	0141                	addi	sp,sp,16
    80000438:	8082                	ret
  for(n = 0; s[n]; n++)
    8000043a:	4501                	li	a0,0
    8000043c:	bfe5                	j	80000434 <strlen+0x20>

000000008000043e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000043e:	1101                	addi	sp,sp,-32
    80000440:	ec06                	sd	ra,24(sp)
    80000442:	e822                	sd	s0,16(sp)
    80000444:	e426                	sd	s1,8(sp)
    80000446:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80000448:	00001097          	auipc	ra,0x1
    8000044c:	afc080e7          	jalr	-1284(ra) # 80000f44 <cpuid>
    kcsaninit();
#endif
    __sync_synchronize();
    started = 1;
  } else {
    while(lockfree_read4((int *) &started) == 0)
    80000450:	00009497          	auipc	s1,0x9
    80000454:	bb048493          	addi	s1,s1,-1104 # 80009000 <started>
  if(cpuid() == 0){
    80000458:	c531                	beqz	a0,800004a4 <main+0x66>
    while(lockfree_read4((int *) &started) == 0)
    8000045a:	8526                	mv	a0,s1
    8000045c:	00006097          	auipc	ra,0x6
    80000460:	396080e7          	jalr	918(ra) # 800067f2 <lockfree_read4>
    80000464:	d97d                	beqz	a0,8000045a <main+0x1c>
      ;
    __sync_synchronize();
    80000466:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000046a:	00001097          	auipc	ra,0x1
    8000046e:	ada080e7          	jalr	-1318(ra) # 80000f44 <cpuid>
    80000472:	85aa                	mv	a1,a0
    80000474:	00008517          	auipc	a0,0x8
    80000478:	bd450513          	addi	a0,a0,-1068 # 80008048 <etext+0x48>
    8000047c:	00006097          	auipc	ra,0x6
    80000480:	c7a080e7          	jalr	-902(ra) # 800060f6 <printf>
    kvminithart();    // turn on paging
    80000484:	00000097          	auipc	ra,0x0
    80000488:	0e0080e7          	jalr	224(ra) # 80000564 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000048c:	00001097          	auipc	ra,0x1
    80000490:	730080e7          	jalr	1840(ra) # 80001bbc <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000494:	00005097          	auipc	ra,0x5
    80000498:	dbc080e7          	jalr	-580(ra) # 80005250 <plicinithart>
  }

  scheduler();        
    8000049c:	00001097          	auipc	ra,0x1
    800004a0:	fde080e7          	jalr	-34(ra) # 8000147a <scheduler>
    consoleinit();
    800004a4:	00006097          	auipc	ra,0x6
    800004a8:	b1a080e7          	jalr	-1254(ra) # 80005fbe <consoleinit>
    statsinit();
    800004ac:	00005097          	auipc	ra,0x5
    800004b0:	48a080e7          	jalr	1162(ra) # 80005936 <statsinit>
    printfinit();
    800004b4:	00006097          	auipc	ra,0x6
    800004b8:	e28080e7          	jalr	-472(ra) # 800062dc <printfinit>
    printf("\n");
    800004bc:	00008517          	auipc	a0,0x8
    800004c0:	3a450513          	addi	a0,a0,932 # 80008860 <digits+0x88>
    800004c4:	00006097          	auipc	ra,0x6
    800004c8:	c32080e7          	jalr	-974(ra) # 800060f6 <printf>
    printf("xv6 kernel is booting\n");
    800004cc:	00008517          	auipc	a0,0x8
    800004d0:	b6450513          	addi	a0,a0,-1180 # 80008030 <etext+0x30>
    800004d4:	00006097          	auipc	ra,0x6
    800004d8:	c22080e7          	jalr	-990(ra) # 800060f6 <printf>
    printf("\n");
    800004dc:	00008517          	auipc	a0,0x8
    800004e0:	38450513          	addi	a0,a0,900 # 80008860 <digits+0x88>
    800004e4:	00006097          	auipc	ra,0x6
    800004e8:	c12080e7          	jalr	-1006(ra) # 800060f6 <printf>
    kinit();         // physical page allocator
    800004ec:	00000097          	auipc	ra,0x0
    800004f0:	c20080e7          	jalr	-992(ra) # 8000010c <kinit>
    kvminit();       // create kernel page table
    800004f4:	00000097          	auipc	ra,0x0
    800004f8:	322080e7          	jalr	802(ra) # 80000816 <kvminit>
    kvminithart();   // turn on paging
    800004fc:	00000097          	auipc	ra,0x0
    80000500:	068080e7          	jalr	104(ra) # 80000564 <kvminithart>
    procinit();      // process table
    80000504:	00001097          	auipc	ra,0x1
    80000508:	990080e7          	jalr	-1648(ra) # 80000e94 <procinit>
    trapinit();      // trap vectors
    8000050c:	00001097          	auipc	ra,0x1
    80000510:	688080e7          	jalr	1672(ra) # 80001b94 <trapinit>
    trapinithart();  // install kernel trap vector
    80000514:	00001097          	auipc	ra,0x1
    80000518:	6a8080e7          	jalr	1704(ra) # 80001bbc <trapinithart>
    plicinit();      // set up interrupt controller
    8000051c:	00005097          	auipc	ra,0x5
    80000520:	d1e080e7          	jalr	-738(ra) # 8000523a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000524:	00005097          	auipc	ra,0x5
    80000528:	d2c080e7          	jalr	-724(ra) # 80005250 <plicinithart>
    binit();         // buffer cache
    8000052c:	00002097          	auipc	ra,0x2
    80000530:	de4080e7          	jalr	-540(ra) # 80002310 <binit>
    iinit();         // inode table
    80000534:	00002097          	auipc	ra,0x2
    80000538:	590080e7          	jalr	1424(ra) # 80002ac4 <iinit>
    fileinit();      // file table
    8000053c:	00003097          	auipc	ra,0x3
    80000540:	53a080e7          	jalr	1338(ra) # 80003a76 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000544:	00005097          	auipc	ra,0x5
    80000548:	e2e080e7          	jalr	-466(ra) # 80005372 <virtio_disk_init>
    userinit();      // first user process
    8000054c:	00001097          	auipc	ra,0x1
    80000550:	cfc080e7          	jalr	-772(ra) # 80001248 <userinit>
    __sync_synchronize();
    80000554:	0ff0000f          	fence
    started = 1;
    80000558:	4785                	li	a5,1
    8000055a:	00009717          	auipc	a4,0x9
    8000055e:	aaf72323          	sw	a5,-1370(a4) # 80009000 <started>
    80000562:	bf2d                	j	8000049c <main+0x5e>

0000000080000564 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000564:	1141                	addi	sp,sp,-16
    80000566:	e422                	sd	s0,8(sp)
    80000568:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000056a:	00009797          	auipc	a5,0x9
    8000056e:	a9e7b783          	ld	a5,-1378(a5) # 80009008 <kernel_pagetable>
    80000572:	83b1                	srli	a5,a5,0xc
    80000574:	577d                	li	a4,-1
    80000576:	177e                	slli	a4,a4,0x3f
    80000578:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000057a:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000057e:	12000073          	sfence.vma
  sfence_vma();
}
    80000582:	6422                	ld	s0,8(sp)
    80000584:	0141                	addi	sp,sp,16
    80000586:	8082                	ret

0000000080000588 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000588:	7139                	addi	sp,sp,-64
    8000058a:	fc06                	sd	ra,56(sp)
    8000058c:	f822                	sd	s0,48(sp)
    8000058e:	f426                	sd	s1,40(sp)
    80000590:	f04a                	sd	s2,32(sp)
    80000592:	ec4e                	sd	s3,24(sp)
    80000594:	e852                	sd	s4,16(sp)
    80000596:	e456                	sd	s5,8(sp)
    80000598:	e05a                	sd	s6,0(sp)
    8000059a:	0080                	addi	s0,sp,64
    8000059c:	84aa                	mv	s1,a0
    8000059e:	89ae                	mv	s3,a1
    800005a0:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800005a2:	57fd                	li	a5,-1
    800005a4:	83e9                	srli	a5,a5,0x1a
    800005a6:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800005a8:	4b31                	li	s6,12
  if(va >= MAXVA)
    800005aa:	04b7f263          	bgeu	a5,a1,800005ee <walk+0x66>
    panic("walk");
    800005ae:	00008517          	auipc	a0,0x8
    800005b2:	ab250513          	addi	a0,a0,-1358 # 80008060 <etext+0x60>
    800005b6:	00006097          	auipc	ra,0x6
    800005ba:	af6080e7          	jalr	-1290(ra) # 800060ac <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800005be:	060a8663          	beqz	s5,8000062a <walk+0xa2>
    800005c2:	00000097          	auipc	ra,0x0
    800005c6:	bc6080e7          	jalr	-1082(ra) # 80000188 <kalloc>
    800005ca:	84aa                	mv	s1,a0
    800005cc:	c529                	beqz	a0,80000616 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800005ce:	6605                	lui	a2,0x1
    800005d0:	4581                	li	a1,0
    800005d2:	00000097          	auipc	ra,0x0
    800005d6:	cbe080e7          	jalr	-834(ra) # 80000290 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800005da:	00c4d793          	srli	a5,s1,0xc
    800005de:	07aa                	slli	a5,a5,0xa
    800005e0:	0017e793          	ori	a5,a5,1
    800005e4:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800005e8:	3a5d                	addiw	s4,s4,-9
    800005ea:	036a0063          	beq	s4,s6,8000060a <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800005ee:	0149d933          	srl	s2,s3,s4
    800005f2:	1ff97913          	andi	s2,s2,511
    800005f6:	090e                	slli	s2,s2,0x3
    800005f8:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800005fa:	00093483          	ld	s1,0(s2)
    800005fe:	0014f793          	andi	a5,s1,1
    80000602:	dfd5                	beqz	a5,800005be <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000604:	80a9                	srli	s1,s1,0xa
    80000606:	04b2                	slli	s1,s1,0xc
    80000608:	b7c5                	j	800005e8 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000060a:	00c9d513          	srli	a0,s3,0xc
    8000060e:	1ff57513          	andi	a0,a0,511
    80000612:	050e                	slli	a0,a0,0x3
    80000614:	9526                	add	a0,a0,s1
}
    80000616:	70e2                	ld	ra,56(sp)
    80000618:	7442                	ld	s0,48(sp)
    8000061a:	74a2                	ld	s1,40(sp)
    8000061c:	7902                	ld	s2,32(sp)
    8000061e:	69e2                	ld	s3,24(sp)
    80000620:	6a42                	ld	s4,16(sp)
    80000622:	6aa2                	ld	s5,8(sp)
    80000624:	6b02                	ld	s6,0(sp)
    80000626:	6121                	addi	sp,sp,64
    80000628:	8082                	ret
        return 0;
    8000062a:	4501                	li	a0,0
    8000062c:	b7ed                	j	80000616 <walk+0x8e>

000000008000062e <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000062e:	57fd                	li	a5,-1
    80000630:	83e9                	srli	a5,a5,0x1a
    80000632:	00b7f463          	bgeu	a5,a1,8000063a <walkaddr+0xc>
    return 0;
    80000636:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000638:	8082                	ret
{
    8000063a:	1141                	addi	sp,sp,-16
    8000063c:	e406                	sd	ra,8(sp)
    8000063e:	e022                	sd	s0,0(sp)
    80000640:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000642:	4601                	li	a2,0
    80000644:	00000097          	auipc	ra,0x0
    80000648:	f44080e7          	jalr	-188(ra) # 80000588 <walk>
  if(pte == 0)
    8000064c:	c105                	beqz	a0,8000066c <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000064e:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000650:	0117f693          	andi	a3,a5,17
    80000654:	4745                	li	a4,17
    return 0;
    80000656:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000658:	00e68663          	beq	a3,a4,80000664 <walkaddr+0x36>
}
    8000065c:	60a2                	ld	ra,8(sp)
    8000065e:	6402                	ld	s0,0(sp)
    80000660:	0141                	addi	sp,sp,16
    80000662:	8082                	ret
  pa = PTE2PA(*pte);
    80000664:	00a7d513          	srli	a0,a5,0xa
    80000668:	0532                	slli	a0,a0,0xc
  return pa;
    8000066a:	bfcd                	j	8000065c <walkaddr+0x2e>
    return 0;
    8000066c:	4501                	li	a0,0
    8000066e:	b7fd                	j	8000065c <walkaddr+0x2e>

0000000080000670 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000670:	715d                	addi	sp,sp,-80
    80000672:	e486                	sd	ra,72(sp)
    80000674:	e0a2                	sd	s0,64(sp)
    80000676:	fc26                	sd	s1,56(sp)
    80000678:	f84a                	sd	s2,48(sp)
    8000067a:	f44e                	sd	s3,40(sp)
    8000067c:	f052                	sd	s4,32(sp)
    8000067e:	ec56                	sd	s5,24(sp)
    80000680:	e85a                	sd	s6,16(sp)
    80000682:	e45e                	sd	s7,8(sp)
    80000684:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000686:	c205                	beqz	a2,800006a6 <mappages+0x36>
    80000688:	8aaa                	mv	s5,a0
    8000068a:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000068c:	77fd                	lui	a5,0xfffff
    8000068e:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80000692:	15fd                	addi	a1,a1,-1
    80000694:	00c589b3          	add	s3,a1,a2
    80000698:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    8000069c:	8952                	mv	s2,s4
    8000069e:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800006a2:	6b85                	lui	s7,0x1
    800006a4:	a015                	j	800006c8 <mappages+0x58>
    panic("mappages: size");
    800006a6:	00008517          	auipc	a0,0x8
    800006aa:	9c250513          	addi	a0,a0,-1598 # 80008068 <etext+0x68>
    800006ae:	00006097          	auipc	ra,0x6
    800006b2:	9fe080e7          	jalr	-1538(ra) # 800060ac <panic>
      panic("mappages: remap");
    800006b6:	00008517          	auipc	a0,0x8
    800006ba:	9c250513          	addi	a0,a0,-1598 # 80008078 <etext+0x78>
    800006be:	00006097          	auipc	ra,0x6
    800006c2:	9ee080e7          	jalr	-1554(ra) # 800060ac <panic>
    a += PGSIZE;
    800006c6:	995e                	add	s2,s2,s7
  for(;;){
    800006c8:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800006cc:	4605                	li	a2,1
    800006ce:	85ca                	mv	a1,s2
    800006d0:	8556                	mv	a0,s5
    800006d2:	00000097          	auipc	ra,0x0
    800006d6:	eb6080e7          	jalr	-330(ra) # 80000588 <walk>
    800006da:	cd19                	beqz	a0,800006f8 <mappages+0x88>
    if(*pte & PTE_V)
    800006dc:	611c                	ld	a5,0(a0)
    800006de:	8b85                	andi	a5,a5,1
    800006e0:	fbf9                	bnez	a5,800006b6 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800006e2:	80b1                	srli	s1,s1,0xc
    800006e4:	04aa                	slli	s1,s1,0xa
    800006e6:	0164e4b3          	or	s1,s1,s6
    800006ea:	0014e493          	ori	s1,s1,1
    800006ee:	e104                	sd	s1,0(a0)
    if(a == last)
    800006f0:	fd391be3          	bne	s2,s3,800006c6 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800006f4:	4501                	li	a0,0
    800006f6:	a011                	j	800006fa <mappages+0x8a>
      return -1;
    800006f8:	557d                	li	a0,-1
}
    800006fa:	60a6                	ld	ra,72(sp)
    800006fc:	6406                	ld	s0,64(sp)
    800006fe:	74e2                	ld	s1,56(sp)
    80000700:	7942                	ld	s2,48(sp)
    80000702:	79a2                	ld	s3,40(sp)
    80000704:	7a02                	ld	s4,32(sp)
    80000706:	6ae2                	ld	s5,24(sp)
    80000708:	6b42                	ld	s6,16(sp)
    8000070a:	6ba2                	ld	s7,8(sp)
    8000070c:	6161                	addi	sp,sp,80
    8000070e:	8082                	ret

0000000080000710 <kvmmap>:
{
    80000710:	1141                	addi	sp,sp,-16
    80000712:	e406                	sd	ra,8(sp)
    80000714:	e022                	sd	s0,0(sp)
    80000716:	0800                	addi	s0,sp,16
    80000718:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000071a:	86b2                	mv	a3,a2
    8000071c:	863e                	mv	a2,a5
    8000071e:	00000097          	auipc	ra,0x0
    80000722:	f52080e7          	jalr	-174(ra) # 80000670 <mappages>
    80000726:	e509                	bnez	a0,80000730 <kvmmap+0x20>
}
    80000728:	60a2                	ld	ra,8(sp)
    8000072a:	6402                	ld	s0,0(sp)
    8000072c:	0141                	addi	sp,sp,16
    8000072e:	8082                	ret
    panic("kvmmap");
    80000730:	00008517          	auipc	a0,0x8
    80000734:	95850513          	addi	a0,a0,-1704 # 80008088 <etext+0x88>
    80000738:	00006097          	auipc	ra,0x6
    8000073c:	974080e7          	jalr	-1676(ra) # 800060ac <panic>

0000000080000740 <kvmmake>:
{
    80000740:	1101                	addi	sp,sp,-32
    80000742:	ec06                	sd	ra,24(sp)
    80000744:	e822                	sd	s0,16(sp)
    80000746:	e426                	sd	s1,8(sp)
    80000748:	e04a                	sd	s2,0(sp)
    8000074a:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000074c:	00000097          	auipc	ra,0x0
    80000750:	a3c080e7          	jalr	-1476(ra) # 80000188 <kalloc>
    80000754:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000756:	6605                	lui	a2,0x1
    80000758:	4581                	li	a1,0
    8000075a:	00000097          	auipc	ra,0x0
    8000075e:	b36080e7          	jalr	-1226(ra) # 80000290 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000762:	4719                	li	a4,6
    80000764:	6685                	lui	a3,0x1
    80000766:	10000637          	lui	a2,0x10000
    8000076a:	100005b7          	lui	a1,0x10000
    8000076e:	8526                	mv	a0,s1
    80000770:	00000097          	auipc	ra,0x0
    80000774:	fa0080e7          	jalr	-96(ra) # 80000710 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000778:	4719                	li	a4,6
    8000077a:	6685                	lui	a3,0x1
    8000077c:	10001637          	lui	a2,0x10001
    80000780:	100015b7          	lui	a1,0x10001
    80000784:	8526                	mv	a0,s1
    80000786:	00000097          	auipc	ra,0x0
    8000078a:	f8a080e7          	jalr	-118(ra) # 80000710 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000078e:	4719                	li	a4,6
    80000790:	004006b7          	lui	a3,0x400
    80000794:	0c000637          	lui	a2,0xc000
    80000798:	0c0005b7          	lui	a1,0xc000
    8000079c:	8526                	mv	a0,s1
    8000079e:	00000097          	auipc	ra,0x0
    800007a2:	f72080e7          	jalr	-142(ra) # 80000710 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800007a6:	00008917          	auipc	s2,0x8
    800007aa:	85a90913          	addi	s2,s2,-1958 # 80008000 <etext>
    800007ae:	4729                	li	a4,10
    800007b0:	80008697          	auipc	a3,0x80008
    800007b4:	85068693          	addi	a3,a3,-1968 # 8000 <_entry-0x7fff8000>
    800007b8:	4605                	li	a2,1
    800007ba:	067e                	slli	a2,a2,0x1f
    800007bc:	85b2                	mv	a1,a2
    800007be:	8526                	mv	a0,s1
    800007c0:	00000097          	auipc	ra,0x0
    800007c4:	f50080e7          	jalr	-176(ra) # 80000710 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800007c8:	4719                	li	a4,6
    800007ca:	46c5                	li	a3,17
    800007cc:	06ee                	slli	a3,a3,0x1b
    800007ce:	412686b3          	sub	a3,a3,s2
    800007d2:	864a                	mv	a2,s2
    800007d4:	85ca                	mv	a1,s2
    800007d6:	8526                	mv	a0,s1
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	f38080e7          	jalr	-200(ra) # 80000710 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800007e0:	4729                	li	a4,10
    800007e2:	6685                	lui	a3,0x1
    800007e4:	00007617          	auipc	a2,0x7
    800007e8:	81c60613          	addi	a2,a2,-2020 # 80007000 <_trampoline>
    800007ec:	040005b7          	lui	a1,0x4000
    800007f0:	15fd                	addi	a1,a1,-1
    800007f2:	05b2                	slli	a1,a1,0xc
    800007f4:	8526                	mv	a0,s1
    800007f6:	00000097          	auipc	ra,0x0
    800007fa:	f1a080e7          	jalr	-230(ra) # 80000710 <kvmmap>
  proc_mapstacks(kpgtbl);
    800007fe:	8526                	mv	a0,s1
    80000800:	00000097          	auipc	ra,0x0
    80000804:	5fe080e7          	jalr	1534(ra) # 80000dfe <proc_mapstacks>
}
    80000808:	8526                	mv	a0,s1
    8000080a:	60e2                	ld	ra,24(sp)
    8000080c:	6442                	ld	s0,16(sp)
    8000080e:	64a2                	ld	s1,8(sp)
    80000810:	6902                	ld	s2,0(sp)
    80000812:	6105                	addi	sp,sp,32
    80000814:	8082                	ret

0000000080000816 <kvminit>:
{
    80000816:	1141                	addi	sp,sp,-16
    80000818:	e406                	sd	ra,8(sp)
    8000081a:	e022                	sd	s0,0(sp)
    8000081c:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000081e:	00000097          	auipc	ra,0x0
    80000822:	f22080e7          	jalr	-222(ra) # 80000740 <kvmmake>
    80000826:	00008797          	auipc	a5,0x8
    8000082a:	7ea7b123          	sd	a0,2018(a5) # 80009008 <kernel_pagetable>
}
    8000082e:	60a2                	ld	ra,8(sp)
    80000830:	6402                	ld	s0,0(sp)
    80000832:	0141                	addi	sp,sp,16
    80000834:	8082                	ret

0000000080000836 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000836:	715d                	addi	sp,sp,-80
    80000838:	e486                	sd	ra,72(sp)
    8000083a:	e0a2                	sd	s0,64(sp)
    8000083c:	fc26                	sd	s1,56(sp)
    8000083e:	f84a                	sd	s2,48(sp)
    80000840:	f44e                	sd	s3,40(sp)
    80000842:	f052                	sd	s4,32(sp)
    80000844:	ec56                	sd	s5,24(sp)
    80000846:	e85a                	sd	s6,16(sp)
    80000848:	e45e                	sd	s7,8(sp)
    8000084a:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000084c:	03459793          	slli	a5,a1,0x34
    80000850:	e795                	bnez	a5,8000087c <uvmunmap+0x46>
    80000852:	8a2a                	mv	s4,a0
    80000854:	892e                	mv	s2,a1
    80000856:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000858:	0632                	slli	a2,a2,0xc
    8000085a:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000085e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000860:	6b05                	lui	s6,0x1
    80000862:	0735e863          	bltu	a1,s3,800008d2 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000866:	60a6                	ld	ra,72(sp)
    80000868:	6406                	ld	s0,64(sp)
    8000086a:	74e2                	ld	s1,56(sp)
    8000086c:	7942                	ld	s2,48(sp)
    8000086e:	79a2                	ld	s3,40(sp)
    80000870:	7a02                	ld	s4,32(sp)
    80000872:	6ae2                	ld	s5,24(sp)
    80000874:	6b42                	ld	s6,16(sp)
    80000876:	6ba2                	ld	s7,8(sp)
    80000878:	6161                	addi	sp,sp,80
    8000087a:	8082                	ret
    panic("uvmunmap: not aligned");
    8000087c:	00008517          	auipc	a0,0x8
    80000880:	81450513          	addi	a0,a0,-2028 # 80008090 <etext+0x90>
    80000884:	00006097          	auipc	ra,0x6
    80000888:	828080e7          	jalr	-2008(ra) # 800060ac <panic>
      panic("uvmunmap: walk");
    8000088c:	00008517          	auipc	a0,0x8
    80000890:	81c50513          	addi	a0,a0,-2020 # 800080a8 <etext+0xa8>
    80000894:	00006097          	auipc	ra,0x6
    80000898:	818080e7          	jalr	-2024(ra) # 800060ac <panic>
      panic("uvmunmap: not mapped");
    8000089c:	00008517          	auipc	a0,0x8
    800008a0:	81c50513          	addi	a0,a0,-2020 # 800080b8 <etext+0xb8>
    800008a4:	00006097          	auipc	ra,0x6
    800008a8:	808080e7          	jalr	-2040(ra) # 800060ac <panic>
      panic("uvmunmap: not a leaf");
    800008ac:	00008517          	auipc	a0,0x8
    800008b0:	82450513          	addi	a0,a0,-2012 # 800080d0 <etext+0xd0>
    800008b4:	00005097          	auipc	ra,0x5
    800008b8:	7f8080e7          	jalr	2040(ra) # 800060ac <panic>
      uint64 pa = PTE2PA(*pte);
    800008bc:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800008be:	0532                	slli	a0,a0,0xc
    800008c0:	fffff097          	auipc	ra,0xfffff
    800008c4:	75c080e7          	jalr	1884(ra) # 8000001c <kfree>
    *pte = 0;
    800008c8:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800008cc:	995a                	add	s2,s2,s6
    800008ce:	f9397ce3          	bgeu	s2,s3,80000866 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800008d2:	4601                	li	a2,0
    800008d4:	85ca                	mv	a1,s2
    800008d6:	8552                	mv	a0,s4
    800008d8:	00000097          	auipc	ra,0x0
    800008dc:	cb0080e7          	jalr	-848(ra) # 80000588 <walk>
    800008e0:	84aa                	mv	s1,a0
    800008e2:	d54d                	beqz	a0,8000088c <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800008e4:	6108                	ld	a0,0(a0)
    800008e6:	00157793          	andi	a5,a0,1
    800008ea:	dbcd                	beqz	a5,8000089c <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800008ec:	3ff57793          	andi	a5,a0,1023
    800008f0:	fb778ee3          	beq	a5,s7,800008ac <uvmunmap+0x76>
    if(do_free){
    800008f4:	fc0a8ae3          	beqz	s5,800008c8 <uvmunmap+0x92>
    800008f8:	b7d1                	j	800008bc <uvmunmap+0x86>

00000000800008fa <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800008fa:	1101                	addi	sp,sp,-32
    800008fc:	ec06                	sd	ra,24(sp)
    800008fe:	e822                	sd	s0,16(sp)
    80000900:	e426                	sd	s1,8(sp)
    80000902:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000904:	00000097          	auipc	ra,0x0
    80000908:	884080e7          	jalr	-1916(ra) # 80000188 <kalloc>
    8000090c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000090e:	c519                	beqz	a0,8000091c <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000910:	6605                	lui	a2,0x1
    80000912:	4581                	li	a1,0
    80000914:	00000097          	auipc	ra,0x0
    80000918:	97c080e7          	jalr	-1668(ra) # 80000290 <memset>
  return pagetable;
}
    8000091c:	8526                	mv	a0,s1
    8000091e:	60e2                	ld	ra,24(sp)
    80000920:	6442                	ld	s0,16(sp)
    80000922:	64a2                	ld	s1,8(sp)
    80000924:	6105                	addi	sp,sp,32
    80000926:	8082                	ret

0000000080000928 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000928:	7179                	addi	sp,sp,-48
    8000092a:	f406                	sd	ra,40(sp)
    8000092c:	f022                	sd	s0,32(sp)
    8000092e:	ec26                	sd	s1,24(sp)
    80000930:	e84a                	sd	s2,16(sp)
    80000932:	e44e                	sd	s3,8(sp)
    80000934:	e052                	sd	s4,0(sp)
    80000936:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000938:	6785                	lui	a5,0x1
    8000093a:	04f67863          	bgeu	a2,a5,8000098a <uvminit+0x62>
    8000093e:	8a2a                	mv	s4,a0
    80000940:	89ae                	mv	s3,a1
    80000942:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000944:	00000097          	auipc	ra,0x0
    80000948:	844080e7          	jalr	-1980(ra) # 80000188 <kalloc>
    8000094c:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000094e:	6605                	lui	a2,0x1
    80000950:	4581                	li	a1,0
    80000952:	00000097          	auipc	ra,0x0
    80000956:	93e080e7          	jalr	-1730(ra) # 80000290 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000095a:	4779                	li	a4,30
    8000095c:	86ca                	mv	a3,s2
    8000095e:	6605                	lui	a2,0x1
    80000960:	4581                	li	a1,0
    80000962:	8552                	mv	a0,s4
    80000964:	00000097          	auipc	ra,0x0
    80000968:	d0c080e7          	jalr	-756(ra) # 80000670 <mappages>
  memmove(mem, src, sz);
    8000096c:	8626                	mv	a2,s1
    8000096e:	85ce                	mv	a1,s3
    80000970:	854a                	mv	a0,s2
    80000972:	00000097          	auipc	ra,0x0
    80000976:	97e080e7          	jalr	-1666(ra) # 800002f0 <memmove>
}
    8000097a:	70a2                	ld	ra,40(sp)
    8000097c:	7402                	ld	s0,32(sp)
    8000097e:	64e2                	ld	s1,24(sp)
    80000980:	6942                	ld	s2,16(sp)
    80000982:	69a2                	ld	s3,8(sp)
    80000984:	6a02                	ld	s4,0(sp)
    80000986:	6145                	addi	sp,sp,48
    80000988:	8082                	ret
    panic("inituvm: more than a page");
    8000098a:	00007517          	auipc	a0,0x7
    8000098e:	75e50513          	addi	a0,a0,1886 # 800080e8 <etext+0xe8>
    80000992:	00005097          	auipc	ra,0x5
    80000996:	71a080e7          	jalr	1818(ra) # 800060ac <panic>

000000008000099a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000099a:	1101                	addi	sp,sp,-32
    8000099c:	ec06                	sd	ra,24(sp)
    8000099e:	e822                	sd	s0,16(sp)
    800009a0:	e426                	sd	s1,8(sp)
    800009a2:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800009a4:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800009a6:	00b67d63          	bgeu	a2,a1,800009c0 <uvmdealloc+0x26>
    800009aa:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800009ac:	6785                	lui	a5,0x1
    800009ae:	17fd                	addi	a5,a5,-1
    800009b0:	00f60733          	add	a4,a2,a5
    800009b4:	767d                	lui	a2,0xfffff
    800009b6:	8f71                	and	a4,a4,a2
    800009b8:	97ae                	add	a5,a5,a1
    800009ba:	8ff1                	and	a5,a5,a2
    800009bc:	00f76863          	bltu	a4,a5,800009cc <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800009c0:	8526                	mv	a0,s1
    800009c2:	60e2                	ld	ra,24(sp)
    800009c4:	6442                	ld	s0,16(sp)
    800009c6:	64a2                	ld	s1,8(sp)
    800009c8:	6105                	addi	sp,sp,32
    800009ca:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800009cc:	8f99                	sub	a5,a5,a4
    800009ce:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800009d0:	4685                	li	a3,1
    800009d2:	0007861b          	sext.w	a2,a5
    800009d6:	85ba                	mv	a1,a4
    800009d8:	00000097          	auipc	ra,0x0
    800009dc:	e5e080e7          	jalr	-418(ra) # 80000836 <uvmunmap>
    800009e0:	b7c5                	j	800009c0 <uvmdealloc+0x26>

00000000800009e2 <uvmalloc>:
  if(newsz < oldsz)
    800009e2:	0ab66163          	bltu	a2,a1,80000a84 <uvmalloc+0xa2>
{
    800009e6:	7139                	addi	sp,sp,-64
    800009e8:	fc06                	sd	ra,56(sp)
    800009ea:	f822                	sd	s0,48(sp)
    800009ec:	f426                	sd	s1,40(sp)
    800009ee:	f04a                	sd	s2,32(sp)
    800009f0:	ec4e                	sd	s3,24(sp)
    800009f2:	e852                	sd	s4,16(sp)
    800009f4:	e456                	sd	s5,8(sp)
    800009f6:	0080                	addi	s0,sp,64
    800009f8:	8aaa                	mv	s5,a0
    800009fa:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800009fc:	6985                	lui	s3,0x1
    800009fe:	19fd                	addi	s3,s3,-1
    80000a00:	95ce                	add	a1,a1,s3
    80000a02:	79fd                	lui	s3,0xfffff
    80000a04:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a08:	08c9f063          	bgeu	s3,a2,80000a88 <uvmalloc+0xa6>
    80000a0c:	894e                	mv	s2,s3
    mem = kalloc();
    80000a0e:	fffff097          	auipc	ra,0xfffff
    80000a12:	77a080e7          	jalr	1914(ra) # 80000188 <kalloc>
    80000a16:	84aa                	mv	s1,a0
    if(mem == 0){
    80000a18:	c51d                	beqz	a0,80000a46 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000a1a:	6605                	lui	a2,0x1
    80000a1c:	4581                	li	a1,0
    80000a1e:	00000097          	auipc	ra,0x0
    80000a22:	872080e7          	jalr	-1934(ra) # 80000290 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000a26:	4779                	li	a4,30
    80000a28:	86a6                	mv	a3,s1
    80000a2a:	6605                	lui	a2,0x1
    80000a2c:	85ca                	mv	a1,s2
    80000a2e:	8556                	mv	a0,s5
    80000a30:	00000097          	auipc	ra,0x0
    80000a34:	c40080e7          	jalr	-960(ra) # 80000670 <mappages>
    80000a38:	e905                	bnez	a0,80000a68 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a3a:	6785                	lui	a5,0x1
    80000a3c:	993e                	add	s2,s2,a5
    80000a3e:	fd4968e3          	bltu	s2,s4,80000a0e <uvmalloc+0x2c>
  return newsz;
    80000a42:	8552                	mv	a0,s4
    80000a44:	a809                	j	80000a56 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000a46:	864e                	mv	a2,s3
    80000a48:	85ca                	mv	a1,s2
    80000a4a:	8556                	mv	a0,s5
    80000a4c:	00000097          	auipc	ra,0x0
    80000a50:	f4e080e7          	jalr	-178(ra) # 8000099a <uvmdealloc>
      return 0;
    80000a54:	4501                	li	a0,0
}
    80000a56:	70e2                	ld	ra,56(sp)
    80000a58:	7442                	ld	s0,48(sp)
    80000a5a:	74a2                	ld	s1,40(sp)
    80000a5c:	7902                	ld	s2,32(sp)
    80000a5e:	69e2                	ld	s3,24(sp)
    80000a60:	6a42                	ld	s4,16(sp)
    80000a62:	6aa2                	ld	s5,8(sp)
    80000a64:	6121                	addi	sp,sp,64
    80000a66:	8082                	ret
      kfree(mem);
    80000a68:	8526                	mv	a0,s1
    80000a6a:	fffff097          	auipc	ra,0xfffff
    80000a6e:	5b2080e7          	jalr	1458(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000a72:	864e                	mv	a2,s3
    80000a74:	85ca                	mv	a1,s2
    80000a76:	8556                	mv	a0,s5
    80000a78:	00000097          	auipc	ra,0x0
    80000a7c:	f22080e7          	jalr	-222(ra) # 8000099a <uvmdealloc>
      return 0;
    80000a80:	4501                	li	a0,0
    80000a82:	bfd1                	j	80000a56 <uvmalloc+0x74>
    return oldsz;
    80000a84:	852e                	mv	a0,a1
}
    80000a86:	8082                	ret
  return newsz;
    80000a88:	8532                	mv	a0,a2
    80000a8a:	b7f1                	j	80000a56 <uvmalloc+0x74>

0000000080000a8c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000a8c:	7179                	addi	sp,sp,-48
    80000a8e:	f406                	sd	ra,40(sp)
    80000a90:	f022                	sd	s0,32(sp)
    80000a92:	ec26                	sd	s1,24(sp)
    80000a94:	e84a                	sd	s2,16(sp)
    80000a96:	e44e                	sd	s3,8(sp)
    80000a98:	e052                	sd	s4,0(sp)
    80000a9a:	1800                	addi	s0,sp,48
    80000a9c:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000a9e:	84aa                	mv	s1,a0
    80000aa0:	6905                	lui	s2,0x1
    80000aa2:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000aa4:	4985                	li	s3,1
    80000aa6:	a821                	j	80000abe <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000aa8:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000aaa:	0532                	slli	a0,a0,0xc
    80000aac:	00000097          	auipc	ra,0x0
    80000ab0:	fe0080e7          	jalr	-32(ra) # 80000a8c <freewalk>
      pagetable[i] = 0;
    80000ab4:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000ab8:	04a1                	addi	s1,s1,8
    80000aba:	03248163          	beq	s1,s2,80000adc <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000abe:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000ac0:	00f57793          	andi	a5,a0,15
    80000ac4:	ff3782e3          	beq	a5,s3,80000aa8 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000ac8:	8905                	andi	a0,a0,1
    80000aca:	d57d                	beqz	a0,80000ab8 <freewalk+0x2c>
      panic("freewalk: leaf");
    80000acc:	00007517          	auipc	a0,0x7
    80000ad0:	63c50513          	addi	a0,a0,1596 # 80008108 <etext+0x108>
    80000ad4:	00005097          	auipc	ra,0x5
    80000ad8:	5d8080e7          	jalr	1496(ra) # 800060ac <panic>
    }
  }
  kfree((void*)pagetable);
    80000adc:	8552                	mv	a0,s4
    80000ade:	fffff097          	auipc	ra,0xfffff
    80000ae2:	53e080e7          	jalr	1342(ra) # 8000001c <kfree>
}
    80000ae6:	70a2                	ld	ra,40(sp)
    80000ae8:	7402                	ld	s0,32(sp)
    80000aea:	64e2                	ld	s1,24(sp)
    80000aec:	6942                	ld	s2,16(sp)
    80000aee:	69a2                	ld	s3,8(sp)
    80000af0:	6a02                	ld	s4,0(sp)
    80000af2:	6145                	addi	sp,sp,48
    80000af4:	8082                	ret

0000000080000af6 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000af6:	1101                	addi	sp,sp,-32
    80000af8:	ec06                	sd	ra,24(sp)
    80000afa:	e822                	sd	s0,16(sp)
    80000afc:	e426                	sd	s1,8(sp)
    80000afe:	1000                	addi	s0,sp,32
    80000b00:	84aa                	mv	s1,a0
  if(sz > 0)
    80000b02:	e999                	bnez	a1,80000b18 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000b04:	8526                	mv	a0,s1
    80000b06:	00000097          	auipc	ra,0x0
    80000b0a:	f86080e7          	jalr	-122(ra) # 80000a8c <freewalk>
}
    80000b0e:	60e2                	ld	ra,24(sp)
    80000b10:	6442                	ld	s0,16(sp)
    80000b12:	64a2                	ld	s1,8(sp)
    80000b14:	6105                	addi	sp,sp,32
    80000b16:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000b18:	6605                	lui	a2,0x1
    80000b1a:	167d                	addi	a2,a2,-1
    80000b1c:	962e                	add	a2,a2,a1
    80000b1e:	4685                	li	a3,1
    80000b20:	8231                	srli	a2,a2,0xc
    80000b22:	4581                	li	a1,0
    80000b24:	00000097          	auipc	ra,0x0
    80000b28:	d12080e7          	jalr	-750(ra) # 80000836 <uvmunmap>
    80000b2c:	bfe1                	j	80000b04 <uvmfree+0xe>

0000000080000b2e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000b2e:	c679                	beqz	a2,80000bfc <uvmcopy+0xce>
{
    80000b30:	715d                	addi	sp,sp,-80
    80000b32:	e486                	sd	ra,72(sp)
    80000b34:	e0a2                	sd	s0,64(sp)
    80000b36:	fc26                	sd	s1,56(sp)
    80000b38:	f84a                	sd	s2,48(sp)
    80000b3a:	f44e                	sd	s3,40(sp)
    80000b3c:	f052                	sd	s4,32(sp)
    80000b3e:	ec56                	sd	s5,24(sp)
    80000b40:	e85a                	sd	s6,16(sp)
    80000b42:	e45e                	sd	s7,8(sp)
    80000b44:	0880                	addi	s0,sp,80
    80000b46:	8b2a                	mv	s6,a0
    80000b48:	8aae                	mv	s5,a1
    80000b4a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000b4c:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000b4e:	4601                	li	a2,0
    80000b50:	85ce                	mv	a1,s3
    80000b52:	855a                	mv	a0,s6
    80000b54:	00000097          	auipc	ra,0x0
    80000b58:	a34080e7          	jalr	-1484(ra) # 80000588 <walk>
    80000b5c:	c531                	beqz	a0,80000ba8 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000b5e:	6118                	ld	a4,0(a0)
    80000b60:	00177793          	andi	a5,a4,1
    80000b64:	cbb1                	beqz	a5,80000bb8 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000b66:	00a75593          	srli	a1,a4,0xa
    80000b6a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000b6e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000b72:	fffff097          	auipc	ra,0xfffff
    80000b76:	616080e7          	jalr	1558(ra) # 80000188 <kalloc>
    80000b7a:	892a                	mv	s2,a0
    80000b7c:	c939                	beqz	a0,80000bd2 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000b7e:	6605                	lui	a2,0x1
    80000b80:	85de                	mv	a1,s7
    80000b82:	fffff097          	auipc	ra,0xfffff
    80000b86:	76e080e7          	jalr	1902(ra) # 800002f0 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000b8a:	8726                	mv	a4,s1
    80000b8c:	86ca                	mv	a3,s2
    80000b8e:	6605                	lui	a2,0x1
    80000b90:	85ce                	mv	a1,s3
    80000b92:	8556                	mv	a0,s5
    80000b94:	00000097          	auipc	ra,0x0
    80000b98:	adc080e7          	jalr	-1316(ra) # 80000670 <mappages>
    80000b9c:	e515                	bnez	a0,80000bc8 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000b9e:	6785                	lui	a5,0x1
    80000ba0:	99be                	add	s3,s3,a5
    80000ba2:	fb49e6e3          	bltu	s3,s4,80000b4e <uvmcopy+0x20>
    80000ba6:	a081                	j	80000be6 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ba8:	00007517          	auipc	a0,0x7
    80000bac:	57050513          	addi	a0,a0,1392 # 80008118 <etext+0x118>
    80000bb0:	00005097          	auipc	ra,0x5
    80000bb4:	4fc080e7          	jalr	1276(ra) # 800060ac <panic>
      panic("uvmcopy: page not present");
    80000bb8:	00007517          	auipc	a0,0x7
    80000bbc:	58050513          	addi	a0,a0,1408 # 80008138 <etext+0x138>
    80000bc0:	00005097          	auipc	ra,0x5
    80000bc4:	4ec080e7          	jalr	1260(ra) # 800060ac <panic>
      kfree(mem);
    80000bc8:	854a                	mv	a0,s2
    80000bca:	fffff097          	auipc	ra,0xfffff
    80000bce:	452080e7          	jalr	1106(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000bd2:	4685                	li	a3,1
    80000bd4:	00c9d613          	srli	a2,s3,0xc
    80000bd8:	4581                	li	a1,0
    80000bda:	8556                	mv	a0,s5
    80000bdc:	00000097          	auipc	ra,0x0
    80000be0:	c5a080e7          	jalr	-934(ra) # 80000836 <uvmunmap>
  return -1;
    80000be4:	557d                	li	a0,-1
}
    80000be6:	60a6                	ld	ra,72(sp)
    80000be8:	6406                	ld	s0,64(sp)
    80000bea:	74e2                	ld	s1,56(sp)
    80000bec:	7942                	ld	s2,48(sp)
    80000bee:	79a2                	ld	s3,40(sp)
    80000bf0:	7a02                	ld	s4,32(sp)
    80000bf2:	6ae2                	ld	s5,24(sp)
    80000bf4:	6b42                	ld	s6,16(sp)
    80000bf6:	6ba2                	ld	s7,8(sp)
    80000bf8:	6161                	addi	sp,sp,80
    80000bfa:	8082                	ret
  return 0;
    80000bfc:	4501                	li	a0,0
}
    80000bfe:	8082                	ret

0000000080000c00 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000c00:	1141                	addi	sp,sp,-16
    80000c02:	e406                	sd	ra,8(sp)
    80000c04:	e022                	sd	s0,0(sp)
    80000c06:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000c08:	4601                	li	a2,0
    80000c0a:	00000097          	auipc	ra,0x0
    80000c0e:	97e080e7          	jalr	-1666(ra) # 80000588 <walk>
  if(pte == 0)
    80000c12:	c901                	beqz	a0,80000c22 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000c14:	611c                	ld	a5,0(a0)
    80000c16:	9bbd                	andi	a5,a5,-17
    80000c18:	e11c                	sd	a5,0(a0)
}
    80000c1a:	60a2                	ld	ra,8(sp)
    80000c1c:	6402                	ld	s0,0(sp)
    80000c1e:	0141                	addi	sp,sp,16
    80000c20:	8082                	ret
    panic("uvmclear");
    80000c22:	00007517          	auipc	a0,0x7
    80000c26:	53650513          	addi	a0,a0,1334 # 80008158 <etext+0x158>
    80000c2a:	00005097          	auipc	ra,0x5
    80000c2e:	482080e7          	jalr	1154(ra) # 800060ac <panic>

0000000080000c32 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c32:	c6bd                	beqz	a3,80000ca0 <copyout+0x6e>
{
    80000c34:	715d                	addi	sp,sp,-80
    80000c36:	e486                	sd	ra,72(sp)
    80000c38:	e0a2                	sd	s0,64(sp)
    80000c3a:	fc26                	sd	s1,56(sp)
    80000c3c:	f84a                	sd	s2,48(sp)
    80000c3e:	f44e                	sd	s3,40(sp)
    80000c40:	f052                	sd	s4,32(sp)
    80000c42:	ec56                	sd	s5,24(sp)
    80000c44:	e85a                	sd	s6,16(sp)
    80000c46:	e45e                	sd	s7,8(sp)
    80000c48:	e062                	sd	s8,0(sp)
    80000c4a:	0880                	addi	s0,sp,80
    80000c4c:	8b2a                	mv	s6,a0
    80000c4e:	8c2e                	mv	s8,a1
    80000c50:	8a32                	mv	s4,a2
    80000c52:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000c54:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000c56:	6a85                	lui	s5,0x1
    80000c58:	a015                	j	80000c7c <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000c5a:	9562                	add	a0,a0,s8
    80000c5c:	0004861b          	sext.w	a2,s1
    80000c60:	85d2                	mv	a1,s4
    80000c62:	41250533          	sub	a0,a0,s2
    80000c66:	fffff097          	auipc	ra,0xfffff
    80000c6a:	68a080e7          	jalr	1674(ra) # 800002f0 <memmove>

    len -= n;
    80000c6e:	409989b3          	sub	s3,s3,s1
    src += n;
    80000c72:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000c74:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c78:	02098263          	beqz	s3,80000c9c <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000c7c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c80:	85ca                	mv	a1,s2
    80000c82:	855a                	mv	a0,s6
    80000c84:	00000097          	auipc	ra,0x0
    80000c88:	9aa080e7          	jalr	-1622(ra) # 8000062e <walkaddr>
    if(pa0 == 0)
    80000c8c:	cd01                	beqz	a0,80000ca4 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000c8e:	418904b3          	sub	s1,s2,s8
    80000c92:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c94:	fc99f3e3          	bgeu	s3,s1,80000c5a <copyout+0x28>
    80000c98:	84ce                	mv	s1,s3
    80000c9a:	b7c1                	j	80000c5a <copyout+0x28>
  }
  return 0;
    80000c9c:	4501                	li	a0,0
    80000c9e:	a021                	j	80000ca6 <copyout+0x74>
    80000ca0:	4501                	li	a0,0
}
    80000ca2:	8082                	ret
      return -1;
    80000ca4:	557d                	li	a0,-1
}
    80000ca6:	60a6                	ld	ra,72(sp)
    80000ca8:	6406                	ld	s0,64(sp)
    80000caa:	74e2                	ld	s1,56(sp)
    80000cac:	7942                	ld	s2,48(sp)
    80000cae:	79a2                	ld	s3,40(sp)
    80000cb0:	7a02                	ld	s4,32(sp)
    80000cb2:	6ae2                	ld	s5,24(sp)
    80000cb4:	6b42                	ld	s6,16(sp)
    80000cb6:	6ba2                	ld	s7,8(sp)
    80000cb8:	6c02                	ld	s8,0(sp)
    80000cba:	6161                	addi	sp,sp,80
    80000cbc:	8082                	ret

0000000080000cbe <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000cbe:	c6bd                	beqz	a3,80000d2c <copyin+0x6e>
{
    80000cc0:	715d                	addi	sp,sp,-80
    80000cc2:	e486                	sd	ra,72(sp)
    80000cc4:	e0a2                	sd	s0,64(sp)
    80000cc6:	fc26                	sd	s1,56(sp)
    80000cc8:	f84a                	sd	s2,48(sp)
    80000cca:	f44e                	sd	s3,40(sp)
    80000ccc:	f052                	sd	s4,32(sp)
    80000cce:	ec56                	sd	s5,24(sp)
    80000cd0:	e85a                	sd	s6,16(sp)
    80000cd2:	e45e                	sd	s7,8(sp)
    80000cd4:	e062                	sd	s8,0(sp)
    80000cd6:	0880                	addi	s0,sp,80
    80000cd8:	8b2a                	mv	s6,a0
    80000cda:	8a2e                	mv	s4,a1
    80000cdc:	8c32                	mv	s8,a2
    80000cde:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000ce0:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ce2:	6a85                	lui	s5,0x1
    80000ce4:	a015                	j	80000d08 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000ce6:	9562                	add	a0,a0,s8
    80000ce8:	0004861b          	sext.w	a2,s1
    80000cec:	412505b3          	sub	a1,a0,s2
    80000cf0:	8552                	mv	a0,s4
    80000cf2:	fffff097          	auipc	ra,0xfffff
    80000cf6:	5fe080e7          	jalr	1534(ra) # 800002f0 <memmove>

    len -= n;
    80000cfa:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000cfe:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000d00:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000d04:	02098263          	beqz	s3,80000d28 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000d08:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000d0c:	85ca                	mv	a1,s2
    80000d0e:	855a                	mv	a0,s6
    80000d10:	00000097          	auipc	ra,0x0
    80000d14:	91e080e7          	jalr	-1762(ra) # 8000062e <walkaddr>
    if(pa0 == 0)
    80000d18:	cd01                	beqz	a0,80000d30 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000d1a:	418904b3          	sub	s1,s2,s8
    80000d1e:	94d6                	add	s1,s1,s5
    if(n > len)
    80000d20:	fc99f3e3          	bgeu	s3,s1,80000ce6 <copyin+0x28>
    80000d24:	84ce                	mv	s1,s3
    80000d26:	b7c1                	j	80000ce6 <copyin+0x28>
  }
  return 0;
    80000d28:	4501                	li	a0,0
    80000d2a:	a021                	j	80000d32 <copyin+0x74>
    80000d2c:	4501                	li	a0,0
}
    80000d2e:	8082                	ret
      return -1;
    80000d30:	557d                	li	a0,-1
}
    80000d32:	60a6                	ld	ra,72(sp)
    80000d34:	6406                	ld	s0,64(sp)
    80000d36:	74e2                	ld	s1,56(sp)
    80000d38:	7942                	ld	s2,48(sp)
    80000d3a:	79a2                	ld	s3,40(sp)
    80000d3c:	7a02                	ld	s4,32(sp)
    80000d3e:	6ae2                	ld	s5,24(sp)
    80000d40:	6b42                	ld	s6,16(sp)
    80000d42:	6ba2                	ld	s7,8(sp)
    80000d44:	6c02                	ld	s8,0(sp)
    80000d46:	6161                	addi	sp,sp,80
    80000d48:	8082                	ret

0000000080000d4a <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000d4a:	c6c5                	beqz	a3,80000df2 <copyinstr+0xa8>
{
    80000d4c:	715d                	addi	sp,sp,-80
    80000d4e:	e486                	sd	ra,72(sp)
    80000d50:	e0a2                	sd	s0,64(sp)
    80000d52:	fc26                	sd	s1,56(sp)
    80000d54:	f84a                	sd	s2,48(sp)
    80000d56:	f44e                	sd	s3,40(sp)
    80000d58:	f052                	sd	s4,32(sp)
    80000d5a:	ec56                	sd	s5,24(sp)
    80000d5c:	e85a                	sd	s6,16(sp)
    80000d5e:	e45e                	sd	s7,8(sp)
    80000d60:	0880                	addi	s0,sp,80
    80000d62:	8a2a                	mv	s4,a0
    80000d64:	8b2e                	mv	s6,a1
    80000d66:	8bb2                	mv	s7,a2
    80000d68:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000d6a:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d6c:	6985                	lui	s3,0x1
    80000d6e:	a035                	j	80000d9a <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000d70:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000d74:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000d76:	0017b793          	seqz	a5,a5
    80000d7a:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000d7e:	60a6                	ld	ra,72(sp)
    80000d80:	6406                	ld	s0,64(sp)
    80000d82:	74e2                	ld	s1,56(sp)
    80000d84:	7942                	ld	s2,48(sp)
    80000d86:	79a2                	ld	s3,40(sp)
    80000d88:	7a02                	ld	s4,32(sp)
    80000d8a:	6ae2                	ld	s5,24(sp)
    80000d8c:	6b42                	ld	s6,16(sp)
    80000d8e:	6ba2                	ld	s7,8(sp)
    80000d90:	6161                	addi	sp,sp,80
    80000d92:	8082                	ret
    srcva = va0 + PGSIZE;
    80000d94:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000d98:	c8a9                	beqz	s1,80000dea <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000d9a:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000d9e:	85ca                	mv	a1,s2
    80000da0:	8552                	mv	a0,s4
    80000da2:	00000097          	auipc	ra,0x0
    80000da6:	88c080e7          	jalr	-1908(ra) # 8000062e <walkaddr>
    if(pa0 == 0)
    80000daa:	c131                	beqz	a0,80000dee <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000dac:	41790833          	sub	a6,s2,s7
    80000db0:	984e                	add	a6,a6,s3
    if(n > max)
    80000db2:	0104f363          	bgeu	s1,a6,80000db8 <copyinstr+0x6e>
    80000db6:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000db8:	955e                	add	a0,a0,s7
    80000dba:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000dbe:	fc080be3          	beqz	a6,80000d94 <copyinstr+0x4a>
    80000dc2:	985a                	add	a6,a6,s6
    80000dc4:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000dc6:	41650633          	sub	a2,a0,s6
    80000dca:	14fd                	addi	s1,s1,-1
    80000dcc:	9b26                	add	s6,s6,s1
    80000dce:	00f60733          	add	a4,a2,a5
    80000dd2:	00074703          	lbu	a4,0(a4)
    80000dd6:	df49                	beqz	a4,80000d70 <copyinstr+0x26>
        *dst = *p;
    80000dd8:	00e78023          	sb	a4,0(a5)
      --max;
    80000ddc:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000de0:	0785                	addi	a5,a5,1
    while(n > 0){
    80000de2:	ff0796e3          	bne	a5,a6,80000dce <copyinstr+0x84>
      dst++;
    80000de6:	8b42                	mv	s6,a6
    80000de8:	b775                	j	80000d94 <copyinstr+0x4a>
    80000dea:	4781                	li	a5,0
    80000dec:	b769                	j	80000d76 <copyinstr+0x2c>
      return -1;
    80000dee:	557d                	li	a0,-1
    80000df0:	b779                	j	80000d7e <copyinstr+0x34>
  int got_null = 0;
    80000df2:	4781                	li	a5,0
  if(got_null){
    80000df4:	0017b793          	seqz	a5,a5
    80000df8:	40f00533          	neg	a0,a5
}
    80000dfc:	8082                	ret

0000000080000dfe <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000dfe:	7139                	addi	sp,sp,-64
    80000e00:	fc06                	sd	ra,56(sp)
    80000e02:	f822                	sd	s0,48(sp)
    80000e04:	f426                	sd	s1,40(sp)
    80000e06:	f04a                	sd	s2,32(sp)
    80000e08:	ec4e                	sd	s3,24(sp)
    80000e0a:	e852                	sd	s4,16(sp)
    80000e0c:	e456                	sd	s5,8(sp)
    80000e0e:	e05a                	sd	s6,0(sp)
    80000e10:	0080                	addi	s0,sp,64
    80000e12:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e14:	00008497          	auipc	s1,0x8
    80000e18:	79c48493          	addi	s1,s1,1948 # 800095b0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e1c:	8b26                	mv	s6,s1
    80000e1e:	00007a97          	auipc	s5,0x7
    80000e22:	1e2a8a93          	addi	s5,s5,482 # 80008000 <etext>
    80000e26:	04000937          	lui	s2,0x4000
    80000e2a:	197d                	addi	s2,s2,-1
    80000e2c:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e2e:	0000ea17          	auipc	s4,0xe
    80000e32:	382a0a13          	addi	s4,s4,898 # 8000f1b0 <tickslock>
    char *pa = kalloc();
    80000e36:	fffff097          	auipc	ra,0xfffff
    80000e3a:	352080e7          	jalr	850(ra) # 80000188 <kalloc>
    80000e3e:	862a                	mv	a2,a0
    if(pa == 0)
    80000e40:	c131                	beqz	a0,80000e84 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000e42:	416485b3          	sub	a1,s1,s6
    80000e46:	8591                	srai	a1,a1,0x4
    80000e48:	000ab783          	ld	a5,0(s5)
    80000e4c:	02f585b3          	mul	a1,a1,a5
    80000e50:	2585                	addiw	a1,a1,1
    80000e52:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e56:	4719                	li	a4,6
    80000e58:	6685                	lui	a3,0x1
    80000e5a:	40b905b3          	sub	a1,s2,a1
    80000e5e:	854e                	mv	a0,s3
    80000e60:	00000097          	auipc	ra,0x0
    80000e64:	8b0080e7          	jalr	-1872(ra) # 80000710 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e68:	17048493          	addi	s1,s1,368
    80000e6c:	fd4495e3          	bne	s1,s4,80000e36 <proc_mapstacks+0x38>
  }
}
    80000e70:	70e2                	ld	ra,56(sp)
    80000e72:	7442                	ld	s0,48(sp)
    80000e74:	74a2                	ld	s1,40(sp)
    80000e76:	7902                	ld	s2,32(sp)
    80000e78:	69e2                	ld	s3,24(sp)
    80000e7a:	6a42                	ld	s4,16(sp)
    80000e7c:	6aa2                	ld	s5,8(sp)
    80000e7e:	6b02                	ld	s6,0(sp)
    80000e80:	6121                	addi	sp,sp,64
    80000e82:	8082                	ret
      panic("kalloc");
    80000e84:	00007517          	auipc	a0,0x7
    80000e88:	2e450513          	addi	a0,a0,740 # 80008168 <etext+0x168>
    80000e8c:	00005097          	auipc	ra,0x5
    80000e90:	220080e7          	jalr	544(ra) # 800060ac <panic>

0000000080000e94 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000e94:	7139                	addi	sp,sp,-64
    80000e96:	fc06                	sd	ra,56(sp)
    80000e98:	f822                	sd	s0,48(sp)
    80000e9a:	f426                	sd	s1,40(sp)
    80000e9c:	f04a                	sd	s2,32(sp)
    80000e9e:	ec4e                	sd	s3,24(sp)
    80000ea0:	e852                	sd	s4,16(sp)
    80000ea2:	e456                	sd	s5,8(sp)
    80000ea4:	e05a                	sd	s6,0(sp)
    80000ea6:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000ea8:	00007597          	auipc	a1,0x7
    80000eac:	2c858593          	addi	a1,a1,712 # 80008170 <etext+0x170>
    80000eb0:	00008517          	auipc	a0,0x8
    80000eb4:	2c050513          	addi	a0,a0,704 # 80009170 <pid_lock>
    80000eb8:	00006097          	auipc	ra,0x6
    80000ebc:	8a4080e7          	jalr	-1884(ra) # 8000675c <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ec0:	00007597          	auipc	a1,0x7
    80000ec4:	2b858593          	addi	a1,a1,696 # 80008178 <etext+0x178>
    80000ec8:	00008517          	auipc	a0,0x8
    80000ecc:	2c850513          	addi	a0,a0,712 # 80009190 <wait_lock>
    80000ed0:	00006097          	auipc	ra,0x6
    80000ed4:	88c080e7          	jalr	-1908(ra) # 8000675c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ed8:	00008497          	auipc	s1,0x8
    80000edc:	6d848493          	addi	s1,s1,1752 # 800095b0 <proc>
      initlock(&p->lock, "proc");
    80000ee0:	00007b17          	auipc	s6,0x7
    80000ee4:	2a8b0b13          	addi	s6,s6,680 # 80008188 <etext+0x188>
      p->kstack = KSTACK((int) (p - proc));
    80000ee8:	8aa6                	mv	s5,s1
    80000eea:	00007a17          	auipc	s4,0x7
    80000eee:	116a0a13          	addi	s4,s4,278 # 80008000 <etext>
    80000ef2:	04000937          	lui	s2,0x4000
    80000ef6:	197d                	addi	s2,s2,-1
    80000ef8:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000efa:	0000e997          	auipc	s3,0xe
    80000efe:	2b698993          	addi	s3,s3,694 # 8000f1b0 <tickslock>
      initlock(&p->lock, "proc");
    80000f02:	85da                	mv	a1,s6
    80000f04:	8526                	mv	a0,s1
    80000f06:	00006097          	auipc	ra,0x6
    80000f0a:	856080e7          	jalr	-1962(ra) # 8000675c <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000f0e:	415487b3          	sub	a5,s1,s5
    80000f12:	8791                	srai	a5,a5,0x4
    80000f14:	000a3703          	ld	a4,0(s4)
    80000f18:	02e787b3          	mul	a5,a5,a4
    80000f1c:	2785                	addiw	a5,a5,1
    80000f1e:	00d7979b          	slliw	a5,a5,0xd
    80000f22:	40f907b3          	sub	a5,s2,a5
    80000f26:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f28:	17048493          	addi	s1,s1,368
    80000f2c:	fd349be3          	bne	s1,s3,80000f02 <procinit+0x6e>
  }
}
    80000f30:	70e2                	ld	ra,56(sp)
    80000f32:	7442                	ld	s0,48(sp)
    80000f34:	74a2                	ld	s1,40(sp)
    80000f36:	7902                	ld	s2,32(sp)
    80000f38:	69e2                	ld	s3,24(sp)
    80000f3a:	6a42                	ld	s4,16(sp)
    80000f3c:	6aa2                	ld	s5,8(sp)
    80000f3e:	6b02                	ld	s6,0(sp)
    80000f40:	6121                	addi	sp,sp,64
    80000f42:	8082                	ret

0000000080000f44 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f44:	1141                	addi	sp,sp,-16
    80000f46:	e422                	sd	s0,8(sp)
    80000f48:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f4a:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f4c:	2501                	sext.w	a0,a0
    80000f4e:	6422                	ld	s0,8(sp)
    80000f50:	0141                	addi	sp,sp,16
    80000f52:	8082                	ret

0000000080000f54 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000f54:	1141                	addi	sp,sp,-16
    80000f56:	e422                	sd	s0,8(sp)
    80000f58:	0800                	addi	s0,sp,16
    80000f5a:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f5c:	2781                	sext.w	a5,a5
    80000f5e:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f60:	00008517          	auipc	a0,0x8
    80000f64:	25050513          	addi	a0,a0,592 # 800091b0 <cpus>
    80000f68:	953e                	add	a0,a0,a5
    80000f6a:	6422                	ld	s0,8(sp)
    80000f6c:	0141                	addi	sp,sp,16
    80000f6e:	8082                	ret

0000000080000f70 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000f70:	1101                	addi	sp,sp,-32
    80000f72:	ec06                	sd	ra,24(sp)
    80000f74:	e822                	sd	s0,16(sp)
    80000f76:	e426                	sd	s1,8(sp)
    80000f78:	1000                	addi	s0,sp,32
  push_off();
    80000f7a:	00005097          	auipc	ra,0x5
    80000f7e:	61a080e7          	jalr	1562(ra) # 80006594 <push_off>
    80000f82:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f84:	2781                	sext.w	a5,a5
    80000f86:	079e                	slli	a5,a5,0x7
    80000f88:	00008717          	auipc	a4,0x8
    80000f8c:	1e870713          	addi	a4,a4,488 # 80009170 <pid_lock>
    80000f90:	97ba                	add	a5,a5,a4
    80000f92:	63a4                	ld	s1,64(a5)
  pop_off();
    80000f94:	00005097          	auipc	ra,0x5
    80000f98:	6bc080e7          	jalr	1724(ra) # 80006650 <pop_off>
  return p;
}
    80000f9c:	8526                	mv	a0,s1
    80000f9e:	60e2                	ld	ra,24(sp)
    80000fa0:	6442                	ld	s0,16(sp)
    80000fa2:	64a2                	ld	s1,8(sp)
    80000fa4:	6105                	addi	sp,sp,32
    80000fa6:	8082                	ret

0000000080000fa8 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000fa8:	1141                	addi	sp,sp,-16
    80000faa:	e406                	sd	ra,8(sp)
    80000fac:	e022                	sd	s0,0(sp)
    80000fae:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000fb0:	00000097          	auipc	ra,0x0
    80000fb4:	fc0080e7          	jalr	-64(ra) # 80000f70 <myproc>
    80000fb8:	00005097          	auipc	ra,0x5
    80000fbc:	6f8080e7          	jalr	1784(ra) # 800066b0 <release>

  if (first) {
    80000fc0:	00008797          	auipc	a5,0x8
    80000fc4:	9007a783          	lw	a5,-1792(a5) # 800088c0 <first.1696>
    80000fc8:	eb89                	bnez	a5,80000fda <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000fca:	00001097          	auipc	ra,0x1
    80000fce:	c0a080e7          	jalr	-1014(ra) # 80001bd4 <usertrapret>
}
    80000fd2:	60a2                	ld	ra,8(sp)
    80000fd4:	6402                	ld	s0,0(sp)
    80000fd6:	0141                	addi	sp,sp,16
    80000fd8:	8082                	ret
    first = 0;
    80000fda:	00008797          	auipc	a5,0x8
    80000fde:	8e07a323          	sw	zero,-1818(a5) # 800088c0 <first.1696>
    fsinit(ROOTDEV);
    80000fe2:	4505                	li	a0,1
    80000fe4:	00002097          	auipc	ra,0x2
    80000fe8:	a60080e7          	jalr	-1440(ra) # 80002a44 <fsinit>
    80000fec:	bff9                	j	80000fca <forkret+0x22>

0000000080000fee <allocpid>:
allocpid() {
    80000fee:	1101                	addi	sp,sp,-32
    80000ff0:	ec06                	sd	ra,24(sp)
    80000ff2:	e822                	sd	s0,16(sp)
    80000ff4:	e426                	sd	s1,8(sp)
    80000ff6:	e04a                	sd	s2,0(sp)
    80000ff8:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ffa:	00008917          	auipc	s2,0x8
    80000ffe:	17690913          	addi	s2,s2,374 # 80009170 <pid_lock>
    80001002:	854a                	mv	a0,s2
    80001004:	00005097          	auipc	ra,0x5
    80001008:	5dc080e7          	jalr	1500(ra) # 800065e0 <acquire>
  pid = nextpid;
    8000100c:	00008797          	auipc	a5,0x8
    80001010:	8b878793          	addi	a5,a5,-1864 # 800088c4 <nextpid>
    80001014:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001016:	0014871b          	addiw	a4,s1,1
    8000101a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    8000101c:	854a                	mv	a0,s2
    8000101e:	00005097          	auipc	ra,0x5
    80001022:	692080e7          	jalr	1682(ra) # 800066b0 <release>
}
    80001026:	8526                	mv	a0,s1
    80001028:	60e2                	ld	ra,24(sp)
    8000102a:	6442                	ld	s0,16(sp)
    8000102c:	64a2                	ld	s1,8(sp)
    8000102e:	6902                	ld	s2,0(sp)
    80001030:	6105                	addi	sp,sp,32
    80001032:	8082                	ret

0000000080001034 <proc_pagetable>:
{
    80001034:	1101                	addi	sp,sp,-32
    80001036:	ec06                	sd	ra,24(sp)
    80001038:	e822                	sd	s0,16(sp)
    8000103a:	e426                	sd	s1,8(sp)
    8000103c:	e04a                	sd	s2,0(sp)
    8000103e:	1000                	addi	s0,sp,32
    80001040:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001042:	00000097          	auipc	ra,0x0
    80001046:	8b8080e7          	jalr	-1864(ra) # 800008fa <uvmcreate>
    8000104a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000104c:	c121                	beqz	a0,8000108c <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000104e:	4729                	li	a4,10
    80001050:	00006697          	auipc	a3,0x6
    80001054:	fb068693          	addi	a3,a3,-80 # 80007000 <_trampoline>
    80001058:	6605                	lui	a2,0x1
    8000105a:	040005b7          	lui	a1,0x4000
    8000105e:	15fd                	addi	a1,a1,-1
    80001060:	05b2                	slli	a1,a1,0xc
    80001062:	fffff097          	auipc	ra,0xfffff
    80001066:	60e080e7          	jalr	1550(ra) # 80000670 <mappages>
    8000106a:	02054863          	bltz	a0,8000109a <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000106e:	4719                	li	a4,6
    80001070:	06093683          	ld	a3,96(s2)
    80001074:	6605                	lui	a2,0x1
    80001076:	020005b7          	lui	a1,0x2000
    8000107a:	15fd                	addi	a1,a1,-1
    8000107c:	05b6                	slli	a1,a1,0xd
    8000107e:	8526                	mv	a0,s1
    80001080:	fffff097          	auipc	ra,0xfffff
    80001084:	5f0080e7          	jalr	1520(ra) # 80000670 <mappages>
    80001088:	02054163          	bltz	a0,800010aa <proc_pagetable+0x76>
}
    8000108c:	8526                	mv	a0,s1
    8000108e:	60e2                	ld	ra,24(sp)
    80001090:	6442                	ld	s0,16(sp)
    80001092:	64a2                	ld	s1,8(sp)
    80001094:	6902                	ld	s2,0(sp)
    80001096:	6105                	addi	sp,sp,32
    80001098:	8082                	ret
    uvmfree(pagetable, 0);
    8000109a:	4581                	li	a1,0
    8000109c:	8526                	mv	a0,s1
    8000109e:	00000097          	auipc	ra,0x0
    800010a2:	a58080e7          	jalr	-1448(ra) # 80000af6 <uvmfree>
    return 0;
    800010a6:	4481                	li	s1,0
    800010a8:	b7d5                	j	8000108c <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010aa:	4681                	li	a3,0
    800010ac:	4605                	li	a2,1
    800010ae:	040005b7          	lui	a1,0x4000
    800010b2:	15fd                	addi	a1,a1,-1
    800010b4:	05b2                	slli	a1,a1,0xc
    800010b6:	8526                	mv	a0,s1
    800010b8:	fffff097          	auipc	ra,0xfffff
    800010bc:	77e080e7          	jalr	1918(ra) # 80000836 <uvmunmap>
    uvmfree(pagetable, 0);
    800010c0:	4581                	li	a1,0
    800010c2:	8526                	mv	a0,s1
    800010c4:	00000097          	auipc	ra,0x0
    800010c8:	a32080e7          	jalr	-1486(ra) # 80000af6 <uvmfree>
    return 0;
    800010cc:	4481                	li	s1,0
    800010ce:	bf7d                	j	8000108c <proc_pagetable+0x58>

00000000800010d0 <proc_freepagetable>:
{
    800010d0:	1101                	addi	sp,sp,-32
    800010d2:	ec06                	sd	ra,24(sp)
    800010d4:	e822                	sd	s0,16(sp)
    800010d6:	e426                	sd	s1,8(sp)
    800010d8:	e04a                	sd	s2,0(sp)
    800010da:	1000                	addi	s0,sp,32
    800010dc:	84aa                	mv	s1,a0
    800010de:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010e0:	4681                	li	a3,0
    800010e2:	4605                	li	a2,1
    800010e4:	040005b7          	lui	a1,0x4000
    800010e8:	15fd                	addi	a1,a1,-1
    800010ea:	05b2                	slli	a1,a1,0xc
    800010ec:	fffff097          	auipc	ra,0xfffff
    800010f0:	74a080e7          	jalr	1866(ra) # 80000836 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800010f4:	4681                	li	a3,0
    800010f6:	4605                	li	a2,1
    800010f8:	020005b7          	lui	a1,0x2000
    800010fc:	15fd                	addi	a1,a1,-1
    800010fe:	05b6                	slli	a1,a1,0xd
    80001100:	8526                	mv	a0,s1
    80001102:	fffff097          	auipc	ra,0xfffff
    80001106:	734080e7          	jalr	1844(ra) # 80000836 <uvmunmap>
  uvmfree(pagetable, sz);
    8000110a:	85ca                	mv	a1,s2
    8000110c:	8526                	mv	a0,s1
    8000110e:	00000097          	auipc	ra,0x0
    80001112:	9e8080e7          	jalr	-1560(ra) # 80000af6 <uvmfree>
}
    80001116:	60e2                	ld	ra,24(sp)
    80001118:	6442                	ld	s0,16(sp)
    8000111a:	64a2                	ld	s1,8(sp)
    8000111c:	6902                	ld	s2,0(sp)
    8000111e:	6105                	addi	sp,sp,32
    80001120:	8082                	ret

0000000080001122 <freeproc>:
{
    80001122:	1101                	addi	sp,sp,-32
    80001124:	ec06                	sd	ra,24(sp)
    80001126:	e822                	sd	s0,16(sp)
    80001128:	e426                	sd	s1,8(sp)
    8000112a:	1000                	addi	s0,sp,32
    8000112c:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000112e:	7128                	ld	a0,96(a0)
    80001130:	c509                	beqz	a0,8000113a <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001132:	fffff097          	auipc	ra,0xfffff
    80001136:	eea080e7          	jalr	-278(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000113a:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    8000113e:	6ca8                	ld	a0,88(s1)
    80001140:	c511                	beqz	a0,8000114c <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001142:	68ac                	ld	a1,80(s1)
    80001144:	00000097          	auipc	ra,0x0
    80001148:	f8c080e7          	jalr	-116(ra) # 800010d0 <proc_freepagetable>
  p->pagetable = 0;
    8000114c:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001150:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    80001154:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001158:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    8000115c:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001160:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001164:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001168:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    8000116c:	0204a023          	sw	zero,32(s1)
}
    80001170:	60e2                	ld	ra,24(sp)
    80001172:	6442                	ld	s0,16(sp)
    80001174:	64a2                	ld	s1,8(sp)
    80001176:	6105                	addi	sp,sp,32
    80001178:	8082                	ret

000000008000117a <allocproc>:
{
    8000117a:	1101                	addi	sp,sp,-32
    8000117c:	ec06                	sd	ra,24(sp)
    8000117e:	e822                	sd	s0,16(sp)
    80001180:	e426                	sd	s1,8(sp)
    80001182:	e04a                	sd	s2,0(sp)
    80001184:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001186:	00008497          	auipc	s1,0x8
    8000118a:	42a48493          	addi	s1,s1,1066 # 800095b0 <proc>
    8000118e:	0000e917          	auipc	s2,0xe
    80001192:	02290913          	addi	s2,s2,34 # 8000f1b0 <tickslock>
    acquire(&p->lock);
    80001196:	8526                	mv	a0,s1
    80001198:	00005097          	auipc	ra,0x5
    8000119c:	448080e7          	jalr	1096(ra) # 800065e0 <acquire>
    if(p->state == UNUSED) {
    800011a0:	509c                	lw	a5,32(s1)
    800011a2:	cf81                	beqz	a5,800011ba <allocproc+0x40>
      release(&p->lock);
    800011a4:	8526                	mv	a0,s1
    800011a6:	00005097          	auipc	ra,0x5
    800011aa:	50a080e7          	jalr	1290(ra) # 800066b0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800011ae:	17048493          	addi	s1,s1,368
    800011b2:	ff2492e3          	bne	s1,s2,80001196 <allocproc+0x1c>
  return 0;
    800011b6:	4481                	li	s1,0
    800011b8:	a889                	j	8000120a <allocproc+0x90>
  p->pid = allocpid();
    800011ba:	00000097          	auipc	ra,0x0
    800011be:	e34080e7          	jalr	-460(ra) # 80000fee <allocpid>
    800011c2:	dc88                	sw	a0,56(s1)
  p->state = USED;
    800011c4:	4785                	li	a5,1
    800011c6:	d09c                	sw	a5,32(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800011c8:	fffff097          	auipc	ra,0xfffff
    800011cc:	fc0080e7          	jalr	-64(ra) # 80000188 <kalloc>
    800011d0:	892a                	mv	s2,a0
    800011d2:	f0a8                	sd	a0,96(s1)
    800011d4:	c131                	beqz	a0,80001218 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800011d6:	8526                	mv	a0,s1
    800011d8:	00000097          	auipc	ra,0x0
    800011dc:	e5c080e7          	jalr	-420(ra) # 80001034 <proc_pagetable>
    800011e0:	892a                	mv	s2,a0
    800011e2:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    800011e4:	c531                	beqz	a0,80001230 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800011e6:	07000613          	li	a2,112
    800011ea:	4581                	li	a1,0
    800011ec:	06848513          	addi	a0,s1,104
    800011f0:	fffff097          	auipc	ra,0xfffff
    800011f4:	0a0080e7          	jalr	160(ra) # 80000290 <memset>
  p->context.ra = (uint64)forkret;
    800011f8:	00000797          	auipc	a5,0x0
    800011fc:	db078793          	addi	a5,a5,-592 # 80000fa8 <forkret>
    80001200:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001202:	64bc                	ld	a5,72(s1)
    80001204:	6705                	lui	a4,0x1
    80001206:	97ba                	add	a5,a5,a4
    80001208:	f8bc                	sd	a5,112(s1)
}
    8000120a:	8526                	mv	a0,s1
    8000120c:	60e2                	ld	ra,24(sp)
    8000120e:	6442                	ld	s0,16(sp)
    80001210:	64a2                	ld	s1,8(sp)
    80001212:	6902                	ld	s2,0(sp)
    80001214:	6105                	addi	sp,sp,32
    80001216:	8082                	ret
    freeproc(p);
    80001218:	8526                	mv	a0,s1
    8000121a:	00000097          	auipc	ra,0x0
    8000121e:	f08080e7          	jalr	-248(ra) # 80001122 <freeproc>
    release(&p->lock);
    80001222:	8526                	mv	a0,s1
    80001224:	00005097          	auipc	ra,0x5
    80001228:	48c080e7          	jalr	1164(ra) # 800066b0 <release>
    return 0;
    8000122c:	84ca                	mv	s1,s2
    8000122e:	bff1                	j	8000120a <allocproc+0x90>
    freeproc(p);
    80001230:	8526                	mv	a0,s1
    80001232:	00000097          	auipc	ra,0x0
    80001236:	ef0080e7          	jalr	-272(ra) # 80001122 <freeproc>
    release(&p->lock);
    8000123a:	8526                	mv	a0,s1
    8000123c:	00005097          	auipc	ra,0x5
    80001240:	474080e7          	jalr	1140(ra) # 800066b0 <release>
    return 0;
    80001244:	84ca                	mv	s1,s2
    80001246:	b7d1                	j	8000120a <allocproc+0x90>

0000000080001248 <userinit>:
{
    80001248:	1101                	addi	sp,sp,-32
    8000124a:	ec06                	sd	ra,24(sp)
    8000124c:	e822                	sd	s0,16(sp)
    8000124e:	e426                	sd	s1,8(sp)
    80001250:	1000                	addi	s0,sp,32
  p = allocproc();
    80001252:	00000097          	auipc	ra,0x0
    80001256:	f28080e7          	jalr	-216(ra) # 8000117a <allocproc>
    8000125a:	84aa                	mv	s1,a0
  initproc = p;
    8000125c:	00008797          	auipc	a5,0x8
    80001260:	daa7ba23          	sd	a0,-588(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001264:	03400613          	li	a2,52
    80001268:	00007597          	auipc	a1,0x7
    8000126c:	66858593          	addi	a1,a1,1640 # 800088d0 <initcode>
    80001270:	6d28                	ld	a0,88(a0)
    80001272:	fffff097          	auipc	ra,0xfffff
    80001276:	6b6080e7          	jalr	1718(ra) # 80000928 <uvminit>
  p->sz = PGSIZE;
    8000127a:	6785                	lui	a5,0x1
    8000127c:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    8000127e:	70b8                	ld	a4,96(s1)
    80001280:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001284:	70b8                	ld	a4,96(s1)
    80001286:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001288:	4641                	li	a2,16
    8000128a:	00007597          	auipc	a1,0x7
    8000128e:	f0658593          	addi	a1,a1,-250 # 80008190 <etext+0x190>
    80001292:	16048513          	addi	a0,s1,352
    80001296:	fffff097          	auipc	ra,0xfffff
    8000129a:	14c080e7          	jalr	332(ra) # 800003e2 <safestrcpy>
  p->cwd = namei("/");
    8000129e:	00007517          	auipc	a0,0x7
    800012a2:	f0250513          	addi	a0,a0,-254 # 800081a0 <etext+0x1a0>
    800012a6:	00002097          	auipc	ra,0x2
    800012aa:	1cc080e7          	jalr	460(ra) # 80003472 <namei>
    800012ae:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    800012b2:	478d                	li	a5,3
    800012b4:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    800012b6:	8526                	mv	a0,s1
    800012b8:	00005097          	auipc	ra,0x5
    800012bc:	3f8080e7          	jalr	1016(ra) # 800066b0 <release>
}
    800012c0:	60e2                	ld	ra,24(sp)
    800012c2:	6442                	ld	s0,16(sp)
    800012c4:	64a2                	ld	s1,8(sp)
    800012c6:	6105                	addi	sp,sp,32
    800012c8:	8082                	ret

00000000800012ca <growproc>:
{
    800012ca:	1101                	addi	sp,sp,-32
    800012cc:	ec06                	sd	ra,24(sp)
    800012ce:	e822                	sd	s0,16(sp)
    800012d0:	e426                	sd	s1,8(sp)
    800012d2:	e04a                	sd	s2,0(sp)
    800012d4:	1000                	addi	s0,sp,32
    800012d6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800012d8:	00000097          	auipc	ra,0x0
    800012dc:	c98080e7          	jalr	-872(ra) # 80000f70 <myproc>
    800012e0:	892a                	mv	s2,a0
  sz = p->sz;
    800012e2:	692c                	ld	a1,80(a0)
    800012e4:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800012e8:	00904f63          	bgtz	s1,80001306 <growproc+0x3c>
  } else if(n < 0){
    800012ec:	0204cc63          	bltz	s1,80001324 <growproc+0x5a>
  p->sz = sz;
    800012f0:	1602                	slli	a2,a2,0x20
    800012f2:	9201                	srli	a2,a2,0x20
    800012f4:	04c93823          	sd	a2,80(s2)
  return 0;
    800012f8:	4501                	li	a0,0
}
    800012fa:	60e2                	ld	ra,24(sp)
    800012fc:	6442                	ld	s0,16(sp)
    800012fe:	64a2                	ld	s1,8(sp)
    80001300:	6902                	ld	s2,0(sp)
    80001302:	6105                	addi	sp,sp,32
    80001304:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001306:	9e25                	addw	a2,a2,s1
    80001308:	1602                	slli	a2,a2,0x20
    8000130a:	9201                	srli	a2,a2,0x20
    8000130c:	1582                	slli	a1,a1,0x20
    8000130e:	9181                	srli	a1,a1,0x20
    80001310:	6d28                	ld	a0,88(a0)
    80001312:	fffff097          	auipc	ra,0xfffff
    80001316:	6d0080e7          	jalr	1744(ra) # 800009e2 <uvmalloc>
    8000131a:	0005061b          	sext.w	a2,a0
    8000131e:	fa69                	bnez	a2,800012f0 <growproc+0x26>
      return -1;
    80001320:	557d                	li	a0,-1
    80001322:	bfe1                	j	800012fa <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001324:	9e25                	addw	a2,a2,s1
    80001326:	1602                	slli	a2,a2,0x20
    80001328:	9201                	srli	a2,a2,0x20
    8000132a:	1582                	slli	a1,a1,0x20
    8000132c:	9181                	srli	a1,a1,0x20
    8000132e:	6d28                	ld	a0,88(a0)
    80001330:	fffff097          	auipc	ra,0xfffff
    80001334:	66a080e7          	jalr	1642(ra) # 8000099a <uvmdealloc>
    80001338:	0005061b          	sext.w	a2,a0
    8000133c:	bf55                	j	800012f0 <growproc+0x26>

000000008000133e <fork>:
{
    8000133e:	7179                	addi	sp,sp,-48
    80001340:	f406                	sd	ra,40(sp)
    80001342:	f022                	sd	s0,32(sp)
    80001344:	ec26                	sd	s1,24(sp)
    80001346:	e84a                	sd	s2,16(sp)
    80001348:	e44e                	sd	s3,8(sp)
    8000134a:	e052                	sd	s4,0(sp)
    8000134c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000134e:	00000097          	auipc	ra,0x0
    80001352:	c22080e7          	jalr	-990(ra) # 80000f70 <myproc>
    80001356:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001358:	00000097          	auipc	ra,0x0
    8000135c:	e22080e7          	jalr	-478(ra) # 8000117a <allocproc>
    80001360:	10050b63          	beqz	a0,80001476 <fork+0x138>
    80001364:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001366:	05093603          	ld	a2,80(s2)
    8000136a:	6d2c                	ld	a1,88(a0)
    8000136c:	05893503          	ld	a0,88(s2)
    80001370:	fffff097          	auipc	ra,0xfffff
    80001374:	7be080e7          	jalr	1982(ra) # 80000b2e <uvmcopy>
    80001378:	04054663          	bltz	a0,800013c4 <fork+0x86>
  np->sz = p->sz;
    8000137c:	05093783          	ld	a5,80(s2)
    80001380:	04f9b823          	sd	a5,80(s3)
  *(np->trapframe) = *(p->trapframe);
    80001384:	06093683          	ld	a3,96(s2)
    80001388:	87b6                	mv	a5,a3
    8000138a:	0609b703          	ld	a4,96(s3)
    8000138e:	12068693          	addi	a3,a3,288
    80001392:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001396:	6788                	ld	a0,8(a5)
    80001398:	6b8c                	ld	a1,16(a5)
    8000139a:	6f90                	ld	a2,24(a5)
    8000139c:	01073023          	sd	a6,0(a4)
    800013a0:	e708                	sd	a0,8(a4)
    800013a2:	eb0c                	sd	a1,16(a4)
    800013a4:	ef10                	sd	a2,24(a4)
    800013a6:	02078793          	addi	a5,a5,32
    800013aa:	02070713          	addi	a4,a4,32
    800013ae:	fed792e3          	bne	a5,a3,80001392 <fork+0x54>
  np->trapframe->a0 = 0;
    800013b2:	0609b783          	ld	a5,96(s3)
    800013b6:	0607b823          	sd	zero,112(a5)
    800013ba:	0d800493          	li	s1,216
  for(i = 0; i < NOFILE; i++)
    800013be:	15800a13          	li	s4,344
    800013c2:	a03d                	j	800013f0 <fork+0xb2>
    freeproc(np);
    800013c4:	854e                	mv	a0,s3
    800013c6:	00000097          	auipc	ra,0x0
    800013ca:	d5c080e7          	jalr	-676(ra) # 80001122 <freeproc>
    release(&np->lock);
    800013ce:	854e                	mv	a0,s3
    800013d0:	00005097          	auipc	ra,0x5
    800013d4:	2e0080e7          	jalr	736(ra) # 800066b0 <release>
    return -1;
    800013d8:	5a7d                	li	s4,-1
    800013da:	a069                	j	80001464 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    800013dc:	00002097          	auipc	ra,0x2
    800013e0:	72c080e7          	jalr	1836(ra) # 80003b08 <filedup>
    800013e4:	009987b3          	add	a5,s3,s1
    800013e8:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800013ea:	04a1                	addi	s1,s1,8
    800013ec:	01448763          	beq	s1,s4,800013fa <fork+0xbc>
    if(p->ofile[i])
    800013f0:	009907b3          	add	a5,s2,s1
    800013f4:	6388                	ld	a0,0(a5)
    800013f6:	f17d                	bnez	a0,800013dc <fork+0x9e>
    800013f8:	bfcd                	j	800013ea <fork+0xac>
  np->cwd = idup(p->cwd);
    800013fa:	15893503          	ld	a0,344(s2)
    800013fe:	00002097          	auipc	ra,0x2
    80001402:	880080e7          	jalr	-1920(ra) # 80002c7e <idup>
    80001406:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000140a:	4641                	li	a2,16
    8000140c:	16090593          	addi	a1,s2,352
    80001410:	16098513          	addi	a0,s3,352
    80001414:	fffff097          	auipc	ra,0xfffff
    80001418:	fce080e7          	jalr	-50(ra) # 800003e2 <safestrcpy>
  pid = np->pid;
    8000141c:	0389aa03          	lw	s4,56(s3)
  release(&np->lock);
    80001420:	854e                	mv	a0,s3
    80001422:	00005097          	auipc	ra,0x5
    80001426:	28e080e7          	jalr	654(ra) # 800066b0 <release>
  acquire(&wait_lock);
    8000142a:	00008497          	auipc	s1,0x8
    8000142e:	d6648493          	addi	s1,s1,-666 # 80009190 <wait_lock>
    80001432:	8526                	mv	a0,s1
    80001434:	00005097          	auipc	ra,0x5
    80001438:	1ac080e7          	jalr	428(ra) # 800065e0 <acquire>
  np->parent = p;
    8000143c:	0529b023          	sd	s2,64(s3)
  release(&wait_lock);
    80001440:	8526                	mv	a0,s1
    80001442:	00005097          	auipc	ra,0x5
    80001446:	26e080e7          	jalr	622(ra) # 800066b0 <release>
  acquire(&np->lock);
    8000144a:	854e                	mv	a0,s3
    8000144c:	00005097          	auipc	ra,0x5
    80001450:	194080e7          	jalr	404(ra) # 800065e0 <acquire>
  np->state = RUNNABLE;
    80001454:	478d                	li	a5,3
    80001456:	02f9a023          	sw	a5,32(s3)
  release(&np->lock);
    8000145a:	854e                	mv	a0,s3
    8000145c:	00005097          	auipc	ra,0x5
    80001460:	254080e7          	jalr	596(ra) # 800066b0 <release>
}
    80001464:	8552                	mv	a0,s4
    80001466:	70a2                	ld	ra,40(sp)
    80001468:	7402                	ld	s0,32(sp)
    8000146a:	64e2                	ld	s1,24(sp)
    8000146c:	6942                	ld	s2,16(sp)
    8000146e:	69a2                	ld	s3,8(sp)
    80001470:	6a02                	ld	s4,0(sp)
    80001472:	6145                	addi	sp,sp,48
    80001474:	8082                	ret
    return -1;
    80001476:	5a7d                	li	s4,-1
    80001478:	b7f5                	j	80001464 <fork+0x126>

000000008000147a <scheduler>:
{
    8000147a:	7139                	addi	sp,sp,-64
    8000147c:	fc06                	sd	ra,56(sp)
    8000147e:	f822                	sd	s0,48(sp)
    80001480:	f426                	sd	s1,40(sp)
    80001482:	f04a                	sd	s2,32(sp)
    80001484:	ec4e                	sd	s3,24(sp)
    80001486:	e852                	sd	s4,16(sp)
    80001488:	e456                	sd	s5,8(sp)
    8000148a:	e05a                	sd	s6,0(sp)
    8000148c:	0080                	addi	s0,sp,64
    8000148e:	8792                	mv	a5,tp
  int id = r_tp();
    80001490:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001492:	00779a93          	slli	s5,a5,0x7
    80001496:	00008717          	auipc	a4,0x8
    8000149a:	cda70713          	addi	a4,a4,-806 # 80009170 <pid_lock>
    8000149e:	9756                	add	a4,a4,s5
    800014a0:	04073023          	sd	zero,64(a4)
        swtch(&c->context, &p->context);
    800014a4:	00008717          	auipc	a4,0x8
    800014a8:	d1470713          	addi	a4,a4,-748 # 800091b8 <cpus+0x8>
    800014ac:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800014ae:	498d                	li	s3,3
        p->state = RUNNING;
    800014b0:	4b11                	li	s6,4
        c->proc = p;
    800014b2:	079e                	slli	a5,a5,0x7
    800014b4:	00008a17          	auipc	s4,0x8
    800014b8:	cbca0a13          	addi	s4,s4,-836 # 80009170 <pid_lock>
    800014bc:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800014be:	0000e917          	auipc	s2,0xe
    800014c2:	cf290913          	addi	s2,s2,-782 # 8000f1b0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014c6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800014ca:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800014ce:	10079073          	csrw	sstatus,a5
    800014d2:	00008497          	auipc	s1,0x8
    800014d6:	0de48493          	addi	s1,s1,222 # 800095b0 <proc>
    800014da:	a03d                	j	80001508 <scheduler+0x8e>
        p->state = RUNNING;
    800014dc:	0364a023          	sw	s6,32(s1)
        c->proc = p;
    800014e0:	049a3023          	sd	s1,64(s4)
        swtch(&c->context, &p->context);
    800014e4:	06848593          	addi	a1,s1,104
    800014e8:	8556                	mv	a0,s5
    800014ea:	00000097          	auipc	ra,0x0
    800014ee:	640080e7          	jalr	1600(ra) # 80001b2a <swtch>
        c->proc = 0;
    800014f2:	040a3023          	sd	zero,64(s4)
      release(&p->lock);
    800014f6:	8526                	mv	a0,s1
    800014f8:	00005097          	auipc	ra,0x5
    800014fc:	1b8080e7          	jalr	440(ra) # 800066b0 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001500:	17048493          	addi	s1,s1,368
    80001504:	fd2481e3          	beq	s1,s2,800014c6 <scheduler+0x4c>
      acquire(&p->lock);
    80001508:	8526                	mv	a0,s1
    8000150a:	00005097          	auipc	ra,0x5
    8000150e:	0d6080e7          	jalr	214(ra) # 800065e0 <acquire>
      if(p->state == RUNNABLE) {
    80001512:	509c                	lw	a5,32(s1)
    80001514:	ff3791e3          	bne	a5,s3,800014f6 <scheduler+0x7c>
    80001518:	b7d1                	j	800014dc <scheduler+0x62>

000000008000151a <sched>:
{
    8000151a:	7179                	addi	sp,sp,-48
    8000151c:	f406                	sd	ra,40(sp)
    8000151e:	f022                	sd	s0,32(sp)
    80001520:	ec26                	sd	s1,24(sp)
    80001522:	e84a                	sd	s2,16(sp)
    80001524:	e44e                	sd	s3,8(sp)
    80001526:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001528:	00000097          	auipc	ra,0x0
    8000152c:	a48080e7          	jalr	-1464(ra) # 80000f70 <myproc>
    80001530:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001532:	00005097          	auipc	ra,0x5
    80001536:	034080e7          	jalr	52(ra) # 80006566 <holding>
    8000153a:	c93d                	beqz	a0,800015b0 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000153c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000153e:	2781                	sext.w	a5,a5
    80001540:	079e                	slli	a5,a5,0x7
    80001542:	00008717          	auipc	a4,0x8
    80001546:	c2e70713          	addi	a4,a4,-978 # 80009170 <pid_lock>
    8000154a:	97ba                	add	a5,a5,a4
    8000154c:	0b87a703          	lw	a4,184(a5)
    80001550:	4785                	li	a5,1
    80001552:	06f71763          	bne	a4,a5,800015c0 <sched+0xa6>
  if(p->state == RUNNING)
    80001556:	5098                	lw	a4,32(s1)
    80001558:	4791                	li	a5,4
    8000155a:	06f70b63          	beq	a4,a5,800015d0 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000155e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001562:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001564:	efb5                	bnez	a5,800015e0 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001566:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001568:	00008917          	auipc	s2,0x8
    8000156c:	c0890913          	addi	s2,s2,-1016 # 80009170 <pid_lock>
    80001570:	2781                	sext.w	a5,a5
    80001572:	079e                	slli	a5,a5,0x7
    80001574:	97ca                	add	a5,a5,s2
    80001576:	0bc7a983          	lw	s3,188(a5)
    8000157a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000157c:	2781                	sext.w	a5,a5
    8000157e:	079e                	slli	a5,a5,0x7
    80001580:	00008597          	auipc	a1,0x8
    80001584:	c3858593          	addi	a1,a1,-968 # 800091b8 <cpus+0x8>
    80001588:	95be                	add	a1,a1,a5
    8000158a:	06848513          	addi	a0,s1,104
    8000158e:	00000097          	auipc	ra,0x0
    80001592:	59c080e7          	jalr	1436(ra) # 80001b2a <swtch>
    80001596:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001598:	2781                	sext.w	a5,a5
    8000159a:	079e                	slli	a5,a5,0x7
    8000159c:	97ca                	add	a5,a5,s2
    8000159e:	0b37ae23          	sw	s3,188(a5)
}
    800015a2:	70a2                	ld	ra,40(sp)
    800015a4:	7402                	ld	s0,32(sp)
    800015a6:	64e2                	ld	s1,24(sp)
    800015a8:	6942                	ld	s2,16(sp)
    800015aa:	69a2                	ld	s3,8(sp)
    800015ac:	6145                	addi	sp,sp,48
    800015ae:	8082                	ret
    panic("sched p->lock");
    800015b0:	00007517          	auipc	a0,0x7
    800015b4:	bf850513          	addi	a0,a0,-1032 # 800081a8 <etext+0x1a8>
    800015b8:	00005097          	auipc	ra,0x5
    800015bc:	af4080e7          	jalr	-1292(ra) # 800060ac <panic>
    panic("sched locks");
    800015c0:	00007517          	auipc	a0,0x7
    800015c4:	bf850513          	addi	a0,a0,-1032 # 800081b8 <etext+0x1b8>
    800015c8:	00005097          	auipc	ra,0x5
    800015cc:	ae4080e7          	jalr	-1308(ra) # 800060ac <panic>
    panic("sched running");
    800015d0:	00007517          	auipc	a0,0x7
    800015d4:	bf850513          	addi	a0,a0,-1032 # 800081c8 <etext+0x1c8>
    800015d8:	00005097          	auipc	ra,0x5
    800015dc:	ad4080e7          	jalr	-1324(ra) # 800060ac <panic>
    panic("sched interruptible");
    800015e0:	00007517          	auipc	a0,0x7
    800015e4:	bf850513          	addi	a0,a0,-1032 # 800081d8 <etext+0x1d8>
    800015e8:	00005097          	auipc	ra,0x5
    800015ec:	ac4080e7          	jalr	-1340(ra) # 800060ac <panic>

00000000800015f0 <yield>:
{
    800015f0:	1101                	addi	sp,sp,-32
    800015f2:	ec06                	sd	ra,24(sp)
    800015f4:	e822                	sd	s0,16(sp)
    800015f6:	e426                	sd	s1,8(sp)
    800015f8:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800015fa:	00000097          	auipc	ra,0x0
    800015fe:	976080e7          	jalr	-1674(ra) # 80000f70 <myproc>
    80001602:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001604:	00005097          	auipc	ra,0x5
    80001608:	fdc080e7          	jalr	-36(ra) # 800065e0 <acquire>
  p->state = RUNNABLE;
    8000160c:	478d                	li	a5,3
    8000160e:	d09c                	sw	a5,32(s1)
  sched();
    80001610:	00000097          	auipc	ra,0x0
    80001614:	f0a080e7          	jalr	-246(ra) # 8000151a <sched>
  release(&p->lock);
    80001618:	8526                	mv	a0,s1
    8000161a:	00005097          	auipc	ra,0x5
    8000161e:	096080e7          	jalr	150(ra) # 800066b0 <release>
}
    80001622:	60e2                	ld	ra,24(sp)
    80001624:	6442                	ld	s0,16(sp)
    80001626:	64a2                	ld	s1,8(sp)
    80001628:	6105                	addi	sp,sp,32
    8000162a:	8082                	ret

000000008000162c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000162c:	7179                	addi	sp,sp,-48
    8000162e:	f406                	sd	ra,40(sp)
    80001630:	f022                	sd	s0,32(sp)
    80001632:	ec26                	sd	s1,24(sp)
    80001634:	e84a                	sd	s2,16(sp)
    80001636:	e44e                	sd	s3,8(sp)
    80001638:	1800                	addi	s0,sp,48
    8000163a:	89aa                	mv	s3,a0
    8000163c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000163e:	00000097          	auipc	ra,0x0
    80001642:	932080e7          	jalr	-1742(ra) # 80000f70 <myproc>
    80001646:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001648:	00005097          	auipc	ra,0x5
    8000164c:	f98080e7          	jalr	-104(ra) # 800065e0 <acquire>
  release(lk);
    80001650:	854a                	mv	a0,s2
    80001652:	00005097          	auipc	ra,0x5
    80001656:	05e080e7          	jalr	94(ra) # 800066b0 <release>

  // Go to sleep.
  p->chan = chan;
    8000165a:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    8000165e:	4789                	li	a5,2
    80001660:	d09c                	sw	a5,32(s1)

  sched();
    80001662:	00000097          	auipc	ra,0x0
    80001666:	eb8080e7          	jalr	-328(ra) # 8000151a <sched>

  // Tidy up.
  p->chan = 0;
    8000166a:	0204b423          	sd	zero,40(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000166e:	8526                	mv	a0,s1
    80001670:	00005097          	auipc	ra,0x5
    80001674:	040080e7          	jalr	64(ra) # 800066b0 <release>
  acquire(lk);
    80001678:	854a                	mv	a0,s2
    8000167a:	00005097          	auipc	ra,0x5
    8000167e:	f66080e7          	jalr	-154(ra) # 800065e0 <acquire>
}
    80001682:	70a2                	ld	ra,40(sp)
    80001684:	7402                	ld	s0,32(sp)
    80001686:	64e2                	ld	s1,24(sp)
    80001688:	6942                	ld	s2,16(sp)
    8000168a:	69a2                	ld	s3,8(sp)
    8000168c:	6145                	addi	sp,sp,48
    8000168e:	8082                	ret

0000000080001690 <wait>:
{
    80001690:	715d                	addi	sp,sp,-80
    80001692:	e486                	sd	ra,72(sp)
    80001694:	e0a2                	sd	s0,64(sp)
    80001696:	fc26                	sd	s1,56(sp)
    80001698:	f84a                	sd	s2,48(sp)
    8000169a:	f44e                	sd	s3,40(sp)
    8000169c:	f052                	sd	s4,32(sp)
    8000169e:	ec56                	sd	s5,24(sp)
    800016a0:	e85a                	sd	s6,16(sp)
    800016a2:	e45e                	sd	s7,8(sp)
    800016a4:	e062                	sd	s8,0(sp)
    800016a6:	0880                	addi	s0,sp,80
    800016a8:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800016aa:	00000097          	auipc	ra,0x0
    800016ae:	8c6080e7          	jalr	-1850(ra) # 80000f70 <myproc>
    800016b2:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800016b4:	00008517          	auipc	a0,0x8
    800016b8:	adc50513          	addi	a0,a0,-1316 # 80009190 <wait_lock>
    800016bc:	00005097          	auipc	ra,0x5
    800016c0:	f24080e7          	jalr	-220(ra) # 800065e0 <acquire>
    havekids = 0;
    800016c4:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800016c6:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800016c8:	0000e997          	auipc	s3,0xe
    800016cc:	ae898993          	addi	s3,s3,-1304 # 8000f1b0 <tickslock>
        havekids = 1;
    800016d0:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016d2:	00008c17          	auipc	s8,0x8
    800016d6:	abec0c13          	addi	s8,s8,-1346 # 80009190 <wait_lock>
    havekids = 0;
    800016da:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800016dc:	00008497          	auipc	s1,0x8
    800016e0:	ed448493          	addi	s1,s1,-300 # 800095b0 <proc>
    800016e4:	a0bd                	j	80001752 <wait+0xc2>
          pid = np->pid;
    800016e6:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800016ea:	000b0e63          	beqz	s6,80001706 <wait+0x76>
    800016ee:	4691                	li	a3,4
    800016f0:	03448613          	addi	a2,s1,52
    800016f4:	85da                	mv	a1,s6
    800016f6:	05893503          	ld	a0,88(s2)
    800016fa:	fffff097          	auipc	ra,0xfffff
    800016fe:	538080e7          	jalr	1336(ra) # 80000c32 <copyout>
    80001702:	02054563          	bltz	a0,8000172c <wait+0x9c>
          freeproc(np);
    80001706:	8526                	mv	a0,s1
    80001708:	00000097          	auipc	ra,0x0
    8000170c:	a1a080e7          	jalr	-1510(ra) # 80001122 <freeproc>
          release(&np->lock);
    80001710:	8526                	mv	a0,s1
    80001712:	00005097          	auipc	ra,0x5
    80001716:	f9e080e7          	jalr	-98(ra) # 800066b0 <release>
          release(&wait_lock);
    8000171a:	00008517          	auipc	a0,0x8
    8000171e:	a7650513          	addi	a0,a0,-1418 # 80009190 <wait_lock>
    80001722:	00005097          	auipc	ra,0x5
    80001726:	f8e080e7          	jalr	-114(ra) # 800066b0 <release>
          return pid;
    8000172a:	a09d                	j	80001790 <wait+0x100>
            release(&np->lock);
    8000172c:	8526                	mv	a0,s1
    8000172e:	00005097          	auipc	ra,0x5
    80001732:	f82080e7          	jalr	-126(ra) # 800066b0 <release>
            release(&wait_lock);
    80001736:	00008517          	auipc	a0,0x8
    8000173a:	a5a50513          	addi	a0,a0,-1446 # 80009190 <wait_lock>
    8000173e:	00005097          	auipc	ra,0x5
    80001742:	f72080e7          	jalr	-142(ra) # 800066b0 <release>
            return -1;
    80001746:	59fd                	li	s3,-1
    80001748:	a0a1                	j	80001790 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    8000174a:	17048493          	addi	s1,s1,368
    8000174e:	03348463          	beq	s1,s3,80001776 <wait+0xe6>
      if(np->parent == p){
    80001752:	60bc                	ld	a5,64(s1)
    80001754:	ff279be3          	bne	a5,s2,8000174a <wait+0xba>
        acquire(&np->lock);
    80001758:	8526                	mv	a0,s1
    8000175a:	00005097          	auipc	ra,0x5
    8000175e:	e86080e7          	jalr	-378(ra) # 800065e0 <acquire>
        if(np->state == ZOMBIE){
    80001762:	509c                	lw	a5,32(s1)
    80001764:	f94781e3          	beq	a5,s4,800016e6 <wait+0x56>
        release(&np->lock);
    80001768:	8526                	mv	a0,s1
    8000176a:	00005097          	auipc	ra,0x5
    8000176e:	f46080e7          	jalr	-186(ra) # 800066b0 <release>
        havekids = 1;
    80001772:	8756                	mv	a4,s5
    80001774:	bfd9                	j	8000174a <wait+0xba>
    if(!havekids || p->killed){
    80001776:	c701                	beqz	a4,8000177e <wait+0xee>
    80001778:	03092783          	lw	a5,48(s2)
    8000177c:	c79d                	beqz	a5,800017aa <wait+0x11a>
      release(&wait_lock);
    8000177e:	00008517          	auipc	a0,0x8
    80001782:	a1250513          	addi	a0,a0,-1518 # 80009190 <wait_lock>
    80001786:	00005097          	auipc	ra,0x5
    8000178a:	f2a080e7          	jalr	-214(ra) # 800066b0 <release>
      return -1;
    8000178e:	59fd                	li	s3,-1
}
    80001790:	854e                	mv	a0,s3
    80001792:	60a6                	ld	ra,72(sp)
    80001794:	6406                	ld	s0,64(sp)
    80001796:	74e2                	ld	s1,56(sp)
    80001798:	7942                	ld	s2,48(sp)
    8000179a:	79a2                	ld	s3,40(sp)
    8000179c:	7a02                	ld	s4,32(sp)
    8000179e:	6ae2                	ld	s5,24(sp)
    800017a0:	6b42                	ld	s6,16(sp)
    800017a2:	6ba2                	ld	s7,8(sp)
    800017a4:	6c02                	ld	s8,0(sp)
    800017a6:	6161                	addi	sp,sp,80
    800017a8:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800017aa:	85e2                	mv	a1,s8
    800017ac:	854a                	mv	a0,s2
    800017ae:	00000097          	auipc	ra,0x0
    800017b2:	e7e080e7          	jalr	-386(ra) # 8000162c <sleep>
    havekids = 0;
    800017b6:	b715                	j	800016da <wait+0x4a>

00000000800017b8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800017b8:	7139                	addi	sp,sp,-64
    800017ba:	fc06                	sd	ra,56(sp)
    800017bc:	f822                	sd	s0,48(sp)
    800017be:	f426                	sd	s1,40(sp)
    800017c0:	f04a                	sd	s2,32(sp)
    800017c2:	ec4e                	sd	s3,24(sp)
    800017c4:	e852                	sd	s4,16(sp)
    800017c6:	e456                	sd	s5,8(sp)
    800017c8:	0080                	addi	s0,sp,64
    800017ca:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800017cc:	00008497          	auipc	s1,0x8
    800017d0:	de448493          	addi	s1,s1,-540 # 800095b0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800017d4:	4989                	li	s3,2
        p->state = RUNNABLE;
    800017d6:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800017d8:	0000e917          	auipc	s2,0xe
    800017dc:	9d890913          	addi	s2,s2,-1576 # 8000f1b0 <tickslock>
    800017e0:	a821                	j	800017f8 <wakeup+0x40>
        p->state = RUNNABLE;
    800017e2:	0354a023          	sw	s5,32(s1)
      }
      release(&p->lock);
    800017e6:	8526                	mv	a0,s1
    800017e8:	00005097          	auipc	ra,0x5
    800017ec:	ec8080e7          	jalr	-312(ra) # 800066b0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017f0:	17048493          	addi	s1,s1,368
    800017f4:	03248463          	beq	s1,s2,8000181c <wakeup+0x64>
    if(p != myproc()){
    800017f8:	fffff097          	auipc	ra,0xfffff
    800017fc:	778080e7          	jalr	1912(ra) # 80000f70 <myproc>
    80001800:	fea488e3          	beq	s1,a0,800017f0 <wakeup+0x38>
      acquire(&p->lock);
    80001804:	8526                	mv	a0,s1
    80001806:	00005097          	auipc	ra,0x5
    8000180a:	dda080e7          	jalr	-550(ra) # 800065e0 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000180e:	509c                	lw	a5,32(s1)
    80001810:	fd379be3          	bne	a5,s3,800017e6 <wakeup+0x2e>
    80001814:	749c                	ld	a5,40(s1)
    80001816:	fd4798e3          	bne	a5,s4,800017e6 <wakeup+0x2e>
    8000181a:	b7e1                	j	800017e2 <wakeup+0x2a>
    }
  }
}
    8000181c:	70e2                	ld	ra,56(sp)
    8000181e:	7442                	ld	s0,48(sp)
    80001820:	74a2                	ld	s1,40(sp)
    80001822:	7902                	ld	s2,32(sp)
    80001824:	69e2                	ld	s3,24(sp)
    80001826:	6a42                	ld	s4,16(sp)
    80001828:	6aa2                	ld	s5,8(sp)
    8000182a:	6121                	addi	sp,sp,64
    8000182c:	8082                	ret

000000008000182e <reparent>:
{
    8000182e:	7179                	addi	sp,sp,-48
    80001830:	f406                	sd	ra,40(sp)
    80001832:	f022                	sd	s0,32(sp)
    80001834:	ec26                	sd	s1,24(sp)
    80001836:	e84a                	sd	s2,16(sp)
    80001838:	e44e                	sd	s3,8(sp)
    8000183a:	e052                	sd	s4,0(sp)
    8000183c:	1800                	addi	s0,sp,48
    8000183e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001840:	00008497          	auipc	s1,0x8
    80001844:	d7048493          	addi	s1,s1,-656 # 800095b0 <proc>
      pp->parent = initproc;
    80001848:	00007a17          	auipc	s4,0x7
    8000184c:	7c8a0a13          	addi	s4,s4,1992 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001850:	0000e997          	auipc	s3,0xe
    80001854:	96098993          	addi	s3,s3,-1696 # 8000f1b0 <tickslock>
    80001858:	a029                	j	80001862 <reparent+0x34>
    8000185a:	17048493          	addi	s1,s1,368
    8000185e:	01348d63          	beq	s1,s3,80001878 <reparent+0x4a>
    if(pp->parent == p){
    80001862:	60bc                	ld	a5,64(s1)
    80001864:	ff279be3          	bne	a5,s2,8000185a <reparent+0x2c>
      pp->parent = initproc;
    80001868:	000a3503          	ld	a0,0(s4)
    8000186c:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    8000186e:	00000097          	auipc	ra,0x0
    80001872:	f4a080e7          	jalr	-182(ra) # 800017b8 <wakeup>
    80001876:	b7d5                	j	8000185a <reparent+0x2c>
}
    80001878:	70a2                	ld	ra,40(sp)
    8000187a:	7402                	ld	s0,32(sp)
    8000187c:	64e2                	ld	s1,24(sp)
    8000187e:	6942                	ld	s2,16(sp)
    80001880:	69a2                	ld	s3,8(sp)
    80001882:	6a02                	ld	s4,0(sp)
    80001884:	6145                	addi	sp,sp,48
    80001886:	8082                	ret

0000000080001888 <exit>:
{
    80001888:	7179                	addi	sp,sp,-48
    8000188a:	f406                	sd	ra,40(sp)
    8000188c:	f022                	sd	s0,32(sp)
    8000188e:	ec26                	sd	s1,24(sp)
    80001890:	e84a                	sd	s2,16(sp)
    80001892:	e44e                	sd	s3,8(sp)
    80001894:	e052                	sd	s4,0(sp)
    80001896:	1800                	addi	s0,sp,48
    80001898:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000189a:	fffff097          	auipc	ra,0xfffff
    8000189e:	6d6080e7          	jalr	1750(ra) # 80000f70 <myproc>
    800018a2:	89aa                	mv	s3,a0
  if(p == initproc)
    800018a4:	00007797          	auipc	a5,0x7
    800018a8:	76c7b783          	ld	a5,1900(a5) # 80009010 <initproc>
    800018ac:	0d850493          	addi	s1,a0,216
    800018b0:	15850913          	addi	s2,a0,344
    800018b4:	02a79363          	bne	a5,a0,800018da <exit+0x52>
    panic("init exiting");
    800018b8:	00007517          	auipc	a0,0x7
    800018bc:	93850513          	addi	a0,a0,-1736 # 800081f0 <etext+0x1f0>
    800018c0:	00004097          	auipc	ra,0x4
    800018c4:	7ec080e7          	jalr	2028(ra) # 800060ac <panic>
      fileclose(f);
    800018c8:	00002097          	auipc	ra,0x2
    800018cc:	292080e7          	jalr	658(ra) # 80003b5a <fileclose>
      p->ofile[fd] = 0;
    800018d0:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800018d4:	04a1                	addi	s1,s1,8
    800018d6:	01248563          	beq	s1,s2,800018e0 <exit+0x58>
    if(p->ofile[fd]){
    800018da:	6088                	ld	a0,0(s1)
    800018dc:	f575                	bnez	a0,800018c8 <exit+0x40>
    800018de:	bfdd                	j	800018d4 <exit+0x4c>
  begin_op();
    800018e0:	00002097          	auipc	ra,0x2
    800018e4:	dae080e7          	jalr	-594(ra) # 8000368e <begin_op>
  iput(p->cwd);
    800018e8:	1589b503          	ld	a0,344(s3)
    800018ec:	00001097          	auipc	ra,0x1
    800018f0:	58a080e7          	jalr	1418(ra) # 80002e76 <iput>
  end_op();
    800018f4:	00002097          	auipc	ra,0x2
    800018f8:	e1a080e7          	jalr	-486(ra) # 8000370e <end_op>
  p->cwd = 0;
    800018fc:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80001900:	00008497          	auipc	s1,0x8
    80001904:	89048493          	addi	s1,s1,-1904 # 80009190 <wait_lock>
    80001908:	8526                	mv	a0,s1
    8000190a:	00005097          	auipc	ra,0x5
    8000190e:	cd6080e7          	jalr	-810(ra) # 800065e0 <acquire>
  reparent(p);
    80001912:	854e                	mv	a0,s3
    80001914:	00000097          	auipc	ra,0x0
    80001918:	f1a080e7          	jalr	-230(ra) # 8000182e <reparent>
  wakeup(p->parent);
    8000191c:	0409b503          	ld	a0,64(s3)
    80001920:	00000097          	auipc	ra,0x0
    80001924:	e98080e7          	jalr	-360(ra) # 800017b8 <wakeup>
  acquire(&p->lock);
    80001928:	854e                	mv	a0,s3
    8000192a:	00005097          	auipc	ra,0x5
    8000192e:	cb6080e7          	jalr	-842(ra) # 800065e0 <acquire>
  p->xstate = status;
    80001932:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    80001936:	4795                	li	a5,5
    80001938:	02f9a023          	sw	a5,32(s3)
  release(&wait_lock);
    8000193c:	8526                	mv	a0,s1
    8000193e:	00005097          	auipc	ra,0x5
    80001942:	d72080e7          	jalr	-654(ra) # 800066b0 <release>
  sched();
    80001946:	00000097          	auipc	ra,0x0
    8000194a:	bd4080e7          	jalr	-1068(ra) # 8000151a <sched>
  panic("zombie exit");
    8000194e:	00007517          	auipc	a0,0x7
    80001952:	8b250513          	addi	a0,a0,-1870 # 80008200 <etext+0x200>
    80001956:	00004097          	auipc	ra,0x4
    8000195a:	756080e7          	jalr	1878(ra) # 800060ac <panic>

000000008000195e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000195e:	7179                	addi	sp,sp,-48
    80001960:	f406                	sd	ra,40(sp)
    80001962:	f022                	sd	s0,32(sp)
    80001964:	ec26                	sd	s1,24(sp)
    80001966:	e84a                	sd	s2,16(sp)
    80001968:	e44e                	sd	s3,8(sp)
    8000196a:	1800                	addi	s0,sp,48
    8000196c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000196e:	00008497          	auipc	s1,0x8
    80001972:	c4248493          	addi	s1,s1,-958 # 800095b0 <proc>
    80001976:	0000e997          	auipc	s3,0xe
    8000197a:	83a98993          	addi	s3,s3,-1990 # 8000f1b0 <tickslock>
    acquire(&p->lock);
    8000197e:	8526                	mv	a0,s1
    80001980:	00005097          	auipc	ra,0x5
    80001984:	c60080e7          	jalr	-928(ra) # 800065e0 <acquire>
    if(p->pid == pid){
    80001988:	5c9c                	lw	a5,56(s1)
    8000198a:	01278d63          	beq	a5,s2,800019a4 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000198e:	8526                	mv	a0,s1
    80001990:	00005097          	auipc	ra,0x5
    80001994:	d20080e7          	jalr	-736(ra) # 800066b0 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001998:	17048493          	addi	s1,s1,368
    8000199c:	ff3491e3          	bne	s1,s3,8000197e <kill+0x20>
  }
  return -1;
    800019a0:	557d                	li	a0,-1
    800019a2:	a829                	j	800019bc <kill+0x5e>
      p->killed = 1;
    800019a4:	4785                	li	a5,1
    800019a6:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    800019a8:	5098                	lw	a4,32(s1)
    800019aa:	4789                	li	a5,2
    800019ac:	00f70f63          	beq	a4,a5,800019ca <kill+0x6c>
      release(&p->lock);
    800019b0:	8526                	mv	a0,s1
    800019b2:	00005097          	auipc	ra,0x5
    800019b6:	cfe080e7          	jalr	-770(ra) # 800066b0 <release>
      return 0;
    800019ba:	4501                	li	a0,0
}
    800019bc:	70a2                	ld	ra,40(sp)
    800019be:	7402                	ld	s0,32(sp)
    800019c0:	64e2                	ld	s1,24(sp)
    800019c2:	6942                	ld	s2,16(sp)
    800019c4:	69a2                	ld	s3,8(sp)
    800019c6:	6145                	addi	sp,sp,48
    800019c8:	8082                	ret
        p->state = RUNNABLE;
    800019ca:	478d                	li	a5,3
    800019cc:	d09c                	sw	a5,32(s1)
    800019ce:	b7cd                	j	800019b0 <kill+0x52>

00000000800019d0 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800019d0:	7179                	addi	sp,sp,-48
    800019d2:	f406                	sd	ra,40(sp)
    800019d4:	f022                	sd	s0,32(sp)
    800019d6:	ec26                	sd	s1,24(sp)
    800019d8:	e84a                	sd	s2,16(sp)
    800019da:	e44e                	sd	s3,8(sp)
    800019dc:	e052                	sd	s4,0(sp)
    800019de:	1800                	addi	s0,sp,48
    800019e0:	84aa                	mv	s1,a0
    800019e2:	892e                	mv	s2,a1
    800019e4:	89b2                	mv	s3,a2
    800019e6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019e8:	fffff097          	auipc	ra,0xfffff
    800019ec:	588080e7          	jalr	1416(ra) # 80000f70 <myproc>
  if(user_dst){
    800019f0:	c08d                	beqz	s1,80001a12 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800019f2:	86d2                	mv	a3,s4
    800019f4:	864e                	mv	a2,s3
    800019f6:	85ca                	mv	a1,s2
    800019f8:	6d28                	ld	a0,88(a0)
    800019fa:	fffff097          	auipc	ra,0xfffff
    800019fe:	238080e7          	jalr	568(ra) # 80000c32 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a02:	70a2                	ld	ra,40(sp)
    80001a04:	7402                	ld	s0,32(sp)
    80001a06:	64e2                	ld	s1,24(sp)
    80001a08:	6942                	ld	s2,16(sp)
    80001a0a:	69a2                	ld	s3,8(sp)
    80001a0c:	6a02                	ld	s4,0(sp)
    80001a0e:	6145                	addi	sp,sp,48
    80001a10:	8082                	ret
    memmove((char *)dst, src, len);
    80001a12:	000a061b          	sext.w	a2,s4
    80001a16:	85ce                	mv	a1,s3
    80001a18:	854a                	mv	a0,s2
    80001a1a:	fffff097          	auipc	ra,0xfffff
    80001a1e:	8d6080e7          	jalr	-1834(ra) # 800002f0 <memmove>
    return 0;
    80001a22:	8526                	mv	a0,s1
    80001a24:	bff9                	j	80001a02 <either_copyout+0x32>

0000000080001a26 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a26:	7179                	addi	sp,sp,-48
    80001a28:	f406                	sd	ra,40(sp)
    80001a2a:	f022                	sd	s0,32(sp)
    80001a2c:	ec26                	sd	s1,24(sp)
    80001a2e:	e84a                	sd	s2,16(sp)
    80001a30:	e44e                	sd	s3,8(sp)
    80001a32:	e052                	sd	s4,0(sp)
    80001a34:	1800                	addi	s0,sp,48
    80001a36:	892a                	mv	s2,a0
    80001a38:	84ae                	mv	s1,a1
    80001a3a:	89b2                	mv	s3,a2
    80001a3c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a3e:	fffff097          	auipc	ra,0xfffff
    80001a42:	532080e7          	jalr	1330(ra) # 80000f70 <myproc>
  if(user_src){
    80001a46:	c08d                	beqz	s1,80001a68 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a48:	86d2                	mv	a3,s4
    80001a4a:	864e                	mv	a2,s3
    80001a4c:	85ca                	mv	a1,s2
    80001a4e:	6d28                	ld	a0,88(a0)
    80001a50:	fffff097          	auipc	ra,0xfffff
    80001a54:	26e080e7          	jalr	622(ra) # 80000cbe <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a58:	70a2                	ld	ra,40(sp)
    80001a5a:	7402                	ld	s0,32(sp)
    80001a5c:	64e2                	ld	s1,24(sp)
    80001a5e:	6942                	ld	s2,16(sp)
    80001a60:	69a2                	ld	s3,8(sp)
    80001a62:	6a02                	ld	s4,0(sp)
    80001a64:	6145                	addi	sp,sp,48
    80001a66:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a68:	000a061b          	sext.w	a2,s4
    80001a6c:	85ce                	mv	a1,s3
    80001a6e:	854a                	mv	a0,s2
    80001a70:	fffff097          	auipc	ra,0xfffff
    80001a74:	880080e7          	jalr	-1920(ra) # 800002f0 <memmove>
    return 0;
    80001a78:	8526                	mv	a0,s1
    80001a7a:	bff9                	j	80001a58 <either_copyin+0x32>

0000000080001a7c <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a7c:	715d                	addi	sp,sp,-80
    80001a7e:	e486                	sd	ra,72(sp)
    80001a80:	e0a2                	sd	s0,64(sp)
    80001a82:	fc26                	sd	s1,56(sp)
    80001a84:	f84a                	sd	s2,48(sp)
    80001a86:	f44e                	sd	s3,40(sp)
    80001a88:	f052                	sd	s4,32(sp)
    80001a8a:	ec56                	sd	s5,24(sp)
    80001a8c:	e85a                	sd	s6,16(sp)
    80001a8e:	e45e                	sd	s7,8(sp)
    80001a90:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a92:	00007517          	auipc	a0,0x7
    80001a96:	dce50513          	addi	a0,a0,-562 # 80008860 <digits+0x88>
    80001a9a:	00004097          	auipc	ra,0x4
    80001a9e:	65c080e7          	jalr	1628(ra) # 800060f6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001aa2:	00008497          	auipc	s1,0x8
    80001aa6:	c6e48493          	addi	s1,s1,-914 # 80009710 <proc+0x160>
    80001aaa:	0000e917          	auipc	s2,0xe
    80001aae:	86690913          	addi	s2,s2,-1946 # 8000f310 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ab2:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001ab4:	00006997          	auipc	s3,0x6
    80001ab8:	75c98993          	addi	s3,s3,1884 # 80008210 <etext+0x210>
    printf("%d %s %s", p->pid, state, p->name);
    80001abc:	00006a97          	auipc	s5,0x6
    80001ac0:	75ca8a93          	addi	s5,s5,1884 # 80008218 <etext+0x218>
    printf("\n");
    80001ac4:	00007a17          	auipc	s4,0x7
    80001ac8:	d9ca0a13          	addi	s4,s4,-612 # 80008860 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001acc:	00006b97          	auipc	s7,0x6
    80001ad0:	784b8b93          	addi	s7,s7,1924 # 80008250 <states.1733>
    80001ad4:	a00d                	j	80001af6 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001ad6:	ed86a583          	lw	a1,-296(a3)
    80001ada:	8556                	mv	a0,s5
    80001adc:	00004097          	auipc	ra,0x4
    80001ae0:	61a080e7          	jalr	1562(ra) # 800060f6 <printf>
    printf("\n");
    80001ae4:	8552                	mv	a0,s4
    80001ae6:	00004097          	auipc	ra,0x4
    80001aea:	610080e7          	jalr	1552(ra) # 800060f6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001aee:	17048493          	addi	s1,s1,368
    80001af2:	03248163          	beq	s1,s2,80001b14 <procdump+0x98>
    if(p->state == UNUSED)
    80001af6:	86a6                	mv	a3,s1
    80001af8:	ec04a783          	lw	a5,-320(s1)
    80001afc:	dbed                	beqz	a5,80001aee <procdump+0x72>
      state = "???";
    80001afe:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b00:	fcfb6be3          	bltu	s6,a5,80001ad6 <procdump+0x5a>
    80001b04:	1782                	slli	a5,a5,0x20
    80001b06:	9381                	srli	a5,a5,0x20
    80001b08:	078e                	slli	a5,a5,0x3
    80001b0a:	97de                	add	a5,a5,s7
    80001b0c:	6390                	ld	a2,0(a5)
    80001b0e:	f661                	bnez	a2,80001ad6 <procdump+0x5a>
      state = "???";
    80001b10:	864e                	mv	a2,s3
    80001b12:	b7d1                	j	80001ad6 <procdump+0x5a>
  }
}
    80001b14:	60a6                	ld	ra,72(sp)
    80001b16:	6406                	ld	s0,64(sp)
    80001b18:	74e2                	ld	s1,56(sp)
    80001b1a:	7942                	ld	s2,48(sp)
    80001b1c:	79a2                	ld	s3,40(sp)
    80001b1e:	7a02                	ld	s4,32(sp)
    80001b20:	6ae2                	ld	s5,24(sp)
    80001b22:	6b42                	ld	s6,16(sp)
    80001b24:	6ba2                	ld	s7,8(sp)
    80001b26:	6161                	addi	sp,sp,80
    80001b28:	8082                	ret

0000000080001b2a <swtch>:
    80001b2a:	00153023          	sd	ra,0(a0)
    80001b2e:	00253423          	sd	sp,8(a0)
    80001b32:	e900                	sd	s0,16(a0)
    80001b34:	ed04                	sd	s1,24(a0)
    80001b36:	03253023          	sd	s2,32(a0)
    80001b3a:	03353423          	sd	s3,40(a0)
    80001b3e:	03453823          	sd	s4,48(a0)
    80001b42:	03553c23          	sd	s5,56(a0)
    80001b46:	05653023          	sd	s6,64(a0)
    80001b4a:	05753423          	sd	s7,72(a0)
    80001b4e:	05853823          	sd	s8,80(a0)
    80001b52:	05953c23          	sd	s9,88(a0)
    80001b56:	07a53023          	sd	s10,96(a0)
    80001b5a:	07b53423          	sd	s11,104(a0)
    80001b5e:	0005b083          	ld	ra,0(a1)
    80001b62:	0085b103          	ld	sp,8(a1)
    80001b66:	6980                	ld	s0,16(a1)
    80001b68:	6d84                	ld	s1,24(a1)
    80001b6a:	0205b903          	ld	s2,32(a1)
    80001b6e:	0285b983          	ld	s3,40(a1)
    80001b72:	0305ba03          	ld	s4,48(a1)
    80001b76:	0385ba83          	ld	s5,56(a1)
    80001b7a:	0405bb03          	ld	s6,64(a1)
    80001b7e:	0485bb83          	ld	s7,72(a1)
    80001b82:	0505bc03          	ld	s8,80(a1)
    80001b86:	0585bc83          	ld	s9,88(a1)
    80001b8a:	0605bd03          	ld	s10,96(a1)
    80001b8e:	0685bd83          	ld	s11,104(a1)
    80001b92:	8082                	ret

0000000080001b94 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b94:	1141                	addi	sp,sp,-16
    80001b96:	e406                	sd	ra,8(sp)
    80001b98:	e022                	sd	s0,0(sp)
    80001b9a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b9c:	00006597          	auipc	a1,0x6
    80001ba0:	6e458593          	addi	a1,a1,1764 # 80008280 <states.1733+0x30>
    80001ba4:	0000d517          	auipc	a0,0xd
    80001ba8:	60c50513          	addi	a0,a0,1548 # 8000f1b0 <tickslock>
    80001bac:	00005097          	auipc	ra,0x5
    80001bb0:	bb0080e7          	jalr	-1104(ra) # 8000675c <initlock>
}
    80001bb4:	60a2                	ld	ra,8(sp)
    80001bb6:	6402                	ld	s0,0(sp)
    80001bb8:	0141                	addi	sp,sp,16
    80001bba:	8082                	ret

0000000080001bbc <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001bbc:	1141                	addi	sp,sp,-16
    80001bbe:	e422                	sd	s0,8(sp)
    80001bc0:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bc2:	00003797          	auipc	a5,0x3
    80001bc6:	5be78793          	addi	a5,a5,1470 # 80005180 <kernelvec>
    80001bca:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001bce:	6422                	ld	s0,8(sp)
    80001bd0:	0141                	addi	sp,sp,16
    80001bd2:	8082                	ret

0000000080001bd4 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001bd4:	1141                	addi	sp,sp,-16
    80001bd6:	e406                	sd	ra,8(sp)
    80001bd8:	e022                	sd	s0,0(sp)
    80001bda:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001bdc:	fffff097          	auipc	ra,0xfffff
    80001be0:	394080e7          	jalr	916(ra) # 80000f70 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001be4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001be8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bea:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001bee:	00005617          	auipc	a2,0x5
    80001bf2:	41260613          	addi	a2,a2,1042 # 80007000 <_trampoline>
    80001bf6:	00005697          	auipc	a3,0x5
    80001bfa:	40a68693          	addi	a3,a3,1034 # 80007000 <_trampoline>
    80001bfe:	8e91                	sub	a3,a3,a2
    80001c00:	040007b7          	lui	a5,0x4000
    80001c04:	17fd                	addi	a5,a5,-1
    80001c06:	07b2                	slli	a5,a5,0xc
    80001c08:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c0a:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c0e:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c10:	180026f3          	csrr	a3,satp
    80001c14:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c16:	7138                	ld	a4,96(a0)
    80001c18:	6534                	ld	a3,72(a0)
    80001c1a:	6585                	lui	a1,0x1
    80001c1c:	96ae                	add	a3,a3,a1
    80001c1e:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c20:	7138                	ld	a4,96(a0)
    80001c22:	00000697          	auipc	a3,0x0
    80001c26:	13868693          	addi	a3,a3,312 # 80001d5a <usertrap>
    80001c2a:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c2c:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c2e:	8692                	mv	a3,tp
    80001c30:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c32:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c36:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c3a:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c3e:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c42:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c44:	6f18                	ld	a4,24(a4)
    80001c46:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c4a:	6d2c                	ld	a1,88(a0)
    80001c4c:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001c4e:	00005717          	auipc	a4,0x5
    80001c52:	44270713          	addi	a4,a4,1090 # 80007090 <userret>
    80001c56:	8f11                	sub	a4,a4,a2
    80001c58:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001c5a:	577d                	li	a4,-1
    80001c5c:	177e                	slli	a4,a4,0x3f
    80001c5e:	8dd9                	or	a1,a1,a4
    80001c60:	02000537          	lui	a0,0x2000
    80001c64:	157d                	addi	a0,a0,-1
    80001c66:	0536                	slli	a0,a0,0xd
    80001c68:	9782                	jalr	a5
}
    80001c6a:	60a2                	ld	ra,8(sp)
    80001c6c:	6402                	ld	s0,0(sp)
    80001c6e:	0141                	addi	sp,sp,16
    80001c70:	8082                	ret

0000000080001c72 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c72:	1101                	addi	sp,sp,-32
    80001c74:	ec06                	sd	ra,24(sp)
    80001c76:	e822                	sd	s0,16(sp)
    80001c78:	e426                	sd	s1,8(sp)
    80001c7a:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c7c:	0000d497          	auipc	s1,0xd
    80001c80:	53448493          	addi	s1,s1,1332 # 8000f1b0 <tickslock>
    80001c84:	8526                	mv	a0,s1
    80001c86:	00005097          	auipc	ra,0x5
    80001c8a:	95a080e7          	jalr	-1702(ra) # 800065e0 <acquire>
  ticks++;
    80001c8e:	00007517          	auipc	a0,0x7
    80001c92:	38a50513          	addi	a0,a0,906 # 80009018 <ticks>
    80001c96:	411c                	lw	a5,0(a0)
    80001c98:	2785                	addiw	a5,a5,1
    80001c9a:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c9c:	00000097          	auipc	ra,0x0
    80001ca0:	b1c080e7          	jalr	-1252(ra) # 800017b8 <wakeup>
  release(&tickslock);
    80001ca4:	8526                	mv	a0,s1
    80001ca6:	00005097          	auipc	ra,0x5
    80001caa:	a0a080e7          	jalr	-1526(ra) # 800066b0 <release>
}
    80001cae:	60e2                	ld	ra,24(sp)
    80001cb0:	6442                	ld	s0,16(sp)
    80001cb2:	64a2                	ld	s1,8(sp)
    80001cb4:	6105                	addi	sp,sp,32
    80001cb6:	8082                	ret

0000000080001cb8 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001cb8:	1101                	addi	sp,sp,-32
    80001cba:	ec06                	sd	ra,24(sp)
    80001cbc:	e822                	sd	s0,16(sp)
    80001cbe:	e426                	sd	s1,8(sp)
    80001cc0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cc2:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001cc6:	00074d63          	bltz	a4,80001ce0 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001cca:	57fd                	li	a5,-1
    80001ccc:	17fe                	slli	a5,a5,0x3f
    80001cce:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001cd0:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001cd2:	06f70363          	beq	a4,a5,80001d38 <devintr+0x80>
  }
}
    80001cd6:	60e2                	ld	ra,24(sp)
    80001cd8:	6442                	ld	s0,16(sp)
    80001cda:	64a2                	ld	s1,8(sp)
    80001cdc:	6105                	addi	sp,sp,32
    80001cde:	8082                	ret
     (scause & 0xff) == 9){
    80001ce0:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001ce4:	46a5                	li	a3,9
    80001ce6:	fed792e3          	bne	a5,a3,80001cca <devintr+0x12>
    int irq = plic_claim();
    80001cea:	00003097          	auipc	ra,0x3
    80001cee:	59e080e7          	jalr	1438(ra) # 80005288 <plic_claim>
    80001cf2:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001cf4:	47a9                	li	a5,10
    80001cf6:	02f50763          	beq	a0,a5,80001d24 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001cfa:	4785                	li	a5,1
    80001cfc:	02f50963          	beq	a0,a5,80001d2e <devintr+0x76>
    return 1;
    80001d00:	4505                	li	a0,1
    } else if(irq){
    80001d02:	d8f1                	beqz	s1,80001cd6 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d04:	85a6                	mv	a1,s1
    80001d06:	00006517          	auipc	a0,0x6
    80001d0a:	58250513          	addi	a0,a0,1410 # 80008288 <states.1733+0x38>
    80001d0e:	00004097          	auipc	ra,0x4
    80001d12:	3e8080e7          	jalr	1000(ra) # 800060f6 <printf>
      plic_complete(irq);
    80001d16:	8526                	mv	a0,s1
    80001d18:	00003097          	auipc	ra,0x3
    80001d1c:	594080e7          	jalr	1428(ra) # 800052ac <plic_complete>
    return 1;
    80001d20:	4505                	li	a0,1
    80001d22:	bf55                	j	80001cd6 <devintr+0x1e>
      uartintr();
    80001d24:	00004097          	auipc	ra,0x4
    80001d28:	7f2080e7          	jalr	2034(ra) # 80006516 <uartintr>
    80001d2c:	b7ed                	j	80001d16 <devintr+0x5e>
      virtio_disk_intr();
    80001d2e:	00004097          	auipc	ra,0x4
    80001d32:	a5e080e7          	jalr	-1442(ra) # 8000578c <virtio_disk_intr>
    80001d36:	b7c5                	j	80001d16 <devintr+0x5e>
    if(cpuid() == 0){
    80001d38:	fffff097          	auipc	ra,0xfffff
    80001d3c:	20c080e7          	jalr	524(ra) # 80000f44 <cpuid>
    80001d40:	c901                	beqz	a0,80001d50 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d42:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d46:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d48:	14479073          	csrw	sip,a5
    return 2;
    80001d4c:	4509                	li	a0,2
    80001d4e:	b761                	j	80001cd6 <devintr+0x1e>
      clockintr();
    80001d50:	00000097          	auipc	ra,0x0
    80001d54:	f22080e7          	jalr	-222(ra) # 80001c72 <clockintr>
    80001d58:	b7ed                	j	80001d42 <devintr+0x8a>

0000000080001d5a <usertrap>:
{
    80001d5a:	1101                	addi	sp,sp,-32
    80001d5c:	ec06                	sd	ra,24(sp)
    80001d5e:	e822                	sd	s0,16(sp)
    80001d60:	e426                	sd	s1,8(sp)
    80001d62:	e04a                	sd	s2,0(sp)
    80001d64:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d66:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d6a:	1007f793          	andi	a5,a5,256
    80001d6e:	e3ad                	bnez	a5,80001dd0 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d70:	00003797          	auipc	a5,0x3
    80001d74:	41078793          	addi	a5,a5,1040 # 80005180 <kernelvec>
    80001d78:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d7c:	fffff097          	auipc	ra,0xfffff
    80001d80:	1f4080e7          	jalr	500(ra) # 80000f70 <myproc>
    80001d84:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d86:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d88:	14102773          	csrr	a4,sepc
    80001d8c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d8e:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d92:	47a1                	li	a5,8
    80001d94:	04f71c63          	bne	a4,a5,80001dec <usertrap+0x92>
    if(p->killed)
    80001d98:	591c                	lw	a5,48(a0)
    80001d9a:	e3b9                	bnez	a5,80001de0 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001d9c:	70b8                	ld	a4,96(s1)
    80001d9e:	6f1c                	ld	a5,24(a4)
    80001da0:	0791                	addi	a5,a5,4
    80001da2:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001da4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001da8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dac:	10079073          	csrw	sstatus,a5
    syscall();
    80001db0:	00000097          	auipc	ra,0x0
    80001db4:	2e0080e7          	jalr	736(ra) # 80002090 <syscall>
  if(p->killed)
    80001db8:	589c                	lw	a5,48(s1)
    80001dba:	ebc1                	bnez	a5,80001e4a <usertrap+0xf0>
  usertrapret();
    80001dbc:	00000097          	auipc	ra,0x0
    80001dc0:	e18080e7          	jalr	-488(ra) # 80001bd4 <usertrapret>
}
    80001dc4:	60e2                	ld	ra,24(sp)
    80001dc6:	6442                	ld	s0,16(sp)
    80001dc8:	64a2                	ld	s1,8(sp)
    80001dca:	6902                	ld	s2,0(sp)
    80001dcc:	6105                	addi	sp,sp,32
    80001dce:	8082                	ret
    panic("usertrap: not from user mode");
    80001dd0:	00006517          	auipc	a0,0x6
    80001dd4:	4d850513          	addi	a0,a0,1240 # 800082a8 <states.1733+0x58>
    80001dd8:	00004097          	auipc	ra,0x4
    80001ddc:	2d4080e7          	jalr	724(ra) # 800060ac <panic>
      exit(-1);
    80001de0:	557d                	li	a0,-1
    80001de2:	00000097          	auipc	ra,0x0
    80001de6:	aa6080e7          	jalr	-1370(ra) # 80001888 <exit>
    80001dea:	bf4d                	j	80001d9c <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001dec:	00000097          	auipc	ra,0x0
    80001df0:	ecc080e7          	jalr	-308(ra) # 80001cb8 <devintr>
    80001df4:	892a                	mv	s2,a0
    80001df6:	c501                	beqz	a0,80001dfe <usertrap+0xa4>
  if(p->killed)
    80001df8:	589c                	lw	a5,48(s1)
    80001dfa:	c3a1                	beqz	a5,80001e3a <usertrap+0xe0>
    80001dfc:	a815                	j	80001e30 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dfe:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e02:	5c90                	lw	a2,56(s1)
    80001e04:	00006517          	auipc	a0,0x6
    80001e08:	4c450513          	addi	a0,a0,1220 # 800082c8 <states.1733+0x78>
    80001e0c:	00004097          	auipc	ra,0x4
    80001e10:	2ea080e7          	jalr	746(ra) # 800060f6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e14:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e18:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e1c:	00006517          	auipc	a0,0x6
    80001e20:	4dc50513          	addi	a0,a0,1244 # 800082f8 <states.1733+0xa8>
    80001e24:	00004097          	auipc	ra,0x4
    80001e28:	2d2080e7          	jalr	722(ra) # 800060f6 <printf>
    p->killed = 1;
    80001e2c:	4785                	li	a5,1
    80001e2e:	d89c                	sw	a5,48(s1)
    exit(-1);
    80001e30:	557d                	li	a0,-1
    80001e32:	00000097          	auipc	ra,0x0
    80001e36:	a56080e7          	jalr	-1450(ra) # 80001888 <exit>
  if(which_dev == 2)
    80001e3a:	4789                	li	a5,2
    80001e3c:	f8f910e3          	bne	s2,a5,80001dbc <usertrap+0x62>
    yield();
    80001e40:	fffff097          	auipc	ra,0xfffff
    80001e44:	7b0080e7          	jalr	1968(ra) # 800015f0 <yield>
    80001e48:	bf95                	j	80001dbc <usertrap+0x62>
  int which_dev = 0;
    80001e4a:	4901                	li	s2,0
    80001e4c:	b7d5                	j	80001e30 <usertrap+0xd6>

0000000080001e4e <kerneltrap>:
{
    80001e4e:	7179                	addi	sp,sp,-48
    80001e50:	f406                	sd	ra,40(sp)
    80001e52:	f022                	sd	s0,32(sp)
    80001e54:	ec26                	sd	s1,24(sp)
    80001e56:	e84a                	sd	s2,16(sp)
    80001e58:	e44e                	sd	s3,8(sp)
    80001e5a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e5c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e60:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e64:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e68:	1004f793          	andi	a5,s1,256
    80001e6c:	cb85                	beqz	a5,80001e9c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e6e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e72:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e74:	ef85                	bnez	a5,80001eac <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e76:	00000097          	auipc	ra,0x0
    80001e7a:	e42080e7          	jalr	-446(ra) # 80001cb8 <devintr>
    80001e7e:	cd1d                	beqz	a0,80001ebc <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e80:	4789                	li	a5,2
    80001e82:	06f50a63          	beq	a0,a5,80001ef6 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e86:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e8a:	10049073          	csrw	sstatus,s1
}
    80001e8e:	70a2                	ld	ra,40(sp)
    80001e90:	7402                	ld	s0,32(sp)
    80001e92:	64e2                	ld	s1,24(sp)
    80001e94:	6942                	ld	s2,16(sp)
    80001e96:	69a2                	ld	s3,8(sp)
    80001e98:	6145                	addi	sp,sp,48
    80001e9a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e9c:	00006517          	auipc	a0,0x6
    80001ea0:	47c50513          	addi	a0,a0,1148 # 80008318 <states.1733+0xc8>
    80001ea4:	00004097          	auipc	ra,0x4
    80001ea8:	208080e7          	jalr	520(ra) # 800060ac <panic>
    panic("kerneltrap: interrupts enabled");
    80001eac:	00006517          	auipc	a0,0x6
    80001eb0:	49450513          	addi	a0,a0,1172 # 80008340 <states.1733+0xf0>
    80001eb4:	00004097          	auipc	ra,0x4
    80001eb8:	1f8080e7          	jalr	504(ra) # 800060ac <panic>
    printf("scause %p\n", scause);
    80001ebc:	85ce                	mv	a1,s3
    80001ebe:	00006517          	auipc	a0,0x6
    80001ec2:	4a250513          	addi	a0,a0,1186 # 80008360 <states.1733+0x110>
    80001ec6:	00004097          	auipc	ra,0x4
    80001eca:	230080e7          	jalr	560(ra) # 800060f6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ece:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ed2:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ed6:	00006517          	auipc	a0,0x6
    80001eda:	49a50513          	addi	a0,a0,1178 # 80008370 <states.1733+0x120>
    80001ede:	00004097          	auipc	ra,0x4
    80001ee2:	218080e7          	jalr	536(ra) # 800060f6 <printf>
    panic("kerneltrap");
    80001ee6:	00006517          	auipc	a0,0x6
    80001eea:	4a250513          	addi	a0,a0,1186 # 80008388 <states.1733+0x138>
    80001eee:	00004097          	auipc	ra,0x4
    80001ef2:	1be080e7          	jalr	446(ra) # 800060ac <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ef6:	fffff097          	auipc	ra,0xfffff
    80001efa:	07a080e7          	jalr	122(ra) # 80000f70 <myproc>
    80001efe:	d541                	beqz	a0,80001e86 <kerneltrap+0x38>
    80001f00:	fffff097          	auipc	ra,0xfffff
    80001f04:	070080e7          	jalr	112(ra) # 80000f70 <myproc>
    80001f08:	5118                	lw	a4,32(a0)
    80001f0a:	4791                	li	a5,4
    80001f0c:	f6f71de3          	bne	a4,a5,80001e86 <kerneltrap+0x38>
    yield();
    80001f10:	fffff097          	auipc	ra,0xfffff
    80001f14:	6e0080e7          	jalr	1760(ra) # 800015f0 <yield>
    80001f18:	b7bd                	j	80001e86 <kerneltrap+0x38>

0000000080001f1a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f1a:	1101                	addi	sp,sp,-32
    80001f1c:	ec06                	sd	ra,24(sp)
    80001f1e:	e822                	sd	s0,16(sp)
    80001f20:	e426                	sd	s1,8(sp)
    80001f22:	1000                	addi	s0,sp,32
    80001f24:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f26:	fffff097          	auipc	ra,0xfffff
    80001f2a:	04a080e7          	jalr	74(ra) # 80000f70 <myproc>
  switch (n) {
    80001f2e:	4795                	li	a5,5
    80001f30:	0497e163          	bltu	a5,s1,80001f72 <argraw+0x58>
    80001f34:	048a                	slli	s1,s1,0x2
    80001f36:	00006717          	auipc	a4,0x6
    80001f3a:	48a70713          	addi	a4,a4,1162 # 800083c0 <states.1733+0x170>
    80001f3e:	94ba                	add	s1,s1,a4
    80001f40:	409c                	lw	a5,0(s1)
    80001f42:	97ba                	add	a5,a5,a4
    80001f44:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f46:	713c                	ld	a5,96(a0)
    80001f48:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f4a:	60e2                	ld	ra,24(sp)
    80001f4c:	6442                	ld	s0,16(sp)
    80001f4e:	64a2                	ld	s1,8(sp)
    80001f50:	6105                	addi	sp,sp,32
    80001f52:	8082                	ret
    return p->trapframe->a1;
    80001f54:	713c                	ld	a5,96(a0)
    80001f56:	7fa8                	ld	a0,120(a5)
    80001f58:	bfcd                	j	80001f4a <argraw+0x30>
    return p->trapframe->a2;
    80001f5a:	713c                	ld	a5,96(a0)
    80001f5c:	63c8                	ld	a0,128(a5)
    80001f5e:	b7f5                	j	80001f4a <argraw+0x30>
    return p->trapframe->a3;
    80001f60:	713c                	ld	a5,96(a0)
    80001f62:	67c8                	ld	a0,136(a5)
    80001f64:	b7dd                	j	80001f4a <argraw+0x30>
    return p->trapframe->a4;
    80001f66:	713c                	ld	a5,96(a0)
    80001f68:	6bc8                	ld	a0,144(a5)
    80001f6a:	b7c5                	j	80001f4a <argraw+0x30>
    return p->trapframe->a5;
    80001f6c:	713c                	ld	a5,96(a0)
    80001f6e:	6fc8                	ld	a0,152(a5)
    80001f70:	bfe9                	j	80001f4a <argraw+0x30>
  panic("argraw");
    80001f72:	00006517          	auipc	a0,0x6
    80001f76:	42650513          	addi	a0,a0,1062 # 80008398 <states.1733+0x148>
    80001f7a:	00004097          	auipc	ra,0x4
    80001f7e:	132080e7          	jalr	306(ra) # 800060ac <panic>

0000000080001f82 <fetchaddr>:
{
    80001f82:	1101                	addi	sp,sp,-32
    80001f84:	ec06                	sd	ra,24(sp)
    80001f86:	e822                	sd	s0,16(sp)
    80001f88:	e426                	sd	s1,8(sp)
    80001f8a:	e04a                	sd	s2,0(sp)
    80001f8c:	1000                	addi	s0,sp,32
    80001f8e:	84aa                	mv	s1,a0
    80001f90:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f92:	fffff097          	auipc	ra,0xfffff
    80001f96:	fde080e7          	jalr	-34(ra) # 80000f70 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f9a:	693c                	ld	a5,80(a0)
    80001f9c:	02f4f863          	bgeu	s1,a5,80001fcc <fetchaddr+0x4a>
    80001fa0:	00848713          	addi	a4,s1,8
    80001fa4:	02e7e663          	bltu	a5,a4,80001fd0 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001fa8:	46a1                	li	a3,8
    80001faa:	8626                	mv	a2,s1
    80001fac:	85ca                	mv	a1,s2
    80001fae:	6d28                	ld	a0,88(a0)
    80001fb0:	fffff097          	auipc	ra,0xfffff
    80001fb4:	d0e080e7          	jalr	-754(ra) # 80000cbe <copyin>
    80001fb8:	00a03533          	snez	a0,a0
    80001fbc:	40a00533          	neg	a0,a0
}
    80001fc0:	60e2                	ld	ra,24(sp)
    80001fc2:	6442                	ld	s0,16(sp)
    80001fc4:	64a2                	ld	s1,8(sp)
    80001fc6:	6902                	ld	s2,0(sp)
    80001fc8:	6105                	addi	sp,sp,32
    80001fca:	8082                	ret
    return -1;
    80001fcc:	557d                	li	a0,-1
    80001fce:	bfcd                	j	80001fc0 <fetchaddr+0x3e>
    80001fd0:	557d                	li	a0,-1
    80001fd2:	b7fd                	j	80001fc0 <fetchaddr+0x3e>

0000000080001fd4 <fetchstr>:
{
    80001fd4:	7179                	addi	sp,sp,-48
    80001fd6:	f406                	sd	ra,40(sp)
    80001fd8:	f022                	sd	s0,32(sp)
    80001fda:	ec26                	sd	s1,24(sp)
    80001fdc:	e84a                	sd	s2,16(sp)
    80001fde:	e44e                	sd	s3,8(sp)
    80001fe0:	1800                	addi	s0,sp,48
    80001fe2:	892a                	mv	s2,a0
    80001fe4:	84ae                	mv	s1,a1
    80001fe6:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001fe8:	fffff097          	auipc	ra,0xfffff
    80001fec:	f88080e7          	jalr	-120(ra) # 80000f70 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001ff0:	86ce                	mv	a3,s3
    80001ff2:	864a                	mv	a2,s2
    80001ff4:	85a6                	mv	a1,s1
    80001ff6:	6d28                	ld	a0,88(a0)
    80001ff8:	fffff097          	auipc	ra,0xfffff
    80001ffc:	d52080e7          	jalr	-686(ra) # 80000d4a <copyinstr>
  if(err < 0)
    80002000:	00054763          	bltz	a0,8000200e <fetchstr+0x3a>
  return strlen(buf);
    80002004:	8526                	mv	a0,s1
    80002006:	ffffe097          	auipc	ra,0xffffe
    8000200a:	40e080e7          	jalr	1038(ra) # 80000414 <strlen>
}
    8000200e:	70a2                	ld	ra,40(sp)
    80002010:	7402                	ld	s0,32(sp)
    80002012:	64e2                	ld	s1,24(sp)
    80002014:	6942                	ld	s2,16(sp)
    80002016:	69a2                	ld	s3,8(sp)
    80002018:	6145                	addi	sp,sp,48
    8000201a:	8082                	ret

000000008000201c <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    8000201c:	1101                	addi	sp,sp,-32
    8000201e:	ec06                	sd	ra,24(sp)
    80002020:	e822                	sd	s0,16(sp)
    80002022:	e426                	sd	s1,8(sp)
    80002024:	1000                	addi	s0,sp,32
    80002026:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002028:	00000097          	auipc	ra,0x0
    8000202c:	ef2080e7          	jalr	-270(ra) # 80001f1a <argraw>
    80002030:	c088                	sw	a0,0(s1)
  return 0;
}
    80002032:	4501                	li	a0,0
    80002034:	60e2                	ld	ra,24(sp)
    80002036:	6442                	ld	s0,16(sp)
    80002038:	64a2                	ld	s1,8(sp)
    8000203a:	6105                	addi	sp,sp,32
    8000203c:	8082                	ret

000000008000203e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    8000203e:	1101                	addi	sp,sp,-32
    80002040:	ec06                	sd	ra,24(sp)
    80002042:	e822                	sd	s0,16(sp)
    80002044:	e426                	sd	s1,8(sp)
    80002046:	1000                	addi	s0,sp,32
    80002048:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000204a:	00000097          	auipc	ra,0x0
    8000204e:	ed0080e7          	jalr	-304(ra) # 80001f1a <argraw>
    80002052:	e088                	sd	a0,0(s1)
  return 0;
}
    80002054:	4501                	li	a0,0
    80002056:	60e2                	ld	ra,24(sp)
    80002058:	6442                	ld	s0,16(sp)
    8000205a:	64a2                	ld	s1,8(sp)
    8000205c:	6105                	addi	sp,sp,32
    8000205e:	8082                	ret

0000000080002060 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002060:	1101                	addi	sp,sp,-32
    80002062:	ec06                	sd	ra,24(sp)
    80002064:	e822                	sd	s0,16(sp)
    80002066:	e426                	sd	s1,8(sp)
    80002068:	e04a                	sd	s2,0(sp)
    8000206a:	1000                	addi	s0,sp,32
    8000206c:	84ae                	mv	s1,a1
    8000206e:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002070:	00000097          	auipc	ra,0x0
    80002074:	eaa080e7          	jalr	-342(ra) # 80001f1a <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002078:	864a                	mv	a2,s2
    8000207a:	85a6                	mv	a1,s1
    8000207c:	00000097          	auipc	ra,0x0
    80002080:	f58080e7          	jalr	-168(ra) # 80001fd4 <fetchstr>
}
    80002084:	60e2                	ld	ra,24(sp)
    80002086:	6442                	ld	s0,16(sp)
    80002088:	64a2                	ld	s1,8(sp)
    8000208a:	6902                	ld	s2,0(sp)
    8000208c:	6105                	addi	sp,sp,32
    8000208e:	8082                	ret

0000000080002090 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002090:	1101                	addi	sp,sp,-32
    80002092:	ec06                	sd	ra,24(sp)
    80002094:	e822                	sd	s0,16(sp)
    80002096:	e426                	sd	s1,8(sp)
    80002098:	e04a                	sd	s2,0(sp)
    8000209a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000209c:	fffff097          	auipc	ra,0xfffff
    800020a0:	ed4080e7          	jalr	-300(ra) # 80000f70 <myproc>
    800020a4:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800020a6:	06053903          	ld	s2,96(a0)
    800020aa:	0a893783          	ld	a5,168(s2)
    800020ae:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020b2:	37fd                	addiw	a5,a5,-1
    800020b4:	4751                	li	a4,20
    800020b6:	00f76f63          	bltu	a4,a5,800020d4 <syscall+0x44>
    800020ba:	00369713          	slli	a4,a3,0x3
    800020be:	00006797          	auipc	a5,0x6
    800020c2:	31a78793          	addi	a5,a5,794 # 800083d8 <syscalls>
    800020c6:	97ba                	add	a5,a5,a4
    800020c8:	639c                	ld	a5,0(a5)
    800020ca:	c789                	beqz	a5,800020d4 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800020cc:	9782                	jalr	a5
    800020ce:	06a93823          	sd	a0,112(s2)
    800020d2:	a839                	j	800020f0 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800020d4:	16048613          	addi	a2,s1,352
    800020d8:	5c8c                	lw	a1,56(s1)
    800020da:	00006517          	auipc	a0,0x6
    800020de:	2c650513          	addi	a0,a0,710 # 800083a0 <states.1733+0x150>
    800020e2:	00004097          	auipc	ra,0x4
    800020e6:	014080e7          	jalr	20(ra) # 800060f6 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020ea:	70bc                	ld	a5,96(s1)
    800020ec:	577d                	li	a4,-1
    800020ee:	fbb8                	sd	a4,112(a5)
  }
}
    800020f0:	60e2                	ld	ra,24(sp)
    800020f2:	6442                	ld	s0,16(sp)
    800020f4:	64a2                	ld	s1,8(sp)
    800020f6:	6902                	ld	s2,0(sp)
    800020f8:	6105                	addi	sp,sp,32
    800020fa:	8082                	ret

00000000800020fc <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800020fc:	1101                	addi	sp,sp,-32
    800020fe:	ec06                	sd	ra,24(sp)
    80002100:	e822                	sd	s0,16(sp)
    80002102:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002104:	fec40593          	addi	a1,s0,-20
    80002108:	4501                	li	a0,0
    8000210a:	00000097          	auipc	ra,0x0
    8000210e:	f12080e7          	jalr	-238(ra) # 8000201c <argint>
    return -1;
    80002112:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002114:	00054963          	bltz	a0,80002126 <sys_exit+0x2a>
  exit(n);
    80002118:	fec42503          	lw	a0,-20(s0)
    8000211c:	fffff097          	auipc	ra,0xfffff
    80002120:	76c080e7          	jalr	1900(ra) # 80001888 <exit>
  return 0;  // not reached
    80002124:	4781                	li	a5,0
}
    80002126:	853e                	mv	a0,a5
    80002128:	60e2                	ld	ra,24(sp)
    8000212a:	6442                	ld	s0,16(sp)
    8000212c:	6105                	addi	sp,sp,32
    8000212e:	8082                	ret

0000000080002130 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002130:	1141                	addi	sp,sp,-16
    80002132:	e406                	sd	ra,8(sp)
    80002134:	e022                	sd	s0,0(sp)
    80002136:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002138:	fffff097          	auipc	ra,0xfffff
    8000213c:	e38080e7          	jalr	-456(ra) # 80000f70 <myproc>
}
    80002140:	5d08                	lw	a0,56(a0)
    80002142:	60a2                	ld	ra,8(sp)
    80002144:	6402                	ld	s0,0(sp)
    80002146:	0141                	addi	sp,sp,16
    80002148:	8082                	ret

000000008000214a <sys_fork>:

uint64
sys_fork(void)
{
    8000214a:	1141                	addi	sp,sp,-16
    8000214c:	e406                	sd	ra,8(sp)
    8000214e:	e022                	sd	s0,0(sp)
    80002150:	0800                	addi	s0,sp,16
  return fork();
    80002152:	fffff097          	auipc	ra,0xfffff
    80002156:	1ec080e7          	jalr	492(ra) # 8000133e <fork>
}
    8000215a:	60a2                	ld	ra,8(sp)
    8000215c:	6402                	ld	s0,0(sp)
    8000215e:	0141                	addi	sp,sp,16
    80002160:	8082                	ret

0000000080002162 <sys_wait>:

uint64
sys_wait(void)
{
    80002162:	1101                	addi	sp,sp,-32
    80002164:	ec06                	sd	ra,24(sp)
    80002166:	e822                	sd	s0,16(sp)
    80002168:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000216a:	fe840593          	addi	a1,s0,-24
    8000216e:	4501                	li	a0,0
    80002170:	00000097          	auipc	ra,0x0
    80002174:	ece080e7          	jalr	-306(ra) # 8000203e <argaddr>
    80002178:	87aa                	mv	a5,a0
    return -1;
    8000217a:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000217c:	0007c863          	bltz	a5,8000218c <sys_wait+0x2a>
  return wait(p);
    80002180:	fe843503          	ld	a0,-24(s0)
    80002184:	fffff097          	auipc	ra,0xfffff
    80002188:	50c080e7          	jalr	1292(ra) # 80001690 <wait>
}
    8000218c:	60e2                	ld	ra,24(sp)
    8000218e:	6442                	ld	s0,16(sp)
    80002190:	6105                	addi	sp,sp,32
    80002192:	8082                	ret

0000000080002194 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002194:	7179                	addi	sp,sp,-48
    80002196:	f406                	sd	ra,40(sp)
    80002198:	f022                	sd	s0,32(sp)
    8000219a:	ec26                	sd	s1,24(sp)
    8000219c:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000219e:	fdc40593          	addi	a1,s0,-36
    800021a2:	4501                	li	a0,0
    800021a4:	00000097          	auipc	ra,0x0
    800021a8:	e78080e7          	jalr	-392(ra) # 8000201c <argint>
    800021ac:	87aa                	mv	a5,a0
    return -1;
    800021ae:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800021b0:	0207c063          	bltz	a5,800021d0 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    800021b4:	fffff097          	auipc	ra,0xfffff
    800021b8:	dbc080e7          	jalr	-580(ra) # 80000f70 <myproc>
    800021bc:	4924                	lw	s1,80(a0)
  if(growproc(n) < 0)
    800021be:	fdc42503          	lw	a0,-36(s0)
    800021c2:	fffff097          	auipc	ra,0xfffff
    800021c6:	108080e7          	jalr	264(ra) # 800012ca <growproc>
    800021ca:	00054863          	bltz	a0,800021da <sys_sbrk+0x46>
    return -1;
  return addr;
    800021ce:	8526                	mv	a0,s1
}
    800021d0:	70a2                	ld	ra,40(sp)
    800021d2:	7402                	ld	s0,32(sp)
    800021d4:	64e2                	ld	s1,24(sp)
    800021d6:	6145                	addi	sp,sp,48
    800021d8:	8082                	ret
    return -1;
    800021da:	557d                	li	a0,-1
    800021dc:	bfd5                	j	800021d0 <sys_sbrk+0x3c>

00000000800021de <sys_sleep>:

uint64
sys_sleep(void)
{
    800021de:	7139                	addi	sp,sp,-64
    800021e0:	fc06                	sd	ra,56(sp)
    800021e2:	f822                	sd	s0,48(sp)
    800021e4:	f426                	sd	s1,40(sp)
    800021e6:	f04a                	sd	s2,32(sp)
    800021e8:	ec4e                	sd	s3,24(sp)
    800021ea:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800021ec:	fcc40593          	addi	a1,s0,-52
    800021f0:	4501                	li	a0,0
    800021f2:	00000097          	auipc	ra,0x0
    800021f6:	e2a080e7          	jalr	-470(ra) # 8000201c <argint>
    return -1;
    800021fa:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021fc:	06054563          	bltz	a0,80002266 <sys_sleep+0x88>
  acquire(&tickslock);
    80002200:	0000d517          	auipc	a0,0xd
    80002204:	fb050513          	addi	a0,a0,-80 # 8000f1b0 <tickslock>
    80002208:	00004097          	auipc	ra,0x4
    8000220c:	3d8080e7          	jalr	984(ra) # 800065e0 <acquire>
  ticks0 = ticks;
    80002210:	00007917          	auipc	s2,0x7
    80002214:	e0892903          	lw	s2,-504(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002218:	fcc42783          	lw	a5,-52(s0)
    8000221c:	cf85                	beqz	a5,80002254 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000221e:	0000d997          	auipc	s3,0xd
    80002222:	f9298993          	addi	s3,s3,-110 # 8000f1b0 <tickslock>
    80002226:	00007497          	auipc	s1,0x7
    8000222a:	df248493          	addi	s1,s1,-526 # 80009018 <ticks>
    if(myproc()->killed){
    8000222e:	fffff097          	auipc	ra,0xfffff
    80002232:	d42080e7          	jalr	-702(ra) # 80000f70 <myproc>
    80002236:	591c                	lw	a5,48(a0)
    80002238:	ef9d                	bnez	a5,80002276 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    8000223a:	85ce                	mv	a1,s3
    8000223c:	8526                	mv	a0,s1
    8000223e:	fffff097          	auipc	ra,0xfffff
    80002242:	3ee080e7          	jalr	1006(ra) # 8000162c <sleep>
  while(ticks - ticks0 < n){
    80002246:	409c                	lw	a5,0(s1)
    80002248:	412787bb          	subw	a5,a5,s2
    8000224c:	fcc42703          	lw	a4,-52(s0)
    80002250:	fce7efe3          	bltu	a5,a4,8000222e <sys_sleep+0x50>
  }
  release(&tickslock);
    80002254:	0000d517          	auipc	a0,0xd
    80002258:	f5c50513          	addi	a0,a0,-164 # 8000f1b0 <tickslock>
    8000225c:	00004097          	auipc	ra,0x4
    80002260:	454080e7          	jalr	1108(ra) # 800066b0 <release>
  return 0;
    80002264:	4781                	li	a5,0
}
    80002266:	853e                	mv	a0,a5
    80002268:	70e2                	ld	ra,56(sp)
    8000226a:	7442                	ld	s0,48(sp)
    8000226c:	74a2                	ld	s1,40(sp)
    8000226e:	7902                	ld	s2,32(sp)
    80002270:	69e2                	ld	s3,24(sp)
    80002272:	6121                	addi	sp,sp,64
    80002274:	8082                	ret
      release(&tickslock);
    80002276:	0000d517          	auipc	a0,0xd
    8000227a:	f3a50513          	addi	a0,a0,-198 # 8000f1b0 <tickslock>
    8000227e:	00004097          	auipc	ra,0x4
    80002282:	432080e7          	jalr	1074(ra) # 800066b0 <release>
      return -1;
    80002286:	57fd                	li	a5,-1
    80002288:	bff9                	j	80002266 <sys_sleep+0x88>

000000008000228a <sys_kill>:

uint64
sys_kill(void)
{
    8000228a:	1101                	addi	sp,sp,-32
    8000228c:	ec06                	sd	ra,24(sp)
    8000228e:	e822                	sd	s0,16(sp)
    80002290:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002292:	fec40593          	addi	a1,s0,-20
    80002296:	4501                	li	a0,0
    80002298:	00000097          	auipc	ra,0x0
    8000229c:	d84080e7          	jalr	-636(ra) # 8000201c <argint>
    800022a0:	87aa                	mv	a5,a0
    return -1;
    800022a2:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800022a4:	0007c863          	bltz	a5,800022b4 <sys_kill+0x2a>
  return kill(pid);
    800022a8:	fec42503          	lw	a0,-20(s0)
    800022ac:	fffff097          	auipc	ra,0xfffff
    800022b0:	6b2080e7          	jalr	1714(ra) # 8000195e <kill>
}
    800022b4:	60e2                	ld	ra,24(sp)
    800022b6:	6442                	ld	s0,16(sp)
    800022b8:	6105                	addi	sp,sp,32
    800022ba:	8082                	ret

00000000800022bc <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022bc:	1101                	addi	sp,sp,-32
    800022be:	ec06                	sd	ra,24(sp)
    800022c0:	e822                	sd	s0,16(sp)
    800022c2:	e426                	sd	s1,8(sp)
    800022c4:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022c6:	0000d517          	auipc	a0,0xd
    800022ca:	eea50513          	addi	a0,a0,-278 # 8000f1b0 <tickslock>
    800022ce:	00004097          	auipc	ra,0x4
    800022d2:	312080e7          	jalr	786(ra) # 800065e0 <acquire>
  xticks = ticks;
    800022d6:	00007497          	auipc	s1,0x7
    800022da:	d424a483          	lw	s1,-702(s1) # 80009018 <ticks>
  release(&tickslock);
    800022de:	0000d517          	auipc	a0,0xd
    800022e2:	ed250513          	addi	a0,a0,-302 # 8000f1b0 <tickslock>
    800022e6:	00004097          	auipc	ra,0x4
    800022ea:	3ca080e7          	jalr	970(ra) # 800066b0 <release>
  return xticks;
}
    800022ee:	02049513          	slli	a0,s1,0x20
    800022f2:	9101                	srli	a0,a0,0x20
    800022f4:	60e2                	ld	ra,24(sp)
    800022f6:	6442                	ld	s0,16(sp)
    800022f8:	64a2                	ld	s1,8(sp)
    800022fa:	6105                	addi	sp,sp,32
    800022fc:	8082                	ret

00000000800022fe <hash>:
  // Sorted by how recently the buffer was used.
  // head.next is most recent, head.prev is least.
  struct buf head[NBUCKETS];
} bcache;

int hash(uint blockno){
    800022fe:	1141                	addi	sp,sp,-16
    80002300:	e422                	sd	s0,8(sp)
    80002302:	0800                	addi	s0,sp,16
  return blockno % NBUCKETS;
}
    80002304:	47b5                	li	a5,13
    80002306:	02f5753b          	remuw	a0,a0,a5
    8000230a:	6422                	ld	s0,8(sp)
    8000230c:	0141                	addi	sp,sp,16
    8000230e:	8082                	ret

0000000080002310 <binit>:

void
binit(void)
{
    80002310:	7179                	addi	sp,sp,-48
    80002312:	f406                	sd	ra,40(sp)
    80002314:	f022                	sd	s0,32(sp)
    80002316:	ec26                	sd	s1,24(sp)
    80002318:	e84a                	sd	s2,16(sp)
    8000231a:	e44e                	sd	s3,8(sp)
    8000231c:	e052                	sd	s4,0(sp)
    8000231e:	1800                	addi	s0,sp,48
  struct buf *b;

  for (int i = 0; i < NBUCKETS; i++){
    80002320:	0000d917          	auipc	s2,0xd
    80002324:	eb090913          	addi	s2,s2,-336 # 8000f1d0 <bcache>
    80002328:	0000da17          	auipc	s4,0xd
    8000232c:	048a0a13          	addi	s4,s4,72 # 8000f370 <bcache+0x1a0>
{
    80002330:	84ca                	mv	s1,s2
    initlock(&bcache.lock[i], "bcache"); 
    80002332:	00006997          	auipc	s3,0x6
    80002336:	15698993          	addi	s3,s3,342 # 80008488 <syscalls+0xb0>
    8000233a:	85ce                	mv	a1,s3
    8000233c:	8526                	mv	a0,s1
    8000233e:	00004097          	auipc	ra,0x4
    80002342:	41e080e7          	jalr	1054(ra) # 8000675c <initlock>
  for (int i = 0; i < NBUCKETS; i++){
    80002346:	02048493          	addi	s1,s1,32
    8000234a:	ff4498e3          	bne	s1,s4,8000233a <binit+0x2a>
    8000234e:	00015797          	auipc	a5,0x15
    80002352:	36278793          	addi	a5,a5,866 # 800176b0 <bcache+0x84e0>
    80002356:	6731                	lui	a4,0xc
    80002358:	dc070713          	addi	a4,a4,-576 # bdc0 <_entry-0x7fff4240>
    8000235c:	974a                	add	a4,a4,s2
  }

  // Create linked list of buffers
  for (int i = 0; i < NBUCKETS; i++){
    bcache.head[i].prev = &bcache.head[i];
    8000235e:	ebbc                	sd	a5,80(a5)
    bcache.head[i].next = &bcache.head[i];
    80002360:	efbc                	sd	a5,88(a5)
  for (int i = 0; i < NBUCKETS; i++){
    80002362:	46078793          	addi	a5,a5,1120
    80002366:	fee79ce3          	bne	a5,a4,8000235e <binit+0x4e>
  }
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000236a:	0000d497          	auipc	s1,0xd
    8000236e:	00648493          	addi	s1,s1,6 # 8000f370 <bcache+0x1a0>
    b->next = bcache.head[0].next;
    80002372:	00015917          	auipc	s2,0x15
    80002376:	e5e90913          	addi	s2,s2,-418 # 800171d0 <bcache+0x8000>
    b->prev = &bcache.head[0];
    8000237a:	00015997          	auipc	s3,0x15
    8000237e:	33698993          	addi	s3,s3,822 # 800176b0 <bcache+0x84e0>
    initsleeplock(&b->lock, "buffer");
    80002382:	00006a17          	auipc	s4,0x6
    80002386:	10ea0a13          	addi	s4,s4,270 # 80008490 <syscalls+0xb8>
    b->next = bcache.head[0].next;
    8000238a:	53893783          	ld	a5,1336(s2)
    8000238e:	ecbc                	sd	a5,88(s1)
    b->prev = &bcache.head[0];
    80002390:	0534b823          	sd	s3,80(s1)
    initsleeplock(&b->lock, "buffer");
    80002394:	85d2                	mv	a1,s4
    80002396:	01048513          	addi	a0,s1,16
    8000239a:	00001097          	auipc	ra,0x1
    8000239e:	5b2080e7          	jalr	1458(ra) # 8000394c <initsleeplock>
    bcache.head[0].next->prev = b;
    800023a2:	53893783          	ld	a5,1336(s2)
    800023a6:	eba4                	sd	s1,80(a5)
    bcache.head[0].next = b;
    800023a8:	52993c23          	sd	s1,1336(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023ac:	46048493          	addi	s1,s1,1120
    800023b0:	fd349de3          	bne	s1,s3,8000238a <binit+0x7a>
  }
}
    800023b4:	70a2                	ld	ra,40(sp)
    800023b6:	7402                	ld	s0,32(sp)
    800023b8:	64e2                	ld	s1,24(sp)
    800023ba:	6942                	ld	s2,16(sp)
    800023bc:	69a2                	ld	s3,8(sp)
    800023be:	6a02                	ld	s4,0(sp)
    800023c0:	6145                	addi	sp,sp,48
    800023c2:	8082                	ret

00000000800023c4 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023c4:	7119                	addi	sp,sp,-128
    800023c6:	fc86                	sd	ra,120(sp)
    800023c8:	f8a2                	sd	s0,112(sp)
    800023ca:	f4a6                	sd	s1,104(sp)
    800023cc:	f0ca                	sd	s2,96(sp)
    800023ce:	ecce                	sd	s3,88(sp)
    800023d0:	e8d2                	sd	s4,80(sp)
    800023d2:	e4d6                	sd	s5,72(sp)
    800023d4:	e0da                	sd	s6,64(sp)
    800023d6:	fc5e                	sd	s7,56(sp)
    800023d8:	f862                	sd	s8,48(sp)
    800023da:	f466                	sd	s9,40(sp)
    800023dc:	f06a                	sd	s10,32(sp)
    800023de:	ec6e                	sd	s11,24(sp)
    800023e0:	0100                	addi	s0,sp,128
    800023e2:	8c2a                	mv	s8,a0
    800023e4:	8aae                	mv	s5,a1
  return blockno % NBUCKETS;
    800023e6:	4935                	li	s2,13
    800023e8:	0325f93b          	remuw	s2,a1,s2
  acquire(&bcache.lock[id]);
    800023ec:	00591b93          	slli	s7,s2,0x5
    800023f0:	0000d497          	auipc	s1,0xd
    800023f4:	de048493          	addi	s1,s1,-544 # 8000f1d0 <bcache>
    800023f8:	9ba6                	add	s7,s7,s1
    800023fa:	855e                	mv	a0,s7
    800023fc:	00004097          	auipc	ra,0x4
    80002400:	1e4080e7          	jalr	484(ra) # 800065e0 <acquire>
  for(b = bcache.head[id].next; b != &bcache.head[id]; b = b->next){
    80002404:	46000793          	li	a5,1120
    80002408:	02f907b3          	mul	a5,s2,a5
    8000240c:	00f486b3          	add	a3,s1,a5
    80002410:	6721                	lui	a4,0x8
    80002412:	96ba                	add	a3,a3,a4
    80002414:	5386b983          	ld	s3,1336(a3)
    80002418:	4e070713          	addi	a4,a4,1248 # 84e0 <_entry-0x7fff7b20>
    8000241c:	97ba                	add	a5,a5,a4
    8000241e:	97a6                	add	a5,a5,s1
    80002420:	03379463          	bne	a5,s3,80002448 <bread+0x84>
  int i = id;
    80002424:	8a4a                	mv	s4,s2
    i = (i + 1) % NBUCKETS;
    80002426:	4db5                	li	s11,13
    acquire(&bcache.lock[i]);
    80002428:	0000dc97          	auipc	s9,0xd
    8000242c:	da8c8c93          	addi	s9,s9,-600 # 8000f1d0 <bcache>
    for(b = bcache.head[i].prev; b != &bcache.head[i]; b = b->prev){
    80002430:	6d21                	lui	s10,0x8
    80002432:	4e0d0793          	addi	a5,s10,1248 # 84e0 <_entry-0x7fff7b20>
    80002436:	f8f43423          	sd	a5,-120(s0)
    8000243a:	f9243023          	sd	s2,-128(s0)
    8000243e:	a8d1                	j	80002512 <bread+0x14e>
  for(b = bcache.head[id].next; b != &bcache.head[id]; b = b->next){
    80002440:	0589b983          	ld	s3,88(s3)
    80002444:	ff3780e3          	beq	a5,s3,80002424 <bread+0x60>
    if(b->dev == dev && b->blockno == blockno){
    80002448:	0089a703          	lw	a4,8(s3)
    8000244c:	ff871ae3          	bne	a4,s8,80002440 <bread+0x7c>
    80002450:	00c9a703          	lw	a4,12(s3)
    80002454:	ff5716e3          	bne	a4,s5,80002440 <bread+0x7c>
      b->refcnt++;
    80002458:	0489a783          	lw	a5,72(s3)
    8000245c:	2785                	addiw	a5,a5,1
    8000245e:	04f9a423          	sw	a5,72(s3)
      release(&bcache.lock[id]);
    80002462:	855e                	mv	a0,s7
    80002464:	00004097          	auipc	ra,0x4
    80002468:	24c080e7          	jalr	588(ra) # 800066b0 <release>
      acquiresleep(&b->lock);
    8000246c:	01098513          	addi	a0,s3,16
    80002470:	00001097          	auipc	ra,0x1
    80002474:	516080e7          	jalr	1302(ra) # 80003986 <acquiresleep>
      return b;
    80002478:	84ce                	mv	s1,s3
    8000247a:	a0ad                	j	800024e4 <bread+0x120>
    8000247c:	f8043a03          	ld	s4,-128(s0)
    80002480:	a849                	j	80002512 <bread+0x14e>
        b->dev = dev;
    80002482:	0184a423          	sw	s8,8(s1)
        b->blockno = blockno;
    80002486:	0154a623          	sw	s5,12(s1)
        b->valid = 0;
    8000248a:	0004a023          	sw	zero,0(s1)
        b->refcnt = 1;
    8000248e:	4785                	li	a5,1
    80002490:	c4bc                	sw	a5,72(s1)
        b->prev->next = b->next;
    80002492:	68bc                	ld	a5,80(s1)
    80002494:	6cb8                	ld	a4,88(s1)
    80002496:	efb8                	sd	a4,88(a5)
        b->next->prev = b->prev;
    80002498:	6cbc                	ld	a5,88(s1)
    8000249a:	68b8                	ld	a4,80(s1)
    8000249c:	ebb8                	sd	a4,80(a5)
        release(&bcache.lock[i]);
    8000249e:	855a                	mv	a0,s6
    800024a0:	00004097          	auipc	ra,0x4
    800024a4:	210080e7          	jalr	528(ra) # 800066b0 <release>
        b->prev = &bcache.head[id];
    800024a8:	0534b823          	sd	s3,80(s1)
        b->next = bcache.head[id].next;
    800024ac:	46000793          	li	a5,1120
    800024b0:	02f90933          	mul	s2,s2,a5
    800024b4:	0000d797          	auipc	a5,0xd
    800024b8:	d1c78793          	addi	a5,a5,-740 # 8000f1d0 <bcache>
    800024bc:	97ca                	add	a5,a5,s2
    800024be:	6921                	lui	s2,0x8
    800024c0:	993e                	add	s2,s2,a5
    800024c2:	53893783          	ld	a5,1336(s2) # 8538 <_entry-0x7fff7ac8>
    800024c6:	ecbc                	sd	a5,88(s1)
        b->next->prev = b;
    800024c8:	eba4                	sd	s1,80(a5)
        b->prev->next = b;
    800024ca:	68bc                	ld	a5,80(s1)
    800024cc:	efa4                	sd	s1,88(a5)
        release(&bcache.lock[id]);
    800024ce:	855e                	mv	a0,s7
    800024d0:	00004097          	auipc	ra,0x4
    800024d4:	1e0080e7          	jalr	480(ra) # 800066b0 <release>
        acquiresleep(&b->lock);
    800024d8:	01048513          	addi	a0,s1,16
    800024dc:	00001097          	auipc	ra,0x1
    800024e0:	4aa080e7          	jalr	1194(ra) # 80003986 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024e4:	409c                	lw	a5,0(s1)
    800024e6:	cba5                	beqz	a5,80002556 <bread+0x192>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024e8:	8526                	mv	a0,s1
    800024ea:	70e6                	ld	ra,120(sp)
    800024ec:	7446                	ld	s0,112(sp)
    800024ee:	74a6                	ld	s1,104(sp)
    800024f0:	7906                	ld	s2,96(sp)
    800024f2:	69e6                	ld	s3,88(sp)
    800024f4:	6a46                	ld	s4,80(sp)
    800024f6:	6aa6                	ld	s5,72(sp)
    800024f8:	6b06                	ld	s6,64(sp)
    800024fa:	7be2                	ld	s7,56(sp)
    800024fc:	7c42                	ld	s8,48(sp)
    800024fe:	7ca2                	ld	s9,40(sp)
    80002500:	7d02                	ld	s10,32(sp)
    80002502:	6de2                	ld	s11,24(sp)
    80002504:	6109                	addi	sp,sp,128
    80002506:	8082                	ret
    release(&bcache.lock[i]);
    80002508:	855a                	mv	a0,s6
    8000250a:	00004097          	auipc	ra,0x4
    8000250e:	1a6080e7          	jalr	422(ra) # 800066b0 <release>
    i = (i + 1) % NBUCKETS;
    80002512:	2a05                	addiw	s4,s4,1
    80002514:	03ba6a3b          	remw	s4,s4,s11
    if (i == id) continue;
    80002518:	f72a02e3          	beq	s4,s2,8000247c <bread+0xb8>
    acquire(&bcache.lock[i]);
    8000251c:	005a1b13          	slli	s6,s4,0x5
    80002520:	9b66                	add	s6,s6,s9
    80002522:	855a                	mv	a0,s6
    80002524:	00004097          	auipc	ra,0x4
    80002528:	0bc080e7          	jalr	188(ra) # 800065e0 <acquire>
    for(b = bcache.head[i].prev; b != &bcache.head[i]; b = b->prev){
    8000252c:	46000793          	li	a5,1120
    80002530:	02fa07b3          	mul	a5,s4,a5
    80002534:	00fc8733          	add	a4,s9,a5
    80002538:	976a                	add	a4,a4,s10
    8000253a:	53073483          	ld	s1,1328(a4)
    8000253e:	f8843703          	ld	a4,-120(s0)
    80002542:	97ba                	add	a5,a5,a4
    80002544:	97e6                	add	a5,a5,s9
    80002546:	fcf481e3          	beq	s1,a5,80002508 <bread+0x144>
      if(b->refcnt == 0) {
    8000254a:	44b8                	lw	a4,72(s1)
    8000254c:	db1d                	beqz	a4,80002482 <bread+0xbe>
    for(b = bcache.head[i].prev; b != &bcache.head[i]; b = b->prev){
    8000254e:	68a4                	ld	s1,80(s1)
    80002550:	fef49de3          	bne	s1,a5,8000254a <bread+0x186>
    80002554:	bf55                	j	80002508 <bread+0x144>
    virtio_disk_rw(b, 0);
    80002556:	4581                	li	a1,0
    80002558:	8526                	mv	a0,s1
    8000255a:	00003097          	auipc	ra,0x3
    8000255e:	f5c080e7          	jalr	-164(ra) # 800054b6 <virtio_disk_rw>
    b->valid = 1;
    80002562:	4785                	li	a5,1
    80002564:	c09c                	sw	a5,0(s1)
  return b;
    80002566:	b749                	j	800024e8 <bread+0x124>

0000000080002568 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002568:	1101                	addi	sp,sp,-32
    8000256a:	ec06                	sd	ra,24(sp)
    8000256c:	e822                	sd	s0,16(sp)
    8000256e:	e426                	sd	s1,8(sp)
    80002570:	1000                	addi	s0,sp,32
    80002572:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002574:	0541                	addi	a0,a0,16
    80002576:	00001097          	auipc	ra,0x1
    8000257a:	4aa080e7          	jalr	1194(ra) # 80003a20 <holdingsleep>
    8000257e:	cd01                	beqz	a0,80002596 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002580:	4585                	li	a1,1
    80002582:	8526                	mv	a0,s1
    80002584:	00003097          	auipc	ra,0x3
    80002588:	f32080e7          	jalr	-206(ra) # 800054b6 <virtio_disk_rw>
}
    8000258c:	60e2                	ld	ra,24(sp)
    8000258e:	6442                	ld	s0,16(sp)
    80002590:	64a2                	ld	s1,8(sp)
    80002592:	6105                	addi	sp,sp,32
    80002594:	8082                	ret
    panic("bwrite");
    80002596:	00006517          	auipc	a0,0x6
    8000259a:	f0250513          	addi	a0,a0,-254 # 80008498 <syscalls+0xc0>
    8000259e:	00004097          	auipc	ra,0x4
    800025a2:	b0e080e7          	jalr	-1266(ra) # 800060ac <panic>

00000000800025a6 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800025a6:	7179                	addi	sp,sp,-48
    800025a8:	f406                	sd	ra,40(sp)
    800025aa:	f022                	sd	s0,32(sp)
    800025ac:	ec26                	sd	s1,24(sp)
    800025ae:	e84a                	sd	s2,16(sp)
    800025b0:	e44e                	sd	s3,8(sp)
    800025b2:	1800                	addi	s0,sp,48
    800025b4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025b6:	01050993          	addi	s3,a0,16
    800025ba:	854e                	mv	a0,s3
    800025bc:	00001097          	auipc	ra,0x1
    800025c0:	464080e7          	jalr	1124(ra) # 80003a20 <holdingsleep>
    800025c4:	c951                	beqz	a0,80002658 <brelse+0xb2>
  return blockno % NBUCKETS;
    800025c6:	00c4a903          	lw	s2,12(s1)
    800025ca:	47b5                	li	a5,13
    800025cc:	02f9793b          	remuw	s2,s2,a5
    panic("brelse");

  int id = hash(b->blockno);

  releasesleep(&b->lock);
    800025d0:	854e                	mv	a0,s3
    800025d2:	00001097          	auipc	ra,0x1
    800025d6:	40a080e7          	jalr	1034(ra) # 800039dc <releasesleep>

  acquire(&bcache.lock[id]);
    800025da:	00591993          	slli	s3,s2,0x5
    800025de:	0000d797          	auipc	a5,0xd
    800025e2:	bf278793          	addi	a5,a5,-1038 # 8000f1d0 <bcache>
    800025e6:	99be                	add	s3,s3,a5
    800025e8:	854e                	mv	a0,s3
    800025ea:	00004097          	auipc	ra,0x4
    800025ee:	ff6080e7          	jalr	-10(ra) # 800065e0 <acquire>
  b->refcnt--;
    800025f2:	44bc                	lw	a5,72(s1)
    800025f4:	37fd                	addiw	a5,a5,-1
    800025f6:	0007871b          	sext.w	a4,a5
    800025fa:	c4bc                	sw	a5,72(s1)
  if (b->refcnt == 0) {
    800025fc:	e331                	bnez	a4,80002640 <brelse+0x9a>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800025fe:	6cbc                	ld	a5,88(s1)
    80002600:	68b8                	ld	a4,80(s1)
    80002602:	ebb8                	sd	a4,80(a5)
    b->prev->next = b->next;
    80002604:	68bc                	ld	a5,80(s1)
    80002606:	6cb8                	ld	a4,88(s1)
    80002608:	efb8                	sd	a4,88(a5)
    b->next = bcache.head[id].next;
    8000260a:	0000d697          	auipc	a3,0xd
    8000260e:	bc668693          	addi	a3,a3,-1082 # 8000f1d0 <bcache>
    80002612:	46000613          	li	a2,1120
    80002616:	02c907b3          	mul	a5,s2,a2
    8000261a:	97b6                	add	a5,a5,a3
    8000261c:	6721                	lui	a4,0x8
    8000261e:	97ba                	add	a5,a5,a4
    80002620:	5387b583          	ld	a1,1336(a5)
    80002624:	ecac                	sd	a1,88(s1)
    b->prev = &bcache.head[id];
    80002626:	02c90933          	mul	s2,s2,a2
    8000262a:	4e070713          	addi	a4,a4,1248 # 84e0 <_entry-0x7fff7b20>
    8000262e:	993a                	add	s2,s2,a4
    80002630:	9936                	add	s2,s2,a3
    80002632:	0524b823          	sd	s2,80(s1)
    bcache.head[id].next->prev = b;
    80002636:	5387b703          	ld	a4,1336(a5)
    8000263a:	eb24                	sd	s1,80(a4)
    bcache.head[id].next = b;
    8000263c:	5297bc23          	sd	s1,1336(a5)
  }

  release(&bcache.lock[id]);
    80002640:	854e                	mv	a0,s3
    80002642:	00004097          	auipc	ra,0x4
    80002646:	06e080e7          	jalr	110(ra) # 800066b0 <release>
}
    8000264a:	70a2                	ld	ra,40(sp)
    8000264c:	7402                	ld	s0,32(sp)
    8000264e:	64e2                	ld	s1,24(sp)
    80002650:	6942                	ld	s2,16(sp)
    80002652:	69a2                	ld	s3,8(sp)
    80002654:	6145                	addi	sp,sp,48
    80002656:	8082                	ret
    panic("brelse");
    80002658:	00006517          	auipc	a0,0x6
    8000265c:	e4850513          	addi	a0,a0,-440 # 800084a0 <syscalls+0xc8>
    80002660:	00004097          	auipc	ra,0x4
    80002664:	a4c080e7          	jalr	-1460(ra) # 800060ac <panic>

0000000080002668 <bpin>:

void
bpin(struct buf *b) {
    80002668:	1101                	addi	sp,sp,-32
    8000266a:	ec06                	sd	ra,24(sp)
    8000266c:	e822                	sd	s0,16(sp)
    8000266e:	e426                	sd	s1,8(sp)
    80002670:	e04a                	sd	s2,0(sp)
    80002672:	1000                	addi	s0,sp,32
    80002674:	892a                	mv	s2,a0
  return blockno % NBUCKETS;
    80002676:	4544                	lw	s1,12(a0)
  int id = hash(b->blockno);
  acquire(&bcache.lock[id]);
    80002678:	47b5                	li	a5,13
    8000267a:	02f4f4bb          	remuw	s1,s1,a5
    8000267e:	0496                	slli	s1,s1,0x5
    80002680:	0000d797          	auipc	a5,0xd
    80002684:	b5078793          	addi	a5,a5,-1200 # 8000f1d0 <bcache>
    80002688:	94be                	add	s1,s1,a5
    8000268a:	8526                	mv	a0,s1
    8000268c:	00004097          	auipc	ra,0x4
    80002690:	f54080e7          	jalr	-172(ra) # 800065e0 <acquire>
  b->refcnt++;
    80002694:	04892783          	lw	a5,72(s2)
    80002698:	2785                	addiw	a5,a5,1
    8000269a:	04f92423          	sw	a5,72(s2)
  release(&bcache.lock[id]);
    8000269e:	8526                	mv	a0,s1
    800026a0:	00004097          	auipc	ra,0x4
    800026a4:	010080e7          	jalr	16(ra) # 800066b0 <release>
}
    800026a8:	60e2                	ld	ra,24(sp)
    800026aa:	6442                	ld	s0,16(sp)
    800026ac:	64a2                	ld	s1,8(sp)
    800026ae:	6902                	ld	s2,0(sp)
    800026b0:	6105                	addi	sp,sp,32
    800026b2:	8082                	ret

00000000800026b4 <bunpin>:

void
bunpin(struct buf *b) {
    800026b4:	1101                	addi	sp,sp,-32
    800026b6:	ec06                	sd	ra,24(sp)
    800026b8:	e822                	sd	s0,16(sp)
    800026ba:	e426                	sd	s1,8(sp)
    800026bc:	e04a                	sd	s2,0(sp)
    800026be:	1000                	addi	s0,sp,32
    800026c0:	892a                	mv	s2,a0
  return blockno % NBUCKETS;
    800026c2:	4544                	lw	s1,12(a0)
  int id = hash(b->blockno);
  acquire(&bcache.lock[id]);
    800026c4:	47b5                	li	a5,13
    800026c6:	02f4f4bb          	remuw	s1,s1,a5
    800026ca:	0496                	slli	s1,s1,0x5
    800026cc:	0000d797          	auipc	a5,0xd
    800026d0:	b0478793          	addi	a5,a5,-1276 # 8000f1d0 <bcache>
    800026d4:	94be                	add	s1,s1,a5
    800026d6:	8526                	mv	a0,s1
    800026d8:	00004097          	auipc	ra,0x4
    800026dc:	f08080e7          	jalr	-248(ra) # 800065e0 <acquire>
  b->refcnt--;
    800026e0:	04892783          	lw	a5,72(s2)
    800026e4:	37fd                	addiw	a5,a5,-1
    800026e6:	04f92423          	sw	a5,72(s2)
  release(&bcache.lock[id]);
    800026ea:	8526                	mv	a0,s1
    800026ec:	00004097          	auipc	ra,0x4
    800026f0:	fc4080e7          	jalr	-60(ra) # 800066b0 <release>
}
    800026f4:	60e2                	ld	ra,24(sp)
    800026f6:	6442                	ld	s0,16(sp)
    800026f8:	64a2                	ld	s1,8(sp)
    800026fa:	6902                	ld	s2,0(sp)
    800026fc:	6105                	addi	sp,sp,32
    800026fe:	8082                	ret

0000000080002700 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002700:	1101                	addi	sp,sp,-32
    80002702:	ec06                	sd	ra,24(sp)
    80002704:	e822                	sd	s0,16(sp)
    80002706:	e426                	sd	s1,8(sp)
    80002708:	e04a                	sd	s2,0(sp)
    8000270a:	1000                	addi	s0,sp,32
    8000270c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000270e:	00d5d59b          	srliw	a1,a1,0xd
    80002712:	00019797          	auipc	a5,0x19
    80002716:	89a7a783          	lw	a5,-1894(a5) # 8001afac <sb+0x1c>
    8000271a:	9dbd                	addw	a1,a1,a5
    8000271c:	00000097          	auipc	ra,0x0
    80002720:	ca8080e7          	jalr	-856(ra) # 800023c4 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002724:	0074f713          	andi	a4,s1,7
    80002728:	4785                	li	a5,1
    8000272a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000272e:	14ce                	slli	s1,s1,0x33
    80002730:	90d9                	srli	s1,s1,0x36
    80002732:	00950733          	add	a4,a0,s1
    80002736:	06074703          	lbu	a4,96(a4)
    8000273a:	00e7f6b3          	and	a3,a5,a4
    8000273e:	c69d                	beqz	a3,8000276c <bfree+0x6c>
    80002740:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002742:	94aa                	add	s1,s1,a0
    80002744:	fff7c793          	not	a5,a5
    80002748:	8ff9                	and	a5,a5,a4
    8000274a:	06f48023          	sb	a5,96(s1)
  log_write(bp);
    8000274e:	00001097          	auipc	ra,0x1
    80002752:	118080e7          	jalr	280(ra) # 80003866 <log_write>
  brelse(bp);
    80002756:	854a                	mv	a0,s2
    80002758:	00000097          	auipc	ra,0x0
    8000275c:	e4e080e7          	jalr	-434(ra) # 800025a6 <brelse>
}
    80002760:	60e2                	ld	ra,24(sp)
    80002762:	6442                	ld	s0,16(sp)
    80002764:	64a2                	ld	s1,8(sp)
    80002766:	6902                	ld	s2,0(sp)
    80002768:	6105                	addi	sp,sp,32
    8000276a:	8082                	ret
    panic("freeing free block");
    8000276c:	00006517          	auipc	a0,0x6
    80002770:	d3c50513          	addi	a0,a0,-708 # 800084a8 <syscalls+0xd0>
    80002774:	00004097          	auipc	ra,0x4
    80002778:	938080e7          	jalr	-1736(ra) # 800060ac <panic>

000000008000277c <balloc>:
{
    8000277c:	711d                	addi	sp,sp,-96
    8000277e:	ec86                	sd	ra,88(sp)
    80002780:	e8a2                	sd	s0,80(sp)
    80002782:	e4a6                	sd	s1,72(sp)
    80002784:	e0ca                	sd	s2,64(sp)
    80002786:	fc4e                	sd	s3,56(sp)
    80002788:	f852                	sd	s4,48(sp)
    8000278a:	f456                	sd	s5,40(sp)
    8000278c:	f05a                	sd	s6,32(sp)
    8000278e:	ec5e                	sd	s7,24(sp)
    80002790:	e862                	sd	s8,16(sp)
    80002792:	e466                	sd	s9,8(sp)
    80002794:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002796:	00018797          	auipc	a5,0x18
    8000279a:	7fe7a783          	lw	a5,2046(a5) # 8001af94 <sb+0x4>
    8000279e:	cbd1                	beqz	a5,80002832 <balloc+0xb6>
    800027a0:	8baa                	mv	s7,a0
    800027a2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800027a4:	00018b17          	auipc	s6,0x18
    800027a8:	7ecb0b13          	addi	s6,s6,2028 # 8001af90 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027ac:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800027ae:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027b0:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800027b2:	6c89                	lui	s9,0x2
    800027b4:	a831                	j	800027d0 <balloc+0x54>
    brelse(bp);
    800027b6:	854a                	mv	a0,s2
    800027b8:	00000097          	auipc	ra,0x0
    800027bc:	dee080e7          	jalr	-530(ra) # 800025a6 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800027c0:	015c87bb          	addw	a5,s9,s5
    800027c4:	00078a9b          	sext.w	s5,a5
    800027c8:	004b2703          	lw	a4,4(s6)
    800027cc:	06eaf363          	bgeu	s5,a4,80002832 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800027d0:	41fad79b          	sraiw	a5,s5,0x1f
    800027d4:	0137d79b          	srliw	a5,a5,0x13
    800027d8:	015787bb          	addw	a5,a5,s5
    800027dc:	40d7d79b          	sraiw	a5,a5,0xd
    800027e0:	01cb2583          	lw	a1,28(s6)
    800027e4:	9dbd                	addw	a1,a1,a5
    800027e6:	855e                	mv	a0,s7
    800027e8:	00000097          	auipc	ra,0x0
    800027ec:	bdc080e7          	jalr	-1060(ra) # 800023c4 <bread>
    800027f0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027f2:	004b2503          	lw	a0,4(s6)
    800027f6:	000a849b          	sext.w	s1,s5
    800027fa:	8662                	mv	a2,s8
    800027fc:	faa4fde3          	bgeu	s1,a0,800027b6 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002800:	41f6579b          	sraiw	a5,a2,0x1f
    80002804:	01d7d69b          	srliw	a3,a5,0x1d
    80002808:	00c6873b          	addw	a4,a3,a2
    8000280c:	00777793          	andi	a5,a4,7
    80002810:	9f95                	subw	a5,a5,a3
    80002812:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002816:	4037571b          	sraiw	a4,a4,0x3
    8000281a:	00e906b3          	add	a3,s2,a4
    8000281e:	0606c683          	lbu	a3,96(a3)
    80002822:	00d7f5b3          	and	a1,a5,a3
    80002826:	cd91                	beqz	a1,80002842 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002828:	2605                	addiw	a2,a2,1
    8000282a:	2485                	addiw	s1,s1,1
    8000282c:	fd4618e3          	bne	a2,s4,800027fc <balloc+0x80>
    80002830:	b759                	j	800027b6 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002832:	00006517          	auipc	a0,0x6
    80002836:	c8e50513          	addi	a0,a0,-882 # 800084c0 <syscalls+0xe8>
    8000283a:	00004097          	auipc	ra,0x4
    8000283e:	872080e7          	jalr	-1934(ra) # 800060ac <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002842:	974a                	add	a4,a4,s2
    80002844:	8fd5                	or	a5,a5,a3
    80002846:	06f70023          	sb	a5,96(a4)
        log_write(bp);
    8000284a:	854a                	mv	a0,s2
    8000284c:	00001097          	auipc	ra,0x1
    80002850:	01a080e7          	jalr	26(ra) # 80003866 <log_write>
        brelse(bp);
    80002854:	854a                	mv	a0,s2
    80002856:	00000097          	auipc	ra,0x0
    8000285a:	d50080e7          	jalr	-688(ra) # 800025a6 <brelse>
  bp = bread(dev, bno);
    8000285e:	85a6                	mv	a1,s1
    80002860:	855e                	mv	a0,s7
    80002862:	00000097          	auipc	ra,0x0
    80002866:	b62080e7          	jalr	-1182(ra) # 800023c4 <bread>
    8000286a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000286c:	40000613          	li	a2,1024
    80002870:	4581                	li	a1,0
    80002872:	06050513          	addi	a0,a0,96
    80002876:	ffffe097          	auipc	ra,0xffffe
    8000287a:	a1a080e7          	jalr	-1510(ra) # 80000290 <memset>
  log_write(bp);
    8000287e:	854a                	mv	a0,s2
    80002880:	00001097          	auipc	ra,0x1
    80002884:	fe6080e7          	jalr	-26(ra) # 80003866 <log_write>
  brelse(bp);
    80002888:	854a                	mv	a0,s2
    8000288a:	00000097          	auipc	ra,0x0
    8000288e:	d1c080e7          	jalr	-740(ra) # 800025a6 <brelse>
}
    80002892:	8526                	mv	a0,s1
    80002894:	60e6                	ld	ra,88(sp)
    80002896:	6446                	ld	s0,80(sp)
    80002898:	64a6                	ld	s1,72(sp)
    8000289a:	6906                	ld	s2,64(sp)
    8000289c:	79e2                	ld	s3,56(sp)
    8000289e:	7a42                	ld	s4,48(sp)
    800028a0:	7aa2                	ld	s5,40(sp)
    800028a2:	7b02                	ld	s6,32(sp)
    800028a4:	6be2                	ld	s7,24(sp)
    800028a6:	6c42                	ld	s8,16(sp)
    800028a8:	6ca2                	ld	s9,8(sp)
    800028aa:	6125                	addi	sp,sp,96
    800028ac:	8082                	ret

00000000800028ae <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800028ae:	7179                	addi	sp,sp,-48
    800028b0:	f406                	sd	ra,40(sp)
    800028b2:	f022                	sd	s0,32(sp)
    800028b4:	ec26                	sd	s1,24(sp)
    800028b6:	e84a                	sd	s2,16(sp)
    800028b8:	e44e                	sd	s3,8(sp)
    800028ba:	e052                	sd	s4,0(sp)
    800028bc:	1800                	addi	s0,sp,48
    800028be:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800028c0:	47ad                	li	a5,11
    800028c2:	04b7fe63          	bgeu	a5,a1,8000291e <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800028c6:	ff45849b          	addiw	s1,a1,-12
    800028ca:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800028ce:	0ff00793          	li	a5,255
    800028d2:	0ae7e363          	bltu	a5,a4,80002978 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800028d6:	08852583          	lw	a1,136(a0)
    800028da:	c5ad                	beqz	a1,80002944 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800028dc:	00092503          	lw	a0,0(s2)
    800028e0:	00000097          	auipc	ra,0x0
    800028e4:	ae4080e7          	jalr	-1308(ra) # 800023c4 <bread>
    800028e8:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800028ea:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    800028ee:	02049593          	slli	a1,s1,0x20
    800028f2:	9181                	srli	a1,a1,0x20
    800028f4:	058a                	slli	a1,a1,0x2
    800028f6:	00b784b3          	add	s1,a5,a1
    800028fa:	0004a983          	lw	s3,0(s1)
    800028fe:	04098d63          	beqz	s3,80002958 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002902:	8552                	mv	a0,s4
    80002904:	00000097          	auipc	ra,0x0
    80002908:	ca2080e7          	jalr	-862(ra) # 800025a6 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000290c:	854e                	mv	a0,s3
    8000290e:	70a2                	ld	ra,40(sp)
    80002910:	7402                	ld	s0,32(sp)
    80002912:	64e2                	ld	s1,24(sp)
    80002914:	6942                	ld	s2,16(sp)
    80002916:	69a2                	ld	s3,8(sp)
    80002918:	6a02                	ld	s4,0(sp)
    8000291a:	6145                	addi	sp,sp,48
    8000291c:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000291e:	02059493          	slli	s1,a1,0x20
    80002922:	9081                	srli	s1,s1,0x20
    80002924:	048a                	slli	s1,s1,0x2
    80002926:	94aa                	add	s1,s1,a0
    80002928:	0584a983          	lw	s3,88(s1)
    8000292c:	fe0990e3          	bnez	s3,8000290c <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002930:	4108                	lw	a0,0(a0)
    80002932:	00000097          	auipc	ra,0x0
    80002936:	e4a080e7          	jalr	-438(ra) # 8000277c <balloc>
    8000293a:	0005099b          	sext.w	s3,a0
    8000293e:	0534ac23          	sw	s3,88(s1)
    80002942:	b7e9                	j	8000290c <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002944:	4108                	lw	a0,0(a0)
    80002946:	00000097          	auipc	ra,0x0
    8000294a:	e36080e7          	jalr	-458(ra) # 8000277c <balloc>
    8000294e:	0005059b          	sext.w	a1,a0
    80002952:	08b92423          	sw	a1,136(s2)
    80002956:	b759                	j	800028dc <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002958:	00092503          	lw	a0,0(s2)
    8000295c:	00000097          	auipc	ra,0x0
    80002960:	e20080e7          	jalr	-480(ra) # 8000277c <balloc>
    80002964:	0005099b          	sext.w	s3,a0
    80002968:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000296c:	8552                	mv	a0,s4
    8000296e:	00001097          	auipc	ra,0x1
    80002972:	ef8080e7          	jalr	-264(ra) # 80003866 <log_write>
    80002976:	b771                	j	80002902 <bmap+0x54>
  panic("bmap: out of range");
    80002978:	00006517          	auipc	a0,0x6
    8000297c:	b6050513          	addi	a0,a0,-1184 # 800084d8 <syscalls+0x100>
    80002980:	00003097          	auipc	ra,0x3
    80002984:	72c080e7          	jalr	1836(ra) # 800060ac <panic>

0000000080002988 <iget>:
{
    80002988:	7179                	addi	sp,sp,-48
    8000298a:	f406                	sd	ra,40(sp)
    8000298c:	f022                	sd	s0,32(sp)
    8000298e:	ec26                	sd	s1,24(sp)
    80002990:	e84a                	sd	s2,16(sp)
    80002992:	e44e                	sd	s3,8(sp)
    80002994:	e052                	sd	s4,0(sp)
    80002996:	1800                	addi	s0,sp,48
    80002998:	89aa                	mv	s3,a0
    8000299a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000299c:	00018517          	auipc	a0,0x18
    800029a0:	61450513          	addi	a0,a0,1556 # 8001afb0 <itable>
    800029a4:	00004097          	auipc	ra,0x4
    800029a8:	c3c080e7          	jalr	-964(ra) # 800065e0 <acquire>
  empty = 0;
    800029ac:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029ae:	00018497          	auipc	s1,0x18
    800029b2:	62248493          	addi	s1,s1,1570 # 8001afd0 <itable+0x20>
    800029b6:	0001a697          	auipc	a3,0x1a
    800029ba:	23a68693          	addi	a3,a3,570 # 8001cbf0 <log>
    800029be:	a039                	j	800029cc <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029c0:	02090b63          	beqz	s2,800029f6 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029c4:	09048493          	addi	s1,s1,144
    800029c8:	02d48a63          	beq	s1,a3,800029fc <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800029cc:	449c                	lw	a5,8(s1)
    800029ce:	fef059e3          	blez	a5,800029c0 <iget+0x38>
    800029d2:	4098                	lw	a4,0(s1)
    800029d4:	ff3716e3          	bne	a4,s3,800029c0 <iget+0x38>
    800029d8:	40d8                	lw	a4,4(s1)
    800029da:	ff4713e3          	bne	a4,s4,800029c0 <iget+0x38>
      ip->ref++;
    800029de:	2785                	addiw	a5,a5,1
    800029e0:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800029e2:	00018517          	auipc	a0,0x18
    800029e6:	5ce50513          	addi	a0,a0,1486 # 8001afb0 <itable>
    800029ea:	00004097          	auipc	ra,0x4
    800029ee:	cc6080e7          	jalr	-826(ra) # 800066b0 <release>
      return ip;
    800029f2:	8926                	mv	s2,s1
    800029f4:	a03d                	j	80002a22 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029f6:	f7f9                	bnez	a5,800029c4 <iget+0x3c>
    800029f8:	8926                	mv	s2,s1
    800029fa:	b7e9                	j	800029c4 <iget+0x3c>
  if(empty == 0)
    800029fc:	02090c63          	beqz	s2,80002a34 <iget+0xac>
  ip->dev = dev;
    80002a00:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a04:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a08:	4785                	li	a5,1
    80002a0a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a0e:	04092423          	sw	zero,72(s2)
  release(&itable.lock);
    80002a12:	00018517          	auipc	a0,0x18
    80002a16:	59e50513          	addi	a0,a0,1438 # 8001afb0 <itable>
    80002a1a:	00004097          	auipc	ra,0x4
    80002a1e:	c96080e7          	jalr	-874(ra) # 800066b0 <release>
}
    80002a22:	854a                	mv	a0,s2
    80002a24:	70a2                	ld	ra,40(sp)
    80002a26:	7402                	ld	s0,32(sp)
    80002a28:	64e2                	ld	s1,24(sp)
    80002a2a:	6942                	ld	s2,16(sp)
    80002a2c:	69a2                	ld	s3,8(sp)
    80002a2e:	6a02                	ld	s4,0(sp)
    80002a30:	6145                	addi	sp,sp,48
    80002a32:	8082                	ret
    panic("iget: no inodes");
    80002a34:	00006517          	auipc	a0,0x6
    80002a38:	abc50513          	addi	a0,a0,-1348 # 800084f0 <syscalls+0x118>
    80002a3c:	00003097          	auipc	ra,0x3
    80002a40:	670080e7          	jalr	1648(ra) # 800060ac <panic>

0000000080002a44 <fsinit>:
fsinit(int dev) {
    80002a44:	7179                	addi	sp,sp,-48
    80002a46:	f406                	sd	ra,40(sp)
    80002a48:	f022                	sd	s0,32(sp)
    80002a4a:	ec26                	sd	s1,24(sp)
    80002a4c:	e84a                	sd	s2,16(sp)
    80002a4e:	e44e                	sd	s3,8(sp)
    80002a50:	1800                	addi	s0,sp,48
    80002a52:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a54:	4585                	li	a1,1
    80002a56:	00000097          	auipc	ra,0x0
    80002a5a:	96e080e7          	jalr	-1682(ra) # 800023c4 <bread>
    80002a5e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a60:	00018997          	auipc	s3,0x18
    80002a64:	53098993          	addi	s3,s3,1328 # 8001af90 <sb>
    80002a68:	02000613          	li	a2,32
    80002a6c:	06050593          	addi	a1,a0,96
    80002a70:	854e                	mv	a0,s3
    80002a72:	ffffe097          	auipc	ra,0xffffe
    80002a76:	87e080e7          	jalr	-1922(ra) # 800002f0 <memmove>
  brelse(bp);
    80002a7a:	8526                	mv	a0,s1
    80002a7c:	00000097          	auipc	ra,0x0
    80002a80:	b2a080e7          	jalr	-1238(ra) # 800025a6 <brelse>
  if(sb.magic != FSMAGIC)
    80002a84:	0009a703          	lw	a4,0(s3)
    80002a88:	102037b7          	lui	a5,0x10203
    80002a8c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a90:	02f71263          	bne	a4,a5,80002ab4 <fsinit+0x70>
  initlog(dev, &sb);
    80002a94:	00018597          	auipc	a1,0x18
    80002a98:	4fc58593          	addi	a1,a1,1276 # 8001af90 <sb>
    80002a9c:	854a                	mv	a0,s2
    80002a9e:	00001097          	auipc	ra,0x1
    80002aa2:	b4c080e7          	jalr	-1204(ra) # 800035ea <initlog>
}
    80002aa6:	70a2                	ld	ra,40(sp)
    80002aa8:	7402                	ld	s0,32(sp)
    80002aaa:	64e2                	ld	s1,24(sp)
    80002aac:	6942                	ld	s2,16(sp)
    80002aae:	69a2                	ld	s3,8(sp)
    80002ab0:	6145                	addi	sp,sp,48
    80002ab2:	8082                	ret
    panic("invalid file system");
    80002ab4:	00006517          	auipc	a0,0x6
    80002ab8:	a4c50513          	addi	a0,a0,-1460 # 80008500 <syscalls+0x128>
    80002abc:	00003097          	auipc	ra,0x3
    80002ac0:	5f0080e7          	jalr	1520(ra) # 800060ac <panic>

0000000080002ac4 <iinit>:
{
    80002ac4:	7179                	addi	sp,sp,-48
    80002ac6:	f406                	sd	ra,40(sp)
    80002ac8:	f022                	sd	s0,32(sp)
    80002aca:	ec26                	sd	s1,24(sp)
    80002acc:	e84a                	sd	s2,16(sp)
    80002ace:	e44e                	sd	s3,8(sp)
    80002ad0:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002ad2:	00006597          	auipc	a1,0x6
    80002ad6:	a4658593          	addi	a1,a1,-1466 # 80008518 <syscalls+0x140>
    80002ada:	00018517          	auipc	a0,0x18
    80002ade:	4d650513          	addi	a0,a0,1238 # 8001afb0 <itable>
    80002ae2:	00004097          	auipc	ra,0x4
    80002ae6:	c7a080e7          	jalr	-902(ra) # 8000675c <initlock>
  for(i = 0; i < NINODE; i++) {
    80002aea:	00018497          	auipc	s1,0x18
    80002aee:	4f648493          	addi	s1,s1,1270 # 8001afe0 <itable+0x30>
    80002af2:	0001a997          	auipc	s3,0x1a
    80002af6:	10e98993          	addi	s3,s3,270 # 8001cc00 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002afa:	00006917          	auipc	s2,0x6
    80002afe:	a2690913          	addi	s2,s2,-1498 # 80008520 <syscalls+0x148>
    80002b02:	85ca                	mv	a1,s2
    80002b04:	8526                	mv	a0,s1
    80002b06:	00001097          	auipc	ra,0x1
    80002b0a:	e46080e7          	jalr	-442(ra) # 8000394c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b0e:	09048493          	addi	s1,s1,144
    80002b12:	ff3498e3          	bne	s1,s3,80002b02 <iinit+0x3e>
}
    80002b16:	70a2                	ld	ra,40(sp)
    80002b18:	7402                	ld	s0,32(sp)
    80002b1a:	64e2                	ld	s1,24(sp)
    80002b1c:	6942                	ld	s2,16(sp)
    80002b1e:	69a2                	ld	s3,8(sp)
    80002b20:	6145                	addi	sp,sp,48
    80002b22:	8082                	ret

0000000080002b24 <ialloc>:
{
    80002b24:	715d                	addi	sp,sp,-80
    80002b26:	e486                	sd	ra,72(sp)
    80002b28:	e0a2                	sd	s0,64(sp)
    80002b2a:	fc26                	sd	s1,56(sp)
    80002b2c:	f84a                	sd	s2,48(sp)
    80002b2e:	f44e                	sd	s3,40(sp)
    80002b30:	f052                	sd	s4,32(sp)
    80002b32:	ec56                	sd	s5,24(sp)
    80002b34:	e85a                	sd	s6,16(sp)
    80002b36:	e45e                	sd	s7,8(sp)
    80002b38:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b3a:	00018717          	auipc	a4,0x18
    80002b3e:	46272703          	lw	a4,1122(a4) # 8001af9c <sb+0xc>
    80002b42:	4785                	li	a5,1
    80002b44:	04e7fa63          	bgeu	a5,a4,80002b98 <ialloc+0x74>
    80002b48:	8aaa                	mv	s5,a0
    80002b4a:	8bae                	mv	s7,a1
    80002b4c:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b4e:	00018a17          	auipc	s4,0x18
    80002b52:	442a0a13          	addi	s4,s4,1090 # 8001af90 <sb>
    80002b56:	00048b1b          	sext.w	s6,s1
    80002b5a:	0044d593          	srli	a1,s1,0x4
    80002b5e:	018a2783          	lw	a5,24(s4)
    80002b62:	9dbd                	addw	a1,a1,a5
    80002b64:	8556                	mv	a0,s5
    80002b66:	00000097          	auipc	ra,0x0
    80002b6a:	85e080e7          	jalr	-1954(ra) # 800023c4 <bread>
    80002b6e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b70:	06050993          	addi	s3,a0,96
    80002b74:	00f4f793          	andi	a5,s1,15
    80002b78:	079a                	slli	a5,a5,0x6
    80002b7a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b7c:	00099783          	lh	a5,0(s3)
    80002b80:	c785                	beqz	a5,80002ba8 <ialloc+0x84>
    brelse(bp);
    80002b82:	00000097          	auipc	ra,0x0
    80002b86:	a24080e7          	jalr	-1500(ra) # 800025a6 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b8a:	0485                	addi	s1,s1,1
    80002b8c:	00ca2703          	lw	a4,12(s4)
    80002b90:	0004879b          	sext.w	a5,s1
    80002b94:	fce7e1e3          	bltu	a5,a4,80002b56 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002b98:	00006517          	auipc	a0,0x6
    80002b9c:	99050513          	addi	a0,a0,-1648 # 80008528 <syscalls+0x150>
    80002ba0:	00003097          	auipc	ra,0x3
    80002ba4:	50c080e7          	jalr	1292(ra) # 800060ac <panic>
      memset(dip, 0, sizeof(*dip));
    80002ba8:	04000613          	li	a2,64
    80002bac:	4581                	li	a1,0
    80002bae:	854e                	mv	a0,s3
    80002bb0:	ffffd097          	auipc	ra,0xffffd
    80002bb4:	6e0080e7          	jalr	1760(ra) # 80000290 <memset>
      dip->type = type;
    80002bb8:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002bbc:	854a                	mv	a0,s2
    80002bbe:	00001097          	auipc	ra,0x1
    80002bc2:	ca8080e7          	jalr	-856(ra) # 80003866 <log_write>
      brelse(bp);
    80002bc6:	854a                	mv	a0,s2
    80002bc8:	00000097          	auipc	ra,0x0
    80002bcc:	9de080e7          	jalr	-1570(ra) # 800025a6 <brelse>
      return iget(dev, inum);
    80002bd0:	85da                	mv	a1,s6
    80002bd2:	8556                	mv	a0,s5
    80002bd4:	00000097          	auipc	ra,0x0
    80002bd8:	db4080e7          	jalr	-588(ra) # 80002988 <iget>
}
    80002bdc:	60a6                	ld	ra,72(sp)
    80002bde:	6406                	ld	s0,64(sp)
    80002be0:	74e2                	ld	s1,56(sp)
    80002be2:	7942                	ld	s2,48(sp)
    80002be4:	79a2                	ld	s3,40(sp)
    80002be6:	7a02                	ld	s4,32(sp)
    80002be8:	6ae2                	ld	s5,24(sp)
    80002bea:	6b42                	ld	s6,16(sp)
    80002bec:	6ba2                	ld	s7,8(sp)
    80002bee:	6161                	addi	sp,sp,80
    80002bf0:	8082                	ret

0000000080002bf2 <iupdate>:
{
    80002bf2:	1101                	addi	sp,sp,-32
    80002bf4:	ec06                	sd	ra,24(sp)
    80002bf6:	e822                	sd	s0,16(sp)
    80002bf8:	e426                	sd	s1,8(sp)
    80002bfa:	e04a                	sd	s2,0(sp)
    80002bfc:	1000                	addi	s0,sp,32
    80002bfe:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c00:	415c                	lw	a5,4(a0)
    80002c02:	0047d79b          	srliw	a5,a5,0x4
    80002c06:	00018597          	auipc	a1,0x18
    80002c0a:	3a25a583          	lw	a1,930(a1) # 8001afa8 <sb+0x18>
    80002c0e:	9dbd                	addw	a1,a1,a5
    80002c10:	4108                	lw	a0,0(a0)
    80002c12:	fffff097          	auipc	ra,0xfffff
    80002c16:	7b2080e7          	jalr	1970(ra) # 800023c4 <bread>
    80002c1a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c1c:	06050793          	addi	a5,a0,96
    80002c20:	40c8                	lw	a0,4(s1)
    80002c22:	893d                	andi	a0,a0,15
    80002c24:	051a                	slli	a0,a0,0x6
    80002c26:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002c28:	04c49703          	lh	a4,76(s1)
    80002c2c:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002c30:	04e49703          	lh	a4,78(s1)
    80002c34:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002c38:	05049703          	lh	a4,80(s1)
    80002c3c:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002c40:	05249703          	lh	a4,82(s1)
    80002c44:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002c48:	48f8                	lw	a4,84(s1)
    80002c4a:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c4c:	03400613          	li	a2,52
    80002c50:	05848593          	addi	a1,s1,88
    80002c54:	0531                	addi	a0,a0,12
    80002c56:	ffffd097          	auipc	ra,0xffffd
    80002c5a:	69a080e7          	jalr	1690(ra) # 800002f0 <memmove>
  log_write(bp);
    80002c5e:	854a                	mv	a0,s2
    80002c60:	00001097          	auipc	ra,0x1
    80002c64:	c06080e7          	jalr	-1018(ra) # 80003866 <log_write>
  brelse(bp);
    80002c68:	854a                	mv	a0,s2
    80002c6a:	00000097          	auipc	ra,0x0
    80002c6e:	93c080e7          	jalr	-1732(ra) # 800025a6 <brelse>
}
    80002c72:	60e2                	ld	ra,24(sp)
    80002c74:	6442                	ld	s0,16(sp)
    80002c76:	64a2                	ld	s1,8(sp)
    80002c78:	6902                	ld	s2,0(sp)
    80002c7a:	6105                	addi	sp,sp,32
    80002c7c:	8082                	ret

0000000080002c7e <idup>:
{
    80002c7e:	1101                	addi	sp,sp,-32
    80002c80:	ec06                	sd	ra,24(sp)
    80002c82:	e822                	sd	s0,16(sp)
    80002c84:	e426                	sd	s1,8(sp)
    80002c86:	1000                	addi	s0,sp,32
    80002c88:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c8a:	00018517          	auipc	a0,0x18
    80002c8e:	32650513          	addi	a0,a0,806 # 8001afb0 <itable>
    80002c92:	00004097          	auipc	ra,0x4
    80002c96:	94e080e7          	jalr	-1714(ra) # 800065e0 <acquire>
  ip->ref++;
    80002c9a:	449c                	lw	a5,8(s1)
    80002c9c:	2785                	addiw	a5,a5,1
    80002c9e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ca0:	00018517          	auipc	a0,0x18
    80002ca4:	31050513          	addi	a0,a0,784 # 8001afb0 <itable>
    80002ca8:	00004097          	auipc	ra,0x4
    80002cac:	a08080e7          	jalr	-1528(ra) # 800066b0 <release>
}
    80002cb0:	8526                	mv	a0,s1
    80002cb2:	60e2                	ld	ra,24(sp)
    80002cb4:	6442                	ld	s0,16(sp)
    80002cb6:	64a2                	ld	s1,8(sp)
    80002cb8:	6105                	addi	sp,sp,32
    80002cba:	8082                	ret

0000000080002cbc <ilock>:
{
    80002cbc:	1101                	addi	sp,sp,-32
    80002cbe:	ec06                	sd	ra,24(sp)
    80002cc0:	e822                	sd	s0,16(sp)
    80002cc2:	e426                	sd	s1,8(sp)
    80002cc4:	e04a                	sd	s2,0(sp)
    80002cc6:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002cc8:	c115                	beqz	a0,80002cec <ilock+0x30>
    80002cca:	84aa                	mv	s1,a0
    80002ccc:	451c                	lw	a5,8(a0)
    80002cce:	00f05f63          	blez	a5,80002cec <ilock+0x30>
  acquiresleep(&ip->lock);
    80002cd2:	0541                	addi	a0,a0,16
    80002cd4:	00001097          	auipc	ra,0x1
    80002cd8:	cb2080e7          	jalr	-846(ra) # 80003986 <acquiresleep>
  if(ip->valid == 0){
    80002cdc:	44bc                	lw	a5,72(s1)
    80002cde:	cf99                	beqz	a5,80002cfc <ilock+0x40>
}
    80002ce0:	60e2                	ld	ra,24(sp)
    80002ce2:	6442                	ld	s0,16(sp)
    80002ce4:	64a2                	ld	s1,8(sp)
    80002ce6:	6902                	ld	s2,0(sp)
    80002ce8:	6105                	addi	sp,sp,32
    80002cea:	8082                	ret
    panic("ilock");
    80002cec:	00006517          	auipc	a0,0x6
    80002cf0:	85450513          	addi	a0,a0,-1964 # 80008540 <syscalls+0x168>
    80002cf4:	00003097          	auipc	ra,0x3
    80002cf8:	3b8080e7          	jalr	952(ra) # 800060ac <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cfc:	40dc                	lw	a5,4(s1)
    80002cfe:	0047d79b          	srliw	a5,a5,0x4
    80002d02:	00018597          	auipc	a1,0x18
    80002d06:	2a65a583          	lw	a1,678(a1) # 8001afa8 <sb+0x18>
    80002d0a:	9dbd                	addw	a1,a1,a5
    80002d0c:	4088                	lw	a0,0(s1)
    80002d0e:	fffff097          	auipc	ra,0xfffff
    80002d12:	6b6080e7          	jalr	1718(ra) # 800023c4 <bread>
    80002d16:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d18:	06050593          	addi	a1,a0,96
    80002d1c:	40dc                	lw	a5,4(s1)
    80002d1e:	8bbd                	andi	a5,a5,15
    80002d20:	079a                	slli	a5,a5,0x6
    80002d22:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d24:	00059783          	lh	a5,0(a1)
    80002d28:	04f49623          	sh	a5,76(s1)
    ip->major = dip->major;
    80002d2c:	00259783          	lh	a5,2(a1)
    80002d30:	04f49723          	sh	a5,78(s1)
    ip->minor = dip->minor;
    80002d34:	00459783          	lh	a5,4(a1)
    80002d38:	04f49823          	sh	a5,80(s1)
    ip->nlink = dip->nlink;
    80002d3c:	00659783          	lh	a5,6(a1)
    80002d40:	04f49923          	sh	a5,82(s1)
    ip->size = dip->size;
    80002d44:	459c                	lw	a5,8(a1)
    80002d46:	c8fc                	sw	a5,84(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d48:	03400613          	li	a2,52
    80002d4c:	05b1                	addi	a1,a1,12
    80002d4e:	05848513          	addi	a0,s1,88
    80002d52:	ffffd097          	auipc	ra,0xffffd
    80002d56:	59e080e7          	jalr	1438(ra) # 800002f0 <memmove>
    brelse(bp);
    80002d5a:	854a                	mv	a0,s2
    80002d5c:	00000097          	auipc	ra,0x0
    80002d60:	84a080e7          	jalr	-1974(ra) # 800025a6 <brelse>
    ip->valid = 1;
    80002d64:	4785                	li	a5,1
    80002d66:	c4bc                	sw	a5,72(s1)
    if(ip->type == 0)
    80002d68:	04c49783          	lh	a5,76(s1)
    80002d6c:	fbb5                	bnez	a5,80002ce0 <ilock+0x24>
      panic("ilock: no type");
    80002d6e:	00005517          	auipc	a0,0x5
    80002d72:	7da50513          	addi	a0,a0,2010 # 80008548 <syscalls+0x170>
    80002d76:	00003097          	auipc	ra,0x3
    80002d7a:	336080e7          	jalr	822(ra) # 800060ac <panic>

0000000080002d7e <iunlock>:
{
    80002d7e:	1101                	addi	sp,sp,-32
    80002d80:	ec06                	sd	ra,24(sp)
    80002d82:	e822                	sd	s0,16(sp)
    80002d84:	e426                	sd	s1,8(sp)
    80002d86:	e04a                	sd	s2,0(sp)
    80002d88:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d8a:	c905                	beqz	a0,80002dba <iunlock+0x3c>
    80002d8c:	84aa                	mv	s1,a0
    80002d8e:	01050913          	addi	s2,a0,16
    80002d92:	854a                	mv	a0,s2
    80002d94:	00001097          	auipc	ra,0x1
    80002d98:	c8c080e7          	jalr	-884(ra) # 80003a20 <holdingsleep>
    80002d9c:	cd19                	beqz	a0,80002dba <iunlock+0x3c>
    80002d9e:	449c                	lw	a5,8(s1)
    80002da0:	00f05d63          	blez	a5,80002dba <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002da4:	854a                	mv	a0,s2
    80002da6:	00001097          	auipc	ra,0x1
    80002daa:	c36080e7          	jalr	-970(ra) # 800039dc <releasesleep>
}
    80002dae:	60e2                	ld	ra,24(sp)
    80002db0:	6442                	ld	s0,16(sp)
    80002db2:	64a2                	ld	s1,8(sp)
    80002db4:	6902                	ld	s2,0(sp)
    80002db6:	6105                	addi	sp,sp,32
    80002db8:	8082                	ret
    panic("iunlock");
    80002dba:	00005517          	auipc	a0,0x5
    80002dbe:	79e50513          	addi	a0,a0,1950 # 80008558 <syscalls+0x180>
    80002dc2:	00003097          	auipc	ra,0x3
    80002dc6:	2ea080e7          	jalr	746(ra) # 800060ac <panic>

0000000080002dca <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002dca:	7179                	addi	sp,sp,-48
    80002dcc:	f406                	sd	ra,40(sp)
    80002dce:	f022                	sd	s0,32(sp)
    80002dd0:	ec26                	sd	s1,24(sp)
    80002dd2:	e84a                	sd	s2,16(sp)
    80002dd4:	e44e                	sd	s3,8(sp)
    80002dd6:	e052                	sd	s4,0(sp)
    80002dd8:	1800                	addi	s0,sp,48
    80002dda:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002ddc:	05850493          	addi	s1,a0,88
    80002de0:	08850913          	addi	s2,a0,136
    80002de4:	a021                	j	80002dec <itrunc+0x22>
    80002de6:	0491                	addi	s1,s1,4
    80002de8:	01248d63          	beq	s1,s2,80002e02 <itrunc+0x38>
    if(ip->addrs[i]){
    80002dec:	408c                	lw	a1,0(s1)
    80002dee:	dde5                	beqz	a1,80002de6 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002df0:	0009a503          	lw	a0,0(s3)
    80002df4:	00000097          	auipc	ra,0x0
    80002df8:	90c080e7          	jalr	-1780(ra) # 80002700 <bfree>
      ip->addrs[i] = 0;
    80002dfc:	0004a023          	sw	zero,0(s1)
    80002e00:	b7dd                	j	80002de6 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e02:	0889a583          	lw	a1,136(s3)
    80002e06:	e185                	bnez	a1,80002e26 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e08:	0409aa23          	sw	zero,84(s3)
  iupdate(ip);
    80002e0c:	854e                	mv	a0,s3
    80002e0e:	00000097          	auipc	ra,0x0
    80002e12:	de4080e7          	jalr	-540(ra) # 80002bf2 <iupdate>
}
    80002e16:	70a2                	ld	ra,40(sp)
    80002e18:	7402                	ld	s0,32(sp)
    80002e1a:	64e2                	ld	s1,24(sp)
    80002e1c:	6942                	ld	s2,16(sp)
    80002e1e:	69a2                	ld	s3,8(sp)
    80002e20:	6a02                	ld	s4,0(sp)
    80002e22:	6145                	addi	sp,sp,48
    80002e24:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e26:	0009a503          	lw	a0,0(s3)
    80002e2a:	fffff097          	auipc	ra,0xfffff
    80002e2e:	59a080e7          	jalr	1434(ra) # 800023c4 <bread>
    80002e32:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e34:	06050493          	addi	s1,a0,96
    80002e38:	46050913          	addi	s2,a0,1120
    80002e3c:	a811                	j	80002e50 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002e3e:	0009a503          	lw	a0,0(s3)
    80002e42:	00000097          	auipc	ra,0x0
    80002e46:	8be080e7          	jalr	-1858(ra) # 80002700 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002e4a:	0491                	addi	s1,s1,4
    80002e4c:	01248563          	beq	s1,s2,80002e56 <itrunc+0x8c>
      if(a[j])
    80002e50:	408c                	lw	a1,0(s1)
    80002e52:	dde5                	beqz	a1,80002e4a <itrunc+0x80>
    80002e54:	b7ed                	j	80002e3e <itrunc+0x74>
    brelse(bp);
    80002e56:	8552                	mv	a0,s4
    80002e58:	fffff097          	auipc	ra,0xfffff
    80002e5c:	74e080e7          	jalr	1870(ra) # 800025a6 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e60:	0889a583          	lw	a1,136(s3)
    80002e64:	0009a503          	lw	a0,0(s3)
    80002e68:	00000097          	auipc	ra,0x0
    80002e6c:	898080e7          	jalr	-1896(ra) # 80002700 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e70:	0809a423          	sw	zero,136(s3)
    80002e74:	bf51                	j	80002e08 <itrunc+0x3e>

0000000080002e76 <iput>:
{
    80002e76:	1101                	addi	sp,sp,-32
    80002e78:	ec06                	sd	ra,24(sp)
    80002e7a:	e822                	sd	s0,16(sp)
    80002e7c:	e426                	sd	s1,8(sp)
    80002e7e:	e04a                	sd	s2,0(sp)
    80002e80:	1000                	addi	s0,sp,32
    80002e82:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e84:	00018517          	auipc	a0,0x18
    80002e88:	12c50513          	addi	a0,a0,300 # 8001afb0 <itable>
    80002e8c:	00003097          	auipc	ra,0x3
    80002e90:	754080e7          	jalr	1876(ra) # 800065e0 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e94:	4498                	lw	a4,8(s1)
    80002e96:	4785                	li	a5,1
    80002e98:	02f70363          	beq	a4,a5,80002ebe <iput+0x48>
  ip->ref--;
    80002e9c:	449c                	lw	a5,8(s1)
    80002e9e:	37fd                	addiw	a5,a5,-1
    80002ea0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ea2:	00018517          	auipc	a0,0x18
    80002ea6:	10e50513          	addi	a0,a0,270 # 8001afb0 <itable>
    80002eaa:	00004097          	auipc	ra,0x4
    80002eae:	806080e7          	jalr	-2042(ra) # 800066b0 <release>
}
    80002eb2:	60e2                	ld	ra,24(sp)
    80002eb4:	6442                	ld	s0,16(sp)
    80002eb6:	64a2                	ld	s1,8(sp)
    80002eb8:	6902                	ld	s2,0(sp)
    80002eba:	6105                	addi	sp,sp,32
    80002ebc:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ebe:	44bc                	lw	a5,72(s1)
    80002ec0:	dff1                	beqz	a5,80002e9c <iput+0x26>
    80002ec2:	05249783          	lh	a5,82(s1)
    80002ec6:	fbf9                	bnez	a5,80002e9c <iput+0x26>
    acquiresleep(&ip->lock);
    80002ec8:	01048913          	addi	s2,s1,16
    80002ecc:	854a                	mv	a0,s2
    80002ece:	00001097          	auipc	ra,0x1
    80002ed2:	ab8080e7          	jalr	-1352(ra) # 80003986 <acquiresleep>
    release(&itable.lock);
    80002ed6:	00018517          	auipc	a0,0x18
    80002eda:	0da50513          	addi	a0,a0,218 # 8001afb0 <itable>
    80002ede:	00003097          	auipc	ra,0x3
    80002ee2:	7d2080e7          	jalr	2002(ra) # 800066b0 <release>
    itrunc(ip);
    80002ee6:	8526                	mv	a0,s1
    80002ee8:	00000097          	auipc	ra,0x0
    80002eec:	ee2080e7          	jalr	-286(ra) # 80002dca <itrunc>
    ip->type = 0;
    80002ef0:	04049623          	sh	zero,76(s1)
    iupdate(ip);
    80002ef4:	8526                	mv	a0,s1
    80002ef6:	00000097          	auipc	ra,0x0
    80002efa:	cfc080e7          	jalr	-772(ra) # 80002bf2 <iupdate>
    ip->valid = 0;
    80002efe:	0404a423          	sw	zero,72(s1)
    releasesleep(&ip->lock);
    80002f02:	854a                	mv	a0,s2
    80002f04:	00001097          	auipc	ra,0x1
    80002f08:	ad8080e7          	jalr	-1320(ra) # 800039dc <releasesleep>
    acquire(&itable.lock);
    80002f0c:	00018517          	auipc	a0,0x18
    80002f10:	0a450513          	addi	a0,a0,164 # 8001afb0 <itable>
    80002f14:	00003097          	auipc	ra,0x3
    80002f18:	6cc080e7          	jalr	1740(ra) # 800065e0 <acquire>
    80002f1c:	b741                	j	80002e9c <iput+0x26>

0000000080002f1e <iunlockput>:
{
    80002f1e:	1101                	addi	sp,sp,-32
    80002f20:	ec06                	sd	ra,24(sp)
    80002f22:	e822                	sd	s0,16(sp)
    80002f24:	e426                	sd	s1,8(sp)
    80002f26:	1000                	addi	s0,sp,32
    80002f28:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f2a:	00000097          	auipc	ra,0x0
    80002f2e:	e54080e7          	jalr	-428(ra) # 80002d7e <iunlock>
  iput(ip);
    80002f32:	8526                	mv	a0,s1
    80002f34:	00000097          	auipc	ra,0x0
    80002f38:	f42080e7          	jalr	-190(ra) # 80002e76 <iput>
}
    80002f3c:	60e2                	ld	ra,24(sp)
    80002f3e:	6442                	ld	s0,16(sp)
    80002f40:	64a2                	ld	s1,8(sp)
    80002f42:	6105                	addi	sp,sp,32
    80002f44:	8082                	ret

0000000080002f46 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f46:	1141                	addi	sp,sp,-16
    80002f48:	e422                	sd	s0,8(sp)
    80002f4a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f4c:	411c                	lw	a5,0(a0)
    80002f4e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f50:	415c                	lw	a5,4(a0)
    80002f52:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f54:	04c51783          	lh	a5,76(a0)
    80002f58:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f5c:	05251783          	lh	a5,82(a0)
    80002f60:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f64:	05456783          	lwu	a5,84(a0)
    80002f68:	e99c                	sd	a5,16(a1)
}
    80002f6a:	6422                	ld	s0,8(sp)
    80002f6c:	0141                	addi	sp,sp,16
    80002f6e:	8082                	ret

0000000080002f70 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f70:	497c                	lw	a5,84(a0)
    80002f72:	0ed7e963          	bltu	a5,a3,80003064 <readi+0xf4>
{
    80002f76:	7159                	addi	sp,sp,-112
    80002f78:	f486                	sd	ra,104(sp)
    80002f7a:	f0a2                	sd	s0,96(sp)
    80002f7c:	eca6                	sd	s1,88(sp)
    80002f7e:	e8ca                	sd	s2,80(sp)
    80002f80:	e4ce                	sd	s3,72(sp)
    80002f82:	e0d2                	sd	s4,64(sp)
    80002f84:	fc56                	sd	s5,56(sp)
    80002f86:	f85a                	sd	s6,48(sp)
    80002f88:	f45e                	sd	s7,40(sp)
    80002f8a:	f062                	sd	s8,32(sp)
    80002f8c:	ec66                	sd	s9,24(sp)
    80002f8e:	e86a                	sd	s10,16(sp)
    80002f90:	e46e                	sd	s11,8(sp)
    80002f92:	1880                	addi	s0,sp,112
    80002f94:	8baa                	mv	s7,a0
    80002f96:	8c2e                	mv	s8,a1
    80002f98:	8ab2                	mv	s5,a2
    80002f9a:	84b6                	mv	s1,a3
    80002f9c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f9e:	9f35                	addw	a4,a4,a3
    return 0;
    80002fa0:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002fa2:	0ad76063          	bltu	a4,a3,80003042 <readi+0xd2>
  if(off + n > ip->size)
    80002fa6:	00e7f463          	bgeu	a5,a4,80002fae <readi+0x3e>
    n = ip->size - off;
    80002faa:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fae:	0a0b0963          	beqz	s6,80003060 <readi+0xf0>
    80002fb2:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fb4:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002fb8:	5cfd                	li	s9,-1
    80002fba:	a82d                	j	80002ff4 <readi+0x84>
    80002fbc:	020a1d93          	slli	s11,s4,0x20
    80002fc0:	020ddd93          	srli	s11,s11,0x20
    80002fc4:	06090613          	addi	a2,s2,96
    80002fc8:	86ee                	mv	a3,s11
    80002fca:	963a                	add	a2,a2,a4
    80002fcc:	85d6                	mv	a1,s5
    80002fce:	8562                	mv	a0,s8
    80002fd0:	fffff097          	auipc	ra,0xfffff
    80002fd4:	a00080e7          	jalr	-1536(ra) # 800019d0 <either_copyout>
    80002fd8:	05950d63          	beq	a0,s9,80003032 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002fdc:	854a                	mv	a0,s2
    80002fde:	fffff097          	auipc	ra,0xfffff
    80002fe2:	5c8080e7          	jalr	1480(ra) # 800025a6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fe6:	013a09bb          	addw	s3,s4,s3
    80002fea:	009a04bb          	addw	s1,s4,s1
    80002fee:	9aee                	add	s5,s5,s11
    80002ff0:	0569f763          	bgeu	s3,s6,8000303e <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002ff4:	000ba903          	lw	s2,0(s7)
    80002ff8:	00a4d59b          	srliw	a1,s1,0xa
    80002ffc:	855e                	mv	a0,s7
    80002ffe:	00000097          	auipc	ra,0x0
    80003002:	8b0080e7          	jalr	-1872(ra) # 800028ae <bmap>
    80003006:	0005059b          	sext.w	a1,a0
    8000300a:	854a                	mv	a0,s2
    8000300c:	fffff097          	auipc	ra,0xfffff
    80003010:	3b8080e7          	jalr	952(ra) # 800023c4 <bread>
    80003014:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003016:	3ff4f713          	andi	a4,s1,1023
    8000301a:	40ed07bb          	subw	a5,s10,a4
    8000301e:	413b06bb          	subw	a3,s6,s3
    80003022:	8a3e                	mv	s4,a5
    80003024:	2781                	sext.w	a5,a5
    80003026:	0006861b          	sext.w	a2,a3
    8000302a:	f8f679e3          	bgeu	a2,a5,80002fbc <readi+0x4c>
    8000302e:	8a36                	mv	s4,a3
    80003030:	b771                	j	80002fbc <readi+0x4c>
      brelse(bp);
    80003032:	854a                	mv	a0,s2
    80003034:	fffff097          	auipc	ra,0xfffff
    80003038:	572080e7          	jalr	1394(ra) # 800025a6 <brelse>
      tot = -1;
    8000303c:	59fd                	li	s3,-1
  }
  return tot;
    8000303e:	0009851b          	sext.w	a0,s3
}
    80003042:	70a6                	ld	ra,104(sp)
    80003044:	7406                	ld	s0,96(sp)
    80003046:	64e6                	ld	s1,88(sp)
    80003048:	6946                	ld	s2,80(sp)
    8000304a:	69a6                	ld	s3,72(sp)
    8000304c:	6a06                	ld	s4,64(sp)
    8000304e:	7ae2                	ld	s5,56(sp)
    80003050:	7b42                	ld	s6,48(sp)
    80003052:	7ba2                	ld	s7,40(sp)
    80003054:	7c02                	ld	s8,32(sp)
    80003056:	6ce2                	ld	s9,24(sp)
    80003058:	6d42                	ld	s10,16(sp)
    8000305a:	6da2                	ld	s11,8(sp)
    8000305c:	6165                	addi	sp,sp,112
    8000305e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003060:	89da                	mv	s3,s6
    80003062:	bff1                	j	8000303e <readi+0xce>
    return 0;
    80003064:	4501                	li	a0,0
}
    80003066:	8082                	ret

0000000080003068 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003068:	497c                	lw	a5,84(a0)
    8000306a:	10d7e863          	bltu	a5,a3,8000317a <writei+0x112>
{
    8000306e:	7159                	addi	sp,sp,-112
    80003070:	f486                	sd	ra,104(sp)
    80003072:	f0a2                	sd	s0,96(sp)
    80003074:	eca6                	sd	s1,88(sp)
    80003076:	e8ca                	sd	s2,80(sp)
    80003078:	e4ce                	sd	s3,72(sp)
    8000307a:	e0d2                	sd	s4,64(sp)
    8000307c:	fc56                	sd	s5,56(sp)
    8000307e:	f85a                	sd	s6,48(sp)
    80003080:	f45e                	sd	s7,40(sp)
    80003082:	f062                	sd	s8,32(sp)
    80003084:	ec66                	sd	s9,24(sp)
    80003086:	e86a                	sd	s10,16(sp)
    80003088:	e46e                	sd	s11,8(sp)
    8000308a:	1880                	addi	s0,sp,112
    8000308c:	8b2a                	mv	s6,a0
    8000308e:	8c2e                	mv	s8,a1
    80003090:	8ab2                	mv	s5,a2
    80003092:	8936                	mv	s2,a3
    80003094:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003096:	00e687bb          	addw	a5,a3,a4
    8000309a:	0ed7e263          	bltu	a5,a3,8000317e <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000309e:	00043737          	lui	a4,0x43
    800030a2:	0ef76063          	bltu	a4,a5,80003182 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030a6:	0c0b8863          	beqz	s7,80003176 <writei+0x10e>
    800030aa:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800030ac:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800030b0:	5cfd                	li	s9,-1
    800030b2:	a091                	j	800030f6 <writei+0x8e>
    800030b4:	02099d93          	slli	s11,s3,0x20
    800030b8:	020ddd93          	srli	s11,s11,0x20
    800030bc:	06048513          	addi	a0,s1,96
    800030c0:	86ee                	mv	a3,s11
    800030c2:	8656                	mv	a2,s5
    800030c4:	85e2                	mv	a1,s8
    800030c6:	953a                	add	a0,a0,a4
    800030c8:	fffff097          	auipc	ra,0xfffff
    800030cc:	95e080e7          	jalr	-1698(ra) # 80001a26 <either_copyin>
    800030d0:	07950263          	beq	a0,s9,80003134 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800030d4:	8526                	mv	a0,s1
    800030d6:	00000097          	auipc	ra,0x0
    800030da:	790080e7          	jalr	1936(ra) # 80003866 <log_write>
    brelse(bp);
    800030de:	8526                	mv	a0,s1
    800030e0:	fffff097          	auipc	ra,0xfffff
    800030e4:	4c6080e7          	jalr	1222(ra) # 800025a6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030e8:	01498a3b          	addw	s4,s3,s4
    800030ec:	0129893b          	addw	s2,s3,s2
    800030f0:	9aee                	add	s5,s5,s11
    800030f2:	057a7663          	bgeu	s4,s7,8000313e <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800030f6:	000b2483          	lw	s1,0(s6)
    800030fa:	00a9559b          	srliw	a1,s2,0xa
    800030fe:	855a                	mv	a0,s6
    80003100:	fffff097          	auipc	ra,0xfffff
    80003104:	7ae080e7          	jalr	1966(ra) # 800028ae <bmap>
    80003108:	0005059b          	sext.w	a1,a0
    8000310c:	8526                	mv	a0,s1
    8000310e:	fffff097          	auipc	ra,0xfffff
    80003112:	2b6080e7          	jalr	694(ra) # 800023c4 <bread>
    80003116:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003118:	3ff97713          	andi	a4,s2,1023
    8000311c:	40ed07bb          	subw	a5,s10,a4
    80003120:	414b86bb          	subw	a3,s7,s4
    80003124:	89be                	mv	s3,a5
    80003126:	2781                	sext.w	a5,a5
    80003128:	0006861b          	sext.w	a2,a3
    8000312c:	f8f674e3          	bgeu	a2,a5,800030b4 <writei+0x4c>
    80003130:	89b6                	mv	s3,a3
    80003132:	b749                	j	800030b4 <writei+0x4c>
      brelse(bp);
    80003134:	8526                	mv	a0,s1
    80003136:	fffff097          	auipc	ra,0xfffff
    8000313a:	470080e7          	jalr	1136(ra) # 800025a6 <brelse>
  }

  if(off > ip->size)
    8000313e:	054b2783          	lw	a5,84(s6)
    80003142:	0127f463          	bgeu	a5,s2,8000314a <writei+0xe2>
    ip->size = off;
    80003146:	052b2a23          	sw	s2,84(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000314a:	855a                	mv	a0,s6
    8000314c:	00000097          	auipc	ra,0x0
    80003150:	aa6080e7          	jalr	-1370(ra) # 80002bf2 <iupdate>

  return tot;
    80003154:	000a051b          	sext.w	a0,s4
}
    80003158:	70a6                	ld	ra,104(sp)
    8000315a:	7406                	ld	s0,96(sp)
    8000315c:	64e6                	ld	s1,88(sp)
    8000315e:	6946                	ld	s2,80(sp)
    80003160:	69a6                	ld	s3,72(sp)
    80003162:	6a06                	ld	s4,64(sp)
    80003164:	7ae2                	ld	s5,56(sp)
    80003166:	7b42                	ld	s6,48(sp)
    80003168:	7ba2                	ld	s7,40(sp)
    8000316a:	7c02                	ld	s8,32(sp)
    8000316c:	6ce2                	ld	s9,24(sp)
    8000316e:	6d42                	ld	s10,16(sp)
    80003170:	6da2                	ld	s11,8(sp)
    80003172:	6165                	addi	sp,sp,112
    80003174:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003176:	8a5e                	mv	s4,s7
    80003178:	bfc9                	j	8000314a <writei+0xe2>
    return -1;
    8000317a:	557d                	li	a0,-1
}
    8000317c:	8082                	ret
    return -1;
    8000317e:	557d                	li	a0,-1
    80003180:	bfe1                	j	80003158 <writei+0xf0>
    return -1;
    80003182:	557d                	li	a0,-1
    80003184:	bfd1                	j	80003158 <writei+0xf0>

0000000080003186 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003186:	1141                	addi	sp,sp,-16
    80003188:	e406                	sd	ra,8(sp)
    8000318a:	e022                	sd	s0,0(sp)
    8000318c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000318e:	4639                	li	a2,14
    80003190:	ffffd097          	auipc	ra,0xffffd
    80003194:	1d8080e7          	jalr	472(ra) # 80000368 <strncmp>
}
    80003198:	60a2                	ld	ra,8(sp)
    8000319a:	6402                	ld	s0,0(sp)
    8000319c:	0141                	addi	sp,sp,16
    8000319e:	8082                	ret

00000000800031a0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800031a0:	7139                	addi	sp,sp,-64
    800031a2:	fc06                	sd	ra,56(sp)
    800031a4:	f822                	sd	s0,48(sp)
    800031a6:	f426                	sd	s1,40(sp)
    800031a8:	f04a                	sd	s2,32(sp)
    800031aa:	ec4e                	sd	s3,24(sp)
    800031ac:	e852                	sd	s4,16(sp)
    800031ae:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800031b0:	04c51703          	lh	a4,76(a0)
    800031b4:	4785                	li	a5,1
    800031b6:	00f71a63          	bne	a4,a5,800031ca <dirlookup+0x2a>
    800031ba:	892a                	mv	s2,a0
    800031bc:	89ae                	mv	s3,a1
    800031be:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800031c0:	497c                	lw	a5,84(a0)
    800031c2:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800031c4:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031c6:	e79d                	bnez	a5,800031f4 <dirlookup+0x54>
    800031c8:	a8a5                	j	80003240 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800031ca:	00005517          	auipc	a0,0x5
    800031ce:	39650513          	addi	a0,a0,918 # 80008560 <syscalls+0x188>
    800031d2:	00003097          	auipc	ra,0x3
    800031d6:	eda080e7          	jalr	-294(ra) # 800060ac <panic>
      panic("dirlookup read");
    800031da:	00005517          	auipc	a0,0x5
    800031de:	39e50513          	addi	a0,a0,926 # 80008578 <syscalls+0x1a0>
    800031e2:	00003097          	auipc	ra,0x3
    800031e6:	eca080e7          	jalr	-310(ra) # 800060ac <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031ea:	24c1                	addiw	s1,s1,16
    800031ec:	05492783          	lw	a5,84(s2)
    800031f0:	04f4f763          	bgeu	s1,a5,8000323e <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031f4:	4741                	li	a4,16
    800031f6:	86a6                	mv	a3,s1
    800031f8:	fc040613          	addi	a2,s0,-64
    800031fc:	4581                	li	a1,0
    800031fe:	854a                	mv	a0,s2
    80003200:	00000097          	auipc	ra,0x0
    80003204:	d70080e7          	jalr	-656(ra) # 80002f70 <readi>
    80003208:	47c1                	li	a5,16
    8000320a:	fcf518e3          	bne	a0,a5,800031da <dirlookup+0x3a>
    if(de.inum == 0)
    8000320e:	fc045783          	lhu	a5,-64(s0)
    80003212:	dfe1                	beqz	a5,800031ea <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003214:	fc240593          	addi	a1,s0,-62
    80003218:	854e                	mv	a0,s3
    8000321a:	00000097          	auipc	ra,0x0
    8000321e:	f6c080e7          	jalr	-148(ra) # 80003186 <namecmp>
    80003222:	f561                	bnez	a0,800031ea <dirlookup+0x4a>
      if(poff)
    80003224:	000a0463          	beqz	s4,8000322c <dirlookup+0x8c>
        *poff = off;
    80003228:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000322c:	fc045583          	lhu	a1,-64(s0)
    80003230:	00092503          	lw	a0,0(s2)
    80003234:	fffff097          	auipc	ra,0xfffff
    80003238:	754080e7          	jalr	1876(ra) # 80002988 <iget>
    8000323c:	a011                	j	80003240 <dirlookup+0xa0>
  return 0;
    8000323e:	4501                	li	a0,0
}
    80003240:	70e2                	ld	ra,56(sp)
    80003242:	7442                	ld	s0,48(sp)
    80003244:	74a2                	ld	s1,40(sp)
    80003246:	7902                	ld	s2,32(sp)
    80003248:	69e2                	ld	s3,24(sp)
    8000324a:	6a42                	ld	s4,16(sp)
    8000324c:	6121                	addi	sp,sp,64
    8000324e:	8082                	ret

0000000080003250 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003250:	711d                	addi	sp,sp,-96
    80003252:	ec86                	sd	ra,88(sp)
    80003254:	e8a2                	sd	s0,80(sp)
    80003256:	e4a6                	sd	s1,72(sp)
    80003258:	e0ca                	sd	s2,64(sp)
    8000325a:	fc4e                	sd	s3,56(sp)
    8000325c:	f852                	sd	s4,48(sp)
    8000325e:	f456                	sd	s5,40(sp)
    80003260:	f05a                	sd	s6,32(sp)
    80003262:	ec5e                	sd	s7,24(sp)
    80003264:	e862                	sd	s8,16(sp)
    80003266:	e466                	sd	s9,8(sp)
    80003268:	1080                	addi	s0,sp,96
    8000326a:	84aa                	mv	s1,a0
    8000326c:	8b2e                	mv	s6,a1
    8000326e:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003270:	00054703          	lbu	a4,0(a0)
    80003274:	02f00793          	li	a5,47
    80003278:	02f70363          	beq	a4,a5,8000329e <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000327c:	ffffe097          	auipc	ra,0xffffe
    80003280:	cf4080e7          	jalr	-780(ra) # 80000f70 <myproc>
    80003284:	15853503          	ld	a0,344(a0)
    80003288:	00000097          	auipc	ra,0x0
    8000328c:	9f6080e7          	jalr	-1546(ra) # 80002c7e <idup>
    80003290:	89aa                	mv	s3,a0
  while(*path == '/')
    80003292:	02f00913          	li	s2,47
  len = path - s;
    80003296:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003298:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000329a:	4c05                	li	s8,1
    8000329c:	a865                	j	80003354 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    8000329e:	4585                	li	a1,1
    800032a0:	4505                	li	a0,1
    800032a2:	fffff097          	auipc	ra,0xfffff
    800032a6:	6e6080e7          	jalr	1766(ra) # 80002988 <iget>
    800032aa:	89aa                	mv	s3,a0
    800032ac:	b7dd                	j	80003292 <namex+0x42>
      iunlockput(ip);
    800032ae:	854e                	mv	a0,s3
    800032b0:	00000097          	auipc	ra,0x0
    800032b4:	c6e080e7          	jalr	-914(ra) # 80002f1e <iunlockput>
      return 0;
    800032b8:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800032ba:	854e                	mv	a0,s3
    800032bc:	60e6                	ld	ra,88(sp)
    800032be:	6446                	ld	s0,80(sp)
    800032c0:	64a6                	ld	s1,72(sp)
    800032c2:	6906                	ld	s2,64(sp)
    800032c4:	79e2                	ld	s3,56(sp)
    800032c6:	7a42                	ld	s4,48(sp)
    800032c8:	7aa2                	ld	s5,40(sp)
    800032ca:	7b02                	ld	s6,32(sp)
    800032cc:	6be2                	ld	s7,24(sp)
    800032ce:	6c42                	ld	s8,16(sp)
    800032d0:	6ca2                	ld	s9,8(sp)
    800032d2:	6125                	addi	sp,sp,96
    800032d4:	8082                	ret
      iunlock(ip);
    800032d6:	854e                	mv	a0,s3
    800032d8:	00000097          	auipc	ra,0x0
    800032dc:	aa6080e7          	jalr	-1370(ra) # 80002d7e <iunlock>
      return ip;
    800032e0:	bfe9                	j	800032ba <namex+0x6a>
      iunlockput(ip);
    800032e2:	854e                	mv	a0,s3
    800032e4:	00000097          	auipc	ra,0x0
    800032e8:	c3a080e7          	jalr	-966(ra) # 80002f1e <iunlockput>
      return 0;
    800032ec:	89d2                	mv	s3,s4
    800032ee:	b7f1                	j	800032ba <namex+0x6a>
  len = path - s;
    800032f0:	40b48633          	sub	a2,s1,a1
    800032f4:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800032f8:	094cd463          	bge	s9,s4,80003380 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800032fc:	4639                	li	a2,14
    800032fe:	8556                	mv	a0,s5
    80003300:	ffffd097          	auipc	ra,0xffffd
    80003304:	ff0080e7          	jalr	-16(ra) # 800002f0 <memmove>
  while(*path == '/')
    80003308:	0004c783          	lbu	a5,0(s1)
    8000330c:	01279763          	bne	a5,s2,8000331a <namex+0xca>
    path++;
    80003310:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003312:	0004c783          	lbu	a5,0(s1)
    80003316:	ff278de3          	beq	a5,s2,80003310 <namex+0xc0>
    ilock(ip);
    8000331a:	854e                	mv	a0,s3
    8000331c:	00000097          	auipc	ra,0x0
    80003320:	9a0080e7          	jalr	-1632(ra) # 80002cbc <ilock>
    if(ip->type != T_DIR){
    80003324:	04c99783          	lh	a5,76(s3)
    80003328:	f98793e3          	bne	a5,s8,800032ae <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000332c:	000b0563          	beqz	s6,80003336 <namex+0xe6>
    80003330:	0004c783          	lbu	a5,0(s1)
    80003334:	d3cd                	beqz	a5,800032d6 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003336:	865e                	mv	a2,s7
    80003338:	85d6                	mv	a1,s5
    8000333a:	854e                	mv	a0,s3
    8000333c:	00000097          	auipc	ra,0x0
    80003340:	e64080e7          	jalr	-412(ra) # 800031a0 <dirlookup>
    80003344:	8a2a                	mv	s4,a0
    80003346:	dd51                	beqz	a0,800032e2 <namex+0x92>
    iunlockput(ip);
    80003348:	854e                	mv	a0,s3
    8000334a:	00000097          	auipc	ra,0x0
    8000334e:	bd4080e7          	jalr	-1068(ra) # 80002f1e <iunlockput>
    ip = next;
    80003352:	89d2                	mv	s3,s4
  while(*path == '/')
    80003354:	0004c783          	lbu	a5,0(s1)
    80003358:	05279763          	bne	a5,s2,800033a6 <namex+0x156>
    path++;
    8000335c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000335e:	0004c783          	lbu	a5,0(s1)
    80003362:	ff278de3          	beq	a5,s2,8000335c <namex+0x10c>
  if(*path == 0)
    80003366:	c79d                	beqz	a5,80003394 <namex+0x144>
    path++;
    80003368:	85a6                	mv	a1,s1
  len = path - s;
    8000336a:	8a5e                	mv	s4,s7
    8000336c:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000336e:	01278963          	beq	a5,s2,80003380 <namex+0x130>
    80003372:	dfbd                	beqz	a5,800032f0 <namex+0xa0>
    path++;
    80003374:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003376:	0004c783          	lbu	a5,0(s1)
    8000337a:	ff279ce3          	bne	a5,s2,80003372 <namex+0x122>
    8000337e:	bf8d                	j	800032f0 <namex+0xa0>
    memmove(name, s, len);
    80003380:	2601                	sext.w	a2,a2
    80003382:	8556                	mv	a0,s5
    80003384:	ffffd097          	auipc	ra,0xffffd
    80003388:	f6c080e7          	jalr	-148(ra) # 800002f0 <memmove>
    name[len] = 0;
    8000338c:	9a56                	add	s4,s4,s5
    8000338e:	000a0023          	sb	zero,0(s4)
    80003392:	bf9d                	j	80003308 <namex+0xb8>
  if(nameiparent){
    80003394:	f20b03e3          	beqz	s6,800032ba <namex+0x6a>
    iput(ip);
    80003398:	854e                	mv	a0,s3
    8000339a:	00000097          	auipc	ra,0x0
    8000339e:	adc080e7          	jalr	-1316(ra) # 80002e76 <iput>
    return 0;
    800033a2:	4981                	li	s3,0
    800033a4:	bf19                	j	800032ba <namex+0x6a>
  if(*path == 0)
    800033a6:	d7fd                	beqz	a5,80003394 <namex+0x144>
  while(*path != '/' && *path != 0)
    800033a8:	0004c783          	lbu	a5,0(s1)
    800033ac:	85a6                	mv	a1,s1
    800033ae:	b7d1                	j	80003372 <namex+0x122>

00000000800033b0 <dirlink>:
{
    800033b0:	7139                	addi	sp,sp,-64
    800033b2:	fc06                	sd	ra,56(sp)
    800033b4:	f822                	sd	s0,48(sp)
    800033b6:	f426                	sd	s1,40(sp)
    800033b8:	f04a                	sd	s2,32(sp)
    800033ba:	ec4e                	sd	s3,24(sp)
    800033bc:	e852                	sd	s4,16(sp)
    800033be:	0080                	addi	s0,sp,64
    800033c0:	892a                	mv	s2,a0
    800033c2:	8a2e                	mv	s4,a1
    800033c4:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800033c6:	4601                	li	a2,0
    800033c8:	00000097          	auipc	ra,0x0
    800033cc:	dd8080e7          	jalr	-552(ra) # 800031a0 <dirlookup>
    800033d0:	e93d                	bnez	a0,80003446 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033d2:	05492483          	lw	s1,84(s2)
    800033d6:	c49d                	beqz	s1,80003404 <dirlink+0x54>
    800033d8:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033da:	4741                	li	a4,16
    800033dc:	86a6                	mv	a3,s1
    800033de:	fc040613          	addi	a2,s0,-64
    800033e2:	4581                	li	a1,0
    800033e4:	854a                	mv	a0,s2
    800033e6:	00000097          	auipc	ra,0x0
    800033ea:	b8a080e7          	jalr	-1142(ra) # 80002f70 <readi>
    800033ee:	47c1                	li	a5,16
    800033f0:	06f51163          	bne	a0,a5,80003452 <dirlink+0xa2>
    if(de.inum == 0)
    800033f4:	fc045783          	lhu	a5,-64(s0)
    800033f8:	c791                	beqz	a5,80003404 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033fa:	24c1                	addiw	s1,s1,16
    800033fc:	05492783          	lw	a5,84(s2)
    80003400:	fcf4ede3          	bltu	s1,a5,800033da <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003404:	4639                	li	a2,14
    80003406:	85d2                	mv	a1,s4
    80003408:	fc240513          	addi	a0,s0,-62
    8000340c:	ffffd097          	auipc	ra,0xffffd
    80003410:	f98080e7          	jalr	-104(ra) # 800003a4 <strncpy>
  de.inum = inum;
    80003414:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003418:	4741                	li	a4,16
    8000341a:	86a6                	mv	a3,s1
    8000341c:	fc040613          	addi	a2,s0,-64
    80003420:	4581                	li	a1,0
    80003422:	854a                	mv	a0,s2
    80003424:	00000097          	auipc	ra,0x0
    80003428:	c44080e7          	jalr	-956(ra) # 80003068 <writei>
    8000342c:	872a                	mv	a4,a0
    8000342e:	47c1                	li	a5,16
  return 0;
    80003430:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003432:	02f71863          	bne	a4,a5,80003462 <dirlink+0xb2>
}
    80003436:	70e2                	ld	ra,56(sp)
    80003438:	7442                	ld	s0,48(sp)
    8000343a:	74a2                	ld	s1,40(sp)
    8000343c:	7902                	ld	s2,32(sp)
    8000343e:	69e2                	ld	s3,24(sp)
    80003440:	6a42                	ld	s4,16(sp)
    80003442:	6121                	addi	sp,sp,64
    80003444:	8082                	ret
    iput(ip);
    80003446:	00000097          	auipc	ra,0x0
    8000344a:	a30080e7          	jalr	-1488(ra) # 80002e76 <iput>
    return -1;
    8000344e:	557d                	li	a0,-1
    80003450:	b7dd                	j	80003436 <dirlink+0x86>
      panic("dirlink read");
    80003452:	00005517          	auipc	a0,0x5
    80003456:	13650513          	addi	a0,a0,310 # 80008588 <syscalls+0x1b0>
    8000345a:	00003097          	auipc	ra,0x3
    8000345e:	c52080e7          	jalr	-942(ra) # 800060ac <panic>
    panic("dirlink");
    80003462:	00005517          	auipc	a0,0x5
    80003466:	23650513          	addi	a0,a0,566 # 80008698 <syscalls+0x2c0>
    8000346a:	00003097          	auipc	ra,0x3
    8000346e:	c42080e7          	jalr	-958(ra) # 800060ac <panic>

0000000080003472 <namei>:

struct inode*
namei(char *path)
{
    80003472:	1101                	addi	sp,sp,-32
    80003474:	ec06                	sd	ra,24(sp)
    80003476:	e822                	sd	s0,16(sp)
    80003478:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000347a:	fe040613          	addi	a2,s0,-32
    8000347e:	4581                	li	a1,0
    80003480:	00000097          	auipc	ra,0x0
    80003484:	dd0080e7          	jalr	-560(ra) # 80003250 <namex>
}
    80003488:	60e2                	ld	ra,24(sp)
    8000348a:	6442                	ld	s0,16(sp)
    8000348c:	6105                	addi	sp,sp,32
    8000348e:	8082                	ret

0000000080003490 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003490:	1141                	addi	sp,sp,-16
    80003492:	e406                	sd	ra,8(sp)
    80003494:	e022                	sd	s0,0(sp)
    80003496:	0800                	addi	s0,sp,16
    80003498:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000349a:	4585                	li	a1,1
    8000349c:	00000097          	auipc	ra,0x0
    800034a0:	db4080e7          	jalr	-588(ra) # 80003250 <namex>
}
    800034a4:	60a2                	ld	ra,8(sp)
    800034a6:	6402                	ld	s0,0(sp)
    800034a8:	0141                	addi	sp,sp,16
    800034aa:	8082                	ret

00000000800034ac <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800034ac:	1101                	addi	sp,sp,-32
    800034ae:	ec06                	sd	ra,24(sp)
    800034b0:	e822                	sd	s0,16(sp)
    800034b2:	e426                	sd	s1,8(sp)
    800034b4:	e04a                	sd	s2,0(sp)
    800034b6:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800034b8:	00019917          	auipc	s2,0x19
    800034bc:	73890913          	addi	s2,s2,1848 # 8001cbf0 <log>
    800034c0:	02092583          	lw	a1,32(s2)
    800034c4:	03092503          	lw	a0,48(s2)
    800034c8:	fffff097          	auipc	ra,0xfffff
    800034cc:	efc080e7          	jalr	-260(ra) # 800023c4 <bread>
    800034d0:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800034d2:	03492683          	lw	a3,52(s2)
    800034d6:	d134                	sw	a3,96(a0)
  for (i = 0; i < log.lh.n; i++) {
    800034d8:	02d05763          	blez	a3,80003506 <write_head+0x5a>
    800034dc:	00019797          	auipc	a5,0x19
    800034e0:	74c78793          	addi	a5,a5,1868 # 8001cc28 <log+0x38>
    800034e4:	06450713          	addi	a4,a0,100
    800034e8:	36fd                	addiw	a3,a3,-1
    800034ea:	1682                	slli	a3,a3,0x20
    800034ec:	9281                	srli	a3,a3,0x20
    800034ee:	068a                	slli	a3,a3,0x2
    800034f0:	00019617          	auipc	a2,0x19
    800034f4:	73c60613          	addi	a2,a2,1852 # 8001cc2c <log+0x3c>
    800034f8:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800034fa:	4390                	lw	a2,0(a5)
    800034fc:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034fe:	0791                	addi	a5,a5,4
    80003500:	0711                	addi	a4,a4,4
    80003502:	fed79ce3          	bne	a5,a3,800034fa <write_head+0x4e>
  }
  bwrite(buf);
    80003506:	8526                	mv	a0,s1
    80003508:	fffff097          	auipc	ra,0xfffff
    8000350c:	060080e7          	jalr	96(ra) # 80002568 <bwrite>
  brelse(buf);
    80003510:	8526                	mv	a0,s1
    80003512:	fffff097          	auipc	ra,0xfffff
    80003516:	094080e7          	jalr	148(ra) # 800025a6 <brelse>
}
    8000351a:	60e2                	ld	ra,24(sp)
    8000351c:	6442                	ld	s0,16(sp)
    8000351e:	64a2                	ld	s1,8(sp)
    80003520:	6902                	ld	s2,0(sp)
    80003522:	6105                	addi	sp,sp,32
    80003524:	8082                	ret

0000000080003526 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003526:	00019797          	auipc	a5,0x19
    8000352a:	6fe7a783          	lw	a5,1790(a5) # 8001cc24 <log+0x34>
    8000352e:	0af05d63          	blez	a5,800035e8 <install_trans+0xc2>
{
    80003532:	7139                	addi	sp,sp,-64
    80003534:	fc06                	sd	ra,56(sp)
    80003536:	f822                	sd	s0,48(sp)
    80003538:	f426                	sd	s1,40(sp)
    8000353a:	f04a                	sd	s2,32(sp)
    8000353c:	ec4e                	sd	s3,24(sp)
    8000353e:	e852                	sd	s4,16(sp)
    80003540:	e456                	sd	s5,8(sp)
    80003542:	e05a                	sd	s6,0(sp)
    80003544:	0080                	addi	s0,sp,64
    80003546:	8b2a                	mv	s6,a0
    80003548:	00019a97          	auipc	s5,0x19
    8000354c:	6e0a8a93          	addi	s5,s5,1760 # 8001cc28 <log+0x38>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003550:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003552:	00019997          	auipc	s3,0x19
    80003556:	69e98993          	addi	s3,s3,1694 # 8001cbf0 <log>
    8000355a:	a035                	j	80003586 <install_trans+0x60>
      bunpin(dbuf);
    8000355c:	8526                	mv	a0,s1
    8000355e:	fffff097          	auipc	ra,0xfffff
    80003562:	156080e7          	jalr	342(ra) # 800026b4 <bunpin>
    brelse(lbuf);
    80003566:	854a                	mv	a0,s2
    80003568:	fffff097          	auipc	ra,0xfffff
    8000356c:	03e080e7          	jalr	62(ra) # 800025a6 <brelse>
    brelse(dbuf);
    80003570:	8526                	mv	a0,s1
    80003572:	fffff097          	auipc	ra,0xfffff
    80003576:	034080e7          	jalr	52(ra) # 800025a6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000357a:	2a05                	addiw	s4,s4,1
    8000357c:	0a91                	addi	s5,s5,4
    8000357e:	0349a783          	lw	a5,52(s3)
    80003582:	04fa5963          	bge	s4,a5,800035d4 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003586:	0209a583          	lw	a1,32(s3)
    8000358a:	014585bb          	addw	a1,a1,s4
    8000358e:	2585                	addiw	a1,a1,1
    80003590:	0309a503          	lw	a0,48(s3)
    80003594:	fffff097          	auipc	ra,0xfffff
    80003598:	e30080e7          	jalr	-464(ra) # 800023c4 <bread>
    8000359c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000359e:	000aa583          	lw	a1,0(s5)
    800035a2:	0309a503          	lw	a0,48(s3)
    800035a6:	fffff097          	auipc	ra,0xfffff
    800035aa:	e1e080e7          	jalr	-482(ra) # 800023c4 <bread>
    800035ae:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800035b0:	40000613          	li	a2,1024
    800035b4:	06090593          	addi	a1,s2,96
    800035b8:	06050513          	addi	a0,a0,96
    800035bc:	ffffd097          	auipc	ra,0xffffd
    800035c0:	d34080e7          	jalr	-716(ra) # 800002f0 <memmove>
    bwrite(dbuf);  // write dst to disk
    800035c4:	8526                	mv	a0,s1
    800035c6:	fffff097          	auipc	ra,0xfffff
    800035ca:	fa2080e7          	jalr	-94(ra) # 80002568 <bwrite>
    if(recovering == 0)
    800035ce:	f80b1ce3          	bnez	s6,80003566 <install_trans+0x40>
    800035d2:	b769                	j	8000355c <install_trans+0x36>
}
    800035d4:	70e2                	ld	ra,56(sp)
    800035d6:	7442                	ld	s0,48(sp)
    800035d8:	74a2                	ld	s1,40(sp)
    800035da:	7902                	ld	s2,32(sp)
    800035dc:	69e2                	ld	s3,24(sp)
    800035de:	6a42                	ld	s4,16(sp)
    800035e0:	6aa2                	ld	s5,8(sp)
    800035e2:	6b02                	ld	s6,0(sp)
    800035e4:	6121                	addi	sp,sp,64
    800035e6:	8082                	ret
    800035e8:	8082                	ret

00000000800035ea <initlog>:
{
    800035ea:	7179                	addi	sp,sp,-48
    800035ec:	f406                	sd	ra,40(sp)
    800035ee:	f022                	sd	s0,32(sp)
    800035f0:	ec26                	sd	s1,24(sp)
    800035f2:	e84a                	sd	s2,16(sp)
    800035f4:	e44e                	sd	s3,8(sp)
    800035f6:	1800                	addi	s0,sp,48
    800035f8:	892a                	mv	s2,a0
    800035fa:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800035fc:	00019497          	auipc	s1,0x19
    80003600:	5f448493          	addi	s1,s1,1524 # 8001cbf0 <log>
    80003604:	00005597          	auipc	a1,0x5
    80003608:	f9458593          	addi	a1,a1,-108 # 80008598 <syscalls+0x1c0>
    8000360c:	8526                	mv	a0,s1
    8000360e:	00003097          	auipc	ra,0x3
    80003612:	14e080e7          	jalr	334(ra) # 8000675c <initlock>
  log.start = sb->logstart;
    80003616:	0149a583          	lw	a1,20(s3)
    8000361a:	d08c                	sw	a1,32(s1)
  log.size = sb->nlog;
    8000361c:	0109a783          	lw	a5,16(s3)
    80003620:	d0dc                	sw	a5,36(s1)
  log.dev = dev;
    80003622:	0324a823          	sw	s2,48(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003626:	854a                	mv	a0,s2
    80003628:	fffff097          	auipc	ra,0xfffff
    8000362c:	d9c080e7          	jalr	-612(ra) # 800023c4 <bread>
  log.lh.n = lh->n;
    80003630:	513c                	lw	a5,96(a0)
    80003632:	d8dc                	sw	a5,52(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003634:	02f05563          	blez	a5,8000365e <initlog+0x74>
    80003638:	06450713          	addi	a4,a0,100
    8000363c:	00019697          	auipc	a3,0x19
    80003640:	5ec68693          	addi	a3,a3,1516 # 8001cc28 <log+0x38>
    80003644:	37fd                	addiw	a5,a5,-1
    80003646:	1782                	slli	a5,a5,0x20
    80003648:	9381                	srli	a5,a5,0x20
    8000364a:	078a                	slli	a5,a5,0x2
    8000364c:	06850613          	addi	a2,a0,104
    80003650:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003652:	4310                	lw	a2,0(a4)
    80003654:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003656:	0711                	addi	a4,a4,4
    80003658:	0691                	addi	a3,a3,4
    8000365a:	fef71ce3          	bne	a4,a5,80003652 <initlog+0x68>
  brelse(buf);
    8000365e:	fffff097          	auipc	ra,0xfffff
    80003662:	f48080e7          	jalr	-184(ra) # 800025a6 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003666:	4505                	li	a0,1
    80003668:	00000097          	auipc	ra,0x0
    8000366c:	ebe080e7          	jalr	-322(ra) # 80003526 <install_trans>
  log.lh.n = 0;
    80003670:	00019797          	auipc	a5,0x19
    80003674:	5a07aa23          	sw	zero,1460(a5) # 8001cc24 <log+0x34>
  write_head(); // clear the log
    80003678:	00000097          	auipc	ra,0x0
    8000367c:	e34080e7          	jalr	-460(ra) # 800034ac <write_head>
}
    80003680:	70a2                	ld	ra,40(sp)
    80003682:	7402                	ld	s0,32(sp)
    80003684:	64e2                	ld	s1,24(sp)
    80003686:	6942                	ld	s2,16(sp)
    80003688:	69a2                	ld	s3,8(sp)
    8000368a:	6145                	addi	sp,sp,48
    8000368c:	8082                	ret

000000008000368e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000368e:	1101                	addi	sp,sp,-32
    80003690:	ec06                	sd	ra,24(sp)
    80003692:	e822                	sd	s0,16(sp)
    80003694:	e426                	sd	s1,8(sp)
    80003696:	e04a                	sd	s2,0(sp)
    80003698:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000369a:	00019517          	auipc	a0,0x19
    8000369e:	55650513          	addi	a0,a0,1366 # 8001cbf0 <log>
    800036a2:	00003097          	auipc	ra,0x3
    800036a6:	f3e080e7          	jalr	-194(ra) # 800065e0 <acquire>
  while(1){
    if(log.committing){
    800036aa:	00019497          	auipc	s1,0x19
    800036ae:	54648493          	addi	s1,s1,1350 # 8001cbf0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036b2:	4979                	li	s2,30
    800036b4:	a039                	j	800036c2 <begin_op+0x34>
      sleep(&log, &log.lock);
    800036b6:	85a6                	mv	a1,s1
    800036b8:	8526                	mv	a0,s1
    800036ba:	ffffe097          	auipc	ra,0xffffe
    800036be:	f72080e7          	jalr	-142(ra) # 8000162c <sleep>
    if(log.committing){
    800036c2:	54dc                	lw	a5,44(s1)
    800036c4:	fbed                	bnez	a5,800036b6 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036c6:	549c                	lw	a5,40(s1)
    800036c8:	0017871b          	addiw	a4,a5,1
    800036cc:	0007069b          	sext.w	a3,a4
    800036d0:	0027179b          	slliw	a5,a4,0x2
    800036d4:	9fb9                	addw	a5,a5,a4
    800036d6:	0017979b          	slliw	a5,a5,0x1
    800036da:	58d8                	lw	a4,52(s1)
    800036dc:	9fb9                	addw	a5,a5,a4
    800036de:	00f95963          	bge	s2,a5,800036f0 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800036e2:	85a6                	mv	a1,s1
    800036e4:	8526                	mv	a0,s1
    800036e6:	ffffe097          	auipc	ra,0xffffe
    800036ea:	f46080e7          	jalr	-186(ra) # 8000162c <sleep>
    800036ee:	bfd1                	j	800036c2 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800036f0:	00019517          	auipc	a0,0x19
    800036f4:	50050513          	addi	a0,a0,1280 # 8001cbf0 <log>
    800036f8:	d514                	sw	a3,40(a0)
      release(&log.lock);
    800036fa:	00003097          	auipc	ra,0x3
    800036fe:	fb6080e7          	jalr	-74(ra) # 800066b0 <release>
      break;
    }
  }
}
    80003702:	60e2                	ld	ra,24(sp)
    80003704:	6442                	ld	s0,16(sp)
    80003706:	64a2                	ld	s1,8(sp)
    80003708:	6902                	ld	s2,0(sp)
    8000370a:	6105                	addi	sp,sp,32
    8000370c:	8082                	ret

000000008000370e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000370e:	7139                	addi	sp,sp,-64
    80003710:	fc06                	sd	ra,56(sp)
    80003712:	f822                	sd	s0,48(sp)
    80003714:	f426                	sd	s1,40(sp)
    80003716:	f04a                	sd	s2,32(sp)
    80003718:	ec4e                	sd	s3,24(sp)
    8000371a:	e852                	sd	s4,16(sp)
    8000371c:	e456                	sd	s5,8(sp)
    8000371e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003720:	00019497          	auipc	s1,0x19
    80003724:	4d048493          	addi	s1,s1,1232 # 8001cbf0 <log>
    80003728:	8526                	mv	a0,s1
    8000372a:	00003097          	auipc	ra,0x3
    8000372e:	eb6080e7          	jalr	-330(ra) # 800065e0 <acquire>
  log.outstanding -= 1;
    80003732:	549c                	lw	a5,40(s1)
    80003734:	37fd                	addiw	a5,a5,-1
    80003736:	0007891b          	sext.w	s2,a5
    8000373a:	d49c                	sw	a5,40(s1)
  if(log.committing)
    8000373c:	54dc                	lw	a5,44(s1)
    8000373e:	efb9                	bnez	a5,8000379c <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003740:	06091663          	bnez	s2,800037ac <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003744:	00019497          	auipc	s1,0x19
    80003748:	4ac48493          	addi	s1,s1,1196 # 8001cbf0 <log>
    8000374c:	4785                	li	a5,1
    8000374e:	d4dc                	sw	a5,44(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003750:	8526                	mv	a0,s1
    80003752:	00003097          	auipc	ra,0x3
    80003756:	f5e080e7          	jalr	-162(ra) # 800066b0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000375a:	58dc                	lw	a5,52(s1)
    8000375c:	06f04763          	bgtz	a5,800037ca <end_op+0xbc>
    acquire(&log.lock);
    80003760:	00019497          	auipc	s1,0x19
    80003764:	49048493          	addi	s1,s1,1168 # 8001cbf0 <log>
    80003768:	8526                	mv	a0,s1
    8000376a:	00003097          	auipc	ra,0x3
    8000376e:	e76080e7          	jalr	-394(ra) # 800065e0 <acquire>
    log.committing = 0;
    80003772:	0204a623          	sw	zero,44(s1)
    wakeup(&log);
    80003776:	8526                	mv	a0,s1
    80003778:	ffffe097          	auipc	ra,0xffffe
    8000377c:	040080e7          	jalr	64(ra) # 800017b8 <wakeup>
    release(&log.lock);
    80003780:	8526                	mv	a0,s1
    80003782:	00003097          	auipc	ra,0x3
    80003786:	f2e080e7          	jalr	-210(ra) # 800066b0 <release>
}
    8000378a:	70e2                	ld	ra,56(sp)
    8000378c:	7442                	ld	s0,48(sp)
    8000378e:	74a2                	ld	s1,40(sp)
    80003790:	7902                	ld	s2,32(sp)
    80003792:	69e2                	ld	s3,24(sp)
    80003794:	6a42                	ld	s4,16(sp)
    80003796:	6aa2                	ld	s5,8(sp)
    80003798:	6121                	addi	sp,sp,64
    8000379a:	8082                	ret
    panic("log.committing");
    8000379c:	00005517          	auipc	a0,0x5
    800037a0:	e0450513          	addi	a0,a0,-508 # 800085a0 <syscalls+0x1c8>
    800037a4:	00003097          	auipc	ra,0x3
    800037a8:	908080e7          	jalr	-1784(ra) # 800060ac <panic>
    wakeup(&log);
    800037ac:	00019497          	auipc	s1,0x19
    800037b0:	44448493          	addi	s1,s1,1092 # 8001cbf0 <log>
    800037b4:	8526                	mv	a0,s1
    800037b6:	ffffe097          	auipc	ra,0xffffe
    800037ba:	002080e7          	jalr	2(ra) # 800017b8 <wakeup>
  release(&log.lock);
    800037be:	8526                	mv	a0,s1
    800037c0:	00003097          	auipc	ra,0x3
    800037c4:	ef0080e7          	jalr	-272(ra) # 800066b0 <release>
  if(do_commit){
    800037c8:	b7c9                	j	8000378a <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037ca:	00019a97          	auipc	s5,0x19
    800037ce:	45ea8a93          	addi	s5,s5,1118 # 8001cc28 <log+0x38>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800037d2:	00019a17          	auipc	s4,0x19
    800037d6:	41ea0a13          	addi	s4,s4,1054 # 8001cbf0 <log>
    800037da:	020a2583          	lw	a1,32(s4)
    800037de:	012585bb          	addw	a1,a1,s2
    800037e2:	2585                	addiw	a1,a1,1
    800037e4:	030a2503          	lw	a0,48(s4)
    800037e8:	fffff097          	auipc	ra,0xfffff
    800037ec:	bdc080e7          	jalr	-1060(ra) # 800023c4 <bread>
    800037f0:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800037f2:	000aa583          	lw	a1,0(s5)
    800037f6:	030a2503          	lw	a0,48(s4)
    800037fa:	fffff097          	auipc	ra,0xfffff
    800037fe:	bca080e7          	jalr	-1078(ra) # 800023c4 <bread>
    80003802:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003804:	40000613          	li	a2,1024
    80003808:	06050593          	addi	a1,a0,96
    8000380c:	06048513          	addi	a0,s1,96
    80003810:	ffffd097          	auipc	ra,0xffffd
    80003814:	ae0080e7          	jalr	-1312(ra) # 800002f0 <memmove>
    bwrite(to);  // write the log
    80003818:	8526                	mv	a0,s1
    8000381a:	fffff097          	auipc	ra,0xfffff
    8000381e:	d4e080e7          	jalr	-690(ra) # 80002568 <bwrite>
    brelse(from);
    80003822:	854e                	mv	a0,s3
    80003824:	fffff097          	auipc	ra,0xfffff
    80003828:	d82080e7          	jalr	-638(ra) # 800025a6 <brelse>
    brelse(to);
    8000382c:	8526                	mv	a0,s1
    8000382e:	fffff097          	auipc	ra,0xfffff
    80003832:	d78080e7          	jalr	-648(ra) # 800025a6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003836:	2905                	addiw	s2,s2,1
    80003838:	0a91                	addi	s5,s5,4
    8000383a:	034a2783          	lw	a5,52(s4)
    8000383e:	f8f94ee3          	blt	s2,a5,800037da <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003842:	00000097          	auipc	ra,0x0
    80003846:	c6a080e7          	jalr	-918(ra) # 800034ac <write_head>
    install_trans(0); // Now install writes to home locations
    8000384a:	4501                	li	a0,0
    8000384c:	00000097          	auipc	ra,0x0
    80003850:	cda080e7          	jalr	-806(ra) # 80003526 <install_trans>
    log.lh.n = 0;
    80003854:	00019797          	auipc	a5,0x19
    80003858:	3c07a823          	sw	zero,976(a5) # 8001cc24 <log+0x34>
    write_head();    // Erase the transaction from the log
    8000385c:	00000097          	auipc	ra,0x0
    80003860:	c50080e7          	jalr	-944(ra) # 800034ac <write_head>
    80003864:	bdf5                	j	80003760 <end_op+0x52>

0000000080003866 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003866:	1101                	addi	sp,sp,-32
    80003868:	ec06                	sd	ra,24(sp)
    8000386a:	e822                	sd	s0,16(sp)
    8000386c:	e426                	sd	s1,8(sp)
    8000386e:	e04a                	sd	s2,0(sp)
    80003870:	1000                	addi	s0,sp,32
    80003872:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003874:	00019917          	auipc	s2,0x19
    80003878:	37c90913          	addi	s2,s2,892 # 8001cbf0 <log>
    8000387c:	854a                	mv	a0,s2
    8000387e:	00003097          	auipc	ra,0x3
    80003882:	d62080e7          	jalr	-670(ra) # 800065e0 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003886:	03492603          	lw	a2,52(s2)
    8000388a:	47f5                	li	a5,29
    8000388c:	06c7c563          	blt	a5,a2,800038f6 <log_write+0x90>
    80003890:	00019797          	auipc	a5,0x19
    80003894:	3847a783          	lw	a5,900(a5) # 8001cc14 <log+0x24>
    80003898:	37fd                	addiw	a5,a5,-1
    8000389a:	04f65e63          	bge	a2,a5,800038f6 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000389e:	00019797          	auipc	a5,0x19
    800038a2:	37a7a783          	lw	a5,890(a5) # 8001cc18 <log+0x28>
    800038a6:	06f05063          	blez	a5,80003906 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800038aa:	4781                	li	a5,0
    800038ac:	06c05563          	blez	a2,80003916 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038b0:	44cc                	lw	a1,12(s1)
    800038b2:	00019717          	auipc	a4,0x19
    800038b6:	37670713          	addi	a4,a4,886 # 8001cc28 <log+0x38>
  for (i = 0; i < log.lh.n; i++) {
    800038ba:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038bc:	4314                	lw	a3,0(a4)
    800038be:	04b68c63          	beq	a3,a1,80003916 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800038c2:	2785                	addiw	a5,a5,1
    800038c4:	0711                	addi	a4,a4,4
    800038c6:	fef61be3          	bne	a2,a5,800038bc <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800038ca:	0631                	addi	a2,a2,12
    800038cc:	060a                	slli	a2,a2,0x2
    800038ce:	00019797          	auipc	a5,0x19
    800038d2:	32278793          	addi	a5,a5,802 # 8001cbf0 <log>
    800038d6:	963e                	add	a2,a2,a5
    800038d8:	44dc                	lw	a5,12(s1)
    800038da:	c61c                	sw	a5,8(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800038dc:	8526                	mv	a0,s1
    800038de:	fffff097          	auipc	ra,0xfffff
    800038e2:	d8a080e7          	jalr	-630(ra) # 80002668 <bpin>
    log.lh.n++;
    800038e6:	00019717          	auipc	a4,0x19
    800038ea:	30a70713          	addi	a4,a4,778 # 8001cbf0 <log>
    800038ee:	5b5c                	lw	a5,52(a4)
    800038f0:	2785                	addiw	a5,a5,1
    800038f2:	db5c                	sw	a5,52(a4)
    800038f4:	a835                	j	80003930 <log_write+0xca>
    panic("too big a transaction");
    800038f6:	00005517          	auipc	a0,0x5
    800038fa:	cba50513          	addi	a0,a0,-838 # 800085b0 <syscalls+0x1d8>
    800038fe:	00002097          	auipc	ra,0x2
    80003902:	7ae080e7          	jalr	1966(ra) # 800060ac <panic>
    panic("log_write outside of trans");
    80003906:	00005517          	auipc	a0,0x5
    8000390a:	cc250513          	addi	a0,a0,-830 # 800085c8 <syscalls+0x1f0>
    8000390e:	00002097          	auipc	ra,0x2
    80003912:	79e080e7          	jalr	1950(ra) # 800060ac <panic>
  log.lh.block[i] = b->blockno;
    80003916:	00c78713          	addi	a4,a5,12
    8000391a:	00271693          	slli	a3,a4,0x2
    8000391e:	00019717          	auipc	a4,0x19
    80003922:	2d270713          	addi	a4,a4,722 # 8001cbf0 <log>
    80003926:	9736                	add	a4,a4,a3
    80003928:	44d4                	lw	a3,12(s1)
    8000392a:	c714                	sw	a3,8(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000392c:	faf608e3          	beq	a2,a5,800038dc <log_write+0x76>
  }
  release(&log.lock);
    80003930:	00019517          	auipc	a0,0x19
    80003934:	2c050513          	addi	a0,a0,704 # 8001cbf0 <log>
    80003938:	00003097          	auipc	ra,0x3
    8000393c:	d78080e7          	jalr	-648(ra) # 800066b0 <release>
}
    80003940:	60e2                	ld	ra,24(sp)
    80003942:	6442                	ld	s0,16(sp)
    80003944:	64a2                	ld	s1,8(sp)
    80003946:	6902                	ld	s2,0(sp)
    80003948:	6105                	addi	sp,sp,32
    8000394a:	8082                	ret

000000008000394c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000394c:	1101                	addi	sp,sp,-32
    8000394e:	ec06                	sd	ra,24(sp)
    80003950:	e822                	sd	s0,16(sp)
    80003952:	e426                	sd	s1,8(sp)
    80003954:	e04a                	sd	s2,0(sp)
    80003956:	1000                	addi	s0,sp,32
    80003958:	84aa                	mv	s1,a0
    8000395a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000395c:	00005597          	auipc	a1,0x5
    80003960:	c8c58593          	addi	a1,a1,-884 # 800085e8 <syscalls+0x210>
    80003964:	0521                	addi	a0,a0,8
    80003966:	00003097          	auipc	ra,0x3
    8000396a:	df6080e7          	jalr	-522(ra) # 8000675c <initlock>
  lk->name = name;
    8000396e:	0324b423          	sd	s2,40(s1)
  lk->locked = 0;
    80003972:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003976:	0204a823          	sw	zero,48(s1)
}
    8000397a:	60e2                	ld	ra,24(sp)
    8000397c:	6442                	ld	s0,16(sp)
    8000397e:	64a2                	ld	s1,8(sp)
    80003980:	6902                	ld	s2,0(sp)
    80003982:	6105                	addi	sp,sp,32
    80003984:	8082                	ret

0000000080003986 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003986:	1101                	addi	sp,sp,-32
    80003988:	ec06                	sd	ra,24(sp)
    8000398a:	e822                	sd	s0,16(sp)
    8000398c:	e426                	sd	s1,8(sp)
    8000398e:	e04a                	sd	s2,0(sp)
    80003990:	1000                	addi	s0,sp,32
    80003992:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003994:	00850913          	addi	s2,a0,8
    80003998:	854a                	mv	a0,s2
    8000399a:	00003097          	auipc	ra,0x3
    8000399e:	c46080e7          	jalr	-954(ra) # 800065e0 <acquire>
  while (lk->locked) {
    800039a2:	409c                	lw	a5,0(s1)
    800039a4:	cb89                	beqz	a5,800039b6 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800039a6:	85ca                	mv	a1,s2
    800039a8:	8526                	mv	a0,s1
    800039aa:	ffffe097          	auipc	ra,0xffffe
    800039ae:	c82080e7          	jalr	-894(ra) # 8000162c <sleep>
  while (lk->locked) {
    800039b2:	409c                	lw	a5,0(s1)
    800039b4:	fbed                	bnez	a5,800039a6 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800039b6:	4785                	li	a5,1
    800039b8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800039ba:	ffffd097          	auipc	ra,0xffffd
    800039be:	5b6080e7          	jalr	1462(ra) # 80000f70 <myproc>
    800039c2:	5d1c                	lw	a5,56(a0)
    800039c4:	d89c                	sw	a5,48(s1)
  release(&lk->lk);
    800039c6:	854a                	mv	a0,s2
    800039c8:	00003097          	auipc	ra,0x3
    800039cc:	ce8080e7          	jalr	-792(ra) # 800066b0 <release>
}
    800039d0:	60e2                	ld	ra,24(sp)
    800039d2:	6442                	ld	s0,16(sp)
    800039d4:	64a2                	ld	s1,8(sp)
    800039d6:	6902                	ld	s2,0(sp)
    800039d8:	6105                	addi	sp,sp,32
    800039da:	8082                	ret

00000000800039dc <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800039dc:	1101                	addi	sp,sp,-32
    800039de:	ec06                	sd	ra,24(sp)
    800039e0:	e822                	sd	s0,16(sp)
    800039e2:	e426                	sd	s1,8(sp)
    800039e4:	e04a                	sd	s2,0(sp)
    800039e6:	1000                	addi	s0,sp,32
    800039e8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039ea:	00850913          	addi	s2,a0,8
    800039ee:	854a                	mv	a0,s2
    800039f0:	00003097          	auipc	ra,0x3
    800039f4:	bf0080e7          	jalr	-1040(ra) # 800065e0 <acquire>
  lk->locked = 0;
    800039f8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039fc:	0204a823          	sw	zero,48(s1)
  wakeup(lk);
    80003a00:	8526                	mv	a0,s1
    80003a02:	ffffe097          	auipc	ra,0xffffe
    80003a06:	db6080e7          	jalr	-586(ra) # 800017b8 <wakeup>
  release(&lk->lk);
    80003a0a:	854a                	mv	a0,s2
    80003a0c:	00003097          	auipc	ra,0x3
    80003a10:	ca4080e7          	jalr	-860(ra) # 800066b0 <release>
}
    80003a14:	60e2                	ld	ra,24(sp)
    80003a16:	6442                	ld	s0,16(sp)
    80003a18:	64a2                	ld	s1,8(sp)
    80003a1a:	6902                	ld	s2,0(sp)
    80003a1c:	6105                	addi	sp,sp,32
    80003a1e:	8082                	ret

0000000080003a20 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a20:	7179                	addi	sp,sp,-48
    80003a22:	f406                	sd	ra,40(sp)
    80003a24:	f022                	sd	s0,32(sp)
    80003a26:	ec26                	sd	s1,24(sp)
    80003a28:	e84a                	sd	s2,16(sp)
    80003a2a:	e44e                	sd	s3,8(sp)
    80003a2c:	1800                	addi	s0,sp,48
    80003a2e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a30:	00850913          	addi	s2,a0,8
    80003a34:	854a                	mv	a0,s2
    80003a36:	00003097          	auipc	ra,0x3
    80003a3a:	baa080e7          	jalr	-1110(ra) # 800065e0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a3e:	409c                	lw	a5,0(s1)
    80003a40:	ef99                	bnez	a5,80003a5e <holdingsleep+0x3e>
    80003a42:	4481                	li	s1,0
  release(&lk->lk);
    80003a44:	854a                	mv	a0,s2
    80003a46:	00003097          	auipc	ra,0x3
    80003a4a:	c6a080e7          	jalr	-918(ra) # 800066b0 <release>
  return r;
}
    80003a4e:	8526                	mv	a0,s1
    80003a50:	70a2                	ld	ra,40(sp)
    80003a52:	7402                	ld	s0,32(sp)
    80003a54:	64e2                	ld	s1,24(sp)
    80003a56:	6942                	ld	s2,16(sp)
    80003a58:	69a2                	ld	s3,8(sp)
    80003a5a:	6145                	addi	sp,sp,48
    80003a5c:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a5e:	0304a983          	lw	s3,48(s1)
    80003a62:	ffffd097          	auipc	ra,0xffffd
    80003a66:	50e080e7          	jalr	1294(ra) # 80000f70 <myproc>
    80003a6a:	5d04                	lw	s1,56(a0)
    80003a6c:	413484b3          	sub	s1,s1,s3
    80003a70:	0014b493          	seqz	s1,s1
    80003a74:	bfc1                	j	80003a44 <holdingsleep+0x24>

0000000080003a76 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a76:	1141                	addi	sp,sp,-16
    80003a78:	e406                	sd	ra,8(sp)
    80003a7a:	e022                	sd	s0,0(sp)
    80003a7c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a7e:	00005597          	auipc	a1,0x5
    80003a82:	b7a58593          	addi	a1,a1,-1158 # 800085f8 <syscalls+0x220>
    80003a86:	00019517          	auipc	a0,0x19
    80003a8a:	2ba50513          	addi	a0,a0,698 # 8001cd40 <ftable>
    80003a8e:	00003097          	auipc	ra,0x3
    80003a92:	cce080e7          	jalr	-818(ra) # 8000675c <initlock>
}
    80003a96:	60a2                	ld	ra,8(sp)
    80003a98:	6402                	ld	s0,0(sp)
    80003a9a:	0141                	addi	sp,sp,16
    80003a9c:	8082                	ret

0000000080003a9e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a9e:	1101                	addi	sp,sp,-32
    80003aa0:	ec06                	sd	ra,24(sp)
    80003aa2:	e822                	sd	s0,16(sp)
    80003aa4:	e426                	sd	s1,8(sp)
    80003aa6:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003aa8:	00019517          	auipc	a0,0x19
    80003aac:	29850513          	addi	a0,a0,664 # 8001cd40 <ftable>
    80003ab0:	00003097          	auipc	ra,0x3
    80003ab4:	b30080e7          	jalr	-1232(ra) # 800065e0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003ab8:	00019497          	auipc	s1,0x19
    80003abc:	2a848493          	addi	s1,s1,680 # 8001cd60 <ftable+0x20>
    80003ac0:	0001a717          	auipc	a4,0x1a
    80003ac4:	24070713          	addi	a4,a4,576 # 8001dd00 <ftable+0xfc0>
    if(f->ref == 0){
    80003ac8:	40dc                	lw	a5,4(s1)
    80003aca:	cf99                	beqz	a5,80003ae8 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003acc:	02848493          	addi	s1,s1,40
    80003ad0:	fee49ce3          	bne	s1,a4,80003ac8 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003ad4:	00019517          	auipc	a0,0x19
    80003ad8:	26c50513          	addi	a0,a0,620 # 8001cd40 <ftable>
    80003adc:	00003097          	auipc	ra,0x3
    80003ae0:	bd4080e7          	jalr	-1068(ra) # 800066b0 <release>
  return 0;
    80003ae4:	4481                	li	s1,0
    80003ae6:	a819                	j	80003afc <filealloc+0x5e>
      f->ref = 1;
    80003ae8:	4785                	li	a5,1
    80003aea:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003aec:	00019517          	auipc	a0,0x19
    80003af0:	25450513          	addi	a0,a0,596 # 8001cd40 <ftable>
    80003af4:	00003097          	auipc	ra,0x3
    80003af8:	bbc080e7          	jalr	-1092(ra) # 800066b0 <release>
}
    80003afc:	8526                	mv	a0,s1
    80003afe:	60e2                	ld	ra,24(sp)
    80003b00:	6442                	ld	s0,16(sp)
    80003b02:	64a2                	ld	s1,8(sp)
    80003b04:	6105                	addi	sp,sp,32
    80003b06:	8082                	ret

0000000080003b08 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b08:	1101                	addi	sp,sp,-32
    80003b0a:	ec06                	sd	ra,24(sp)
    80003b0c:	e822                	sd	s0,16(sp)
    80003b0e:	e426                	sd	s1,8(sp)
    80003b10:	1000                	addi	s0,sp,32
    80003b12:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b14:	00019517          	auipc	a0,0x19
    80003b18:	22c50513          	addi	a0,a0,556 # 8001cd40 <ftable>
    80003b1c:	00003097          	auipc	ra,0x3
    80003b20:	ac4080e7          	jalr	-1340(ra) # 800065e0 <acquire>
  if(f->ref < 1)
    80003b24:	40dc                	lw	a5,4(s1)
    80003b26:	02f05263          	blez	a5,80003b4a <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b2a:	2785                	addiw	a5,a5,1
    80003b2c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b2e:	00019517          	auipc	a0,0x19
    80003b32:	21250513          	addi	a0,a0,530 # 8001cd40 <ftable>
    80003b36:	00003097          	auipc	ra,0x3
    80003b3a:	b7a080e7          	jalr	-1158(ra) # 800066b0 <release>
  return f;
}
    80003b3e:	8526                	mv	a0,s1
    80003b40:	60e2                	ld	ra,24(sp)
    80003b42:	6442                	ld	s0,16(sp)
    80003b44:	64a2                	ld	s1,8(sp)
    80003b46:	6105                	addi	sp,sp,32
    80003b48:	8082                	ret
    panic("filedup");
    80003b4a:	00005517          	auipc	a0,0x5
    80003b4e:	ab650513          	addi	a0,a0,-1354 # 80008600 <syscalls+0x228>
    80003b52:	00002097          	auipc	ra,0x2
    80003b56:	55a080e7          	jalr	1370(ra) # 800060ac <panic>

0000000080003b5a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b5a:	7139                	addi	sp,sp,-64
    80003b5c:	fc06                	sd	ra,56(sp)
    80003b5e:	f822                	sd	s0,48(sp)
    80003b60:	f426                	sd	s1,40(sp)
    80003b62:	f04a                	sd	s2,32(sp)
    80003b64:	ec4e                	sd	s3,24(sp)
    80003b66:	e852                	sd	s4,16(sp)
    80003b68:	e456                	sd	s5,8(sp)
    80003b6a:	0080                	addi	s0,sp,64
    80003b6c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b6e:	00019517          	auipc	a0,0x19
    80003b72:	1d250513          	addi	a0,a0,466 # 8001cd40 <ftable>
    80003b76:	00003097          	auipc	ra,0x3
    80003b7a:	a6a080e7          	jalr	-1430(ra) # 800065e0 <acquire>
  if(f->ref < 1)
    80003b7e:	40dc                	lw	a5,4(s1)
    80003b80:	06f05163          	blez	a5,80003be2 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003b84:	37fd                	addiw	a5,a5,-1
    80003b86:	0007871b          	sext.w	a4,a5
    80003b8a:	c0dc                	sw	a5,4(s1)
    80003b8c:	06e04363          	bgtz	a4,80003bf2 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b90:	0004a903          	lw	s2,0(s1)
    80003b94:	0094ca83          	lbu	s5,9(s1)
    80003b98:	0104ba03          	ld	s4,16(s1)
    80003b9c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003ba0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ba4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ba8:	00019517          	auipc	a0,0x19
    80003bac:	19850513          	addi	a0,a0,408 # 8001cd40 <ftable>
    80003bb0:	00003097          	auipc	ra,0x3
    80003bb4:	b00080e7          	jalr	-1280(ra) # 800066b0 <release>

  if(ff.type == FD_PIPE){
    80003bb8:	4785                	li	a5,1
    80003bba:	04f90d63          	beq	s2,a5,80003c14 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003bbe:	3979                	addiw	s2,s2,-2
    80003bc0:	4785                	li	a5,1
    80003bc2:	0527e063          	bltu	a5,s2,80003c02 <fileclose+0xa8>
    begin_op();
    80003bc6:	00000097          	auipc	ra,0x0
    80003bca:	ac8080e7          	jalr	-1336(ra) # 8000368e <begin_op>
    iput(ff.ip);
    80003bce:	854e                	mv	a0,s3
    80003bd0:	fffff097          	auipc	ra,0xfffff
    80003bd4:	2a6080e7          	jalr	678(ra) # 80002e76 <iput>
    end_op();
    80003bd8:	00000097          	auipc	ra,0x0
    80003bdc:	b36080e7          	jalr	-1226(ra) # 8000370e <end_op>
    80003be0:	a00d                	j	80003c02 <fileclose+0xa8>
    panic("fileclose");
    80003be2:	00005517          	auipc	a0,0x5
    80003be6:	a2650513          	addi	a0,a0,-1498 # 80008608 <syscalls+0x230>
    80003bea:	00002097          	auipc	ra,0x2
    80003bee:	4c2080e7          	jalr	1218(ra) # 800060ac <panic>
    release(&ftable.lock);
    80003bf2:	00019517          	auipc	a0,0x19
    80003bf6:	14e50513          	addi	a0,a0,334 # 8001cd40 <ftable>
    80003bfa:	00003097          	auipc	ra,0x3
    80003bfe:	ab6080e7          	jalr	-1354(ra) # 800066b0 <release>
  }
}
    80003c02:	70e2                	ld	ra,56(sp)
    80003c04:	7442                	ld	s0,48(sp)
    80003c06:	74a2                	ld	s1,40(sp)
    80003c08:	7902                	ld	s2,32(sp)
    80003c0a:	69e2                	ld	s3,24(sp)
    80003c0c:	6a42                	ld	s4,16(sp)
    80003c0e:	6aa2                	ld	s5,8(sp)
    80003c10:	6121                	addi	sp,sp,64
    80003c12:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c14:	85d6                	mv	a1,s5
    80003c16:	8552                	mv	a0,s4
    80003c18:	00000097          	auipc	ra,0x0
    80003c1c:	34c080e7          	jalr	844(ra) # 80003f64 <pipeclose>
    80003c20:	b7cd                	j	80003c02 <fileclose+0xa8>

0000000080003c22 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c22:	715d                	addi	sp,sp,-80
    80003c24:	e486                	sd	ra,72(sp)
    80003c26:	e0a2                	sd	s0,64(sp)
    80003c28:	fc26                	sd	s1,56(sp)
    80003c2a:	f84a                	sd	s2,48(sp)
    80003c2c:	f44e                	sd	s3,40(sp)
    80003c2e:	0880                	addi	s0,sp,80
    80003c30:	84aa                	mv	s1,a0
    80003c32:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c34:	ffffd097          	auipc	ra,0xffffd
    80003c38:	33c080e7          	jalr	828(ra) # 80000f70 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c3c:	409c                	lw	a5,0(s1)
    80003c3e:	37f9                	addiw	a5,a5,-2
    80003c40:	4705                	li	a4,1
    80003c42:	04f76763          	bltu	a4,a5,80003c90 <filestat+0x6e>
    80003c46:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c48:	6c88                	ld	a0,24(s1)
    80003c4a:	fffff097          	auipc	ra,0xfffff
    80003c4e:	072080e7          	jalr	114(ra) # 80002cbc <ilock>
    stati(f->ip, &st);
    80003c52:	fb840593          	addi	a1,s0,-72
    80003c56:	6c88                	ld	a0,24(s1)
    80003c58:	fffff097          	auipc	ra,0xfffff
    80003c5c:	2ee080e7          	jalr	750(ra) # 80002f46 <stati>
    iunlock(f->ip);
    80003c60:	6c88                	ld	a0,24(s1)
    80003c62:	fffff097          	auipc	ra,0xfffff
    80003c66:	11c080e7          	jalr	284(ra) # 80002d7e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c6a:	46e1                	li	a3,24
    80003c6c:	fb840613          	addi	a2,s0,-72
    80003c70:	85ce                	mv	a1,s3
    80003c72:	05893503          	ld	a0,88(s2)
    80003c76:	ffffd097          	auipc	ra,0xffffd
    80003c7a:	fbc080e7          	jalr	-68(ra) # 80000c32 <copyout>
    80003c7e:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003c82:	60a6                	ld	ra,72(sp)
    80003c84:	6406                	ld	s0,64(sp)
    80003c86:	74e2                	ld	s1,56(sp)
    80003c88:	7942                	ld	s2,48(sp)
    80003c8a:	79a2                	ld	s3,40(sp)
    80003c8c:	6161                	addi	sp,sp,80
    80003c8e:	8082                	ret
  return -1;
    80003c90:	557d                	li	a0,-1
    80003c92:	bfc5                	j	80003c82 <filestat+0x60>

0000000080003c94 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c94:	7179                	addi	sp,sp,-48
    80003c96:	f406                	sd	ra,40(sp)
    80003c98:	f022                	sd	s0,32(sp)
    80003c9a:	ec26                	sd	s1,24(sp)
    80003c9c:	e84a                	sd	s2,16(sp)
    80003c9e:	e44e                	sd	s3,8(sp)
    80003ca0:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003ca2:	00854783          	lbu	a5,8(a0)
    80003ca6:	c3d5                	beqz	a5,80003d4a <fileread+0xb6>
    80003ca8:	84aa                	mv	s1,a0
    80003caa:	89ae                	mv	s3,a1
    80003cac:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cae:	411c                	lw	a5,0(a0)
    80003cb0:	4705                	li	a4,1
    80003cb2:	04e78963          	beq	a5,a4,80003d04 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cb6:	470d                	li	a4,3
    80003cb8:	04e78d63          	beq	a5,a4,80003d12 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cbc:	4709                	li	a4,2
    80003cbe:	06e79e63          	bne	a5,a4,80003d3a <fileread+0xa6>
    ilock(f->ip);
    80003cc2:	6d08                	ld	a0,24(a0)
    80003cc4:	fffff097          	auipc	ra,0xfffff
    80003cc8:	ff8080e7          	jalr	-8(ra) # 80002cbc <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003ccc:	874a                	mv	a4,s2
    80003cce:	5094                	lw	a3,32(s1)
    80003cd0:	864e                	mv	a2,s3
    80003cd2:	4585                	li	a1,1
    80003cd4:	6c88                	ld	a0,24(s1)
    80003cd6:	fffff097          	auipc	ra,0xfffff
    80003cda:	29a080e7          	jalr	666(ra) # 80002f70 <readi>
    80003cde:	892a                	mv	s2,a0
    80003ce0:	00a05563          	blez	a0,80003cea <fileread+0x56>
      f->off += r;
    80003ce4:	509c                	lw	a5,32(s1)
    80003ce6:	9fa9                	addw	a5,a5,a0
    80003ce8:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003cea:	6c88                	ld	a0,24(s1)
    80003cec:	fffff097          	auipc	ra,0xfffff
    80003cf0:	092080e7          	jalr	146(ra) # 80002d7e <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003cf4:	854a                	mv	a0,s2
    80003cf6:	70a2                	ld	ra,40(sp)
    80003cf8:	7402                	ld	s0,32(sp)
    80003cfa:	64e2                	ld	s1,24(sp)
    80003cfc:	6942                	ld	s2,16(sp)
    80003cfe:	69a2                	ld	s3,8(sp)
    80003d00:	6145                	addi	sp,sp,48
    80003d02:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d04:	6908                	ld	a0,16(a0)
    80003d06:	00000097          	auipc	ra,0x0
    80003d0a:	3d2080e7          	jalr	978(ra) # 800040d8 <piperead>
    80003d0e:	892a                	mv	s2,a0
    80003d10:	b7d5                	j	80003cf4 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d12:	02451783          	lh	a5,36(a0)
    80003d16:	03079693          	slli	a3,a5,0x30
    80003d1a:	92c1                	srli	a3,a3,0x30
    80003d1c:	4725                	li	a4,9
    80003d1e:	02d76863          	bltu	a4,a3,80003d4e <fileread+0xba>
    80003d22:	0792                	slli	a5,a5,0x4
    80003d24:	00019717          	auipc	a4,0x19
    80003d28:	f7c70713          	addi	a4,a4,-132 # 8001cca0 <devsw>
    80003d2c:	97ba                	add	a5,a5,a4
    80003d2e:	639c                	ld	a5,0(a5)
    80003d30:	c38d                	beqz	a5,80003d52 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d32:	4505                	li	a0,1
    80003d34:	9782                	jalr	a5
    80003d36:	892a                	mv	s2,a0
    80003d38:	bf75                	j	80003cf4 <fileread+0x60>
    panic("fileread");
    80003d3a:	00005517          	auipc	a0,0x5
    80003d3e:	8de50513          	addi	a0,a0,-1826 # 80008618 <syscalls+0x240>
    80003d42:	00002097          	auipc	ra,0x2
    80003d46:	36a080e7          	jalr	874(ra) # 800060ac <panic>
    return -1;
    80003d4a:	597d                	li	s2,-1
    80003d4c:	b765                	j	80003cf4 <fileread+0x60>
      return -1;
    80003d4e:	597d                	li	s2,-1
    80003d50:	b755                	j	80003cf4 <fileread+0x60>
    80003d52:	597d                	li	s2,-1
    80003d54:	b745                	j	80003cf4 <fileread+0x60>

0000000080003d56 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d56:	715d                	addi	sp,sp,-80
    80003d58:	e486                	sd	ra,72(sp)
    80003d5a:	e0a2                	sd	s0,64(sp)
    80003d5c:	fc26                	sd	s1,56(sp)
    80003d5e:	f84a                	sd	s2,48(sp)
    80003d60:	f44e                	sd	s3,40(sp)
    80003d62:	f052                	sd	s4,32(sp)
    80003d64:	ec56                	sd	s5,24(sp)
    80003d66:	e85a                	sd	s6,16(sp)
    80003d68:	e45e                	sd	s7,8(sp)
    80003d6a:	e062                	sd	s8,0(sp)
    80003d6c:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003d6e:	00954783          	lbu	a5,9(a0)
    80003d72:	10078663          	beqz	a5,80003e7e <filewrite+0x128>
    80003d76:	892a                	mv	s2,a0
    80003d78:	8aae                	mv	s5,a1
    80003d7a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d7c:	411c                	lw	a5,0(a0)
    80003d7e:	4705                	li	a4,1
    80003d80:	02e78263          	beq	a5,a4,80003da4 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d84:	470d                	li	a4,3
    80003d86:	02e78663          	beq	a5,a4,80003db2 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d8a:	4709                	li	a4,2
    80003d8c:	0ee79163          	bne	a5,a4,80003e6e <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d90:	0ac05d63          	blez	a2,80003e4a <filewrite+0xf4>
    int i = 0;
    80003d94:	4981                	li	s3,0
    80003d96:	6b05                	lui	s6,0x1
    80003d98:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003d9c:	6b85                	lui	s7,0x1
    80003d9e:	c00b8b9b          	addiw	s7,s7,-1024
    80003da2:	a861                	j	80003e3a <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003da4:	6908                	ld	a0,16(a0)
    80003da6:	00000097          	auipc	ra,0x0
    80003daa:	238080e7          	jalr	568(ra) # 80003fde <pipewrite>
    80003dae:	8a2a                	mv	s4,a0
    80003db0:	a045                	j	80003e50 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003db2:	02451783          	lh	a5,36(a0)
    80003db6:	03079693          	slli	a3,a5,0x30
    80003dba:	92c1                	srli	a3,a3,0x30
    80003dbc:	4725                	li	a4,9
    80003dbe:	0cd76263          	bltu	a4,a3,80003e82 <filewrite+0x12c>
    80003dc2:	0792                	slli	a5,a5,0x4
    80003dc4:	00019717          	auipc	a4,0x19
    80003dc8:	edc70713          	addi	a4,a4,-292 # 8001cca0 <devsw>
    80003dcc:	97ba                	add	a5,a5,a4
    80003dce:	679c                	ld	a5,8(a5)
    80003dd0:	cbdd                	beqz	a5,80003e86 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003dd2:	4505                	li	a0,1
    80003dd4:	9782                	jalr	a5
    80003dd6:	8a2a                	mv	s4,a0
    80003dd8:	a8a5                	j	80003e50 <filewrite+0xfa>
    80003dda:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003dde:	00000097          	auipc	ra,0x0
    80003de2:	8b0080e7          	jalr	-1872(ra) # 8000368e <begin_op>
      ilock(f->ip);
    80003de6:	01893503          	ld	a0,24(s2)
    80003dea:	fffff097          	auipc	ra,0xfffff
    80003dee:	ed2080e7          	jalr	-302(ra) # 80002cbc <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003df2:	8762                	mv	a4,s8
    80003df4:	02092683          	lw	a3,32(s2)
    80003df8:	01598633          	add	a2,s3,s5
    80003dfc:	4585                	li	a1,1
    80003dfe:	01893503          	ld	a0,24(s2)
    80003e02:	fffff097          	auipc	ra,0xfffff
    80003e06:	266080e7          	jalr	614(ra) # 80003068 <writei>
    80003e0a:	84aa                	mv	s1,a0
    80003e0c:	00a05763          	blez	a0,80003e1a <filewrite+0xc4>
        f->off += r;
    80003e10:	02092783          	lw	a5,32(s2)
    80003e14:	9fa9                	addw	a5,a5,a0
    80003e16:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e1a:	01893503          	ld	a0,24(s2)
    80003e1e:	fffff097          	auipc	ra,0xfffff
    80003e22:	f60080e7          	jalr	-160(ra) # 80002d7e <iunlock>
      end_op();
    80003e26:	00000097          	auipc	ra,0x0
    80003e2a:	8e8080e7          	jalr	-1816(ra) # 8000370e <end_op>

      if(r != n1){
    80003e2e:	009c1f63          	bne	s8,s1,80003e4c <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e32:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e36:	0149db63          	bge	s3,s4,80003e4c <filewrite+0xf6>
      int n1 = n - i;
    80003e3a:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003e3e:	84be                	mv	s1,a5
    80003e40:	2781                	sext.w	a5,a5
    80003e42:	f8fb5ce3          	bge	s6,a5,80003dda <filewrite+0x84>
    80003e46:	84de                	mv	s1,s7
    80003e48:	bf49                	j	80003dda <filewrite+0x84>
    int i = 0;
    80003e4a:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e4c:	013a1f63          	bne	s4,s3,80003e6a <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e50:	8552                	mv	a0,s4
    80003e52:	60a6                	ld	ra,72(sp)
    80003e54:	6406                	ld	s0,64(sp)
    80003e56:	74e2                	ld	s1,56(sp)
    80003e58:	7942                	ld	s2,48(sp)
    80003e5a:	79a2                	ld	s3,40(sp)
    80003e5c:	7a02                	ld	s4,32(sp)
    80003e5e:	6ae2                	ld	s5,24(sp)
    80003e60:	6b42                	ld	s6,16(sp)
    80003e62:	6ba2                	ld	s7,8(sp)
    80003e64:	6c02                	ld	s8,0(sp)
    80003e66:	6161                	addi	sp,sp,80
    80003e68:	8082                	ret
    ret = (i == n ? n : -1);
    80003e6a:	5a7d                	li	s4,-1
    80003e6c:	b7d5                	j	80003e50 <filewrite+0xfa>
    panic("filewrite");
    80003e6e:	00004517          	auipc	a0,0x4
    80003e72:	7ba50513          	addi	a0,a0,1978 # 80008628 <syscalls+0x250>
    80003e76:	00002097          	auipc	ra,0x2
    80003e7a:	236080e7          	jalr	566(ra) # 800060ac <panic>
    return -1;
    80003e7e:	5a7d                	li	s4,-1
    80003e80:	bfc1                	j	80003e50 <filewrite+0xfa>
      return -1;
    80003e82:	5a7d                	li	s4,-1
    80003e84:	b7f1                	j	80003e50 <filewrite+0xfa>
    80003e86:	5a7d                	li	s4,-1
    80003e88:	b7e1                	j	80003e50 <filewrite+0xfa>

0000000080003e8a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e8a:	7179                	addi	sp,sp,-48
    80003e8c:	f406                	sd	ra,40(sp)
    80003e8e:	f022                	sd	s0,32(sp)
    80003e90:	ec26                	sd	s1,24(sp)
    80003e92:	e84a                	sd	s2,16(sp)
    80003e94:	e44e                	sd	s3,8(sp)
    80003e96:	e052                	sd	s4,0(sp)
    80003e98:	1800                	addi	s0,sp,48
    80003e9a:	84aa                	mv	s1,a0
    80003e9c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e9e:	0005b023          	sd	zero,0(a1)
    80003ea2:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003ea6:	00000097          	auipc	ra,0x0
    80003eaa:	bf8080e7          	jalr	-1032(ra) # 80003a9e <filealloc>
    80003eae:	e088                	sd	a0,0(s1)
    80003eb0:	c551                	beqz	a0,80003f3c <pipealloc+0xb2>
    80003eb2:	00000097          	auipc	ra,0x0
    80003eb6:	bec080e7          	jalr	-1044(ra) # 80003a9e <filealloc>
    80003eba:	00aa3023          	sd	a0,0(s4)
    80003ebe:	c92d                	beqz	a0,80003f30 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003ec0:	ffffc097          	auipc	ra,0xffffc
    80003ec4:	2c8080e7          	jalr	712(ra) # 80000188 <kalloc>
    80003ec8:	892a                	mv	s2,a0
    80003eca:	c125                	beqz	a0,80003f2a <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003ecc:	4985                	li	s3,1
    80003ece:	23352423          	sw	s3,552(a0)
  pi->writeopen = 1;
    80003ed2:	23352623          	sw	s3,556(a0)
  pi->nwrite = 0;
    80003ed6:	22052223          	sw	zero,548(a0)
  pi->nread = 0;
    80003eda:	22052023          	sw	zero,544(a0)
  initlock(&pi->lock, "pipe");
    80003ede:	00004597          	auipc	a1,0x4
    80003ee2:	75a58593          	addi	a1,a1,1882 # 80008638 <syscalls+0x260>
    80003ee6:	00003097          	auipc	ra,0x3
    80003eea:	876080e7          	jalr	-1930(ra) # 8000675c <initlock>
  (*f0)->type = FD_PIPE;
    80003eee:	609c                	ld	a5,0(s1)
    80003ef0:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003ef4:	609c                	ld	a5,0(s1)
    80003ef6:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003efa:	609c                	ld	a5,0(s1)
    80003efc:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f00:	609c                	ld	a5,0(s1)
    80003f02:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f06:	000a3783          	ld	a5,0(s4)
    80003f0a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f0e:	000a3783          	ld	a5,0(s4)
    80003f12:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f16:	000a3783          	ld	a5,0(s4)
    80003f1a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f1e:	000a3783          	ld	a5,0(s4)
    80003f22:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f26:	4501                	li	a0,0
    80003f28:	a025                	j	80003f50 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f2a:	6088                	ld	a0,0(s1)
    80003f2c:	e501                	bnez	a0,80003f34 <pipealloc+0xaa>
    80003f2e:	a039                	j	80003f3c <pipealloc+0xb2>
    80003f30:	6088                	ld	a0,0(s1)
    80003f32:	c51d                	beqz	a0,80003f60 <pipealloc+0xd6>
    fileclose(*f0);
    80003f34:	00000097          	auipc	ra,0x0
    80003f38:	c26080e7          	jalr	-986(ra) # 80003b5a <fileclose>
  if(*f1)
    80003f3c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f40:	557d                	li	a0,-1
  if(*f1)
    80003f42:	c799                	beqz	a5,80003f50 <pipealloc+0xc6>
    fileclose(*f1);
    80003f44:	853e                	mv	a0,a5
    80003f46:	00000097          	auipc	ra,0x0
    80003f4a:	c14080e7          	jalr	-1004(ra) # 80003b5a <fileclose>
  return -1;
    80003f4e:	557d                	li	a0,-1
}
    80003f50:	70a2                	ld	ra,40(sp)
    80003f52:	7402                	ld	s0,32(sp)
    80003f54:	64e2                	ld	s1,24(sp)
    80003f56:	6942                	ld	s2,16(sp)
    80003f58:	69a2                	ld	s3,8(sp)
    80003f5a:	6a02                	ld	s4,0(sp)
    80003f5c:	6145                	addi	sp,sp,48
    80003f5e:	8082                	ret
  return -1;
    80003f60:	557d                	li	a0,-1
    80003f62:	b7fd                	j	80003f50 <pipealloc+0xc6>

0000000080003f64 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f64:	1101                	addi	sp,sp,-32
    80003f66:	ec06                	sd	ra,24(sp)
    80003f68:	e822                	sd	s0,16(sp)
    80003f6a:	e426                	sd	s1,8(sp)
    80003f6c:	e04a                	sd	s2,0(sp)
    80003f6e:	1000                	addi	s0,sp,32
    80003f70:	84aa                	mv	s1,a0
    80003f72:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f74:	00002097          	auipc	ra,0x2
    80003f78:	66c080e7          	jalr	1644(ra) # 800065e0 <acquire>
  if(writable){
    80003f7c:	04090263          	beqz	s2,80003fc0 <pipeclose+0x5c>
    pi->writeopen = 0;
    80003f80:	2204a623          	sw	zero,556(s1)
    wakeup(&pi->nread);
    80003f84:	22048513          	addi	a0,s1,544
    80003f88:	ffffe097          	auipc	ra,0xffffe
    80003f8c:	830080e7          	jalr	-2000(ra) # 800017b8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f90:	2284b783          	ld	a5,552(s1)
    80003f94:	ef9d                	bnez	a5,80003fd2 <pipeclose+0x6e>
    release(&pi->lock);
    80003f96:	8526                	mv	a0,s1
    80003f98:	00002097          	auipc	ra,0x2
    80003f9c:	718080e7          	jalr	1816(ra) # 800066b0 <release>
#ifdef LAB_LOCK
    freelock(&pi->lock);
    80003fa0:	8526                	mv	a0,s1
    80003fa2:	00002097          	auipc	ra,0x2
    80003fa6:	756080e7          	jalr	1878(ra) # 800066f8 <freelock>
#endif    
    kfree((char*)pi);
    80003faa:	8526                	mv	a0,s1
    80003fac:	ffffc097          	auipc	ra,0xffffc
    80003fb0:	070080e7          	jalr	112(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003fb4:	60e2                	ld	ra,24(sp)
    80003fb6:	6442                	ld	s0,16(sp)
    80003fb8:	64a2                	ld	s1,8(sp)
    80003fba:	6902                	ld	s2,0(sp)
    80003fbc:	6105                	addi	sp,sp,32
    80003fbe:	8082                	ret
    pi->readopen = 0;
    80003fc0:	2204a423          	sw	zero,552(s1)
    wakeup(&pi->nwrite);
    80003fc4:	22448513          	addi	a0,s1,548
    80003fc8:	ffffd097          	auipc	ra,0xffffd
    80003fcc:	7f0080e7          	jalr	2032(ra) # 800017b8 <wakeup>
    80003fd0:	b7c1                	j	80003f90 <pipeclose+0x2c>
    release(&pi->lock);
    80003fd2:	8526                	mv	a0,s1
    80003fd4:	00002097          	auipc	ra,0x2
    80003fd8:	6dc080e7          	jalr	1756(ra) # 800066b0 <release>
}
    80003fdc:	bfe1                	j	80003fb4 <pipeclose+0x50>

0000000080003fde <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003fde:	7159                	addi	sp,sp,-112
    80003fe0:	f486                	sd	ra,104(sp)
    80003fe2:	f0a2                	sd	s0,96(sp)
    80003fe4:	eca6                	sd	s1,88(sp)
    80003fe6:	e8ca                	sd	s2,80(sp)
    80003fe8:	e4ce                	sd	s3,72(sp)
    80003fea:	e0d2                	sd	s4,64(sp)
    80003fec:	fc56                	sd	s5,56(sp)
    80003fee:	f85a                	sd	s6,48(sp)
    80003ff0:	f45e                	sd	s7,40(sp)
    80003ff2:	f062                	sd	s8,32(sp)
    80003ff4:	ec66                	sd	s9,24(sp)
    80003ff6:	1880                	addi	s0,sp,112
    80003ff8:	84aa                	mv	s1,a0
    80003ffa:	8aae                	mv	s5,a1
    80003ffc:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ffe:	ffffd097          	auipc	ra,0xffffd
    80004002:	f72080e7          	jalr	-142(ra) # 80000f70 <myproc>
    80004006:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004008:	8526                	mv	a0,s1
    8000400a:	00002097          	auipc	ra,0x2
    8000400e:	5d6080e7          	jalr	1494(ra) # 800065e0 <acquire>
  while(i < n){
    80004012:	0d405163          	blez	s4,800040d4 <pipewrite+0xf6>
    80004016:	8ba6                	mv	s7,s1
  int i = 0;
    80004018:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000401a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000401c:	22048c93          	addi	s9,s1,544
      sleep(&pi->nwrite, &pi->lock);
    80004020:	22448c13          	addi	s8,s1,548
    80004024:	a08d                	j	80004086 <pipewrite+0xa8>
      release(&pi->lock);
    80004026:	8526                	mv	a0,s1
    80004028:	00002097          	auipc	ra,0x2
    8000402c:	688080e7          	jalr	1672(ra) # 800066b0 <release>
      return -1;
    80004030:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004032:	854a                	mv	a0,s2
    80004034:	70a6                	ld	ra,104(sp)
    80004036:	7406                	ld	s0,96(sp)
    80004038:	64e6                	ld	s1,88(sp)
    8000403a:	6946                	ld	s2,80(sp)
    8000403c:	69a6                	ld	s3,72(sp)
    8000403e:	6a06                	ld	s4,64(sp)
    80004040:	7ae2                	ld	s5,56(sp)
    80004042:	7b42                	ld	s6,48(sp)
    80004044:	7ba2                	ld	s7,40(sp)
    80004046:	7c02                	ld	s8,32(sp)
    80004048:	6ce2                	ld	s9,24(sp)
    8000404a:	6165                	addi	sp,sp,112
    8000404c:	8082                	ret
      wakeup(&pi->nread);
    8000404e:	8566                	mv	a0,s9
    80004050:	ffffd097          	auipc	ra,0xffffd
    80004054:	768080e7          	jalr	1896(ra) # 800017b8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004058:	85de                	mv	a1,s7
    8000405a:	8562                	mv	a0,s8
    8000405c:	ffffd097          	auipc	ra,0xffffd
    80004060:	5d0080e7          	jalr	1488(ra) # 8000162c <sleep>
    80004064:	a839                	j	80004082 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004066:	2244a783          	lw	a5,548(s1)
    8000406a:	0017871b          	addiw	a4,a5,1
    8000406e:	22e4a223          	sw	a4,548(s1)
    80004072:	1ff7f793          	andi	a5,a5,511
    80004076:	97a6                	add	a5,a5,s1
    80004078:	f9f44703          	lbu	a4,-97(s0)
    8000407c:	02e78023          	sb	a4,32(a5)
      i++;
    80004080:	2905                	addiw	s2,s2,1
  while(i < n){
    80004082:	03495d63          	bge	s2,s4,800040bc <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80004086:	2284a783          	lw	a5,552(s1)
    8000408a:	dfd1                	beqz	a5,80004026 <pipewrite+0x48>
    8000408c:	0309a783          	lw	a5,48(s3)
    80004090:	fbd9                	bnez	a5,80004026 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004092:	2204a783          	lw	a5,544(s1)
    80004096:	2244a703          	lw	a4,548(s1)
    8000409a:	2007879b          	addiw	a5,a5,512
    8000409e:	faf708e3          	beq	a4,a5,8000404e <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040a2:	4685                	li	a3,1
    800040a4:	01590633          	add	a2,s2,s5
    800040a8:	f9f40593          	addi	a1,s0,-97
    800040ac:	0589b503          	ld	a0,88(s3)
    800040b0:	ffffd097          	auipc	ra,0xffffd
    800040b4:	c0e080e7          	jalr	-1010(ra) # 80000cbe <copyin>
    800040b8:	fb6517e3          	bne	a0,s6,80004066 <pipewrite+0x88>
  wakeup(&pi->nread);
    800040bc:	22048513          	addi	a0,s1,544
    800040c0:	ffffd097          	auipc	ra,0xffffd
    800040c4:	6f8080e7          	jalr	1784(ra) # 800017b8 <wakeup>
  release(&pi->lock);
    800040c8:	8526                	mv	a0,s1
    800040ca:	00002097          	auipc	ra,0x2
    800040ce:	5e6080e7          	jalr	1510(ra) # 800066b0 <release>
  return i;
    800040d2:	b785                	j	80004032 <pipewrite+0x54>
  int i = 0;
    800040d4:	4901                	li	s2,0
    800040d6:	b7dd                	j	800040bc <pipewrite+0xde>

00000000800040d8 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800040d8:	715d                	addi	sp,sp,-80
    800040da:	e486                	sd	ra,72(sp)
    800040dc:	e0a2                	sd	s0,64(sp)
    800040de:	fc26                	sd	s1,56(sp)
    800040e0:	f84a                	sd	s2,48(sp)
    800040e2:	f44e                	sd	s3,40(sp)
    800040e4:	f052                	sd	s4,32(sp)
    800040e6:	ec56                	sd	s5,24(sp)
    800040e8:	e85a                	sd	s6,16(sp)
    800040ea:	0880                	addi	s0,sp,80
    800040ec:	84aa                	mv	s1,a0
    800040ee:	892e                	mv	s2,a1
    800040f0:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800040f2:	ffffd097          	auipc	ra,0xffffd
    800040f6:	e7e080e7          	jalr	-386(ra) # 80000f70 <myproc>
    800040fa:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040fc:	8b26                	mv	s6,s1
    800040fe:	8526                	mv	a0,s1
    80004100:	00002097          	auipc	ra,0x2
    80004104:	4e0080e7          	jalr	1248(ra) # 800065e0 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004108:	2204a703          	lw	a4,544(s1)
    8000410c:	2244a783          	lw	a5,548(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004110:	22048993          	addi	s3,s1,544
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004114:	02f71463          	bne	a4,a5,8000413c <piperead+0x64>
    80004118:	22c4a783          	lw	a5,556(s1)
    8000411c:	c385                	beqz	a5,8000413c <piperead+0x64>
    if(pr->killed){
    8000411e:	030a2783          	lw	a5,48(s4)
    80004122:	ebc1                	bnez	a5,800041b2 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004124:	85da                	mv	a1,s6
    80004126:	854e                	mv	a0,s3
    80004128:	ffffd097          	auipc	ra,0xffffd
    8000412c:	504080e7          	jalr	1284(ra) # 8000162c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004130:	2204a703          	lw	a4,544(s1)
    80004134:	2244a783          	lw	a5,548(s1)
    80004138:	fef700e3          	beq	a4,a5,80004118 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000413c:	09505263          	blez	s5,800041c0 <piperead+0xe8>
    80004140:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004142:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004144:	2204a783          	lw	a5,544(s1)
    80004148:	2244a703          	lw	a4,548(s1)
    8000414c:	02f70d63          	beq	a4,a5,80004186 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004150:	0017871b          	addiw	a4,a5,1
    80004154:	22e4a023          	sw	a4,544(s1)
    80004158:	1ff7f793          	andi	a5,a5,511
    8000415c:	97a6                	add	a5,a5,s1
    8000415e:	0207c783          	lbu	a5,32(a5)
    80004162:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004166:	4685                	li	a3,1
    80004168:	fbf40613          	addi	a2,s0,-65
    8000416c:	85ca                	mv	a1,s2
    8000416e:	058a3503          	ld	a0,88(s4)
    80004172:	ffffd097          	auipc	ra,0xffffd
    80004176:	ac0080e7          	jalr	-1344(ra) # 80000c32 <copyout>
    8000417a:	01650663          	beq	a0,s6,80004186 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000417e:	2985                	addiw	s3,s3,1
    80004180:	0905                	addi	s2,s2,1
    80004182:	fd3a91e3          	bne	s5,s3,80004144 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004186:	22448513          	addi	a0,s1,548
    8000418a:	ffffd097          	auipc	ra,0xffffd
    8000418e:	62e080e7          	jalr	1582(ra) # 800017b8 <wakeup>
  release(&pi->lock);
    80004192:	8526                	mv	a0,s1
    80004194:	00002097          	auipc	ra,0x2
    80004198:	51c080e7          	jalr	1308(ra) # 800066b0 <release>
  return i;
}
    8000419c:	854e                	mv	a0,s3
    8000419e:	60a6                	ld	ra,72(sp)
    800041a0:	6406                	ld	s0,64(sp)
    800041a2:	74e2                	ld	s1,56(sp)
    800041a4:	7942                	ld	s2,48(sp)
    800041a6:	79a2                	ld	s3,40(sp)
    800041a8:	7a02                	ld	s4,32(sp)
    800041aa:	6ae2                	ld	s5,24(sp)
    800041ac:	6b42                	ld	s6,16(sp)
    800041ae:	6161                	addi	sp,sp,80
    800041b0:	8082                	ret
      release(&pi->lock);
    800041b2:	8526                	mv	a0,s1
    800041b4:	00002097          	auipc	ra,0x2
    800041b8:	4fc080e7          	jalr	1276(ra) # 800066b0 <release>
      return -1;
    800041bc:	59fd                	li	s3,-1
    800041be:	bff9                	j	8000419c <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041c0:	4981                	li	s3,0
    800041c2:	b7d1                	j	80004186 <piperead+0xae>

00000000800041c4 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800041c4:	df010113          	addi	sp,sp,-528
    800041c8:	20113423          	sd	ra,520(sp)
    800041cc:	20813023          	sd	s0,512(sp)
    800041d0:	ffa6                	sd	s1,504(sp)
    800041d2:	fbca                	sd	s2,496(sp)
    800041d4:	f7ce                	sd	s3,488(sp)
    800041d6:	f3d2                	sd	s4,480(sp)
    800041d8:	efd6                	sd	s5,472(sp)
    800041da:	ebda                	sd	s6,464(sp)
    800041dc:	e7de                	sd	s7,456(sp)
    800041de:	e3e2                	sd	s8,448(sp)
    800041e0:	ff66                	sd	s9,440(sp)
    800041e2:	fb6a                	sd	s10,432(sp)
    800041e4:	f76e                	sd	s11,424(sp)
    800041e6:	0c00                	addi	s0,sp,528
    800041e8:	84aa                	mv	s1,a0
    800041ea:	dea43c23          	sd	a0,-520(s0)
    800041ee:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800041f2:	ffffd097          	auipc	ra,0xffffd
    800041f6:	d7e080e7          	jalr	-642(ra) # 80000f70 <myproc>
    800041fa:	892a                	mv	s2,a0

  begin_op();
    800041fc:	fffff097          	auipc	ra,0xfffff
    80004200:	492080e7          	jalr	1170(ra) # 8000368e <begin_op>

  if((ip = namei(path)) == 0){
    80004204:	8526                	mv	a0,s1
    80004206:	fffff097          	auipc	ra,0xfffff
    8000420a:	26c080e7          	jalr	620(ra) # 80003472 <namei>
    8000420e:	c92d                	beqz	a0,80004280 <exec+0xbc>
    80004210:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004212:	fffff097          	auipc	ra,0xfffff
    80004216:	aaa080e7          	jalr	-1366(ra) # 80002cbc <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000421a:	04000713          	li	a4,64
    8000421e:	4681                	li	a3,0
    80004220:	e5040613          	addi	a2,s0,-432
    80004224:	4581                	li	a1,0
    80004226:	8526                	mv	a0,s1
    80004228:	fffff097          	auipc	ra,0xfffff
    8000422c:	d48080e7          	jalr	-696(ra) # 80002f70 <readi>
    80004230:	04000793          	li	a5,64
    80004234:	00f51a63          	bne	a0,a5,80004248 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004238:	e5042703          	lw	a4,-432(s0)
    8000423c:	464c47b7          	lui	a5,0x464c4
    80004240:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004244:	04f70463          	beq	a4,a5,8000428c <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004248:	8526                	mv	a0,s1
    8000424a:	fffff097          	auipc	ra,0xfffff
    8000424e:	cd4080e7          	jalr	-812(ra) # 80002f1e <iunlockput>
    end_op();
    80004252:	fffff097          	auipc	ra,0xfffff
    80004256:	4bc080e7          	jalr	1212(ra) # 8000370e <end_op>
  }
  return -1;
    8000425a:	557d                	li	a0,-1
}
    8000425c:	20813083          	ld	ra,520(sp)
    80004260:	20013403          	ld	s0,512(sp)
    80004264:	74fe                	ld	s1,504(sp)
    80004266:	795e                	ld	s2,496(sp)
    80004268:	79be                	ld	s3,488(sp)
    8000426a:	7a1e                	ld	s4,480(sp)
    8000426c:	6afe                	ld	s5,472(sp)
    8000426e:	6b5e                	ld	s6,464(sp)
    80004270:	6bbe                	ld	s7,456(sp)
    80004272:	6c1e                	ld	s8,448(sp)
    80004274:	7cfa                	ld	s9,440(sp)
    80004276:	7d5a                	ld	s10,432(sp)
    80004278:	7dba                	ld	s11,424(sp)
    8000427a:	21010113          	addi	sp,sp,528
    8000427e:	8082                	ret
    end_op();
    80004280:	fffff097          	auipc	ra,0xfffff
    80004284:	48e080e7          	jalr	1166(ra) # 8000370e <end_op>
    return -1;
    80004288:	557d                	li	a0,-1
    8000428a:	bfc9                	j	8000425c <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    8000428c:	854a                	mv	a0,s2
    8000428e:	ffffd097          	auipc	ra,0xffffd
    80004292:	da6080e7          	jalr	-602(ra) # 80001034 <proc_pagetable>
    80004296:	8baa                	mv	s7,a0
    80004298:	d945                	beqz	a0,80004248 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000429a:	e7042983          	lw	s3,-400(s0)
    8000429e:	e8845783          	lhu	a5,-376(s0)
    800042a2:	c7ad                	beqz	a5,8000430c <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042a4:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042a6:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    800042a8:	6c85                	lui	s9,0x1
    800042aa:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800042ae:	def43823          	sd	a5,-528(s0)
    800042b2:	a42d                	j	800044dc <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800042b4:	00004517          	auipc	a0,0x4
    800042b8:	38c50513          	addi	a0,a0,908 # 80008640 <syscalls+0x268>
    800042bc:	00002097          	auipc	ra,0x2
    800042c0:	df0080e7          	jalr	-528(ra) # 800060ac <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800042c4:	8756                	mv	a4,s5
    800042c6:	012d86bb          	addw	a3,s11,s2
    800042ca:	4581                	li	a1,0
    800042cc:	8526                	mv	a0,s1
    800042ce:	fffff097          	auipc	ra,0xfffff
    800042d2:	ca2080e7          	jalr	-862(ra) # 80002f70 <readi>
    800042d6:	2501                	sext.w	a0,a0
    800042d8:	1aaa9963          	bne	s5,a0,8000448a <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    800042dc:	6785                	lui	a5,0x1
    800042de:	0127893b          	addw	s2,a5,s2
    800042e2:	77fd                	lui	a5,0xfffff
    800042e4:	01478a3b          	addw	s4,a5,s4
    800042e8:	1f897163          	bgeu	s2,s8,800044ca <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    800042ec:	02091593          	slli	a1,s2,0x20
    800042f0:	9181                	srli	a1,a1,0x20
    800042f2:	95ea                	add	a1,a1,s10
    800042f4:	855e                	mv	a0,s7
    800042f6:	ffffc097          	auipc	ra,0xffffc
    800042fa:	338080e7          	jalr	824(ra) # 8000062e <walkaddr>
    800042fe:	862a                	mv	a2,a0
    if(pa == 0)
    80004300:	d955                	beqz	a0,800042b4 <exec+0xf0>
      n = PGSIZE;
    80004302:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004304:	fd9a70e3          	bgeu	s4,s9,800042c4 <exec+0x100>
      n = sz - i;
    80004308:	8ad2                	mv	s5,s4
    8000430a:	bf6d                	j	800042c4 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000430c:	4901                	li	s2,0
  iunlockput(ip);
    8000430e:	8526                	mv	a0,s1
    80004310:	fffff097          	auipc	ra,0xfffff
    80004314:	c0e080e7          	jalr	-1010(ra) # 80002f1e <iunlockput>
  end_op();
    80004318:	fffff097          	auipc	ra,0xfffff
    8000431c:	3f6080e7          	jalr	1014(ra) # 8000370e <end_op>
  p = myproc();
    80004320:	ffffd097          	auipc	ra,0xffffd
    80004324:	c50080e7          	jalr	-944(ra) # 80000f70 <myproc>
    80004328:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000432a:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    8000432e:	6785                	lui	a5,0x1
    80004330:	17fd                	addi	a5,a5,-1
    80004332:	993e                	add	s2,s2,a5
    80004334:	757d                	lui	a0,0xfffff
    80004336:	00a977b3          	and	a5,s2,a0
    8000433a:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000433e:	6609                	lui	a2,0x2
    80004340:	963e                	add	a2,a2,a5
    80004342:	85be                	mv	a1,a5
    80004344:	855e                	mv	a0,s7
    80004346:	ffffc097          	auipc	ra,0xffffc
    8000434a:	69c080e7          	jalr	1692(ra) # 800009e2 <uvmalloc>
    8000434e:	8b2a                	mv	s6,a0
  ip = 0;
    80004350:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004352:	12050c63          	beqz	a0,8000448a <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004356:	75f9                	lui	a1,0xffffe
    80004358:	95aa                	add	a1,a1,a0
    8000435a:	855e                	mv	a0,s7
    8000435c:	ffffd097          	auipc	ra,0xffffd
    80004360:	8a4080e7          	jalr	-1884(ra) # 80000c00 <uvmclear>
  stackbase = sp - PGSIZE;
    80004364:	7c7d                	lui	s8,0xfffff
    80004366:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004368:	e0043783          	ld	a5,-512(s0)
    8000436c:	6388                	ld	a0,0(a5)
    8000436e:	c535                	beqz	a0,800043da <exec+0x216>
    80004370:	e9040993          	addi	s3,s0,-368
    80004374:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004378:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    8000437a:	ffffc097          	auipc	ra,0xffffc
    8000437e:	09a080e7          	jalr	154(ra) # 80000414 <strlen>
    80004382:	2505                	addiw	a0,a0,1
    80004384:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004388:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000438c:	13896363          	bltu	s2,s8,800044b2 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004390:	e0043d83          	ld	s11,-512(s0)
    80004394:	000dba03          	ld	s4,0(s11)
    80004398:	8552                	mv	a0,s4
    8000439a:	ffffc097          	auipc	ra,0xffffc
    8000439e:	07a080e7          	jalr	122(ra) # 80000414 <strlen>
    800043a2:	0015069b          	addiw	a3,a0,1
    800043a6:	8652                	mv	a2,s4
    800043a8:	85ca                	mv	a1,s2
    800043aa:	855e                	mv	a0,s7
    800043ac:	ffffd097          	auipc	ra,0xffffd
    800043b0:	886080e7          	jalr	-1914(ra) # 80000c32 <copyout>
    800043b4:	10054363          	bltz	a0,800044ba <exec+0x2f6>
    ustack[argc] = sp;
    800043b8:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043bc:	0485                	addi	s1,s1,1
    800043be:	008d8793          	addi	a5,s11,8
    800043c2:	e0f43023          	sd	a5,-512(s0)
    800043c6:	008db503          	ld	a0,8(s11)
    800043ca:	c911                	beqz	a0,800043de <exec+0x21a>
    if(argc >= MAXARG)
    800043cc:	09a1                	addi	s3,s3,8
    800043ce:	fb3c96e3          	bne	s9,s3,8000437a <exec+0x1b6>
  sz = sz1;
    800043d2:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043d6:	4481                	li	s1,0
    800043d8:	a84d                	j	8000448a <exec+0x2c6>
  sp = sz;
    800043da:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800043dc:	4481                	li	s1,0
  ustack[argc] = 0;
    800043de:	00349793          	slli	a5,s1,0x3
    800043e2:	f9040713          	addi	a4,s0,-112
    800043e6:	97ba                	add	a5,a5,a4
    800043e8:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800043ec:	00148693          	addi	a3,s1,1
    800043f0:	068e                	slli	a3,a3,0x3
    800043f2:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043f6:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800043fa:	01897663          	bgeu	s2,s8,80004406 <exec+0x242>
  sz = sz1;
    800043fe:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004402:	4481                	li	s1,0
    80004404:	a059                	j	8000448a <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004406:	e9040613          	addi	a2,s0,-368
    8000440a:	85ca                	mv	a1,s2
    8000440c:	855e                	mv	a0,s7
    8000440e:	ffffd097          	auipc	ra,0xffffd
    80004412:	824080e7          	jalr	-2012(ra) # 80000c32 <copyout>
    80004416:	0a054663          	bltz	a0,800044c2 <exec+0x2fe>
  p->trapframe->a1 = sp;
    8000441a:	060ab783          	ld	a5,96(s5)
    8000441e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004422:	df843783          	ld	a5,-520(s0)
    80004426:	0007c703          	lbu	a4,0(a5)
    8000442a:	cf11                	beqz	a4,80004446 <exec+0x282>
    8000442c:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000442e:	02f00693          	li	a3,47
    80004432:	a039                	j	80004440 <exec+0x27c>
      last = s+1;
    80004434:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004438:	0785                	addi	a5,a5,1
    8000443a:	fff7c703          	lbu	a4,-1(a5)
    8000443e:	c701                	beqz	a4,80004446 <exec+0x282>
    if(*s == '/')
    80004440:	fed71ce3          	bne	a4,a3,80004438 <exec+0x274>
    80004444:	bfc5                	j	80004434 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004446:	4641                	li	a2,16
    80004448:	df843583          	ld	a1,-520(s0)
    8000444c:	160a8513          	addi	a0,s5,352
    80004450:	ffffc097          	auipc	ra,0xffffc
    80004454:	f92080e7          	jalr	-110(ra) # 800003e2 <safestrcpy>
  oldpagetable = p->pagetable;
    80004458:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    8000445c:	057abc23          	sd	s7,88(s5)
  p->sz = sz;
    80004460:	056ab823          	sd	s6,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004464:	060ab783          	ld	a5,96(s5)
    80004468:	e6843703          	ld	a4,-408(s0)
    8000446c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000446e:	060ab783          	ld	a5,96(s5)
    80004472:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004476:	85ea                	mv	a1,s10
    80004478:	ffffd097          	auipc	ra,0xffffd
    8000447c:	c58080e7          	jalr	-936(ra) # 800010d0 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004480:	0004851b          	sext.w	a0,s1
    80004484:	bbe1                	j	8000425c <exec+0x98>
    80004486:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000448a:	e0843583          	ld	a1,-504(s0)
    8000448e:	855e                	mv	a0,s7
    80004490:	ffffd097          	auipc	ra,0xffffd
    80004494:	c40080e7          	jalr	-960(ra) # 800010d0 <proc_freepagetable>
  if(ip){
    80004498:	da0498e3          	bnez	s1,80004248 <exec+0x84>
  return -1;
    8000449c:	557d                	li	a0,-1
    8000449e:	bb7d                	j	8000425c <exec+0x98>
    800044a0:	e1243423          	sd	s2,-504(s0)
    800044a4:	b7dd                	j	8000448a <exec+0x2c6>
    800044a6:	e1243423          	sd	s2,-504(s0)
    800044aa:	b7c5                	j	8000448a <exec+0x2c6>
    800044ac:	e1243423          	sd	s2,-504(s0)
    800044b0:	bfe9                	j	8000448a <exec+0x2c6>
  sz = sz1;
    800044b2:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044b6:	4481                	li	s1,0
    800044b8:	bfc9                	j	8000448a <exec+0x2c6>
  sz = sz1;
    800044ba:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044be:	4481                	li	s1,0
    800044c0:	b7e9                	j	8000448a <exec+0x2c6>
  sz = sz1;
    800044c2:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044c6:	4481                	li	s1,0
    800044c8:	b7c9                	j	8000448a <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800044ca:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044ce:	2b05                	addiw	s6,s6,1
    800044d0:	0389899b          	addiw	s3,s3,56
    800044d4:	e8845783          	lhu	a5,-376(s0)
    800044d8:	e2fb5be3          	bge	s6,a5,8000430e <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800044dc:	2981                	sext.w	s3,s3
    800044de:	03800713          	li	a4,56
    800044e2:	86ce                	mv	a3,s3
    800044e4:	e1840613          	addi	a2,s0,-488
    800044e8:	4581                	li	a1,0
    800044ea:	8526                	mv	a0,s1
    800044ec:	fffff097          	auipc	ra,0xfffff
    800044f0:	a84080e7          	jalr	-1404(ra) # 80002f70 <readi>
    800044f4:	03800793          	li	a5,56
    800044f8:	f8f517e3          	bne	a0,a5,80004486 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    800044fc:	e1842783          	lw	a5,-488(s0)
    80004500:	4705                	li	a4,1
    80004502:	fce796e3          	bne	a5,a4,800044ce <exec+0x30a>
    if(ph.memsz < ph.filesz)
    80004506:	e4043603          	ld	a2,-448(s0)
    8000450a:	e3843783          	ld	a5,-456(s0)
    8000450e:	f8f669e3          	bltu	a2,a5,800044a0 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004512:	e2843783          	ld	a5,-472(s0)
    80004516:	963e                	add	a2,a2,a5
    80004518:	f8f667e3          	bltu	a2,a5,800044a6 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000451c:	85ca                	mv	a1,s2
    8000451e:	855e                	mv	a0,s7
    80004520:	ffffc097          	auipc	ra,0xffffc
    80004524:	4c2080e7          	jalr	1218(ra) # 800009e2 <uvmalloc>
    80004528:	e0a43423          	sd	a0,-504(s0)
    8000452c:	d141                	beqz	a0,800044ac <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    8000452e:	e2843d03          	ld	s10,-472(s0)
    80004532:	df043783          	ld	a5,-528(s0)
    80004536:	00fd77b3          	and	a5,s10,a5
    8000453a:	fba1                	bnez	a5,8000448a <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000453c:	e2042d83          	lw	s11,-480(s0)
    80004540:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004544:	f80c03e3          	beqz	s8,800044ca <exec+0x306>
    80004548:	8a62                	mv	s4,s8
    8000454a:	4901                	li	s2,0
    8000454c:	b345                	j	800042ec <exec+0x128>

000000008000454e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000454e:	7179                	addi	sp,sp,-48
    80004550:	f406                	sd	ra,40(sp)
    80004552:	f022                	sd	s0,32(sp)
    80004554:	ec26                	sd	s1,24(sp)
    80004556:	e84a                	sd	s2,16(sp)
    80004558:	1800                	addi	s0,sp,48
    8000455a:	892e                	mv	s2,a1
    8000455c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000455e:	fdc40593          	addi	a1,s0,-36
    80004562:	ffffe097          	auipc	ra,0xffffe
    80004566:	aba080e7          	jalr	-1350(ra) # 8000201c <argint>
    8000456a:	04054063          	bltz	a0,800045aa <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000456e:	fdc42703          	lw	a4,-36(s0)
    80004572:	47bd                	li	a5,15
    80004574:	02e7ed63          	bltu	a5,a4,800045ae <argfd+0x60>
    80004578:	ffffd097          	auipc	ra,0xffffd
    8000457c:	9f8080e7          	jalr	-1544(ra) # 80000f70 <myproc>
    80004580:	fdc42703          	lw	a4,-36(s0)
    80004584:	01a70793          	addi	a5,a4,26
    80004588:	078e                	slli	a5,a5,0x3
    8000458a:	953e                	add	a0,a0,a5
    8000458c:	651c                	ld	a5,8(a0)
    8000458e:	c395                	beqz	a5,800045b2 <argfd+0x64>
    return -1;
  if(pfd)
    80004590:	00090463          	beqz	s2,80004598 <argfd+0x4a>
    *pfd = fd;
    80004594:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004598:	4501                	li	a0,0
  if(pf)
    8000459a:	c091                	beqz	s1,8000459e <argfd+0x50>
    *pf = f;
    8000459c:	e09c                	sd	a5,0(s1)
}
    8000459e:	70a2                	ld	ra,40(sp)
    800045a0:	7402                	ld	s0,32(sp)
    800045a2:	64e2                	ld	s1,24(sp)
    800045a4:	6942                	ld	s2,16(sp)
    800045a6:	6145                	addi	sp,sp,48
    800045a8:	8082                	ret
    return -1;
    800045aa:	557d                	li	a0,-1
    800045ac:	bfcd                	j	8000459e <argfd+0x50>
    return -1;
    800045ae:	557d                	li	a0,-1
    800045b0:	b7fd                	j	8000459e <argfd+0x50>
    800045b2:	557d                	li	a0,-1
    800045b4:	b7ed                	j	8000459e <argfd+0x50>

00000000800045b6 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800045b6:	1101                	addi	sp,sp,-32
    800045b8:	ec06                	sd	ra,24(sp)
    800045ba:	e822                	sd	s0,16(sp)
    800045bc:	e426                	sd	s1,8(sp)
    800045be:	1000                	addi	s0,sp,32
    800045c0:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800045c2:	ffffd097          	auipc	ra,0xffffd
    800045c6:	9ae080e7          	jalr	-1618(ra) # 80000f70 <myproc>
    800045ca:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800045cc:	0d850793          	addi	a5,a0,216 # fffffffffffff0d8 <end+0xffffffff7ffd3e90>
    800045d0:	4501                	li	a0,0
    800045d2:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800045d4:	6398                	ld	a4,0(a5)
    800045d6:	cb19                	beqz	a4,800045ec <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800045d8:	2505                	addiw	a0,a0,1
    800045da:	07a1                	addi	a5,a5,8
    800045dc:	fed51ce3          	bne	a0,a3,800045d4 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800045e0:	557d                	li	a0,-1
}
    800045e2:	60e2                	ld	ra,24(sp)
    800045e4:	6442                	ld	s0,16(sp)
    800045e6:	64a2                	ld	s1,8(sp)
    800045e8:	6105                	addi	sp,sp,32
    800045ea:	8082                	ret
      p->ofile[fd] = f;
    800045ec:	01a50793          	addi	a5,a0,26
    800045f0:	078e                	slli	a5,a5,0x3
    800045f2:	963e                	add	a2,a2,a5
    800045f4:	e604                	sd	s1,8(a2)
      return fd;
    800045f6:	b7f5                	j	800045e2 <fdalloc+0x2c>

00000000800045f8 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800045f8:	715d                	addi	sp,sp,-80
    800045fa:	e486                	sd	ra,72(sp)
    800045fc:	e0a2                	sd	s0,64(sp)
    800045fe:	fc26                	sd	s1,56(sp)
    80004600:	f84a                	sd	s2,48(sp)
    80004602:	f44e                	sd	s3,40(sp)
    80004604:	f052                	sd	s4,32(sp)
    80004606:	ec56                	sd	s5,24(sp)
    80004608:	0880                	addi	s0,sp,80
    8000460a:	89ae                	mv	s3,a1
    8000460c:	8ab2                	mv	s5,a2
    8000460e:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004610:	fb040593          	addi	a1,s0,-80
    80004614:	fffff097          	auipc	ra,0xfffff
    80004618:	e7c080e7          	jalr	-388(ra) # 80003490 <nameiparent>
    8000461c:	892a                	mv	s2,a0
    8000461e:	12050f63          	beqz	a0,8000475c <create+0x164>
    return 0;

  ilock(dp);
    80004622:	ffffe097          	auipc	ra,0xffffe
    80004626:	69a080e7          	jalr	1690(ra) # 80002cbc <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000462a:	4601                	li	a2,0
    8000462c:	fb040593          	addi	a1,s0,-80
    80004630:	854a                	mv	a0,s2
    80004632:	fffff097          	auipc	ra,0xfffff
    80004636:	b6e080e7          	jalr	-1170(ra) # 800031a0 <dirlookup>
    8000463a:	84aa                	mv	s1,a0
    8000463c:	c921                	beqz	a0,8000468c <create+0x94>
    iunlockput(dp);
    8000463e:	854a                	mv	a0,s2
    80004640:	fffff097          	auipc	ra,0xfffff
    80004644:	8de080e7          	jalr	-1826(ra) # 80002f1e <iunlockput>
    ilock(ip);
    80004648:	8526                	mv	a0,s1
    8000464a:	ffffe097          	auipc	ra,0xffffe
    8000464e:	672080e7          	jalr	1650(ra) # 80002cbc <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004652:	2981                	sext.w	s3,s3
    80004654:	4789                	li	a5,2
    80004656:	02f99463          	bne	s3,a5,8000467e <create+0x86>
    8000465a:	04c4d783          	lhu	a5,76(s1)
    8000465e:	37f9                	addiw	a5,a5,-2
    80004660:	17c2                	slli	a5,a5,0x30
    80004662:	93c1                	srli	a5,a5,0x30
    80004664:	4705                	li	a4,1
    80004666:	00f76c63          	bltu	a4,a5,8000467e <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000466a:	8526                	mv	a0,s1
    8000466c:	60a6                	ld	ra,72(sp)
    8000466e:	6406                	ld	s0,64(sp)
    80004670:	74e2                	ld	s1,56(sp)
    80004672:	7942                	ld	s2,48(sp)
    80004674:	79a2                	ld	s3,40(sp)
    80004676:	7a02                	ld	s4,32(sp)
    80004678:	6ae2                	ld	s5,24(sp)
    8000467a:	6161                	addi	sp,sp,80
    8000467c:	8082                	ret
    iunlockput(ip);
    8000467e:	8526                	mv	a0,s1
    80004680:	fffff097          	auipc	ra,0xfffff
    80004684:	89e080e7          	jalr	-1890(ra) # 80002f1e <iunlockput>
    return 0;
    80004688:	4481                	li	s1,0
    8000468a:	b7c5                	j	8000466a <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000468c:	85ce                	mv	a1,s3
    8000468e:	00092503          	lw	a0,0(s2)
    80004692:	ffffe097          	auipc	ra,0xffffe
    80004696:	492080e7          	jalr	1170(ra) # 80002b24 <ialloc>
    8000469a:	84aa                	mv	s1,a0
    8000469c:	c529                	beqz	a0,800046e6 <create+0xee>
  ilock(ip);
    8000469e:	ffffe097          	auipc	ra,0xffffe
    800046a2:	61e080e7          	jalr	1566(ra) # 80002cbc <ilock>
  ip->major = major;
    800046a6:	05549723          	sh	s5,78(s1)
  ip->minor = minor;
    800046aa:	05449823          	sh	s4,80(s1)
  ip->nlink = 1;
    800046ae:	4785                	li	a5,1
    800046b0:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    800046b4:	8526                	mv	a0,s1
    800046b6:	ffffe097          	auipc	ra,0xffffe
    800046ba:	53c080e7          	jalr	1340(ra) # 80002bf2 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800046be:	2981                	sext.w	s3,s3
    800046c0:	4785                	li	a5,1
    800046c2:	02f98a63          	beq	s3,a5,800046f6 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800046c6:	40d0                	lw	a2,4(s1)
    800046c8:	fb040593          	addi	a1,s0,-80
    800046cc:	854a                	mv	a0,s2
    800046ce:	fffff097          	auipc	ra,0xfffff
    800046d2:	ce2080e7          	jalr	-798(ra) # 800033b0 <dirlink>
    800046d6:	06054b63          	bltz	a0,8000474c <create+0x154>
  iunlockput(dp);
    800046da:	854a                	mv	a0,s2
    800046dc:	fffff097          	auipc	ra,0xfffff
    800046e0:	842080e7          	jalr	-1982(ra) # 80002f1e <iunlockput>
  return ip;
    800046e4:	b759                	j	8000466a <create+0x72>
    panic("create: ialloc");
    800046e6:	00004517          	auipc	a0,0x4
    800046ea:	f7a50513          	addi	a0,a0,-134 # 80008660 <syscalls+0x288>
    800046ee:	00002097          	auipc	ra,0x2
    800046f2:	9be080e7          	jalr	-1602(ra) # 800060ac <panic>
    dp->nlink++;  // for ".."
    800046f6:	05295783          	lhu	a5,82(s2)
    800046fa:	2785                	addiw	a5,a5,1
    800046fc:	04f91923          	sh	a5,82(s2)
    iupdate(dp);
    80004700:	854a                	mv	a0,s2
    80004702:	ffffe097          	auipc	ra,0xffffe
    80004706:	4f0080e7          	jalr	1264(ra) # 80002bf2 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000470a:	40d0                	lw	a2,4(s1)
    8000470c:	00004597          	auipc	a1,0x4
    80004710:	f6458593          	addi	a1,a1,-156 # 80008670 <syscalls+0x298>
    80004714:	8526                	mv	a0,s1
    80004716:	fffff097          	auipc	ra,0xfffff
    8000471a:	c9a080e7          	jalr	-870(ra) # 800033b0 <dirlink>
    8000471e:	00054f63          	bltz	a0,8000473c <create+0x144>
    80004722:	00492603          	lw	a2,4(s2)
    80004726:	00004597          	auipc	a1,0x4
    8000472a:	f5258593          	addi	a1,a1,-174 # 80008678 <syscalls+0x2a0>
    8000472e:	8526                	mv	a0,s1
    80004730:	fffff097          	auipc	ra,0xfffff
    80004734:	c80080e7          	jalr	-896(ra) # 800033b0 <dirlink>
    80004738:	f80557e3          	bgez	a0,800046c6 <create+0xce>
      panic("create dots");
    8000473c:	00004517          	auipc	a0,0x4
    80004740:	f4450513          	addi	a0,a0,-188 # 80008680 <syscalls+0x2a8>
    80004744:	00002097          	auipc	ra,0x2
    80004748:	968080e7          	jalr	-1688(ra) # 800060ac <panic>
    panic("create: dirlink");
    8000474c:	00004517          	auipc	a0,0x4
    80004750:	f4450513          	addi	a0,a0,-188 # 80008690 <syscalls+0x2b8>
    80004754:	00002097          	auipc	ra,0x2
    80004758:	958080e7          	jalr	-1704(ra) # 800060ac <panic>
    return 0;
    8000475c:	84aa                	mv	s1,a0
    8000475e:	b731                	j	8000466a <create+0x72>

0000000080004760 <sys_dup>:
{
    80004760:	7179                	addi	sp,sp,-48
    80004762:	f406                	sd	ra,40(sp)
    80004764:	f022                	sd	s0,32(sp)
    80004766:	ec26                	sd	s1,24(sp)
    80004768:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000476a:	fd840613          	addi	a2,s0,-40
    8000476e:	4581                	li	a1,0
    80004770:	4501                	li	a0,0
    80004772:	00000097          	auipc	ra,0x0
    80004776:	ddc080e7          	jalr	-548(ra) # 8000454e <argfd>
    return -1;
    8000477a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000477c:	02054363          	bltz	a0,800047a2 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004780:	fd843503          	ld	a0,-40(s0)
    80004784:	00000097          	auipc	ra,0x0
    80004788:	e32080e7          	jalr	-462(ra) # 800045b6 <fdalloc>
    8000478c:	84aa                	mv	s1,a0
    return -1;
    8000478e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004790:	00054963          	bltz	a0,800047a2 <sys_dup+0x42>
  filedup(f);
    80004794:	fd843503          	ld	a0,-40(s0)
    80004798:	fffff097          	auipc	ra,0xfffff
    8000479c:	370080e7          	jalr	880(ra) # 80003b08 <filedup>
  return fd;
    800047a0:	87a6                	mv	a5,s1
}
    800047a2:	853e                	mv	a0,a5
    800047a4:	70a2                	ld	ra,40(sp)
    800047a6:	7402                	ld	s0,32(sp)
    800047a8:	64e2                	ld	s1,24(sp)
    800047aa:	6145                	addi	sp,sp,48
    800047ac:	8082                	ret

00000000800047ae <sys_read>:
{
    800047ae:	7179                	addi	sp,sp,-48
    800047b0:	f406                	sd	ra,40(sp)
    800047b2:	f022                	sd	s0,32(sp)
    800047b4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047b6:	fe840613          	addi	a2,s0,-24
    800047ba:	4581                	li	a1,0
    800047bc:	4501                	li	a0,0
    800047be:	00000097          	auipc	ra,0x0
    800047c2:	d90080e7          	jalr	-624(ra) # 8000454e <argfd>
    return -1;
    800047c6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047c8:	04054163          	bltz	a0,8000480a <sys_read+0x5c>
    800047cc:	fe440593          	addi	a1,s0,-28
    800047d0:	4509                	li	a0,2
    800047d2:	ffffe097          	auipc	ra,0xffffe
    800047d6:	84a080e7          	jalr	-1974(ra) # 8000201c <argint>
    return -1;
    800047da:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047dc:	02054763          	bltz	a0,8000480a <sys_read+0x5c>
    800047e0:	fd840593          	addi	a1,s0,-40
    800047e4:	4505                	li	a0,1
    800047e6:	ffffe097          	auipc	ra,0xffffe
    800047ea:	858080e7          	jalr	-1960(ra) # 8000203e <argaddr>
    return -1;
    800047ee:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047f0:	00054d63          	bltz	a0,8000480a <sys_read+0x5c>
  return fileread(f, p, n);
    800047f4:	fe442603          	lw	a2,-28(s0)
    800047f8:	fd843583          	ld	a1,-40(s0)
    800047fc:	fe843503          	ld	a0,-24(s0)
    80004800:	fffff097          	auipc	ra,0xfffff
    80004804:	494080e7          	jalr	1172(ra) # 80003c94 <fileread>
    80004808:	87aa                	mv	a5,a0
}
    8000480a:	853e                	mv	a0,a5
    8000480c:	70a2                	ld	ra,40(sp)
    8000480e:	7402                	ld	s0,32(sp)
    80004810:	6145                	addi	sp,sp,48
    80004812:	8082                	ret

0000000080004814 <sys_write>:
{
    80004814:	7179                	addi	sp,sp,-48
    80004816:	f406                	sd	ra,40(sp)
    80004818:	f022                	sd	s0,32(sp)
    8000481a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000481c:	fe840613          	addi	a2,s0,-24
    80004820:	4581                	li	a1,0
    80004822:	4501                	li	a0,0
    80004824:	00000097          	auipc	ra,0x0
    80004828:	d2a080e7          	jalr	-726(ra) # 8000454e <argfd>
    return -1;
    8000482c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000482e:	04054163          	bltz	a0,80004870 <sys_write+0x5c>
    80004832:	fe440593          	addi	a1,s0,-28
    80004836:	4509                	li	a0,2
    80004838:	ffffd097          	auipc	ra,0xffffd
    8000483c:	7e4080e7          	jalr	2020(ra) # 8000201c <argint>
    return -1;
    80004840:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004842:	02054763          	bltz	a0,80004870 <sys_write+0x5c>
    80004846:	fd840593          	addi	a1,s0,-40
    8000484a:	4505                	li	a0,1
    8000484c:	ffffd097          	auipc	ra,0xffffd
    80004850:	7f2080e7          	jalr	2034(ra) # 8000203e <argaddr>
    return -1;
    80004854:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004856:	00054d63          	bltz	a0,80004870 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000485a:	fe442603          	lw	a2,-28(s0)
    8000485e:	fd843583          	ld	a1,-40(s0)
    80004862:	fe843503          	ld	a0,-24(s0)
    80004866:	fffff097          	auipc	ra,0xfffff
    8000486a:	4f0080e7          	jalr	1264(ra) # 80003d56 <filewrite>
    8000486e:	87aa                	mv	a5,a0
}
    80004870:	853e                	mv	a0,a5
    80004872:	70a2                	ld	ra,40(sp)
    80004874:	7402                	ld	s0,32(sp)
    80004876:	6145                	addi	sp,sp,48
    80004878:	8082                	ret

000000008000487a <sys_close>:
{
    8000487a:	1101                	addi	sp,sp,-32
    8000487c:	ec06                	sd	ra,24(sp)
    8000487e:	e822                	sd	s0,16(sp)
    80004880:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004882:	fe040613          	addi	a2,s0,-32
    80004886:	fec40593          	addi	a1,s0,-20
    8000488a:	4501                	li	a0,0
    8000488c:	00000097          	auipc	ra,0x0
    80004890:	cc2080e7          	jalr	-830(ra) # 8000454e <argfd>
    return -1;
    80004894:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004896:	02054463          	bltz	a0,800048be <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000489a:	ffffc097          	auipc	ra,0xffffc
    8000489e:	6d6080e7          	jalr	1750(ra) # 80000f70 <myproc>
    800048a2:	fec42783          	lw	a5,-20(s0)
    800048a6:	07e9                	addi	a5,a5,26
    800048a8:	078e                	slli	a5,a5,0x3
    800048aa:	97aa                	add	a5,a5,a0
    800048ac:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    800048b0:	fe043503          	ld	a0,-32(s0)
    800048b4:	fffff097          	auipc	ra,0xfffff
    800048b8:	2a6080e7          	jalr	678(ra) # 80003b5a <fileclose>
  return 0;
    800048bc:	4781                	li	a5,0
}
    800048be:	853e                	mv	a0,a5
    800048c0:	60e2                	ld	ra,24(sp)
    800048c2:	6442                	ld	s0,16(sp)
    800048c4:	6105                	addi	sp,sp,32
    800048c6:	8082                	ret

00000000800048c8 <sys_fstat>:
{
    800048c8:	1101                	addi	sp,sp,-32
    800048ca:	ec06                	sd	ra,24(sp)
    800048cc:	e822                	sd	s0,16(sp)
    800048ce:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048d0:	fe840613          	addi	a2,s0,-24
    800048d4:	4581                	li	a1,0
    800048d6:	4501                	li	a0,0
    800048d8:	00000097          	auipc	ra,0x0
    800048dc:	c76080e7          	jalr	-906(ra) # 8000454e <argfd>
    return -1;
    800048e0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048e2:	02054563          	bltz	a0,8000490c <sys_fstat+0x44>
    800048e6:	fe040593          	addi	a1,s0,-32
    800048ea:	4505                	li	a0,1
    800048ec:	ffffd097          	auipc	ra,0xffffd
    800048f0:	752080e7          	jalr	1874(ra) # 8000203e <argaddr>
    return -1;
    800048f4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048f6:	00054b63          	bltz	a0,8000490c <sys_fstat+0x44>
  return filestat(f, st);
    800048fa:	fe043583          	ld	a1,-32(s0)
    800048fe:	fe843503          	ld	a0,-24(s0)
    80004902:	fffff097          	auipc	ra,0xfffff
    80004906:	320080e7          	jalr	800(ra) # 80003c22 <filestat>
    8000490a:	87aa                	mv	a5,a0
}
    8000490c:	853e                	mv	a0,a5
    8000490e:	60e2                	ld	ra,24(sp)
    80004910:	6442                	ld	s0,16(sp)
    80004912:	6105                	addi	sp,sp,32
    80004914:	8082                	ret

0000000080004916 <sys_link>:
{
    80004916:	7169                	addi	sp,sp,-304
    80004918:	f606                	sd	ra,296(sp)
    8000491a:	f222                	sd	s0,288(sp)
    8000491c:	ee26                	sd	s1,280(sp)
    8000491e:	ea4a                	sd	s2,272(sp)
    80004920:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004922:	08000613          	li	a2,128
    80004926:	ed040593          	addi	a1,s0,-304
    8000492a:	4501                	li	a0,0
    8000492c:	ffffd097          	auipc	ra,0xffffd
    80004930:	734080e7          	jalr	1844(ra) # 80002060 <argstr>
    return -1;
    80004934:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004936:	10054e63          	bltz	a0,80004a52 <sys_link+0x13c>
    8000493a:	08000613          	li	a2,128
    8000493e:	f5040593          	addi	a1,s0,-176
    80004942:	4505                	li	a0,1
    80004944:	ffffd097          	auipc	ra,0xffffd
    80004948:	71c080e7          	jalr	1820(ra) # 80002060 <argstr>
    return -1;
    8000494c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000494e:	10054263          	bltz	a0,80004a52 <sys_link+0x13c>
  begin_op();
    80004952:	fffff097          	auipc	ra,0xfffff
    80004956:	d3c080e7          	jalr	-708(ra) # 8000368e <begin_op>
  if((ip = namei(old)) == 0){
    8000495a:	ed040513          	addi	a0,s0,-304
    8000495e:	fffff097          	auipc	ra,0xfffff
    80004962:	b14080e7          	jalr	-1260(ra) # 80003472 <namei>
    80004966:	84aa                	mv	s1,a0
    80004968:	c551                	beqz	a0,800049f4 <sys_link+0xde>
  ilock(ip);
    8000496a:	ffffe097          	auipc	ra,0xffffe
    8000496e:	352080e7          	jalr	850(ra) # 80002cbc <ilock>
  if(ip->type == T_DIR){
    80004972:	04c49703          	lh	a4,76(s1)
    80004976:	4785                	li	a5,1
    80004978:	08f70463          	beq	a4,a5,80004a00 <sys_link+0xea>
  ip->nlink++;
    8000497c:	0524d783          	lhu	a5,82(s1)
    80004980:	2785                	addiw	a5,a5,1
    80004982:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004986:	8526                	mv	a0,s1
    80004988:	ffffe097          	auipc	ra,0xffffe
    8000498c:	26a080e7          	jalr	618(ra) # 80002bf2 <iupdate>
  iunlock(ip);
    80004990:	8526                	mv	a0,s1
    80004992:	ffffe097          	auipc	ra,0xffffe
    80004996:	3ec080e7          	jalr	1004(ra) # 80002d7e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000499a:	fd040593          	addi	a1,s0,-48
    8000499e:	f5040513          	addi	a0,s0,-176
    800049a2:	fffff097          	auipc	ra,0xfffff
    800049a6:	aee080e7          	jalr	-1298(ra) # 80003490 <nameiparent>
    800049aa:	892a                	mv	s2,a0
    800049ac:	c935                	beqz	a0,80004a20 <sys_link+0x10a>
  ilock(dp);
    800049ae:	ffffe097          	auipc	ra,0xffffe
    800049b2:	30e080e7          	jalr	782(ra) # 80002cbc <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800049b6:	00092703          	lw	a4,0(s2)
    800049ba:	409c                	lw	a5,0(s1)
    800049bc:	04f71d63          	bne	a4,a5,80004a16 <sys_link+0x100>
    800049c0:	40d0                	lw	a2,4(s1)
    800049c2:	fd040593          	addi	a1,s0,-48
    800049c6:	854a                	mv	a0,s2
    800049c8:	fffff097          	auipc	ra,0xfffff
    800049cc:	9e8080e7          	jalr	-1560(ra) # 800033b0 <dirlink>
    800049d0:	04054363          	bltz	a0,80004a16 <sys_link+0x100>
  iunlockput(dp);
    800049d4:	854a                	mv	a0,s2
    800049d6:	ffffe097          	auipc	ra,0xffffe
    800049da:	548080e7          	jalr	1352(ra) # 80002f1e <iunlockput>
  iput(ip);
    800049de:	8526                	mv	a0,s1
    800049e0:	ffffe097          	auipc	ra,0xffffe
    800049e4:	496080e7          	jalr	1174(ra) # 80002e76 <iput>
  end_op();
    800049e8:	fffff097          	auipc	ra,0xfffff
    800049ec:	d26080e7          	jalr	-730(ra) # 8000370e <end_op>
  return 0;
    800049f0:	4781                	li	a5,0
    800049f2:	a085                	j	80004a52 <sys_link+0x13c>
    end_op();
    800049f4:	fffff097          	auipc	ra,0xfffff
    800049f8:	d1a080e7          	jalr	-742(ra) # 8000370e <end_op>
    return -1;
    800049fc:	57fd                	li	a5,-1
    800049fe:	a891                	j	80004a52 <sys_link+0x13c>
    iunlockput(ip);
    80004a00:	8526                	mv	a0,s1
    80004a02:	ffffe097          	auipc	ra,0xffffe
    80004a06:	51c080e7          	jalr	1308(ra) # 80002f1e <iunlockput>
    end_op();
    80004a0a:	fffff097          	auipc	ra,0xfffff
    80004a0e:	d04080e7          	jalr	-764(ra) # 8000370e <end_op>
    return -1;
    80004a12:	57fd                	li	a5,-1
    80004a14:	a83d                	j	80004a52 <sys_link+0x13c>
    iunlockput(dp);
    80004a16:	854a                	mv	a0,s2
    80004a18:	ffffe097          	auipc	ra,0xffffe
    80004a1c:	506080e7          	jalr	1286(ra) # 80002f1e <iunlockput>
  ilock(ip);
    80004a20:	8526                	mv	a0,s1
    80004a22:	ffffe097          	auipc	ra,0xffffe
    80004a26:	29a080e7          	jalr	666(ra) # 80002cbc <ilock>
  ip->nlink--;
    80004a2a:	0524d783          	lhu	a5,82(s1)
    80004a2e:	37fd                	addiw	a5,a5,-1
    80004a30:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004a34:	8526                	mv	a0,s1
    80004a36:	ffffe097          	auipc	ra,0xffffe
    80004a3a:	1bc080e7          	jalr	444(ra) # 80002bf2 <iupdate>
  iunlockput(ip);
    80004a3e:	8526                	mv	a0,s1
    80004a40:	ffffe097          	auipc	ra,0xffffe
    80004a44:	4de080e7          	jalr	1246(ra) # 80002f1e <iunlockput>
  end_op();
    80004a48:	fffff097          	auipc	ra,0xfffff
    80004a4c:	cc6080e7          	jalr	-826(ra) # 8000370e <end_op>
  return -1;
    80004a50:	57fd                	li	a5,-1
}
    80004a52:	853e                	mv	a0,a5
    80004a54:	70b2                	ld	ra,296(sp)
    80004a56:	7412                	ld	s0,288(sp)
    80004a58:	64f2                	ld	s1,280(sp)
    80004a5a:	6952                	ld	s2,272(sp)
    80004a5c:	6155                	addi	sp,sp,304
    80004a5e:	8082                	ret

0000000080004a60 <sys_unlink>:
{
    80004a60:	7151                	addi	sp,sp,-240
    80004a62:	f586                	sd	ra,232(sp)
    80004a64:	f1a2                	sd	s0,224(sp)
    80004a66:	eda6                	sd	s1,216(sp)
    80004a68:	e9ca                	sd	s2,208(sp)
    80004a6a:	e5ce                	sd	s3,200(sp)
    80004a6c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a6e:	08000613          	li	a2,128
    80004a72:	f3040593          	addi	a1,s0,-208
    80004a76:	4501                	li	a0,0
    80004a78:	ffffd097          	auipc	ra,0xffffd
    80004a7c:	5e8080e7          	jalr	1512(ra) # 80002060 <argstr>
    80004a80:	18054163          	bltz	a0,80004c02 <sys_unlink+0x1a2>
  begin_op();
    80004a84:	fffff097          	auipc	ra,0xfffff
    80004a88:	c0a080e7          	jalr	-1014(ra) # 8000368e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a8c:	fb040593          	addi	a1,s0,-80
    80004a90:	f3040513          	addi	a0,s0,-208
    80004a94:	fffff097          	auipc	ra,0xfffff
    80004a98:	9fc080e7          	jalr	-1540(ra) # 80003490 <nameiparent>
    80004a9c:	84aa                	mv	s1,a0
    80004a9e:	c979                	beqz	a0,80004b74 <sys_unlink+0x114>
  ilock(dp);
    80004aa0:	ffffe097          	auipc	ra,0xffffe
    80004aa4:	21c080e7          	jalr	540(ra) # 80002cbc <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004aa8:	00004597          	auipc	a1,0x4
    80004aac:	bc858593          	addi	a1,a1,-1080 # 80008670 <syscalls+0x298>
    80004ab0:	fb040513          	addi	a0,s0,-80
    80004ab4:	ffffe097          	auipc	ra,0xffffe
    80004ab8:	6d2080e7          	jalr	1746(ra) # 80003186 <namecmp>
    80004abc:	14050a63          	beqz	a0,80004c10 <sys_unlink+0x1b0>
    80004ac0:	00004597          	auipc	a1,0x4
    80004ac4:	bb858593          	addi	a1,a1,-1096 # 80008678 <syscalls+0x2a0>
    80004ac8:	fb040513          	addi	a0,s0,-80
    80004acc:	ffffe097          	auipc	ra,0xffffe
    80004ad0:	6ba080e7          	jalr	1722(ra) # 80003186 <namecmp>
    80004ad4:	12050e63          	beqz	a0,80004c10 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004ad8:	f2c40613          	addi	a2,s0,-212
    80004adc:	fb040593          	addi	a1,s0,-80
    80004ae0:	8526                	mv	a0,s1
    80004ae2:	ffffe097          	auipc	ra,0xffffe
    80004ae6:	6be080e7          	jalr	1726(ra) # 800031a0 <dirlookup>
    80004aea:	892a                	mv	s2,a0
    80004aec:	12050263          	beqz	a0,80004c10 <sys_unlink+0x1b0>
  ilock(ip);
    80004af0:	ffffe097          	auipc	ra,0xffffe
    80004af4:	1cc080e7          	jalr	460(ra) # 80002cbc <ilock>
  if(ip->nlink < 1)
    80004af8:	05291783          	lh	a5,82(s2)
    80004afc:	08f05263          	blez	a5,80004b80 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b00:	04c91703          	lh	a4,76(s2)
    80004b04:	4785                	li	a5,1
    80004b06:	08f70563          	beq	a4,a5,80004b90 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b0a:	4641                	li	a2,16
    80004b0c:	4581                	li	a1,0
    80004b0e:	fc040513          	addi	a0,s0,-64
    80004b12:	ffffb097          	auipc	ra,0xffffb
    80004b16:	77e080e7          	jalr	1918(ra) # 80000290 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b1a:	4741                	li	a4,16
    80004b1c:	f2c42683          	lw	a3,-212(s0)
    80004b20:	fc040613          	addi	a2,s0,-64
    80004b24:	4581                	li	a1,0
    80004b26:	8526                	mv	a0,s1
    80004b28:	ffffe097          	auipc	ra,0xffffe
    80004b2c:	540080e7          	jalr	1344(ra) # 80003068 <writei>
    80004b30:	47c1                	li	a5,16
    80004b32:	0af51563          	bne	a0,a5,80004bdc <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b36:	04c91703          	lh	a4,76(s2)
    80004b3a:	4785                	li	a5,1
    80004b3c:	0af70863          	beq	a4,a5,80004bec <sys_unlink+0x18c>
  iunlockput(dp);
    80004b40:	8526                	mv	a0,s1
    80004b42:	ffffe097          	auipc	ra,0xffffe
    80004b46:	3dc080e7          	jalr	988(ra) # 80002f1e <iunlockput>
  ip->nlink--;
    80004b4a:	05295783          	lhu	a5,82(s2)
    80004b4e:	37fd                	addiw	a5,a5,-1
    80004b50:	04f91923          	sh	a5,82(s2)
  iupdate(ip);
    80004b54:	854a                	mv	a0,s2
    80004b56:	ffffe097          	auipc	ra,0xffffe
    80004b5a:	09c080e7          	jalr	156(ra) # 80002bf2 <iupdate>
  iunlockput(ip);
    80004b5e:	854a                	mv	a0,s2
    80004b60:	ffffe097          	auipc	ra,0xffffe
    80004b64:	3be080e7          	jalr	958(ra) # 80002f1e <iunlockput>
  end_op();
    80004b68:	fffff097          	auipc	ra,0xfffff
    80004b6c:	ba6080e7          	jalr	-1114(ra) # 8000370e <end_op>
  return 0;
    80004b70:	4501                	li	a0,0
    80004b72:	a84d                	j	80004c24 <sys_unlink+0x1c4>
    end_op();
    80004b74:	fffff097          	auipc	ra,0xfffff
    80004b78:	b9a080e7          	jalr	-1126(ra) # 8000370e <end_op>
    return -1;
    80004b7c:	557d                	li	a0,-1
    80004b7e:	a05d                	j	80004c24 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004b80:	00004517          	auipc	a0,0x4
    80004b84:	b2050513          	addi	a0,a0,-1248 # 800086a0 <syscalls+0x2c8>
    80004b88:	00001097          	auipc	ra,0x1
    80004b8c:	524080e7          	jalr	1316(ra) # 800060ac <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b90:	05492703          	lw	a4,84(s2)
    80004b94:	02000793          	li	a5,32
    80004b98:	f6e7f9e3          	bgeu	a5,a4,80004b0a <sys_unlink+0xaa>
    80004b9c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ba0:	4741                	li	a4,16
    80004ba2:	86ce                	mv	a3,s3
    80004ba4:	f1840613          	addi	a2,s0,-232
    80004ba8:	4581                	li	a1,0
    80004baa:	854a                	mv	a0,s2
    80004bac:	ffffe097          	auipc	ra,0xffffe
    80004bb0:	3c4080e7          	jalr	964(ra) # 80002f70 <readi>
    80004bb4:	47c1                	li	a5,16
    80004bb6:	00f51b63          	bne	a0,a5,80004bcc <sys_unlink+0x16c>
    if(de.inum != 0)
    80004bba:	f1845783          	lhu	a5,-232(s0)
    80004bbe:	e7a1                	bnez	a5,80004c06 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bc0:	29c1                	addiw	s3,s3,16
    80004bc2:	05492783          	lw	a5,84(s2)
    80004bc6:	fcf9ede3          	bltu	s3,a5,80004ba0 <sys_unlink+0x140>
    80004bca:	b781                	j	80004b0a <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004bcc:	00004517          	auipc	a0,0x4
    80004bd0:	aec50513          	addi	a0,a0,-1300 # 800086b8 <syscalls+0x2e0>
    80004bd4:	00001097          	auipc	ra,0x1
    80004bd8:	4d8080e7          	jalr	1240(ra) # 800060ac <panic>
    panic("unlink: writei");
    80004bdc:	00004517          	auipc	a0,0x4
    80004be0:	af450513          	addi	a0,a0,-1292 # 800086d0 <syscalls+0x2f8>
    80004be4:	00001097          	auipc	ra,0x1
    80004be8:	4c8080e7          	jalr	1224(ra) # 800060ac <panic>
    dp->nlink--;
    80004bec:	0524d783          	lhu	a5,82(s1)
    80004bf0:	37fd                	addiw	a5,a5,-1
    80004bf2:	04f49923          	sh	a5,82(s1)
    iupdate(dp);
    80004bf6:	8526                	mv	a0,s1
    80004bf8:	ffffe097          	auipc	ra,0xffffe
    80004bfc:	ffa080e7          	jalr	-6(ra) # 80002bf2 <iupdate>
    80004c00:	b781                	j	80004b40 <sys_unlink+0xe0>
    return -1;
    80004c02:	557d                	li	a0,-1
    80004c04:	a005                	j	80004c24 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c06:	854a                	mv	a0,s2
    80004c08:	ffffe097          	auipc	ra,0xffffe
    80004c0c:	316080e7          	jalr	790(ra) # 80002f1e <iunlockput>
  iunlockput(dp);
    80004c10:	8526                	mv	a0,s1
    80004c12:	ffffe097          	auipc	ra,0xffffe
    80004c16:	30c080e7          	jalr	780(ra) # 80002f1e <iunlockput>
  end_op();
    80004c1a:	fffff097          	auipc	ra,0xfffff
    80004c1e:	af4080e7          	jalr	-1292(ra) # 8000370e <end_op>
  return -1;
    80004c22:	557d                	li	a0,-1
}
    80004c24:	70ae                	ld	ra,232(sp)
    80004c26:	740e                	ld	s0,224(sp)
    80004c28:	64ee                	ld	s1,216(sp)
    80004c2a:	694e                	ld	s2,208(sp)
    80004c2c:	69ae                	ld	s3,200(sp)
    80004c2e:	616d                	addi	sp,sp,240
    80004c30:	8082                	ret

0000000080004c32 <sys_open>:

uint64
sys_open(void)
{
    80004c32:	7131                	addi	sp,sp,-192
    80004c34:	fd06                	sd	ra,184(sp)
    80004c36:	f922                	sd	s0,176(sp)
    80004c38:	f526                	sd	s1,168(sp)
    80004c3a:	f14a                	sd	s2,160(sp)
    80004c3c:	ed4e                	sd	s3,152(sp)
    80004c3e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c40:	08000613          	li	a2,128
    80004c44:	f5040593          	addi	a1,s0,-176
    80004c48:	4501                	li	a0,0
    80004c4a:	ffffd097          	auipc	ra,0xffffd
    80004c4e:	416080e7          	jalr	1046(ra) # 80002060 <argstr>
    return -1;
    80004c52:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c54:	0c054163          	bltz	a0,80004d16 <sys_open+0xe4>
    80004c58:	f4c40593          	addi	a1,s0,-180
    80004c5c:	4505                	li	a0,1
    80004c5e:	ffffd097          	auipc	ra,0xffffd
    80004c62:	3be080e7          	jalr	958(ra) # 8000201c <argint>
    80004c66:	0a054863          	bltz	a0,80004d16 <sys_open+0xe4>

  begin_op();
    80004c6a:	fffff097          	auipc	ra,0xfffff
    80004c6e:	a24080e7          	jalr	-1500(ra) # 8000368e <begin_op>

  if(omode & O_CREATE){
    80004c72:	f4c42783          	lw	a5,-180(s0)
    80004c76:	2007f793          	andi	a5,a5,512
    80004c7a:	cbdd                	beqz	a5,80004d30 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c7c:	4681                	li	a3,0
    80004c7e:	4601                	li	a2,0
    80004c80:	4589                	li	a1,2
    80004c82:	f5040513          	addi	a0,s0,-176
    80004c86:	00000097          	auipc	ra,0x0
    80004c8a:	972080e7          	jalr	-1678(ra) # 800045f8 <create>
    80004c8e:	892a                	mv	s2,a0
    if(ip == 0){
    80004c90:	c959                	beqz	a0,80004d26 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c92:	04c91703          	lh	a4,76(s2)
    80004c96:	478d                	li	a5,3
    80004c98:	00f71763          	bne	a4,a5,80004ca6 <sys_open+0x74>
    80004c9c:	04e95703          	lhu	a4,78(s2)
    80004ca0:	47a5                	li	a5,9
    80004ca2:	0ce7ec63          	bltu	a5,a4,80004d7a <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004ca6:	fffff097          	auipc	ra,0xfffff
    80004caa:	df8080e7          	jalr	-520(ra) # 80003a9e <filealloc>
    80004cae:	89aa                	mv	s3,a0
    80004cb0:	10050263          	beqz	a0,80004db4 <sys_open+0x182>
    80004cb4:	00000097          	auipc	ra,0x0
    80004cb8:	902080e7          	jalr	-1790(ra) # 800045b6 <fdalloc>
    80004cbc:	84aa                	mv	s1,a0
    80004cbe:	0e054663          	bltz	a0,80004daa <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004cc2:	04c91703          	lh	a4,76(s2)
    80004cc6:	478d                	li	a5,3
    80004cc8:	0cf70463          	beq	a4,a5,80004d90 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004ccc:	4789                	li	a5,2
    80004cce:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004cd2:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004cd6:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004cda:	f4c42783          	lw	a5,-180(s0)
    80004cde:	0017c713          	xori	a4,a5,1
    80004ce2:	8b05                	andi	a4,a4,1
    80004ce4:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004ce8:	0037f713          	andi	a4,a5,3
    80004cec:	00e03733          	snez	a4,a4
    80004cf0:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004cf4:	4007f793          	andi	a5,a5,1024
    80004cf8:	c791                	beqz	a5,80004d04 <sys_open+0xd2>
    80004cfa:	04c91703          	lh	a4,76(s2)
    80004cfe:	4789                	li	a5,2
    80004d00:	08f70f63          	beq	a4,a5,80004d9e <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004d04:	854a                	mv	a0,s2
    80004d06:	ffffe097          	auipc	ra,0xffffe
    80004d0a:	078080e7          	jalr	120(ra) # 80002d7e <iunlock>
  end_op();
    80004d0e:	fffff097          	auipc	ra,0xfffff
    80004d12:	a00080e7          	jalr	-1536(ra) # 8000370e <end_op>

  return fd;
}
    80004d16:	8526                	mv	a0,s1
    80004d18:	70ea                	ld	ra,184(sp)
    80004d1a:	744a                	ld	s0,176(sp)
    80004d1c:	74aa                	ld	s1,168(sp)
    80004d1e:	790a                	ld	s2,160(sp)
    80004d20:	69ea                	ld	s3,152(sp)
    80004d22:	6129                	addi	sp,sp,192
    80004d24:	8082                	ret
      end_op();
    80004d26:	fffff097          	auipc	ra,0xfffff
    80004d2a:	9e8080e7          	jalr	-1560(ra) # 8000370e <end_op>
      return -1;
    80004d2e:	b7e5                	j	80004d16 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d30:	f5040513          	addi	a0,s0,-176
    80004d34:	ffffe097          	auipc	ra,0xffffe
    80004d38:	73e080e7          	jalr	1854(ra) # 80003472 <namei>
    80004d3c:	892a                	mv	s2,a0
    80004d3e:	c905                	beqz	a0,80004d6e <sys_open+0x13c>
    ilock(ip);
    80004d40:	ffffe097          	auipc	ra,0xffffe
    80004d44:	f7c080e7          	jalr	-132(ra) # 80002cbc <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d48:	04c91703          	lh	a4,76(s2)
    80004d4c:	4785                	li	a5,1
    80004d4e:	f4f712e3          	bne	a4,a5,80004c92 <sys_open+0x60>
    80004d52:	f4c42783          	lw	a5,-180(s0)
    80004d56:	dba1                	beqz	a5,80004ca6 <sys_open+0x74>
      iunlockput(ip);
    80004d58:	854a                	mv	a0,s2
    80004d5a:	ffffe097          	auipc	ra,0xffffe
    80004d5e:	1c4080e7          	jalr	452(ra) # 80002f1e <iunlockput>
      end_op();
    80004d62:	fffff097          	auipc	ra,0xfffff
    80004d66:	9ac080e7          	jalr	-1620(ra) # 8000370e <end_op>
      return -1;
    80004d6a:	54fd                	li	s1,-1
    80004d6c:	b76d                	j	80004d16 <sys_open+0xe4>
      end_op();
    80004d6e:	fffff097          	auipc	ra,0xfffff
    80004d72:	9a0080e7          	jalr	-1632(ra) # 8000370e <end_op>
      return -1;
    80004d76:	54fd                	li	s1,-1
    80004d78:	bf79                	j	80004d16 <sys_open+0xe4>
    iunlockput(ip);
    80004d7a:	854a                	mv	a0,s2
    80004d7c:	ffffe097          	auipc	ra,0xffffe
    80004d80:	1a2080e7          	jalr	418(ra) # 80002f1e <iunlockput>
    end_op();
    80004d84:	fffff097          	auipc	ra,0xfffff
    80004d88:	98a080e7          	jalr	-1654(ra) # 8000370e <end_op>
    return -1;
    80004d8c:	54fd                	li	s1,-1
    80004d8e:	b761                	j	80004d16 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004d90:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004d94:	04e91783          	lh	a5,78(s2)
    80004d98:	02f99223          	sh	a5,36(s3)
    80004d9c:	bf2d                	j	80004cd6 <sys_open+0xa4>
    itrunc(ip);
    80004d9e:	854a                	mv	a0,s2
    80004da0:	ffffe097          	auipc	ra,0xffffe
    80004da4:	02a080e7          	jalr	42(ra) # 80002dca <itrunc>
    80004da8:	bfb1                	j	80004d04 <sys_open+0xd2>
      fileclose(f);
    80004daa:	854e                	mv	a0,s3
    80004dac:	fffff097          	auipc	ra,0xfffff
    80004db0:	dae080e7          	jalr	-594(ra) # 80003b5a <fileclose>
    iunlockput(ip);
    80004db4:	854a                	mv	a0,s2
    80004db6:	ffffe097          	auipc	ra,0xffffe
    80004dba:	168080e7          	jalr	360(ra) # 80002f1e <iunlockput>
    end_op();
    80004dbe:	fffff097          	auipc	ra,0xfffff
    80004dc2:	950080e7          	jalr	-1712(ra) # 8000370e <end_op>
    return -1;
    80004dc6:	54fd                	li	s1,-1
    80004dc8:	b7b9                	j	80004d16 <sys_open+0xe4>

0000000080004dca <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004dca:	7175                	addi	sp,sp,-144
    80004dcc:	e506                	sd	ra,136(sp)
    80004dce:	e122                	sd	s0,128(sp)
    80004dd0:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004dd2:	fffff097          	auipc	ra,0xfffff
    80004dd6:	8bc080e7          	jalr	-1860(ra) # 8000368e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004dda:	08000613          	li	a2,128
    80004dde:	f7040593          	addi	a1,s0,-144
    80004de2:	4501                	li	a0,0
    80004de4:	ffffd097          	auipc	ra,0xffffd
    80004de8:	27c080e7          	jalr	636(ra) # 80002060 <argstr>
    80004dec:	02054963          	bltz	a0,80004e1e <sys_mkdir+0x54>
    80004df0:	4681                	li	a3,0
    80004df2:	4601                	li	a2,0
    80004df4:	4585                	li	a1,1
    80004df6:	f7040513          	addi	a0,s0,-144
    80004dfa:	fffff097          	auipc	ra,0xfffff
    80004dfe:	7fe080e7          	jalr	2046(ra) # 800045f8 <create>
    80004e02:	cd11                	beqz	a0,80004e1e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e04:	ffffe097          	auipc	ra,0xffffe
    80004e08:	11a080e7          	jalr	282(ra) # 80002f1e <iunlockput>
  end_op();
    80004e0c:	fffff097          	auipc	ra,0xfffff
    80004e10:	902080e7          	jalr	-1790(ra) # 8000370e <end_op>
  return 0;
    80004e14:	4501                	li	a0,0
}
    80004e16:	60aa                	ld	ra,136(sp)
    80004e18:	640a                	ld	s0,128(sp)
    80004e1a:	6149                	addi	sp,sp,144
    80004e1c:	8082                	ret
    end_op();
    80004e1e:	fffff097          	auipc	ra,0xfffff
    80004e22:	8f0080e7          	jalr	-1808(ra) # 8000370e <end_op>
    return -1;
    80004e26:	557d                	li	a0,-1
    80004e28:	b7fd                	j	80004e16 <sys_mkdir+0x4c>

0000000080004e2a <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e2a:	7135                	addi	sp,sp,-160
    80004e2c:	ed06                	sd	ra,152(sp)
    80004e2e:	e922                	sd	s0,144(sp)
    80004e30:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e32:	fffff097          	auipc	ra,0xfffff
    80004e36:	85c080e7          	jalr	-1956(ra) # 8000368e <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e3a:	08000613          	li	a2,128
    80004e3e:	f7040593          	addi	a1,s0,-144
    80004e42:	4501                	li	a0,0
    80004e44:	ffffd097          	auipc	ra,0xffffd
    80004e48:	21c080e7          	jalr	540(ra) # 80002060 <argstr>
    80004e4c:	04054a63          	bltz	a0,80004ea0 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004e50:	f6c40593          	addi	a1,s0,-148
    80004e54:	4505                	li	a0,1
    80004e56:	ffffd097          	auipc	ra,0xffffd
    80004e5a:	1c6080e7          	jalr	454(ra) # 8000201c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e5e:	04054163          	bltz	a0,80004ea0 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004e62:	f6840593          	addi	a1,s0,-152
    80004e66:	4509                	li	a0,2
    80004e68:	ffffd097          	auipc	ra,0xffffd
    80004e6c:	1b4080e7          	jalr	436(ra) # 8000201c <argint>
     argint(1, &major) < 0 ||
    80004e70:	02054863          	bltz	a0,80004ea0 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e74:	f6841683          	lh	a3,-152(s0)
    80004e78:	f6c41603          	lh	a2,-148(s0)
    80004e7c:	458d                	li	a1,3
    80004e7e:	f7040513          	addi	a0,s0,-144
    80004e82:	fffff097          	auipc	ra,0xfffff
    80004e86:	776080e7          	jalr	1910(ra) # 800045f8 <create>
     argint(2, &minor) < 0 ||
    80004e8a:	c919                	beqz	a0,80004ea0 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e8c:	ffffe097          	auipc	ra,0xffffe
    80004e90:	092080e7          	jalr	146(ra) # 80002f1e <iunlockput>
  end_op();
    80004e94:	fffff097          	auipc	ra,0xfffff
    80004e98:	87a080e7          	jalr	-1926(ra) # 8000370e <end_op>
  return 0;
    80004e9c:	4501                	li	a0,0
    80004e9e:	a031                	j	80004eaa <sys_mknod+0x80>
    end_op();
    80004ea0:	fffff097          	auipc	ra,0xfffff
    80004ea4:	86e080e7          	jalr	-1938(ra) # 8000370e <end_op>
    return -1;
    80004ea8:	557d                	li	a0,-1
}
    80004eaa:	60ea                	ld	ra,152(sp)
    80004eac:	644a                	ld	s0,144(sp)
    80004eae:	610d                	addi	sp,sp,160
    80004eb0:	8082                	ret

0000000080004eb2 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004eb2:	7135                	addi	sp,sp,-160
    80004eb4:	ed06                	sd	ra,152(sp)
    80004eb6:	e922                	sd	s0,144(sp)
    80004eb8:	e526                	sd	s1,136(sp)
    80004eba:	e14a                	sd	s2,128(sp)
    80004ebc:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004ebe:	ffffc097          	auipc	ra,0xffffc
    80004ec2:	0b2080e7          	jalr	178(ra) # 80000f70 <myproc>
    80004ec6:	892a                	mv	s2,a0
  
  begin_op();
    80004ec8:	ffffe097          	auipc	ra,0xffffe
    80004ecc:	7c6080e7          	jalr	1990(ra) # 8000368e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004ed0:	08000613          	li	a2,128
    80004ed4:	f6040593          	addi	a1,s0,-160
    80004ed8:	4501                	li	a0,0
    80004eda:	ffffd097          	auipc	ra,0xffffd
    80004ede:	186080e7          	jalr	390(ra) # 80002060 <argstr>
    80004ee2:	04054b63          	bltz	a0,80004f38 <sys_chdir+0x86>
    80004ee6:	f6040513          	addi	a0,s0,-160
    80004eea:	ffffe097          	auipc	ra,0xffffe
    80004eee:	588080e7          	jalr	1416(ra) # 80003472 <namei>
    80004ef2:	84aa                	mv	s1,a0
    80004ef4:	c131                	beqz	a0,80004f38 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004ef6:	ffffe097          	auipc	ra,0xffffe
    80004efa:	dc6080e7          	jalr	-570(ra) # 80002cbc <ilock>
  if(ip->type != T_DIR){
    80004efe:	04c49703          	lh	a4,76(s1)
    80004f02:	4785                	li	a5,1
    80004f04:	04f71063          	bne	a4,a5,80004f44 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f08:	8526                	mv	a0,s1
    80004f0a:	ffffe097          	auipc	ra,0xffffe
    80004f0e:	e74080e7          	jalr	-396(ra) # 80002d7e <iunlock>
  iput(p->cwd);
    80004f12:	15893503          	ld	a0,344(s2)
    80004f16:	ffffe097          	auipc	ra,0xffffe
    80004f1a:	f60080e7          	jalr	-160(ra) # 80002e76 <iput>
  end_op();
    80004f1e:	ffffe097          	auipc	ra,0xffffe
    80004f22:	7f0080e7          	jalr	2032(ra) # 8000370e <end_op>
  p->cwd = ip;
    80004f26:	14993c23          	sd	s1,344(s2)
  return 0;
    80004f2a:	4501                	li	a0,0
}
    80004f2c:	60ea                	ld	ra,152(sp)
    80004f2e:	644a                	ld	s0,144(sp)
    80004f30:	64aa                	ld	s1,136(sp)
    80004f32:	690a                	ld	s2,128(sp)
    80004f34:	610d                	addi	sp,sp,160
    80004f36:	8082                	ret
    end_op();
    80004f38:	ffffe097          	auipc	ra,0xffffe
    80004f3c:	7d6080e7          	jalr	2006(ra) # 8000370e <end_op>
    return -1;
    80004f40:	557d                	li	a0,-1
    80004f42:	b7ed                	j	80004f2c <sys_chdir+0x7a>
    iunlockput(ip);
    80004f44:	8526                	mv	a0,s1
    80004f46:	ffffe097          	auipc	ra,0xffffe
    80004f4a:	fd8080e7          	jalr	-40(ra) # 80002f1e <iunlockput>
    end_op();
    80004f4e:	ffffe097          	auipc	ra,0xffffe
    80004f52:	7c0080e7          	jalr	1984(ra) # 8000370e <end_op>
    return -1;
    80004f56:	557d                	li	a0,-1
    80004f58:	bfd1                	j	80004f2c <sys_chdir+0x7a>

0000000080004f5a <sys_exec>:

uint64
sys_exec(void)
{
    80004f5a:	7145                	addi	sp,sp,-464
    80004f5c:	e786                	sd	ra,456(sp)
    80004f5e:	e3a2                	sd	s0,448(sp)
    80004f60:	ff26                	sd	s1,440(sp)
    80004f62:	fb4a                	sd	s2,432(sp)
    80004f64:	f74e                	sd	s3,424(sp)
    80004f66:	f352                	sd	s4,416(sp)
    80004f68:	ef56                	sd	s5,408(sp)
    80004f6a:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f6c:	08000613          	li	a2,128
    80004f70:	f4040593          	addi	a1,s0,-192
    80004f74:	4501                	li	a0,0
    80004f76:	ffffd097          	auipc	ra,0xffffd
    80004f7a:	0ea080e7          	jalr	234(ra) # 80002060 <argstr>
    return -1;
    80004f7e:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f80:	0c054a63          	bltz	a0,80005054 <sys_exec+0xfa>
    80004f84:	e3840593          	addi	a1,s0,-456
    80004f88:	4505                	li	a0,1
    80004f8a:	ffffd097          	auipc	ra,0xffffd
    80004f8e:	0b4080e7          	jalr	180(ra) # 8000203e <argaddr>
    80004f92:	0c054163          	bltz	a0,80005054 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004f96:	10000613          	li	a2,256
    80004f9a:	4581                	li	a1,0
    80004f9c:	e4040513          	addi	a0,s0,-448
    80004fa0:	ffffb097          	auipc	ra,0xffffb
    80004fa4:	2f0080e7          	jalr	752(ra) # 80000290 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004fa8:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004fac:	89a6                	mv	s3,s1
    80004fae:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004fb0:	02000a13          	li	s4,32
    80004fb4:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004fb8:	00391513          	slli	a0,s2,0x3
    80004fbc:	e3040593          	addi	a1,s0,-464
    80004fc0:	e3843783          	ld	a5,-456(s0)
    80004fc4:	953e                	add	a0,a0,a5
    80004fc6:	ffffd097          	auipc	ra,0xffffd
    80004fca:	fbc080e7          	jalr	-68(ra) # 80001f82 <fetchaddr>
    80004fce:	02054a63          	bltz	a0,80005002 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004fd2:	e3043783          	ld	a5,-464(s0)
    80004fd6:	c3b9                	beqz	a5,8000501c <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004fd8:	ffffb097          	auipc	ra,0xffffb
    80004fdc:	1b0080e7          	jalr	432(ra) # 80000188 <kalloc>
    80004fe0:	85aa                	mv	a1,a0
    80004fe2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004fe6:	cd11                	beqz	a0,80005002 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004fe8:	6605                	lui	a2,0x1
    80004fea:	e3043503          	ld	a0,-464(s0)
    80004fee:	ffffd097          	auipc	ra,0xffffd
    80004ff2:	fe6080e7          	jalr	-26(ra) # 80001fd4 <fetchstr>
    80004ff6:	00054663          	bltz	a0,80005002 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004ffa:	0905                	addi	s2,s2,1
    80004ffc:	09a1                	addi	s3,s3,8
    80004ffe:	fb491be3          	bne	s2,s4,80004fb4 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005002:	10048913          	addi	s2,s1,256
    80005006:	6088                	ld	a0,0(s1)
    80005008:	c529                	beqz	a0,80005052 <sys_exec+0xf8>
    kfree(argv[i]);
    8000500a:	ffffb097          	auipc	ra,0xffffb
    8000500e:	012080e7          	jalr	18(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005012:	04a1                	addi	s1,s1,8
    80005014:	ff2499e3          	bne	s1,s2,80005006 <sys_exec+0xac>
  return -1;
    80005018:	597d                	li	s2,-1
    8000501a:	a82d                	j	80005054 <sys_exec+0xfa>
      argv[i] = 0;
    8000501c:	0a8e                	slli	s5,s5,0x3
    8000501e:	fc040793          	addi	a5,s0,-64
    80005022:	9abe                	add	s5,s5,a5
    80005024:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005028:	e4040593          	addi	a1,s0,-448
    8000502c:	f4040513          	addi	a0,s0,-192
    80005030:	fffff097          	auipc	ra,0xfffff
    80005034:	194080e7          	jalr	404(ra) # 800041c4 <exec>
    80005038:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000503a:	10048993          	addi	s3,s1,256
    8000503e:	6088                	ld	a0,0(s1)
    80005040:	c911                	beqz	a0,80005054 <sys_exec+0xfa>
    kfree(argv[i]);
    80005042:	ffffb097          	auipc	ra,0xffffb
    80005046:	fda080e7          	jalr	-38(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000504a:	04a1                	addi	s1,s1,8
    8000504c:	ff3499e3          	bne	s1,s3,8000503e <sys_exec+0xe4>
    80005050:	a011                	j	80005054 <sys_exec+0xfa>
  return -1;
    80005052:	597d                	li	s2,-1
}
    80005054:	854a                	mv	a0,s2
    80005056:	60be                	ld	ra,456(sp)
    80005058:	641e                	ld	s0,448(sp)
    8000505a:	74fa                	ld	s1,440(sp)
    8000505c:	795a                	ld	s2,432(sp)
    8000505e:	79ba                	ld	s3,424(sp)
    80005060:	7a1a                	ld	s4,416(sp)
    80005062:	6afa                	ld	s5,408(sp)
    80005064:	6179                	addi	sp,sp,464
    80005066:	8082                	ret

0000000080005068 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005068:	7139                	addi	sp,sp,-64
    8000506a:	fc06                	sd	ra,56(sp)
    8000506c:	f822                	sd	s0,48(sp)
    8000506e:	f426                	sd	s1,40(sp)
    80005070:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005072:	ffffc097          	auipc	ra,0xffffc
    80005076:	efe080e7          	jalr	-258(ra) # 80000f70 <myproc>
    8000507a:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    8000507c:	fd840593          	addi	a1,s0,-40
    80005080:	4501                	li	a0,0
    80005082:	ffffd097          	auipc	ra,0xffffd
    80005086:	fbc080e7          	jalr	-68(ra) # 8000203e <argaddr>
    return -1;
    8000508a:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    8000508c:	0e054063          	bltz	a0,8000516c <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005090:	fc840593          	addi	a1,s0,-56
    80005094:	fd040513          	addi	a0,s0,-48
    80005098:	fffff097          	auipc	ra,0xfffff
    8000509c:	df2080e7          	jalr	-526(ra) # 80003e8a <pipealloc>
    return -1;
    800050a0:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800050a2:	0c054563          	bltz	a0,8000516c <sys_pipe+0x104>
  fd0 = -1;
    800050a6:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800050aa:	fd043503          	ld	a0,-48(s0)
    800050ae:	fffff097          	auipc	ra,0xfffff
    800050b2:	508080e7          	jalr	1288(ra) # 800045b6 <fdalloc>
    800050b6:	fca42223          	sw	a0,-60(s0)
    800050ba:	08054c63          	bltz	a0,80005152 <sys_pipe+0xea>
    800050be:	fc843503          	ld	a0,-56(s0)
    800050c2:	fffff097          	auipc	ra,0xfffff
    800050c6:	4f4080e7          	jalr	1268(ra) # 800045b6 <fdalloc>
    800050ca:	fca42023          	sw	a0,-64(s0)
    800050ce:	06054863          	bltz	a0,8000513e <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050d2:	4691                	li	a3,4
    800050d4:	fc440613          	addi	a2,s0,-60
    800050d8:	fd843583          	ld	a1,-40(s0)
    800050dc:	6ca8                	ld	a0,88(s1)
    800050de:	ffffc097          	auipc	ra,0xffffc
    800050e2:	b54080e7          	jalr	-1196(ra) # 80000c32 <copyout>
    800050e6:	02054063          	bltz	a0,80005106 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800050ea:	4691                	li	a3,4
    800050ec:	fc040613          	addi	a2,s0,-64
    800050f0:	fd843583          	ld	a1,-40(s0)
    800050f4:	0591                	addi	a1,a1,4
    800050f6:	6ca8                	ld	a0,88(s1)
    800050f8:	ffffc097          	auipc	ra,0xffffc
    800050fc:	b3a080e7          	jalr	-1222(ra) # 80000c32 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005100:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005102:	06055563          	bgez	a0,8000516c <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005106:	fc442783          	lw	a5,-60(s0)
    8000510a:	07e9                	addi	a5,a5,26
    8000510c:	078e                	slli	a5,a5,0x3
    8000510e:	97a6                	add	a5,a5,s1
    80005110:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005114:	fc042503          	lw	a0,-64(s0)
    80005118:	0569                	addi	a0,a0,26
    8000511a:	050e                	slli	a0,a0,0x3
    8000511c:	9526                	add	a0,a0,s1
    8000511e:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005122:	fd043503          	ld	a0,-48(s0)
    80005126:	fffff097          	auipc	ra,0xfffff
    8000512a:	a34080e7          	jalr	-1484(ra) # 80003b5a <fileclose>
    fileclose(wf);
    8000512e:	fc843503          	ld	a0,-56(s0)
    80005132:	fffff097          	auipc	ra,0xfffff
    80005136:	a28080e7          	jalr	-1496(ra) # 80003b5a <fileclose>
    return -1;
    8000513a:	57fd                	li	a5,-1
    8000513c:	a805                	j	8000516c <sys_pipe+0x104>
    if(fd0 >= 0)
    8000513e:	fc442783          	lw	a5,-60(s0)
    80005142:	0007c863          	bltz	a5,80005152 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005146:	01a78513          	addi	a0,a5,26
    8000514a:	050e                	slli	a0,a0,0x3
    8000514c:	9526                	add	a0,a0,s1
    8000514e:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005152:	fd043503          	ld	a0,-48(s0)
    80005156:	fffff097          	auipc	ra,0xfffff
    8000515a:	a04080e7          	jalr	-1532(ra) # 80003b5a <fileclose>
    fileclose(wf);
    8000515e:	fc843503          	ld	a0,-56(s0)
    80005162:	fffff097          	auipc	ra,0xfffff
    80005166:	9f8080e7          	jalr	-1544(ra) # 80003b5a <fileclose>
    return -1;
    8000516a:	57fd                	li	a5,-1
}
    8000516c:	853e                	mv	a0,a5
    8000516e:	70e2                	ld	ra,56(sp)
    80005170:	7442                	ld	s0,48(sp)
    80005172:	74a2                	ld	s1,40(sp)
    80005174:	6121                	addi	sp,sp,64
    80005176:	8082                	ret
	...

0000000080005180 <kernelvec>:
    80005180:	7111                	addi	sp,sp,-256
    80005182:	e006                	sd	ra,0(sp)
    80005184:	e40a                	sd	sp,8(sp)
    80005186:	e80e                	sd	gp,16(sp)
    80005188:	ec12                	sd	tp,24(sp)
    8000518a:	f016                	sd	t0,32(sp)
    8000518c:	f41a                	sd	t1,40(sp)
    8000518e:	f81e                	sd	t2,48(sp)
    80005190:	fc22                	sd	s0,56(sp)
    80005192:	e0a6                	sd	s1,64(sp)
    80005194:	e4aa                	sd	a0,72(sp)
    80005196:	e8ae                	sd	a1,80(sp)
    80005198:	ecb2                	sd	a2,88(sp)
    8000519a:	f0b6                	sd	a3,96(sp)
    8000519c:	f4ba                	sd	a4,104(sp)
    8000519e:	f8be                	sd	a5,112(sp)
    800051a0:	fcc2                	sd	a6,120(sp)
    800051a2:	e146                	sd	a7,128(sp)
    800051a4:	e54a                	sd	s2,136(sp)
    800051a6:	e94e                	sd	s3,144(sp)
    800051a8:	ed52                	sd	s4,152(sp)
    800051aa:	f156                	sd	s5,160(sp)
    800051ac:	f55a                	sd	s6,168(sp)
    800051ae:	f95e                	sd	s7,176(sp)
    800051b0:	fd62                	sd	s8,184(sp)
    800051b2:	e1e6                	sd	s9,192(sp)
    800051b4:	e5ea                	sd	s10,200(sp)
    800051b6:	e9ee                	sd	s11,208(sp)
    800051b8:	edf2                	sd	t3,216(sp)
    800051ba:	f1f6                	sd	t4,224(sp)
    800051bc:	f5fa                	sd	t5,232(sp)
    800051be:	f9fe                	sd	t6,240(sp)
    800051c0:	c8ffc0ef          	jal	ra,80001e4e <kerneltrap>
    800051c4:	6082                	ld	ra,0(sp)
    800051c6:	6122                	ld	sp,8(sp)
    800051c8:	61c2                	ld	gp,16(sp)
    800051ca:	7282                	ld	t0,32(sp)
    800051cc:	7322                	ld	t1,40(sp)
    800051ce:	73c2                	ld	t2,48(sp)
    800051d0:	7462                	ld	s0,56(sp)
    800051d2:	6486                	ld	s1,64(sp)
    800051d4:	6526                	ld	a0,72(sp)
    800051d6:	65c6                	ld	a1,80(sp)
    800051d8:	6666                	ld	a2,88(sp)
    800051da:	7686                	ld	a3,96(sp)
    800051dc:	7726                	ld	a4,104(sp)
    800051de:	77c6                	ld	a5,112(sp)
    800051e0:	7866                	ld	a6,120(sp)
    800051e2:	688a                	ld	a7,128(sp)
    800051e4:	692a                	ld	s2,136(sp)
    800051e6:	69ca                	ld	s3,144(sp)
    800051e8:	6a6a                	ld	s4,152(sp)
    800051ea:	7a8a                	ld	s5,160(sp)
    800051ec:	7b2a                	ld	s6,168(sp)
    800051ee:	7bca                	ld	s7,176(sp)
    800051f0:	7c6a                	ld	s8,184(sp)
    800051f2:	6c8e                	ld	s9,192(sp)
    800051f4:	6d2e                	ld	s10,200(sp)
    800051f6:	6dce                	ld	s11,208(sp)
    800051f8:	6e6e                	ld	t3,216(sp)
    800051fa:	7e8e                	ld	t4,224(sp)
    800051fc:	7f2e                	ld	t5,232(sp)
    800051fe:	7fce                	ld	t6,240(sp)
    80005200:	6111                	addi	sp,sp,256
    80005202:	10200073          	sret
    80005206:	00000013          	nop
    8000520a:	00000013          	nop
    8000520e:	0001                	nop

0000000080005210 <timervec>:
    80005210:	34051573          	csrrw	a0,mscratch,a0
    80005214:	e10c                	sd	a1,0(a0)
    80005216:	e510                	sd	a2,8(a0)
    80005218:	e914                	sd	a3,16(a0)
    8000521a:	6d0c                	ld	a1,24(a0)
    8000521c:	7110                	ld	a2,32(a0)
    8000521e:	6194                	ld	a3,0(a1)
    80005220:	96b2                	add	a3,a3,a2
    80005222:	e194                	sd	a3,0(a1)
    80005224:	4589                	li	a1,2
    80005226:	14459073          	csrw	sip,a1
    8000522a:	6914                	ld	a3,16(a0)
    8000522c:	6510                	ld	a2,8(a0)
    8000522e:	610c                	ld	a1,0(a0)
    80005230:	34051573          	csrrw	a0,mscratch,a0
    80005234:	30200073          	mret
	...

000000008000523a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000523a:	1141                	addi	sp,sp,-16
    8000523c:	e422                	sd	s0,8(sp)
    8000523e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005240:	0c0007b7          	lui	a5,0xc000
    80005244:	4705                	li	a4,1
    80005246:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005248:	c3d8                	sw	a4,4(a5)
}
    8000524a:	6422                	ld	s0,8(sp)
    8000524c:	0141                	addi	sp,sp,16
    8000524e:	8082                	ret

0000000080005250 <plicinithart>:

void
plicinithart(void)
{
    80005250:	1141                	addi	sp,sp,-16
    80005252:	e406                	sd	ra,8(sp)
    80005254:	e022                	sd	s0,0(sp)
    80005256:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005258:	ffffc097          	auipc	ra,0xffffc
    8000525c:	cec080e7          	jalr	-788(ra) # 80000f44 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005260:	0085171b          	slliw	a4,a0,0x8
    80005264:	0c0027b7          	lui	a5,0xc002
    80005268:	97ba                	add	a5,a5,a4
    8000526a:	40200713          	li	a4,1026
    8000526e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005272:	00d5151b          	slliw	a0,a0,0xd
    80005276:	0c2017b7          	lui	a5,0xc201
    8000527a:	953e                	add	a0,a0,a5
    8000527c:	00052023          	sw	zero,0(a0)
}
    80005280:	60a2                	ld	ra,8(sp)
    80005282:	6402                	ld	s0,0(sp)
    80005284:	0141                	addi	sp,sp,16
    80005286:	8082                	ret

0000000080005288 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005288:	1141                	addi	sp,sp,-16
    8000528a:	e406                	sd	ra,8(sp)
    8000528c:	e022                	sd	s0,0(sp)
    8000528e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005290:	ffffc097          	auipc	ra,0xffffc
    80005294:	cb4080e7          	jalr	-844(ra) # 80000f44 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005298:	00d5179b          	slliw	a5,a0,0xd
    8000529c:	0c201537          	lui	a0,0xc201
    800052a0:	953e                	add	a0,a0,a5
  return irq;
}
    800052a2:	4148                	lw	a0,4(a0)
    800052a4:	60a2                	ld	ra,8(sp)
    800052a6:	6402                	ld	s0,0(sp)
    800052a8:	0141                	addi	sp,sp,16
    800052aa:	8082                	ret

00000000800052ac <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800052ac:	1101                	addi	sp,sp,-32
    800052ae:	ec06                	sd	ra,24(sp)
    800052b0:	e822                	sd	s0,16(sp)
    800052b2:	e426                	sd	s1,8(sp)
    800052b4:	1000                	addi	s0,sp,32
    800052b6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800052b8:	ffffc097          	auipc	ra,0xffffc
    800052bc:	c8c080e7          	jalr	-884(ra) # 80000f44 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800052c0:	00d5151b          	slliw	a0,a0,0xd
    800052c4:	0c2017b7          	lui	a5,0xc201
    800052c8:	97aa                	add	a5,a5,a0
    800052ca:	c3c4                	sw	s1,4(a5)
}
    800052cc:	60e2                	ld	ra,24(sp)
    800052ce:	6442                	ld	s0,16(sp)
    800052d0:	64a2                	ld	s1,8(sp)
    800052d2:	6105                	addi	sp,sp,32
    800052d4:	8082                	ret

00000000800052d6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800052d6:	1141                	addi	sp,sp,-16
    800052d8:	e406                	sd	ra,8(sp)
    800052da:	e022                	sd	s0,0(sp)
    800052dc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800052de:	479d                	li	a5,7
    800052e0:	06a7c963          	blt	a5,a0,80005352 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800052e4:	00019797          	auipc	a5,0x19
    800052e8:	d1c78793          	addi	a5,a5,-740 # 8001e000 <disk>
    800052ec:	00a78733          	add	a4,a5,a0
    800052f0:	6789                	lui	a5,0x2
    800052f2:	97ba                	add	a5,a5,a4
    800052f4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800052f8:	e7ad                	bnez	a5,80005362 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800052fa:	00451793          	slli	a5,a0,0x4
    800052fe:	0001b717          	auipc	a4,0x1b
    80005302:	d0270713          	addi	a4,a4,-766 # 80020000 <disk+0x2000>
    80005306:	6314                	ld	a3,0(a4)
    80005308:	96be                	add	a3,a3,a5
    8000530a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000530e:	6314                	ld	a3,0(a4)
    80005310:	96be                	add	a3,a3,a5
    80005312:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005316:	6314                	ld	a3,0(a4)
    80005318:	96be                	add	a3,a3,a5
    8000531a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000531e:	6318                	ld	a4,0(a4)
    80005320:	97ba                	add	a5,a5,a4
    80005322:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005326:	00019797          	auipc	a5,0x19
    8000532a:	cda78793          	addi	a5,a5,-806 # 8001e000 <disk>
    8000532e:	97aa                	add	a5,a5,a0
    80005330:	6509                	lui	a0,0x2
    80005332:	953e                	add	a0,a0,a5
    80005334:	4785                	li	a5,1
    80005336:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000533a:	0001b517          	auipc	a0,0x1b
    8000533e:	cde50513          	addi	a0,a0,-802 # 80020018 <disk+0x2018>
    80005342:	ffffc097          	auipc	ra,0xffffc
    80005346:	476080e7          	jalr	1142(ra) # 800017b8 <wakeup>
}
    8000534a:	60a2                	ld	ra,8(sp)
    8000534c:	6402                	ld	s0,0(sp)
    8000534e:	0141                	addi	sp,sp,16
    80005350:	8082                	ret
    panic("free_desc 1");
    80005352:	00003517          	auipc	a0,0x3
    80005356:	38e50513          	addi	a0,a0,910 # 800086e0 <syscalls+0x308>
    8000535a:	00001097          	auipc	ra,0x1
    8000535e:	d52080e7          	jalr	-686(ra) # 800060ac <panic>
    panic("free_desc 2");
    80005362:	00003517          	auipc	a0,0x3
    80005366:	38e50513          	addi	a0,a0,910 # 800086f0 <syscalls+0x318>
    8000536a:	00001097          	auipc	ra,0x1
    8000536e:	d42080e7          	jalr	-702(ra) # 800060ac <panic>

0000000080005372 <virtio_disk_init>:
{
    80005372:	1101                	addi	sp,sp,-32
    80005374:	ec06                	sd	ra,24(sp)
    80005376:	e822                	sd	s0,16(sp)
    80005378:	e426                	sd	s1,8(sp)
    8000537a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000537c:	00003597          	auipc	a1,0x3
    80005380:	38458593          	addi	a1,a1,900 # 80008700 <syscalls+0x328>
    80005384:	0001b517          	auipc	a0,0x1b
    80005388:	da450513          	addi	a0,a0,-604 # 80020128 <disk+0x2128>
    8000538c:	00001097          	auipc	ra,0x1
    80005390:	3d0080e7          	jalr	976(ra) # 8000675c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005394:	100017b7          	lui	a5,0x10001
    80005398:	4398                	lw	a4,0(a5)
    8000539a:	2701                	sext.w	a4,a4
    8000539c:	747277b7          	lui	a5,0x74727
    800053a0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053a4:	0ef71163          	bne	a4,a5,80005486 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053a8:	100017b7          	lui	a5,0x10001
    800053ac:	43dc                	lw	a5,4(a5)
    800053ae:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053b0:	4705                	li	a4,1
    800053b2:	0ce79a63          	bne	a5,a4,80005486 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053b6:	100017b7          	lui	a5,0x10001
    800053ba:	479c                	lw	a5,8(a5)
    800053bc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053be:	4709                	li	a4,2
    800053c0:	0ce79363          	bne	a5,a4,80005486 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800053c4:	100017b7          	lui	a5,0x10001
    800053c8:	47d8                	lw	a4,12(a5)
    800053ca:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053cc:	554d47b7          	lui	a5,0x554d4
    800053d0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800053d4:	0af71963          	bne	a4,a5,80005486 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053d8:	100017b7          	lui	a5,0x10001
    800053dc:	4705                	li	a4,1
    800053de:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053e0:	470d                	li	a4,3
    800053e2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800053e4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800053e6:	c7ffe737          	lui	a4,0xc7ffe
    800053ea:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd3517>
    800053ee:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800053f0:	2701                	sext.w	a4,a4
    800053f2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053f4:	472d                	li	a4,11
    800053f6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053f8:	473d                	li	a4,15
    800053fa:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800053fc:	6705                	lui	a4,0x1
    800053fe:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005400:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005404:	5bdc                	lw	a5,52(a5)
    80005406:	2781                	sext.w	a5,a5
  if(max == 0)
    80005408:	c7d9                	beqz	a5,80005496 <virtio_disk_init+0x124>
  if(max < NUM)
    8000540a:	471d                	li	a4,7
    8000540c:	08f77d63          	bgeu	a4,a5,800054a6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005410:	100014b7          	lui	s1,0x10001
    80005414:	47a1                	li	a5,8
    80005416:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005418:	6609                	lui	a2,0x2
    8000541a:	4581                	li	a1,0
    8000541c:	00019517          	auipc	a0,0x19
    80005420:	be450513          	addi	a0,a0,-1052 # 8001e000 <disk>
    80005424:	ffffb097          	auipc	ra,0xffffb
    80005428:	e6c080e7          	jalr	-404(ra) # 80000290 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000542c:	00019717          	auipc	a4,0x19
    80005430:	bd470713          	addi	a4,a4,-1068 # 8001e000 <disk>
    80005434:	00c75793          	srli	a5,a4,0xc
    80005438:	2781                	sext.w	a5,a5
    8000543a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000543c:	0001b797          	auipc	a5,0x1b
    80005440:	bc478793          	addi	a5,a5,-1084 # 80020000 <disk+0x2000>
    80005444:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005446:	00019717          	auipc	a4,0x19
    8000544a:	c3a70713          	addi	a4,a4,-966 # 8001e080 <disk+0x80>
    8000544e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005450:	0001a717          	auipc	a4,0x1a
    80005454:	bb070713          	addi	a4,a4,-1104 # 8001f000 <disk+0x1000>
    80005458:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000545a:	4705                	li	a4,1
    8000545c:	00e78c23          	sb	a4,24(a5)
    80005460:	00e78ca3          	sb	a4,25(a5)
    80005464:	00e78d23          	sb	a4,26(a5)
    80005468:	00e78da3          	sb	a4,27(a5)
    8000546c:	00e78e23          	sb	a4,28(a5)
    80005470:	00e78ea3          	sb	a4,29(a5)
    80005474:	00e78f23          	sb	a4,30(a5)
    80005478:	00e78fa3          	sb	a4,31(a5)
}
    8000547c:	60e2                	ld	ra,24(sp)
    8000547e:	6442                	ld	s0,16(sp)
    80005480:	64a2                	ld	s1,8(sp)
    80005482:	6105                	addi	sp,sp,32
    80005484:	8082                	ret
    panic("could not find virtio disk");
    80005486:	00003517          	auipc	a0,0x3
    8000548a:	28a50513          	addi	a0,a0,650 # 80008710 <syscalls+0x338>
    8000548e:	00001097          	auipc	ra,0x1
    80005492:	c1e080e7          	jalr	-994(ra) # 800060ac <panic>
    panic("virtio disk has no queue 0");
    80005496:	00003517          	auipc	a0,0x3
    8000549a:	29a50513          	addi	a0,a0,666 # 80008730 <syscalls+0x358>
    8000549e:	00001097          	auipc	ra,0x1
    800054a2:	c0e080e7          	jalr	-1010(ra) # 800060ac <panic>
    panic("virtio disk max queue too short");
    800054a6:	00003517          	auipc	a0,0x3
    800054aa:	2aa50513          	addi	a0,a0,682 # 80008750 <syscalls+0x378>
    800054ae:	00001097          	auipc	ra,0x1
    800054b2:	bfe080e7          	jalr	-1026(ra) # 800060ac <panic>

00000000800054b6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800054b6:	7159                	addi	sp,sp,-112
    800054b8:	f486                	sd	ra,104(sp)
    800054ba:	f0a2                	sd	s0,96(sp)
    800054bc:	eca6                	sd	s1,88(sp)
    800054be:	e8ca                	sd	s2,80(sp)
    800054c0:	e4ce                	sd	s3,72(sp)
    800054c2:	e0d2                	sd	s4,64(sp)
    800054c4:	fc56                	sd	s5,56(sp)
    800054c6:	f85a                	sd	s6,48(sp)
    800054c8:	f45e                	sd	s7,40(sp)
    800054ca:	f062                	sd	s8,32(sp)
    800054cc:	ec66                	sd	s9,24(sp)
    800054ce:	e86a                	sd	s10,16(sp)
    800054d0:	1880                	addi	s0,sp,112
    800054d2:	892a                	mv	s2,a0
    800054d4:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800054d6:	00c52c83          	lw	s9,12(a0)
    800054da:	001c9c9b          	slliw	s9,s9,0x1
    800054de:	1c82                	slli	s9,s9,0x20
    800054e0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800054e4:	0001b517          	auipc	a0,0x1b
    800054e8:	c4450513          	addi	a0,a0,-956 # 80020128 <disk+0x2128>
    800054ec:	00001097          	auipc	ra,0x1
    800054f0:	0f4080e7          	jalr	244(ra) # 800065e0 <acquire>
  for(int i = 0; i < 3; i++){
    800054f4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800054f6:	4c21                	li	s8,8
      disk.free[i] = 0;
    800054f8:	00019b97          	auipc	s7,0x19
    800054fc:	b08b8b93          	addi	s7,s7,-1272 # 8001e000 <disk>
    80005500:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005502:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005504:	8a4e                	mv	s4,s3
    80005506:	a051                	j	8000558a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005508:	00fb86b3          	add	a3,s7,a5
    8000550c:	96da                	add	a3,a3,s6
    8000550e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005512:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005514:	0207c563          	bltz	a5,8000553e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005518:	2485                	addiw	s1,s1,1
    8000551a:	0711                	addi	a4,a4,4
    8000551c:	25548063          	beq	s1,s5,8000575c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005520:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005522:	0001b697          	auipc	a3,0x1b
    80005526:	af668693          	addi	a3,a3,-1290 # 80020018 <disk+0x2018>
    8000552a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000552c:	0006c583          	lbu	a1,0(a3)
    80005530:	fde1                	bnez	a1,80005508 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005532:	2785                	addiw	a5,a5,1
    80005534:	0685                	addi	a3,a3,1
    80005536:	ff879be3          	bne	a5,s8,8000552c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000553a:	57fd                	li	a5,-1
    8000553c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000553e:	02905a63          	blez	s1,80005572 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005542:	f9042503          	lw	a0,-112(s0)
    80005546:	00000097          	auipc	ra,0x0
    8000554a:	d90080e7          	jalr	-624(ra) # 800052d6 <free_desc>
      for(int j = 0; j < i; j++)
    8000554e:	4785                	li	a5,1
    80005550:	0297d163          	bge	a5,s1,80005572 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005554:	f9442503          	lw	a0,-108(s0)
    80005558:	00000097          	auipc	ra,0x0
    8000555c:	d7e080e7          	jalr	-642(ra) # 800052d6 <free_desc>
      for(int j = 0; j < i; j++)
    80005560:	4789                	li	a5,2
    80005562:	0097d863          	bge	a5,s1,80005572 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005566:	f9842503          	lw	a0,-104(s0)
    8000556a:	00000097          	auipc	ra,0x0
    8000556e:	d6c080e7          	jalr	-660(ra) # 800052d6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005572:	0001b597          	auipc	a1,0x1b
    80005576:	bb658593          	addi	a1,a1,-1098 # 80020128 <disk+0x2128>
    8000557a:	0001b517          	auipc	a0,0x1b
    8000557e:	a9e50513          	addi	a0,a0,-1378 # 80020018 <disk+0x2018>
    80005582:	ffffc097          	auipc	ra,0xffffc
    80005586:	0aa080e7          	jalr	170(ra) # 8000162c <sleep>
  for(int i = 0; i < 3; i++){
    8000558a:	f9040713          	addi	a4,s0,-112
    8000558e:	84ce                	mv	s1,s3
    80005590:	bf41                	j	80005520 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005592:	20058713          	addi	a4,a1,512
    80005596:	00471693          	slli	a3,a4,0x4
    8000559a:	00019717          	auipc	a4,0x19
    8000559e:	a6670713          	addi	a4,a4,-1434 # 8001e000 <disk>
    800055a2:	9736                	add	a4,a4,a3
    800055a4:	4685                	li	a3,1
    800055a6:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800055aa:	20058713          	addi	a4,a1,512
    800055ae:	00471693          	slli	a3,a4,0x4
    800055b2:	00019717          	auipc	a4,0x19
    800055b6:	a4e70713          	addi	a4,a4,-1458 # 8001e000 <disk>
    800055ba:	9736                	add	a4,a4,a3
    800055bc:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800055c0:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800055c4:	7679                	lui	a2,0xffffe
    800055c6:	963e                	add	a2,a2,a5
    800055c8:	0001b697          	auipc	a3,0x1b
    800055cc:	a3868693          	addi	a3,a3,-1480 # 80020000 <disk+0x2000>
    800055d0:	6298                	ld	a4,0(a3)
    800055d2:	9732                	add	a4,a4,a2
    800055d4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800055d6:	6298                	ld	a4,0(a3)
    800055d8:	9732                	add	a4,a4,a2
    800055da:	4541                	li	a0,16
    800055dc:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800055de:	6298                	ld	a4,0(a3)
    800055e0:	9732                	add	a4,a4,a2
    800055e2:	4505                	li	a0,1
    800055e4:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800055e8:	f9442703          	lw	a4,-108(s0)
    800055ec:	6288                	ld	a0,0(a3)
    800055ee:	962a                	add	a2,a2,a0
    800055f0:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd2dc6>

  disk.desc[idx[1]].addr = (uint64) b->data;
    800055f4:	0712                	slli	a4,a4,0x4
    800055f6:	6290                	ld	a2,0(a3)
    800055f8:	963a                	add	a2,a2,a4
    800055fa:	06090513          	addi	a0,s2,96
    800055fe:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005600:	6294                	ld	a3,0(a3)
    80005602:	96ba                	add	a3,a3,a4
    80005604:	40000613          	li	a2,1024
    80005608:	c690                	sw	a2,8(a3)
  if(write)
    8000560a:	140d0063          	beqz	s10,8000574a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000560e:	0001b697          	auipc	a3,0x1b
    80005612:	9f26b683          	ld	a3,-1550(a3) # 80020000 <disk+0x2000>
    80005616:	96ba                	add	a3,a3,a4
    80005618:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000561c:	00019817          	auipc	a6,0x19
    80005620:	9e480813          	addi	a6,a6,-1564 # 8001e000 <disk>
    80005624:	0001b517          	auipc	a0,0x1b
    80005628:	9dc50513          	addi	a0,a0,-1572 # 80020000 <disk+0x2000>
    8000562c:	6114                	ld	a3,0(a0)
    8000562e:	96ba                	add	a3,a3,a4
    80005630:	00c6d603          	lhu	a2,12(a3)
    80005634:	00166613          	ori	a2,a2,1
    80005638:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000563c:	f9842683          	lw	a3,-104(s0)
    80005640:	6110                	ld	a2,0(a0)
    80005642:	9732                	add	a4,a4,a2
    80005644:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005648:	20058613          	addi	a2,a1,512
    8000564c:	0612                	slli	a2,a2,0x4
    8000564e:	9642                	add	a2,a2,a6
    80005650:	577d                	li	a4,-1
    80005652:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005656:	00469713          	slli	a4,a3,0x4
    8000565a:	6114                	ld	a3,0(a0)
    8000565c:	96ba                	add	a3,a3,a4
    8000565e:	03078793          	addi	a5,a5,48
    80005662:	97c2                	add	a5,a5,a6
    80005664:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005666:	611c                	ld	a5,0(a0)
    80005668:	97ba                	add	a5,a5,a4
    8000566a:	4685                	li	a3,1
    8000566c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000566e:	611c                	ld	a5,0(a0)
    80005670:	97ba                	add	a5,a5,a4
    80005672:	4809                	li	a6,2
    80005674:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005678:	611c                	ld	a5,0(a0)
    8000567a:	973e                	add	a4,a4,a5
    8000567c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005680:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005684:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005688:	6518                	ld	a4,8(a0)
    8000568a:	00275783          	lhu	a5,2(a4)
    8000568e:	8b9d                	andi	a5,a5,7
    80005690:	0786                	slli	a5,a5,0x1
    80005692:	97ba                	add	a5,a5,a4
    80005694:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005698:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000569c:	6518                	ld	a4,8(a0)
    8000569e:	00275783          	lhu	a5,2(a4)
    800056a2:	2785                	addiw	a5,a5,1
    800056a4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800056a8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800056ac:	100017b7          	lui	a5,0x10001
    800056b0:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800056b4:	00492703          	lw	a4,4(s2)
    800056b8:	4785                	li	a5,1
    800056ba:	02f71163          	bne	a4,a5,800056dc <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    800056be:	0001b997          	auipc	s3,0x1b
    800056c2:	a6a98993          	addi	s3,s3,-1430 # 80020128 <disk+0x2128>
  while(b->disk == 1) {
    800056c6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800056c8:	85ce                	mv	a1,s3
    800056ca:	854a                	mv	a0,s2
    800056cc:	ffffc097          	auipc	ra,0xffffc
    800056d0:	f60080e7          	jalr	-160(ra) # 8000162c <sleep>
  while(b->disk == 1) {
    800056d4:	00492783          	lw	a5,4(s2)
    800056d8:	fe9788e3          	beq	a5,s1,800056c8 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    800056dc:	f9042903          	lw	s2,-112(s0)
    800056e0:	20090793          	addi	a5,s2,512
    800056e4:	00479713          	slli	a4,a5,0x4
    800056e8:	00019797          	auipc	a5,0x19
    800056ec:	91878793          	addi	a5,a5,-1768 # 8001e000 <disk>
    800056f0:	97ba                	add	a5,a5,a4
    800056f2:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800056f6:	0001b997          	auipc	s3,0x1b
    800056fa:	90a98993          	addi	s3,s3,-1782 # 80020000 <disk+0x2000>
    800056fe:	00491713          	slli	a4,s2,0x4
    80005702:	0009b783          	ld	a5,0(s3)
    80005706:	97ba                	add	a5,a5,a4
    80005708:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000570c:	854a                	mv	a0,s2
    8000570e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005712:	00000097          	auipc	ra,0x0
    80005716:	bc4080e7          	jalr	-1084(ra) # 800052d6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000571a:	8885                	andi	s1,s1,1
    8000571c:	f0ed                	bnez	s1,800056fe <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000571e:	0001b517          	auipc	a0,0x1b
    80005722:	a0a50513          	addi	a0,a0,-1526 # 80020128 <disk+0x2128>
    80005726:	00001097          	auipc	ra,0x1
    8000572a:	f8a080e7          	jalr	-118(ra) # 800066b0 <release>
}
    8000572e:	70a6                	ld	ra,104(sp)
    80005730:	7406                	ld	s0,96(sp)
    80005732:	64e6                	ld	s1,88(sp)
    80005734:	6946                	ld	s2,80(sp)
    80005736:	69a6                	ld	s3,72(sp)
    80005738:	6a06                	ld	s4,64(sp)
    8000573a:	7ae2                	ld	s5,56(sp)
    8000573c:	7b42                	ld	s6,48(sp)
    8000573e:	7ba2                	ld	s7,40(sp)
    80005740:	7c02                	ld	s8,32(sp)
    80005742:	6ce2                	ld	s9,24(sp)
    80005744:	6d42                	ld	s10,16(sp)
    80005746:	6165                	addi	sp,sp,112
    80005748:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000574a:	0001b697          	auipc	a3,0x1b
    8000574e:	8b66b683          	ld	a3,-1866(a3) # 80020000 <disk+0x2000>
    80005752:	96ba                	add	a3,a3,a4
    80005754:	4609                	li	a2,2
    80005756:	00c69623          	sh	a2,12(a3)
    8000575a:	b5c9                	j	8000561c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000575c:	f9042583          	lw	a1,-112(s0)
    80005760:	20058793          	addi	a5,a1,512
    80005764:	0792                	slli	a5,a5,0x4
    80005766:	00019517          	auipc	a0,0x19
    8000576a:	94250513          	addi	a0,a0,-1726 # 8001e0a8 <disk+0xa8>
    8000576e:	953e                	add	a0,a0,a5
  if(write)
    80005770:	e20d11e3          	bnez	s10,80005592 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005774:	20058713          	addi	a4,a1,512
    80005778:	00471693          	slli	a3,a4,0x4
    8000577c:	00019717          	auipc	a4,0x19
    80005780:	88470713          	addi	a4,a4,-1916 # 8001e000 <disk>
    80005784:	9736                	add	a4,a4,a3
    80005786:	0a072423          	sw	zero,168(a4)
    8000578a:	b505                	j	800055aa <virtio_disk_rw+0xf4>

000000008000578c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000578c:	1101                	addi	sp,sp,-32
    8000578e:	ec06                	sd	ra,24(sp)
    80005790:	e822                	sd	s0,16(sp)
    80005792:	e426                	sd	s1,8(sp)
    80005794:	e04a                	sd	s2,0(sp)
    80005796:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005798:	0001b517          	auipc	a0,0x1b
    8000579c:	99050513          	addi	a0,a0,-1648 # 80020128 <disk+0x2128>
    800057a0:	00001097          	auipc	ra,0x1
    800057a4:	e40080e7          	jalr	-448(ra) # 800065e0 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057a8:	10001737          	lui	a4,0x10001
    800057ac:	533c                	lw	a5,96(a4)
    800057ae:	8b8d                	andi	a5,a5,3
    800057b0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800057b2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800057b6:	0001b797          	auipc	a5,0x1b
    800057ba:	84a78793          	addi	a5,a5,-1974 # 80020000 <disk+0x2000>
    800057be:	6b94                	ld	a3,16(a5)
    800057c0:	0207d703          	lhu	a4,32(a5)
    800057c4:	0026d783          	lhu	a5,2(a3)
    800057c8:	06f70163          	beq	a4,a5,8000582a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057cc:	00019917          	auipc	s2,0x19
    800057d0:	83490913          	addi	s2,s2,-1996 # 8001e000 <disk>
    800057d4:	0001b497          	auipc	s1,0x1b
    800057d8:	82c48493          	addi	s1,s1,-2004 # 80020000 <disk+0x2000>
    __sync_synchronize();
    800057dc:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057e0:	6898                	ld	a4,16(s1)
    800057e2:	0204d783          	lhu	a5,32(s1)
    800057e6:	8b9d                	andi	a5,a5,7
    800057e8:	078e                	slli	a5,a5,0x3
    800057ea:	97ba                	add	a5,a5,a4
    800057ec:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057ee:	20078713          	addi	a4,a5,512
    800057f2:	0712                	slli	a4,a4,0x4
    800057f4:	974a                	add	a4,a4,s2
    800057f6:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800057fa:	e731                	bnez	a4,80005846 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800057fc:	20078793          	addi	a5,a5,512
    80005800:	0792                	slli	a5,a5,0x4
    80005802:	97ca                	add	a5,a5,s2
    80005804:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005806:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000580a:	ffffc097          	auipc	ra,0xffffc
    8000580e:	fae080e7          	jalr	-82(ra) # 800017b8 <wakeup>

    disk.used_idx += 1;
    80005812:	0204d783          	lhu	a5,32(s1)
    80005816:	2785                	addiw	a5,a5,1
    80005818:	17c2                	slli	a5,a5,0x30
    8000581a:	93c1                	srli	a5,a5,0x30
    8000581c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005820:	6898                	ld	a4,16(s1)
    80005822:	00275703          	lhu	a4,2(a4)
    80005826:	faf71be3          	bne	a4,a5,800057dc <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000582a:	0001b517          	auipc	a0,0x1b
    8000582e:	8fe50513          	addi	a0,a0,-1794 # 80020128 <disk+0x2128>
    80005832:	00001097          	auipc	ra,0x1
    80005836:	e7e080e7          	jalr	-386(ra) # 800066b0 <release>
}
    8000583a:	60e2                	ld	ra,24(sp)
    8000583c:	6442                	ld	s0,16(sp)
    8000583e:	64a2                	ld	s1,8(sp)
    80005840:	6902                	ld	s2,0(sp)
    80005842:	6105                	addi	sp,sp,32
    80005844:	8082                	ret
      panic("virtio_disk_intr status");
    80005846:	00003517          	auipc	a0,0x3
    8000584a:	f2a50513          	addi	a0,a0,-214 # 80008770 <syscalls+0x398>
    8000584e:	00001097          	auipc	ra,0x1
    80005852:	85e080e7          	jalr	-1954(ra) # 800060ac <panic>

0000000080005856 <statswrite>:
int statscopyin(char*, int);
int statslock(char*, int);
  
int
statswrite(int user_src, uint64 src, int n)
{
    80005856:	1141                	addi	sp,sp,-16
    80005858:	e422                	sd	s0,8(sp)
    8000585a:	0800                	addi	s0,sp,16
  return -1;
}
    8000585c:	557d                	li	a0,-1
    8000585e:	6422                	ld	s0,8(sp)
    80005860:	0141                	addi	sp,sp,16
    80005862:	8082                	ret

0000000080005864 <statsread>:

int
statsread(int user_dst, uint64 dst, int n)
{
    80005864:	7179                	addi	sp,sp,-48
    80005866:	f406                	sd	ra,40(sp)
    80005868:	f022                	sd	s0,32(sp)
    8000586a:	ec26                	sd	s1,24(sp)
    8000586c:	e84a                	sd	s2,16(sp)
    8000586e:	e44e                	sd	s3,8(sp)
    80005870:	e052                	sd	s4,0(sp)
    80005872:	1800                	addi	s0,sp,48
    80005874:	892a                	mv	s2,a0
    80005876:	89ae                	mv	s3,a1
    80005878:	84b2                	mv	s1,a2
  int m;

  acquire(&stats.lock);
    8000587a:	0001b517          	auipc	a0,0x1b
    8000587e:	78650513          	addi	a0,a0,1926 # 80021000 <stats>
    80005882:	00001097          	auipc	ra,0x1
    80005886:	d5e080e7          	jalr	-674(ra) # 800065e0 <acquire>

  if(stats.sz == 0) {
    8000588a:	0001c797          	auipc	a5,0x1c
    8000588e:	7967a783          	lw	a5,1942(a5) # 80022020 <stats+0x1020>
    80005892:	cbb5                	beqz	a5,80005906 <statsread+0xa2>
#endif
#ifdef LAB_LOCK
    stats.sz = statslock(stats.buf, BUFSZ);
#endif
  }
  m = stats.sz - stats.off;
    80005894:	0001c797          	auipc	a5,0x1c
    80005898:	76c78793          	addi	a5,a5,1900 # 80022000 <stats+0x1000>
    8000589c:	53d8                	lw	a4,36(a5)
    8000589e:	539c                	lw	a5,32(a5)
    800058a0:	9f99                	subw	a5,a5,a4
    800058a2:	0007869b          	sext.w	a3,a5

  if (m > 0) {
    800058a6:	06d05e63          	blez	a3,80005922 <statsread+0xbe>
    if(m > n)
    800058aa:	8a3e                	mv	s4,a5
    800058ac:	00d4d363          	bge	s1,a3,800058b2 <statsread+0x4e>
    800058b0:	8a26                	mv	s4,s1
    800058b2:	000a049b          	sext.w	s1,s4
      m  = n;
    if(either_copyout(user_dst, dst, stats.buf+stats.off, m) != -1) {
    800058b6:	86a6                	mv	a3,s1
    800058b8:	0001b617          	auipc	a2,0x1b
    800058bc:	76860613          	addi	a2,a2,1896 # 80021020 <stats+0x20>
    800058c0:	963a                	add	a2,a2,a4
    800058c2:	85ce                	mv	a1,s3
    800058c4:	854a                	mv	a0,s2
    800058c6:	ffffc097          	auipc	ra,0xffffc
    800058ca:	10a080e7          	jalr	266(ra) # 800019d0 <either_copyout>
    800058ce:	57fd                	li	a5,-1
    800058d0:	00f50a63          	beq	a0,a5,800058e4 <statsread+0x80>
      stats.off += m;
    800058d4:	0001c717          	auipc	a4,0x1c
    800058d8:	72c70713          	addi	a4,a4,1836 # 80022000 <stats+0x1000>
    800058dc:	535c                	lw	a5,36(a4)
    800058de:	014787bb          	addw	a5,a5,s4
    800058e2:	d35c                	sw	a5,36(a4)
  } else {
    m = -1;
    stats.sz = 0;
    stats.off = 0;
  }
  release(&stats.lock);
    800058e4:	0001b517          	auipc	a0,0x1b
    800058e8:	71c50513          	addi	a0,a0,1820 # 80021000 <stats>
    800058ec:	00001097          	auipc	ra,0x1
    800058f0:	dc4080e7          	jalr	-572(ra) # 800066b0 <release>
  return m;
}
    800058f4:	8526                	mv	a0,s1
    800058f6:	70a2                	ld	ra,40(sp)
    800058f8:	7402                	ld	s0,32(sp)
    800058fa:	64e2                	ld	s1,24(sp)
    800058fc:	6942                	ld	s2,16(sp)
    800058fe:	69a2                	ld	s3,8(sp)
    80005900:	6a02                	ld	s4,0(sp)
    80005902:	6145                	addi	sp,sp,48
    80005904:	8082                	ret
    stats.sz = statslock(stats.buf, BUFSZ);
    80005906:	6585                	lui	a1,0x1
    80005908:	0001b517          	auipc	a0,0x1b
    8000590c:	71850513          	addi	a0,a0,1816 # 80021020 <stats+0x20>
    80005910:	00001097          	auipc	ra,0x1
    80005914:	f28080e7          	jalr	-216(ra) # 80006838 <statslock>
    80005918:	0001c797          	auipc	a5,0x1c
    8000591c:	70a7a423          	sw	a0,1800(a5) # 80022020 <stats+0x1020>
    80005920:	bf95                	j	80005894 <statsread+0x30>
    stats.sz = 0;
    80005922:	0001c797          	auipc	a5,0x1c
    80005926:	6de78793          	addi	a5,a5,1758 # 80022000 <stats+0x1000>
    8000592a:	0207a023          	sw	zero,32(a5)
    stats.off = 0;
    8000592e:	0207a223          	sw	zero,36(a5)
    m = -1;
    80005932:	54fd                	li	s1,-1
    80005934:	bf45                	j	800058e4 <statsread+0x80>

0000000080005936 <statsinit>:

void
statsinit(void)
{
    80005936:	1141                	addi	sp,sp,-16
    80005938:	e406                	sd	ra,8(sp)
    8000593a:	e022                	sd	s0,0(sp)
    8000593c:	0800                	addi	s0,sp,16
  initlock(&stats.lock, "stats");
    8000593e:	00003597          	auipc	a1,0x3
    80005942:	e4a58593          	addi	a1,a1,-438 # 80008788 <syscalls+0x3b0>
    80005946:	0001b517          	auipc	a0,0x1b
    8000594a:	6ba50513          	addi	a0,a0,1722 # 80021000 <stats>
    8000594e:	00001097          	auipc	ra,0x1
    80005952:	e0e080e7          	jalr	-498(ra) # 8000675c <initlock>

  devsw[STATS].read = statsread;
    80005956:	00017797          	auipc	a5,0x17
    8000595a:	34a78793          	addi	a5,a5,842 # 8001cca0 <devsw>
    8000595e:	00000717          	auipc	a4,0x0
    80005962:	f0670713          	addi	a4,a4,-250 # 80005864 <statsread>
    80005966:	f398                	sd	a4,32(a5)
  devsw[STATS].write = statswrite;
    80005968:	00000717          	auipc	a4,0x0
    8000596c:	eee70713          	addi	a4,a4,-274 # 80005856 <statswrite>
    80005970:	f798                	sd	a4,40(a5)
}
    80005972:	60a2                	ld	ra,8(sp)
    80005974:	6402                	ld	s0,0(sp)
    80005976:	0141                	addi	sp,sp,16
    80005978:	8082                	ret

000000008000597a <sprintint>:
  return 1;
}

static int
sprintint(char *s, int xx, int base, int sign)
{
    8000597a:	1101                	addi	sp,sp,-32
    8000597c:	ec22                	sd	s0,24(sp)
    8000597e:	1000                	addi	s0,sp,32
    80005980:	882a                	mv	a6,a0
  char buf[16];
  int i, n;
  uint x;

  if(sign && (sign = xx < 0))
    80005982:	c299                	beqz	a3,80005988 <sprintint+0xe>
    80005984:	0805c163          	bltz	a1,80005a06 <sprintint+0x8c>
    x = -xx;
  else
    x = xx;
    80005988:	2581                	sext.w	a1,a1
    8000598a:	4301                	li	t1,0

  i = 0;
    8000598c:	fe040713          	addi	a4,s0,-32
    80005990:	4501                	li	a0,0
  do {
    buf[i++] = digits[x % base];
    80005992:	2601                	sext.w	a2,a2
    80005994:	00003697          	auipc	a3,0x3
    80005998:	e1468693          	addi	a3,a3,-492 # 800087a8 <digits>
    8000599c:	88aa                	mv	a7,a0
    8000599e:	2505                	addiw	a0,a0,1
    800059a0:	02c5f7bb          	remuw	a5,a1,a2
    800059a4:	1782                	slli	a5,a5,0x20
    800059a6:	9381                	srli	a5,a5,0x20
    800059a8:	97b6                	add	a5,a5,a3
    800059aa:	0007c783          	lbu	a5,0(a5)
    800059ae:	00f70023          	sb	a5,0(a4)
  } while((x /= base) != 0);
    800059b2:	0005879b          	sext.w	a5,a1
    800059b6:	02c5d5bb          	divuw	a1,a1,a2
    800059ba:	0705                	addi	a4,a4,1
    800059bc:	fec7f0e3          	bgeu	a5,a2,8000599c <sprintint+0x22>

  if(sign)
    800059c0:	00030b63          	beqz	t1,800059d6 <sprintint+0x5c>
    buf[i++] = '-';
    800059c4:	ff040793          	addi	a5,s0,-16
    800059c8:	97aa                	add	a5,a5,a0
    800059ca:	02d00713          	li	a4,45
    800059ce:	fee78823          	sb	a4,-16(a5)
    800059d2:	0028851b          	addiw	a0,a7,2

  n = 0;
  while(--i >= 0)
    800059d6:	02a05c63          	blez	a0,80005a0e <sprintint+0x94>
    800059da:	fe040793          	addi	a5,s0,-32
    800059de:	00a78733          	add	a4,a5,a0
    800059e2:	87c2                	mv	a5,a6
    800059e4:	0805                	addi	a6,a6,1
    800059e6:	fff5061b          	addiw	a2,a0,-1
    800059ea:	1602                	slli	a2,a2,0x20
    800059ec:	9201                	srli	a2,a2,0x20
    800059ee:	9642                	add	a2,a2,a6
  *s = c;
    800059f0:	fff74683          	lbu	a3,-1(a4)
    800059f4:	00d78023          	sb	a3,0(a5)
  while(--i >= 0)
    800059f8:	177d                	addi	a4,a4,-1
    800059fa:	0785                	addi	a5,a5,1
    800059fc:	fec79ae3          	bne	a5,a2,800059f0 <sprintint+0x76>
    n += sputc(s+n, buf[i]);
  return n;
}
    80005a00:	6462                	ld	s0,24(sp)
    80005a02:	6105                	addi	sp,sp,32
    80005a04:	8082                	ret
    x = -xx;
    80005a06:	40b005bb          	negw	a1,a1
  if(sign && (sign = xx < 0))
    80005a0a:	4305                	li	t1,1
    x = -xx;
    80005a0c:	b741                	j	8000598c <sprintint+0x12>
  while(--i >= 0)
    80005a0e:	4501                	li	a0,0
    80005a10:	bfc5                	j	80005a00 <sprintint+0x86>

0000000080005a12 <snprintf>:

int
snprintf(char *buf, int sz, char *fmt, ...)
{
    80005a12:	7171                	addi	sp,sp,-176
    80005a14:	fc86                	sd	ra,120(sp)
    80005a16:	f8a2                	sd	s0,112(sp)
    80005a18:	f4a6                	sd	s1,104(sp)
    80005a1a:	f0ca                	sd	s2,96(sp)
    80005a1c:	ecce                	sd	s3,88(sp)
    80005a1e:	e8d2                	sd	s4,80(sp)
    80005a20:	e4d6                	sd	s5,72(sp)
    80005a22:	e0da                	sd	s6,64(sp)
    80005a24:	fc5e                	sd	s7,56(sp)
    80005a26:	f862                	sd	s8,48(sp)
    80005a28:	f466                	sd	s9,40(sp)
    80005a2a:	f06a                	sd	s10,32(sp)
    80005a2c:	ec6e                	sd	s11,24(sp)
    80005a2e:	0100                	addi	s0,sp,128
    80005a30:	e414                	sd	a3,8(s0)
    80005a32:	e818                	sd	a4,16(s0)
    80005a34:	ec1c                	sd	a5,24(s0)
    80005a36:	03043023          	sd	a6,32(s0)
    80005a3a:	03143423          	sd	a7,40(s0)
  va_list ap;
  int i, c;
  int off = 0;
  char *s;

  if (fmt == 0)
    80005a3e:	ca0d                	beqz	a2,80005a70 <snprintf+0x5e>
    80005a40:	8baa                	mv	s7,a0
    80005a42:	89ae                	mv	s3,a1
    80005a44:	8a32                	mv	s4,a2
    panic("null fmt");

  va_start(ap, fmt);
    80005a46:	00840793          	addi	a5,s0,8
    80005a4a:	f8f43423          	sd	a5,-120(s0)
  int off = 0;
    80005a4e:	4481                	li	s1,0
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005a50:	4901                	li	s2,0
    80005a52:	02b05763          	blez	a1,80005a80 <snprintf+0x6e>
    if(c != '%'){
    80005a56:	02500a93          	li	s5,37
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    80005a5a:	07300b13          	li	s6,115
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
      break;
    case 's':
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s && off < sz; s++)
    80005a5e:	02800d93          	li	s11,40
  *s = c;
    80005a62:	02500d13          	li	s10,37
    switch(c){
    80005a66:	07800c93          	li	s9,120
    80005a6a:	06400c13          	li	s8,100
    80005a6e:	a01d                	j	80005a94 <snprintf+0x82>
    panic("null fmt");
    80005a70:	00003517          	auipc	a0,0x3
    80005a74:	d2850513          	addi	a0,a0,-728 # 80008798 <syscalls+0x3c0>
    80005a78:	00000097          	auipc	ra,0x0
    80005a7c:	634080e7          	jalr	1588(ra) # 800060ac <panic>
  int off = 0;
    80005a80:	4481                	li	s1,0
    80005a82:	a86d                	j	80005b3c <snprintf+0x12a>
  *s = c;
    80005a84:	009b8733          	add	a4,s7,s1
    80005a88:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005a8c:	2485                	addiw	s1,s1,1
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005a8e:	2905                	addiw	s2,s2,1
    80005a90:	0b34d663          	bge	s1,s3,80005b3c <snprintf+0x12a>
    80005a94:	012a07b3          	add	a5,s4,s2
    80005a98:	0007c783          	lbu	a5,0(a5)
    80005a9c:	0007871b          	sext.w	a4,a5
    80005aa0:	cfd1                	beqz	a5,80005b3c <snprintf+0x12a>
    if(c != '%'){
    80005aa2:	ff5711e3          	bne	a4,s5,80005a84 <snprintf+0x72>
    c = fmt[++i] & 0xff;
    80005aa6:	2905                	addiw	s2,s2,1
    80005aa8:	012a07b3          	add	a5,s4,s2
    80005aac:	0007c783          	lbu	a5,0(a5)
    if(c == 0)
    80005ab0:	c7d1                	beqz	a5,80005b3c <snprintf+0x12a>
    switch(c){
    80005ab2:	05678c63          	beq	a5,s6,80005b0a <snprintf+0xf8>
    80005ab6:	02fb6763          	bltu	s6,a5,80005ae4 <snprintf+0xd2>
    80005aba:	0b578763          	beq	a5,s5,80005b68 <snprintf+0x156>
    80005abe:	0b879b63          	bne	a5,s8,80005b74 <snprintf+0x162>
      off += sprintint(buf+off, va_arg(ap, int), 10, 1);
    80005ac2:	f8843783          	ld	a5,-120(s0)
    80005ac6:	00878713          	addi	a4,a5,8
    80005aca:	f8e43423          	sd	a4,-120(s0)
    80005ace:	4685                	li	a3,1
    80005ad0:	4629                	li	a2,10
    80005ad2:	438c                	lw	a1,0(a5)
    80005ad4:	009b8533          	add	a0,s7,s1
    80005ad8:	00000097          	auipc	ra,0x0
    80005adc:	ea2080e7          	jalr	-350(ra) # 8000597a <sprintint>
    80005ae0:	9ca9                	addw	s1,s1,a0
      break;
    80005ae2:	b775                	j	80005a8e <snprintf+0x7c>
    switch(c){
    80005ae4:	09979863          	bne	a5,s9,80005b74 <snprintf+0x162>
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
    80005ae8:	f8843783          	ld	a5,-120(s0)
    80005aec:	00878713          	addi	a4,a5,8
    80005af0:	f8e43423          	sd	a4,-120(s0)
    80005af4:	4685                	li	a3,1
    80005af6:	4641                	li	a2,16
    80005af8:	438c                	lw	a1,0(a5)
    80005afa:	009b8533          	add	a0,s7,s1
    80005afe:	00000097          	auipc	ra,0x0
    80005b02:	e7c080e7          	jalr	-388(ra) # 8000597a <sprintint>
    80005b06:	9ca9                	addw	s1,s1,a0
      break;
    80005b08:	b759                	j	80005a8e <snprintf+0x7c>
      if((s = va_arg(ap, char*)) == 0)
    80005b0a:	f8843783          	ld	a5,-120(s0)
    80005b0e:	00878713          	addi	a4,a5,8
    80005b12:	f8e43423          	sd	a4,-120(s0)
    80005b16:	639c                	ld	a5,0(a5)
    80005b18:	c3b1                	beqz	a5,80005b5c <snprintf+0x14a>
      for(; *s && off < sz; s++)
    80005b1a:	0007c703          	lbu	a4,0(a5)
    80005b1e:	db25                	beqz	a4,80005a8e <snprintf+0x7c>
    80005b20:	0134de63          	bge	s1,s3,80005b3c <snprintf+0x12a>
    80005b24:	009b86b3          	add	a3,s7,s1
  *s = c;
    80005b28:	00e68023          	sb	a4,0(a3)
        off += sputc(buf+off, *s);
    80005b2c:	2485                	addiw	s1,s1,1
      for(; *s && off < sz; s++)
    80005b2e:	0785                	addi	a5,a5,1
    80005b30:	0007c703          	lbu	a4,0(a5)
    80005b34:	df29                	beqz	a4,80005a8e <snprintf+0x7c>
    80005b36:	0685                	addi	a3,a3,1
    80005b38:	fe9998e3          	bne	s3,s1,80005b28 <snprintf+0x116>
      off += sputc(buf+off, c);
      break;
    }
  }
  return off;
}
    80005b3c:	8526                	mv	a0,s1
    80005b3e:	70e6                	ld	ra,120(sp)
    80005b40:	7446                	ld	s0,112(sp)
    80005b42:	74a6                	ld	s1,104(sp)
    80005b44:	7906                	ld	s2,96(sp)
    80005b46:	69e6                	ld	s3,88(sp)
    80005b48:	6a46                	ld	s4,80(sp)
    80005b4a:	6aa6                	ld	s5,72(sp)
    80005b4c:	6b06                	ld	s6,64(sp)
    80005b4e:	7be2                	ld	s7,56(sp)
    80005b50:	7c42                	ld	s8,48(sp)
    80005b52:	7ca2                	ld	s9,40(sp)
    80005b54:	7d02                	ld	s10,32(sp)
    80005b56:	6de2                	ld	s11,24(sp)
    80005b58:	614d                	addi	sp,sp,176
    80005b5a:	8082                	ret
        s = "(null)";
    80005b5c:	00003797          	auipc	a5,0x3
    80005b60:	c3478793          	addi	a5,a5,-972 # 80008790 <syscalls+0x3b8>
      for(; *s && off < sz; s++)
    80005b64:	876e                	mv	a4,s11
    80005b66:	bf6d                	j	80005b20 <snprintf+0x10e>
  *s = c;
    80005b68:	009b87b3          	add	a5,s7,s1
    80005b6c:	01a78023          	sb	s10,0(a5)
      off += sputc(buf+off, '%');
    80005b70:	2485                	addiw	s1,s1,1
      break;
    80005b72:	bf31                	j	80005a8e <snprintf+0x7c>
  *s = c;
    80005b74:	009b8733          	add	a4,s7,s1
    80005b78:	01a70023          	sb	s10,0(a4)
      off += sputc(buf+off, c);
    80005b7c:	0014871b          	addiw	a4,s1,1
  *s = c;
    80005b80:	975e                	add	a4,a4,s7
    80005b82:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005b86:	2489                	addiw	s1,s1,2
      break;
    80005b88:	b719                	j	80005a8e <snprintf+0x7c>

0000000080005b8a <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005b8a:	1141                	addi	sp,sp,-16
    80005b8c:	e422                	sd	s0,8(sp)
    80005b8e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005b90:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005b94:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005b98:	0037979b          	slliw	a5,a5,0x3
    80005b9c:	02004737          	lui	a4,0x2004
    80005ba0:	97ba                	add	a5,a5,a4
    80005ba2:	0200c737          	lui	a4,0x200c
    80005ba6:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005baa:	000f4637          	lui	a2,0xf4
    80005bae:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005bb2:	95b2                	add	a1,a1,a2
    80005bb4:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005bb6:	00269713          	slli	a4,a3,0x2
    80005bba:	9736                	add	a4,a4,a3
    80005bbc:	00371693          	slli	a3,a4,0x3
    80005bc0:	0001c717          	auipc	a4,0x1c
    80005bc4:	47070713          	addi	a4,a4,1136 # 80022030 <timer_scratch>
    80005bc8:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005bca:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005bcc:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005bce:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005bd2:	fffff797          	auipc	a5,0xfffff
    80005bd6:	63e78793          	addi	a5,a5,1598 # 80005210 <timervec>
    80005bda:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005bde:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005be2:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005be6:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005bea:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005bee:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005bf2:	30479073          	csrw	mie,a5
}
    80005bf6:	6422                	ld	s0,8(sp)
    80005bf8:	0141                	addi	sp,sp,16
    80005bfa:	8082                	ret

0000000080005bfc <start>:
{
    80005bfc:	1141                	addi	sp,sp,-16
    80005bfe:	e406                	sd	ra,8(sp)
    80005c00:	e022                	sd	s0,0(sp)
    80005c02:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005c04:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005c08:	7779                	lui	a4,0xffffe
    80005c0a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd35b7>
    80005c0e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005c10:	6705                	lui	a4,0x1
    80005c12:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005c16:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005c18:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005c1c:	ffffb797          	auipc	a5,0xffffb
    80005c20:	82278793          	addi	a5,a5,-2014 # 8000043e <main>
    80005c24:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005c28:	4781                	li	a5,0
    80005c2a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005c2e:	67c1                	lui	a5,0x10
    80005c30:	17fd                	addi	a5,a5,-1
    80005c32:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005c36:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005c3a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005c3e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005c42:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005c46:	57fd                	li	a5,-1
    80005c48:	83a9                	srli	a5,a5,0xa
    80005c4a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005c4e:	47bd                	li	a5,15
    80005c50:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005c54:	00000097          	auipc	ra,0x0
    80005c58:	f36080e7          	jalr	-202(ra) # 80005b8a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005c5c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005c60:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005c62:	823e                	mv	tp,a5
  asm volatile("mret");
    80005c64:	30200073          	mret
}
    80005c68:	60a2                	ld	ra,8(sp)
    80005c6a:	6402                	ld	s0,0(sp)
    80005c6c:	0141                	addi	sp,sp,16
    80005c6e:	8082                	ret

0000000080005c70 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005c70:	715d                	addi	sp,sp,-80
    80005c72:	e486                	sd	ra,72(sp)
    80005c74:	e0a2                	sd	s0,64(sp)
    80005c76:	fc26                	sd	s1,56(sp)
    80005c78:	f84a                	sd	s2,48(sp)
    80005c7a:	f44e                	sd	s3,40(sp)
    80005c7c:	f052                	sd	s4,32(sp)
    80005c7e:	ec56                	sd	s5,24(sp)
    80005c80:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005c82:	04c05663          	blez	a2,80005cce <consolewrite+0x5e>
    80005c86:	8a2a                	mv	s4,a0
    80005c88:	84ae                	mv	s1,a1
    80005c8a:	89b2                	mv	s3,a2
    80005c8c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005c8e:	5afd                	li	s5,-1
    80005c90:	4685                	li	a3,1
    80005c92:	8626                	mv	a2,s1
    80005c94:	85d2                	mv	a1,s4
    80005c96:	fbf40513          	addi	a0,s0,-65
    80005c9a:	ffffc097          	auipc	ra,0xffffc
    80005c9e:	d8c080e7          	jalr	-628(ra) # 80001a26 <either_copyin>
    80005ca2:	01550c63          	beq	a0,s5,80005cba <consolewrite+0x4a>
      break;
    uartputc(c);
    80005ca6:	fbf44503          	lbu	a0,-65(s0)
    80005caa:	00000097          	auipc	ra,0x0
    80005cae:	78e080e7          	jalr	1934(ra) # 80006438 <uartputc>
  for(i = 0; i < n; i++){
    80005cb2:	2905                	addiw	s2,s2,1
    80005cb4:	0485                	addi	s1,s1,1
    80005cb6:	fd299de3          	bne	s3,s2,80005c90 <consolewrite+0x20>
  }

  return i;
}
    80005cba:	854a                	mv	a0,s2
    80005cbc:	60a6                	ld	ra,72(sp)
    80005cbe:	6406                	ld	s0,64(sp)
    80005cc0:	74e2                	ld	s1,56(sp)
    80005cc2:	7942                	ld	s2,48(sp)
    80005cc4:	79a2                	ld	s3,40(sp)
    80005cc6:	7a02                	ld	s4,32(sp)
    80005cc8:	6ae2                	ld	s5,24(sp)
    80005cca:	6161                	addi	sp,sp,80
    80005ccc:	8082                	ret
  for(i = 0; i < n; i++){
    80005cce:	4901                	li	s2,0
    80005cd0:	b7ed                	j	80005cba <consolewrite+0x4a>

0000000080005cd2 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005cd2:	7119                	addi	sp,sp,-128
    80005cd4:	fc86                	sd	ra,120(sp)
    80005cd6:	f8a2                	sd	s0,112(sp)
    80005cd8:	f4a6                	sd	s1,104(sp)
    80005cda:	f0ca                	sd	s2,96(sp)
    80005cdc:	ecce                	sd	s3,88(sp)
    80005cde:	e8d2                	sd	s4,80(sp)
    80005ce0:	e4d6                	sd	s5,72(sp)
    80005ce2:	e0da                	sd	s6,64(sp)
    80005ce4:	fc5e                	sd	s7,56(sp)
    80005ce6:	f862                	sd	s8,48(sp)
    80005ce8:	f466                	sd	s9,40(sp)
    80005cea:	f06a                	sd	s10,32(sp)
    80005cec:	ec6e                	sd	s11,24(sp)
    80005cee:	0100                	addi	s0,sp,128
    80005cf0:	8b2a                	mv	s6,a0
    80005cf2:	8aae                	mv	s5,a1
    80005cf4:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005cf6:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005cfa:	00024517          	auipc	a0,0x24
    80005cfe:	47650513          	addi	a0,a0,1142 # 8002a170 <cons>
    80005d02:	00001097          	auipc	ra,0x1
    80005d06:	8de080e7          	jalr	-1826(ra) # 800065e0 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005d0a:	00024497          	auipc	s1,0x24
    80005d0e:	46648493          	addi	s1,s1,1126 # 8002a170 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005d12:	89a6                	mv	s3,s1
    80005d14:	00024917          	auipc	s2,0x24
    80005d18:	4fc90913          	addi	s2,s2,1276 # 8002a210 <cons+0xa0>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005d1c:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005d1e:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005d20:	4da9                	li	s11,10
  while(n > 0){
    80005d22:	07405863          	blez	s4,80005d92 <consoleread+0xc0>
    while(cons.r == cons.w){
    80005d26:	0a04a783          	lw	a5,160(s1)
    80005d2a:	0a44a703          	lw	a4,164(s1)
    80005d2e:	02f71463          	bne	a4,a5,80005d56 <consoleread+0x84>
      if(myproc()->killed){
    80005d32:	ffffb097          	auipc	ra,0xffffb
    80005d36:	23e080e7          	jalr	574(ra) # 80000f70 <myproc>
    80005d3a:	591c                	lw	a5,48(a0)
    80005d3c:	e7b5                	bnez	a5,80005da8 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005d3e:	85ce                	mv	a1,s3
    80005d40:	854a                	mv	a0,s2
    80005d42:	ffffc097          	auipc	ra,0xffffc
    80005d46:	8ea080e7          	jalr	-1814(ra) # 8000162c <sleep>
    while(cons.r == cons.w){
    80005d4a:	0a04a783          	lw	a5,160(s1)
    80005d4e:	0a44a703          	lw	a4,164(s1)
    80005d52:	fef700e3          	beq	a4,a5,80005d32 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005d56:	0017871b          	addiw	a4,a5,1
    80005d5a:	0ae4a023          	sw	a4,160(s1)
    80005d5e:	07f7f713          	andi	a4,a5,127
    80005d62:	9726                	add	a4,a4,s1
    80005d64:	02074703          	lbu	a4,32(a4)
    80005d68:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005d6c:	079c0663          	beq	s8,s9,80005dd8 <consoleread+0x106>
    cbuf = c;
    80005d70:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005d74:	4685                	li	a3,1
    80005d76:	f8f40613          	addi	a2,s0,-113
    80005d7a:	85d6                	mv	a1,s5
    80005d7c:	855a                	mv	a0,s6
    80005d7e:	ffffc097          	auipc	ra,0xffffc
    80005d82:	c52080e7          	jalr	-942(ra) # 800019d0 <either_copyout>
    80005d86:	01a50663          	beq	a0,s10,80005d92 <consoleread+0xc0>
    dst++;
    80005d8a:	0a85                	addi	s5,s5,1
    --n;
    80005d8c:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005d8e:	f9bc1ae3          	bne	s8,s11,80005d22 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005d92:	00024517          	auipc	a0,0x24
    80005d96:	3de50513          	addi	a0,a0,990 # 8002a170 <cons>
    80005d9a:	00001097          	auipc	ra,0x1
    80005d9e:	916080e7          	jalr	-1770(ra) # 800066b0 <release>

  return target - n;
    80005da2:	414b853b          	subw	a0,s7,s4
    80005da6:	a811                	j	80005dba <consoleread+0xe8>
        release(&cons.lock);
    80005da8:	00024517          	auipc	a0,0x24
    80005dac:	3c850513          	addi	a0,a0,968 # 8002a170 <cons>
    80005db0:	00001097          	auipc	ra,0x1
    80005db4:	900080e7          	jalr	-1792(ra) # 800066b0 <release>
        return -1;
    80005db8:	557d                	li	a0,-1
}
    80005dba:	70e6                	ld	ra,120(sp)
    80005dbc:	7446                	ld	s0,112(sp)
    80005dbe:	74a6                	ld	s1,104(sp)
    80005dc0:	7906                	ld	s2,96(sp)
    80005dc2:	69e6                	ld	s3,88(sp)
    80005dc4:	6a46                	ld	s4,80(sp)
    80005dc6:	6aa6                	ld	s5,72(sp)
    80005dc8:	6b06                	ld	s6,64(sp)
    80005dca:	7be2                	ld	s7,56(sp)
    80005dcc:	7c42                	ld	s8,48(sp)
    80005dce:	7ca2                	ld	s9,40(sp)
    80005dd0:	7d02                	ld	s10,32(sp)
    80005dd2:	6de2                	ld	s11,24(sp)
    80005dd4:	6109                	addi	sp,sp,128
    80005dd6:	8082                	ret
      if(n < target){
    80005dd8:	000a071b          	sext.w	a4,s4
    80005ddc:	fb777be3          	bgeu	a4,s7,80005d92 <consoleread+0xc0>
        cons.r--;
    80005de0:	00024717          	auipc	a4,0x24
    80005de4:	42f72823          	sw	a5,1072(a4) # 8002a210 <cons+0xa0>
    80005de8:	b76d                	j	80005d92 <consoleread+0xc0>

0000000080005dea <consputc>:
{
    80005dea:	1141                	addi	sp,sp,-16
    80005dec:	e406                	sd	ra,8(sp)
    80005dee:	e022                	sd	s0,0(sp)
    80005df0:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005df2:	10000793          	li	a5,256
    80005df6:	00f50a63          	beq	a0,a5,80005e0a <consputc+0x20>
    uartputc_sync(c);
    80005dfa:	00000097          	auipc	ra,0x0
    80005dfe:	564080e7          	jalr	1380(ra) # 8000635e <uartputc_sync>
}
    80005e02:	60a2                	ld	ra,8(sp)
    80005e04:	6402                	ld	s0,0(sp)
    80005e06:	0141                	addi	sp,sp,16
    80005e08:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005e0a:	4521                	li	a0,8
    80005e0c:	00000097          	auipc	ra,0x0
    80005e10:	552080e7          	jalr	1362(ra) # 8000635e <uartputc_sync>
    80005e14:	02000513          	li	a0,32
    80005e18:	00000097          	auipc	ra,0x0
    80005e1c:	546080e7          	jalr	1350(ra) # 8000635e <uartputc_sync>
    80005e20:	4521                	li	a0,8
    80005e22:	00000097          	auipc	ra,0x0
    80005e26:	53c080e7          	jalr	1340(ra) # 8000635e <uartputc_sync>
    80005e2a:	bfe1                	j	80005e02 <consputc+0x18>

0000000080005e2c <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005e2c:	1101                	addi	sp,sp,-32
    80005e2e:	ec06                	sd	ra,24(sp)
    80005e30:	e822                	sd	s0,16(sp)
    80005e32:	e426                	sd	s1,8(sp)
    80005e34:	e04a                	sd	s2,0(sp)
    80005e36:	1000                	addi	s0,sp,32
    80005e38:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005e3a:	00024517          	auipc	a0,0x24
    80005e3e:	33650513          	addi	a0,a0,822 # 8002a170 <cons>
    80005e42:	00000097          	auipc	ra,0x0
    80005e46:	79e080e7          	jalr	1950(ra) # 800065e0 <acquire>

  switch(c){
    80005e4a:	47d5                	li	a5,21
    80005e4c:	0af48663          	beq	s1,a5,80005ef8 <consoleintr+0xcc>
    80005e50:	0297ca63          	blt	a5,s1,80005e84 <consoleintr+0x58>
    80005e54:	47a1                	li	a5,8
    80005e56:	0ef48763          	beq	s1,a5,80005f44 <consoleintr+0x118>
    80005e5a:	47c1                	li	a5,16
    80005e5c:	10f49a63          	bne	s1,a5,80005f70 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005e60:	ffffc097          	auipc	ra,0xffffc
    80005e64:	c1c080e7          	jalr	-996(ra) # 80001a7c <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005e68:	00024517          	auipc	a0,0x24
    80005e6c:	30850513          	addi	a0,a0,776 # 8002a170 <cons>
    80005e70:	00001097          	auipc	ra,0x1
    80005e74:	840080e7          	jalr	-1984(ra) # 800066b0 <release>
}
    80005e78:	60e2                	ld	ra,24(sp)
    80005e7a:	6442                	ld	s0,16(sp)
    80005e7c:	64a2                	ld	s1,8(sp)
    80005e7e:	6902                	ld	s2,0(sp)
    80005e80:	6105                	addi	sp,sp,32
    80005e82:	8082                	ret
  switch(c){
    80005e84:	07f00793          	li	a5,127
    80005e88:	0af48e63          	beq	s1,a5,80005f44 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005e8c:	00024717          	auipc	a4,0x24
    80005e90:	2e470713          	addi	a4,a4,740 # 8002a170 <cons>
    80005e94:	0a872783          	lw	a5,168(a4)
    80005e98:	0a072703          	lw	a4,160(a4)
    80005e9c:	9f99                	subw	a5,a5,a4
    80005e9e:	07f00713          	li	a4,127
    80005ea2:	fcf763e3          	bltu	a4,a5,80005e68 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005ea6:	47b5                	li	a5,13
    80005ea8:	0cf48763          	beq	s1,a5,80005f76 <consoleintr+0x14a>
      consputc(c);
    80005eac:	8526                	mv	a0,s1
    80005eae:	00000097          	auipc	ra,0x0
    80005eb2:	f3c080e7          	jalr	-196(ra) # 80005dea <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005eb6:	00024797          	auipc	a5,0x24
    80005eba:	2ba78793          	addi	a5,a5,698 # 8002a170 <cons>
    80005ebe:	0a87a703          	lw	a4,168(a5)
    80005ec2:	0017069b          	addiw	a3,a4,1
    80005ec6:	0006861b          	sext.w	a2,a3
    80005eca:	0ad7a423          	sw	a3,168(a5)
    80005ece:	07f77713          	andi	a4,a4,127
    80005ed2:	97ba                	add	a5,a5,a4
    80005ed4:	02978023          	sb	s1,32(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005ed8:	47a9                	li	a5,10
    80005eda:	0cf48563          	beq	s1,a5,80005fa4 <consoleintr+0x178>
    80005ede:	4791                	li	a5,4
    80005ee0:	0cf48263          	beq	s1,a5,80005fa4 <consoleintr+0x178>
    80005ee4:	00024797          	auipc	a5,0x24
    80005ee8:	32c7a783          	lw	a5,812(a5) # 8002a210 <cons+0xa0>
    80005eec:	0807879b          	addiw	a5,a5,128
    80005ef0:	f6f61ce3          	bne	a2,a5,80005e68 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ef4:	863e                	mv	a2,a5
    80005ef6:	a07d                	j	80005fa4 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005ef8:	00024717          	auipc	a4,0x24
    80005efc:	27870713          	addi	a4,a4,632 # 8002a170 <cons>
    80005f00:	0a872783          	lw	a5,168(a4)
    80005f04:	0a472703          	lw	a4,164(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005f08:	00024497          	auipc	s1,0x24
    80005f0c:	26848493          	addi	s1,s1,616 # 8002a170 <cons>
    while(cons.e != cons.w &&
    80005f10:	4929                	li	s2,10
    80005f12:	f4f70be3          	beq	a4,a5,80005e68 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005f16:	37fd                	addiw	a5,a5,-1
    80005f18:	07f7f713          	andi	a4,a5,127
    80005f1c:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005f1e:	02074703          	lbu	a4,32(a4)
    80005f22:	f52703e3          	beq	a4,s2,80005e68 <consoleintr+0x3c>
      cons.e--;
    80005f26:	0af4a423          	sw	a5,168(s1)
      consputc(BACKSPACE);
    80005f2a:	10000513          	li	a0,256
    80005f2e:	00000097          	auipc	ra,0x0
    80005f32:	ebc080e7          	jalr	-324(ra) # 80005dea <consputc>
    while(cons.e != cons.w &&
    80005f36:	0a84a783          	lw	a5,168(s1)
    80005f3a:	0a44a703          	lw	a4,164(s1)
    80005f3e:	fcf71ce3          	bne	a4,a5,80005f16 <consoleintr+0xea>
    80005f42:	b71d                	j	80005e68 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005f44:	00024717          	auipc	a4,0x24
    80005f48:	22c70713          	addi	a4,a4,556 # 8002a170 <cons>
    80005f4c:	0a872783          	lw	a5,168(a4)
    80005f50:	0a472703          	lw	a4,164(a4)
    80005f54:	f0f70ae3          	beq	a4,a5,80005e68 <consoleintr+0x3c>
      cons.e--;
    80005f58:	37fd                	addiw	a5,a5,-1
    80005f5a:	00024717          	auipc	a4,0x24
    80005f5e:	2af72f23          	sw	a5,702(a4) # 8002a218 <cons+0xa8>
      consputc(BACKSPACE);
    80005f62:	10000513          	li	a0,256
    80005f66:	00000097          	auipc	ra,0x0
    80005f6a:	e84080e7          	jalr	-380(ra) # 80005dea <consputc>
    80005f6e:	bded                	j	80005e68 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005f70:	ee048ce3          	beqz	s1,80005e68 <consoleintr+0x3c>
    80005f74:	bf21                	j	80005e8c <consoleintr+0x60>
      consputc(c);
    80005f76:	4529                	li	a0,10
    80005f78:	00000097          	auipc	ra,0x0
    80005f7c:	e72080e7          	jalr	-398(ra) # 80005dea <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005f80:	00024797          	auipc	a5,0x24
    80005f84:	1f078793          	addi	a5,a5,496 # 8002a170 <cons>
    80005f88:	0a87a703          	lw	a4,168(a5)
    80005f8c:	0017069b          	addiw	a3,a4,1
    80005f90:	0006861b          	sext.w	a2,a3
    80005f94:	0ad7a423          	sw	a3,168(a5)
    80005f98:	07f77713          	andi	a4,a4,127
    80005f9c:	97ba                	add	a5,a5,a4
    80005f9e:	4729                	li	a4,10
    80005fa0:	02e78023          	sb	a4,32(a5)
        cons.w = cons.e;
    80005fa4:	00024797          	auipc	a5,0x24
    80005fa8:	26c7a823          	sw	a2,624(a5) # 8002a214 <cons+0xa4>
        wakeup(&cons.r);
    80005fac:	00024517          	auipc	a0,0x24
    80005fb0:	26450513          	addi	a0,a0,612 # 8002a210 <cons+0xa0>
    80005fb4:	ffffc097          	auipc	ra,0xffffc
    80005fb8:	804080e7          	jalr	-2044(ra) # 800017b8 <wakeup>
    80005fbc:	b575                	j	80005e68 <consoleintr+0x3c>

0000000080005fbe <consoleinit>:

void
consoleinit(void)
{
    80005fbe:	1141                	addi	sp,sp,-16
    80005fc0:	e406                	sd	ra,8(sp)
    80005fc2:	e022                	sd	s0,0(sp)
    80005fc4:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005fc6:	00002597          	auipc	a1,0x2
    80005fca:	7fa58593          	addi	a1,a1,2042 # 800087c0 <digits+0x18>
    80005fce:	00024517          	auipc	a0,0x24
    80005fd2:	1a250513          	addi	a0,a0,418 # 8002a170 <cons>
    80005fd6:	00000097          	auipc	ra,0x0
    80005fda:	786080e7          	jalr	1926(ra) # 8000675c <initlock>

  uartinit();
    80005fde:	00000097          	auipc	ra,0x0
    80005fe2:	330080e7          	jalr	816(ra) # 8000630e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005fe6:	00017797          	auipc	a5,0x17
    80005fea:	cba78793          	addi	a5,a5,-838 # 8001cca0 <devsw>
    80005fee:	00000717          	auipc	a4,0x0
    80005ff2:	ce470713          	addi	a4,a4,-796 # 80005cd2 <consoleread>
    80005ff6:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005ff8:	00000717          	auipc	a4,0x0
    80005ffc:	c7870713          	addi	a4,a4,-904 # 80005c70 <consolewrite>
    80006000:	ef98                	sd	a4,24(a5)
}
    80006002:	60a2                	ld	ra,8(sp)
    80006004:	6402                	ld	s0,0(sp)
    80006006:	0141                	addi	sp,sp,16
    80006008:	8082                	ret

000000008000600a <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    8000600a:	7179                	addi	sp,sp,-48
    8000600c:	f406                	sd	ra,40(sp)
    8000600e:	f022                	sd	s0,32(sp)
    80006010:	ec26                	sd	s1,24(sp)
    80006012:	e84a                	sd	s2,16(sp)
    80006014:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80006016:	c219                	beqz	a2,8000601c <printint+0x12>
    80006018:	08054663          	bltz	a0,800060a4 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    8000601c:	2501                	sext.w	a0,a0
    8000601e:	4881                	li	a7,0
    80006020:	fd040693          	addi	a3,s0,-48

  i = 0;
    80006024:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80006026:	2581                	sext.w	a1,a1
    80006028:	00002617          	auipc	a2,0x2
    8000602c:	7b060613          	addi	a2,a2,1968 # 800087d8 <digits>
    80006030:	883a                	mv	a6,a4
    80006032:	2705                	addiw	a4,a4,1
    80006034:	02b577bb          	remuw	a5,a0,a1
    80006038:	1782                	slli	a5,a5,0x20
    8000603a:	9381                	srli	a5,a5,0x20
    8000603c:	97b2                	add	a5,a5,a2
    8000603e:	0007c783          	lbu	a5,0(a5)
    80006042:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80006046:	0005079b          	sext.w	a5,a0
    8000604a:	02b5553b          	divuw	a0,a0,a1
    8000604e:	0685                	addi	a3,a3,1
    80006050:	feb7f0e3          	bgeu	a5,a1,80006030 <printint+0x26>

  if(sign)
    80006054:	00088b63          	beqz	a7,8000606a <printint+0x60>
    buf[i++] = '-';
    80006058:	fe040793          	addi	a5,s0,-32
    8000605c:	973e                	add	a4,a4,a5
    8000605e:	02d00793          	li	a5,45
    80006062:	fef70823          	sb	a5,-16(a4)
    80006066:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    8000606a:	02e05763          	blez	a4,80006098 <printint+0x8e>
    8000606e:	fd040793          	addi	a5,s0,-48
    80006072:	00e784b3          	add	s1,a5,a4
    80006076:	fff78913          	addi	s2,a5,-1
    8000607a:	993a                	add	s2,s2,a4
    8000607c:	377d                	addiw	a4,a4,-1
    8000607e:	1702                	slli	a4,a4,0x20
    80006080:	9301                	srli	a4,a4,0x20
    80006082:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80006086:	fff4c503          	lbu	a0,-1(s1)
    8000608a:	00000097          	auipc	ra,0x0
    8000608e:	d60080e7          	jalr	-672(ra) # 80005dea <consputc>
  while(--i >= 0)
    80006092:	14fd                	addi	s1,s1,-1
    80006094:	ff2499e3          	bne	s1,s2,80006086 <printint+0x7c>
}
    80006098:	70a2                	ld	ra,40(sp)
    8000609a:	7402                	ld	s0,32(sp)
    8000609c:	64e2                	ld	s1,24(sp)
    8000609e:	6942                	ld	s2,16(sp)
    800060a0:	6145                	addi	sp,sp,48
    800060a2:	8082                	ret
    x = -xx;
    800060a4:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    800060a8:	4885                	li	a7,1
    x = -xx;
    800060aa:	bf9d                	j	80006020 <printint+0x16>

00000000800060ac <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    800060ac:	1101                	addi	sp,sp,-32
    800060ae:	ec06                	sd	ra,24(sp)
    800060b0:	e822                	sd	s0,16(sp)
    800060b2:	e426                	sd	s1,8(sp)
    800060b4:	1000                	addi	s0,sp,32
    800060b6:	84aa                	mv	s1,a0
  pr.locking = 0;
    800060b8:	00024797          	auipc	a5,0x24
    800060bc:	1807a423          	sw	zero,392(a5) # 8002a240 <pr+0x20>
  printf("panic: ");
    800060c0:	00002517          	auipc	a0,0x2
    800060c4:	70850513          	addi	a0,a0,1800 # 800087c8 <digits+0x20>
    800060c8:	00000097          	auipc	ra,0x0
    800060cc:	02e080e7          	jalr	46(ra) # 800060f6 <printf>
  printf(s);
    800060d0:	8526                	mv	a0,s1
    800060d2:	00000097          	auipc	ra,0x0
    800060d6:	024080e7          	jalr	36(ra) # 800060f6 <printf>
  printf("\n");
    800060da:	00002517          	auipc	a0,0x2
    800060de:	78650513          	addi	a0,a0,1926 # 80008860 <digits+0x88>
    800060e2:	00000097          	auipc	ra,0x0
    800060e6:	014080e7          	jalr	20(ra) # 800060f6 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800060ea:	4785                	li	a5,1
    800060ec:	00003717          	auipc	a4,0x3
    800060f0:	f2f72823          	sw	a5,-208(a4) # 8000901c <panicked>
  for(;;)
    800060f4:	a001                	j	800060f4 <panic+0x48>

00000000800060f6 <printf>:
{
    800060f6:	7131                	addi	sp,sp,-192
    800060f8:	fc86                	sd	ra,120(sp)
    800060fa:	f8a2                	sd	s0,112(sp)
    800060fc:	f4a6                	sd	s1,104(sp)
    800060fe:	f0ca                	sd	s2,96(sp)
    80006100:	ecce                	sd	s3,88(sp)
    80006102:	e8d2                	sd	s4,80(sp)
    80006104:	e4d6                	sd	s5,72(sp)
    80006106:	e0da                	sd	s6,64(sp)
    80006108:	fc5e                	sd	s7,56(sp)
    8000610a:	f862                	sd	s8,48(sp)
    8000610c:	f466                	sd	s9,40(sp)
    8000610e:	f06a                	sd	s10,32(sp)
    80006110:	ec6e                	sd	s11,24(sp)
    80006112:	0100                	addi	s0,sp,128
    80006114:	8a2a                	mv	s4,a0
    80006116:	e40c                	sd	a1,8(s0)
    80006118:	e810                	sd	a2,16(s0)
    8000611a:	ec14                	sd	a3,24(s0)
    8000611c:	f018                	sd	a4,32(s0)
    8000611e:	f41c                	sd	a5,40(s0)
    80006120:	03043823          	sd	a6,48(s0)
    80006124:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80006128:	00024d97          	auipc	s11,0x24
    8000612c:	118dad83          	lw	s11,280(s11) # 8002a240 <pr+0x20>
  if(locking)
    80006130:	020d9b63          	bnez	s11,80006166 <printf+0x70>
  if (fmt == 0)
    80006134:	040a0263          	beqz	s4,80006178 <printf+0x82>
  va_start(ap, fmt);
    80006138:	00840793          	addi	a5,s0,8
    8000613c:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006140:	000a4503          	lbu	a0,0(s4)
    80006144:	16050263          	beqz	a0,800062a8 <printf+0x1b2>
    80006148:	4481                	li	s1,0
    if(c != '%'){
    8000614a:	02500a93          	li	s5,37
    switch(c){
    8000614e:	07000b13          	li	s6,112
  consputc('x');
    80006152:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006154:	00002b97          	auipc	s7,0x2
    80006158:	684b8b93          	addi	s7,s7,1668 # 800087d8 <digits>
    switch(c){
    8000615c:	07300c93          	li	s9,115
    80006160:	06400c13          	li	s8,100
    80006164:	a82d                	j	8000619e <printf+0xa8>
    acquire(&pr.lock);
    80006166:	00024517          	auipc	a0,0x24
    8000616a:	0ba50513          	addi	a0,a0,186 # 8002a220 <pr>
    8000616e:	00000097          	auipc	ra,0x0
    80006172:	472080e7          	jalr	1138(ra) # 800065e0 <acquire>
    80006176:	bf7d                	j	80006134 <printf+0x3e>
    panic("null fmt");
    80006178:	00002517          	auipc	a0,0x2
    8000617c:	62050513          	addi	a0,a0,1568 # 80008798 <syscalls+0x3c0>
    80006180:	00000097          	auipc	ra,0x0
    80006184:	f2c080e7          	jalr	-212(ra) # 800060ac <panic>
      consputc(c);
    80006188:	00000097          	auipc	ra,0x0
    8000618c:	c62080e7          	jalr	-926(ra) # 80005dea <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006190:	2485                	addiw	s1,s1,1
    80006192:	009a07b3          	add	a5,s4,s1
    80006196:	0007c503          	lbu	a0,0(a5)
    8000619a:	10050763          	beqz	a0,800062a8 <printf+0x1b2>
    if(c != '%'){
    8000619e:	ff5515e3          	bne	a0,s5,80006188 <printf+0x92>
    c = fmt[++i] & 0xff;
    800061a2:	2485                	addiw	s1,s1,1
    800061a4:	009a07b3          	add	a5,s4,s1
    800061a8:	0007c783          	lbu	a5,0(a5)
    800061ac:	0007891b          	sext.w	s2,a5
    if(c == 0)
    800061b0:	cfe5                	beqz	a5,800062a8 <printf+0x1b2>
    switch(c){
    800061b2:	05678a63          	beq	a5,s6,80006206 <printf+0x110>
    800061b6:	02fb7663          	bgeu	s6,a5,800061e2 <printf+0xec>
    800061ba:	09978963          	beq	a5,s9,8000624c <printf+0x156>
    800061be:	07800713          	li	a4,120
    800061c2:	0ce79863          	bne	a5,a4,80006292 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    800061c6:	f8843783          	ld	a5,-120(s0)
    800061ca:	00878713          	addi	a4,a5,8
    800061ce:	f8e43423          	sd	a4,-120(s0)
    800061d2:	4605                	li	a2,1
    800061d4:	85ea                	mv	a1,s10
    800061d6:	4388                	lw	a0,0(a5)
    800061d8:	00000097          	auipc	ra,0x0
    800061dc:	e32080e7          	jalr	-462(ra) # 8000600a <printint>
      break;
    800061e0:	bf45                	j	80006190 <printf+0x9a>
    switch(c){
    800061e2:	0b578263          	beq	a5,s5,80006286 <printf+0x190>
    800061e6:	0b879663          	bne	a5,s8,80006292 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    800061ea:	f8843783          	ld	a5,-120(s0)
    800061ee:	00878713          	addi	a4,a5,8
    800061f2:	f8e43423          	sd	a4,-120(s0)
    800061f6:	4605                	li	a2,1
    800061f8:	45a9                	li	a1,10
    800061fa:	4388                	lw	a0,0(a5)
    800061fc:	00000097          	auipc	ra,0x0
    80006200:	e0e080e7          	jalr	-498(ra) # 8000600a <printint>
      break;
    80006204:	b771                	j	80006190 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80006206:	f8843783          	ld	a5,-120(s0)
    8000620a:	00878713          	addi	a4,a5,8
    8000620e:	f8e43423          	sd	a4,-120(s0)
    80006212:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80006216:	03000513          	li	a0,48
    8000621a:	00000097          	auipc	ra,0x0
    8000621e:	bd0080e7          	jalr	-1072(ra) # 80005dea <consputc>
  consputc('x');
    80006222:	07800513          	li	a0,120
    80006226:	00000097          	auipc	ra,0x0
    8000622a:	bc4080e7          	jalr	-1084(ra) # 80005dea <consputc>
    8000622e:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006230:	03c9d793          	srli	a5,s3,0x3c
    80006234:	97de                	add	a5,a5,s7
    80006236:	0007c503          	lbu	a0,0(a5)
    8000623a:	00000097          	auipc	ra,0x0
    8000623e:	bb0080e7          	jalr	-1104(ra) # 80005dea <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006242:	0992                	slli	s3,s3,0x4
    80006244:	397d                	addiw	s2,s2,-1
    80006246:	fe0915e3          	bnez	s2,80006230 <printf+0x13a>
    8000624a:	b799                	j	80006190 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    8000624c:	f8843783          	ld	a5,-120(s0)
    80006250:	00878713          	addi	a4,a5,8
    80006254:	f8e43423          	sd	a4,-120(s0)
    80006258:	0007b903          	ld	s2,0(a5)
    8000625c:	00090e63          	beqz	s2,80006278 <printf+0x182>
      for(; *s; s++)
    80006260:	00094503          	lbu	a0,0(s2)
    80006264:	d515                	beqz	a0,80006190 <printf+0x9a>
        consputc(*s);
    80006266:	00000097          	auipc	ra,0x0
    8000626a:	b84080e7          	jalr	-1148(ra) # 80005dea <consputc>
      for(; *s; s++)
    8000626e:	0905                	addi	s2,s2,1
    80006270:	00094503          	lbu	a0,0(s2)
    80006274:	f96d                	bnez	a0,80006266 <printf+0x170>
    80006276:	bf29                	j	80006190 <printf+0x9a>
        s = "(null)";
    80006278:	00002917          	auipc	s2,0x2
    8000627c:	51890913          	addi	s2,s2,1304 # 80008790 <syscalls+0x3b8>
      for(; *s; s++)
    80006280:	02800513          	li	a0,40
    80006284:	b7cd                	j	80006266 <printf+0x170>
      consputc('%');
    80006286:	8556                	mv	a0,s5
    80006288:	00000097          	auipc	ra,0x0
    8000628c:	b62080e7          	jalr	-1182(ra) # 80005dea <consputc>
      break;
    80006290:	b701                	j	80006190 <printf+0x9a>
      consputc('%');
    80006292:	8556                	mv	a0,s5
    80006294:	00000097          	auipc	ra,0x0
    80006298:	b56080e7          	jalr	-1194(ra) # 80005dea <consputc>
      consputc(c);
    8000629c:	854a                	mv	a0,s2
    8000629e:	00000097          	auipc	ra,0x0
    800062a2:	b4c080e7          	jalr	-1204(ra) # 80005dea <consputc>
      break;
    800062a6:	b5ed                	j	80006190 <printf+0x9a>
  if(locking)
    800062a8:	020d9163          	bnez	s11,800062ca <printf+0x1d4>
}
    800062ac:	70e6                	ld	ra,120(sp)
    800062ae:	7446                	ld	s0,112(sp)
    800062b0:	74a6                	ld	s1,104(sp)
    800062b2:	7906                	ld	s2,96(sp)
    800062b4:	69e6                	ld	s3,88(sp)
    800062b6:	6a46                	ld	s4,80(sp)
    800062b8:	6aa6                	ld	s5,72(sp)
    800062ba:	6b06                	ld	s6,64(sp)
    800062bc:	7be2                	ld	s7,56(sp)
    800062be:	7c42                	ld	s8,48(sp)
    800062c0:	7ca2                	ld	s9,40(sp)
    800062c2:	7d02                	ld	s10,32(sp)
    800062c4:	6de2                	ld	s11,24(sp)
    800062c6:	6129                	addi	sp,sp,192
    800062c8:	8082                	ret
    release(&pr.lock);
    800062ca:	00024517          	auipc	a0,0x24
    800062ce:	f5650513          	addi	a0,a0,-170 # 8002a220 <pr>
    800062d2:	00000097          	auipc	ra,0x0
    800062d6:	3de080e7          	jalr	990(ra) # 800066b0 <release>
}
    800062da:	bfc9                	j	800062ac <printf+0x1b6>

00000000800062dc <printfinit>:
    ;
}

void
printfinit(void)
{
    800062dc:	1101                	addi	sp,sp,-32
    800062de:	ec06                	sd	ra,24(sp)
    800062e0:	e822                	sd	s0,16(sp)
    800062e2:	e426                	sd	s1,8(sp)
    800062e4:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800062e6:	00024497          	auipc	s1,0x24
    800062ea:	f3a48493          	addi	s1,s1,-198 # 8002a220 <pr>
    800062ee:	00002597          	auipc	a1,0x2
    800062f2:	4e258593          	addi	a1,a1,1250 # 800087d0 <digits+0x28>
    800062f6:	8526                	mv	a0,s1
    800062f8:	00000097          	auipc	ra,0x0
    800062fc:	464080e7          	jalr	1124(ra) # 8000675c <initlock>
  pr.locking = 1;
    80006300:	4785                	li	a5,1
    80006302:	d09c                	sw	a5,32(s1)
}
    80006304:	60e2                	ld	ra,24(sp)
    80006306:	6442                	ld	s0,16(sp)
    80006308:	64a2                	ld	s1,8(sp)
    8000630a:	6105                	addi	sp,sp,32
    8000630c:	8082                	ret

000000008000630e <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000630e:	1141                	addi	sp,sp,-16
    80006310:	e406                	sd	ra,8(sp)
    80006312:	e022                	sd	s0,0(sp)
    80006314:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006316:	100007b7          	lui	a5,0x10000
    8000631a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000631e:	f8000713          	li	a4,-128
    80006322:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006326:	470d                	li	a4,3
    80006328:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000632c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006330:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006334:	469d                	li	a3,7
    80006336:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000633a:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000633e:	00002597          	auipc	a1,0x2
    80006342:	4b258593          	addi	a1,a1,1202 # 800087f0 <digits+0x18>
    80006346:	00024517          	auipc	a0,0x24
    8000634a:	f0250513          	addi	a0,a0,-254 # 8002a248 <uart_tx_lock>
    8000634e:	00000097          	auipc	ra,0x0
    80006352:	40e080e7          	jalr	1038(ra) # 8000675c <initlock>
}
    80006356:	60a2                	ld	ra,8(sp)
    80006358:	6402                	ld	s0,0(sp)
    8000635a:	0141                	addi	sp,sp,16
    8000635c:	8082                	ret

000000008000635e <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000635e:	1101                	addi	sp,sp,-32
    80006360:	ec06                	sd	ra,24(sp)
    80006362:	e822                	sd	s0,16(sp)
    80006364:	e426                	sd	s1,8(sp)
    80006366:	1000                	addi	s0,sp,32
    80006368:	84aa                	mv	s1,a0
  push_off();
    8000636a:	00000097          	auipc	ra,0x0
    8000636e:	22a080e7          	jalr	554(ra) # 80006594 <push_off>

  if(panicked){
    80006372:	00003797          	auipc	a5,0x3
    80006376:	caa7a783          	lw	a5,-854(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000637a:	10000737          	lui	a4,0x10000
  if(panicked){
    8000637e:	c391                	beqz	a5,80006382 <uartputc_sync+0x24>
    for(;;)
    80006380:	a001                	j	80006380 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006382:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006386:	0ff7f793          	andi	a5,a5,255
    8000638a:	0207f793          	andi	a5,a5,32
    8000638e:	dbf5                	beqz	a5,80006382 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006390:	0ff4f793          	andi	a5,s1,255
    80006394:	10000737          	lui	a4,0x10000
    80006398:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    8000639c:	00000097          	auipc	ra,0x0
    800063a0:	2b4080e7          	jalr	692(ra) # 80006650 <pop_off>
}
    800063a4:	60e2                	ld	ra,24(sp)
    800063a6:	6442                	ld	s0,16(sp)
    800063a8:	64a2                	ld	s1,8(sp)
    800063aa:	6105                	addi	sp,sp,32
    800063ac:	8082                	ret

00000000800063ae <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800063ae:	00003717          	auipc	a4,0x3
    800063b2:	c7273703          	ld	a4,-910(a4) # 80009020 <uart_tx_r>
    800063b6:	00003797          	auipc	a5,0x3
    800063ba:	c727b783          	ld	a5,-910(a5) # 80009028 <uart_tx_w>
    800063be:	06e78c63          	beq	a5,a4,80006436 <uartstart+0x88>
{
    800063c2:	7139                	addi	sp,sp,-64
    800063c4:	fc06                	sd	ra,56(sp)
    800063c6:	f822                	sd	s0,48(sp)
    800063c8:	f426                	sd	s1,40(sp)
    800063ca:	f04a                	sd	s2,32(sp)
    800063cc:	ec4e                	sd	s3,24(sp)
    800063ce:	e852                	sd	s4,16(sp)
    800063d0:	e456                	sd	s5,8(sp)
    800063d2:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800063d4:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800063d8:	00024a17          	auipc	s4,0x24
    800063dc:	e70a0a13          	addi	s4,s4,-400 # 8002a248 <uart_tx_lock>
    uart_tx_r += 1;
    800063e0:	00003497          	auipc	s1,0x3
    800063e4:	c4048493          	addi	s1,s1,-960 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800063e8:	00003997          	auipc	s3,0x3
    800063ec:	c4098993          	addi	s3,s3,-960 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800063f0:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    800063f4:	0ff7f793          	andi	a5,a5,255
    800063f8:	0207f793          	andi	a5,a5,32
    800063fc:	c785                	beqz	a5,80006424 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800063fe:	01f77793          	andi	a5,a4,31
    80006402:	97d2                	add	a5,a5,s4
    80006404:	0207ca83          	lbu	s5,32(a5)
    uart_tx_r += 1;
    80006408:	0705                	addi	a4,a4,1
    8000640a:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000640c:	8526                	mv	a0,s1
    8000640e:	ffffb097          	auipc	ra,0xffffb
    80006412:	3aa080e7          	jalr	938(ra) # 800017b8 <wakeup>
    
    WriteReg(THR, c);
    80006416:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000641a:	6098                	ld	a4,0(s1)
    8000641c:	0009b783          	ld	a5,0(s3)
    80006420:	fce798e3          	bne	a5,a4,800063f0 <uartstart+0x42>
  }
}
    80006424:	70e2                	ld	ra,56(sp)
    80006426:	7442                	ld	s0,48(sp)
    80006428:	74a2                	ld	s1,40(sp)
    8000642a:	7902                	ld	s2,32(sp)
    8000642c:	69e2                	ld	s3,24(sp)
    8000642e:	6a42                	ld	s4,16(sp)
    80006430:	6aa2                	ld	s5,8(sp)
    80006432:	6121                	addi	sp,sp,64
    80006434:	8082                	ret
    80006436:	8082                	ret

0000000080006438 <uartputc>:
{
    80006438:	7179                	addi	sp,sp,-48
    8000643a:	f406                	sd	ra,40(sp)
    8000643c:	f022                	sd	s0,32(sp)
    8000643e:	ec26                	sd	s1,24(sp)
    80006440:	e84a                	sd	s2,16(sp)
    80006442:	e44e                	sd	s3,8(sp)
    80006444:	e052                	sd	s4,0(sp)
    80006446:	1800                	addi	s0,sp,48
    80006448:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    8000644a:	00024517          	auipc	a0,0x24
    8000644e:	dfe50513          	addi	a0,a0,-514 # 8002a248 <uart_tx_lock>
    80006452:	00000097          	auipc	ra,0x0
    80006456:	18e080e7          	jalr	398(ra) # 800065e0 <acquire>
  if(panicked){
    8000645a:	00003797          	auipc	a5,0x3
    8000645e:	bc27a783          	lw	a5,-1086(a5) # 8000901c <panicked>
    80006462:	c391                	beqz	a5,80006466 <uartputc+0x2e>
    for(;;)
    80006464:	a001                	j	80006464 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006466:	00003797          	auipc	a5,0x3
    8000646a:	bc27b783          	ld	a5,-1086(a5) # 80009028 <uart_tx_w>
    8000646e:	00003717          	auipc	a4,0x3
    80006472:	bb273703          	ld	a4,-1102(a4) # 80009020 <uart_tx_r>
    80006476:	02070713          	addi	a4,a4,32
    8000647a:	02f71b63          	bne	a4,a5,800064b0 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000647e:	00024a17          	auipc	s4,0x24
    80006482:	dcaa0a13          	addi	s4,s4,-566 # 8002a248 <uart_tx_lock>
    80006486:	00003497          	auipc	s1,0x3
    8000648a:	b9a48493          	addi	s1,s1,-1126 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000648e:	00003917          	auipc	s2,0x3
    80006492:	b9a90913          	addi	s2,s2,-1126 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006496:	85d2                	mv	a1,s4
    80006498:	8526                	mv	a0,s1
    8000649a:	ffffb097          	auipc	ra,0xffffb
    8000649e:	192080e7          	jalr	402(ra) # 8000162c <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800064a2:	00093783          	ld	a5,0(s2)
    800064a6:	6098                	ld	a4,0(s1)
    800064a8:	02070713          	addi	a4,a4,32
    800064ac:	fef705e3          	beq	a4,a5,80006496 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800064b0:	00024497          	auipc	s1,0x24
    800064b4:	d9848493          	addi	s1,s1,-616 # 8002a248 <uart_tx_lock>
    800064b8:	01f7f713          	andi	a4,a5,31
    800064bc:	9726                	add	a4,a4,s1
    800064be:	03370023          	sb	s3,32(a4)
      uart_tx_w += 1;
    800064c2:	0785                	addi	a5,a5,1
    800064c4:	00003717          	auipc	a4,0x3
    800064c8:	b6f73223          	sd	a5,-1180(a4) # 80009028 <uart_tx_w>
      uartstart();
    800064cc:	00000097          	auipc	ra,0x0
    800064d0:	ee2080e7          	jalr	-286(ra) # 800063ae <uartstart>
      release(&uart_tx_lock);
    800064d4:	8526                	mv	a0,s1
    800064d6:	00000097          	auipc	ra,0x0
    800064da:	1da080e7          	jalr	474(ra) # 800066b0 <release>
}
    800064de:	70a2                	ld	ra,40(sp)
    800064e0:	7402                	ld	s0,32(sp)
    800064e2:	64e2                	ld	s1,24(sp)
    800064e4:	6942                	ld	s2,16(sp)
    800064e6:	69a2                	ld	s3,8(sp)
    800064e8:	6a02                	ld	s4,0(sp)
    800064ea:	6145                	addi	sp,sp,48
    800064ec:	8082                	ret

00000000800064ee <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800064ee:	1141                	addi	sp,sp,-16
    800064f0:	e422                	sd	s0,8(sp)
    800064f2:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800064f4:	100007b7          	lui	a5,0x10000
    800064f8:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800064fc:	8b85                	andi	a5,a5,1
    800064fe:	cb91                	beqz	a5,80006512 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006500:	100007b7          	lui	a5,0x10000
    80006504:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006508:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    8000650c:	6422                	ld	s0,8(sp)
    8000650e:	0141                	addi	sp,sp,16
    80006510:	8082                	ret
    return -1;
    80006512:	557d                	li	a0,-1
    80006514:	bfe5                	j	8000650c <uartgetc+0x1e>

0000000080006516 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006516:	1101                	addi	sp,sp,-32
    80006518:	ec06                	sd	ra,24(sp)
    8000651a:	e822                	sd	s0,16(sp)
    8000651c:	e426                	sd	s1,8(sp)
    8000651e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006520:	54fd                	li	s1,-1
    int c = uartgetc();
    80006522:	00000097          	auipc	ra,0x0
    80006526:	fcc080e7          	jalr	-52(ra) # 800064ee <uartgetc>
    if(c == -1)
    8000652a:	00950763          	beq	a0,s1,80006538 <uartintr+0x22>
      break;
    consoleintr(c);
    8000652e:	00000097          	auipc	ra,0x0
    80006532:	8fe080e7          	jalr	-1794(ra) # 80005e2c <consoleintr>
  while(1){
    80006536:	b7f5                	j	80006522 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006538:	00024497          	auipc	s1,0x24
    8000653c:	d1048493          	addi	s1,s1,-752 # 8002a248 <uart_tx_lock>
    80006540:	8526                	mv	a0,s1
    80006542:	00000097          	auipc	ra,0x0
    80006546:	09e080e7          	jalr	158(ra) # 800065e0 <acquire>
  uartstart();
    8000654a:	00000097          	auipc	ra,0x0
    8000654e:	e64080e7          	jalr	-412(ra) # 800063ae <uartstart>
  release(&uart_tx_lock);
    80006552:	8526                	mv	a0,s1
    80006554:	00000097          	auipc	ra,0x0
    80006558:	15c080e7          	jalr	348(ra) # 800066b0 <release>
}
    8000655c:	60e2                	ld	ra,24(sp)
    8000655e:	6442                	ld	s0,16(sp)
    80006560:	64a2                	ld	s1,8(sp)
    80006562:	6105                	addi	sp,sp,32
    80006564:	8082                	ret

0000000080006566 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006566:	411c                	lw	a5,0(a0)
    80006568:	e399                	bnez	a5,8000656e <holding+0x8>
    8000656a:	4501                	li	a0,0
  return r;
}
    8000656c:	8082                	ret
{
    8000656e:	1101                	addi	sp,sp,-32
    80006570:	ec06                	sd	ra,24(sp)
    80006572:	e822                	sd	s0,16(sp)
    80006574:	e426                	sd	s1,8(sp)
    80006576:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006578:	6904                	ld	s1,16(a0)
    8000657a:	ffffb097          	auipc	ra,0xffffb
    8000657e:	9da080e7          	jalr	-1574(ra) # 80000f54 <mycpu>
    80006582:	40a48533          	sub	a0,s1,a0
    80006586:	00153513          	seqz	a0,a0
}
    8000658a:	60e2                	ld	ra,24(sp)
    8000658c:	6442                	ld	s0,16(sp)
    8000658e:	64a2                	ld	s1,8(sp)
    80006590:	6105                	addi	sp,sp,32
    80006592:	8082                	ret

0000000080006594 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006594:	1101                	addi	sp,sp,-32
    80006596:	ec06                	sd	ra,24(sp)
    80006598:	e822                	sd	s0,16(sp)
    8000659a:	e426                	sd	s1,8(sp)
    8000659c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000659e:	100024f3          	csrr	s1,sstatus
    800065a2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800065a6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800065a8:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800065ac:	ffffb097          	auipc	ra,0xffffb
    800065b0:	9a8080e7          	jalr	-1624(ra) # 80000f54 <mycpu>
    800065b4:	5d3c                	lw	a5,120(a0)
    800065b6:	cf89                	beqz	a5,800065d0 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800065b8:	ffffb097          	auipc	ra,0xffffb
    800065bc:	99c080e7          	jalr	-1636(ra) # 80000f54 <mycpu>
    800065c0:	5d3c                	lw	a5,120(a0)
    800065c2:	2785                	addiw	a5,a5,1
    800065c4:	dd3c                	sw	a5,120(a0)
}
    800065c6:	60e2                	ld	ra,24(sp)
    800065c8:	6442                	ld	s0,16(sp)
    800065ca:	64a2                	ld	s1,8(sp)
    800065cc:	6105                	addi	sp,sp,32
    800065ce:	8082                	ret
    mycpu()->intena = old;
    800065d0:	ffffb097          	auipc	ra,0xffffb
    800065d4:	984080e7          	jalr	-1660(ra) # 80000f54 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800065d8:	8085                	srli	s1,s1,0x1
    800065da:	8885                	andi	s1,s1,1
    800065dc:	dd64                	sw	s1,124(a0)
    800065de:	bfe9                	j	800065b8 <push_off+0x24>

00000000800065e0 <acquire>:
{
    800065e0:	1101                	addi	sp,sp,-32
    800065e2:	ec06                	sd	ra,24(sp)
    800065e4:	e822                	sd	s0,16(sp)
    800065e6:	e426                	sd	s1,8(sp)
    800065e8:	1000                	addi	s0,sp,32
    800065ea:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800065ec:	00000097          	auipc	ra,0x0
    800065f0:	fa8080e7          	jalr	-88(ra) # 80006594 <push_off>
  if(holding(lk))
    800065f4:	8526                	mv	a0,s1
    800065f6:	00000097          	auipc	ra,0x0
    800065fa:	f70080e7          	jalr	-144(ra) # 80006566 <holding>
    800065fe:	e911                	bnez	a0,80006612 <acquire+0x32>
    __sync_fetch_and_add(&(lk->n), 1);
    80006600:	4785                	li	a5,1
    80006602:	01c48713          	addi	a4,s1,28
    80006606:	0f50000f          	fence	iorw,ow
    8000660a:	04f7202f          	amoadd.w.aq	zero,a5,(a4)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    8000660e:	4705                	li	a4,1
    80006610:	a839                	j	8000662e <acquire+0x4e>
    panic("acquire");
    80006612:	00002517          	auipc	a0,0x2
    80006616:	1e650513          	addi	a0,a0,486 # 800087f8 <digits+0x20>
    8000661a:	00000097          	auipc	ra,0x0
    8000661e:	a92080e7          	jalr	-1390(ra) # 800060ac <panic>
    __sync_fetch_and_add(&(lk->nts), 1);
    80006622:	01848793          	addi	a5,s1,24
    80006626:	0f50000f          	fence	iorw,ow
    8000662a:	04e7a02f          	amoadd.w.aq	zero,a4,(a5)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    8000662e:	87ba                	mv	a5,a4
    80006630:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006634:	2781                	sext.w	a5,a5
    80006636:	f7f5                	bnez	a5,80006622 <acquire+0x42>
  __sync_synchronize();
    80006638:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000663c:	ffffb097          	auipc	ra,0xffffb
    80006640:	918080e7          	jalr	-1768(ra) # 80000f54 <mycpu>
    80006644:	e888                	sd	a0,16(s1)
}
    80006646:	60e2                	ld	ra,24(sp)
    80006648:	6442                	ld	s0,16(sp)
    8000664a:	64a2                	ld	s1,8(sp)
    8000664c:	6105                	addi	sp,sp,32
    8000664e:	8082                	ret

0000000080006650 <pop_off>:

void
pop_off(void)
{
    80006650:	1141                	addi	sp,sp,-16
    80006652:	e406                	sd	ra,8(sp)
    80006654:	e022                	sd	s0,0(sp)
    80006656:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006658:	ffffb097          	auipc	ra,0xffffb
    8000665c:	8fc080e7          	jalr	-1796(ra) # 80000f54 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006660:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006664:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006666:	e78d                	bnez	a5,80006690 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006668:	5d3c                	lw	a5,120(a0)
    8000666a:	02f05b63          	blez	a5,800066a0 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000666e:	37fd                	addiw	a5,a5,-1
    80006670:	0007871b          	sext.w	a4,a5
    80006674:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006676:	eb09                	bnez	a4,80006688 <pop_off+0x38>
    80006678:	5d7c                	lw	a5,124(a0)
    8000667a:	c799                	beqz	a5,80006688 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000667c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006680:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006684:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006688:	60a2                	ld	ra,8(sp)
    8000668a:	6402                	ld	s0,0(sp)
    8000668c:	0141                	addi	sp,sp,16
    8000668e:	8082                	ret
    panic("pop_off - interruptible");
    80006690:	00002517          	auipc	a0,0x2
    80006694:	17050513          	addi	a0,a0,368 # 80008800 <digits+0x28>
    80006698:	00000097          	auipc	ra,0x0
    8000669c:	a14080e7          	jalr	-1516(ra) # 800060ac <panic>
    panic("pop_off");
    800066a0:	00002517          	auipc	a0,0x2
    800066a4:	17850513          	addi	a0,a0,376 # 80008818 <digits+0x40>
    800066a8:	00000097          	auipc	ra,0x0
    800066ac:	a04080e7          	jalr	-1532(ra) # 800060ac <panic>

00000000800066b0 <release>:
{
    800066b0:	1101                	addi	sp,sp,-32
    800066b2:	ec06                	sd	ra,24(sp)
    800066b4:	e822                	sd	s0,16(sp)
    800066b6:	e426                	sd	s1,8(sp)
    800066b8:	1000                	addi	s0,sp,32
    800066ba:	84aa                	mv	s1,a0
  if(!holding(lk))
    800066bc:	00000097          	auipc	ra,0x0
    800066c0:	eaa080e7          	jalr	-342(ra) # 80006566 <holding>
    800066c4:	c115                	beqz	a0,800066e8 <release+0x38>
  lk->cpu = 0;
    800066c6:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800066ca:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800066ce:	0f50000f          	fence	iorw,ow
    800066d2:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800066d6:	00000097          	auipc	ra,0x0
    800066da:	f7a080e7          	jalr	-134(ra) # 80006650 <pop_off>
}
    800066de:	60e2                	ld	ra,24(sp)
    800066e0:	6442                	ld	s0,16(sp)
    800066e2:	64a2                	ld	s1,8(sp)
    800066e4:	6105                	addi	sp,sp,32
    800066e6:	8082                	ret
    panic("release");
    800066e8:	00002517          	auipc	a0,0x2
    800066ec:	13850513          	addi	a0,a0,312 # 80008820 <digits+0x48>
    800066f0:	00000097          	auipc	ra,0x0
    800066f4:	9bc080e7          	jalr	-1604(ra) # 800060ac <panic>

00000000800066f8 <freelock>:
{
    800066f8:	1101                	addi	sp,sp,-32
    800066fa:	ec06                	sd	ra,24(sp)
    800066fc:	e822                	sd	s0,16(sp)
    800066fe:	e426                	sd	s1,8(sp)
    80006700:	1000                	addi	s0,sp,32
    80006702:	84aa                	mv	s1,a0
  acquire(&lock_locks);
    80006704:	00024517          	auipc	a0,0x24
    80006708:	b8450513          	addi	a0,a0,-1148 # 8002a288 <lock_locks>
    8000670c:	00000097          	auipc	ra,0x0
    80006710:	ed4080e7          	jalr	-300(ra) # 800065e0 <acquire>
  for (i = 0; i < NLOCK; i++) {
    80006714:	00024717          	auipc	a4,0x24
    80006718:	b9470713          	addi	a4,a4,-1132 # 8002a2a8 <locks>
    8000671c:	4781                	li	a5,0
    8000671e:	1f400613          	li	a2,500
    if(locks[i] == lk) {
    80006722:	6314                	ld	a3,0(a4)
    80006724:	00968763          	beq	a3,s1,80006732 <freelock+0x3a>
  for (i = 0; i < NLOCK; i++) {
    80006728:	2785                	addiw	a5,a5,1
    8000672a:	0721                	addi	a4,a4,8
    8000672c:	fec79be3          	bne	a5,a2,80006722 <freelock+0x2a>
    80006730:	a809                	j	80006742 <freelock+0x4a>
      locks[i] = 0;
    80006732:	078e                	slli	a5,a5,0x3
    80006734:	00024717          	auipc	a4,0x24
    80006738:	b7470713          	addi	a4,a4,-1164 # 8002a2a8 <locks>
    8000673c:	97ba                	add	a5,a5,a4
    8000673e:	0007b023          	sd	zero,0(a5)
  release(&lock_locks);
    80006742:	00024517          	auipc	a0,0x24
    80006746:	b4650513          	addi	a0,a0,-1210 # 8002a288 <lock_locks>
    8000674a:	00000097          	auipc	ra,0x0
    8000674e:	f66080e7          	jalr	-154(ra) # 800066b0 <release>
}
    80006752:	60e2                	ld	ra,24(sp)
    80006754:	6442                	ld	s0,16(sp)
    80006756:	64a2                	ld	s1,8(sp)
    80006758:	6105                	addi	sp,sp,32
    8000675a:	8082                	ret

000000008000675c <initlock>:
{
    8000675c:	1101                	addi	sp,sp,-32
    8000675e:	ec06                	sd	ra,24(sp)
    80006760:	e822                	sd	s0,16(sp)
    80006762:	e426                	sd	s1,8(sp)
    80006764:	1000                	addi	s0,sp,32
    80006766:	84aa                	mv	s1,a0
  lk->name = name;
    80006768:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000676a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000676e:	00053823          	sd	zero,16(a0)
  lk->nts = 0;
    80006772:	00052c23          	sw	zero,24(a0)
  lk->n = 0;
    80006776:	00052e23          	sw	zero,28(a0)
  acquire(&lock_locks);
    8000677a:	00024517          	auipc	a0,0x24
    8000677e:	b0e50513          	addi	a0,a0,-1266 # 8002a288 <lock_locks>
    80006782:	00000097          	auipc	ra,0x0
    80006786:	e5e080e7          	jalr	-418(ra) # 800065e0 <acquire>
  for (i = 0; i < NLOCK; i++) {
    8000678a:	00024717          	auipc	a4,0x24
    8000678e:	b1e70713          	addi	a4,a4,-1250 # 8002a2a8 <locks>
    80006792:	4781                	li	a5,0
    80006794:	1f400693          	li	a3,500
    if(locks[i] == 0) {
    80006798:	6310                	ld	a2,0(a4)
    8000679a:	ce09                	beqz	a2,800067b4 <initlock+0x58>
  for (i = 0; i < NLOCK; i++) {
    8000679c:	2785                	addiw	a5,a5,1
    8000679e:	0721                	addi	a4,a4,8
    800067a0:	fed79ce3          	bne	a5,a3,80006798 <initlock+0x3c>
  panic("findslot");
    800067a4:	00002517          	auipc	a0,0x2
    800067a8:	08450513          	addi	a0,a0,132 # 80008828 <digits+0x50>
    800067ac:	00000097          	auipc	ra,0x0
    800067b0:	900080e7          	jalr	-1792(ra) # 800060ac <panic>
      locks[i] = lk;
    800067b4:	078e                	slli	a5,a5,0x3
    800067b6:	00024717          	auipc	a4,0x24
    800067ba:	af270713          	addi	a4,a4,-1294 # 8002a2a8 <locks>
    800067be:	97ba                	add	a5,a5,a4
    800067c0:	e384                	sd	s1,0(a5)
      release(&lock_locks);
    800067c2:	00024517          	auipc	a0,0x24
    800067c6:	ac650513          	addi	a0,a0,-1338 # 8002a288 <lock_locks>
    800067ca:	00000097          	auipc	ra,0x0
    800067ce:	ee6080e7          	jalr	-282(ra) # 800066b0 <release>
}
    800067d2:	60e2                	ld	ra,24(sp)
    800067d4:	6442                	ld	s0,16(sp)
    800067d6:	64a2                	ld	s1,8(sp)
    800067d8:	6105                	addi	sp,sp,32
    800067da:	8082                	ret

00000000800067dc <lockfree_read8>:

// Read a shared 64-bit value without holding a lock
uint64
lockfree_read8(uint64 *addr) {
    800067dc:	1141                	addi	sp,sp,-16
    800067de:	e422                	sd	s0,8(sp)
    800067e0:	0800                	addi	s0,sp,16
  uint64 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    800067e2:	0ff0000f          	fence
    800067e6:	6108                	ld	a0,0(a0)
    800067e8:	0ff0000f          	fence
  return val;
}
    800067ec:	6422                	ld	s0,8(sp)
    800067ee:	0141                	addi	sp,sp,16
    800067f0:	8082                	ret

00000000800067f2 <lockfree_read4>:

// Read a shared 32-bit value without holding a lock
int
lockfree_read4(int *addr) {
    800067f2:	1141                	addi	sp,sp,-16
    800067f4:	e422                	sd	s0,8(sp)
    800067f6:	0800                	addi	s0,sp,16
  uint32 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    800067f8:	0ff0000f          	fence
    800067fc:	4108                	lw	a0,0(a0)
    800067fe:	0ff0000f          	fence
  return val;
}
    80006802:	2501                	sext.w	a0,a0
    80006804:	6422                	ld	s0,8(sp)
    80006806:	0141                	addi	sp,sp,16
    80006808:	8082                	ret

000000008000680a <snprint_lock>:
#ifdef LAB_LOCK
int
snprint_lock(char *buf, int sz, struct spinlock *lk)
{
  int n = 0;
  if(lk->n > 0) {
    8000680a:	4e5c                	lw	a5,28(a2)
    8000680c:	00f04463          	bgtz	a5,80006814 <snprint_lock+0xa>
  int n = 0;
    80006810:	4501                	li	a0,0
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
                 lk->name, lk->nts, lk->n);
  }
  return n;
}
    80006812:	8082                	ret
{
    80006814:	1141                	addi	sp,sp,-16
    80006816:	e406                	sd	ra,8(sp)
    80006818:	e022                	sd	s0,0(sp)
    8000681a:	0800                	addi	s0,sp,16
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
    8000681c:	4e18                	lw	a4,24(a2)
    8000681e:	6614                	ld	a3,8(a2)
    80006820:	00002617          	auipc	a2,0x2
    80006824:	01860613          	addi	a2,a2,24 # 80008838 <digits+0x60>
    80006828:	fffff097          	auipc	ra,0xfffff
    8000682c:	1ea080e7          	jalr	490(ra) # 80005a12 <snprintf>
}
    80006830:	60a2                	ld	ra,8(sp)
    80006832:	6402                	ld	s0,0(sp)
    80006834:	0141                	addi	sp,sp,16
    80006836:	8082                	ret

0000000080006838 <statslock>:

int
statslock(char *buf, int sz) {
    80006838:	7159                	addi	sp,sp,-112
    8000683a:	f486                	sd	ra,104(sp)
    8000683c:	f0a2                	sd	s0,96(sp)
    8000683e:	eca6                	sd	s1,88(sp)
    80006840:	e8ca                	sd	s2,80(sp)
    80006842:	e4ce                	sd	s3,72(sp)
    80006844:	e0d2                	sd	s4,64(sp)
    80006846:	fc56                	sd	s5,56(sp)
    80006848:	f85a                	sd	s6,48(sp)
    8000684a:	f45e                	sd	s7,40(sp)
    8000684c:	f062                	sd	s8,32(sp)
    8000684e:	ec66                	sd	s9,24(sp)
    80006850:	e86a                	sd	s10,16(sp)
    80006852:	e46e                	sd	s11,8(sp)
    80006854:	1880                	addi	s0,sp,112
    80006856:	8aaa                	mv	s5,a0
    80006858:	8b2e                	mv	s6,a1
  int n;
  int tot = 0;

  acquire(&lock_locks);
    8000685a:	00024517          	auipc	a0,0x24
    8000685e:	a2e50513          	addi	a0,a0,-1490 # 8002a288 <lock_locks>
    80006862:	00000097          	auipc	ra,0x0
    80006866:	d7e080e7          	jalr	-642(ra) # 800065e0 <acquire>
  n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    8000686a:	00002617          	auipc	a2,0x2
    8000686e:	ffe60613          	addi	a2,a2,-2 # 80008868 <digits+0x90>
    80006872:	85da                	mv	a1,s6
    80006874:	8556                	mv	a0,s5
    80006876:	fffff097          	auipc	ra,0xfffff
    8000687a:	19c080e7          	jalr	412(ra) # 80005a12 <snprintf>
    8000687e:	892a                	mv	s2,a0
  for(int i = 0; i < NLOCK; i++) {
    80006880:	00024c97          	auipc	s9,0x24
    80006884:	a28c8c93          	addi	s9,s9,-1496 # 8002a2a8 <locks>
    80006888:	00025c17          	auipc	s8,0x25
    8000688c:	9c0c0c13          	addi	s8,s8,-1600 # 8002b248 <end>
  n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    80006890:	84e6                	mv	s1,s9
  int tot = 0;
    80006892:	4a01                	li	s4,0
    if(locks[i] == 0)
      break;
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006894:	00002b97          	auipc	s7,0x2
    80006898:	bf4b8b93          	addi	s7,s7,-1036 # 80008488 <syscalls+0xb0>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    8000689c:	00001d17          	auipc	s10,0x1
    800068a0:	78cd0d13          	addi	s10,s10,1932 # 80008028 <etext+0x28>
    800068a4:	a01d                	j	800068ca <statslock+0x92>
      tot += locks[i]->nts;
    800068a6:	0009b603          	ld	a2,0(s3)
    800068aa:	4e1c                	lw	a5,24(a2)
    800068ac:	01478a3b          	addw	s4,a5,s4
      n += snprint_lock(buf +n, sz-n, locks[i]);
    800068b0:	412b05bb          	subw	a1,s6,s2
    800068b4:	012a8533          	add	a0,s5,s2
    800068b8:	00000097          	auipc	ra,0x0
    800068bc:	f52080e7          	jalr	-174(ra) # 8000680a <snprint_lock>
    800068c0:	0125093b          	addw	s2,a0,s2
  for(int i = 0; i < NLOCK; i++) {
    800068c4:	04a1                	addi	s1,s1,8
    800068c6:	05848763          	beq	s1,s8,80006914 <statslock+0xdc>
    if(locks[i] == 0)
    800068ca:	89a6                	mv	s3,s1
    800068cc:	609c                	ld	a5,0(s1)
    800068ce:	c3b9                	beqz	a5,80006914 <statslock+0xdc>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    800068d0:	0087bd83          	ld	s11,8(a5)
    800068d4:	855e                	mv	a0,s7
    800068d6:	ffffa097          	auipc	ra,0xffffa
    800068da:	b3e080e7          	jalr	-1218(ra) # 80000414 <strlen>
    800068de:	0005061b          	sext.w	a2,a0
    800068e2:	85de                	mv	a1,s7
    800068e4:	856e                	mv	a0,s11
    800068e6:	ffffa097          	auipc	ra,0xffffa
    800068ea:	a82080e7          	jalr	-1406(ra) # 80000368 <strncmp>
    800068ee:	dd45                	beqz	a0,800068a6 <statslock+0x6e>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    800068f0:	609c                	ld	a5,0(s1)
    800068f2:	0087bd83          	ld	s11,8(a5)
    800068f6:	856a                	mv	a0,s10
    800068f8:	ffffa097          	auipc	ra,0xffffa
    800068fc:	b1c080e7          	jalr	-1252(ra) # 80000414 <strlen>
    80006900:	0005061b          	sext.w	a2,a0
    80006904:	85ea                	mv	a1,s10
    80006906:	856e                	mv	a0,s11
    80006908:	ffffa097          	auipc	ra,0xffffa
    8000690c:	a60080e7          	jalr	-1440(ra) # 80000368 <strncmp>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006910:	f955                	bnez	a0,800068c4 <statslock+0x8c>
    80006912:	bf51                	j	800068a6 <statslock+0x6e>
    }
  }
  
  n += snprintf(buf+n, sz-n, "--- top 5 contended locks:\n");
    80006914:	00002617          	auipc	a2,0x2
    80006918:	f7460613          	addi	a2,a2,-140 # 80008888 <digits+0xb0>
    8000691c:	412b05bb          	subw	a1,s6,s2
    80006920:	012a8533          	add	a0,s5,s2
    80006924:	fffff097          	auipc	ra,0xfffff
    80006928:	0ee080e7          	jalr	238(ra) # 80005a12 <snprintf>
    8000692c:	012509bb          	addw	s3,a0,s2
    80006930:	4b95                	li	s7,5
  int last = 100000000;
    80006932:	05f5e537          	lui	a0,0x5f5e
    80006936:	10050513          	addi	a0,a0,256 # 5f5e100 <_entry-0x7a0a1f00>
  // stupid way to compute top 5 contended locks
  for(int t = 0; t < 5; t++) {
    int top = 0;
    for(int i = 0; i < NLOCK; i++) {
    8000693a:	4c01                	li	s8,0
      if(locks[i] == 0)
        break;
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    8000693c:	00024497          	auipc	s1,0x24
    80006940:	96c48493          	addi	s1,s1,-1684 # 8002a2a8 <locks>
    for(int i = 0; i < NLOCK; i++) {
    80006944:	1f400913          	li	s2,500
    80006948:	a881                	j	80006998 <statslock+0x160>
    8000694a:	2705                	addiw	a4,a4,1
    8000694c:	06a1                	addi	a3,a3,8
    8000694e:	03270063          	beq	a4,s2,8000696e <statslock+0x136>
      if(locks[i] == 0)
    80006952:	629c                	ld	a5,0(a3)
    80006954:	cf89                	beqz	a5,8000696e <statslock+0x136>
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80006956:	4f90                	lw	a2,24(a5)
    80006958:	00359793          	slli	a5,a1,0x3
    8000695c:	97a6                	add	a5,a5,s1
    8000695e:	639c                	ld	a5,0(a5)
    80006960:	4f9c                	lw	a5,24(a5)
    80006962:	fec7d4e3          	bge	a5,a2,8000694a <statslock+0x112>
    80006966:	fea652e3          	bge	a2,a0,8000694a <statslock+0x112>
    8000696a:	85ba                	mv	a1,a4
    8000696c:	bff9                	j	8000694a <statslock+0x112>
        top = i;
      }
    }
    n += snprint_lock(buf+n, sz-n, locks[top]);
    8000696e:	058e                	slli	a1,a1,0x3
    80006970:	00b48d33          	add	s10,s1,a1
    80006974:	000d3603          	ld	a2,0(s10)
    80006978:	413b05bb          	subw	a1,s6,s3
    8000697c:	013a8533          	add	a0,s5,s3
    80006980:	00000097          	auipc	ra,0x0
    80006984:	e8a080e7          	jalr	-374(ra) # 8000680a <snprint_lock>
    80006988:	013509bb          	addw	s3,a0,s3
    last = locks[top]->nts;
    8000698c:	000d3783          	ld	a5,0(s10)
    80006990:	4f88                	lw	a0,24(a5)
  for(int t = 0; t < 5; t++) {
    80006992:	3bfd                	addiw	s7,s7,-1
    80006994:	000b8663          	beqz	s7,800069a0 <statslock+0x168>
  int tot = 0;
    80006998:	86e6                	mv	a3,s9
    for(int i = 0; i < NLOCK; i++) {
    8000699a:	8762                	mv	a4,s8
    int top = 0;
    8000699c:	85e2                	mv	a1,s8
    8000699e:	bf55                	j	80006952 <statslock+0x11a>
  }
  n += snprintf(buf+n, sz-n, "tot= %d\n", tot);
    800069a0:	86d2                	mv	a3,s4
    800069a2:	00002617          	auipc	a2,0x2
    800069a6:	f0660613          	addi	a2,a2,-250 # 800088a8 <digits+0xd0>
    800069aa:	413b05bb          	subw	a1,s6,s3
    800069ae:	013a8533          	add	a0,s5,s3
    800069b2:	fffff097          	auipc	ra,0xfffff
    800069b6:	060080e7          	jalr	96(ra) # 80005a12 <snprintf>
    800069ba:	013509bb          	addw	s3,a0,s3
  release(&lock_locks);  
    800069be:	00024517          	auipc	a0,0x24
    800069c2:	8ca50513          	addi	a0,a0,-1846 # 8002a288 <lock_locks>
    800069c6:	00000097          	auipc	ra,0x0
    800069ca:	cea080e7          	jalr	-790(ra) # 800066b0 <release>
  return n;
}
    800069ce:	854e                	mv	a0,s3
    800069d0:	70a6                	ld	ra,104(sp)
    800069d2:	7406                	ld	s0,96(sp)
    800069d4:	64e6                	ld	s1,88(sp)
    800069d6:	6946                	ld	s2,80(sp)
    800069d8:	69a6                	ld	s3,72(sp)
    800069da:	6a06                	ld	s4,64(sp)
    800069dc:	7ae2                	ld	s5,56(sp)
    800069de:	7b42                	ld	s6,48(sp)
    800069e0:	7ba2                	ld	s7,40(sp)
    800069e2:	7c02                	ld	s8,32(sp)
    800069e4:	6ce2                	ld	s9,24(sp)
    800069e6:	6d42                	ld	s10,16(sp)
    800069e8:	6da2                	ld	s11,8(sp)
    800069ea:	6165                	addi	sp,sp,112
    800069ec:	8082                	ret
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
