"""Retain the LLVM22 port as a portable patch, including new CDFG sources."""
from pathlib import Path
import subprocess, json, difflib
root = Path(__file__).resolve().parents[2]
repo = root / 'llvm-project-22'
assert subprocess.check_output(['git', '-C', str(repo), 'rev-parse', 'HEAD'], text=True).strip() == 'ca7933e47d3a3451d81e72ac174dcb5aa28b59d1', 'Use these development helpers only before Seal5 retargets the source tree'
patch = subprocess.check_output(['git', '-C', str(repo), 'diff', '--binary'], text=True)
for entry in json.loads((root / 'reports/llvm22-migration/merge-audit.json').read_text()):
    if entry['status'] != 'new-custom-file':
        continue
    path = entry['path']
    text = (repo / path).read_text()
    patch += f'diff --git a/{path} b/{path}\nnew file mode 100644\n'
    patch += ''.join(difflib.unified_diff([], text.splitlines(keepends=True), fromfile='/dev/null', tofile='b/' + path))
(root / 'cfg/seal5/llvm22-isaac.patch').write_text(patch)
print(len(patch), 'bytes')
