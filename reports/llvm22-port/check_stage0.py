"""Check CDFG/PatternGen/Seal5 marker patch composition without altering a build."""
from pathlib import Path
import subprocess, tempfile, re
from seal5.tools.cdsl2llvm import get_pattern_gen_backend_patch
root = Path(__file__).resolve().parents[2]
port = root / 'cfg/seal5/llvm22-isaac.patch'
markers = root / 'seal5/seal5/resources/patches/llvm/insert_markers_llvm22.patch'
with tempfile.TemporaryDirectory(prefix='isaac-llvm22-stage0-') as tmp:
    tree = Path(tmp)
    subprocess.run(['git', 'init', '-q', str(tree)], check=True)
    paths = set()
    for patch in [port, markers]:
        paths.update(re.findall(r'^--- a/(.*)$', patch.read_text(), re.M))
    for suffix in ['GISel/RISCVInstructionSelector.cpp','RISCVInstrInfo.cpp','RISCVLateBranchOpt.cpp',
                   'RISCVRedundantCopyElimination.cpp','GISel/RISCVLegalizerInfo.cpp','RISCVInstrInfo.td']:
        paths.add('llvm/lib/Target/RISCV/' + suffix)
    for path in paths:
        text = subprocess.check_output(['git', '-C', str(root/'llvm-project-22'), 'show', 'HEAD:' + path])
        dest = tree / path
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_bytes(text)
    subprocess.run(['git', '-C', str(tree), 'apply', str(port)], check=True)
    print('CDFG port applies to pristine LLVM22.1.8', flush=True)
    backend = get_pattern_gen_backend_patch(root/'reports/llvm22-migration/patterngen22', tree, tree)
    assert backend is not None
    subprocess.run(['git', '-C', str(tree), 'apply', str(backend.file)], check=True)
    print('PatternGen backend support applies after CDFG', flush=True)
    subprocess.run(['git', '-C', str(tree), 'apply', str(markers)], check=True)
    print('LLVM22 Seal5 insertion markers apply after both patches', flush=True)
