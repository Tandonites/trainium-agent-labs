"""Independent A–E feedback from visible checker measurements; no model calls."""
import argparse
import copy
import json
import pathlib
import re

import check_result
import taxonomy

STYLES = ('A', 'B', 'C', 'D', 'E')


class FrozenLookup:
    """Load one versioned, dev-attributed lesson set before an experiment starts."""
    def __init__(self, path):
        raw = pathlib.Path(path).read_text()
        data = json.loads(raw)
        if not data.get('version') or not data.get('development_tasks') or not isinstance(data.get('rules'), dict):
            raise ValueError('Lessons require a version, development_tasks, and a rules dictionary')
        if any(not isinstance(key, str) or ':' not in key or not isinstance(rule, str) or not rule.strip()
               for key, rule in data['rules'].items()):
            raise ValueError('Each lesson must map category:signature to nonempty text')
        self._data = copy.deepcopy(data)
        self._hash = check_result.digest(raw)

    def select(self, result):
        return taxonomy.select(None, ['generic'], result.get('signatures', []),
                               data={'signatures': {}}, knowledge=self._data['rules'], limit=2, max_bytes=1200)

    def audit(self):
        return dict(version=self._data['version'], sha256=self._hash,
                    development_tasks=list(self._data['development_tasks']),
                    provenance=self._data.get('provenance', ''))


def _values(values):
    return ', '.join(f'{name}={value}' for name, value in values.items()) or '(none)'


def _expected(expected):
    def text(value):
        if value['kind'] == 'exact':
            return value['value']
        if value['kind'] == 'hold':
            return 'hold ' + value['value']
        if value['kind'] == 'range':
            return f"integer {value['minimum']}..{value['maximum']}"
        if value['kind'] == 'defined':
            return 'defined bits (no X/Z)'
        raise ValueError('Unknown expected-output contract')
    return _values({name: text(value) for name, value in expected.items()})


def _examples(observations, limit):
    selected, seen = [], set()
    for row in observations:
        key = (tuple(row['failures']), row['kind'], tuple(row['checks']))
        if row['checked'] and row['failures'] and key not in seen:
            selected.append(row)
            seen.add(key)
            if len(selected) == limit:
                break
    return selected


def feedback_record(result, style, *, candidate_source=None, lookup=None, max_examples=3, preceding=3):
    """Return text plus the exact style/evidence/lesson identifiers for JSON logs.

    A=count, B=A+examples, C=B+preceding observations, D=C+source locations,
    E=C+lookup lessons. D and E are separate additions to C, not mixed together.
    Nothing is read from the legacy free-text feedback or the hidden test set.
    """
    if style not in STYLES:
        raise ValueError('style must be A, B, C, D, or E')
    if result.get('partition') != 'visible':
        raise ValueError('Only visible test results may enter repair feedback')
    if result['status'] in ('infrastructure_error', 'reference_error'):
        raise ValueError('Infrastructure/reference failures must be fixed before requesting a model repair')
    if max_examples < 1 or preceding < 0:
        raise ValueError('max_examples must be positive and preceding must be nonnegative')
    if lookup is not None and style != 'E':
        raise ValueError('Lookup lessons are permitted only in style E')
    if style == 'E' and lookup is None:
        raise ValueError('Style E requires an explicitly frozen lesson set')
    if style == 'D' and candidate_source is None:
        raise ValueError('Style D requires the exact candidate source')
    if candidate_source is not None and check_result.digest(candidate_source) != result['candidate_sha256']:
        raise ValueError('Candidate source does not match the checked version')
    audit = dict(style=style, candidate_sha256=result['candidate_sha256'],
                 samples_shown=[], source_lines=[], selected_rules=[], lookup=None)
    status = result['status']
    observations = result.get('observations', [])
    if observations:
        label = 'Passed' if result['passed'] else f'Failed ({status})'
        lines = [f"{label}: {result['mismatches']} output mismatches in {result['samples']} checked observations "
                 f"({result['output_checks']} output checks; {result['failed_samples']} observations failed)."]
    else:
        lines = [f'Failed ({status}); no complete simulation measurements.']
    examples = _examples(observations, max_examples) if style != 'A' else []
    audit['samples_shown'] = [row['sample'] for row in examples]
    if style != 'A':
        for error in result.get('port_errors', []):
            lines.append(f"Port {error['port']}: expected {error['expected']}; actual {error['actual']}.")
        if status == 'compile_error':
            # Source locations are reserved for D; B/C retain diagnostic messages.
            messages = [re.sub(r'^.*?:\d+(?::\d+)?:\s*', '', line)
                        for line in result.get('compiler_diagnostics', '').splitlines()]
            lines.extend(dict.fromkeys(messages[:6]))
        for row in examples:
            failed = row['failures']
            lines.append(f"Sample {row['sample']}, cycle {row['cycle']}, time {row['time_ns']} ns: "
                         f"inputs {_values(row['inputs'])}; "
                         f"expected {_expected({n: row['expected'][n] for n in failed})}; "
                         f"actual {_values({n: row['actual'][n] for n in failed})}.")
    if style in ('C', 'D', 'E') and examples:
        chosen = set()
        checked = [row for row in observations if row['checked']]
        positions = {row['sample']: i for i, row in enumerate(checked)}
        for row in examples:
            index = positions[row['sample']]
            chosen.update(x['sample'] for x in checked[max(0, index - preceding):index + 1])
        lines += ['Recent checked observations (binary values retain their widths):',
                  'sample | cycle | time ns | inputs | expected | actual']
        for row in checked:
            if row['sample'] in chosen:
                lines.append(f"{row['sample']} | {row['cycle']} | {row['time_ns']} | {_values(row['inputs'])} | "
                             f"{_expected(row['expected'])} | {_values(row['actual'])}")
        audit['trace_samples'] = sorted(chosen)
    if style == 'D' and not result['passed']:
        source_lines = candidate_source.splitlines()
        locations = result.get('source_locations', [])[:6]
        if not locations:
            lines.append('No supported candidate source location was identified.')
        for location in locations:
            number = location['line']
            if not 0 < number <= len(source_lines) or source_lines[number - 1] != location['text']:
                raise ValueError('Source location does not match the checked candidate')
            label = ('Compiler-reported location' if location['kind'] == 'compiler' else
                     f"Block that writes {location['output']} (inspection lead; cause unverified)")
            lines.append(f"{label}, line {number}: {location['text']}")
            audit['source_lines'].append(number)
    if style == 'E':
        audit['lookup'] = lookup.audit()
        audit['selected_rules'] = lookup.select(result) if not result['passed'] else []
        if audit['selected_rules']:
            lines.append('Reusable lessons from development tasks (suggested checks, not measured causes):')
            lines.extend(taxonomy.entry_text(entry) for entry in audit['selected_rules'])
    audit['text'] = '\n'.join(lines)
    return audit


def format_feedback(result, style, **options):
    """Return just the model-facing text; use feedback_record to retain its audit."""
    return feedback_record(result, style, **options)['text']


def main():
    import checker
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--problem', default='lfsr', help='prepared task when --spec is absent')
    parser.add_argument('--spec')
    parser.add_argument('--ref')
    parser.add_argument('--tb')
    parser.add_argument('--dut', required=True)
    parser.add_argument('--style', choices=STYLES, required=True)
    parser.add_argument('--output-dir', required=True, help='new evidence directory; must not exist')
    parser.add_argument('--rules', help='versioned lesson JSON; only permitted for E')
    args = parser.parse_args()
    if args.rules and args.style != 'E':
        parser.error('--rules is only permitted for style E')
    if args.style == 'E' and not args.rules:
        parser.error('style E requires --rules')
    # Freeze advice before checking; formatting A–D never loads a lookup table.
    lookup = FrozenLookup(args.rules) if args.style == 'E' else None
    problem = checker.load_problem(args.spec or checker._find_spec(args.problem), args.tb, args.ref)
    result = checker.check(problem, args.dut, work_dir=args.output_dir)
    if result['status'] in ('infrastructure_error', 'reference_error'):
        print(result['detail'])
        return 2
    record = feedback_record(result, args.style, candidate_source=pathlib.Path(args.dut).read_text(), lookup=lookup)
    (pathlib.Path(args.output_dir) / 'feedback.json').write_text(json.dumps(record, indent=2) + '\n')
    print(record['text'])
    return 0 if result['passed'] else 1


if __name__ == '__main__':
    raise SystemExit(main())
