// Bug: treats PATTERN[0] as the oldest bit (pattern reversed).
module seq_det_nonoverlap #(parameter [7:0] PATTERN = 8'b1011_0101) (
  input clk, input rst_n, input din, output reg detected);
  reg [7:0] win; reg [3:0] n;
  wire [7:0] cur = {din, win[7:1]};
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin win <= 0; n <= 0; detected <= 0; end
    else begin
      win <= cur;
      if ((n >= 7) && (cur == PATTERN)) begin detected <= 1; n <= 0; end
      else begin detected <= 0; if (n != 8) n <= n + 1; end
    end
  end
endmodule
