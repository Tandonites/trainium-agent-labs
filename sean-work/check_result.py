"""Measurements shared by the checker and independent feedback writers.

Port metadata comes from Icarus 12's elaborated VVP, so parameters and classic
port declarations are resolved by the same compiler that runs the design.
Unknown metadata fails closed instead of accepting an unverified interface.
"""
import hashlib
import pathlib
import re


def digest(source):
    return hashlib.sha256(source.encode()).hexdigest()


def candidate_error(source, module):
    text = re.sub(r'/\*.*?\*/|//[^\n]*', '', source, flags=re.S)
    if re.search(r'\$(?:finish|stop|fatal|error|display|write|monitor|strobe|fopen|system)\b', text):
        return 'The candidate contains simulator control or reporting tasks.'
    if re.findall(r'\bmodule\s+(\w+)', text) != [module] or not re.search(r'\bendmodule\b', text):
        return f'Expected one complete module named {module}.'
    return None


def port_errors(executable, ports, module):
    scopes, current = {}, None
    for line in pathlib.Path(executable).read_text().splitlines():
        match = re.match(r'(\S+) \.scope (\w+), "([^"]+)" "([^"]+)"(.*);', line)
        if match:
            identifier, kind, name, definition, tail = match.groups()
            parent = re.search(r', (S_\w+)$', tail)
            current = dict(kind=kind, name=name, definition=definition,
                           parent=parent[1] if parent else None, ports={})
            scopes[identifier] = current
        match = re.match(r'\s*\.port_info \d+ /(INPUT|OUTPUT|INOUT) (\d+) "([^"]+)";', line)
        if match and current is not None:
            direction, width, name = match.groups()
            if name in current['ports']:
                raise ValueError('Duplicate Icarus port metadata')
            current['ports'][name] = dict(direction=direction.lower(), width=int(width))
    candidates = [s for s in scopes.values() if s['kind'] == 'module' and s['name'] == 'dut'
                  and s['definition'] == module
                  and scopes.get(s['parent'], {}).get('name') == 'probe']
    if len(candidates) != 1 or not candidates[0]['ports']:
        raise ValueError('Cannot verify the DUT interface from Icarus VVP port metadata')
    actual = candidates[0]['ports']
    expected = {name: dict(direction=direction, width=width) for name, direction, width in ports}
    return [dict(port=name, expected=expected.get(name), actual=actual.get(name))
            for name in sorted(expected.keys() | actual.keys()) if expected.get(name) != actual.get(name)]


def failed_process(process):
    return process.returncode != 0 or bool(re.search(
        r'^\s*(?:ERROR|FATAL|FAIL(?:ED|URE)?)(?=\s|:|$)',
        process.stdout + '\n' + process.stderr, re.M | re.I))


def save_process(directory, name, process):
    for stream in ('stdout', 'stderr'):
        value = getattr(process, stream, '') or ''
        if isinstance(value, bytes):
            value = value.decode(errors='replace')
        (pathlib.Path(directory) / f'{name}.{stream}').write_text(value)


def compiler_locations(stderr, candidate, source):
    lines, found = source.splitlines(), []
    pattern = re.compile(re.escape(str(candidate)) + r':(\d+)(?::\d+)?:\s*(.*)')
    for match in pattern.finditer(stderr):
        number = int(match[1])
        if 0 < number <= len(lines):
            item = dict(line=number, text=lines[number - 1], kind='compiler', detail=match[2])
            if item not in found:
                found.append(item)
    return found


def expectation(contract, want, width, sample, previous, previous_sample):
    """A range contract has no single golden value; never invent one for feedback."""
    if not contract:
        return dict(kind='exact', value=f'{want:0{width}b}')
    if sample['kind'] in ('initial_value', 'initial_immediate', 'reset') and contract.get('reset') == 'defined':
        return dict(kind='defined')
    trigger = contract.get('trigger')
    triggered = True
    if trigger:
        old = (previous_sample['inputs'].get(trigger['input'], 0) if previous_sample and
               previous_sample['kind'] not in ('initial_value', 'initial_immediate', 'reset') else 0)
        new = sample['inputs'].get(trigger['input'], 0)
        triggered = bool(new) and (trigger.get('edge') != 'rising' or not old)
    if not triggered and contract.get('hold_outside_trigger'):
        return dict(kind='hold', value=previous)
    if contract['kind'] == 'range':
        low, high = contract['ranges'][str(sample['inputs'][contract['selector']])]
        return dict(kind='range', minimum=low, maximum=high)
    raise ValueError(f'Unsupported output contract: {contract}')


def observation(sample, index, outputs, rows, ref_rows, problem, previous_sample):
    actual = rows[index]
    expected = {}
    for name, width in outputs:
        want = ref_rows[index][name] if problem.get('ref_verilog') else sample['want'][name]
        expected[name] = expectation(problem.get('comparisons', {}).get(name), want, width,
                                     sample, rows.get(index - 1, {}).get(name, ''), previous_sample)
    return dict(sample=index, cycle=sample['edge'], time_ns=sample['time'],
                kind=sample['kind'], checked=bool(sample['checks']),
                checks=list(sample['checks']), inputs=sample['pin_inputs'],
                expected=expected, actual=actual, failures=[])


def totals(result):
    rows = [row for row in result['observations'] if row['checked']]
    result.update(samples=len(rows), output_checks=sum(len(row['actual']) for row in rows),
                  mismatches=sum(len(row['failures']) for row in rows),
                  failed_samples=sum(bool(row['failures']) for row in rows))
    result['passed_samples'] = result['samples'] - result['failed_samples']
    result['passed_output_checks'] = result['output_checks'] - result['mismatches']


def source_locations(result, source, facts):
    lines = source.splitlines()
    failed_outputs = {name for row in result['observations'] for name in row['failures']}
    locations = []
    for name in sorted(failed_outputs):
        for block in facts.get(name, {}).get('blocks', []):
            number = block['line']
            if 0 < number <= len(lines):
                locations.append(dict(line=number, text=lines[number - 1], output=name,
                                      kind='driver', detail='Output-driving block; cause of failure is unverified.'))
    result['source_locations'] = locations
