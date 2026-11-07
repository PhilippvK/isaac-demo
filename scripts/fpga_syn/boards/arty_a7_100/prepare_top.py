"""Adapt Nailgun CVA5 byte-addressed memory pins to the local 64K-word IP."""
import argparse,re
from pathlib import Path
p=argparse.ArgumentParser(description=__doc__);p.add_argument('source',type=Path);p.add_argument('output',type=Path);a=p.parse_args();s=a.source.read_text()
for name in ['instruction_bram_addr','data_bram_addr']:
 pattern=r'\.addra\(\s*'+name+r'\s*\)'
 s,n=re.subn(pattern,'.addra('+name+'[17:2])',s)
 if n!=1:raise ValueError(f'Expected one byte-addressed RAM connection for {name}; found {n}')
 # cva5_wrapper_verilog exports full 32-bit byte addresses.
 s,n=re.subn(r'wire\s*\[29:0\]\s*'+name+r'\s*;',f'wire [31:0] {name};',s)
 if n!=1:raise ValueError(f'Unexpected address declaration for {name}')
a.output.parent.mkdir(parents=True,exist_ok=True);a.output.write_text(s)
