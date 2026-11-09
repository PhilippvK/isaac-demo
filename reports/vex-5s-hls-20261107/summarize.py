"""Summarize HLS schedules, functional RTL runs and measured kernel retirement."""
from pathlib import Path
import json,re,statistics,hashlib
r=Path(__file__).resolve().parent;repo=r.parents[1]
executions={}
for p in sorted((r/'sim').glob('*/execution.json')):
 d=json.loads(p.read_text());text=(p.parent/'uart.log').read_text();record={**d,'log':str((p.parent/'uart.log').relative_to(r))}
 record['pairs']=[dict(zip(['run','native_crc','ise_crc','native_cycles','ise_cycles'],[int(x,16) for x in m.groups()])) for m in re.finditer(r'PAIR run=([0-9a-f]+) native=([0-9a-f]+) ise=([0-9a-f]+) native_cycles=([0-9a-f]+) ise_cycles=([0-9a-f]+)',text)]
 record['native_kernels']=[{'instructions':int(n),'cycles':int(c)} for n,c in re.findall(r'ISAAC_KERNEL native instructions=(\d+) cycles=(\d+)',text)]
 record['ise_kernels']=[{'instructions':int(n),'cycles':int(c),'ise_ops':int(o)} for n,c,o in re.findall(r'ISAAC_KERNEL ise instructions=(\d+) cycles=(\d+) ise_ops=(\d+)',text)]
 for label,pattern in [('branch_checks',r'^BRANCH PASS checks=([0-9a-f]+)'),('store_checks',r'^STORE PASS checks=([0-9a-f]+)'),('native_store_checks',r'^NATIVE STORE PASS checks=([0-9a-f]+)'),('load_checks',r'^MEMORY PASS checks=([0-9a-f]+)')]:
  m=re.search(pattern,text,re.M)
  if m:record[label]=int(m[1],16)
 record['zero_register_check_passed']='ZERO REGISTER PASS' in text
 executions[p.parent.name]=record
hls={}
for job in ('crc32-fixed','branches','stores-fixed'):
 out=r/'hls-run'/job;instructions=[]
 for p in sorted(out.glob('*.dot.stats')):
  text=p.read_text();m=re.findall(r'instruction: ([^\n]+)\n\s+latency: (\d+)',text);ii=re.search(r'\bII: (\d+)',text)
  if m and ii:instructions.append({'name':m[-1][0],'latency':int(m[-1][1]),'II':int(ii[1])})
 hls[job]={'instructions':instructions,'count':len(instructions),'has_unwanted_rd_read':'interface: RdRD' in ''.join(p.read_text() for p in out.glob('ISAX_*.yaml'))}
perf={}
for key in ('crc32-fixed','crc32-fixed-wait1'):
 e=executions[key];assert e['passed'] and len(e['pairs'])==len(e['ise_kernels'])==5
 assert all(p['native_crc']==p['ise_crc']==0x65842ca9 for p in e['pairs'])
 native=statistics.median(k['instructions'] for k in e['native_kernels']);ise=statistics.median(k['instructions'] for k in e['ise_kernels'])
 perf[key]={'data_wait_states':e['data_wait_states'],'native_instructions':native,'ise_instructions':ise,'instructions_saved':native-ise,'instruction_reduction_percent':100*(native-ise)/native,'native_retirement_cycles':statistics.median(k['cycles'] for k in e['native_kernels']),'ise_retirement_cycles':statistics.median(k['cycles'] for k in e['ise_kernels']),'ise_invocations_per_kernel':statistics.median(k['ise_ops'] for k in e['ise_kernels']),'native_timer_cycles':statistics.median(p['native_cycles'] for p in e['pairs']),'ise_timer_cycles':statistics.median(p['ise_cycles'] for p in e['pairs'])}
control=executions['stores'];fixed=executions['stores-fixed']
summary={'workload':'CRC32','target':'VEX_5S','reuse_io':False,'hls':hls,'executions':executions,'performance':perf,'store_ab_control_identical_firmware':control['loaded_memory_sha256']==fixed['loaded_memory_sha256'],'fpga_synthesis_executed':False,'physical_fpga_execution':False,'compiler_selection':'GCC -O2 with explicit generated load intrinsics; not automatic LLVM selection'}
assert not control['passed'] and fixed['passed'] and summary['store_ab_control_identical_firmware']
assert all(not d['has_unwanted_rd_read'] for d in hls.values())
(r/'results.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps({'performance':perf,'store_ab_control_identical_firmware':summary['store_ab_control_identical_firmware'],'functional_passes':[k for k,v in executions.items() if v['passed']]},indent=2))
