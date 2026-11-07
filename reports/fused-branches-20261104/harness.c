typedef int (*test_fn)(unsigned,unsigned);
int taken(void){return 1;} int missed(void){return 0;}
extern int selected_BEQ(unsigned,unsigned);
extern int native_BEQ(unsigned,unsigned);
extern int far_BEQ(unsigned,unsigned);
extern int asm_BEQ_forward(unsigned,unsigned);
extern int asm_BEQ_backward(unsigned,unsigned);
extern int asm_BEQ_p4094(unsigned,unsigned);
extern int asm_BEQ_m4096(unsigned,unsigned);
extern int selected_BNE(unsigned,unsigned);
extern int native_BNE(unsigned,unsigned);
extern int far_BNE(unsigned,unsigned);
extern int asm_BNE_forward(unsigned,unsigned);
extern int asm_BNE_backward(unsigned,unsigned);
extern int asm_BNE_p4094(unsigned,unsigned);
extern int asm_BNE_m4096(unsigned,unsigned);
extern int selected_BLT(unsigned,unsigned);
extern int native_BLT(unsigned,unsigned);
extern int far_BLT(unsigned,unsigned);
extern int asm_BLT_forward(unsigned,unsigned);
extern int asm_BLT_backward(unsigned,unsigned);
extern int asm_BLT_p4094(unsigned,unsigned);
extern int asm_BLT_m4096(unsigned,unsigned);
extern int selected_BGE(unsigned,unsigned);
extern int native_BGE(unsigned,unsigned);
extern int far_BGE(unsigned,unsigned);
extern int asm_BGE_forward(unsigned,unsigned);
extern int asm_BGE_backward(unsigned,unsigned);
extern int asm_BGE_p4094(unsigned,unsigned);
extern int asm_BGE_m4096(unsigned,unsigned);
extern int selected_BLTU(unsigned,unsigned);
extern int native_BLTU(unsigned,unsigned);
extern int far_BLTU(unsigned,unsigned);
extern int asm_BLTU_forward(unsigned,unsigned);
extern int asm_BLTU_backward(unsigned,unsigned);
extern int asm_BLTU_p4094(unsigned,unsigned);
extern int asm_BLTU_m4096(unsigned,unsigned);
extern int selected_BGEU(unsigned,unsigned);
extern int native_BGEU(unsigned,unsigned);
extern int far_BGEU(unsigned,unsigned);
extern int asm_BGEU_forward(unsigned,unsigned);
extern int asm_BGEU_backward(unsigned,unsigned);
extern int asm_BGEU_p4094(unsigned,unsigned);
extern int asm_BGEU_m4096(unsigned,unsigned);
test_fn functions[]={selected_BEQ,native_BEQ,far_BEQ,asm_BEQ_forward,asm_BEQ_backward,asm_BEQ_p4094,asm_BEQ_m4096,selected_BNE,native_BNE,far_BNE,asm_BNE_forward,asm_BNE_backward,asm_BNE_p4094,asm_BNE_m4096,selected_BLT,native_BLT,far_BLT,asm_BLT_forward,asm_BLT_backward,asm_BLT_p4094,asm_BLT_m4096,selected_BGE,native_BGE,far_BGE,asm_BGE_forward,asm_BGE_backward,asm_BGE_p4094,asm_BGE_m4096,selected_BLTU,native_BLTU,far_BLTU,asm_BLTU_forward,asm_BLTU_backward,asm_BLTU_p4094,asm_BLTU_m4096,selected_BGEU,native_BGEU,far_BGEU,asm_BGEU_forward,asm_BGEU_backward,asm_BGEU_p4094,asm_BGEU_m4096};
unsigned predicates[]={0,0,0,0,0,0,0,1,1,1,1,1,1,1,2,2,2,2,2,2,2,3,3,3,3,3,3,3,4,4,4,4,4,4,4,5,5,5,5,5,5,5};
static unsigned rng=0x12345678u;
static unsigned next(void){rng^=rng<<13;rng^=rng>>17;rng^=rng<<5;return rng;}
static int reference(unsigned p,unsigned a,unsigned b){unsigned v=a&b;switch(p){case 0:return v==7;case 1:return v!=7;case 2:return (int)v<7;case 3:return (int)v>=7;case 4:return v<7;default:return v>=7;}}
static void semihost(unsigned op, const void *arg){register unsigned a0 __asm__("a0")=op;register const void *a1 __asm__("a1")=arg;__asm__ volatile(".option push\n.option norvc\nslli zero,zero,31\nebreak\nsrai zero,zero,7\n.option pop" : "+r"(a0):"r"(a1):"memory");}
volatile unsigned tests, failures, failure_function, failure_a, failure_b;
int main(void){
 static const unsigned edges[]={0,1,2,6,7,8,15,0x7fffffff,0x80000000,0xffffffff,0x80000007};
 for(unsigned f=0;f<sizeof(functions)/sizeof(functions[0]);++f){
  for(unsigned i=0;i<121+256;++i){unsigned a,b;if(i<121){a=edges[i/11];b=edges[i%11];}else{a=next();b=next();}
   int expected=reference(predicates[f],a,b),actual=functions[f](a,b);++tests;
   if(expected!=actual){++failures;failure_function=f;failure_a=a;failure_b=b;}
  }
 }
 semihost(4,failures?"BRANCH TEST FAIL\n":"BRANCH TEST PASS\n");
 unsigned args[2]={0x20026,failures?1u:0u};semihost(0x18,args);return 1;
}
