from pathlib import Path
import copy,pickle,subprocess
from m2isar.metamodel import M2Model,M2_METAMODEL_VERSION,arch,type_info,attribute_info
from m2isar.backends.coredsl2.writer import gen_cdsl_code
root=Path(__file__).resolve().parent;repo=root.parents[1];dest=root/'hls-inputs/branch-probes';dest.mkdir(parents=True,exist_ok=True)
source=repo/'reports/fused-branches-20261104/generated-rv32/XBranch.core_desc'
p=dest/'XBranch.core_desc';p.write_text(source.read_text().replace("PC = PC + (signed<XLEN>)(offset);", "PC = (unsigned<32>)(PC + (signed<32>)(offset));"))
subprocess.run(['python','-m','m2isar.frontends.coredsl2_set.parser',str(p),'-D','XLEN=32'],check=True)
model=pickle.load((dest/'gen_model/XBranch.m2isarmodel').open('rb'))
instructions=copy.deepcopy(model.sets['XBranch']);instructions.extension=[];instructions.parameters={};instructions.functions={}
instructions.register_banks={
 'X':arch.RegisterBank('X',32,type_info.TypeKind.UINT,32,{attribute_info.RegisterAttribute.IS_MAIN_REG:[]}),
 'PC':arch.Register('PC',type_info.TypeKind.UINT,32,{attribute_info.RegisterAttribute.IS_PC:[]})}
instructions.memories={};instructions.memory_aliases={};instructions.register_aliases={}
output=M2Model(M2_METAMODEL_VERSION,{}, {'XBranch':instructions},{})
(dest/'XBranch.hls.core_desc').write_text(gen_cdsl_code(output,with_includes=False,legacy=True))
print('Prepared',len(instructions.instructions),'supplemental branch probes, separate from CRC32 discovery')
