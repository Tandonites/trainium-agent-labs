// Bug: after a match the FSM spends one extra cycle in a "done" state and drops that sample,
// so a pattern that follows a match directly is missed.
module seq_det_nonoverlap #(parameter [7:0] PATTERN = 8'b1011_0101) (
  input clk, input rst_n, input din, output reg detected);
  reg [7:0] win; reg [3:0] n;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin win <= 0; n <= 0; detected <= 0; end
    else if (detected) begin detected <= 0; n <= 0; end
    else begin
      win <= {win[6:0], din};
      if ((n >= 7) && ({win[6:0], din} == PATTERN)) begin detected <= 1; n <= 0; end
      else begin detected <= 0; if (n != 8) n <= n + 1; end
    end
  end
endmodule
