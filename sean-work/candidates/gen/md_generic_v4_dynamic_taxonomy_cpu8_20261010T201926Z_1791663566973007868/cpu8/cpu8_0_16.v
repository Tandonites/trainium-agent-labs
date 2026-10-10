module cpu8 (
    input clk,
    input reset_n,
    input enable,
    input instruction [7:0],
    output reg [7:0] acc,
    output reg [7:0] pc,
    output reg [7:0] data_out,
    output reg carry,
    output reg halted
);

    // Immediate value from instruction (extended to 8 bits)
    reg [7:0] imm;
    always @(instruction) begin
        imm = instruction;
    end

    // Reset logic
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            acc <= 8'h00;
            pc <= 8'h00;
            data_out <= 8'h00;
            carry <= 1'b0;
            halted <= 1'b0;
        end else begin
            if (enable && !halted) begin
                case (instruction[7:4])
                    8'h00: begin // NOP
                        pc <= pc + 1;
                    end
                    8'h01: begin // LDI
                        acc <= imm;
                        pc <= pc + 1;
                    end
                    8'h02: begin // ADD
                        acc <= acc + imm;
                        carry <= acc[8];
                        pc <= pc + 1;
                    end
                    8'h03: begin // XOR
                        acc <= acc ^ imm;
                        pc <= pc + 1;
                    end
                    8'h04: begin // AND
                        acc <= acc & imm;
                        pc <= pc + 1;
                    end
                    8'h05: begin // JMP
                        pc <= imm;
                    end
                    8'h06: begin // JZ
                        if (acc == 8'h00) begin
                            pc <= imm;
                        end else begin
                            pc <= pc + 1;
                        end
                    end
                    8'h07: begin // OUT
                        data_out <= acc;
                        pc <= pc + 1;
                    end
                    8'h08: begin // HLT
                        halted <= 1'b1;
                    end
                    default: begin // NOP for opcodes 9-15
                        pc <= pc + 1;
                    end
                endcase
            end
        end
    end

endmodule
