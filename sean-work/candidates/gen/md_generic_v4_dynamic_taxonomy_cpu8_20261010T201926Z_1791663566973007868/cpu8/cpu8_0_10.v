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
            // Reset all registers to their initial state
            acc <= 8'h00;
            pc <= 8'h00;
            data_out <= 8'h00;
            carry <= 1'b0;
            halted <= 1'b0;
            imm <= 8'h00;
        end else begin
            if (enable && !halted) begin
                // Extract immediate value (zero-extended)
                imm = {4'b0000, instruction[3:0]};

                // Determine the opcode
                reg [3:0] opcode = instruction[7:4];

                // Execute the instruction
                case (opcode)
                    4'h0: begin // NOP
                        next_acc = acc;
                        next_pc = pc + 1;
                        next_carry = carry;
                        next_halted = halted;
                        next_data_out = data_out;
                    end
                    4'h1: begin // LDI
                        next_acc = imm;
                        next_pc = pc + 1;
                        next_carry = carry;
                        next_halted = halted;
                        next_data_out = data_out;
                    end
                    4'h2: begin // ADD
                        reg [9:0] result = acc + imm;
                        next_acc = result[7:0];
                        next_carry = result[8];
                        next_pc = pc + 1;
                        next_halted = halted;
                        next_data_out = data_out;
                    end
                    4'h3: begin // XOR
                        next_acc = acc ^ imm;
                        next_pc = pc + 1;
                        next_carry = carry;
                        next_halted = halted;
                        next_data_out = data_out;
                    end
                    4'h4: begin // AND
                        next_acc = acc & imm;
                        next_pc = pc + 1;
                        next_carry = carry;
                        next_halted = halted;
                        next_data_out = data_out;
                    end
                    4'h5: begin // JMP
                        next_pc = imm;
                        next_acc = acc;
                        next_carry = carry;
                        next_halted = halted;
                        next_data_out = data_out;
                    end
                    4'h6: begin // JZ
                        if (acc == 8'h00) begin
                            next_pc = imm;
                        end else begin
                            next_pc = pc + 1;
                        end
                        next_acc = acc;
                        next_carry = carry;
                        next_halted = halted;
                        next_data_out = data_out;
                    end
                    4'h7: begin // OUT
                        next_data_out = acc;
                        next_pc = pc + 1;
                        next_acc = acc;
                        next_carry = carry;
                        next_halted = halted;
                    end
                    4'h8: begin // HLT
                        next_halted = 1'b1;
                        next_pc = pc;
                        next_acc = acc;
                        next_carry = carry;
                        next_data_out = data_out;
                    end
                    default: begin // NOP for opcodes 9-15
                        next_acc = acc;
                        next_pc = pc + 1;
                        next_carry = carry;
                        next_halted = halted;
                        next_data_out = data_out;
                    end
                endcase
            end else begin
                // If enable is low or halted is high, retain current values
                next_acc = acc;
                next_pc = pc;
                next_carry = carry;
                next_halted = halted;
                next_data_out = data_out;
            end
        end
    end

    // Assign next values to current registers
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            acc <= 8'h00;
            pc <= 8'h00;
            data_out <= 8'h00;
            carry <= 1'b0;
            halted <= 1'b0;
        end else begin
            acc <= next_acc;
            pc <= next_pc;
            data_out <= next_data_out;
            carry <= next_carry;
            halted <= next_halted;
        end
    end

endmodule
