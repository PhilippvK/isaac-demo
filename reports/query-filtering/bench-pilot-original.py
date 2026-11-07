import argparse, collections, hashlib, json, random, statistics, sys, time
from pathlib import Path
sys.path.insert(0,str(Path('memgraph_experiments').resolve()))
from neo4j import GraphDatabase, Query
from tool.queries import generate_candidates_query
from tool.types import RegisterClass
from tool import defaults
ROOT=Path('/tmp/isaac-query-pushdown-20261030')
SUPPORTED={'ADDIW','SRLI','SLLI','AND','ANDI','ORI','OR','XOR','XORI','ADD','ADDI','ADDW','MULW','MUL','MULH','MULHSU','MULHU','SRA','SRAI','SRL','SLL','SUB','SUBW','DIVU','REMU','SLT','SLTU','SLTIU','SLTI','BNE','BEQ','LH','LW','SW','SH','G_CONSTANT','G_TRUNC','G_ANYEXT','G_SEXT','G_ZEXT','G_ADD','G_PTR_ADD','G_MUL','G_LOAD','G_SEXTLOAD','G_ZEXTLOAD','PseudoVXOR_VV_M1','PseudoVAND_VV_M1','PseudoVSLIDEUP_VI_M1','PseudoVSLIDE1DOWN_VX_M1','PseudoVSRL_VX_M1','PseudoVMV_X_S'}
FLAGS={'no_mem':('mayLoad','mayStore'), 'cfu_local':('mayLoad','mayStore','isBranch','isTerminator'), 'codegen_local':('mayLoad','mayStore','isBranch','isTerminator')}

def allowed(props,profile):
 return not any(props.get(x,False) for x in FLAGS[profile]) and (profile!='codegen_local' or props.get('name') in SUPPORTED)

def expression(var,profile):
 terms=[f'NOT coalesce({var}.{prop}, false)' for prop in FLAGS[profile]]
 if profile=='codegen_local':terms.append(f'{var}.name IN '+json.dumps(sorted(SUPPORTED)))
 return ' AND '.join(terms)

def query(g,func,bb,high,limit=None,profile=None,mode='baseline'):
 q=generate_candidates_query(g['label'],func,bb,1,high,2,defaults.IGNORE_NAMES,defaults.IGNORE_OP_TYPES,
        min_nodes=1,max_nodes=1000,stage=32,limit=limit,allowed_reg_classes=RegisterClass.GPR|RegisterClass.UNKNOWN)
 if mode=='early':
  q=q.replace('WHERE b:INSTR',f'WHERE ({expression("b",profile)}) AND b:INSTR',1)
  q=q.replace('node:INSTR',f'({expression("node",profile)}) AND node:INSTR')
 elif mode=='late':
  q=q.replace('WHERE size(all_nodes) >= 1', f'WHERE size(all_nodes) >= 1 AND all(node IN all_nodes WHERE {expression("node",profile)})')
 elif mode=='idmask':
  q=q.replace('WHERE b:INSTR','WHERE id(b) IN $eligible AND b:INSTR',1)
  q=q.replace('node:INSTR','id(node) IN $eligible AND node:INSTR')
 return q

def run(d,q,params):
 t=time.perf_counter(); rows=[]
 try:
  with d.session() as s:
   for r in s.run(Query(q,timeout=6),**params):
    rows.append(tuple(tuple(int(n.element_id) for n in path.nodes) for path in r.values()))
  return rows,(time.perf_counter()-t)*1000,None
 except Exception as e:
  return None,(time.perf_counter()-t)*1000,type(e).__name__+': '+str(e)[:180]

def filter_rows(rows,eligible):
 t=time.perf_counter()
 result=[r for r in rows if all(n in eligible for p in r for n in p)]
 return result,(time.perf_counter()-t)*1000

def main():
 a=argparse.ArgumentParser();a.add_argument('--repeats',type=int,default=1);a.add_argument('--high',type=int,default=3);a.add_argument('--limit',type=int);a.add_argument('--output',default='pilot');a.add_argument('--profiles',nargs='+',default=['no_mem','cfu_local','codegen_local']);a.add_argument('--cases',nargs='+');args=a.parse_args()
 gs=[json.loads((ROOT/f'graph-{i}.json').read_text()) for i in range(2)]
 cases=[('sha_hot',0,'_nettle_sha256_compress','%bb.5'),('sha_mid',0,'_nettle_sha256_compress','%bb.4'),('sha_load',0,'_nettle_sha256_compress','%bb.1'),('sha_mixed',0,'sha256_digest','%bb.6'),('crc_hot',1,'benchmark_body','%bb.4'),('crc_alloc',1,'malloc_beebs','%bb.1'),('crc_rand',1,'rand_beebs','%bb.0'),('crc_arith',1,'benchmark_body','%bb.7')]
 if args.cases:cases=[x for x in cases if x[0] in args.cases]
 rows_out=[]; random.seed(20261030)
 with GraphDatabase.driver('bolt://127.0.0.1:7687',auth=('', ''),connection_timeout=3) as d:
  for name,idx,func,bb in cases:
   g=gs[idx]; ids={p:{n['id'] for n in g['nodes'] if allowed(n['props'],p)} for p in args.profiles}
   baseline=None
   for repeat in range(args.repeats):
    tasks=[('baseline',None)]+[(mode,p) for p in args.profiles for mode in ('late','early','idmask')]
    random.shuffle(tasks)
    completed={}
    for mode,profile in tasks:
     q=query(g,func,bb,args.high,args.limit,profile,mode)
     key=f'{name}-{profile or "base"}-{mode}-L{args.high}-cap{args.limit}'
     (ROOT/(key+'.cypher')).write_text(q)
     result,ms,error=run(d,q,{'eligible':list(ids[profile])} if mode=='idmask' else {})
     completed[(mode,profile)]=(result,ms,error)
    base,base_ms,base_error=completed[('baseline',None)]
    for profile in args.profiles:
     ref,post_ms=filter_rows(base,ids[profile]) if base is not None else (None,None)
     for mode in ('baseline','late','early','idmask'):
      result,ms,error=completed[('baseline',None) if mode=='baseline' else (mode,profile)]
      valid=ref if mode=='baseline' else result
      same=None
      if args.limit is None and valid is not None and ref is not None:
       same=collections.Counter(valid)==collections.Counter(ref)
       if not same:raise RuntimeError(f'candidate mismatch: {name}/{profile}/{mode}')
      row=dict(case=name,profile=profile,mode=mode,repeat=repeat,high=args.high,limit=args.limit,
               query_ms=ms,post_ms=post_ms if mode=='baseline' else 0,
               rows=len(result) if result is not None else None,valid_rows=len(valid) if valid is not None else None,
               unique_candidates=len({frozenset(n for p in r for n in p) for r in valid}) if valid is not None else None,
               identical=same,error=error)
      rows_out.append(row)
      print(json.dumps(row),flush=True)
    (ROOT/(args.output+'.json')).write_text(json.dumps(rows_out,indent=2))
 print('DONE',ROOT/(args.output+'.json'),flush=True)
if __name__=='__main__':main()
