# Architecture

This is a single-clock, SDR bit-serial behavioral link with synthesizable Verilog-2005 RTL. One bit interval equals one master clock cycle. There is no clock recovery, DDR PHY, vendor primitive, or PCIe LTSSM. The obsolete SystemVerilog/Xilinx reference files were inspected during implementation and removed during pre-upload cleanup. `README(7).md` was absent; the workspace `README.md` and legacy RTL were inspected instead.

## Paths and hierarchy

```text
TX data/K/valid --ready--> encoder_8b10b
                         | registered encoded word
                         v
                   pending + holding buffer
                         |
                         v
                    tx_serializer --> serial_tx

serial_rx --> rx_deserializer --> raw_data/raw_valid
                                  |             |
                                  v             v
                         {previous_raw,raw}   rx_word_aligner
                              20-bit window     ^       |
                                  |             |       v
                           k28_5_detector       |  decoder_8b10b
                                  |             |       |
                                  v             |       v
                            rx_symbol_lock -----+  decoded/error/valid
```

`serdes_top` instantiates all seven other modules. The detector and aligner each retain the same definition of adjacent-word position; the detector's window register is visible as `dut.window_data` in waveforms.

## Coding and disparity

Data byte convention is HGF_EDCBA: x=data[4:0], y=data[7:5]. The 10-bit vector is abcdei_fghj, with a at bit 9. The serializer sends bit 9 first; the deserializer shifts left and appends each received bit at bit 0. RD=0 is negative; reset RD is negative.

The full encoder case table covers 256 data and twelve K characters at both input disparities (536 entries). It applies intermediate 6-bit disparity before selecting the 4-bit code, including balanced D7 polarity, balanced .3 polarity, alternate D.x.7 selections, and special K28 suffixes. Legal controls are K28.0 through K28.7 and K23.7/K27.7/K29.7/K30.7. K28.5 (BC with K=1) is 0011111010 at incoming RD-, and 1100000101 at incoming RD+.

Encoder `valid_out` pulses one registered stage after valid input. An illegal K request raises `invalid_k`, suppresses `valid_out`, and leaves running disparity and encoded output unchanged. Ordinary D28.5 remains distinct from K28.5.

The decoder classifies complete 10-bit codes, rather than accepting arbitrary combinations of legal subblocks. Each entry records its decoded byte/K flag and permissible incoming disparities. A word legal only at the opposite disparity raises disparity_error, still decodes, and adopts the resulting disparity of that legal representation. A globally invalid word raises code_error and retains disparity. Both errors are cleared on invalid cycles; `valid_out` marks every presented word, including erroneous ones. Balanced words preserve the applicable running disparity.

The tables are combinational `case` statements followed by registers. They are deliberately explicit and have not been optimized for FPGA area or timing.

## TX acceptance and timing

An upstream symbol is accepted on a rising edge with `tx_valid && tx_ready`. Inputs must remain stable for that edge. The encoder handles one outstanding request; a separate word buffer retains its output until the serializer accepts it. Invalid K requests release the outstanding request without sending a word.

With an idle serializer, acceptance at edge E reaches the holding buffer at E+1 and launches serial bit 9 at E+2. Every accepted serializer word produces exactly ten bit intervals. `ready` means the serializer can launch a new word at the next edge. It is high throughout the final bit interval; `busy` is consequently low during that interval. These two outputs are readiness indicators, not a bit-valid strobe. `serial_tx_valid` explicitly marks every emitted bit interval, including the last one.

Sustained source traffic yields one serializer launch every ten clocks; the scoreboard asserts this spacing. The source may hold valid high and advance only on ready. If no word is available at a boundary, serial_out holds its last value. A continuous ungated physical-style stream must therefore supply filler/training words between payload bursts. For a paused simulation transport, connect TX `serial_tx_valid` to receiver `rx_bit_valid` alongside serial data. RX `rx_bit_valid=1` models sampling every clock, including gaps. RX has no output backpressure.

## Window alignment and latency

The window is `{older_raw[9:0], newer_raw[9:0]}`. Offset o is the count of bits skipped from older_raw[9]. The candidate/reconstructed word is `(window >> (10-o)) & 10'h3ff`, for o=0..9. Offset 0 returns the older word. Every other offset spans two words; rotating one word would fail the reconstruction tests. The detector searches all ten starts and chooses the smallest matching offset if multiple matches exist.

The aligner primes its previous-word register on the first raw_valid edge. Every subsequent raw_valid edge emits one aligned word when alignment is enabled. `aligned_valid` is registered at that edge; it is low on raw-valid gaps. Thus offset zero deliberately has the same two-word lookahead latency as other offsets. Once aligned, throughput is one symbol per ten valid bit clocks.

A completed deserializer word and raw_valid are registered on its tenth received-bit edge. The aligner and detector consume that pair on the following edge. The decoder consumes registered aligned data one clock later. The lock controller consumes the registered decoder-valid and associated error flags on the next edge; it does not combine raw-word valid with decoder errors from a different symbol.

On acquisition, the detected comma is decoded once directly from the window to establish receiver disparity. This seed's diagnostic is excluded from verification via a registered payload tag. The aligner starts with the following symbol. Otherwise, acquisition at RD+ could repeatedly fail from a reset RD- assumption. Decoder error outputs can therefore indicate a seed disparity mismatch while searching; only rx_valid qualifies delivered payload.

## Lock controller

```text
IDLE -> SEARCHING -> VERIFY -> LOCKED -> LOST -> SEARCHING
                     |                    ^
                     +-- error -> SEARCHING
force_realign ----------------------------+
```

SEARCHING enables alignment at a detected comma offset. VERIFY requires `VERIFY_SYMBOLS` successive legal decoded symbols (default four). An error during verification rejects the candidate. LOCKED ignores comma absence; legal data resets its consecutive-error counter. `ERROR_LIMIT` consecutive decoded symbols carrying either error (default four) enter LOST, pulse lock_lost, disable alignment and clear lock. LOST returns to SEARCHING on the next clock. Acquisition pulses lock_acquired. Force realignment enters LOST from any state, pulsing lock_lost only if previously locked. Parameters must be positive integers.

The receiver's output valid is gated with symbol lock. Symbols used for training/verification are not guaranteed as application payload. Send repeated K28.5 training before meaningful data and after link interruption. No finite comma search can guarantee acquisition from arbitrary payload or adversarial false comma sequences; four legal symbols validate a candidate rather than proving higher-level packet framing.
