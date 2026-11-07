"""Summarize actual board implementation artifacts and their provenance."""
import csv
import hashlib
import json
import re
from pathlib import Path
root = Path(__file__).resolve().parent
repo = root.parent.parent
rows = []
for variant in ['baseline', 'crc32-scaiev2-final', 'memory-cva5-final', 'branches-fixed', 'store-probes']:
    d = root / 'builds' / variant
    util = d / 'reports/utilization_impl.rpt'
    timing = d / 'reports/timing_summary.rpt'
    if not util.exists() or not timing.exists():
        continue
    text = util.read_text()
    def used(label):
        match = re.search(r'^\|\s*' + re.escape(label) + r'\s*\|\s*([\d.]+)', text, re.M)
        if not match:
            raise ValueError(f'{label} missing from {util}')
        return float(match[1])
    tt = timing.read_text()
    m = re.search(r'WNS\(ns\).*?\n\s*[- ]+\n\s*([-\d.]+)\s+([-\d.]+)', tt)
    if not m:
        raise ValueError(f'Timing not found in {timing}')
    core_timing = re.search(r'^\s*clk20_raw\s+([-\d.]+)\s+([-\d.]+)\s+\d+', tt, re.M)
    if not core_timing: raise ValueError(f'Core timing missing: {timing}')
    bit = d / 'cva5_arty_top.bit'
    row = dict(variant=variant, LUTs=used('Slice LUTs'), FFs=used('Slice Registers'), BRAM_tiles=used('Block RAM Tile'), DSPs=used('DSPs'), IOBs=used('Bonded IOB'), WNS_ns=float(m[1]), TNS_ns=float(m[2]), core_WNS_ns=float(core_timing[1]), timing_met='All user specified timing constraints are met.' in tt, bitstream=bit.exists())
    rows.append(row)
with (root / 'results.csv').open('w') as f:
    writer = csv.DictWriter(f, fieldnames=list(rows[0]) if rows else ['variant'])
    writer.writeheader(); writer.writerows(rows)
(root / 'results.json').write_text(json.dumps(rows, indent=2) + '\n')
files = [repo / 'scripts/fpga_syn_script.sh', repo / 'scripts/fpga_syn/my_vivado_script.tcl', repo / 'cfg/flow/paper/cva5_reuseio.env', repo / 'cfg/fpga/boards/arty_a7_100.json']
files += sorted((repo / 'scripts/fpga_syn/boards/arty_a7_100').glob('*'))
for d in (root / 'builds').iterdir():
    if not d.is_dir(): continue
    bit = d / 'cva5_arty_top.bit'
    if bit.exists(): files.append(bit)
    old_list = repo / 'reports/cva5-fpga-20261105' / d.name / 'files.txt'
    if old_list.exists(): files += [Path(p) for p in old_list.read_text().splitlines()]
manifest = {str(f.relative_to(repo)): hashlib.sha256(f.read_bytes()).hexdigest() for f in files}
(root / 'sha256.json').write_text(json.dumps(manifest, indent=2) + '\n')
print(json.dumps(rows, indent=2))
