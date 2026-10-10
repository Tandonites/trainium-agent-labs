# Generic Markdown experiments

## Measurement API and feedback contract

The new entry points are independent of the model client:

```python
import checker
import feedback

problem = checker.load_problem("prompts/specs/LFSR.md",
    "TestBench/lfsr_tb.v", "verilog/reference/lfsr.v")
result = checker.check(problem, "candidate.v", work_dir="runs/check-001",
                       partition="visible", finish_reason="stop")
record = feedback.feedback_record(result, "C")
text_for_model = record["text"]
# Save record with the runner's attempt log. format_feedback() returns text only.
```

`work_dir` must be new. Separate calls use separate build files and can run
concurrently. Each directory preserves the exact candidate, assembled public
specification, supplied reference/testbench copies, generated probe, compiler and
simulator stdout/stderr, and `result.json`. The manifest records input and checker
source hashes. This single-file interface does not package external include-file
dependencies; supply self-contained task files.

`result` is a JSON object. Its principal fields are:

| Field | Meaning |
| --- | --- |
| `status`, `passed`, `compiled` | Acceptance and compilation results, kept separate. |
| `port_errors` | Expected versus elaborated names, directions, and widths. Missing ports may instead prevent compilation. |
| `samples`, `passed_samples`, `failed_samples` | Checked observations, including between-edge reset checks. An observation is not always a new clock cycle. |
| `output_checks`, `mismatches`, `passed_output_checks` | Output/observation pairs. Two wrong outputs at one observation count as two mismatches and one failed sample. |
| `observations` | Every observation: sample index, cycle, time in ns, input bits including clock/reset, expected constraints, actual bits, failed output names, and check categories. |
| `weighted_score` | Sean's legacy sum of passing category weights; **not** a passed-cycle percentage. |
| `source_locations` | Compiler-named candidate lines or output-driving blocks, bound to the candidate hash. Driver locations are investigation leads, not measured root causes. |
| `signatures`, `category_checks` | Failure categories for optional lesson selection and analysis. |

Expected values retain their widths. Unknown actual bits remain X/Z. Dice-style
contracts retain `defined`, `range`, or `hold` expectations rather than inventing
one correct random output. Setup observations that have no scored check category
remain in the trace with `checked=false` and are excluded from counts.

Failure statuses distinguish invalid candidates, truncated responses, port errors,
compile errors/timeouts, simulation errors/timeouts, incomplete simulation,
functional mismatch, official-testbench failure, reference errors, and infrastructure
errors. Simulator nonzero exits and ERROR/FATAL/FAIL messages cannot produce a pass.
The probe requires every expected observation exactly once and one completion
record. Port validation reads Icarus 12's elaborated VVP metadata; unavailable or
unrecognized metadata stops checking. Signedness is not represented in the current
task-port schema. No synthesis or formal-correctness claim is made.

The legacy `grade()` return value remains `(weighted_score, feedback_text)`.
Both APIs receive the acceptance fixes. The original testbench and the generated
probe are visible checks here; this interface does not create a hidden test set.
For a final verdict, supply a separately frozen problem/test plan to `check()` with
`partition="hidden"`. Every feedback style rejects results carrying that label.
Hidden evaluation must run only after the runner has selected its final candidate.

| Style | Model-facing evidence |
| --- | --- |
| A | Status and complete mismatch totals. |
| B | A plus up to three representative failing observations. |
| C | B plus up to three preceding checked observations for each example. |
| D | C plus compiler locations or output-driver lines. Pass `candidate_source=...`; stale source is rejected. |
| E | C plus at most two lessons from an explicitly supplied `FrozenLookup`. |

The limits are explicit `max_examples` and `preceding` arguments. These are
deterministic evidence selections, not a tokenizer-based context limit. The runner
must keep the specification and candidate intact and count the assembled prompt
with Qwen's tokenizer before sending it. D and E are separate additions to C so
line pointers and reusable lessons can be compared independently.

For E, construct `lookup = feedback.FrozenLookup("feedback_rules.json")` before
the experiment and pass it to `feedback_record`. The file must declare its version,
development tasks, and rules. The lookup keeps a frozen copy; file edits do not
change subsequent feedback. The returned record includes the rules selected,
version, hash, and development-task attribution. LFSR and sequence generator must
remain development tasks for the included reset rules. A–D never retrieve lessons
and reject a supplied lookup. No experiments establish that E improves repairs yet.

The returned feedback record also lists the sample and source-line identifiers
shown. It does not modify the checker result or silently mix in the legacy feedback.
Infrastructure and reference errors are refused as repair feedback.

Run all CPU-only tests with:

```sh
python -m unittest discover -s tests -v
```

The new tests exercise exact interfaces, real simulation timeout, failed processes,
incomplete/duplicate reports, multi-output counts, X/Z preservation, hidden-result
rejection, stale source, immutable lessons, concurrency, and the offline CLI.

## Existing runner

Run the four prepared tasks (LFSR, sequence generator, traffic light, dice roller):

```sh
python checker.py --run-all --mode agent --repeat 1 --rounds 6
```

The Python runner in `checker.py` reads `experiments/md_generic_v4_dynamic_taxonomy.json`; adding another
spec/reference pair to its task list requires no new checker or agent code.
Optional arguments include `--only traffic_light dice_roller`, `--model MODEL`,
`--base-url URL`, `--repeat`, `--rounds`, and `--seed`.

Reference files and their public behavior clarifications are in
`verilog/reference/`. Generated attempts are saved under `candidates/gen/`.
The model sees the Markdown, interface, public clarifications, current feedback,
and retrieved rules. It never sees reference Verilog or reference output values.

For a new Markdown file:

```sh
python agent.py --spec my_design.md --ref my_reference.v --principles-v2 --explain
python checker.py --spec my_design.md --ref my_reference.v --dut candidate.v --detectors --principles
```

An independent reference is needed to grade behavior. A same-stem reference beside
the spec, in its `reference/` folder, or in `verilog/reference/` is discovered
without `--ref`. An optional same-stem `TestBench/NAME_tb.v` is also discovered;
`--tb FILE` overrides it. Without a testbench, simple ANSI or classic reference
ports supply the interface. Complex/parameterized interfaces need an explicit
compatible testbench. Clock and reset are recognized by conventional signal
names. Designs without a reset or clock also use the shared stimulus engine.

Reference-adjacent JSON may supply `async_reset`, a public `spec_addendum`, and
`comparisons` for outputs with nondeterministic behavior. These are problem data.
Sequence behavior A is preserved: reset shows AF; the first enabled edge produces
BC. Traffic light enable pauses both phase and elapsed time. Dice grading checks
selected-die bounds, defined reset output, and output hold between sampled roll
edges, rather than requiring a particular PRNG sequence. Randomness quality and
uniformity are not measured by the range/hold contract or the official dice TB.

The generic stimulus includes 256 active edges, 128 seeded random cycles, low/high
holds of every stimulus input, and resets held across edges. `--cycles`,
`--random-cycles`, and `--seed` are configurable. Inputs change only with the clock
low; all outputs settle for one ns after each rising edge before being sampled.
The official testbench gates a perfect score whenever one is available.

## Dynamic taxonomy retrieval

`--principles` uses `taxonomy.json` definitions and `knowledge.json` rules; `--principles-v2` also enables
output-pattern detectors. The suite enables retrieval, detectors, and explanations
by default. `--taxonomy FILE` selects category and signature definitions;
`--knowledge FILE` selects the rule cache. Flat category:signature JSON also remains supported.

Each iteration takes fresh snapshots of both JSON files. Categories are matched
using whole-word, case-insensitive taxonomy keywords/phrases, port hints, and declared priority order. Current checker signatures select only matching
`category:signature` entries, falling back to `generic:signature` and
`*:signature`. Only principles for current fired signatures are included by default.
`--show-detect-text` also includes the signature name and taxonomy detection text.
Signatures with no principle are skipped without consuming a selection slot. At most two
selected entries and 1200 retrieval bytes enter the next prompt, respecting the
lookup limit declared in your taxonomy.
`--rules-limit`, `--rule-bytes`, and repeatable `--category` options control this.
Editing either JSON during a run affects the next iteration. Rule text and
category keyword lists are never hardcoded into the prompt. A description for an
unimplemented detector does not execute a new detector automatically.
`--exclude-categories lfsr,sequence_gen` excludes those rules when desired;
`kb_hits` records the actual rule keys selected for each round.

Only the latest attempt and its current feedback enter the prompt. The full
specification is retained; long feedback and previous code are shortened to fit.
The default 8000-token context reserves 1500 generation tokens and 512 chat-overhead
tokens. Remaining UTF-8 bytes conservatively bound byte-token prompt length, so
no tokenizer dependency is required. `--context-tokens` and `--max-tokens` adjust
these budgets. A specification that cannot fit produces an explicit error.

## Distinct logs for this update

Suite logs go to `log/runs/md_generic_v4_dynamic_taxonomy_TIMESTAMP/`:

- `run.json`: manifest, paths, arguments, seed, and suite version.
- `NAME.log`: exact command, console output, and errors for each task.
- Per-agent `.jsonl`: flushed after every iteration, including full generated
  code, prompt, feedback, score, diagnostics, selected rule keys and text,
  taxonomy and knowledge snapshot hashes, `kb_hits`, timing, context budget, and
  official verdict.
- `summary.json`: exit status and duration for completed tasks, updated as the
  suite progresses.

`log/history/md_generic_v4_dynamic_taxonomy_UPDATE.json` records implementation changes;
no experiment or test execution is represented by that update record.

To run the checker on the prepared references without model requests:

```sh
python checker.py --run-all --mode checker
```

To grade your own four files (`lfsr.v`, `sequence_generator.v`, `traffic_light.v`,
`dice_roller.v`), use `--run-all --mode checker --dut-dir YOUR_FOLDER`.
All individual and batch orchestration is in `checker.py`; no extra runner is needed.

An individual official testbench can run without a Markdown spec or reference:

```sh
python checker.py --run-tb --tb TestBench/lfsr_tb.v --dut verilog/reference/lfsr.v
```

`--tb FILE --dut FILE` alone also selects this operation. Results are reported
without printing private expected values.

The legacy `python checker.py` LFSR regression entry point and
`baseline_lfsr.txt` remain. Its historical feedback uses `principles.json`;
Markdown experiment runs retrieve the new taxonomy dynamically.


## Prompt ownership and regression evidence

All model-facing text, spec/interface formatting, taxonomy retrieval, context
budgeting, response extraction, and historical prompt layouts live in `checker.py`.
`agent.py` calls `checker.build_prompt`, sends the messages, calls
`checker.extract` and `checker.grade`, and records the results. The existing
request/reply/round JSONL event layout is preserved.

The API is `build_prompt(problem, history, explain=False, show_code=True)`.
`prompt_problem(problem, spec=..., **options)` attaches checker options for
principles, taxonomy/knowledge files, context limits, hints, and interface
formatting. History can contain round records (including diagnostics) or
`(code, score, feedback)` tuples. Archived layouts preserve earlier experiment
wording, including the earlier-feedback ledger and repeat nudge; current runs
use their bounded layout with principle-only retrieval by default.

`prompts/regression/before/` and `prompts/regression/after/` contain independently constructed messages
for all four recorded flag conditions, plus recorded sequence-generator,
ledger, and repeat-nudge cases. Historical JSONL files remain in the old workspace archive. Snapshots include the pre-refactor source and frozen taxonomy data;
`prompt_regression.py after` replays the historical cases with detector text
enabled to preserve the original regression evidence; new runs default to principles alone.

`--interface-from-tb` is optional and defaults off. It regenerates the interface
line from the named testbench instantiation while preserving existing default
text. Show both versions with:

```sh
python checker.py --show-interface-lines
```

`log/history/prompt_refactor_regression.json`, `log/history/prompt_owner_tests.log`, and
`log/history/lfsr_after_prompt_refactor.txt` record the comparisons and verification.


## Plain result logs and required files

See `README.md` for the file checklist and single-run commands. The project lives
in `/workspace/sean-work`. Bundled specifications live in `prompts/specs/`,
actual model requests in `prompts/runs/`, and historical snapshots in
`prompts/regression/`. Old root spec names remain accepted as aliases.

Each run writes plain console output to `log/NAME.log` (for example, `log/lfsr.log`),
without a command or timestamp header. This file is replaced on the next run for
that problem. Full JSONL events and timestamped batch metadata remain separate
so results from earlier runs can be examined. `--log-dir` changes the destination;
`--no-console-log` disables the console copy.

To compare every knowledge key, including complete before/after text, place the
original at `knowledge_original.json` and run:

```sh
python checker.py --knowledge-report
```

The report prints both full MD5 hashes and whether the original begins with
`a38ea61b`. Neither input JSON file is modified. A missing original is reported
explicitly; it is not treated as an empty or identical dictionary.
