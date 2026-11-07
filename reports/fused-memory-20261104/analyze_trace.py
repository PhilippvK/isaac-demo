from pathlib import Path
from collections import Counter
import argparse,gzip,hashlib,json,re,shutil
from elftools.elf.elffile import ELFFile

p=argparse.ArgumentParser();p.add_argument('--selector',choices=['dag','gisel'],required=True);args=p.parse_args()
root=Path(__file__).resolve().parent
log=(root/f'runtime-{args.selector}.log').read_text()
assert 'MEMORY TEST PASS' in log and 'MEMORY TEST FAIL' not in log
assert 'Finished cpu execution' in log
cases=json.loads((root/'runtime-cases.json').read_text())
with (root/'memory-tests.elf').open('rb') as stream:
    elf=ELFFile(stream)
    symbols={s.name:(s['st_value'],s['st_size']) for s in elf.get_section_by_name('.symtab').iter_symbols()}
    text=elf.get_section_by_name('.text');data=text.data();start=text['sh_addr']
functions={f'{prefix}_{row["name"]}':symbols[f'{prefix}_{row["name"]}'] for row in cases['functions'] for prefix in ('selected','native')}
entries={a:n for n,(a,s) in functions.items()}
sites={}
for m in re.finditer(r'^\s*([0-9a-f]+):\s*([0-9a-f]{8})\s+(mem_\w+)\b',(root/'memory-tests.dump').read_text(),re.M):
    pc=int(m[1],16)
    assert int.from_bytes(data[pc-start:pc-start+4],'little')==int(m[2],16)
    owners=[n for n,(a,s) in functions.items() if a<=pc<a+s]
    assert len(owners)==1 and owners[0].startswith('selected_'),owners
    sites[pc]={'instruction':m[3],'function':owners[0],'executions':0}
hits=Counter();dynamic=Counter();count=0;digest=hashlib.sha256()
with (root/'instr_trace.csv').open('rb') as stream:
    for line in stream:
        digest.update(line)
        m=re.match(rb'^0x([a-fA-F0-9]+): ([^ ]+)',line)
        if not m:continue
        pc=int(m[1],16);name=m[2].decode().lower();count+=1
        if pc in entries:hits[entries[pc]]+=1
        if pc in sites:
            assert name==sites[pc]['instruction']
            sites[pc]['executions']+=1;dynamic[name]+=1
        elif name.startswith('mem_'):raise AssertionError((pc,name))
assert all(hits[n]==cases['cases_per_function_per_mode'] for n in functions),hits
assert all(s['executions']==cases['cases_per_function_per_mode'] for s in sites.values())
result={'selector':args.selector,'validation':True,'differential_cases':sum(hits.values()),
        'custom_sites':len(sites),'custom_executions':sum(dynamic.values()),'per_ise_executions':dict(dynamic),
        'trace_instructions':count,'trace_sha256':digest.hexdigest(), 'function_calls':dict(hits),
        'sites':{hex(pc):s for pc,s in sites.items()}}
assert result['differential_cases']==cases['expected_total_cases']
(root/f'runtime-results-{args.selector}.json').write_text(json.dumps(result,indent=2)+'\n')
with (root/'instr_trace.csv').open('rb') as src,gzip.open(root/f'instr_trace-{args.selector}.csv.gz','wb',compresslevel=1) as dst:
    shutil.copyfileobj(src,dst)
for name in ('memory-tests.elf','memory-tests.dump'):
    shutil.copy2(root/name,root/(args.selector+'-'+name))
print({k:v for k,v in result.items() if k not in ('sites','function_calls','per_ise_executions')})
