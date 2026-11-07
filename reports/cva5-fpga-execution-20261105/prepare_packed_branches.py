from pathlib import Path
import copy,pickle
from m2isar.metamodel import M2Model,M2_METAMODEL_VERSION,arch,type_info,attribute_info
from m2isar.backends.coredsl2.writer import gen_cdsl_code
from isaac_toolkit.generate.iss.hls_immediates import normalize_hls_immediates
root=Path(__file__).resolve().parents[2]
old=root/'reports/cva5-reuseio-hls-20261105/hls-inputs/branch-probes/gen_model/XBranch.m2isarmodel'
model=pickle.load(old.open('rb'));instructions=copy.deepcopy(model.sets['XBranch'])
instructions.extension=[];instructions.parameters={};instructions.functions={}
instructions.register_banks={'X':arch.RegisterBank('X',32,type_info.TypeKind.UINT,32,{attribute_info.RegisterAttribute.IS_MAIN_REG:[]}), 'PC':arch.Register('PC',type_info.TypeKind.UINT,32,{attribute_info.RegisterAttribute.IS_PC:[]})}
instructions.memories={};instructions.memory_aliases={};instructions.register_aliases={}
normalize_hls_immediates(instructions,32)
out=M2Model(M2_METAMODEL_VERSION,{}, {'XBranch':instructions},{})
dest=root/'reports/cva5-reuseio-hls-20261105/hls-inputs/branch-packed/XBranch.hls.core_desc'
dest.write_text(gen_cdsl_code(out,with_includes=False,legacy=True))
print(dest)
