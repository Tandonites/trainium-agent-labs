// Bug: the async reset clears detected but not the history window / sample count.
module seq_det_overlap #(parameter [7:0] PATTERN = 8'b1011_0101) (
  input clk, input rst_n, input din, output reg detected);
  reg [7:0] win;
  reg [3:0] n;   // samples since reset, saturating at 8
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      detected <= 1'b0;
    end else begin
      win <= {win[6:0], din};
      if (n != 8) n <= n + 1;
      detected <= (n >= 7) && ({win[6:0], din} == PATTERN);
    end
  end
endmodule
