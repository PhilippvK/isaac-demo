"""Apply the reviewed LLVM19 customizations to a pristine LLVM22.1.8 tree.

Development helper; final portable patch is retained alongside the report.
"""
from pathlib import Path
import json, re, subprocess
root = Path(__file__).resolve().parents[2]
source = root / 'llvm-project'
target = root / 'llvm-project-22'
assert subprocess.check_output(['git', '-C', str(target), 'rev-parse', 'HEAD'], text=True).strip() == 'ca7933e47d3a3451d81e72ac174dcb5aa28b59d1', 'Use these development helpers only before Seal5 retargets the source tree'
audit = root / 'reports/llvm22-migration'
# These upstream implementations replace old target-specific workarounds.
skip = {'clang/lib/Driver/ToolChains/Clang.cpp',
        'llvm/lib/Target/RISCV/GISel/RISCVRegisterBankInfo.cpp',
        'llvm/include/llvm/CodeGen/MachineBasicBlock.h'}
pattern = re.compile(r'^<<<<<<<[^\n]*\n(.*?)^\|\|\|\|\|\|\|[^\n]*\n(.*?)^=======\n(.*?)^>>>>>>>[^\n]*\n', re.M | re.S)
for entry in json.loads((audit / 'merge-audit.json').read_text()):
    path = entry['path']
    if path in skip:
        continue
    if entry['status'] == 'new-custom-file':
        text = subprocess.check_output(['git', '-C', str(source), 'show', 'HEAD:' + path], text=True)
    else:
        text = (audit / 'merge-preview' / path).read_text()
    if entry['status'] == 'conflict':
        def resolve(m):
            upstream, base, custom = m.groups()
            if path.endswith('GIMatchTableExecutor.h'):
                return custom.replace('  bool isOperandImmEqual', '  LLVM_ABI bool isOperandImmEqual')
            if path.endswith('SubtargetFeature.h'):
                return '// Allow per-instruction Seal5 extension feature bits.\n' + custom
            if path.endswith('MachineFunction.cpp'):
                return upstream.replace('  MBBNumberingEpoch++;', custom + '  MBBNumberingEpoch++;')
            if path.endswith('TargetPassConfig.cpp'):
                if 'CDFG_STAGE_3' in custom:
                    return custom + upstream
                if 'CDFG_STAGE_4' in custom:
                    return custom[custom.index('#ifdef HAS_CDFG_PASS'):]
                return upstream + custom[custom.index('#ifdef HAS_CDFG_PASS'):]
            if path.endswith('InstCombineCasts.cpp'):
                # Preserve the existing ISAAC policy of not widening whole
                # expression trees, while retaining LLVM22's truncation handling.
                if 'canEvaluateZExtd' in upstream:
                    return upstream.replace('if (shouldChangeType', '// ISAAC: preserve narrow expressions for instruction selection.\n  if (false && shouldChangeType', 1)
                return upstream.replace('if (ShouldExtendExpression &&', '// ISAAC: preserve narrow expressions for instruction selection.\n  if (false && ShouldExtendExpression &&', 1)
            raise ValueError(path)
        text, count = pattern.subn(resolve, text)
        assert count == entry['conflict_regions'], (path, count)
    if path.endswith('CDFGPass.cpp'):
        text = text.replace('#include "llvm/CodeGen/GlobalISel/GISelKnownBits.h"\n', '')
        text = text.replace('INITIALIZE_PASS_DEPENDENCY(GISelKnownBitsAnalysis)\n', '')
        text = text.replace('  // AU.addRequired<GISelKnownBitsAnalysis>();\n', '').replace('  // AU.addPreserved<GISelKnownBitsAnalysis>();\n', '')
        text = text.replace('#include "llvm/IR/Module.h"', '#include "llvm/IR/Module.h"\n#include "llvm/InitializePasses.h"')
        before, body = text.split('bool CDFGPass::runOnMachineFunction', 1)
        text = before + 'bool CDFGPass::runOnMachineFunction' + body.replace('return true;', 'return false;').replace('return false;  // TODO: return false?', 'return false;')
        assert not re.search(r'^(<<<<<<< |>>>>>>> )', text, re.M), path
    dest = target / path
    dest.parent.mkdir(parents=True, exist_ok=True)
    dest.write_text(text)
    print(path)
