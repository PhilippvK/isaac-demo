"""Count dynamic custom-instruction use and compare old/new executable code."""
from pathlib import Path
from collections import Counter
import json,re,hashlib,gzip,subprocess
import pandas as pd
from elftools.elf.elffile import ELFFile
root=Path(__file__).resolve().parent
results=[]
trace_pattern=re.compile(rb'^0x([a-fA-F0-9]+): ([^ ]+)')
for bench in ['crc32','nettle-sha256']:
 resources=root if bench=='crc32' else root/bench
 generated=32 if bench=='crc32' else 105
 for arm in ['baseline','old','new']:
  run=root/'runs'/bench/arm
  if not (run/'etiss_instrs.log.gz').exists():continue
  report=pd.read_csv(run/'report.csv').iloc[0]
  elf=run/'generic_mlonmcu'
  dump=subprocess.check_output([str(resources/'llvm/llvm_install/bin/llvm-objdump'),'-d','--mattr=+c,+xisaac',str(elf)],text=True)
  (run/'decoded.dump').write_text(dump)
  pcs={};static=Counter()
  for line in dump.splitlines():
   m=re.match(r'^\s*([a-fA-F0-9]+):.*?\b(custom\d+)\b',line,re.I)
   if m:pcs[int(m[1],16)]=m[2].lower();static[m[2].lower()]+=1
  with elf.open('rb') as stream:
   symbols={s.name:s['st_value'] for s in ELFFile(stream).get_section_by_name('.symtab').iter_symbols()}
  run_start=symbols['mlonmcu_run'];run_stop=symbols['stop_bench']
  in_run=False;starts=0;ends=0;run_lines=0;run_dynamic=Counter()
  dynamic=Counter();dynamic_sites=Counter();lines=0;unknown=0;trace_hash=hashlib.sha256()
  with gzip.open(run/'etiss_instrs.log.gz','rb') as stream:
   for line in stream:
    trace_hash.update(line)
    m=trace_pattern.match(line)
    if not m:unknown+=1;continue
    lines+=1;pc=int(m[1],16);name=m[2].decode().lower()
    if pc==run_start:in_run=True;starts+=1
    if in_run and pc==run_stop:in_run=False;ends+=1
    if in_run:run_lines+=1
    if pc in pcs:
     assert name==pcs[pc],(pc,name,pcs[pc])
     dynamic[pcs[pc]]+=1
     dynamic_sites[pc]+=1
     if in_run:run_dynamic[pcs[pc]]+=1
    elif name.startswith('custom'):raise AssertionError('Dynamic custom instruction absent from disassembly')
  with elf.open('rb') as f:text=ELFFile(f).get_section_by_name('.text').data()
  assert starts==ends==1,(bench,arm,starts,ends)
  row=dict(benchmark=bench,arm=arm,validation=bool(report['Validation']),generated_definitions=generated,
           run_instructions=int(report['Run Instructions']),run_cycles=int(report['Run Cycles']),
           benchmark_body_trace_instructions=run_lines,benchmark_body_custom_executions=sum(run_dynamic.values()),
           benchmark_body_used_ises=len(run_dynamic),benchmark_body_generated_utilization=len(run_dynamic)/generated,
           per_ise_benchmark_body=dict(sorted(run_dynamic.items())),
           simulated_instructions=int(report['Simulated Instructions']),trace_instructions=lines,
           trace_other_lines=unknown,dynamic_custom_executions=sum(dynamic.values()),
           static_custom_occurrences=sum(static.values()),dynamically_used_static_sites=len(dynamic_sites),
           per_ise_address_executions={hex(pc):n for pc,n in sorted(dynamic_sites.items())},
           static_site_utilization=len(dynamic_sites)/len(pcs) if pcs else None,statically_emitted_ises=len(static),
           dynamically_used_ises=len(dynamic),generated_ise_utilization=len(dynamic)/generated,
           emitted_ise_utilization=len(dynamic)/len(static) if static else None,
           dynamic_custom_instruction_share=sum(dynamic.values())/lines,
           per_ise_static=dict(sorted(static.items())),per_ise_dynamic=dict(sorted(dynamic.items())),
           executable_sha256=hashlib.sha256(elf.read_bytes()).hexdigest(),text_sha256=hashlib.sha256(text).hexdigest(),
           trace_sha256=trace_hash.hexdigest())
  results.append(row);print(bench,arm,lines,'trace entries, custom:',dict(dynamic),flush=True)
(root/'results.json').write_text(json.dumps(results,indent=2))
pd.DataFrame([{k:v for k,v in row.items() if not k.startswith('per_ise')} for row in results]).to_csv(root/'results.csv',index=False)
for bench in {r['benchmark'] for r in results}:
 rows={r['arm']:r for r in results if r['benchmark']==bench}
 if len(rows)==3:
  assert all(r['validation'] for r in rows.values())
  assert rows['old']['text_sha256']==rows['new']['text_sha256']
  assert rows['old']['trace_sha256']==rows['new']['trace_sha256']
  for key in ['run_instructions','run_cycles','dynamic_custom_executions','per_ise_dynamic','per_ise_benchmark_body']:
   assert rows['old'][key]==rows['new'][key],(bench,key)
