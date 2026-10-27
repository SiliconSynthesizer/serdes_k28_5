# Executed verification report

Date: 2026-10-27. Environment: Ubuntu Linux, Icarus Verilog 11.0 (stable), vvp, installed GTKWave. All commands below were executed from `serdes_k28_5/`:

```bash
bash scripts/compile.sh
bash scripts/run_tests.sh
```

Compilation used `iverilog -g2005 -Wall` for each of three selected testbench tops. Compilation and simulation returned zero. `build/compile.log` is empty: zero compiler warnings/errors. Shell syntax checks and `git diff --check` passed. A keyword scan of the new RTL/testbench directories found no SystemVerilog-only declarations. There are eight RTL `.v` files and three testbench `.v` files. Obsolete legacy `.sv` files were removed during pre-upload cleanup.

## Actual results

| Testbench | Result | Executed coverage |
|---|---|---|
| tb_encoder_decoder | PASS, 3,139 checks | All 256 D + 12 K at both input RDs; continuous encoder valid; 244 illegal K inputs; RD/reset; 36 fixed literal vector checks; all 1,024 decoder words at each initial RD |
| tb_comma_alignment | PASS | Both comma polarities at every offset 0..9 (20 cases); full comma and two distinct following-word comparisons; cross-word reconstruction; priming/valid gaps; no comma; invalid window; deserializer bit order with bit-valid pauses; FSM checks below |
| tb_serdes_loopback | PASS, 5,010 symbol matches | Ten initial bit phases; 256 sequential bytes, 200 deterministic pseudorandom bytes and mixed legal K symbols in each phase; continuous launches; corruption, phase change, reacquisition and 33 checked recovery symbols per phase |

Required suites: **3 PASS, 0 FAIL**. The tests contain explicit timeouts and `$fatal(1, ...)` failure exits. The runner checks simulator exit codes and a completion PASS marker, and preserves logs through `tee` with pipefail.

Codec tests compare full words and post-encoding RD. The decoder sweep checks code_error, disparity_error, decoded data and K classification. Its two starting RDs include initial RD- after reset and RD+ established by a valid comma. The legality table recognizes 464 distinct complete 10-bit patterns. Globally illegal codes and legal opposite-RD codes are tested separately. Loopback further checks continuous decoder timing with real serial words.

Alignment tests check the exact offset and polarity plus complete reconstructed words; all eighteen cross-boundary polarity/offset cases pass. A separate serial unit test verifies that pauses in bit_valid do not advance the raw word counter.

FSM tests check SEARCHING without commas, VERIFY rejection, no early acquisition, four-symbol acquisition, no early error loss, a legal symbol resetting the error streak, four disparity errors causing LOST, next-cycle SEARCHING, reacquisition, force realignment, and reset during synchronization. An additional instance checks acquisition after three legal symbols and loss after exactly two errors with nondefault parameters. A 300-symbol legal interval without commas keeps lock; each loopback payload also supplies 457 consecutive D/K23.7 symbols without K28.5 before its mixed control suffix.

Loopback compares 501 symbols per phase: one K23.7 marker, 256 sequential data, 200 pseudorandom data, eleven mixed controls, then one marker plus 32 data after recovery. Every mismatch, missing symbol, flagged payload error or non-ten-clock serializer launch interval fails the test. Training output before the marker is deliberately excluded from application payload checking. The marker is queued and checked along with subsequent data. Injection forces the serial wire low for 85 master clocks while TX keeps sending commas, then changes delay by three bits modulo ten. Each phase records one lock-loss pulse and one reacquisition pulse. Observed decoding errors during injection/recovery: five in phases 0..6 and four in phases 7..9. All ten phases recover and deliver the scored recovery payload.

## Reference independence

The exhaustive encoder expected vectors and decoder classifications were constructed from the 5b/6b and 3b/4b coding rules, including intermediate disparity, alternate .7, K28 suffixes and all legal controls. They are stored in the testbench and do not call RTL functions or inspect DUT coding tables. However, the specification-derived exhaustive expectations share their derivation with the implementation; they are not an independently certified exhaustive oracle.

To avoid relying solely on encoder/decoder roundtrip agreement, the testbench also contains 24 fixed K vectors (all twelve controls at both RDs) checked against the published [ZIPcores CODEC_8B10B control table](https://www.zipcores.com/datasheets/codec_8b10b.pdf), plus twelve manually checked D vectors covering balanced and alternate-.7 behavior. [Intel's ED8B10B data sheet](https://cdrdv2-public.intel.com/654541/dsed8b10b.pdf) corroborates the legal K byte set and running-disparity rules. No external HDL implementation was copied into the project. These checks are simulation evidence, not formal certification against the entire IEEE specification.

## Logs and waveforms

```text
build/test_summary.log
build/compile.log
build/tb_encoder_decoder.log
build/tb_comma_alignment.log
build/tb_serdes_loopback.log
build/tb_encoder_decoder.vcd
build/tb_comma_alignment.vcd
build/tb_serdes_loopback.vcd
```

All three VCD files were produced by the passing runs. Full-hierarchy `$dumpvars` includes TX byte/K, encoded word, buffer, serial TX/RX, raw words, 20-bit window, comma and offset, aligned words, decoded byte/K, errors and lock-controller state. For viewing:

```bash
bash scripts/run_wave.sh
bash scripts/run_wave.sh tb_comma_alignment
bash scripts/run_wave.sh tb_encoder_decoder
```

GTKWave executable availability was checked. The graphical viewer was not launched or visually inspected in this session.

## Remaining limits

No required simulation test remains failing. `README(7).md` was not supplied, so the available root README was used as the architectural reference. Legacy DDR, comma-absence lock-loss and partial-codec behavior were not carried into this implementation.

The design is an SDR, shared-clock simulation link, not a physical DDR transceiver. It assumes a sampled serial bit stream and models no CDR, jitter, metastability, analog effects or clock-frequency tolerance. There is no RX backpressure, idle insertion, elastic FIFO, hardware timing/area analysis or FPGA synthesis validation. Gaps on an ungated serial link are held levels and can correctly lead to code errors and lock loss; maintain filler traffic or qualify received bits for a paused simulation transport. The initial acquisition comma may report a disparity diagnostic before lock, and verification/training symbols are not guaranteed as payload. Fixed tables prioritize reviewable functional mapping over resource efficiency. No PCIe protocol logic or vendor PHY primitives were added.

## Terminal reporting

The test runner was rerun after adding named coverage-group PASS messages. It prints each suite as RUN followed by its actual PASS/FAIL result, continues to remaining suites after a simulation failure, and ends with total PASS/FAIL counts and OVERALL status. The final executed summary is 3 suites, 3 PASS, 0 FAIL, OVERALL PASS. Compilation failure explicitly marks all three simulations NOT RUN. The full report is saved in `build/test_summary.log`; testbench `$fatal` messages identify failed checks.

## Pre-upload cleanup

Removed fourteen obsolete SystemVerilog/Xilinx reference files from the original workspace, the unused alignment-test variable, and a temporary loopback debug print. Essential RTL, self-checking tests, named terminal results, wave generation and documentation are retained. Added `scripts/clean.sh` and editor-temporary-file ignore rules.

After cleanup, reran all three suites from a clean build: 3 PASS, 0 FAIL; codec checks remain 3,139 and loopback matches remain 5,010. Generated executables, logs and VCD files were then removed for the clean source deliverable. The waveform/log paths listed above are regenerated by `bash scripts/run_tests.sh`; the numerical results in this report record the executed passing run.
