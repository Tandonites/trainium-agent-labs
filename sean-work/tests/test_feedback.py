"""Real Icarus checks plus failure injection; never contacts a model endpoint."""
import concurrent.futures
import copy
import json
import pathlib
import subprocess
import tempfile
import unittest
from unittest import mock

import checker
import feedback

ROOT = pathlib.Path(checker.__file__).resolve().parent


class FeedbackTests(unittest.TestCase):
    def setUp(self):
        self.temp = pathlib.Path(self.enterContext(tempfile.TemporaryDirectory()))
        self.enterContext(mock.patch.object(checker, 'BUILD', self.temp))
        self.problem = checker.load_problem(ROOT / 'prompts/specs/LFSR.md',
            ROOT / 'TestBench/lfsr_tb.v', ROOT / 'verilog/reference/lfsr.v')
        self.good = (ROOT / 'verilog/reference/lfsr.v').read_text()
        self.bad = (ROOT / 'candidates/bad/lfsr_syncreset.v').read_text()
        self.counter = 0

    def check(self, source=None, problem=None, **kwargs):
        self.counter += 1
        source = self.good if source is None else source
        candidate = self.temp / f'input-{self.counter}.v'
        candidate.write_text(source)
        return checker.check(problem or self.problem, candidate,
                             work_dir=self.temp / f'result-{self.counter}', **kwargs)

    def inject_simulation(self, change, official=False):
        run = subprocess.run
        def patched(command, **kwargs):
            result = run(command, **kwargs)
            if command[0] == 'vvp' and str(command[1]).endswith('_official.vvp' if official else '_probe.vvp'):
                change(result)
            return result
        return mock.patch.object(checker.subprocess, 'run', side_effect=patched)

    def test_four_references_pass_and_preserve_full_measurements(self):
        tasks = json.loads((ROOT / 'experiments/md_generic_v4_dynamic_taxonomy.json').read_text())['tasks']
        for entry in tasks:
            with self.subTest(task=entry['name']):
                p = checker.load_problem(ROOT / entry['spec'], ROOT / entry['tb'], ROOT / entry['ref'])
                result = self.check((ROOT / entry['ref']).read_text(), p)
                self.assertEqual(result['status'], 'pass')
                self.assertEqual(result['mismatches'], 0)
                self.assertGreater(result['samples'], 0)
                self.assertEqual(result['passed_samples'], result['samples'])
                self.assertEqual(json.loads((pathlib.Path(result['evidence_dir']) / 'result.json').read_text()), result)
                if entry['name'] == 'dice_roller':
                    self.assertIn('range', {r['expected']['rolled_number']['kind'] for r in result['observations']})
                    self.assertIn('defined', {r['expected']['rolled_number']['kind'] for r in result['observations']})

    def test_port_widths_extra_ports_and_resolved_parameters(self):
        for source in (self.good.replace('input  clk,', 'input [1:0] clk,'),
                       self.good.replace('output reg [7:0] data', 'output reg [8:0] data'),
                       self.good.replace('input  clk,', 'input spare, input clk,')):
            with self.subTest(source=source[:75]):
                result = self.check(source)
                self.assertEqual(result['status'], 'port_error')
                self.assertTrue(result['compiled'])
                self.assertTrue(result['port_errors'])
                self.assertFalse(result['passed'])
        parameterized = self.good.replace('module lfsr (', 'module lfsr #(parameter WIDTH=8) (')
        parameterized = parameterized.replace('[7:0] data', '[WIDTH-1:0] data')
        self.assertTrue(self.check(parameterized)['passed'])

    def test_different_port_direction_is_rejected(self):
        source = 'module lfsr(input clk, input reset_n, inout [7:0] data); assign data=8\'h8a; endmodule'
        result = self.check(source)
        self.assertEqual(result['status'], 'port_error')
        self.assertEqual(result['port_errors'][0]['actual']['direction'], 'inout')

    def test_actual_mismatch_totals_and_reset_pins(self):
        result = self.check(self.bad)
        bad = [row for row in result['observations'] if row['failures']]
        self.assertEqual(result['mismatches'], 4)
        self.assertEqual(result['failed_samples'], len(bad))
        self.assertEqual(result['passed_samples'] + len(bad), result['samples'])
        self.assertEqual(bad[0]['expected']['data']['value'], '10001010')
        self.assertEqual(bad[0]['actual']['data'], 'xxxxxxxx')
        self.assertEqual(bad[0]['inputs'], {'clk': '0', 'reset_n': '0'})
        self.assertEqual(result['category_checks']['reset_immediate'], False)

    def test_multiple_outputs_count_separately_and_keep_xz(self):
        spec = self.temp / 'pair.md'
        spec.write_text('Two-bit input a. Output y copies a; output z is its parity. Combinational.')
        ref = self.temp / 'pair.v'
        ref.write_text('module pair(input [1:0] a, output [1:0] y, output z); assign y=a; assign z=^a; endmodule')
        p = checker.load_problem(spec, ref=ref, cycles=4, random_cycles=3)
        bad = "module pair(input [1:0] a, output [1:0] y, output z); assign y=2'bxx; assign z=1'bz; endmodule"
        result = self.check(bad, p)
        self.assertEqual(result['mismatches'], result['samples'] * 2)
        self.assertEqual(result['failed_samples'], result['samples'])
        self.assertEqual(result['observations'][0]['actual'], {'y': 'xx', 'z': 'z'})
        self.assertIn('z=z', feedback.format_feedback(result, 'B'))

    def test_nonzero_simulator_exit_and_error_text_cannot_pass(self):
        for change in (lambda r: setattr(r, 'returncode', 1),
                       lambda r: setattr(r, 'stderr', 'FATAL: injected process failure\n'),
                       lambda r: setattr(r, 'stdout', r.stdout + 'ERROR: injected assertion\n')):
            with self.inject_simulation(change):
                result = self.check()
            self.assertEqual(result['status'], 'simulation_error')
            self.assertFalse(result['passed'])

    def test_official_nonzero_exit_and_stderr_cannot_pass(self):
        for change in (lambda r: setattr(r, 'returncode', 1),
                       lambda r: setattr(r, 'stderr', 'FATAL: injected official failure\n')):
            with self.inject_simulation(change, official=True):
                result = self.check()
            self.assertEqual(result['status'], 'official_failure')
            self.assertFalse(result['passed'])

    def test_missing_duplicate_and_bad_completion_are_rejected(self):
        transforms = [lambda s: '\n'.join(line for line in s.splitlines() if not line.startswith('CHECKER_DONE')),
                      lambda s: s + next(line for line in s.splitlines() if line.startswith('P ')) + '\n',
                      lambda s: s.replace('P 0 ', 'P 999999 '),
                      lambda s: s + 'CHECKER_DONE 0\n']
        for transform in transforms:
            with self.inject_simulation(lambda r: setattr(r, 'stdout', transform(r.stdout))):
                result = self.check()
            self.assertEqual(result['status'], 'incomplete_simulation')

    def test_compile_errors_locations_and_timeouts(self):
        source = self.good.replace("data <= 8'b10001010;", 'data <= ;')
        result = self.check(source)
        self.assertEqual(result['status'], 'compile_error')
        self.assertFalse(result['compiled'])
        record = feedback.feedback_record(result, 'D', candidate_source=source)
        self.assertIn('Compiler-reported location', record['text'])
        self.assertTrue(record['source_lines'])
        with mock.patch.object(checker.subprocess, 'run', side_effect=subprocess.TimeoutExpired('iverilog', 1, stderr=b'partial diagnostic')):
            result = self.check()
        self.assertEqual(result['status'], 'compile_timeout')
        self.assertEqual((pathlib.Path(result['evidence_dir']) / 'candidate_compile.stderr').read_text(), 'partial diagnostic')

    def test_real_simulation_timeout(self):
        source = self.good.replace('endmodule', 'initial forever begin #0; end\nendmodule')
        result = self.check(source, timeout=.2)
        self.assertEqual(result['status'], 'simulation_timeout')

    def test_infrastructure_errors_are_not_model_failures(self):
        with mock.patch.object(checker.subprocess, 'run', side_effect=FileNotFoundError('missing iverilog')):
            result = self.check()
        self.assertEqual(result['status'], 'infrastructure_error')
        with self.assertRaises(ValueError):
            feedback.format_feedback(result, 'A')

    def test_candidate_cannot_print_scores_or_terminate_simulator(self):
        for command in ('$display("P 0 00000000");', '$finish;', '$fatal(1);'):
            source = self.good.replace('endmodule', 'initial begin ' + command + ' end\nendmodule')
            result = self.check(source)
            self.assertEqual(result['status'], 'invalid_candidate')

    def test_truncated_response_is_not_scored_even_if_module_looks_complete(self):
        with mock.patch.object(checker, 'grade', side_effect=AssertionError('must not score truncation')):
            result = self.check(finish_reason='length')
        self.assertEqual(result['status'], 'truncated')

    def test_feedback_styles_are_separate_and_do_not_mutate_results(self):
        result = self.check(self.bad)
        before = copy.deepcopy(result)
        with mock.patch.object(feedback.taxonomy, 'select', side_effect=AssertionError('A-D must not retrieve lessons')):
            a, b, c, d = [feedback.format_feedback(result, style, candidate_source=self.bad) for style in 'ABCD']
        self.assertEqual(len(a.splitlines()), 1)
        self.assertNotIn('10001010', a)
        self.assertIn('expected data=10001010', b)
        self.assertNotIn('sample | cycle', b)
        self.assertTrue(c.startswith(b))
        self.assertIn('sample | cycle', c)
        self.assertNotIn('Block that writes', c)
        self.assertTrue(d.startswith(c))
        self.assertIn('cause unverified', d)
        self.assertEqual(result, before)

    def test_hidden_results_and_stale_source_never_enter_feedback(self):
        result = self.check(self.bad, partition='hidden')
        for style in 'ABCDE':
            with self.assertRaises(ValueError):
                feedback.format_feedback(result, style, candidate_source=self.bad)
        result['partition'] = 'visible'
        with self.assertRaises(ValueError):
            feedback.format_feedback(result, 'D', candidate_source=self.bad + '\n')
        with self.assertRaises(ValueError):
            feedback.format_feedback(result, 'D')

    def test_e_uses_frozen_dev_rules_only(self):
        result = self.check(self.bad)
        path = self.temp / 'rules.json'
        path.write_bytes((ROOT / 'feedback_rules.json').read_bytes())
        lookup = feedback.FrozenLookup(path)
        before = lookup.audit()
        path.write_text('{}')
        record = feedback.feedback_record(result, 'E', lookup=lookup)
        self.assertTrue(record['text'].startswith(feedback.format_feedback(result, 'C')))
        self.assertIn('Principle:', record['text'])
        self.assertLessEqual(len(record['selected_rules']), 2)
        self.assertEqual(record['lookup'], before)
        self.assertEqual(record['source_lines'], [])
        with self.assertRaises(ValueError):
            feedback.format_feedback(result, 'A', lookup=lookup)
        with self.assertRaises(ValueError):
            feedback.format_feedback(result, 'E')
        with self.assertRaises(ValueError):
            feedback.FrozenLookup(ROOT / 'knowledge.json')  # no dev-only provenance contract

    def test_work_directories_are_unique_and_checks_can_run_in_parallel(self):
        candidate = self.temp / 'parallel.v'
        candidate.write_text(self.good)
        def run(index):
            return checker.check(self.problem, candidate, work_dir=self.temp / f'parallel-{index}')
        with concurrent.futures.ThreadPoolExecutor(2) as pool:
            results = list(pool.map(run, (0, 1)))
        self.assertTrue(all(r['passed'] for r in results))
        with self.assertRaises(FileExistsError):
            run(0)

    def test_cli_produces_check_and_feedback_artifacts_without_generation(self):
        output = self.temp / 'cli'
        p = subprocess.run([__import__('sys').executable, str(ROOT / 'feedback.py'),
                            '--problem', 'lfsr', '--dut', str(ROOT / 'candidates/bad/lfsr_syncreset.v'),
                            '--style', 'C', '--output-dir', str(output)],
                           cwd=self.temp, capture_output=True, text=True, timeout=20)
        self.assertEqual(p.returncode, 1, p.stderr)
        self.assertIn('expected data=', p.stdout)
        self.assertEqual(json.loads((output / 'feedback.json').read_text())['style'], 'C')
        self.assertEqual(json.loads((output / 'result.json').read_text())['status'], 'functional_mismatch')


if __name__ == '__main__':
    unittest.main()
