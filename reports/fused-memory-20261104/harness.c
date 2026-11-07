typedef unsigned (*test_fn)(unsigned,unsigned,unsigned);
extern unsigned selected_MEM_ADDR_LB(unsigned,unsigned,unsigned);
extern unsigned native_MEM_ADDR_LB(unsigned,unsigned,unsigned);
extern unsigned selected_MEM_ADDR_LBU(unsigned,unsigned,unsigned);
extern unsigned native_MEM_ADDR_LBU(unsigned,unsigned,unsigned);
extern unsigned selected_MEM_ADDR_LH(unsigned,unsigned,unsigned);
extern unsigned native_MEM_ADDR_LH(unsigned,unsigned,unsigned);
extern unsigned selected_MEM_ADDR_LHU(unsigned,unsigned,unsigned);
extern unsigned native_MEM_ADDR_LHU(unsigned,unsigned,unsigned);
extern unsigned selected_MEM_ADDR_LW(unsigned,unsigned,unsigned);
extern unsigned native_MEM_ADDR_LW(unsigned,unsigned,unsigned);
extern unsigned selected_MEM_LOADADD_LB(unsigned,unsigned,unsigned);
extern unsigned native_MEM_LOADADD_LB(unsigned,unsigned,unsigned);
extern unsigned selected_MEM_LOADADD_LBU(unsigned,unsigned,unsigned);
extern unsigned native_MEM_LOADADD_LBU(unsigned,unsigned,unsigned);
extern unsigned selected_MEM_LOADADD_LH(unsigned,unsigned,unsigned);
extern unsigned native_MEM_LOADADD_LH(unsigned,unsigned,unsigned);
extern unsigned selected_MEM_LOADADD_LHU(unsigned,unsigned,unsigned);
extern unsigned native_MEM_LOADADD_LHU(unsigned,unsigned,unsigned);
extern unsigned selected_MEM_LOADADD_LW(unsigned,unsigned,unsigned);
extern unsigned native_MEM_LOADADD_LW(unsigned,unsigned,unsigned);
extern unsigned selected_MEM_ADDR_SB(unsigned,unsigned,unsigned);
extern unsigned native_MEM_ADDR_SB(unsigned,unsigned,unsigned);
extern unsigned selected_MEM_ADDR_SH(unsigned,unsigned,unsigned);
extern unsigned native_MEM_ADDR_SH(unsigned,unsigned,unsigned);
extern unsigned selected_MEM_ADDR_SW(unsigned,unsigned,unsigned);
extern unsigned native_MEM_ADDR_SW(unsigned,unsigned,unsigned);
extern unsigned selected_MEM_STOREXOR_SB(unsigned,unsigned,unsigned);
extern unsigned native_MEM_STOREXOR_SB(unsigned,unsigned,unsigned);
extern unsigned selected_MEM_STOREXOR_SH(unsigned,unsigned,unsigned);
extern unsigned native_MEM_STOREXOR_SH(unsigned,unsigned,unsigned);
extern unsigned selected_MEM_STOREXOR_SW(unsigned,unsigned,unsigned);
extern unsigned native_MEM_STOREXOR_SW(unsigned,unsigned,unsigned);
struct test {test_fn selected,native;unsigned bytes,load,sign,addr;};
static const struct test funcs[]={{selected_MEM_ADDR_LB,native_MEM_ADDR_LB,1,1,1,1},{selected_MEM_ADDR_LBU,native_MEM_ADDR_LBU,1,1,0,1},{selected_MEM_ADDR_LH,native_MEM_ADDR_LH,2,1,1,1},{selected_MEM_ADDR_LHU,native_MEM_ADDR_LHU,2,1,0,1},{selected_MEM_ADDR_LW,native_MEM_ADDR_LW,4,1,1,1},{selected_MEM_LOADADD_LB,native_MEM_LOADADD_LB,1,1,1,0},{selected_MEM_LOADADD_LBU,native_MEM_LOADADD_LBU,1,1,0,0},{selected_MEM_LOADADD_LH,native_MEM_LOADADD_LH,2,1,1,0},{selected_MEM_LOADADD_LHU,native_MEM_LOADADD_LHU,2,1,0,0},{selected_MEM_LOADADD_LW,native_MEM_LOADADD_LW,4,1,1,0},{selected_MEM_ADDR_SB,native_MEM_ADDR_SB,1,0,0,1},{selected_MEM_ADDR_SH,native_MEM_ADDR_SH,2,0,0,1},{selected_MEM_ADDR_SW,native_MEM_ADDR_SW,4,0,0,1},{selected_MEM_STOREXOR_SB,native_MEM_STOREXOR_SB,1,0,0,0},{selected_MEM_STOREXOR_SH,native_MEM_STOREXOR_SH,2,0,0,0},{selected_MEM_STOREXOR_SW,native_MEM_STOREXOR_SW,4,0,0,0}};

static unsigned rng=0x12345678;
static unsigned next(void){rng^=rng<<13;rng^=rng>>17;rng^=rng<<5;return rng;}
static void semihost(unsigned op,const void *arg){register unsigned a0 __asm__("a0")=op;register const void *a1 __asm__("a1")=arg;__asm__ volatile(".option push\n.option norvc\nslli zero,zero,31\nebreak\nsrai zero,zero,7\n.option pop":"+r"(a0):"r"(a1):"memory");}
volatile unsigned tests,failures,failure_function,failure_iteration;
static unsigned char buf[64] __attribute__((aligned(16))), original[64], expected[64];
int main(void){
 static const unsigned edges[]={0,1,0x7f,0x80,0xff,0x7fff,0x8000,0xffff,0x7fffffff,0x80000000,0xffffffff};
 for(unsigned f=0;f<sizeof(funcs)/sizeof(funcs[0]);++f){const struct test *t=&funcs[f];
  for(unsigned i=0;i<128;++i){
   for(unsigned j=0;j<64;++j)original[j]=(unsigned char)next();
   unsigned v=i<11?edges[i]:next(),b=next(),c=next();
   unsigned offset=16+(i%8)*4;
   for(unsigned j=0;j<t->bytes;++j)original[offset+j]=(unsigned char)(v>>(8*j));
   for(unsigned j=0;j<64;++j)expected[j]=original[j];
   unsigned loaded=0;for(unsigned j=0;j<t->bytes;++j)loaded|=(unsigned)original[offset+j]<<(8*j);
   if(t->sign && t->bytes<4){unsigned shift=32-8*t->bytes;loaded=(unsigned)((int)(loaded<<shift)>>shift);}
   unsigned want=t->load?(t->addr?loaded:loaded+b):0;
   if(!t->load){unsigned value=t->addr?c:b^c;for(unsigned j=0;j<t->bytes;++j)expected[offset+j]=(unsigned char)(value>>(8*j));}
   for(unsigned mode=0;mode<2;++mode){
    for(unsigned j=0;j<64;++j)buf[j]=original[j];
    /* Alternate positive and negative register offsets, keeping accesses aligned. */
    unsigned delta=(i&1)?(unsigned)-16:16;
    unsigned a=t->addr?(unsigned)(buf+offset)-delta:(unsigned)(buf+offset);
    unsigned argb=t->addr?delta:b;
    unsigned got=(mode?t->native:t->selected)(a,argb,c),bad=got!=want;
    for(unsigned j=0;j<64;++j)bad|=buf[j]!=expected[j];
    ++tests;if(bad){++failures;failure_function=f;failure_iteration=i;}
   }
  }
 }
 semihost(4,failures?"MEMORY TEST FAIL\n":"MEMORY TEST PASS\n");
 unsigned args[2]={0x20026,failures?1u:0u};semihost(0x18,args);return 1;
}

