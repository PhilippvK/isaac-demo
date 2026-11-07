"""Compile/link real RISC-V BB maps and decode them with the Toolkit."""
from pathlib import Path
import json, os, subprocess, sys
from elftools.elf.elffile import ELFFile
from isaac_toolkit.analysis.static.llvm_bbs import parse_elf
from isaac_toolkit.utils.llvm_bb_addr_map import decode_bb_addr_map
root = Path(__file__).resolve().parent
repo = root.parents[1]
source = root / 'compat-input.c'
source.write_text('''volatile unsigned sink;
__attribute__((noinline)) unsigned choose(unsigned x) {
  if (x > 7) { sink = x; return x * 3; }
  sink = x + 1; return x + 1;
}
void _start(void) { sink = choose(sink); for (;;) {} }
''')
versions = [int(arg) for arg in sys.argv[1:]] or [19, 20, 21, 22]
results = []
xlen = int(os.environ.get('PROBE_XLEN', '32'))
assert xlen in (32, 64)
for major in versions:
    if major == 19:
        compiler = repo / 'install/llvm/bin/clang'
        library = repo / 'install/mgclient/lib'
    elif major == 22:
        compiler = repo / 'llvm-project-22/build/bin/clang'
        library = repo / 'install/mgclient/lib'
    else:
        prefix = root / 'compat-compilers' / str(major)
        compiler = prefix / f'usr/bin/clang-{major}'
        library = prefix / 'usr/lib/x86_64-linux-gnu'
    env = dict(os.environ, LD_LIBRARY_PATH=str(library))
    version = subprocess.check_output([str(compiler), '--version'], env=env, text=True)
    for flag in ['-fbasic-block-address-map', '-fbasic-block-sections=labels']:
        label = 'address-map' if flag.endswith('address-map') else 'labels'
        obj = root / f'compat-{major}-{label}-rv{xlen}.o'
        elf = root / f'compat-{major}-{label}-rv{xlen}.elf'
        command = [str(compiler), f'--target=riscv{xlen}-unknown-elf', f'-march=rv{xlen}im', '-mabi=' + ('ilp32' if xlen == 32 else 'lp64'), '-O2',
                   '-ffreestanding', '-fno-unwind-tables', '-fno-asynchronous-unwind-tables', flag,
                   '-c', str(source), '-o', str(obj)]
        compiled = subprocess.run(command, env=env, text=True, capture_output=True)
        row = dict(major=major, xlen=xlen, version=version, flag=flag, command=command, compile_returncode=compiled.returncode, stderr=compiled.stderr)
        if compiled.returncode == 0:
            subprocess.run(['/usr/bin/ld.lld-18', '-m', f'elf{xlen}lriscv', '-e', '_start', str(obj), '-o', str(elf)], check=True)
            blocks = parse_elf(elf)
            with elf.open('rb') as stream:
                ef = ELFFile(stream)
                maps = decode_bb_addr_map(ef.get_section_by_name('.llvm_bb_addr_map').data(), xlen // 8)
            assert set(blocks) == {'choose', '_start'}, blocks
            assert len(blocks['choose']) >= 3, blocks
            assert all(bb[3] > 0 for bbs in blocks.values() for bb in bbs.values())
            row.update(format_versions=sorted({rec['version'] for rec in maps}), blocks=blocks)
        results.append(row)
        print(major, flag, 'PASS' if compiled.returncode == 0 else compiled.stderr.strip(), flush=True)
(root / ('compat-probe-' + '-'.join(map(str, versions)) + ('' if xlen == 32 else '-rv64') + '.json')).write_text(json.dumps(results, indent=2))
