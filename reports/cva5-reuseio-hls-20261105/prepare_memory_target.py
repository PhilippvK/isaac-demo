from pathlib import Path
import pickle,copy,json
from m2isar.metamodel import M2Model,M2_METAMODEL_VERSION
from m2isar.transforms.encode_instructions.planner import Assignment,Field
from isaac_toolkit.generate.iss.generate_etiss_core import validate_instruction_sets
from m2isar.backends.coredsl2.writer import gen_cdsl_code
root=Path(__file__).resolve().parent
model=pickle.load((root/'hls-inputs/crc32/gen_model/XMemoryCRC32.hls.m2isarmodel').open('rb'))
s=copy.deepcopy(model.sets['XMemoryCRC32']);instructions={};changes=[]
for i in s.instructions.values():
 old=i.code
 code=(old & ~(7<<12)) | (2<<12)
 fields=(Field('rd',7,5,False),Field('rs1',15,5,False),Field('rs2',20,5,False))
 a=Assignment(i.name,'R',code,i.mask,fields)
 i.code=code;i.encoding=a.encoding();instructions[(code,i.mask)]=i
 changes.append({'instruction':i.name,'original_code':hex(old),'target_code':hex(code),'mask':hex(i.mask),'funct3':2})
assert len(instructions)==5
s.instructions=instructions
validate_instruction_sets({'XMemoryCRC32':instructions})
path=root/'hls-inputs/memory-cva5';path.mkdir(exist_ok=True)
(path/'XMemoryCRC32.hls.core_desc').write_text(gen_cdsl_code(M2Model(M2_METAMODEL_VERSION,{}, {'XMemoryCRC32':s},{}),with_includes=False,legacy=True))
(root/'memory-target-encoding.json').write_text(json.dumps({'scope':'standalone five-instruction HLS probe; not original full-set encodings','requirement':'Longnail CVA5 word access requires funct3=010','collision_check':True,'assignments':changes},indent=2)+'\n')
