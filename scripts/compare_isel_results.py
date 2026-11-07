"""Compare measured instruction counts and ISE utilization in retraced sessions."""
import argparse
import json
from pathlib import Path
import pandas as pd


def summarize(session):
    table = session / 'table'
    dynamic = pd.read_pickle(table / 'dynamic_counts_custom.pkl')
    static = pd.read_pickle(table / 'static_counts_custom.pkl')
    histogram = pd.read_pickle(table / 'instrs_hist.pkl')
    definitions = pd.read_pickle(table / 'ise_instrs.pkl')
    # Utilization tables include an aggregate row; never sum it twice.
    dynamic = dynamic[dynamic['instr'].notna()].fillna(0)
    static = static[static['instr'].notna()].fillna(0)
    counts = {str(name).lower(): 0 for name in definitions['instr_lower']}
    counts.update({str(row['instr']).lower(): int(row['count']) for _, row in dynamic.iterrows()})
    return {
        'session': str(session),
        'selector': json.loads((session / 'instruction-selector.json').read_text()),
        'trace_instructions': int(histogram['count'].sum()),
        'custom_executions': int(dynamic['count'].sum()),
        'custom_static_sites': int(static['count'].sum()),
        'emitted_ises': len(definitions),
        'utilized_ises': sum(value > 0 for value in counts.values()),
        'per_ise_executions': counts,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--dag', type=Path, required=True)
    parser.add_argument('--gisel', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    dag, gisel = summarize(args.dag), summarize(args.gisel)
    if dag['selector']['global_isel'] or not gisel['selector']['global_isel']:
        raise ValueError('Session selector metadata does not match comparison roles')
    metrics = ('trace_instructions', 'custom_executions', 'custom_static_sites', 'utilized_ises')
    result = {'dag': dag, 'gisel': gisel,
              'gisel_minus_dag': {key: gisel[key] - dag[key] for key in metrics},
              'note': 'Measured retrace utilization; instruction counts are not cycle estimates.'}
    args.output.write_text(json.dumps(result, indent=2) + '\n')


if __name__ == '__main__':
    main()
