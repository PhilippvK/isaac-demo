"""Build freestanding CVA5 UART/CRC32 execution firmware."""
import argparse,hashlib,json,subprocess
from pathlib import Path
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--delay-cycles',type=int,default=0)
p.add_argument('--branch-repeats',type=int,default=1)
p.add_argument('--core-label',default='CVA5')
p.add_argument('--cycle-counter-address',type=lambda value:int(value,0))
p.add_argument('--memory-coredsl',type=Path)
p.add_argument('--memory-names',nargs=5)
p.add_argument('variant',choices=['baseline','full','memory','branches','stores']);p.add_argument('output',type=Path)
a=p.parse_args()
if not 1<=a.branch_repeats<=1000:p.error('branch-repeats must be between 1 and 1000')
if not 0<=a.delay_cycles<2**32:p.error('delay-cycles must fit an unsigned 32-bit counter')
root=Path(__file__).resolve().parents[3];src=Path(__file__).resolve().parent;out=a.output.resolve();out.mkdir(parents=True,exist_ok=True)
cc=root/'install/gnu_cfu/bin/riscv32-unknown-elf-gcc';objcopy=cc.with_name('riscv32-unknown-elf-objcopy');objdump=cc.with_name('riscv32-unknown-elf-objdump')
extra=([f'-DDEBUG_DELAY_CYCLES={a.delay_cycles}u'] if a.delay_cycles else []);inputs=[src/'start.S',src/'board.c',src/'arty.ld']
extra += [f'-DBOARD_CORE_NAME="{a.core_label}"']
if a.cycle_counter_address is not None:
 if not 0<=a.cycle_counter_address<2**32 or a.cycle_counter_address%4:p.error('cycle-counter-address must be a 32-bit word-aligned address')
 extra += [f'-DBOARD_CYCLE_COUNTER_ADDRESS={a.cycle_counter_address}u']
if a.variant in ('full','memory'):
 coredsl=a.memory_coredsl or root/'reports/cva5-reuseio-hls-20261105/hls-inputs'/('crc32-scaiev2-final/XIsaac.hls.core_desc' if a.variant=='full' else 'memory-cva5/XMemoryCRC32.hls.core_desc')
 header=out/'memory.h'
 subprocess.run(['python3',str(src/'memory_header.py'),str(coredsl),str(header)]+(['--names',*a.memory_names] if a.memory_names else []),check=True)
 extra+=[f'-DISAAC_MEMORY_HEADER="{header}"'];inputs += [coredsl,header]
if a.variant=='branches':extra+=['-DISAAC_BRANCHES=1',f'-DBRANCH_REPEATS={a.branch_repeats}',str(src/'branch_probes.S')];inputs += [src/'branch_probes.S',src/'effect_checks.h']
if a.variant=='stores':extra+=['-DISAAC_STORES=1'];inputs += [src/'effect_checks.h']
import shutil
snapshot=out/'sources';snapshot.mkdir(exist_ok=True)
for source in inputs:
 if source.parent==src:shutil.copyfile(source,snapshot/source.name)
command=[str(cc),'-march=rv32im_zicsr_zifencei','-mabi=ilp32','-O2','-ffreestanding','-fno-builtin','-fno-pic','-msmall-data-limit=0','-nostdlib','-Wl,--no-relax',f'-DBOARD_VARIANT="{a.variant}"',*extra,'-Wl,-T,'+str(src/'arty.ld'),str(src/'start.S'),str(src/'board.c'),'-o',str(out/'firmware.elf')]
subprocess.run(command,check=True)
subprocess.run([str(objcopy),'-O','binary',str(out/'firmware.elf'),str(out/'firmware.bin')],check=True)
with (out/'firmware.dis').open('w') as f:subprocess.run([str(objdump),'-d',str(out/'firmware.elf')],stdout=f,check=True)
subprocess.run(['python3',str(src/'bin_to_coe.py'),str(out/'firmware.bin'),str(out/'firmware.coe')],check=True)
inputs += [out/'firmware.elf',out/'firmware.bin',out/'firmware.coe']
(out/'build.json').write_text(json.dumps({'command':command,'variant':a.variant,'sha256':{str(f):hashlib.sha256(f.read_bytes()).hexdigest() for f in inputs}},indent=2)+'\n')
