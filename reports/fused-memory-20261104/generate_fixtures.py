"""Generate address/data memory fusions through the real candidate pipeline."""
from pathlib import Path
from types import SimpleNamespace
import json,pickle
import pandas as pd
import networkx as nx
from tool.enums import ExportFilter
from tool.memory import LOADS,STORES
from tool.stages.assign_io_names import assign_io_names
from tool.gen.tree import generate_tree
from tool.gen.cdsl import generate_cdsl
from tool.gen.fuse_cdsl import generate_fuse_cdsl
from isaac_toolkit.generate.iss.generate_etiss_core import parse_generated_set,encode_instruction_sets
from m2isar.metamodel import arch
root=Path(__file__).resolve().parent;repo=root.parents[1]
results=[]
for xlen in (32,64):
 dest=root/f'generated-rv{xlen}';dest.mkdir(exist_ok=True);pending={};codes=[]
 forms=[('addr',op) for op in LOADS if LOADS[op][0]<=xlen and not(op=='LWU' and xlen==32)]
 forms += [('loadadd',op) for op in ('LB','LBU','LH','LHU','LW')]
 forms += [('addr',op) for op in STORES if STORES[op]<=xlen]
 forms += [('storexor',op) for op in ('SB','SH','SW')]
 for kind,op in forms:
  load=op in LOADS;g=nx.MultiDiGraph()
  def add(n,name,typ='instruction',**kw):
   props=dict(name=name,op_type=typ,out_reg_name=f'%{n}',out_reg_class='gpr',out_reg_size=xlen,out_reg_type=f's{xlen}',**kw)
   g.add_node(n,properties=props,label=name)
  for n in (0,1,2):add(n,f'input{n}','input')
  add(3,'0','constant',inst='0_');add(4,'XOR' if kind=='storexor' else 'ADD')
  add(5,op,mayLoad=load,mayStore=not load);add(6,'ADD');add(7,'dst0','output')
  def edge(a,b,i):g.add_edge(a,b,properties={'op_idx':i,'out_idx':0})
  if kind=='addr':
   edge(0,4,0);edge(1,4,1)
   if load:edge(4,5,0);edge(3,5,1);edge(5,7,0);inputs=[0,1]
   else:edge(2,5,0);edge(4,5,1);edge(3,5,2);edge(5,7,0);inputs=[0,1,2]
   nodes=[4,5]
  elif kind=='loadadd':
   edge(0,5,0);edge(3,5,1);edge(5,6,0);edge(1,6,1);edge(6,7,0);inputs=[0,1];nodes=[5,6]
  else:
   edge(1,4,0);edge(2,4,1);edge(4,5,0);edge(0,5,1);edge(3,5,2);edge(5,7,0);inputs=[0,1,2];nodes=[4,5]
  g=g.subgraph(set(nodes+inputs+[3,7])).copy();sub=g.subgraph(nodes).copy()
  data=dict(InputNodes=inputs,OutputNodes=[7],ConstantNodes=[3],Status=ExportFilter.SELECTED.value)
  for k in ('OperandNames','OperandNodes','OperandDirs','OperandTypes','OperandEncBits','OperandRegClasses','OutputNames','InputNames'):data[k]=[]
  df=pd.DataFrame([data]);settings=SimpleNamespace(progress=False,write=SimpleNamespace(gen_flt=ExportFilter.SELECTED),filters=SimpleNamespace(allowed_enc_sizes=[32]))
  assign_io_names(settings,[sub],[g],df);data=df.iloc[0].to_dict()
  tree=generate_tree(sub,data,g,xlen=xlen);name=f'MEM_{kind.upper()}_{op}'
  code=generate_cdsl(tree,data,xlen=xlen,name=name)
  assert code==generate_fuse_cdsl(tree,data,xlen=xlen,name=name)
  assert '?' not in code and 'None' not in code and 'TODO' not in code
  assert code.count('MEM[')==1,code
  assert data['OperandDirs'].count('OUT')==(1 if load else 0)
  p=dest/(name+'.core_desc');p.write_text(code+'\n');(dest/(name+'.tree.pkl')).write_bytes(pickle.dumps(tree))
  defs,_,err=parse_generated_set(p,extra_includes=[repo/'etiss_arch_riscv/rv_base'],auto_encoding=True,xlen=xlen);assert not err
  pending[name]=defs[name]
  results.append(dict(xlen=xlen,name=name,kind=kind,opcode=op,load=load,width=LOADS[op][0] if load else STORES[op],signed=LOADS[op][1] if load else False,operand_names=data['OperandNames']))
 encoded,plan=encode_instruction_sets({'XMem':pending});(dest/'encoding-plan.json').write_text(json.dumps(plan.to_dict(),indent=2)+'\n')
 for instr in encoded['XMem'].values():
  parts=[f"{f.length}'d{f.value}" if isinstance(f,arch.BitVal) else f'{f.name}[{f.range.upper}:{f.range.lower}]' for f in instr.encoding]
  body=(dest/(instr.name+'.core_desc')).read_text().split('    instructions {\n',1)[1].rsplit('    }',1)[0]
  codes.append(body.replace('encoding: auto;', 'encoding: '+' :: '.join(parts)+';'))
 (dest/'XMem.core_desc').write_text(f'import "{repo}/etiss_arch_riscv/rv_base/RVI.core_desc"\nInstructionSet XMem extends RV{xlen}I {{\n    instructions {{\n'+''.join(codes)+'    }\n}\n')
(root/'generation-results.json').write_text(json.dumps(results,indent=2)+'\n')
print('Generated memory fusions:',len(results))
