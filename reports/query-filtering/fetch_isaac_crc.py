import json
from pathlib import Path
from neo4j import GraphDatabase,Query
label='isaac-demo-crc32-20261021T203031'
with GraphDatabase.driver('bolt://127.0.0.1:7687',auth=('', ''),connection_timeout=3) as d:
 with d.session() as s:
  ns=s.run(Query('MATCH (n:INSTR) WHERE n.session=$label RETURN id(n) AS id,properties(n) AS props',timeout=6),label=label).data()
  es=s.run(Query('MATCH (a:INSTR)-[r:DFG]->(b:INSTR) WHERE a.session=$label AND b.session=$label RETURN id(r) AS id,id(a) AS source,id(b) AS target,properties(r) AS props',timeout=6),label=label).data()
  Path('/tmp/isaac-query-pushdown-20261030/graph-2.json').write_text(json.dumps(dict(label=label,nodes=ns,edges=es),indent=2))
  print(label,len(ns),len(es))
