from pathlib import Path
import difflib
root=Path(__file__).resolve().parents[3];here=Path(__file__).resolve().parent
original=(here/'VexRiscv.original.java').read_text();updated=original
for node,stage in [('WrMem','memStageNum'),('WrMem_spawn','spawnStageNum')]:
 old='"                            dBusAccess.cmd.data := io." +\n                       language.CreateNodeName(BNode.'+node+', stages['+stage+'], "") + "\\n"'
 new='"                            dBusAccess.cmd.data := " +\n                       formatStoreData("io." + language.CreateNodeName(BNode.'+node+', stages['+stage+'], "")) + "\\n"'
 assert updated.count(old)==1,(node,'Unexpected backend source')
 updated=updated.replace(old,new)
helper='''
  // DBusSimpleBus expects replicated subword data, as native stores provide.
  private String formatStoreData(String value) {
    String byteValue = value + "(7 downto 0)";
    String halfValue = value + "(15 downto 0)";
    return "dBusAccess.cmd.size.mux(\\n"
        + "                                U(0) -> (" + byteValue + " ## " + byteValue + " ## " + byteValue + " ## " + byteValue + "),\\n"
        + "                                U(1) -> (" + halfValue + " ## " + halfValue + "),\\n"
        + "                                default -> " + value + "\\n"
        + "                            )";
  }
'''
end=updated.rfind('}');assert end>=0;updated=updated[:end]+helper+updated[end:]
(here/'VexRiscv.fixed.java').write_text(updated)
path='src/scaiev/backend/VexRiscv.java'
patch=''.join(difflib.unified_diff(original.splitlines(True),updated.splitlines(True),fromfile='a/'+path,tofile='b/'+path))
(root/'cfg/hls/patches/scaiev-vex-subword-stores.patch').write_text(patch)
print('Prepared source patch:',len(patch),'bytes')
