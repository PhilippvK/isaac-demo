import json,sys,collections
from pathlib import Path
sys.path.insert(0,str(Path('memgraph_experiments').resolve()))
from tool import defaults
from tool.types import RegisterClass
for p in sorted(Path('/tmp/isaac-query-pushdown-20261030').glob('graph-*.json')):
 g=json.loads(p.read_text()); groups=collections.defaultdict(list)
 for n in g['nodes']:
  z=n['props']
  if z.get('name') in defaults.IGNORE_NAMES or z.get('op_type') in defaults.IGNORE_OP_TYPES:continue
  if z.get('out_reg_class') in ('fpr','fpr32','fpr64','csr'):continue
  groups[(z['func_name'],z['basic_block'])].append(z)
 print('\n',g['label'])
 for k,nodes in sorted(groups.items(),key=lambda kv:len(kv[1]),reverse=True)[:15]:
  bad=[n for n in nodes if any(n.get(k,False) for k in ('mayLoad','mayStore','isBranch','isTerminator'))]
  print(k,'nodes',len(nodes),'bad',len(bad),'ops',dict(collections.Counter(n['name'] for n in nodes)))
