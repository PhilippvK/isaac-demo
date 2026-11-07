from pathlib import Path
import sys,json,tarfile,time
import zstandard
from isaac_toolkit.retargeting.service.client import Seal5RetargetClient,EtissRetargetClient
root=Path(__file__).resolve().parent
repo=root.parent.parent
tag=sys.argv[1];bench=sys.argv[2] if len(sys.argv)>2 else 'crc32'
run=next(p for p in (repo/'reports/bb-quality-20261102/runs'/bench).iterdir() if (p/'work-new').exists())
work=run/'work-new'
base=root if bench=='crc32' else root/bench;base.mkdir(exist_ok=True)
out=base/tag;out.mkdir(exist_ok=True)
if tag=='llvm':
 client=Seal5RetargetClient('http://localhost:8080')
 job,token=client.submit_job('llvm',cdsl_path=str(work/'gen/XIsaac.seal5.core_desc'),config_path=str(repo/'reports/bb-quality-20261102/service-default.yml'))
else:
 top=(work/'gen/XIsaacCore.core_desc').read_text()
 top=top.replace(f'import "{work}/gen/XIsaac.core_desc"',(work/'gen/XIsaac.core_desc').read_text())
 top=top.replace(str(repo/'etiss_arch_riscv'),'/tools/etiss_arch_riscv')
 core=base/'XIsaacCore.core_desc';core.write_text(top)
 client=EtissRetargetClient('http://localhost:8080');job,token=client.submit_job('etiss',cdsl_path=str(core))
(out/'job.json').write_text(json.dumps({'job_id':job,'tag':tag},indent=2))
print('Submitted',tag,job,flush=True)
status=client.wait_for_completion(job)
client.download_logs(job,str(out/'job.log'))
if status!='finished':raise RuntimeError(f'{tag} job failed: see {out}/job.log')
archive=out/'artifact.tar.zst';client.download_artifact(job,str(archive))
with archive.open('rb') as src,zstandard.ZstdDecompressor().stream_reader(src) as reader,tarfile.open(fileobj=reader,mode='r|') as bundle:
 for item in bundle:
  relative=Path(item.name)
  if relative.parts and relative.parts[0]=='output':relative=Path(*relative.parts[1:])
  allowed=(str(relative)=='seal5.tar.gz' or str(relative).startswith('seal5_reports/') or str(relative).startswith('etiss_install/') or str(relative).startswith('llvm_install/lib/clang/') or str(relative) in ['llvm_install/bin/clang','llvm_install/bin/clang-19','llvm_install/bin/clang++','llvm_install/bin/llc','llvm_install/bin/lld','llvm_install/bin/ld.lld','llvm_install/bin/llvm-objdump','llvm_install/bin/llvm-readobj'])
  if allowed:
   item.name=str(relative);bundle.extract(item,out)
archive.unlink()
print('Recovered selected',tag,'artifacts',flush=True)
