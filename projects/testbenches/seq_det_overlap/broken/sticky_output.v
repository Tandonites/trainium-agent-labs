// Bug: detected latches high after the first match instead of being a 1-cycle pulse.
module seq_det_overlap #(parameter [7:0] PATTERN = 8'b1011_0101) (
  input clk, input rst_n, input din, output reg detected);
  reg [7:0] win; reg [3:0] n;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin win <= 0; n <= 0; detected <= 0; end
    else begin
      win <= {win[6:0], din};
      if (n != 8) n <= n + 1;
      if ((n >= 7) && ({win[6:0], din} == PATTERN)) detected <= 1;
    end
  end
endmodule
