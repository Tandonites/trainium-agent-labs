// Bug: the async reset clears the pins but not the FSM state, so an in-flight read still responds after reset.
module mem_ctrl #(parameter AW = 8, DW = 16, READ_LATENCY = 2) (
  input clk, input rst_n,
  input req_valid, output reg req_ready, input req_we,
  input [AW-1:0] req_addr, input [DW-1:0] req_wdata,
  output reg rsp_valid, output reg [DW-1:0] rsp_rdata,
  output reg sram_ce_n, output reg sram_we_n, output reg sram_oe_n,
  output reg [AW-1:0] sram_addr, inout [DW-1:0] sram_dq);
  localparam IDLE = 2'd0, CMD = 2'd1, WAIT = 2'd2;
  reg [1:0] st;
  reg [7:0] cnt;
  reg [DW-1:0] dq_out;
  reg dq_oe;
  assign sram_dq = dq_oe ? dq_out : {DW{1'bz}};
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      req_ready <= 1'b0; rsp_valid <= 1'b0; rsp_rdata <= 0;
      sram_ce_n <= 1'b1; sram_we_n <= 1'b1; sram_oe_n <= 1'b1; sram_addr <= 0;
      dq_out <= 0; dq_oe <= 1'b0;
    end else begin
      rsp_valid <= 1'b0;
      case (st)
        IDLE:
          if (!req_ready) req_ready <= 1'b1;                 // first edge after reset
          else if (req_valid) begin
            sram_ce_n <= 1'b0; sram_we_n <= !req_we; sram_addr <= req_addr;
            dq_out <= req_wdata; dq_oe <= req_we;
            req_ready <= 1'b0; st <= CMD;
          end
        CMD: begin                                           // the SRAM samples the command now
          sram_ce_n <= 1'b1; sram_we_n <= 1'b1; dq_oe <= 1'b0;
          if (!sram_we_n) begin req_ready <= 1'b1; st <= IDLE; end
          else begin sram_oe_n <= 1'b0; cnt <= 1; st <= WAIT; end
        end
        WAIT:
          if (cnt == READ_LATENCY) begin                     // data was on dq this cycle
            rsp_valid <= 1'b1; rsp_rdata <= sram_dq; sram_oe_n <= 1'b1;
            req_ready <= 1'b1; st <= IDLE;
          end else cnt <= cnt + 1;
        default: st <= IDLE;
      endcase
    end
  end
endmodule
