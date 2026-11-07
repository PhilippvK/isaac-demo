"""Generate and compare CoreDSL semantics and profile metrics from both arms."""
from pathlib import Path
from collections import Counter
import hashlib,json,re
import yaml
from isaac_toolkit.generate.ise.generate_cdsl import generate_cdsl
root=Path(__file__).resolve().parent
summary=[]
for bench in ['crc32','nettle-sha256']:
 run=sorted(p for p in (root/'runs'/bench).iterdir() if (p/'sess').exists())[-1]
 arms={}
 for arm in ['old','new']:
  work=run/('work-'+arm)
  if not (work/'gen').exists():
   generate_cdsl(None,workdir=work,n_parallel=2)
  candidates=yaml.safe_load((work/'combined_index.yml').read_text())['candidates']
  signatures=[];metrics=[];freqs=[]
  for c in candidates:
   text=Path(c['artifacts']['cdsl']).read_text()
   text=re.sub(r'^// DateTime:.*\n', '', text, flags=re.M)
   normalized=re.sub(r'CUSTOM\d+', 'CUSTOM', text)
   sig=hashlib.sha256(normalized.encode()).hexdigest()
   p=c['properties'];freqs.append(p['Freq'])
   signatures.append(sig)
   metrics.append((sig,*(p.get(k) for k in ['#Instrs','Freq','Weight','IsoWeight','#Isos','#IsosNO'])))
  arms[arm]=dict(definitions=len(candidates),profiled_frequency_positive=sum(f>0 for f in freqs),
                 min_profile_frequency=min(freqs),max_profile_frequency=max(freqs),
                 semantic_hashes=sorted(signatures),metrics=sorted(metrics))
 row=dict(benchmark=bench,identical_semantic_multiset=arms['old']['semantic_hashes']==arms['new']['semantic_hashes'],
          identical_profile_metrics=arms['old']['metrics']==arms['new']['metrics'],arms=arms)
 summary.append(row)
 print(bench,'same definitions',row['identical_semantic_multiset'],'same metrics',row['identical_profile_metrics'],flush=True)
(root/'output-comparison.json').write_text(json.dumps(summary,indent=2))
assert all(r['identical_semantic_multiset'] and r['identical_profile_metrics'] for r in summary)
