"""Convert a little-endian RV32 flat firmware image to 256 KiB COE."""
import argparse
from pathlib import Path
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('binary',type=Path);p.add_argument('output',type=Path)
a=p.parse_args();data=a.binary.read_bytes()
if not data or len(data)>256*1024: p.error('Firmware must be nonempty and fit 256 KiB')
data=data.ljust(256*1024,b'\0')
words=[f'{int.from_bytes(data[i:i+4],"little"):08x}' for i in range(0,len(data),4)]
a.output.write_text('memory_initialization_radix=16;\nmemory_initialization_vector=\n'+',\n'.join(words)+';\n')
