#!/usr/bin/env python3
"""Independent F4PGA XC7 synthesis-to-bitstream backend (SymbiFlow CLI)."""
import argparse
from collections import Counter
import hashlib
import json
import math
import os
from pathlib import Path
import re
import shlex
import shutil
import subprocess
import sys
import time

HERE = Path(__file__).resolve().parent
BOARD = HERE.parent / 'boards/arty_a7_100'
PART = 'xc7a100tcsg324-1'
TOPS = {'VEX_5S': 'vex_arty_top', 'CVA5': 'cva5_arty_top'}


def result_top(out):
    path = out/'execution.json'
    core = json.loads(path.read_text()).get('core', 'VEX_5S') if path.exists() else 'VEX_5S'
    return TOPS[core]


STEPS = ['synth', 'pack', 'place', 'route', 'write_fasm', 'write_bitstream']


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def write_json(path, value):
    path.write_text(json.dumps(value, indent=2) + '\n')


def firmware_image(binary=None, coe=None):
    if binary and coe:
        raise ValueError('Choose FPGA_SYN_FIRMWARE_BIN or FPGA_SYN_INIT_COE, not both')
    if binary:
        data = Path(binary).read_bytes()
        if not data or len(data) > 262144:
            raise ValueError('Firmware must be nonempty and fit 256 KiB')
        data = data.ljust(262144, b'\0')
        words = [int.from_bytes(data[i:i+4], 'little') for i in range(0, len(data), 4)]
    elif coe:
        text = Path(coe).read_text()
        if not re.search(r'memory_initialization_radix\s*=\s*16\s*;', text, re.I):
            raise ValueError('Only hexadecimal COE is supported')
        match = re.search(r'memory_initialization_vector\s*=\s*([\da-fA-F,\s]+);\s*$', text, re.I)
        if not match:
            raise ValueError('Invalid COE vector')
        words = [int(w.strip(), 16) for w in match[1].split(',') if w.strip()]
        if not words or len(words) > 65536 or any(w > 0xffffffff for w in words):
            raise ValueError('COE does not fit 64K x 32 memory')
        words += [0] * (65536-len(words))
    else:
        words = [0] * 65536
    return ''.join(f'{word:08x}\n' for word in words)


def normalize_constant_selects(text):
    """Fold sized-literal selects emitted by sv2v 0.0.13, unsupported by Yosys.

    Only constant, in-range selects of fully known literals are rewritten.
    Expressions and variable selects are left for the HDL frontend.
    """
    pattern = r"(\d+)'[sS]?([bBoOdDhH])([0-9a-fA-F_]+)\[(\d+)(?:(-:|:)(\d+))?\]"
    def fold(match):
        width, base, digits, high, kind, low = match.groups()
        width, high = int(width), int(high)
        low = high if kind is None else (high-int(low)+1 if kind == '-:' else int(low))
        if not 0 <= low <= high < width:
            raise ValueError('Out-of-range converted constant select: '+match[0])
        value = int(digits.replace('_', ''), {'b': 2, 'o': 8, 'd': 10, 'h': 16}[base.lower()])
        size = high-low+1
        return str(size)+"'h"+format((value >> low) & ((1 << size)-1), 'x')
    return re.sub(pattern, fold, text)


def strip_intel_ramstyle(text):
    # Yosys recognizes both spellings, so Intel's MLAB hint must not reach
    # the Xilinx memory mapper. Preserve the independent ram_style hint.
    text = re.sub(r'\(\*\s*ramstyle\s*=\s*"[^"]*"\s*\*\)', '', text)
    text = re.sub(r'\bramstyle\s*=\s*"[^"]*"\s*,\s*', '', text)
    return re.sub(r',\s*\bramstyle\s*=\s*"[^"]*"', '', text)


def prepare(rtl, out, binary=None, coe=None, core="VEX_5S"):
    """Stage portable board adapters without modifying generated HLS sources."""
    files = []
    for line in (rtl / 'files.txt').read_text().splitlines():
        if line.strip():
            path = Path(line.strip())
            files.append((rtl / path).resolve())
    files += sorted(rtl.parent.glob('ISAX_*.sv'))
    files = list(dict.fromkeys(files))
    if not files or len({p.name for p in files}) != len(files):
        raise ValueError('Missing sources or duplicate source basenames')
    staged = out / 'rtl'
    staged.mkdir()
    hashes = {}
    for p in files:
        hashes[str(p)] = sha(p)
        text = p.read_text()
        if core == 'CVA5':
            text = strip_intel_ramstyle(text)
            if p.name in ('CVA5_top.v', 'scaiev_unit.sv'):
                adapter = 'prepare_top.py' if p.name == 'CVA5_top.v' else 'prepare_scaiev.py'
                subprocess.run([sys.executable, str(BOARD/adapter), str(p), str(staged/p.name)], check=True)
                continue
            if p.name in ('cva5.sv', 'writeback.sv', 'scaiev_glue.sv'):
                subprocess.run([sys.executable, str(HERE/'cva5_defaults.py'), str(p), str(staged/p.name)], check=True)
                continue
            if p.name == 'cva5_config.sv':
                for option in ('INCLUDE_ICACHE', 'INCLUDE_DCACHE', 'INCLUDE_IBUS'):
                    if not re.search(r'\b'+option+r'\s*:\s*0\s*,', text):
                        raise ValueError('CVA5 Arty requires '+option+' : 0')
        if core == 'VEX_5S' and p.name == 'VexRiscv.v':
            text, n = re.subn(r'\bmodule\s+VexRiscv\s*\(', 'module VexRiscv (output wire isaac_retired,', text)
            if n != 1 or 'wire                writeBack_arbitration_isFiring;' not in text:
                raise ValueError('Unexpected VexRiscv retirement interface')
            text = text.replace('wire                writeBack_arbitration_isFiring;',
                                'wire writeBack_arbitration_isFiring;\n assign isaac_retired = writeBack_arbitration_isFiring;', 1)
        elif core == 'VEX_5S' and p.name == 'Vex_top.sv':
            text, n = re.subn(r'\bmodule\s+top\s*\(', 'module top(output wire isaac_retired,', text)
            text, k = re.subn(r'\bVexRiscv\s+VexRiscv_inst\s*\(',
                              'VexRiscv VexRiscv_inst(.isaac_retired(isaac_retired),', text)
            if (n, k) != (1, 1):
                raise ValueError('Unexpected Vex wrapper interface')
        (staged / p.name).write_text(text)
    required = {'VexRiscv.v', 'Vex_top.sv'} if core == 'VEX_5S' else {'CVA5_top.v', 'cva5_config.sv', 'scaiev_unit.sv'}
    if not required <= {p.name for p in files}:
        raise ValueError(f'{core} requires {sorted(required)}')
    for directory in {p.parent for p in files}:
        for pattern in ['*.vh', '*.svh']:
            for p in directory.glob(pattern):
                target = staged / p.name
                if target.exists() and target.read_bytes() != p.read_bytes():
                    raise ValueError(f'Conflicting include header: {p}')
                shutil.copyfile(p, target)
                hashes[str(p)] = sha(p)
    top = TOPS[core]
    shell = (BOARD / (top+'.sv')).read_text()
    if core == 'VEX_5S' and shell.count('dut.VexRiscv_inst.writeBack_arbitration_isFiring') != 1:
        raise ValueError('Unexpected board retirement tap')
    if shell.count('MMCME2_BASE #(') != 1 or shell.count('.CLKIN1(clk_input),') != 1:
        raise ValueError('Unexpected MMCM board interface')
    # The pinned full-100T architecture models PLLs, but not MMCMs.
    # 100 MHz * 10 / 50 gives the same 20 MHz clock at a 1 GHz VCO.
    shell = shell.replace('MMCME2_BASE #(', 'PLLE2_ADV #(')
    shell = shell.replace('.CLKFBOUT_MULT_F(10.0)', '.CLKFBOUT_MULT(10)')
    shell = shell.replace('.CLKOUT0_DIVIDE_F(50.0)', '.CLKOUT0_DIVIDE(50)')
    shell = shell.replace('.CLKIN1(clk_input),',
                          '.CLKIN1(clk_input), .CLKIN2(1\'b0), .CLKINSEL(1\'b1),\n'
                          '        .DADDR(7\'b0), .DCLK(1\'b0), .DEN(1\'b0), .DI(16\'b0), .DWE(1\'b0),')
    shell = shell.replace('dut.VexRiscv_inst.writeBack_arbitration_isFiring', 'isaac_retired')
    shell = shell.replace(' top dut(', ' wire isaac_retired;\n top dut(.isaac_retired(isaac_retired),')
    (staged / (top+'.sv')).write_text(shell)
    shutil.copyfile(HERE / ('ram.sv' if core == 'VEX_5S' else 'cva5_ram.sv'), staged / 'ram.sv')
    if core == 'CVA5':
        shutil.copyfile(HERE/'axi_uart.sv', staged/'axi_uart.sv')
    shutil.copyfile(HERE / 'board.xdc', out / 'board.xdc')
    (out / 'firmware.hex').write_text(firmware_image(binary, coe))
    # Legacy wrappers split arguments internally: use simple relative names.
    ordered = [f'rtl/{p.name}' for p in files] + ['rtl/ram.sv', 'rtl/'+top+'.sv']
    if core == 'CVA5':
        ordered += ['rtl/axi_uart.sv']
    if any(re.search(r'[^\w./-]', name) for name in ordered):
        raise ValueError('F4PGA wrapper source filenames must be simple paths')
    return ordered, hashes


def commands(sources, top='vex_arty_top'):
    common = ['-e', top+'.eblif', '-d', 'xc7a100t_test']
    sdc = ['-s', 'constraints.sdc']
    return [
        ['symbiflow_synth', '-t', top, '-v', *sources, '-d', 'artix7', '-p', PART, '-x', 'board.xdc'],
        ['symbiflow_pack', *common, *sdc],
        ['symbiflow_place', *common, '-n', top+'.net', '-P', PART, *sdc],
        ['symbiflow_route', *common, *sdc],
        ['python', str(HERE/'write_fasm.py'), *common, *sdc],
        ['symbiflow_write_bitstream', '-d', 'artix7', '-f', top+'.fasm', '-p', PART, '-b', top+'.bit'],
    ]


def deduplicate_sdc(out):
    """Collapse duplicate clock aliases using actual synthesized net bit identities."""
    netnames = json.loads((out/(result_top(out)+'.json')).read_text())['modules'][result_top(out)]['netnames']
    groups = {}
    pattern = r'create_clock\s+-period\s+(\S+)(?:\s+-waveform\s+(\{[^}]+\}))?\s+(\S+)\s*'
    for line in (out/(result_top(out)+'.sdc')).read_text().splitlines():
        if not line.strip() or line.lstrip().startswith('#'):
            continue
        match = re.fullmatch(pattern, line)
        if not match or match[3] not in netnames:
            raise ValueError(f'Unsupported native clock constraint: {line}')
        period, waveform, name = float(match[1]), match[2], match[3]
        bits = tuple(netnames[name]['bits'])
        if len(bits) != 1 or not isinstance(bits[0], int) or not math.isfinite(period) or period <= 0:
            raise ValueError('Invalid native clock net or period')
        if bits in groups:
            group = groups[bits]
            if (period, waveform) != (group['period'], group['waveform']):
                raise ValueError('Conflicting constraints on aliased clock nets')
            group['aliases'].append(name)
        else:
            groups[bits] = dict(period=period, waveform=waveform, aliases=[name])
    lines = []
    for group in groups.values():
        names = group['aliases']
        name = 'clk20' if 'clk20' in names else names[0]
        group['canonical'] = name
        wave = ' -waveform '+group['waveform'] if group['waveform'] else ''
        lines.append(f"create_clock -period {group['period']:g}{wave} {name}\n")
    (out/'constraints.sdc').write_text(''.join(lines))
    write_json(out/'clock-aliases.json', list(groups.values()))
    validate_clocks(out)


def validate_clocks(out):
    for filename in [result_top(out)+'.sdc', 'constraints.sdc']:
        sdc = (out/filename).read_text()
        if ('create_clock' not in sdc or not re.search(r'-period\s+50(?:\.0*)?(?:\s|$)', sdc)
                or 'clk20' not in sdc):
            raise ValueError('Missing explicit 20 MHz core clock in '+filename)


def validate_fasm(out):
    path = out/(result_top(out)+'.fasm')
    text = path.read_text() if path.is_file() else ''
    if not re.search(r'^CLB', text, re.M) or not re.search(r'^BRAM', text, re.M):
        raise ValueError('F4PGA FASM lacks implemented logic/BRAM features; bitstream generation refused')


def parse_results(out, require_bitstream=True):
    """Use actual mapped primitive counts, not estimates from RTL or LUT equations."""
    design = json.loads((out / (result_top(out)+'.json')).read_text())
    cells = design['modules'][result_top(out)]['cells']
    counts = Counter(c['type'] for c in cells.values())
    if any(t.startswith('$') and t != '$lut' for t in counts):
        raise ValueError('Unmapped Yosys cells in final netlist')
    def count(pattern):
        return sum(n for t, n in counts.items() if re.fullmatch(pattern, t))
    lut = count(r'LUT[1-6](?:_VPR)?') + counts.get('$lut', 0)
    ff = count(r'(?:FD[A-Z0-9_]*|[DS]FF[A-Z0-9_]*)')
    ram18 = count(r'RAMB18[A-Z0-9_]*')
    ram36 = count(r'RAMB36[A-Z0-9_]*')
    if not lut or not ff or not (ram18 or ram36):
        raise ValueError(f'Cannot identify mapped LUT/FF/BRAM resources: {dict(counts)}')
    route = (out / 'route.log').read_text(errors='replace')
    matches = re.findall(r'Final setup (?:slack|Worst Negative Slack) \(sWNS\):\s*([-+\d.eE]+)\s*ns', route)
    if not matches:
        raise ValueError('Missing routed VPR setup slack; inspect route.log')
    setup = float(matches[-1])
    hold_matches = re.findall(r'Final hold (?:slack|Worst Negative Slack) \(hWNS\):\s*([-+\d.eE]+)\s*ns', route)
    hold = float(hold_matches[-1]) if hold_matches else None
    if not math.isfinite(setup) or (hold is not None and not math.isfinite(hold)):
        raise ValueError('Non-finite routed timing')
    validate_clocks(out)
    required = [result_top(out)+'.'+suffix for suffix in ['eblif', 'net', 'place', 'route']]
    if require_bitstream:
        required += [result_top(out)+'.fasm', result_top(out)+'.bit']
    for name in required:
        if not (out/name).is_file() or not (out/name).stat().st_size:
            raise ValueError(f'Missing completed implementation artifact: {name}')
    if require_bitstream:
        validate_fasm(out)
    return dict(luts_total=lut, ffs_total=ff, brams_total=ram18+ram36,
                brams_18k_equivalent=ram18+2*ram36, dsps_total=count(r'DSP48[A-Z0-9_]*'),
                setup_slack_ns=setup, setup_met=setup >= 0, hold_slack_ns=hold,
                hold_met=None if hold is None else hold >= 0,
                resource_stage='F4PGA mapped LUT atoms before packing (not Vivado physical LUT sites)', primitive_counts=dict(counts),
                timing_scope='VPR constrained paths; native propagated clocks; asynchronous I/O unconstrained')


def validate(directory, part=PART, clock=50, core=None):
    meta = json.loads((directory/'execution.json').read_text())
    if (not meta.get('passed') or meta.get('status') != 'complete' or meta.get('tool') != 'f4pga'
            or meta.get('completed_steps') != STEPS or meta.get('core') not in TOPS or (core is not None and meta.get('core') != core)
            or not meta.get('frontend_checked')):
        raise ValueError(f'Failed or incompatible F4PGA result: {directory}')
    if meta.get('part') != part or meta.get('clock_period_ns') != clock or meta.get('board') != 'arty_a7_100':
        raise ValueError('F4PGA baseline part/clock/board mismatch')
    required = {'metrics.json', 'route.log', 'constraints.sdc', 'clock-aliases.json'} | {
        result_top(directory)+'.'+suffix for suffix in ['json', 'sdc', 'eblif', 'net', 'place', 'route', 'fasm', 'bit']}
    if meta['core'] == 'CVA5':
        required |= {'converted.v', 'converted.raw.v', 'frontend.ys', 'firmware.hex', 'conversion.log', 'sv2v-version.log'}
    if not required <= meta.get('artifacts_sha256', {}).keys():
        raise ValueError('Incomplete F4PGA artifact manifest')
    for name, digest in meta['artifacts_sha256'].items():
        if Path(name).is_absolute() or '..' in Path(name).parts:
            raise ValueError('Invalid artifact path')
        if sha(directory/name) != digest:
            raise ValueError(f'Changed result artifact: {name}')
    metrics = json.loads((directory/'metrics.json').read_text())
    if metrics != parse_results(directory):
        raise ValueError('F4PGA metrics do not match native reports')
    return metrics


def run(args):
    out = args.output.resolve()
    out.mkdir(parents=True, exist_ok=True)
    meta = dict(passed=False, status='preparing', tool='f4pga', core=args.core,
                part=args.part, board=args.board, clock_period_ns=args.clock_ns)
    # Never reuse stale success after failure; require a fresh implementation directory.
    previous = list(out.iterdir())
    write_json(out/'execution.json', meta)
    started = time.monotonic()
    try:
        if previous:
            raise ValueError('Output must be empty; use a new directory or explicit baseline reuse')
        if args.core not in TOPS or args.board != 'arty_a7_100' or args.part != PART or args.clock_ns != 50:
            raise ValueError('F4PGA currently supports VEX_5S/CVA5 on arty_a7_100, xc7a100tcsg324-1, 50 ns only')
        if args.core == 'CVA5' and not (args.firmware or args.coe):
            raise ValueError('CVA5 requires firmware (--firmware/--coe): an empty instruction ROM can optimize away the CPU')
        sources, hashes = prepare(args.rtl.resolve(), out, args.firmware, args.coe, args.core)
        meta['rtl_sha256'] = hashes
        meta['firmware_sha256'] = sha(out/'firmware.hex')
        meta['runner_sha256'] = sha(__file__)
        meta['fasm_driver_sha256'] = sha(HERE/'write_fasm.py')
        meta['adapter_sha256'] = {str(p): sha(p) for p in ([HERE/'ram.sv'] if args.core == 'VEX_5S' else [HERE/'cva5_ram.sv', HERE/'axi_uart.sv', HERE/'cva5_defaults.py', BOARD/'prepare_top.py', BOARD/'prepare_scaiev.py']) + [HERE/'board.xdc', BOARD/(TOPS[args.core]+'.sv')]}
        prefix = shlex.split(args.launcher) if args.launcher else []
        cmds = commands(sources, TOPS[args.core])
        meta.update(status='running', commands=[prefix+c for c in cmds], completed_steps=[])
        write_json(out/'execution.json', meta)
        env = dict(os.environ, FPGA_FAM='xc7')
        if args.env_script:
            # Fixed shell program: user path and commands are positional, never interpolated.
            prefix = ['bash', '-c', 'set -e; source "$1"; shift; exec "$@"', 'f4pga-env', str(args.env_script.resolve())] + prefix
        def invoke(cmd, log):
            remaining = args.timeout - (time.monotonic()-started)
            if remaining <= 0:
                raise TimeoutError('F4PGA time budget exhausted')
            with (out/log).open('w') as stream:
                subprocess.run(prefix+cmd, cwd=out, env=env, stdout=stream, stderr=subprocess.STDOUT,
                               timeout=remaining, check=True)
        meta['env_script'] = str(args.env_script) if args.env_script else None
        meta['env_script_sha256'] = sha(args.env_script) if args.env_script else None
        meta['commands'] = [prefix+c for c in cmds]
        # Retain versions from the same runtime as the six build steps.
        invoke(['yosys', '-V'], 'yosys-version.log')
        invoke(['vpr', '--version'], 'vpr-version.log')
        frontend = ('read_verilog -lib +/xilinx/cells_sim.v\n'
                    'read_verilog -lib +/xilinx/cells_xtra.v\n'
                    'read_verilog -sv '+ ' '.join(sources)+ '\n'
                    'hierarchy -check -top '+TOPS[args.core]+'\nproc\ncheck -assert\n')
        if args.core == 'CVA5':
            invoke([args.sv2v, '--version'], 'sv2v-version.log')
            conversion = [args.sv2v, '-DSYNTHESIS', '--top='+TOPS[args.core], '--write=converted.v', *sources]
            meta['conversion_command'] = prefix+conversion
            invoke(conversion, 'conversion.log')
            converted = out/'converted.v'
            shutil.copyfile(converted, out/'converted.raw.v')
            converted.write_text(normalize_constant_selects(converted.read_text()))
            frontend = frontend.replace(' '.join(sources), 'converted.v').replace('proc\ncheck', 'proc\nflatten\nopt\ncheck')
        (out/'frontend.ys').write_text(frontend)
        invoke(['yosys', '-s', 'frontend.ys', '-l', 'frontend.log'], 'frontend.stdout.log')
        meta['frontend_checked'] = True
        if args.core == 'CVA5':
            cmds = commands(['converted.v'], TOPS[args.core])
            meta['commands'] = [prefix+c for c in cmds]
        for step, cmd in zip(STEPS, cmds):
            invoke(cmd, step+'.stdout.log')
            if step == 'synth':
                deduplicate_sdc(out)
            if step == 'write_fasm':
                validate_fasm(out)
            meta['completed_steps'].append(step)
            write_json(out/'execution.json', meta)
        metrics = parse_results(out)
        write_json(out/'metrics.json', metrics)
        final_names = {'metrics.json', 'firmware.hex', 'board.xdc', 'frontend.ys', 'converted.v', 'converted.raw.v', 'constraints.sdc', 'clock-aliases.json'} | {
            result_top(out)+'.'+suffix for suffix in ['json', 'sdc', 'eblif', 'net', 'place', 'route', 'fasm', 'bit']}
        artifacts = [p for p in out.iterdir() if p.is_file() and (p.name in final_names or p.suffix == '.log')]
        artifacts += list((out/'rtl').iterdir())
        meta.pop('error', None)
        meta.update(passed=True, status='complete', setup_met=metrics['setup_met'], hold_met=metrics['hold_met'],
                    artifacts_sha256={str(p.relative_to(out)): sha(p) for p in artifacts})
    except (OSError, ValueError, KeyError, subprocess.SubprocessError) as exc:
        meta.update(passed=False, status='failed', error=str(exc))
    finally:
        meta['elapsed_seconds'] = time.monotonic()-started
        write_json(out/'execution.json', meta)
    if not meta['passed']:
        print(meta.get('error'), file=sys.stderr)
    return meta['passed']



def resume_routed(args):
    """Retry final conversion after revalidating a recorded, completed routed build."""
    out = args.output.resolve()
    meta = json.loads((out/'execution.json').read_text())
    previous = dict(meta)
    started = time.monotonic()
    try:
        if (meta.get('tool') != 'f4pga' or meta.get('core') != args.core or meta.get('part') != args.part
                or meta.get('board') != args.board or meta.get('clock_period_ns') != args.clock_ns
                or meta.get('completed_steps', [])[:4] != STEPS[:4] or not meta.get('frontend_checked')):
            raise ValueError('Resume requires a completed, matching F4PGA routed build')
        if 'VPR succeeded' not in (out/'route.log').read_text():
            raise ValueError('Native routing did not succeed')
        # Verify original RTL and board adapters before reusing physical implementation.
        for mapping in ['rtl_sha256', 'adapter_sha256']:
            for path, digest in meta[mapping].items():
                if sha(path) != digest:
                    raise ValueError('Changed routed-build input: '+path)
        if (sha(args.env_script) if args.env_script else None) != meta.get('env_script_sha256'):
            raise ValueError('Changed runtime environment; use a fresh build')
        if meta.get('passed'):
            validate(out, args.part, args.clock_ns)
        parse_results(out, require_bitstream=False)
        routed = [out/(result_top(out)+'.'+suffix) for suffix in ['json', 'sdc', 'eblif', 'net', 'place', 'route']]
        routed += [out/'constraints.sdc', out/'route.log', out/'firmware.hex', *[p for p in [out/'converted.v', out/'converted.raw.v'] if p.exists()], *list((out/'rtl').iterdir())]
        checkpoint = {str(p.relative_to(out)): sha(p) for p in routed if p.is_file()}
        # A resumed run pins its route; subsequent retries detect any changed checkpoint.
        if meta.get('routed_checkpoint_sha256') and meta['routed_checkpoint_sha256'] != checkpoint:
            raise ValueError('Changed routed checkpoint')
        write_json(out/'execution-before-resume.json', previous)
        meta.update(passed=False, status='resuming', resumed_from_route=True,
                    routed_checkpoint_sha256=checkpoint, finalizer_sha256=sha(__file__), fasm_driver_sha256=sha(HERE/'write_fasm.py'), completed_steps=STEPS[:4])
        write_json(out/'execution.json', meta)
        prefix = shlex.split(args.launcher) if args.launcher else []
        if args.env_script:
            prefix = ['bash', '-c', 'set -e; source "$1"; shift; exec "$@"', 'f4pga-env', str(args.env_script.resolve())]+prefix
        cmds = commands([], TOPS[args.core])[4:]
        meta['resume_commands'] = [prefix+c for c in cmds]
        for step, cmd in zip(STEPS[4:], cmds):
            # Archive failed conversion evidence and prevent stale outputs from passing checks.
            artifact = out/(result_top(out)+'.'+('fasm' if step == 'write_fasm' else 'bit'))
            if artifact.exists():
                shutil.copyfile(artifact, artifact.with_suffix(artifact.suffix+'.before-resume'))
                artifact.unlink()
            log = out/(step+'.resume.log')
            remaining = args.timeout-(time.monotonic()-started)
            if remaining <= 0:
                raise TimeoutError('F4PGA finalization time budget exhausted')
            with log.open('w') as stream:
                subprocess.run(prefix+cmd, cwd=out, env=dict(os.environ, FPGA_FAM='xc7'),
                               stdout=stream, stderr=subprocess.STDOUT, check=True, timeout=remaining)
            if not artifact.is_file() or not artifact.stat().st_size:
                raise ValueError('F4PGA conversion emitted an empty artifact: '+str(artifact))
            if step == 'write_fasm':
                validate_fasm(out)
            meta['completed_steps'].append(step)
            write_json(out/'execution.json', meta)
        metrics = parse_results(out)
        write_json(out/'metrics.json', metrics)
        names = {'metrics.json', 'firmware.hex', 'board.xdc', 'frontend.ys', 'converted.v', 'converted.raw.v', 'constraints.sdc',
                 'clock-aliases.json', 'execution-before-resume.json'} | {
                     result_top(out)+'.'+suffix for suffix in ['json','sdc','eblif','net','place','route','fasm','bit']}
        artifacts = [p for p in out.iterdir() if p.is_file() and (p.name in names or p.suffix == '.log')]
        artifacts += list((out/'rtl').iterdir())
        meta.pop('error', None)
        meta.update(passed=True, status='complete', setup_met=metrics['setup_met'], hold_met=metrics['hold_met'],
                    artifacts_sha256={str(p.relative_to(out)): sha(p) for p in artifacts})
    except (OSError, ValueError, KeyError, subprocess.SubprocessError) as exc:
        meta.update(passed=False, status='failed', error=str(exc))
        print(str(exc), file=sys.stderr)
    finally:
        meta['resume_elapsed_seconds'] = time.monotonic()-started
        write_json(out/'execution.json', meta)
    return meta['passed']


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('output', type=Path)
    p.add_argument('rtl', type=Path)
    p.add_argument('--resume-routed', action='store_true', help='Revalidate and reuse completed routing; retry FASM and bitstream only')
    p.add_argument('--core', default='VEX_5S')
    p.add_argument('--board', default='arty_a7_100')
    p.add_argument('--part', default=PART)
    p.add_argument('--clock-ns', type=float, default=50)
    p.add_argument('--timeout', type=float, default=7200)
    p.add_argument('--sv2v', default=os.environ.get('FPGA_SYN_F4PGA_SV2V') or 'sv2v', help='CVA5 SystemVerilog converter executable')
    p.add_argument('--launcher', default='', help='Argument prefix, e.g. conda run --no-capture-output -n f4pga')
    p.add_argument('--env-script', type=Path)
    p.add_argument('--firmware', type=Path)
    p.add_argument('--coe', type=Path)
    args = p.parse_args()
    if args.timeout <= 0 or not math.isfinite(args.timeout):
        p.error('timeout must be finite and positive')
    raise SystemExit(0 if (resume_routed(args) if args.resume_routed else run(args)) else 1)


if __name__ == '__main__':
    main()
