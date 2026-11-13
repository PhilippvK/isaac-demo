"""Build serial-selected, volatile-only Arty programming commands."""
import re


def command(programmer, bitstream, serial, vivado, script, openfpgaloader='openFPGALoader'):
    if not re.fullmatch(r'[A-Za-z0-9_-]+', serial):
        raise ValueError('Invalid board serial')
    if programmer == 'openfpgaloader':
        # No -f/--write-flash: SRAM configuration only. Never select the first cable.
        return [openfpgaloader, '-b', 'arty_a7_100t', '--usb-serial-num', serial, str(bitstream)]
    if programmer == 'vivado':
        return [vivado, '-mode', 'batch', '-source', str(script), '-tclargs', serial, str(bitstream)]
    raise ValueError(f'Unsupported programmer: {programmer}')
