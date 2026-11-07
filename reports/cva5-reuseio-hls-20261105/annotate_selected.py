from pathlib import Path
from isaac_toolkit.session import Session
from isaac_toolkit.backend.memgraph.annotate_bb_weights import annotate_bb_weights,enforce_bb_report
root=Path(__file__).resolve().parent
sess=Session.from_dir(root/'runs/crc32/20261105T120000/sess')
annotate_bb_weights(sess,label='isaac-demo-crc32-20261105T120000',force=True,mismatch_action='warn')
report=next(a.df for a in sess.artifacts if a.name=='bb_cdfg_validation')
selected=report[report.selected].copy()
enforce_bb_report(selected,'error')
report.to_csv(root/'bb-validation-all.csv',index=False)
selected.to_csv(root/'bb-validation-selected.csv',index=False)
print(selected.to_string(index=False))
