"""Extract comparable Vivado totals; retain raw reports as authority."""
import csv
import hashlib
import json
import re
from pathlib import Path

root = Path(__file__).resolve().parent
variants = ['baseline', 'crc32-scaiev2-final', 'memory-cva5-final', 'branches-fixed', 'store-probes']
rows = []
provenance = {}
for variant in variants:
    directory = root / variant
    sources = (directory / 'files.txt').read_text().splitlines()
    provenance[variant] = {str(Path(f).relative_to(root.parent.parent)): hashlib.sha256(Path(f).read_bytes()).hexdigest() for f in sources}
    for stage in ['synth', 'impl']:
        util = directory / 'reports' / f'utilization_{stage}.rpt'
        timing = directory / 'reports' / f'timing_{stage}.rpt'
        if not util.exists() or not timing.exists():
            continue
        text = util.read_text()
        def used(label):
            match = re.search(r'^\|\s*' + re.escape(label) + r'\s*\|\s*([\d.]+)', text, re.M)
            return float(match[1]) if match else None
        tt = timing.read_text()
        match = re.search(r'WNS\(ns\).*?\n\s*[- ]+\n\s*([-\d.]+)\s+([-\d.]+)\s+(\d+).*?\s+([-\d.]+)\s+([-\d.]+)', tt)
        row = dict(variant=variant, stage=stage, LUTs=used('Slice LUTs*') if stage == 'synth' else used('Slice LUTs'), FFs=used('Slice Registers'), BRAM_tiles=used('Block RAM Tile'), DSPs=used('DSPs'))
        if match:
            row.update(WNS_ns=float(match[1]), TNS_ns=float(match[2]))
        else:
            raise ValueError(f'Cannot parse timing summary: {timing}')
        rows.append(row)
(root / 'source-sha256.json').write_text(json.dumps(provenance, indent=2) + '\n')
(root / 'results.json').write_text(json.dumps(rows, indent=2) + '\n')
with (root / 'results.csv').open('w') as handle:
    writer = csv.DictWriter(handle, fieldnames=list(rows[0]))
    writer.writeheader()
    writer.writerows(rows)
print(json.dumps(rows, indent=2))
