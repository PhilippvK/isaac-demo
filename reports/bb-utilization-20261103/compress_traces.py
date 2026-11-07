from pathlib import Path
import gzip,shutil,sys
root=Path(__file__).resolve().parent
bench,arm=sys.argv[1:]
run=root/'runs'/bench/arm
trace=run/'etiss_instrs.log'
with trace.open('rb') as src,gzip.open(str(trace)+'.gz','wb') as dst:shutil.copyfileobj(src,dst)
trace.unlink()
# MLonMCU's optional artifacts can retain another raw copy; the exported gzip
# is the durable experiment trace. Keep other session artifacts unchanged.
for path in (root/'environment/results').glob('**/etiss_instrs.log'):
 path.unlink()
