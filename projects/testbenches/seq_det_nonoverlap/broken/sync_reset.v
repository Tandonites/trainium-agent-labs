// Bug: synchronous reset (rst_n only acts on a clock edge), so pulses between edges are missed
// and detected is X until the first edge.
module seq_det_nonoverlap #(parameter [7:0] PATTERN = 8'b1011_0101) (
  input clk, input rst_n, input din, output reg detected);
  reg [7:0] win;
  reg [3:0] n;   // usable samples since reset or the last match, saturating at 8
  always @(posedge clk) begin
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
