// EXPECT: timing
// Protocol is correct, but the start bit begins one cycle after the accept edge.
module uart_tx #(parameter CLKS_PER_BIT = 4) (
  input clk, input rst, input [7:0] data, input valid,
  output reg ready, output reg tx);
  reg [9:0] sh; reg [3:0] bitn; reg [15:0] cnt; reg pend;
  always @(posedge clk) begin
    if (rst) begin tx <= 1; ready <= 1; bitn <= 0; cnt <= 0; pend <= 0; end
    else if (ready) begin
      if (valid) begin sh <= {1'b1, data, 1'b0}; ready <= 0; pend <= 1; end
    end else if (pend) begin pend <= 0; tx <= 0; bitn <= 0; cnt <= 0; end
    else if (cnt == CLKS_PER_BIT - 1) begin
      cnt <= 0;
      if (bitn == 9) begin ready <= 1; tx <= 1; end
      else begin bitn <= bitn + 1; tx <= sh[bitn + 1]; end
    end else cnt <= cnt + 1;
  end
endmodule
