// Bug: combinational (Mealy) output from the current din, so detected is a cycle early and
// glitches with din instead of being registered.
module seq_det_nonoverlap #(parameter [7:0] PATTERN = 8'b1011_0101) (
  input clk, input rst_n, input din, output detected);
  reg [7:0] win; reg [3:0] n;
  assign detected = rst_n && (n >= 7) && ({win[6:0], din} == PATTERN);
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin win <= 0; n <= 0; end
    else begin
      win <= {win[6:0], din};
      if (detected) n <= 0; else if (n != 8) n <= n + 1;
    end
  end
endmodule
