// Bug: plain shift register, no count of samples since reset. The zeroed history can complete a
// match early when PATTERN starts with zeros (shows up with PATTERN=8'h01 or 8'h00). After a match
// it clears the window to zeros, which has the same flaw.
module seq_det_nonoverlap #(parameter [7:0] PATTERN = 8'b1011_0101) (
  input clk, input rst_n, input din, output reg detected);
  reg [7:0] win;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin win <= 0; detected <= 0; end
    else begin
      win <= {win[6:0], din};
      detected <= ({win[6:0], din} == PATTERN);
      if ({win[6:0], din} == PATTERN) win <= 8'h00;
    end
  end
endmodule
