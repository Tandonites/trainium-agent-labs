# What the testbenches expect

This is the contract each testbench grades against. Every rule below is checked. A prompt that leaves a rule out will make correct-looking designs fail, so each prompt should state all of them: port names, widths, parameter names, reset polarity and type, and timing.

General rules for every module:
- Plain synthesizable Verilog-2001 (compiled with Icarus 12, `-g2012`).
- Module, port, and parameter names must match exactly. A mismatch is a compile error (`status: compile_error`).
- Outputs must never be X or Z after reset.
- "Registered" means an output changes only on the rising edge of `clk`, or asynchronously when the reset asserts.

---

## UART TX (`uart_tx/`)

Same as `07-verilog-protocols/protocols/problems/uart_tx/prompt.txt`.

```verilog
module uart_tx #(parameter CLKS_PER_BIT = 4) (
  input        clk,
  input        rst,      // synchronous, active high
  input  [7:0] data,
  input        valid,    // "data is ready to transmit"
  output       ready,    // transmitter can accept a byte
  output       tx        // serial line
);
```
- Outputs are registered.
- Reset: on a rising edge with `rst=1`, `tx=1` and `ready=1`, and any frame in progress is abandoned.
- Idle: `tx=1`, `ready=1`.
- A byte is accepted on a rising edge with `valid=1 && ready=1`. On that same edge, `data` is captured, `ready` goes 0, and `tx` goes 0 (the start bit begins).
- Frame: start bit `0`, then `data[0]` through `data[7]` (LSB first), then stop bit `1`. Each bit lasts exactly `CLKS_PER_BIT` cycles.
- `ready` returns to 1 on the edge that ends the stop bit, `10*CLKS_PER_BIT` cycles after the accept, with `tx=1`. If `valid` is still 1, the next byte is accepted on the following edge.
- `valid` and `data` are ignored while `ready=0`. `data` may change right after it is accepted.

Checked against `CLKS_PER_BIT` = 1, 2, 3, 4 and 16. Exact cycle counts are `kind=timing`. Wrong bits, order or framing are `kind=func`.

If you want the UART to use an async active-low reset like the others, tell me and I'll switch it.

---

## Sequence detector, overlapping (`seq_det_overlap/`) and non-overlapping (`seq_det_nonoverlap/`)

```verilog
module seq_det_overlap    #(parameter [7:0] PATTERN = 8'b1011_0101) (input clk, input rst_n, input din, output reg detected);
module seq_det_nonoverlap #(parameter [7:0] PATTERN = 8'b1011_0101) (input clk, input rst_n, input din, output reg detected);
```
- **Input:** one serial bit `din`, sampled on every rising edge while `rst_n=1`. `PATTERN[7]` is the bit that must arrive first (oldest), and `PATTERN[0]` arrives last.
- **Reset:** `rst_n` is asynchronous and active low.
  - The moment it goes low, with no clock edge needed, all history is cleared and `detected=0`.
  - While it is low, no samples are taken.
  - It is released away from clock edges.
- **Output timing:** `detected` is registered.
  - It is 1 for exactly one cycle, the cycle right after the rising edge that samples the last bit of a match. Otherwise it is 0.
  - It must not change between clock edges (no combinational / Mealy output from `din`).
- **Fewer than 8 bits:** fewer than 8 samples since reset never match, whatever the history registers reset to.
- **Overlapping:** samples may be shared between matches.
  - Example: with `PATTERN = 8'b1010_1010`, the stream `1010101010` matches after bit 8 and again after bit 10.
- **Non-overlapping:** after a match the detector starts over. The next match needs 8 new samples, so none of the bits of the previous match can be reused.
  - In the example above, only the first match counts.
  - A full new copy of the pattern right after a match does match.

Checked with `PATTERN` = B5, AA, 00, FF, 01, 80, E7, 6D (all-same, alternating, leading zeros, self-overlapping). The prompt should say `PATTERN` is a parameter the design must use, not a constant.

---

## Memory controller (`mem_ctrl/`)

The controller sits between a host (valid/ready requests) and an external synchronous SRAM, which the testbench models. The SRAM has active-low controls and one shared bidirectional data bus.

```verilog
module mem_ctrl #(parameter AW = 8, DW = 16, READ_LATENCY = 2) (
  input           clk,
  input           rst_n,       // asynchronous, active low

  // host side
  input           req_valid,   // a request is presented
  output          req_ready,   // controller can accept it
  input           req_we,      // 1 = write, 0 = read
  input  [AW-1:0] req_addr,
  input  [DW-1:0] req_wdata,
  output          rsp_valid,   // 1-cycle pulse: read data is on rsp_rdata
  output [DW-1:0] rsp_rdata,

  // SRAM side
  output          sram_ce_n,   // chip enable, active low: a command this cycle
  output          sram_we_n,   // 0 = write command, 1 = read command (when sram_ce_n=0)
  output          sram_oe_n,   // output enable, active low: lets the SRAM drive sram_dq
  output [AW-1:0] sram_addr,
  inout  [DW-1:0] sram_dq      // shared data bus
);
```

### How the SRAM behaves

The design must assume this behavior.

- The SRAM samples `sram_ce_n`, `sram_we_n`, `sram_addr` and `sram_dq` on each rising edge. A command happens at a rising edge where `sram_ce_n=0`.
- **Write command** (`sram_we_n=0`): the SRAM stores the value on `sram_dq` at that edge into `mem[sram_addr]`.
- **Read command** (`sram_we_n=1`) at edge *k*:
  - The SRAM drives `mem[sram_addr]` onto `sram_dq` for one cycle, from edge *k+READ_LATENCY-1* to edge *k+READ_LATENCY*, but only while `sram_oe_n=0`.
  - The controller captures it at edge *k+READ_LATENCY*.
  - For `READ_LATENCY=1`, the data is on the bus the cycle right after the command.
- The SRAM accepts a command every cycle. Reads are pipelined.
- The SRAM is not reset by `rst_n`.

### What the controller must do

1. **Accepting requests.** A request is accepted on a rising edge where `req_valid=1 && req_ready=1`. The `req_*` fields are only valid on that edge, so the controller must latch them. They may change on the next cycle.
2. **One command per request, in order.** Each accepted request becomes exactly one SRAM command, with the same operation and address (and the same data for a write), issued in acceptance order. There must be no other SRAM commands.
3. **Write data on the bus.** For a write, the controller drives the data on `sram_dq` during the command cycle (the cycle ending at the edge with `sram_ce_n=0, sram_we_n=0`).
4. **Bus ownership.** The controller drives `sram_dq` only during write command cycles. At all other times it must release the bus (`'z`). It must never drive the bus while the SRAM is outputting read data, so a read followed by a write needs to avoid that collision.
5. **`sram_oe_n`.**
   - It must be 0 during every cycle in which the SRAM outputs read data for a read this controller issued.
   - It must be 1 during write command cycles.
   - At other times it can be anything (0 or 1, not X).
6. **Read responses.** Each accepted read produces exactly one `rsp_valid` pulse (1 cycle), in acceptance order.
   - `rsp_rdata` is the data the SRAM returned, which equals the value at that address after all earlier accepted writes and none of the later ones.
   - There is no `rsp_valid` without a read.
   - `rsp_rdata` is don't-care when `rsp_valid=0`.
7. **Latency and throughput are up to the design.**
   - One request at a time, or pipelined, are both fine.
   - Bounds:
     - A request held on `req_valid` must be accepted within 16 cycles.
     - An accepted request must reach the SRAM within 16 cycles.
     - A read must be answered within `READ_LATENCY+16` cycles of acceptance.
   - `READ_LATENCY` is a parameter and must be honored (tested at 1, 2, 3, 4).
8. **Reset (asynchronous, active low).**
   - Immediately when `rst_n` goes low, and for as long as it stays low: `sram_ce_n=1`, `sram_we_n=1`, `sram_oe_n=1`, `rsp_valid=0`, `req_ready=0`, and `sram_dq` is released.
   - All accepted-but-unfinished requests are dropped. They get no SRAM command and no response.
   - After `rst_n` rises, `req_ready` must be 1 within 4 cycles.
9. No X/Z on `req_ready`, `rsp_valid`, `sram_ce_n`, `sram_oe_n` (or on `sram_we_n` during a command) after reset.

Checked with (AW, DW, READ_LATENCY) = (4,8,1), (4,8,2), (4,8,3), (2,8,2), (6,16,4).

`golden.v` shows the simple approach: accept, issue the command for one cycle, and for reads wait `READ_LATENCY` edges with `oe_n` low, then respond. `alt_pipelined.v` shows a pipelined design that also passes.

---

## Reading the results

Use `python3 parse_log.py --run <module> <design.v> [-P tb.X=..]` to get JSON. Each mismatch carries the signals and inputs at that moment, and the expected and actual values, so no waveform is needed. See `README.md` for the log format.
