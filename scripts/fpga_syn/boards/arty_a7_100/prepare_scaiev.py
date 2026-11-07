"""Honor ISAAC's native-memory funct3 contract in CVA5 injected accesses."""
import argparse
from pathlib import Path
p=argparse.ArgumentParser(description=__doc__);p.add_argument('source',type=Path);p.add_argument('output',type=Path);a=p.parse_args()
s=a.source.read_text();old='assign ls_inputs_scaiev.fn3 = LS_W_fn3; //Full word'
if s.count(old)!=1:raise ValueError('Expected CVA5 word-only injected-memory assignment exactly once')
s=s.replace(old,'''// ISAAC scaiev2 allocation preserves the source memory funct3.
    // This selects byte/halfword lanes and load signedness just like native LS.
    assign ls_inputs_scaiev.fn3 = scaiev.execute_injectLS_potentiallyValid
        ? scaiev.execute_Instr[14:12] : scaiev_inputs.instruction[14:12];''')
a.output.parent.mkdir(parents=True,exist_ok=True);a.output.write_text(s)
