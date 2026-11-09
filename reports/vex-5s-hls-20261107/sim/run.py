"""Execute firmware against real generated Vex RTL with selectable AHB data wait states."""
from pathlib import Path
import argparse,subprocess,json,hashlib,time
p=argparse.ArgumentParser();p.add_argument('job',choices=['baseline','crc32-fixed','branches','stores','stores-fixed']);p.add_argument('--branch-repeats',type=int,default=1);p.add_argument('--data-wait',type=int,choices=[0,1,3],default=0);a=p.parse_args()
root=Path(__file__).resolve().parents[3];report=Path(__file__).resolve().parents[1]
variant={'crc32-fixed':'full','stores-fixed':'stores'}.get(a.job,a.job)
name=a.job+(f'-repeat{a.branch_repeats}' if a.branch_repeats!=1 else '')+(f'-wait{a.data_wait}' if a.data_wait else '')
firmware=report/'firmware'/name;dest=report/'sim'/name;dest.mkdir(parents=True,exist_ok=True)
args=['python3',str(root/'scripts/fpga_syn/firmware/build.py'),variant,str(firmware),'--core-label','VEX_5S','--cycle-counter-address','0x60000010','--branch-repeats',str(a.branch_repeats)]
if variant=='full':args+=['--memory-coredsl',str(report/'hls-inputs/crc32-fixed/XIsaac.hls.core_desc'),'--memory-names','CUSTOM0','CUSTOM5','CUSTOM3','CUSTOM15','CUSTOM16']
with (dest/'firmware-build.log').open('w') as log:subprocess.run(args,stdout=log,stderr=subprocess.STDOUT,check=True)
b=(firmware/'firmware.bin').read_bytes().ljust(262144,b'\0');hexfile=firmware/'firmware.hex';hexfile.write_text(''.join(f'{int.from_bytes(b[i:i+4],"little"):08x}\n' for i in range(0,len(b),4)))
rtl=report/'hls-run'/a.job;core=rtl/'VexRiscv_5s'
sources=[core/'VexRiscv.v',core/'Vex_top.sv',core/'CommonLogicModule.sv',report/'sim/tb.sv']
sources+=sorted(rtl.glob('ISAX_*.sv'))
command=['iverilog','-g2012','-s','tb','-o',str(dest/'firmware.vvp'),*map(str,sources)]
with (dest/'compile.log').open('w') as log:subprocess.run(command,stdout=log,stderr=subprocess.STDOUT,check=True)
symbols=subprocess.check_output([str(root/'install/gnu_cfu/bin/riscv32-unknown-elf-nm'),'-S',str(firmware/'firmware.elf')],text=True)
probes=[]
for line in symbols.splitlines():
 fields=line.split()
 if len(fields)==4 and fields[3] in ('crc_run','crc_ise'):
  key='native' if fields[3]=='crc_run' else 'ise'
  start,size=int(fields[0],16),int(fields[1],16)
  probes += [f'+{key}_start={start:x}',f'+{key}_end={start+size:x}']
started=time.monotonic()
with (dest/'uart.log').open('w') as log:result=subprocess.run(['vvp',str(dest/'firmware.vvp'),'+firmware='+str(hexfile),f'+data_wait={a.data_wait}',*probes],stdout=log,stderr=subprocess.STDOUT,timeout=180)
text=(dest/'uart.log').read_text();passed=result.returncode==0 and any(l.strip()=='PASS' for l in text.splitlines()) and 'ISAAC_SIM_PASS' in text and 'FATAL' not in text and 'FAIL' not in text
meta={'passed':passed,'job':a.job,'branch_repeats':a.branch_repeats,'data_wait_states':a.data_wait,'elapsed_seconds':time.monotonic()-started,'simulation':'Icarus RTL, AHB RAM/UART with selectable data wait states; wrapper cycle counter at 0x60000010','firmware_sha256':hashlib.sha256((firmware/'firmware.elf').read_bytes()).hexdigest(),'loaded_memory_sha256':hashlib.sha256(b).hexdigest(),'rtl_sha256':{str(s.relative_to(report)):hashlib.sha256(s.read_bytes()).hexdigest() for s in sources}}
(dest/'execution.json').write_text(json.dumps(meta,indent=2)+'\n');print(text);print(json.dumps(meta,indent=2));raise SystemExit(0 if passed else 1)
