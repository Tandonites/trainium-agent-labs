// Reference RV32I decoder used to sanity-check tb_rv32i_decoder.sv.
// alu_op = {funct7[5], funct3}; the extra bit only matters for SUB / SRA.
// NOTE: LUI has no ALU op in the spec'd enum -- this version emits ADD with
// operand B = imm; a real core must also force operand A to 0 for LUI
// (e.g. via an extra select), which isn't part of this port list.
module rv32i_decoder (
  input      [31:0] instr,
  output reg [4:0]  rs1, rs2, rd,
  output reg [2:0]  funct3,
  output reg [31:0] imm,
  output reg        reg_write, mem_read, mem_write,
  output reg        alu_src_a_pc,
  output reg        alu_src_b_imm,
  output reg        branch, jal, jalr,
  output reg [3:0]  alu_op,
  output reg        illegal
);
  wire [6:0] opcode = instr[6:0];
  wire [2:0] f3     = instr[14:12];
  wire [6:0] f7     = instr[31:25];

  always @* begin
    rs1 = instr[19:15];
    rs2 = instr[24:20];
    rd  = instr[11:7];
    funct3 = f3;
    imm = 32'd0;
    reg_write = 0; mem_read = 0; mem_write = 0;
    alu_src_a_pc = 0; alu_src_b_imm = 0;
    branch = 0; jal = 0; jalr = 0;
    alu_op = 4'b0000;
    illegal = 1'b1;

    case (opcode)
      7'b0110111: begin // LUI
        illegal = 0; reg_write = 1; alu_src_b_imm = 1;
        imm = {instr[31:12], 12'b0};
      end
      7'b0010111: begin // AUIPC
        illegal = 0; reg_write = 1; alu_src_b_imm = 1; alu_src_a_pc = 1;
        imm = {instr[31:12], 12'b0};
      end
      7'b1101111: begin // JAL
        illegal = 0; reg_write = 1; jal = 1;
        imm = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
      end
      7'b1100111: begin // JALR
        if (f3 == 3'b000) begin
          illegal = 0; reg_write = 1; jalr = 1;
          imm = {{20{instr[31]}}, instr[31:20]};
        end
      end
      7'b1100011: begin // BRANCH
        if (f3 != 3'b010 && f3 != 3'b011) begin
          illegal = 0; branch = 1;
          imm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
        end
      end
      7'b0000011: begin // LOAD
        if (f3 == 3'b000 || f3 == 3'b001 || f3 == 3'b010 || f3 == 3'b100 || f3 == 3'b101) begin
          illegal = 0; reg_write = 1; mem_read = 1; alu_src_b_imm = 1;
          imm = {{20{instr[31]}}, instr[31:20]};
        end
      end
      7'b0100011: begin // STORE
        if (f3 == 3'b000 || f3 == 3'b001 || f3 == 3'b010) begin
          illegal = 0; mem_write = 1; alu_src_b_imm = 1;
          imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};
        end
      end
      7'b0010011: begin // OP-IMM
        illegal = 0; reg_write = 1; alu_src_b_imm = 1;
        imm = {{20{instr[31]}}, instr[31:20]};
        alu_op = {1'b0, f3};
        if (f3 == 3'b001) begin                 // SLLI
          if (f7 != 7'b0000000) illegal = 1;
          imm = {27'b0, instr[24:20]};
        end else if (f3 == 3'b101) begin        // SRLI / SRAI
          if (f7 == 7'b0000000)      alu_op = {1'b0, f3};
          else if (f7 == 7'b0100000) alu_op = {1'b1, f3};
          else                       illegal = 1;
          imm = {27'b0, instr[24:20]};
        end
      end
      7'b0110011: begin // OP
        reg_write = 1;
        alu_op = {f7[5], f3};
        if (f7 == 7'b0000000) illegal = 0;
        else if (f7 == 7'b0100000 && (f3 == 3'b000 || f3 == 3'b101)) illegal = 0;
      end
      7'b0001111: begin // FENCE
        if (f3 == 3'b000) illegal = 0;
      end
      7'b1110011: begin // SYSTEM: ECALL / EBREAK only
        if (instr == 32'h0000_0073 || instr == 32'h0010_0073) illegal = 0;
      end
      default: ;
    endcase

    if (illegal) begin
      imm = 32'd0;
      reg_write = 0; mem_read = 0; mem_write = 0;
      alu_src_a_pc = 0; alu_src_b_imm = 0;
      branch = 0; jal = 0; jalr = 0;
      alu_op = 4'b0000;
    end
  end
endmodule
