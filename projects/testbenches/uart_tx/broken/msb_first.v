// EXPECT: func
module uart_tx #(parameter CLKS_PER_BIT = 4) (
  input clk, input rst, input [7:0] data, input valid,
  output reg ready, output reg tx);
  reg [9:0]  sh;
  reg [3:0]  bitn;
  reg [15:0] cnt;
  always @(posedge clk) begin
    if (rst) begin
      tx <= 1'b1; ready <= 1'b1; bitn <= 0; cnt <= 0;
    end else if (ready) begin
      if (valid) begin
        sh <= {1'b1, data[0],data[1],data[2],data[3],data[4],data[5],data[6],data[7], 1'b0}; tx <= 1'b0; ready <= 1'b0; bitn <= 0; cnt <= 0;
      end
    end else if (cnt == CLKS_PER_BIT - 1) begin
      cnt <= 0;
      if (bitn == 9) begin ready <= 1'b1; tx <= 1'b1; end
      else begin bitn <= bitn + 1; tx <= sh[bitn + 1]; end
    end else
      cnt <= cnt + 1;
  end
endmodule
