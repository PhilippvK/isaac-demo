"""Check actual branch executions, decoded targets, and test function coverage."""
from pathlib import Path
from collections import Counter,defaultdict
import re,json,gzip,hashlib,shutil
from elftools.elf.elffile import ELFFile
root=Path(__file__).resolve().parent
log=(root/'runtime-final.log').read_text();assert 'BRANCH TEST PASS' in log and 'BRANCH TEST FAIL' not in log
assert 'Finished cpu execution' in log
cases=json.loads((root/'runtime-cases.json').read_text())
with (root/'branch-tests.elf').open('rb') as stream:
 elf=ELFFile(stream);symbols={s.name:(s['st_value'],s['st_size']) for s in elf.get_section_by_name('.symtab').iter_symbols()}
 text=elf.get_section_by_name('.text');data=text.data();start=text['sh_addr']
funcs={f['name']:symbols[f['name']] for f in cases['functions']}
entries={address:name for name,(address,size) in funcs.items()}
sites={}
for m in re.finditer(r'^\s*([0-9a-f]+):\s*([0-9a-f]{8})\s+(fused_\w+)\b', (root/'branch-tests.dump').read_text(),re.M):
 pc=int(m[1],16);word=int.from_bytes(data[pc-start:pc-start+4],'little');assert word==int(m[2],16)
 imm=((word>>31)&1)<<12|((word>>25)&63)<<5|((word>>8)&15)<<1|((word>>7)&1)<<11
 imm=imm-8192 if imm&4096 else imm
 owners=[n for n,(a,s) in funcs.items() if a<=pc<a+s];assert len(owners)==1
 sites[pc]=dict(name=m[3],function=owners[0],displacement=imm,target=(pc+imm)&0xffffffff,taken=0,fallthrough=0,executions=0)
assert len(sites)==36,len(sites)
for name,(address,size) in funcs.items():
 owned=[s for s in sites.values() if s['function']==name]
 assert len(owned)==(0 if name.startswith('native_') else 1),(name,owned)
 if name.endswith('_p4094'):assert owned[0]['displacement']==4094
 if name.endswith('_m4096'):assert owned[0]['displacement']==-4096
hits=Counter();dynamic=Counter();pending=None;lines=0;digest=hashlib.sha256()
pattern=re.compile(rb'^0x([a-fA-F0-9]+): ([^ ]+)')
with (root/'instr_trace.csv').open('rb') as stream:
 for line in stream:
  digest.update(line);m=pattern.match(line)
  if not m:continue
  pc=int(m[1],16);name=m[2].decode().lower();lines+=1
  if pending is not None:
   s=sites[pending]
   assert pc in (pending+4,s['target']),(pending,pc,s)
   s['taken' if pc==s['target'] else 'fallthrough']+=1
   pending=None
  if pc in entries:hits[entries[pc]]+=1
  if pc in sites:
   s=sites[pc];assert name==s['name'],(pc,name,s)
   s['executions']+=1;dynamic[name]+=1;pending=pc
  elif name.startswith('fused_'):raise AssertionError((pc,name))
assert pending is None
assert all(hits[n]==cases['cases_per_function'] for n in funcs),hits
assert all(s['executions']==377 and s['taken'] and s['fallthrough'] for s in sites.values())
result={'validation':True,'differential_cases':sum(hits.values()),'functions':len(funcs),'trace_instructions':lines,
 'custom_executions':sum(dynamic.values()),'per_ise_executions':dict(dynamic),'all_sites_exercise_taken_and_fallthrough':True,
 'trace_sha256':digest.hexdigest(),'function_calls':dict(hits),'sites':{hex(pc):s for pc,s in sites.items()}}
assert result['differential_cases']==cases['expected_total_cases']
(root/'runtime-results.json').write_text(json.dumps(result,indent=2)+'\n')
with (root/'instr_trace.csv').open('rb') as src,gzip.open(root/'instr_trace.csv.gz','wb',compresslevel=1) as dst:shutil.copyfileobj(src,dst)
print({k:v for k,v in result.items() if k not in ('sites','function_calls')})
