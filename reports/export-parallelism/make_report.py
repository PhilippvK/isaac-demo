from pathlib import Path
import pandas as pd,json,statistics,hashlib,subprocess
from PIL import Image
r=Path('/tmp/isaac-export-parallel-eval')
charts=pd.read_json(r/'charts.jsonl',lines=True)
assert len(charts)==18
med=charts.groupby(['case','method']).seconds.median().unstack()
graphs=pd.read_json(r/'full-graphs.jsonl',lines=True)
assert len(graphs)==48
full=graphs.groupby(['case','family','method','workers']).seconds.median()
misc=pd.DataFrame(json.loads((r/'misc.json').read_text()))
hist=json.loads((r/'historical.json').read_text())
meta=json.loads((r/'source_versions.json').read_text())
# Prove source state still matches the implementation used in the experiment.
for f,h in meta['source_sha256'].items():
 assert hashlib.sha256((Path('/var/tmp/ga87puy/isaac-demo-new/memgraph_experiments')/f).read_bytes()).hexdigest()==h
# Compare decoded images and extracted PDF text, not metadata/timestamps.
validation={}
for case in ('crc','sha'):
 signatures=[]
 for method in ('serial','batch','process2'):
  for rep in range(3):
   out=r/f'chart-{case}-{method}-{rep}';sig=[]
   for name in ('pie.png','pie2.png'):
    with Image.open(out/name) as im:
     assert im.size==(700,500)
     sig.append(hashlib.sha256(im.convert('RGBA').tobytes()).hexdigest())
   for name in ('pie.pdf','pie2.pdf'):
    sig.append(hashlib.sha256(subprocess.check_output(['pdftotext',str(out/name),'-'])).hexdigest())
   signatures.append(sig)
 assert all(s==signatures[0] for s in signatures)
 validation[case]={'exports':len(signatures),'png_pixels_identical':True,'pdf_text_identical':True}
for case in ('crc','sha'):
 for family in ('sub','io_sub'):
  baseline=r/f'graph-{family}-{case}-pdfdotpkl-serial1-10'
  for rep in (10,11,12):
   for workers in (4,8,16):
    out=r/f'graph-{family}-{case}-pdfdotpkl-process{workers}-{rep}'
    for dot in baseline.glob('*.dot'):
     assert dot.read_bytes()==(out/dot.name).read_bytes()
    for pdf in out.glob('*.pdf'):
     assert pdf.open('rb').read(5)==b'%PDF-'
(r/'validation.json').write_text(json.dumps(validation,indent=2))
lines=['# Evaluation: parallel dump/export stages','',
'## Recommendation','',
'Optimize pie rendering first by batching its four static images in one `plotly.io.write_images` call. Do not add a general outer executor for all dump stages. Keep the existing graph process pools, but consider an explicit worker limit and a serial fast path for very small or pickle-only exports. This evaluation changes no production source.','',
'## Scope and reproducibility','',
f"Source commit: `{meta['commit']}`; worktree at capture: `{meta['dirty'].strip() or 'clean'}`. Python {meta['python']}; CPU affinity {meta['affinity']}, reported CPUs {meta['cpus']}. Versions: {meta['versions']}. Source fingerprints are in `source_versions.json` and were revalidated when building this report.", '',
'Inputs are saved CRC32 (42 dataframe rows, 6 selected candidates) and SHA256 (18,142 dataframe rows, 669 selected candidates) from `out/embench_iot/crc32/20261022T132649/work/benchmark_body_%bb.3_0` and `out/embench_iot/nettle-sha256/20261021T091416/work/_nettle_sha256_compress_%bb.5_0`. Existing results were read only; exports went to this experiment directory on the same local filesystem. No DB access, dependency downloads, or new full ISAAC flows were needed.','',
'All reported comparison times are three-run medians. Each sweep randomized run order and executed benchmark cases sequentially. Chart tests used fresh Python processes, with imports and input loading outside the timed region, and included figure construction and four writes. Graph tests included pool creation, per-task serialization, export, result collection, and pool shutdown; preloading and result validation were outside timing. Worker payloads use small settings objects rather than the full production Settings object. Do not interpret these results as a universal optimum.','',
'## Existing parallelism','',
'`tool/stages/write_subs.py` and `write_io_subs.py` already submit one worker per candidate using `ProcessPoolExecutor(settings.n_parallel)`. These are separate, sequential pools. `n_parallel` is available in YAML; no CLI option currently forwards it. With null it uses the Python executor default (16 CPUs on this host). Extra parallelism across these stages would multiply active pools unless they share one global budget.','',
'## Pie export: the main avoidable cost','',
'| Input | Current: four sequential writes | Two processes, one per chart | One batched call | Batch speedup |',
'|---|---:|---:|---:|---:|']
for case in ('crc','sha'):
 x=med.loc[case];lines.append(f"| {case} | {x['serial']:.3f} s | {x['process2']:.3f} s | {x['batch']:.3f} s | {x['serial']/x['batch']:.2f}x |")
lines+=['',
'The current default writes two charts in both PDF and PNG. The local Plotly batch implementation passes all four objects to one Kaleido batch invocation. Two workers improve latency but retain more browser startup overhead, memory, and process management. Batching achieved a larger improvement with less orchestration. CSV/HTML-only exports do not have this browser cost. Only PDF+PNG was benchmarked here.', '',
'All 18 chart exports produced four files. For each input, decoded PNG pixels and extracted PDF text matched across all methods and repetitions. PDF binary equality was not required because metadata can differ. A sandboxed browser startup stalled and was terminated; all reported chart timings are from successful exports outside the sandbox.','',
'## Graph exports: all selected candidates','',
'Format is DOT + PDF + pickle. These runs use the actual existing per-candidate worker functions.','',
'| Input | Graph type | Candidates | Serial | 4 workers | 8 workers | 16 workers |','|---|---|---:|---:|---:|---:|---:|']
for case in ('crc','sha'):
 for family in ('sub','io_sub'):
  n=int(graphs[(graphs.case==case)&(graphs.family==family)].n.iloc[0]); vals=[full.loc[(case,family,'serial',1)]]+[full.loc[(case,family,'process',w)] for w in (4,8,16)]
  lines.append(f"| {case} | {family} | {n} | "+' | '.join(f'{v:.3f} s' for v in vals)+' |')
lines+=['',
'For a small candidate set, pool creation can cost more than serial work. Rendering many graphs benefits from the existing process pools. The preliminary 108-run sweep additionally covered pickle-only and DOT+pickle exports on 6 CRC32 and 48 SHA256 saved graphs; pickle-only exports were faster serially than through pools. That sweep sampled saved files, which may include old artifacts; the full-set confirmation above selects actual SELECTED indices from the saved dataframe. Graph pickle node and edge data were checked after every benchmark run; DOT output was byte-identical across worker counts on the full selected sets, and PDF outputs had valid headers.','',
'## Dataframes and Sankey','',
'| Input | Sequential DF + Sankey | Two threads |','|---|---:|---:|']
for case in ('crc','sha'):
 x=misc[misc.case==case].groupby('mode').seconds.median();lines.append(f"| {case} | {x['serial']:.4f} s | {x['threads2']:.4f} s |")
lines+=['',
'Both stages used their actual unmodified entry points, exporting CSV/pickle and Mermaid. Dataframe pickle round trips and artifact registration were checked. The absolute benefit is small and can fall within run-to-run effects. Process workers would also need to transfer the large dataframe: a separate local measurement serialized the SHA dataframe to roughly 13.4 MB in about 0.12 seconds, before IPC or deserialization.','',
'## Potential workflow impact','',
'The 12 saved `times.csv` files show pie export at about 14–18 seconds. It dominates small CRC32 jobs, while SHA256 query/analysis/variation stages dominate large jobs. These are historical instrumented tool-stage sums, not a rerun of the full demo or compiler workflow.','',
'| Saved job | Instrumented total | Pie | Ideal saving from overlapping existing export stages |','|---|---:|---:|---:|']
for row in hist:
 if ('20261022T132649' in row['path']) or ('20261021T203457' in row['path']):
  vals=[row[k] for k in ['Subgraph Export','Dumping I/O Subgraphs','Dump DFs','Dump Pie','Dump Sankey chart']]
  name=row['path'].split('/work/')[-1];lines.append(f"| {name} | {row['total']:.2f} s | {row['Dump Pie']:.2f} s | {sum(vals)-max(vals):.2f} s |")
lines+=['',
'The last column is an optimistic upper bound: sequential sum minus the longest stage, assuming zero overhead and no contention. The index must still wait for artifact-producing stages. Substituting the measured batched pie cost suggests roughly 10 seconds saved per block in these configurations. A 15-second CRC32 tool job could approach 5 seconds; a 365-second SHA job saves only about 3%. These are estimates, not measured full-workflow speedups.','',
'## Dependencies and implementation cautions','',
'- Keep graph styling and dataframe finalization before graph export. Styled graph attributes are shared between candidates; mutation during export would race.',
'- Have workers return artifact updates, then merge them in the parent and wait before `write_index`. The existing graph exporters already follow this pattern.',
'- `write_index` mutates `global_df` and reads every artifact entry, so scheduling it alongside the producers can yield missing or inconsistent paths.',
'- `tool/index.py:write_index_file` additionally writes a hardcoded `/tmp/abc.yml`; independent block-level parallelism would race on that path. Use a unique per-job path before parallelizing whole jobs.',
'- Prefer existing process workers for Graphviz; no Graphviz thread-safety claim was established by these tests. Do not fork process pools from an outer multithreaded exporter.',
'- The optional HDF5 path was not benchmarked: it is disabled by default, uses one hardcoded `/tmp/mytestfile.hdf5`, and the current main call supplies four arguments to a three-argument exporter. It needs repair before performance work; concurrent writers to that same file are not a suitable extension.',
'- The early function-graph dump writes one graph sequentially; historical cost was only 0.01–0.41 seconds for these runs. There is no per-candidate work to distribute within that stage.',
'- Bound total concurrency across blocks/stages rather than creating several default-sized process pools.',
'- Propagate failures and retain deterministic filenames and artifact mappings. Batch static image export should respect the configured formats and existing MathJax override.',
'',
'## Artifacts','',
'`historical.json`, `charts.jsonl`, `graphs.jsonl` (108 preliminary runs), `full-graphs.jsonl` (48 full-set runs), `misc.json`, `serialization.json`, `validation.json`, `source_versions.json`; scripts `bench.py`, `chart_sweep.py`, `graph_sweep.py`, `full_graph_sweep.py`, `misc_sweep.py`, `make_report.py`. All production sources remained unchanged during this evaluation.','']
(r/'report.md').write_text('\n'.join(lines))
print(med.round(3).to_string());print(full.round(3).to_string());print('Report:',r/'report.md')
