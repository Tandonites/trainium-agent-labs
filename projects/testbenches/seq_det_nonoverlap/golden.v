// Spec: 8-bit serial sequence detector, non-overlapping.
//   seq_det_nonoverlap #(parameter [7:0] PATTERN = 8'b1011_0101)
//                      (input clk, input rst_n, input din, output reg detected)
//   rst_n: asynchronous, active low. While low: all history cleared and detected=0 at once
//   (no clock edge needed); no samples are taken.
//   One bit of din is sampled on every rising edge while rst_n=1. PATTERN[7] is the oldest bit.
//   detected is registered: after each non-reset edge it is 1 exactly when the last 8 samples
//   equal PATTERN and none of those 8 samples belongs to an earlier match (or precedes reset).
//   Equivalently: after a match the detector starts over, and the next match needs 8 new samples.
module seq_det_nonoverlap #(parameter [7:0] PATTERN = 8'b1011_0101) (
  input clk, input rst_n, input din, output reg detected);
  reg [7:0] win;
  reg [3:0] n;   // usable samples since reset or the last match, saturating at 8
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      win <= 0; n <= 0; detected <= 1'b0;
    end else begin
      win <= {win[6:0], din};
      if ((n >= 7) && ({win[6:0], din} == PATTERN)) begin
        detected <= 1'b1; n <= 0;
      end else begin
        detected <= 1'b0;
        if (n != 8) n <= n + 1;
      end
    end
  end
endmodule
