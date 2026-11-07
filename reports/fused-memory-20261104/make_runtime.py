from pathlib import Path
import json, shutil

root = Path(__file__).resolve().parent
rows = [r for r in json.loads((root/'generation-results.json').read_text()) if r['xlen'] == 32]
print(rows[0])
types = {'LB':'signed char','LBU':'unsigned char','LH':'short','LHU':'unsigned short','LW':'unsigned'}
src=[]
h=['typedef unsigned (*test_fn)(unsigned,unsigned,unsigned);']
entries=[]
for row in rows:
    name=row['name']; op=row['opcode']; kind=row['kind']; width=row['width']
    if row['load']:
        ty=types[op]
        expr=f'*(const {ty} *)(a+b)' if kind=='addr' else f'*(const {ty} *)a+b'
        body=f'return {expr};'
    else:
        ty={8:'unsigned char',16:'unsigned short',32:'unsigned'}[width]
        body=f'*({ty} *)(a+b)=c;return 0;' if kind=='addr' else f'*({ty} *)a=b^c;return 0;'
    src.append(f'__attribute__((noinline)) unsigned FUNC({name})(unsigned a,unsigned b,unsigned c){{{body}}}')
    for prefix in ('selected','native'):
        h.append(f'extern unsigned {prefix}_{name}(unsigned,unsigned,unsigned);')
    entries.append(f'{{selected_{name},native_{name},{width//8},{int(row["load"])},{int(row["signed"])},{int(kind=="addr")}}}')
(root/'selected.c').write_text('\n'.join(src)+'\n')
h += ['struct test {test_fn selected,native;unsigned bytes,load,sign,addr;};',
      'static const struct test funcs[]={'+','.join(entries)+'};']
h += [r'''
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
''']
(root/'harness.c').write_text('\n'.join(h)+'\n')
for file in ('start.S','link.ld'):
    shutil.copy(root.parent/'fused-branches-20261104'/file, root/file)
(root/'runtime-cases.json').write_text(json.dumps({'functions':rows,'cases_per_function_per_mode':128,'expected_total_cases':len(rows)*128*2},indent=2)+'\n')
