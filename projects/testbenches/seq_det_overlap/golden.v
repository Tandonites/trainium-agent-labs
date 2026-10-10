// Spec: 8-bit serial sequence detector, overlapping.
//   seq_det_overlap #(parameter [7:0] PATTERN = 8'b1011_0101)
//                   (input clk, input rst_n, input din, output reg detected)
//   rst_n: asynchronous, active low. While low: all history cleared and detected=0 at once
//   (no clock edge needed); no samples are taken.
//   One bit of din is sampled on every rising edge while rst_n=1. PATTERN[7] is the oldest bit.
//   detected is registered: after each non-reset edge it is 1 exactly when the last 8 samples
//   since reset (including this one) equal PATTERN, else 0. Fewer than 8 samples never match.
//   Overlapping: a sample may belong to more than one match (10101010 with PATTERN 1010_1010
//   followed by 10 matches again).
module seq_det_overlap #(parameter [7:0] PATTERN = 8'b1011_0101) (
  input clk, input rst_n, input din, output reg detected);
  reg [7:0] win;
  reg [3:0] n;   // samples since reset, saturating at 8
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      win <= 0; n <= 0; detected <= 1'b0;
    end else begin
      win <= {win[6:0], din};
      if (n != 8) n <= n + 1;
      detected <= (n >= 7) && ({win[6:0], din} == PATTERN);
    end
  end
endmodule
