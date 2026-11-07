import json
from pathlib import Path
from neo4j import GraphDatabase, Query
from bench import allowed, FLAGS, ROOT
URI='bolt://127.0.0.1:28763'
with GraphDatabase.driver(URI,auth=('', ''),connection_timeout=3) as d:
 with d.session() as s:
  assert s.run('MATCH (n) RETURN count(n) AS count').single()['count']==0, 'Temporary database must start empty'
  s.run('CREATE INDEX ON :INSTR').consume()
  for prop in ('name','inst','session','func_name','stage','experiment_source_id'):
   s.run(f'CREATE INDEX ON :INSTR({prop})').consume()
  for f in sorted(ROOT.glob('graph-*.json')):
   g=json.loads(f.read_text())
   nodes=[]
   for n in g['nodes']:
    props=dict(n['props'],experiment_source_id=n['id'])
    for profile in FLAGS:props['isaac_exp_'+profile]=allowed(n['props'],profile)
    nodes.append(dict(props=props))
   for i in range(0,len(nodes),200):
    s.run(Query('UNWIND $rows AS row CREATE (n:INSTR) SET n = row.props',timeout=10),rows=nodes[i:i+200]).consume()
   for i in range(0,len(g['edges']),300):
    s.run(Query('UNWIND $rows AS row MATCH (a:INSTR {experiment_source_id:row.source}),(b:INSTR {experiment_source_id:row.target}) CREATE (a)-[r:DFG]->(b) SET r = row.props',timeout=10),rows=g['edges'][i:i+300]).consume()
   print('LOADED',f.name,len(nodes),len(g['edges']),flush=True)
  print(s.run('MATCH (n:INSTR) RETURN count(n) AS nodes').single().data(),flush=True)
