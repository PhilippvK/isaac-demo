import json
from pathlib import Path
from neo4j import GraphDatabase, Query
out=Path('/tmp/isaac-query-pushdown-20261030')
with GraphDatabase.driver('bolt://127.0.0.1:7687',auth=('', ''),connection_timeout=3) as d:
    with d.session() as s:
        rows=s.run(Query('MATCH (n:INSTR) RETURN n.session AS label, n.stage AS stage, count(*) AS nodes ORDER BY nodes DESC',timeout=10)).data()
        print(json.dumps(rows,indent=2),flush=True)
        (out/'sessions.json').write_text(json.dumps(rows,indent=2))
        labels=[]
        for r in rows:
            if r['label'] not in labels:
                labels.append(r['label'])
        selected=[]
        for term in ('nettle-sha256','crc32'):
            found=next((x for x in labels if term in x),None)
            if found:selected.append(found)
        selected += [x for x in labels if x not in selected and not any(t in x for t in ('nettle-sha256','crc32'))][:2]
        for i,label in enumerate(selected):
            nodes=s.run(Query('MATCH (n:INSTR) WHERE n.session=$label RETURN id(n) AS id, properties(n) AS props',timeout=10),label=label).data()
            edges=s.run(Query('MATCH (a:INSTR)-[r:DFG]->(b:INSTR) WHERE a.session=$label AND b.session=$label RETURN id(r) AS id, id(a) AS source, id(b) AS target, properties(r) AS props',timeout=10),label=label).data()
            (out/f'graph-{i}.json').write_text(json.dumps(dict(label=label,nodes=nodes,edges=edges),indent=2))
            print('SAVED',i,label,len(nodes),len(edges),flush=True)
