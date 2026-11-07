"""Extract LLVM20/21 Jammy compiler packages locally; do not install system-wide."""
from pathlib import Path
import gzip, hashlib, json, subprocess, urllib.request
root = Path(__file__).resolve().parent / 'compat-compilers'
root.mkdir(exist_ok=True)
manifest = []
for major in (20, 21):
    base = 'https://apt.llvm.org/jammy/'
    url = base + f'dists/llvm-toolchain-jammy-{major}/main/binary-amd64/Packages.gz'
    index = urllib.request.urlopen(url, timeout=60).read()
    packages = {}
    for stanza in gzip.decompress(index).decode().split('\n\n'):
        fields = {}
        for line in stanza.splitlines():
            if line and not line.startswith(' ') and ': ' in line:
                key, value = line.split(': ', 1)
                fields[key] = value
        if 'Package' in fields:
            packages[fields['Package']] = fields
    dest = root / str(major)
    dest.mkdir(exist_ok=True)
    for name in (f'clang-{major}', f'libclang-cpp{major}', f'libllvm{major}', f'libclang-common-{major}-dev', f'libclang1-{major}'):
        fields = packages[name]
        deb = root / Path(fields['Filename']).name
        if not deb.exists():
            urllib.request.urlretrieve(base + fields['Filename'], deb)
        digest = hashlib.sha256(deb.read_bytes()).hexdigest()
        assert digest == fields['SHA256'], name
        subprocess.run(['dpkg-deb', '-x', str(deb), str(dest)], check=True)
        manifest.append(dict(package=name, version=fields['Version'], url=base + fields['Filename'], sha256=digest, depends=fields.get('Depends')))
        print(name, fields['Version'], flush=True)
(root / 'packages.json').write_text(json.dumps(manifest, indent=2))
