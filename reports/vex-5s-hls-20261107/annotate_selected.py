from pathlib import Path
import sys
from isaac_toolkit.session import Session
from isaac_toolkit.backend.memgraph.annotate_bb_weights import annotate_bb_weights,enforce_bb_report
root=Path(__file__).resolve().parent
run=Path(sys.argv[1]).resolve() if len(sys.argv)>1 else root/'runs/crc32/20261107T120000'
sess=Session.from_dir(run/'sess')
annotate_bb_weights(sess,label=f'isaac-demo-{run.parent.name}-{run.name}',force=True,mismatch_action='warn')
report=next(a.df for a in sess.artifacts if a.name=='bb_cdfg_validation')
selected=report[report.selected].copy()
enforce_bb_report(selected,'error')
report.to_csv(root/'bb-validation-all.csv',index=False)
selected.to_csv(root/'bb-validation-selected.csv',index=False)
print(selected.to_string(index=False))
