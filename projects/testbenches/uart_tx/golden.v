// Spec: UART 8N1 transmitter (same as 07-verilog-protocols/protocols/problems/uart_tx/prompt.txt).
//   uart_tx #(parameter CLKS_PER_BIT = 4) (input clk, input rst, input [7:0] data, input valid,
//                                          output ready, output tx)
//   Outputs registered on posedge clk. rst: synchronous, active high: tx=1, ready=1, frame abandoned.
//   Idle: tx=1, ready=1. On an edge with valid=1 and ready=1: capture data, ready=0, tx=0 (start).
//   Frame: start 0, data[0]..data[7] (LSB first), stop 1, each bit exactly CLKS_PER_BIT cycles.
//   ready returns to 1 on the edge that ends the stop bit (10*CLKS_PER_BIT cycles after accept),
//   with tx=1; a byte still on valid is accepted on the following edge.
//   valid and data are ignored while ready=0.
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
        sh <= {1'b1, data, 1'b0}; tx <= 1'b0; ready <= 1'b0; bitn <= 0; cnt <= 0;
      end
    end else if (cnt == CLKS_PER_BIT - 1) begin
      cnt <= 0;
      if (bitn == 9) begin ready <= 1'b1; tx <= 1'b1; end
      else begin bitn <= bitn + 1; tx <= sh[bitn + 1]; end
    end else
      cnt <= cnt + 1;
  end
endmodule
