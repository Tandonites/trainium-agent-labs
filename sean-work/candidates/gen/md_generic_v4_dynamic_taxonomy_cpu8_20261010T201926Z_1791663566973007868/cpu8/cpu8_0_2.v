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

    // Internal signals
    reg [7:0] imm;
    reg [7:0] next_pc;
    reg [7:0] next_acc;
    reg next_carry;
    reg next_halted;
    reg next_data_out;

    // Initialize signals on reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            acc <= 8'h00;
            pc <= 8'h00;
            data_out <= 8'h00;
            carry <= 1'b0;
            halted <= 1'b0;
        end else begin
            if (enable && !halted) begin
                // Extract immediate value
                imm = instruction[3:0];
                imm = {instruction[7:4], imm}; // Sign-extend to 8 bits

                case (instruction[7:4])
                    8'h00: begin // NOP
                        next_pc = pc + 1;
                        next_acc = acc;
                        next_carry = carry;
                        next_data_out = data_out;
                        next_halted = halted;
                    end
                    8'h01: begin // LDI
                        next_acc = imm;
                        next_pc = pc + 1;
                        next_carry = carry;
                        next_data_out = data_out;
                        next_halted = halted;
                    end
                    8'h02: begin // ADD
                        next_acc = acc + imm;
                        next_carry = (acc + imm) > 8'hFF;
                        next_pc = pc + 1;
                        next_data_out = data_out;
                        next_halted = halted;
                    end
                    8'h03: begin // XOR
                        next_acc = acc ^ imm;
                        next_carry = carry;
                        next_pc = pc + 1;
                        next_data_out = data_out;
                        next_halted = halted;
                    end
                    8'h04: begin // AND
                        next_acc = acc & imm;
                        next_carry = carry;
                        next_pc = pc + 1;
                        next_data_out = data_out;
                        next_halted = halted;
                    end
                    8'h05: begin // JMP
                        next_pc = imm;
                        next_acc = acc;
                        next_carry = carry;
                        next_data_out = data_out;
                        next_halted = halted;
                    end
                    8'h06: begin // JZ
                        if (acc == 8'h00) begin
                            next_pc = imm;
                        end else begin
                            next_pc = pc + 1;
                        end
                        next_acc = acc;
                        next_carry = carry;
                        next_data_out = data_out;
                        next_halted = halted;
                    end
                    8'h07: begin // OUT
                        next_data_out = acc;
                        next_pc = pc + 1;
                        next_acc = acc;
                        next_carry = carry;
                        next_halted = halted;
                    end
                    8'h08: begin // HLT
                        next_halted = 1'b1;
                        next_pc = pc;
                        next_acc = acc;
                        next_carry = carry;
                        next_data_out = data_out;
                    end
                    default: begin // NOP for opcodes 9-15
                        next_pc = pc + 1;
                        next_acc = acc;
                        next_carry = carry;
                        next_data_out = data_out;
                        next_halted = halted;
                    end
                endcase
            end else begin
                // No change on enable low or halted high
                next_acc = acc;
                next_pc = pc;
                next_carry = carry;
                next_data_out = data_out;
                next_halted = halted;
            end
        end
    end

    // Assign next values to current registers
    always @(posedge clk) begin
        acc <= next_acc;
        pc <= next_pc;
        data_out <= next_data_out;
        carry <= next_carry;
        halted <= next_halted;
    end

endmodule
