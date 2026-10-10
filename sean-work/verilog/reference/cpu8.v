module cpu8 (
    input clk,
    input reset_n,
    input enable,
    input [7:0] instruction,
    output reg [7:0] acc,
    output reg [7:0] pc,
    output reg [7:0] data_out,
    output reg carry,
    output reg halted
);
    wire [7:0] immediate = {4'b0000, instruction[3:0]};
    wire [8:0] addition = {1'b0, acc} + {1'b0, immediate};

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            acc <= 8'd0;
            pc <= 8'd0;
            data_out <= 8'd0;
            carry <= 1'b0;
            halted <= 1'b0;
        end else if (enable && !halted) begin
            pc <= pc + 8'd1;
            case (instruction[7:4])
                4'h1: acc <= immediate;
                4'h2: begin
                    acc <= addition[7:0];
                    carry <= addition[8];
                end
                4'h3: acc <= acc ^ immediate;
                4'h4: acc <= acc & immediate;
                4'h5: pc <= immediate;
                4'h6: if (acc == 8'd0) pc <= immediate;
                4'h7: data_out <= acc;
                4'h8: begin
                    halted <= 1'b1;
                    pc <= pc;
                end
                default: begin end
            endcase
        end
    end
endmodule
