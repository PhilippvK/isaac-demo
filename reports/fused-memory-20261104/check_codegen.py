from pathlib import Path
import json,re,subprocess

root=Path(__file__).resolve().parent
tools=root/'compiler/llvm_install/bin'
rows=json.loads((root/'runtime-cases.json').read_text())['functions']
dump=(root/'memory-tests.dump').read_text()
functions={name:body for name,body in re.findall(r'^[0-9a-f]+ <([^>]+)>:\n(.*?)(?=\n[0-9a-f]+ <|\Z)',dump,re.M|re.S)}
results=[]
for row in rows:
    mnemonic=row['name'].lower()
    selected=functions['selected_'+row['name']]
    native=functions['native_'+row['name']]
    assert selected.count(mnemonic+'\t')==1,(mnemonic,selected)
    assert not re.search(r'\bmem_\w+',native),native
    results.append(dict(instruction=row['name'],selected=True,
                        selected_instructions=len(selected.strip().splitlines()),
                        native_instructions=len(native.strip().splitlines())))
subprocess.run([str(tools/'clang'),'--target=riscv32','-march=rv32im_xmem','-mabi=ilp32',
                '-O2','-ffreestanding','-fno-builtin','-S','-mllvm','-global-isel=1',
                '-mllvm','-global-isel-abort=1','-DFUNC(x)=gisel_##x',str(root/'selected.c'),'-o',str(root/'gisel.s')],check=True)
for row in rows:
    assert row['name'].lower()+'\t' in (root/'gisel.s').read_text()
for row in rows:
    assert row['name']+'_' in (root/'compiler/RISCVGenGlobalISel.inc').read_text()
(root/'codegen-results.json').write_text(json.dumps({'all_selected':True,'gisel_imported':True,'instructions':results},indent=2)+'\n')
print('All',len(results),'memory ISEs selected from C; all imported and selected with GlobalISel.')
