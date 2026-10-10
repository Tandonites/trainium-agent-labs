// Bug: prefix-counting FSM that falls back to state 0/1 on a mismatch instead of the longest
// matching suffix (no KMP failure function). Misses matches for self-overlapping patterns.
module seq_det_nonoverlap #(parameter [7:0] PATTERN = 8'b1011_0101) (
  input clk, input rst_n, input din, output reg detected);
  reg [3:0] s;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin s <= 0; detected <= 0; end
    else if (din == PATTERN[7 - s]) begin
      if (s == 7) begin detected <= 1; s <= 0; end
      else begin detected <= 0; s <= s + 1; end
    end else begin
      detected <= 0; s <= (din == PATTERN[7]) ? 1 : 0;
    end
  end
endmodule
