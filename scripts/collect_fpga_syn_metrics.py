"""Collect native Vivado or validated F4PGA metrics with explicit backend identity."""
import argparse
import importlib.util
from pathlib import Path

import pandas as pd


def load_f4pga():
    spec = importlib.util.spec_from_file_location('f4pga_runner', Path(__file__).parent/'fpga_syn/f4pga/run.py')
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def collect(directory, tool='vivado', part=None, clock=None):
    if tool in ('f4pga', 'symbiflow'):
        runner = load_f4pga()
        data = runner.validate(directory, part or runner.PART, clock if clock is not None else 50)
        data.pop('primitive_counts', None)
        for metric in ('luts', 'ffs', 'brams', 'dsps'):
            for component in ('isax', 'scaiev'):
                # The native F4PGA netlist is flattened: do not fabricate component counts.
                data[f'{metric}_{component}'] = None
        return dict(data, tool='f4pga', part=part or runner.PART, clock_period_ns=clock if clock is not None else 50)
    if (directory/'execution.json').exists():
        import json
        meta = json.loads((directory/'execution.json').read_text())
        if meta.get('tool') in ('f4pga', 'symbiflow'):
            raise ValueError('F4PGA result cannot be used as a Vivado baseline')
    frame = pd.read_csv(directory/'reports/utilization_hier_impl_summary.csv')
    result = dict(tool='vivado', part=part, clock_period_ns=clock)
    for component, name in [('total', '(top)'), ('isax', 'ISAX_XIsaac'), ('scaiev', 'SCAL')]:
        rows = frame[frame['Module'] == name]
        if len(rows) > 1 or (component == 'total' and len(rows) != 1):
            raise ValueError(f'Expected a unique {name} utilization row')
        for metric, columns in [('luts', ['Total LUTs']), ('ffs', ['FFs']),
                                ('brams', ['RAMB18', 'RAMB36']), ('dsps', ['DSP Blocks'])]:
            result[f'{metric}_{component}'] = rows[columns].iloc[0].sum() if len(rows) else None
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('-o', '--output', '--out')
    parser.add_argument('--fmt', choices=['auto', 'csv', 'pkl', 'md'], default='auto')
    parser.add_argument('--print-df', action='store_true')
    for variant in ['baseline', 'default', 'shared']:
        parser.add_argument(f'--{variant}-dir', type=Path)
    parser.add_argument('--expected-tool', choices=['vivado', 'f4pga', 'symbiflow'], default='vivado')
    parser.add_argument('--expected-part')
    parser.add_argument('--expected-clock-ns', type=float)
    args = parser.parse_args()
    data = []
    for variant in ['baseline', 'default', 'shared']:
        directory = getattr(args, variant+'_dir')
        if directory is not None:
            data.append(dict(variant=variant, **collect(directory, args.expected_tool, args.expected_part, args.expected_clock_ns)))
    if not data:
        parser.error('At least one variant is required')
    df = pd.DataFrame(data)
    if any(row['variant'] != 'baseline' for row in data):
        for metric in ['luts', 'ffs', 'brams', 'dsps']:
            for component in ['isax', 'scaiev']:
                df[f'{metric}_{component}_rel'] = pd.to_numeric(df[f'{metric}_{component}']) / df[f'{metric}_total'].replace(0, float('nan'))
    if data[0]['variant'] == 'baseline' and len(data) > 1:
        for component in ['total', 'isax', 'scaiev']:
            for metric in ['luts', 'ffs', 'brams', 'dsps']:
                key = f'{metric}_{component}'
                df[f'{key}_overhead'] = pd.to_numeric(df[key]) - (data[0].get(key) or 0)
    if args.print_df:
        with pd.option_context('display.max_columns', None):
            print(df)
    if args.output:
        path = Path(args.output)
        fmt = path.suffix[1:].lower() if args.fmt == 'auto' else args.fmt
        if fmt == 'csv':
            df.to_csv(path, index=False)
        elif fmt == 'pkl':
            df.to_pickle(path)
        elif fmt == 'md':
            df.to_markdown(path, index=False)
        else:
            parser.error(f'Unsupported format: {fmt}')
    elif not args.print_df:
        parser.error('--output or --print-df is required')


if __name__ == '__main__':
    main()
