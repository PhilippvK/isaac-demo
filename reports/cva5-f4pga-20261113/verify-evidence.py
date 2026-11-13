#!/usr/bin/env python3
"""Verify every checksummed member without extracting large native archives."""
import hashlib
import json
from pathlib import Path
import sys
import tarfile


def verify(path):
    expected = None
    seen = set()
    with tarfile.open(path, 'r|gz') as archive:
        for member in archive:
            name = Path(member.name)
            if not member.isfile() or name.is_absolute() or '..' in name.parts:
                raise ValueError('Unexpected archive member: '+member.name)
            relative = str(Path(*name.parts[1:]))
            stream = archive.extractfile(member)
            if relative == 'execution.json':
                meta = json.load(stream)
                if not meta['passed'] or meta['status'] != 'complete':
                    raise ValueError('Archive is not a completed implementation')
                expected = meta['artifacts_sha256']
                continue
            if expected is None or relative not in expected:
                raise ValueError('Unlisted archive member: '+member.name)
            digest = hashlib.sha256()
            for block in iter(lambda: stream.read(1024*1024), b''):
                digest.update(block)
            if digest.hexdigest() != expected[relative]:
                raise ValueError('Changed archive member: '+member.name)
            seen.add(relative)
    if expected is None or seen != expected.keys():
        raise ValueError('Incomplete archive')
    digest = hashlib.sha256()
    with Path(path).open('rb') as stream:
        for block in iter(lambda: stream.read(1024*1024), b''):
            digest.update(block)
    return dict(archive=Path(path).name, sha256=digest.hexdigest(), checked_artifacts=len(seen))


if __name__ == '__main__':
    for argument in sys.argv[1:]:
        print(json.dumps(verify(argument)))
