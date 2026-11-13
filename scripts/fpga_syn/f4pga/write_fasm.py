#!/usr/bin/env python3
"""Pass the effective SDC to genfasm through F4PGA's supported Python API.

The console wrapper parses -s but does not forward it to genfasm. Its explicit
extra-arguments API avoids falling back to the duplicate-alias native SDC.
"""
from f4pga.wrappers.sh import write_fasm

write_fasm(genfasm_extra_args=['--sdc_file', 'constraints.sdc'])
