"""Emit raw instruction intrinsics from the exact HLS CoreDSL encodings."""
import argparse,re,json
from pathlib import Path
p=argparse.ArgumentParser(description=__doc__);p.add_argument('coredsl',type=Path);p.add_argument('output',type=Path)
p.add_argument('--names',nargs=5,default=['CUSTOM17','CUSTOM43','CUSTOM44','CUSTOM76','CUSTOM78'],
 help='Instructions implementing masked-index load, index load, load-XOR-shift, offset load, load-XOR')
p.add_argument('--crc-index-name',help='Optional arithmetic XOR/mask/shift index instruction')
a=p.parse_args()
s=a.coredsl.read_text();out=['/* Generated from '+str(a.coredsl)+' */'];manifest={}
for name in [*a.names, *([a.crc_index_name] if a.crc_index_name else [])]:
 m=re.search(r'\b'+name+r'\s*\{\s*encoding:\s*(.*?);',s,re.S)
 if not m:raise ValueError(name+' not found')
 code=0;bits=0
 for token in m[1].split('::'):
  token=token.strip();constant=re.fullmatch(r"(\d+)'([bdh])([0-9a-fA-F]+)",token)
  field=re.fullmatch(r'(\w+)\[(\d+):(\d+)\]',token)
  if constant:w=int(constant[1]);value=int(constant[3],{'b':2,'d':10,'h':16}[constant[2]])
  elif field:w=int(field[2])-int(field[3])+1;value=0
  else:raise ValueError(token)
  code=(code<<w)|value;bits+=w
 if bits!=32:raise ValueError((name,bits))
 opcode=code&127;f3=(code>>12)&7;f7=code>>25
 manifest[name]={'code':hex(code),'opcode':opcode,'funct3':f3,'funct7':f7}
 out.append(f'static inline u32 ise_{name}(u32 a,u32 b) {{ u32 r; __asm__ volatile(".insn r {opcode}, {f3}, {f7}, %0, %1, %2":"=r"(r):"r"(a),"r"(b):"memory");return r; }}')
 if name==a.names[0]:
  out.append(f'static inline u32 ise_check_x0(u32 a,u32 b) {{ u32 r; __asm__ volatile(".insn r {opcode}, {f3}, {f7}, zero, %1, %2\\n\\taddi %0, zero, 0":"=r"(r):"r"(a),"r"(b):"memory");return r; }}')
for role,name in zip(['crc_masked','index','load_xor_shift','offset','load_xor'],a.names):
 out.append(f'#define ise_{role} ise_{name}')
if a.crc_index_name:out.append(f'#define ise_crc_index ise_{a.crc_index_name}')
a.output.write_text('\n'.join(out)+'\n');a.output.with_suffix('.json').write_text(json.dumps(manifest,indent=2)+'\n')
