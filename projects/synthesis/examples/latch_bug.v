// Example for the synthesis check: this detector PASSES the simulation testbench
// (../testbenches/seq_det_overlap, 21/21) but is not clean hardware.
// `match` is assigned in a combinational block only while rst_n is high. When rst_n is low the
// block keeps its old value, which a simulator just does, but hardware needs a latch to do it.
// The flip-flop ignores `match` during reset, so no test can observe the difference.
module seq_det_overlap #(parameter [7:0] PATTERN = 8'b1011_0101) (
  input clk, input rst_n, input din, output reg detected);
  reg [7:0] win;
  reg [3:0] n;
  reg match;
  always @* begin
    if (rst_n) match = (n >= 7) && ({win[6:0], din} == PATTERN);   // no else: latch
  end
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      win <= 0; n <= 0; detected <= 1'b0;
    end else begin
      win <= {win[6:0], din};
      if (n != 8) n <= n + 1;
      detected <= match;
    end
  end
endmodule
