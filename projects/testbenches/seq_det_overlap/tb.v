`timescale 1ns/1ps
// Testbench for seq_det_overlap: 8-bit serial sequence detector, overlapping matches count.
// Override the pattern with: iverilog -Ptb.PATTERN=<value> ...  (see ../run.sh)
// The checks and the stimulus live in ../common/seq_det_body.vh.
module tb;
  parameter [7:0] PATTERN = 8'b1011_0101;
  localparam OVERLAP = 1;
  reg clk = 0, rst_n, din = 0;   // rst_n starts X and falls at 0.2 ns (power-on reset)
  wire detected;
  integer cycle = 0;

  seq_det_overlap #(.PATTERN(PATTERN)) dut (.clk(clk), .rst_n(rst_n), .din(din), .detected(detected));
  always #5 clk = ~clk;
  always @(posedge clk) cycle <= cycle + 1;

  `include "tb_common.vh"
  `include "seq_det_body.vh"
endmodule
