"""Summarize physical FPGA execution, preserving failed probes as evidence."""
import hashlib,json,re,statistics
from pathlib import Path
root=Path(__file__).resolve().parent;repo=root.parent.parent
executions={}
for path in sorted((root/'execution').glob('*/execution.json')):
    data=json.loads(path.read_text());text=data['uart']
    pairs=[]
    for m in re.finditer(r'PAIR run=([0-9a-f]+) native=([0-9a-f]+) ise=([0-9a-f]+) native_cycles=([0-9a-f]+) ise_cycles=([0-9a-f]+)',text):
        pairs.append(dict(zip(['run','native_crc','ise_crc','native_cycles','ise_cycles'],[int(x,16) for x in m.groups()])))
    executions[path.parent.name]={'passed':data['passed'],'bitstream':data['bitstream'],'pairs':pairs,'uart_log':str(path.parent.relative_to(root)/'uart.log')}
summary={'board':'Arty A7-100','part':'xc7a100tcsg324-1','core_clock_hz':20000000,'reference_crc':'65842ca9','embench_verification':11433,'executions':executions}
full=executions.get('full-final')
if full and full['passed']:
    pairs=full['pairs'];assert len(pairs)==5
    assert all(p['native_crc']==p['ise_crc']==0x65842ca9 for p in pairs)
    native=statistics.median(p['native_cycles'] for p in pairs[1:]);ise=statistics.median(p['ise_cycles'] for p in pairs[1:])
    summary['performance']={'steady_pairs':4,'native_cycles':native,'ise_cycles':ise,'cycles_saved':native-ise,'cycle_reduction_percent':100*(native-ise)/native,'speedup':native/ise,'native_ms':native/20000,'ise_ms':ise/20000,'selection':'explicit generated CUSTOM17 intrinsic, GCC -O2; not automatic LLVM retargeting'}
(root/'results.json').write_text(json.dumps(summary,indent=2)+'\n')
files=list((repo/'scripts/fpga_syn/firmware').glob('*'))+list((repo/'scripts/fpga_syn/boards/arty_a7_100').glob('*'))+[repo/'scripts/fpga_syn/my_vivado_script.tcl',repo/'isaac-toolkit/isaac_toolkit/generate/iss/hls_immediates.py',repo/'isaac-toolkit/isaac_toolkit/generate/iss/generate_etiss_core.py']
files += list((root/'firmware').rglob('*.elf'))+list((root/'firmware').rglob('*.coe'))+list((root/'firmware').rglob('sources/*'))
for data in executions.values():files.append(Path(data['bitstream']))
manifest={str(p.relative_to(repo)):hashlib.sha256(p.read_bytes()).hexdigest() for p in files if p.is_file()}
(root/'sha256.json').write_text(json.dumps(manifest,indent=2)+'\n')
print(json.dumps({k:v for k,v in summary.items() if k!='executions'},indent=2))
