from pathlib import Path
import subprocess,re,json,hashlib
root=Path('/tmp/isaac-bbid-investigation')
bindir=Path('/var/tmp/ga87puy/isaac-demo-new/llvm-project/build/bin')
commands=[]
def run(args,tag):
 commands.append(args)
 with (root/(tag+'.stdout')).open('w') as out,(root/(tag+'.log')).open('w') as err:
  subprocess.run(args,stdout=out,stderr=err,check=True)
def records(tag):
 ret=[]
 for line in (root/(tag+'.log')).read_text().splitlines():
  if line.startswith('BBIDTRACE '):ret.append(dict(re.findall(r'(\w+)=([^\s]+)',line)))
 return ret
def maps(tag):
 text=subprocess.check_output([str(bindir/'llvm-readobj'),'--bb-addr-map',str(root/(tag+'.elf'))],text=True)
 (root/(tag+'-map.txt')).write_text(text)
 return {re.search(r'Name: (\S+)',part)[1]:list(map(int,re.findall(r'^\s+ID: (\d+)',part,re.M))) for part in text.split('  Function {')[1:]}
def link(tag,entry):
 subprocess.run([str(bindir/'ld.lld'),'-m','elf32lriscv','--unresolved-symbols=ignore-all','-e',entry,'-Ttext=0x10000',str(root/(tag+'.o')),'-o',str(root/(tag+'.elf'))],check=True)
flags=['--target=riscv32','-march=rv32im','-mabi=ilp32','-O2','-g','-fbasic-block-sections=labels','-fglobal-isel','-mllvm','-global-isel-abort=0','-mllvm','-cdfg-stage-mask=32']
for tag,trace in [('verified-trace',True),('verified-no-trace',False)]:
 run([str(bindir/'clang'),*flags,*(['-mllvm','-debug-only=bbid-trace','-mllvm','-print-after-all'] if trace else []),'-c',str(root/'cases.c'),'-o',str(root/(tag+'.o'))],tag)
assert (root/'verified-trace.o').read_bytes()==(root/'verified-no-trace.o').read_bytes()
assert not records('verified-no-trace')
rec=records('verified-trace');assert rec
choose=[r for r in rec if r['function']=='choose']
early=[r for r in choose if r['event']=='cdfg-stage' and r['stage']=='32']
assert [(int(r['mbb']),int(r['base'])) for r in early]==[(1,1),(2,3),(3,2)]
assert all(r['requested']=='0' and r['selected']=='1' and r['failed_isel']=='0' for r in early)
seen=[]
for r in choose:
 if r['event']=='cdfg-stage' and r['stage'] not in seen:seen.append(r['stage'])
assert seen==['1','2','4','8','16','32','128','256','64']
assert next(i for i,r in enumerate(choose) if r['event']=='delete' and r['base']=='0')<next(i for i,r in enumerate(choose) if r['event']=='cdfg-stage')
link('verified-trace','choose');linked=maps('verified-trace')
for fn,ids in linked.items():
 assert [int(r['base']) for r in rec if r['function']==fn and r['event']=='emit']==ids
assert linked['choose']==[1,3,4]
assert any(r['event']=='erase' and r['base']=='2' for r in choose)
assert {r['mbb'] for r in choose if r.get('base')=='1'}>={'0','1','-1'}
noidflags=[f for f in flags if f!='-fbasic-block-sections=labels']
run([str(bindir/'clang'),*noidflags,'-mllvm','-debug-only=bbid-trace','-c',str(root/'cases.c'),'-o',str(root/'verified-no-ids.o')],'verified-no-ids')
noids=records('verified-no-ids');assert noids and all(r.get('base','none')=='none' for r in noids)
assert not any(r['event']=='emit' for r in noids)
run([str(bindir/'clang'),*flags,'-mllvm','-debug-only=bbid-trace','-mllvm','-print-after-all','-c',str(root/'fallback.c'),'-o',str(root/'verified-fallback.o')],'verified-fallback')
fall=[r for r in records('verified-fallback') if r['function']=='extended_add']
reset=next(i for i,r in enumerate(fall) if r['event']=='reset')
assert fall[reset]['reason']=='failed-isel'
assert any(r.get('failed_isel')=='1' for r in fall[:reset])
assert [r['base'] for r in fall[reset:] if r['event']=='create']==['2']
link('verified-fallback','extended_add');fallback_maps=maps('verified-fallback')
assert fallback_maps['extended_add']==[2]
for fn,ids in fallback_maps.items():
 assert [int(r['base']) for r in records('verified-fallback') if r['function']==fn and r['event']=='emit']==ids
out={'status':'PASS','normal_events':len(rec),'stage32_choose':early,'final_ids':linked,'fallback_extended_add_final_ids':fallback_maps['extended_add'],'trace_preserves_object_bytes':True,'no_id_trace_safe':True,'stage_order':seen,'source_commit':subprocess.check_output(['git','-C',str(bindir.parents[1]),'rev-parse','HEAD'],text=True).strip(),'compiler':subprocess.check_output([str(bindir/'clang'),'--version'],text=True),'commands':commands}
(root/'trace-validation.json').write_text(json.dumps(out,indent=2))
print(json.dumps({k:v for k,v in out.items() if k not in ('stage32_choose','commands')},indent=2))
