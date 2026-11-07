"""Exercise real operand/tree/CoreDSL generation and shared encoding allocation."""
from pathlib import Path
from types import SimpleNamespace
import json,pickle
import networkx as nx
import pandas as pd
from tool.branches import BRANCHES
from tool.enums import ExportFilter
from tool.stages.assign_io_names import assign_io_names
from tool.gen.tree import generate_tree
from tool.gen.cdsl import generate_cdsl
from tool.gen.fuse_cdsl import generate_fuse_cdsl
from isaac_toolkit.generate.iss.generate_etiss_core import parse_generated_set, encode_instruction_sets
from m2isar.metamodel import arch
root=Path(__file__).resolve().parent;repo=root.parents[1]
results=[]
for xlen in (32,64):
 dest=root/f'generated-rv{xlen}';dest.mkdir(exist_ok=True)
 unencoded={};codes=[]
 for pred in BRANCHES:
  def props(name,op_type='instruction',**kw):
   return dict(name=name,op_type=op_type,out_reg_name='%0',out_reg_class='gpr',out_reg_size=xlen,out_reg_type=f's{xlen}',**kw)
  g=nx.MultiDiGraph()
  for n,p in [(0,props('input0','input')),(1,props('input1','input')),
               (2,props('7','constant',inst='7_')),(3,props('AND')),
               (4,props(pred,isBranch=True,isTerminator=True)),
               (5,props('%bb.1','label')),(6,props('dst0','output'))]:
   g.add_node(n,properties=p,label=p['name'])
  for a,b,i in [(0,3,0),(1,3,1),(3,4,0),(2,4,1),(5,4,2),(4,6,0)]:
   g.add_edge(a,b,properties={'op_idx':i,'out_idx':0})
  sub=g.subgraph((3,4)).copy()
  data={'InputNodes':[5,0,1],'OutputNodes':[6],'ConstantNodes':[2],'Status':ExportFilter.SELECTED.value}
  for key in ('OperandNames','OperandNodes','OperandDirs','OperandTypes','OperandEncBits','OperandRegClasses','OutputNames','InputNames'):data[key]=[]
  df=pd.DataFrame([data]);settings=SimpleNamespace(progress=False,write=SimpleNamespace(gen_flt=ExportFilter.SELECTED),filters=SimpleNamespace(allowed_enc_sizes=[32]))
  assign_io_names(settings,[sub],[g],df)
  data=df.iloc[0].to_dict()
  tree=generate_tree(sub,data,g,xlen=xlen)
  name='FUSED_'+pred
  code=generate_cdsl(tree,data,xlen=xlen,name=name)
  fused=generate_fuse_cdsl(tree,data,xlen=xlen,name=name)
  assert code==fused
  assert 'TODO' not in code and 'None' not in code,code
  assert data['OperandEncBitsSum']==22
  assert data['OperandNames'][-1]=='offset' and 'OUT' not in data['OperandDirs']
  p=dest/(name+'.core_desc');p.write_text(code+'\n')
  (dest/(name+'.tree.pkl')).write_bytes(pickle.dumps(tree))
  defs,_,err=parse_generated_set(p,extra_includes=[repo/'etiss_arch_riscv/rv_base'],auto_encoding=True,xlen=xlen)
  assert not err
  unencoded[name]=defs[name]
  results.append({'xlen':xlen,'predicate':pred,'operand_names':data['OperandNames'],'physical_operand_bits':data['OperandEncBitsSum']})
 encoded,plan=encode_instruction_sets({'XBranch':unencoded})
 (dest/'encoding-plan.json').write_text(json.dumps(plan.to_dict(),indent=2)+'\n')
 # Reuse generated source and replace only auto encoding with the actual allocation.
 for instr in encoded['XBranch'].values():
  name=instr.name
  fields=[]
  for f in instr.encoding:
   if isinstance(f,arch.BitVal):fields.append(f"{f.length}'d{f.value}")
   else:fields.append(f'{f.name}[{f.range.upper}:{f.range.lower}]')
  body=(dest/(name+'.core_desc')).read_text().split('    instructions {\n',1)[1].rsplit('    }',1)[0]
  body=body.replace('encoding: auto;', 'encoding: '+' :: '.join(fields)+';')
  codes.append(body)
 text=f'import "{repo}/etiss_arch_riscv/rv_base/RVI.core_desc"\nInstructionSet XBranch extends RV{xlen}I {{\n    instructions {{\n'+''.join(codes)+'    }\n}\n'
 (dest/'XBranch.core_desc').write_text(text)
(root/'generation-results.json').write_text(json.dumps(results,indent=2)+'\n')
print('Generated and encoded all six predicates for RV32 and RV64.')
