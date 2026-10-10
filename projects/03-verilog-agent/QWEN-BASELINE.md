# Qwen baseline abilities and hackathon implications

Evidence reviewed on October 10, 2026. Model: **Qwen3-8B**.

Publication note: this commit contains the report. The linked `runs/` evidence
archives and `AGENTS.md` are retained in the local experiment checkout; those
relative links are not available in this document-only GitHub publication.

**Qwen can write some small circuits correctly, but its first answer is unreliable even on basic tasks.** It passed both counter tasks and the eight-bit shift register. It failed the bit counter, binary-to-BCD converter, four-bit shift register, and both sequence detectors. The failures include wrong arithmetic, lost bits, incorrect interfaces, wrong reset timing, and code that does not compile.

For our hackathon, this supports building a program that checks Qwen's answer and gives it useful evidence for another attempt. We already have one successful example of that: feedback helped Qwen fix the bit counter. We have not yet shown that compact memory improves results.

“Understanding” here means what Qwen demonstrated through answers and tested code. These tests cannot tell us exactly what the model knows internally.

## What the first Verilog answers achieved

Both experiments used one fresh answer per task, without testbench code, reference code, a prior model answer, or repair feedback. Examples already included in the task specification stayed in the prompt. Settings were temperature 0, top-p 1, seed 0, thinking disabled, and at most 2500 output tokens within an 8000-token cap. Qwen ran on Trainium; Icarus Verilog 12 compiled and simulated the circuits on the CPU.

### Five original VerilogEval tasks

**2 of 5 tasks passed. All five compiled.** “Wrong checks” counts incorrect observations of a generated circuit, not separate model attempts.

| Task | First answer | Wrong checks | What the code demonstrated |
| --- | --- | --- | --- |
| Count the ones in three input bits (`Prob009_popcount3`) | Failed tests | 59 / 220 | It got the odd/even bit right, but only counted some combinations containing two ones correctly. For example, `011` should produce 2 but produces 0. |
| Count repeatedly from 1 to 10 (`Prob035_count1to10`) | Passed tests | 0 / 439 | It implemented the reset value, increment, and return from 10 to 1 correctly for the tested inputs. |
| Two-bit counter that stops at its limits (`Prob075_counter_2bc`) | Passed tests | 0 / 1051 | It handled increasing, decreasing, enable, reset, and the upper/lower limits for the tested inputs. |
| Four-bit shift register with loading (`Prob085_shift4`) | Failed tests | 81 / 427 | It made the input and output one bit wide instead of four, and shifted in the wrong direction. |
| Detect `1101` and keep the flag on (`Prob096_review2015_fsmseq`) | Failed tests | 175 / 643 | It searched for `1111` instead, and used an immediate reset instead of the specified reset at a clock edge. |

Source: [five-task summary](../../runs/verilog-oneshot-20261010T155559.456475Z/summary.json), with each original response and candidate in that run folder.

### Three separately selected GUIDE tasks

**1 of 3 tasks passed. Two compiled; the detector did not.** These used separately clarified specifications and scoring adapters. Their scores stay separate from the original five-task experiment.

| Task | First answer | Wrong checks | What the code demonstrated |
| --- | --- | --- | --- |
| Convert 0–31 into two decimal digits stored in binary (`BinaryToBCD5`) | Failed tests | 22 / 32 | It used binary masking and shifting where decimal remainder and division were needed, and gave each digit the wrong width. Input 10 produced `0x0a` instead of `0x10`. |
| Detect eight ordered three-bit values (`SequenceDetector`) | Did not compile | Not simulated | It listed the correct target sequence, but used a constant-array declaration rejected by Icarus. Its remaining logic also loses history bits, compares the wrong bits, and sets the detection flag incorrectly. |
| Eight-bit shift register (`ShiftRegister8`) | Passed tests | 0 / 8 | It followed the specified shift direction, hold behavior, and reset in the tested cases. |

Source: [GUIDE summary](../../runs/verilog-oneshot-20261010T162234.717156Z/summary.json). Rechecking the unchanged candidates on the AWS CPU produced [the same outcomes](../../runs/verilog-oneshot-20261010T162234.717156Z/aws-replay/summary.json).

The largest complete prompt plus answer in either baseline was **830 tokens**. Every baseline answer ended normally, rather than being cut off. These particular failures happened well below our context limit.

## What additional tests tell us

### More tests of the same GUIDE answers

Separate hidden tests checked the saved candidates without asking Qwen for new answers or showing it the hidden inputs.

| Saved candidate | Additional result |
| --- | --- |
| Binary-to-BCD | 1408 wrong observations out of 2048. |
| Eight-value sequence detector | Still failed compilation. |
| Eight-bit shift register | Passed all 372 observations. |

Sources: [BCD replay](../../runs/verilog-hidden-eval-20261010T163726.156034Z/summary.json), [detector replay](../../runs/verilog-hidden-eval-20261010T163726.159258Z/summary.json), and [shift replay](../../runs/verilog-hidden-eval-20261010T163726.156214Z/summary.json).

This strengthens the evidence for this particular eight-bit shift implementation. It does not establish that Qwen reliably writes every shift register: its four-bit version failed a different contract.

### Questions about BCD and arithmetic

Five later diagnostic requests separated explaining a concept from writing working code. They are additional conditions, not replacements for the baseline.

| Question or condition | Result | What we can infer |
| --- | --- | --- |
| Give seven packed-BCD encodings without a further definition | 0 / 7 correct | It returned character encodings for decimal text instead of packed BCD, despite describing the correct digit arrangement. |
| Calculate masking, shifting, decimal remainder, and decimal division | 16 / 18 checks correct | The requested decimal remainder/division values were correct, but two shift results were wrong. Its arithmetic answers were inconsistent. |
| Explain digit widths and concatenation | 3 / 3 numeric checks correct | It identified four bits per BCD digit and the original ten-bit concatenation. Its prose explanation was inconsistent. |
| Give the same seven encodings after an explicit digit-by-digit definition | 7 / 7 correct | The added definition helped it produce the requested examples. |
| Generate the converter with that added definition | Failed 24 / 32 inputs | It still substituted division by 8 and remainder modulo 16 for decimal division and remainder. Correct examples did not translate into correct code. |

Sources: [initial BCD diagnosis](../../runs/bcd-diagnosis-20261010T163459.170405Z/summary.json) and [clarification experiment](../../runs/bcd-clarification-20261010T164000.684613Z/summary.json).

The original BCD generation prompt already specified the tens and ones nibbles and included `10 becomes 8'h10` and `31 becomes 8'h31`. The failure therefore occurred despite an explicit definition and examples; it does not establish that the model has no knowledge of BCD. [Original request](../../runs/verilog-oneshot-20261010T162234.717156Z/BinaryToBCD5/request.json).

An independent audit read all 32 inputs from the saved waveforms and compared their outputs with decimal arithmetic and the simulator logs. The original code passed only inputs 0–9, where ordinary binary and packed BCD agree. The clarified generation passed only 0–7. Representative observations are:

| Decimal input | Expected packed BCD | Original Qwen code | Qwen code with clarification |
| --- | --- | --- | --- |
| 9 | `0x09` | `0x09` | `0x19` |
| 10 | `0x10` | `0x0a` | `0x1a` |
| 16 | `0x16` | `0x30` | `0x20` |
| 31 | `0x31` | `0x3f` | `0x3f` |

The original `binary_input & 9'b11111` keeps the five-bit input unchanged, while `binary_input >> 4` divides by 16. Its two five-bit digit wires produce a ten-bit concatenation, placing the tens field at bit 5 before truncation to eight bits. In the clarified generation, `[3:0]` computes remainder modulo 16 and `[4:3]` computes division by 8. Its two-bit tens field can represent the required values 0–3; the remaining failure is the incorrect digit extraction, not necessarily that smaller tens width.

| Human-controlled diagnostic copy | Correct inputs out of 32 |
| --- | --- |
| Original logic replayed | 10 |
| Decimal division/remainder fixed, original widths retained | 10 |
| Four-bit digit widths used, original arithmetic retained | 10 |
| Both decimal arithmetic and digit widths fixed | 32 |

These counts confirm that fixing only one of the original fault types was insufficient in the tested copies. The audit verified the original candidate's saved hash, matching generation settings, normal completion, and matching AWS replay results. It made no new model or simulator requests. This is evidence from single responses per condition, not proof that clarification generally makes performance worse. [Waveform audit and source hashes](../../runs/bcd-evidence-review-20261010T165301.170043Z/summary.json).

A separate human diagnostic copy of the sequence detector replaced only the rejected constant representation; its unchanged detection logic then missed the real match at cycle 8 and falsely reported a match at cycle 12. These edits locate faults; **they are not Qwen repairs or improved baseline scores**. [Sequence diagnosis](../../runs/sequence-diagnosis-20261010T163613.567275Z/diagnosis.json).

### Qwen repairs of the three-bit counter

The original failed bit counter was reused in two repair pilots. Each pilot compared feedback about the current failure with feedback plus bounded history, allowing up to three repair requests per condition.

| Pilot | Current failure feedback | Feedback with history |
| --- | --- | --- |
| Initial feedback format | Failed all three repairs: 170, 92, then 92 wrong checks out of 220. | Failed all three repairs: 170, 170, then 119 wrong checks out of 220. |
| Revised feedback with explicit binary values and passing examples | Passed 220 / 220 checks after one repair. | Passed 220 / 220 checks after one repair. |

The baseline had 59 wrong checks, so the first pilot initially made the circuit worse. The revised pilot shows that Qwen **can** produce a correct tested repair when given clearer evidence. The two successful requests were identical and used no history; they do not demonstrate a memory benefit. No matched independent-retry comparison has established how much of the improvement comes specifically from feedback.

Sources: [initial repair pilot](../../runs/verilog-repair-20261010T162909.634763Z/summary.json) and [revised repair pilot](../../runs/verilog-repair-20261010T163253.055553Z/summary.json).

## Earlier heat-equation experiments

These math experiments used **four candidate answers per round**, calculator help when requested, and later failure feedback. Their results measure the whole assisted process, rather than one unaided answer. The saved log contains 48 final candidate answers across six problems.

| Problem | Task in plain language | Accepted answers in the first round | Final result |
| --- | --- | --- | --- |
| `level0.1` | One temperature wave on a rod | 4 / 4 | Solved in the first round. |
| `level0.2` | One wave with a different rod length and heat rate | 1 / 4 | Solved in the first round by selecting the passing answer. |
| `level0.3` | Several temperature waves together | 1 / 4 | Solved in the first round by selecting the passing answer. |
| `level1.1` | One wave with an insulated end | 1 / 4 | Solved in the first round by selecting the passing answer. |
| `level1.2` | Several waves with an insulated end | 0 / 4 | Not solved after four rounds; best checker reward was 0.6. |
| `level1.3` | A curved starting temperature requiring several waves | 0 / 4 | Solved in the fourth round; all four final answers passed. |

The harder run finished with **2 of 3 problems solved**, not the six-problem success shown in the starter README's example transcript. A partial checker reward such as 0.6 is not a percentage of mathematical correctness.

Sources retrieved from our assigned `seat-122`: [archived attempt log](../../runs/qwen-evidence-review-20261010T164914.767659Z/attempts.jsonl), [harder-run output](../../runs/qwen-evidence-review-20261010T164914.767659Z/run.log), and [per-problem summary](../../runs/qwen-evidence-review-20261010T164914.767659Z/heat-rod-summary.json).

The logs show useful answers alongside wrong equations and answers the checker could not accept. Calculator use, selection, and feedback help in some cases, but do not guarantee success.

## Assessment of baseline ability

| Ability | Assessment supported by these tests |
| --- | --- |
| Write a small working circuit from English | Demonstrated for the two counters and the eight-bit shift register; unreliable across the selected tasks. |
| Preserve every interface and timing requirement | Unreliable. The four-bit shift register lost port widths, and the `1101` detector used the wrong reset timing. |
| Turn arithmetic requirements into code | Unreliable. Both BCD generations used incorrect operations, even after clarification. |
| Track an ordered sequence | Not demonstrated successfully. Both sequence-detector tasks failed. |
| Explain a rule and apply it consistently | Inconsistent. Correct BCD examples and some correct width answers coexisted with broken HDL. |
| Improve after test feedback | Demonstrated on one circuit after revised feedback, and in the assisted heat-equation process. Earlier repairs also regressed. |
| Benefit from compact memory | Not established. The successful circuit repairs did not use history. |

The pattern is not simply “easy tasks pass, hard tasks fail.” Counting three bits failed while the larger counters passed. Qwen can produce a plausible structure and explanatory comments while the actual operations violate the requested behavior.

## What this means for our hackathon solution

Our strongest current demonstration is: **Qwen generates a wrong bit counter, our checker supplies concrete evidence, and Qwen then generates a version that passes the tests.** That is a measured improvement we can show. Successful Qwen repairs of BCD and sequence detection have not yet been demonstrated.

For BCD, repeating the definition alone did not produce working code in the measured clarification trial. Useful feedback should connect the observed failure (`10`: expected `0001_0000`, got `0000_1010`) to the current candidate's operations and digit layout. Compare measured failure evidence alone with evidence plus the arithmetic/width diagnosis under matching budgets; the latter supplies more help and must be reported as a separate condition. The human correction's 32/32 result does not show that Qwen can make that correction itself.

The next useful work is to make that improvement repeatable across tasks:

1. Give Qwen the exact interface and behavior together with observed failing inputs, expected outputs, actual outputs, and enough earlier inputs to explain a sequence failure.
2. Recheck the complete visible test set after every repair. The initial bit-counter repairs show why checking only the previously failing example is insufficient.
3. Compare current feedback, feedback with compact history, and independent retries under the same attempt and token budgets. Keep separate final tests whose detailed failures never enter repair prompts.
4. Add new team-authored tasks and larger cases that actually pressure the context budget. The present baseline prompts were too small to test whether memory compaction improves circuit generation.

The generate-test-repair loop already has prior work, including AutoChip, as described in our [project guidance](../../AGENTS.md). Our contribution needs to be evidence that our choice of feedback or memory improves results under a limited budget.

## Evidence limits and coverage

This review covers all **21 saved local Qwen responses** found: eight initial circuit generations, eight repair responses, and five BCD diagnostic responses. It also covers the six heat-equation problems in the assigned pod's attempt log. Reference runs, planted bugs, simulator replays, synthetic context checks, and offline stand-ins are not model accomplishments.

No team Qwen kernel-generation attempt log was found locally or in the assigned pod's kernel-project folder. NKI installation and checker checks therefore do not establish our model's kernel-writing ability. Results described in the shipped workshop README are excluded from our experiment scores.

The checker was separately tested with six correct references, 38 deliberately incorrect circuits, and 21 scoring checks. The expanded tests caught five planted faults that the original visible tests missed. This supports using the checker while also showing that a small visible test set can overlook real errors. [Checker audit](../../runs/verilog-checker-audit-20261010T163837.041257Z/summary.json).

These are small experiments on public circuit tasks, mostly one deterministic answer per initial condition. They do not establish a general success rate, formal circuit correctness, synthesis success, or performance of manufactured hardware. The evidence folders under `runs/` are Git-ignored and need to be retained with the submission.

## Simple Explanation

Qwen is a useful first-draft writer that needs a checker. It can get some circuits right, but it also makes basic mistakes and can explain something correctly while coding it incorrectly. We have shown that better feedback can help it fix one circuit. Our hackathon goal is to show that this help works across more tasks, and then measure whether remembering earlier failures helps further.
