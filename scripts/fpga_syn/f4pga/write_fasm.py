#!/usr/bin/env python3
"""Export routed FASM with explicit clocks and corrected XC7 mux metadata."""
import hashlib
import json
from pathlib import Path
import shlex
import shutil
import subprocess
import xml.etree.ElementTree as ET

OLD = 'BDI1MUX_ROUTING.DI1 = ALUT.DI1MUX.BDI1_BMC31,BLUT.DI1MUX.DI_CMC31'
NEW = 'BDI1MUX_ROUTING.DI1 = ALUT.DI1MUX.BDI1_BMC31'


def structural_xml(text):
    root = ET.fromstring(text)
    for parent in root.iter():
        for child in list(parent):
            if child.tag == 'metadata':
                parent.remove(child)
    return ET.tostring(root)


def patch_architecture(text):
    """BDI1MUX itself selects DI/BI; ADI1MUX must not force its choice."""
    if text.count(OLD) == 1:
        patched = text.replace(OLD, NEW, 1)
        if structural_xml(text) != structural_xml(patched):
            raise ValueError('FASM compatibility fix changed architecture structure')
        return patched, True
    if OLD not in text and text.count(NEW) == 1:
        return text, False
    raise ValueError('Unrecognized XC7 ADI1MUX FASM metadata; refusing an unverified patch')


def check_packed_architecture(path, digest):
    with Path(path).open('rb') as stream:
        _, root = next(ET.iterparse(stream, events=('start',)))
        identity = root.get('architecture_id')
    if identity != 'SHA256:'+digest:
        raise ValueError('Installed architecture does not match the routed packed netlist')
    return identity


def main():
    # Use the pinned wrapper's device/options resolution, then invoke genfasm
    # directly so failures propagate and its SDC is actually forwarded.
    from f4pga.wrappers.sh import p_vpr_env_from_args
    env = p_vpr_env_from_args('fasm')
    original = Path(env['ARCH_DEF'])
    text = original.read_text()
    original_digest = hashlib.sha256(text.encode()).hexdigest()
    packed_identity = check_packed_architecture(Path(env['EBLIF']).with_suffix('.net'), original_digest)
    patched, applied = patch_architecture(text)
    local = Path('arch-genfasm.xml')
    local.write_text(patched)
    command = [shutil.which('genfasm') or 'genfasm', str(local), env['EBLIF'],
               '--device', env['DEVICE_NAME'], *shlex.split(env['VPR_OPTIONS']),
               '--read_rr_graph', env['RR_GRAPH'], '--sdc_file', env['SDC'],
               '--verify_file_digests', 'off']
    # The original packed-netlist architecture digest includes FASM metadata.
    # Only that metadata changed; structural equivalence is checked above and
    # the backend independently pins the routed checkpoint and input hashes.
    provenance = dict(original=str(original), original_sha256=original_digest, packed_architecture_id=packed_identity,
                      patched_sha256=hashlib.sha256(patched.encode()).hexdigest(),
                      metadata_fix_applied=applied, structural_xml_unchanged=True,
                      removed_redundant_feature='BLUT.DI1MUX.DI_CMC31 on ADI1MUX forwarding BDI1MUX',
                      command=command)
    Path('fasm-architecture.json').write_text(json.dumps(provenance, indent=2)+'\n')
    subprocess.run(command, env=env, check=True)
    Path('vpr_stdout.log').replace('fasm.log')
    top = Path(env['EBLIF']).stem
    extra = Path(top+'_fasm_extra.fasm')
    if extra.exists():
        with Path(top+'.fasm').open('ab') as stream:
            stream.write(extra.read_bytes())


if __name__ == '__main__':
    main()
