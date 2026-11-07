#ifdef ISAAC_BRANCHES
#ifndef BRANCH_REPEATS
#define BRANCH_REPEATS 1
#endif
#define DECLARE_PROBE(n) extern u32 probe_##n(u32,u32); extern u32 back_##n(u32,u32);
DECLARE_PROBE(beq) DECLARE_PROBE(bne) DECLARE_PROBE(blt) DECLARE_PROBE(bge) DECLARE_PROBE(bltu) DECLARE_PROBE(bgeu)
static int effect_checks(void) {
 u32 (*forward[])(u32,u32)={probe_beq,probe_bne,probe_blt,probe_bge,probe_bltu,probe_bgeu};
 u32 (*back[])(u32,u32)={back_beq,back_bne,back_blt,back_bge,back_bltu,back_bgeu};
 const u32 inputs[][2]={{7,7},{6,7},{8,8},{0x80000000u,~0u},{~0u,~0u},{0,0},{0x80000007u,~0u}};
 for (u32 repeat=0;repeat<BRANCH_REPEATS;repeat++)
 for (u32 j=0;j<6;j++) {
  puts_uart("BRANCH BEGIN probe=");hex(j);puts_uart("\r\n");
  for (u32 i=0;i<7;i++) {
   u32 a=inputs[i][0],b=inputs[i][1],v=a&b;
   u32 want[]={v==7,v!=7,(int)v<7,(int)v>=7,v<7,v>=7};
   u32 f=forward[j](a,b),r=back[j](a,b);
   if (f!=want[j]||r!=want[j]) {puts_uart("BRANCH FAIL input=");hex(i);puts_uart(" forward=");hex(f);puts_uart(" back=");hex(r);puts_uart(" want=");hex(want[j]);puts_uart("\r\n");return 1;}
  }
 }
 puts_uart("BRANCH PASS checks=");hex(84u*BRANCH_REPEATS);puts_uart("\r\n");return 0;
}
#endif
#ifdef ISAAC_STORES
static int effect_checks(void) {
 for (u32 mode=0;mode<3;mode++) {
  puts_uart("STORE BEGIN probe=");hex(mode);puts_uart("\r\n");
  for (u32 i=0;i<16;i++) {
   u32 original=0xa5c36f18u,value=0xf00d1234u^(i*0x1234567u),result=value^7u;
   u32 lane=mode==0?(i&3):mode==1?(i&2):0;
   scratch[0]=0x11223344u;scratch[1]=original;scratch[2]=0x55667788u;
   u32 addr=(u32)&scratch[1]+lane;
   if (mode==0) __asm__ volatile(".insn r 0x2b,0,0,zero,%0,%1"::"r"(addr),"r"(value):"memory");
   else if (mode==1) __asm__ volatile(".insn r 0x2b,1,0,zero,%0,%1"::"r"(addr),"r"(value):"memory");
   else __asm__ volatile(".insn r 0x2b,2,0,zero,%0,%1"::"r"(addr),"r"(value):"memory");
   __asm__ volatile("fence rw,rw":::"memory");
   u32 mask=mode==0?0xffu<<(lane*8):mode==1?0xffffu<<(lane*8):~0u;
   u32 want=(original&~mask)|((result<<(lane*8))&mask),got=scratch[1];
   if (got!=want||scratch[0]!=0x11223344u||scratch[2]!=0x55667788u) {puts_uart("STORE FAIL input=");hex(i);puts_uart(" got=");hex(got);puts_uart(" want=");hex(want);puts_uart("\r\n");return 1;}
  }
 }
 puts_uart("STORE PASS checks=00000030\r\n");return 0;
}
#endif
