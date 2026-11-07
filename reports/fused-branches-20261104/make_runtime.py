from pathlib import Path
import json
root=Path(__file__).resolve().parent
preds={'BEQ':'==','BNE':'!=','BLT':'<','BGE':'>=','BLTU':'<','BGEU':'>='}
src=['extern int taken(void); extern int missed(void);']
for name,op in preds.items():
 ty='int' if name in ('BLT','BGE') else 'unsigned'
 src.append(f'__attribute__((noinline)) int FUNC({name})(unsigned a,unsigned b) {{ if (({ty})(a&b) {op} ({ty})7) return taken(); else return missed(); }}')
(root/'selected.c').write_text('\n'.join(src)+'\n')
asm=['.text','.option norvc']
funcs=[]
for name in preds:
 for mode in ('forward','backward','p4094','m4096'):
  func=f'asm_{name}_{mode}';funcs.append(func)
  asm += ['.balign 4',f'.global {func}',f'.type {func},@function',f'{func}:']
  if mode in ('forward','p4094'):
   asm += [f'.Lstart_{func}:',f'fused_{name.lower()} a0,a1,.Ltrue_{func}','li a0,0','ret']
   if mode=='p4094':asm += [f'.space 4094-(.-.Lstart_{func}),0']
   asm += [f'.Ltrue_{func}:','li a0,1','ret']
  else:
   asm += [f'j .Ltest_{func}',f'.Ltrue_{func}:','li a0,1','ret']
   if mode=='m4096':asm += [f'.space 4096-(.-.Ltrue_{func}),0']
   asm += [f'.Ltest_{func}:',f'fused_{name.lower()} a0,a1,.Ltrue_{func}','li a0,0','ret']
  asm += [f'.size {func},.-{func}']
(root/'branches.S').write_text('\n'.join(asm)+'\n')
h=['typedef int (*test_fn)(unsigned,unsigned);','int taken(void){return 1;} int missed(void){return 0;}']
rows=[]
for name in preds:
 for func in ['selected_'+name,'native_'+name,'far_'+name]+[f'asm_{name}_{m}' for m in ('forward','backward','p4094','m4096')]:
  h.append(f'extern int {func}(unsigned,unsigned);');rows.append((func,name))
h += ['test_fn functions[]={'+','.join(f for f,_ in rows)+'};', 'unsigned predicates[]={'+','.join(str(list(preds).index(p)) for _,p in rows)+'};']
h += ['''static unsigned rng=0x12345678u;
static unsigned next(void){rng^=rng<<13;rng^=rng>>17;rng^=rng<<5;return rng;}
static int reference(unsigned p,unsigned a,unsigned b){unsigned v=a&b;switch(p){case 0:return v==7;case 1:return v!=7;case 2:return (int)v<7;case 3:return (int)v>=7;case 4:return v<7;default:return v>=7;}}
static void semihost(unsigned op, const void *arg){register unsigned a0 __asm__("a0")=op;register const void *a1 __asm__("a1")=arg;__asm__ volatile(".option push\\n.option norvc\\nslli zero,zero,31\\nebreak\\nsrai zero,zero,7\\n.option pop" : "+r"(a0):"r"(a1):"memory");}
volatile unsigned tests, failures, failure_function, failure_a, failure_b;
int main(void){
 static const unsigned edges[]={0,1,2,6,7,8,15,0x7fffffff,0x80000000,0xffffffff,0x80000007};
 for(unsigned f=0;f<sizeof(functions)/sizeof(functions[0]);++f){
  for(unsigned i=0;i<121+256;++i){unsigned a,b;if(i<121){a=edges[i/11];b=edges[i%11];}else{a=next();b=next();}
   int expected=reference(predicates[f],a,b),actual=functions[f](a,b);++tests;
   if(expected!=actual){++failures;failure_function=f;failure_a=a;failure_b=b;}
  }
 }
 semihost(4,failures?"BRANCH TEST FAIL\\n":"BRANCH TEST PASS\\n");
 unsigned args[2]={0x20026,failures?1u:0u};semihost(0x18,args);return 1;
}
''']
(root/'harness.c').write_text('\n'.join(h))
(root/'start.S').write_text('''.text
.option norvc
.global _start
_start:
 lui sp,0x2000
 call main
1: j 1b
''')
(root/'link.ld').write_text('''ENTRY(_start)
SECTIONS { . = 0x01000000; .text : { *(.text*) } .rodata : { *(.rodata*) } . = 0x01800000; .data : { *(.data*) *(.sdata*) } .bss : { *(.bss*) *(.sbss*) *(COMMON) } }
''')
(root/'runtime-cases.json').write_text(json.dumps({'functions':[{'name':f,'predicate':p} for f,p in rows],'cases_per_function':377,'expected_total_cases':len(rows)*377},indent=2)+'\n')
print('Runtime cases:',len(rows)*377)
