#!/usr/bin/env python3
"""Retain validated F4PGA results and bitstreams beyond disposable work dirs."""
import argparse
import hashlib
import json
from pathlib import Path
import shutil

from run import validate


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--metrics', type=Path, required=True)
    p.add_argument('--output', type=Path, required=True)
    for variant in ['baseline', 'default', 'shared']:
        p.add_argument('--'+variant+'-dir', type=Path)
    args = p.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(args.metrics, args.output/'metrics.csv')
    manifest = {}
    for variant in ['baseline', 'default', 'shared']:
        source = getattr(args, variant+'_dir')
        if source is None:
            continue
        validate(source)
        meta = json.loads((source/'execution.json').read_text())
        target = args.output/variant
        target.mkdir(exist_ok=True)
        # All checksummed outputs are required for portable cache revalidation.
        for name in [*meta['artifacts_sha256'], 'execution.json']:
            src, dst = source/name, target/name
            dst.parent.mkdir(parents=True, exist_ok=True)
            if src.resolve() != dst.resolve():
                shutil.copyfile(src, dst)
        manifest[variant] = {str(f.relative_to(target)): hashlib.sha256(f.read_bytes()).hexdigest()
                             for f in target.rglob('*') if f.is_file()}
    (args.output/'manifest.json').write_text(json.dumps(manifest, indent=2)+'\n')


if __name__ == '__main__':
    main()
