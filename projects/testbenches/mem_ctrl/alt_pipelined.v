// A second CORRECT design with very different timing, used to show the tb does not assume the
// golden's latency or one-at-a-time behavior. It accepts a request almost every cycle and keeps
// up to READ_LATENCY reads in flight. The one restriction: a write may not be issued in a cycle
// when the SRAM will be driving read data (bus turnaround), so req_ready drops for a write then.
module mem_ctrl #(parameter AW = 8, DW = 16, READ_LATENCY = 2) (
  input clk, input rst_n,
  input req_valid, output req_ready, input req_we,
  input [AW-1:0] req_addr, input [DW-1:0] req_wdata,
  output reg rsp_valid, output reg [DW-1:0] rsp_rdata,
  output reg sram_ce_n, output reg sram_we_n, output sram_oe_n,
  output reg [AW-1:0] sram_addr, inout [DW-1:0] sram_dq);
  // rd_sched[i] = 1: the SRAM drives read data i cycles from now (index 0 = the current cycle)
  reg [READ_LATENCY:0] rd_sched;
  reg [DW-1:0] dq_out;
  reg dq_oe;
  assign sram_dq = dq_oe ? dq_out : {DW{1'bz}};
  assign sram_oe_n = !rd_sched[0];
  assign req_ready = rst_n && !(req_we && rd_sched[1]);
  wire accept = req_valid && req_ready;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rd_sched <= 0; rsp_valid <= 1'b0; rsp_rdata <= 0;
      sram_ce_n <= 1'b1; sram_we_n <= 1'b1; sram_addr <= 0; dq_out <= 0; dq_oe <= 1'b0;
    end else begin
      rsp_valid <= rd_sched[0];
      if (rd_sched[0]) rsp_rdata <= sram_dq;
      rd_sched <= (rd_sched >> 1) | ((accept && !req_we) << READ_LATENCY);
      sram_ce_n <= !accept; sram_we_n <= !(accept && req_we);
      if (accept) sram_addr <= req_addr;
      dq_out <= req_wdata; dq_oe <= accept && req_we;
    end
  end
endmodule
