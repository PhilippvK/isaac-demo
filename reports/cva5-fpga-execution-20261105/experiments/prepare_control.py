"""Publish issue-stage PC effects only when CVA5 can accept the instruction."""
import argparse
from pathlib import Path
p=argparse.ArgumentParser(description=__doc__);p.add_argument('source',type=Path);p.add_argument('output',type=Path);a=p.parse_args();s=a.source.read_text()
if 'input logic  WrPC_validReq_2_i' in s:
    old='if (WrPC_validReq_2_i) begin'
    if s.count(old)!=1:raise ValueError('Unexpected issue-stage PC redirect implementation')
    ready='!scaiev.issue_isStalling && !scaiev.issue_stall'
    s=s.replace(old,'if (WrPC_validReq_2_i && '+ready+') begin')
    old='assign scaiev.decode_flush = WrFlush_1_i;'
    if s.count(old)!=1:raise ValueError('Unexpected automatic PC-flush implementation')
    s=s.replace(old,'assign scaiev.decode_flush = WrFlush_1_i && '+ready+';')
a.output.parent.mkdir(parents=True,exist_ok=True);a.output.write_text(s)
