// =============================================================================
// tb_rv32i_decoder.sv  --  iverilog-compatible (tested with iverilog 12, -g2012)
//
//   iverilog -g2012 -o sim tb_rv32i_decoder.sv rv32i_decoder.sv && vvp sim
//
// Self-checking testbench for a combinational RV32I instruction decoder.
//   1. Encoder self-test   : hand-assembled words vs. the TB encoders
//   2. Directed tests      : all 40 RV32I instructions (incl. FENCE/ECALL/EBREAK)
//   3. Immediate sweeps    : boundary values for I/S/B/J/U + walking-one bit flips
//   4. Field sweep         : every (opcode, funct3, funct7) combination
//   5. Constrained random
//   Expected values come from an independent reference model (task model()).
//   Fields an instruction doesn't use (e.g. rs2 on ADDI) are not checked.
//
// DUT interface assumed (edit the instance below to match yours):
//   module rv32i_decoder (
//     input  [31:0] instr,
//     output [4:0]  rs1, rs2, rd,
//     output [2:0]  funct3,
//     output [31:0] imm,
//     output        reg_write, mem_read, mem_write,
//     output        alu_src_a_pc,    // 1: ALU operand A = PC (AUIPC)
//     output        alu_src_b_imm,   // 1: ALU operand B = imm
//     output        branch, jal, jalr,
//     output [3:0]  alu_op,          // {funct7[5], funct3}
//     output        illegal );
// =============================================================================
`timescale 1ns/1ps

module tb_rv32i_decoder;

  // ---------------------------------------------------------------------------
  // Configuration
  // ---------------------------------------------------------------------------
  // ALU op = {funct7[5], funct3}; the extra bit distinguishes ADD/SUB, SRL/SRA
  localparam [3:0] ALU_ADD  = {1'b0, 3'b000};
  localparam [3:0] ALU_SUB  = {1'b1, 3'b000};
  localparam [3:0] ALU_SLL  = {1'b0, 3'b001};
  localparam [3:0] ALU_SLT  = {1'b0, 3'b010};
  localparam [3:0] ALU_SLTU = {1'b0, 3'b011};
  localparam [3:0] ALU_XOR  = {1'b0, 3'b100};
  localparam [3:0] ALU_SRL  = {1'b0, 3'b101};
  localparam [3:0] ALU_SRA  = {1'b1, 3'b101};
  localparam [3:0] ALU_OR   = {1'b0, 3'b110};
  localparam [3:0] ALU_AND  = {1'b0, 3'b111};

  // The ALU enum has no "pass B" op, so how LUI uses the ALU is design-specific
  // (e.g. ADD with operand A forced to 0). Off by default; set to 1 and set
  // LUI_ALU_OP if you want alu_op / alu_src_* checked for LUI too.
  localparam CHECK_LUI_ALU = 0;
  localparam [3:0] LUI_ALU_OP = ALU_ADD;

  // 1: imm for SLLI/SRLI/SRAI is the zero-extended 5-bit shamt
  // 0: imm is the plain sign-extended I-immediate (includes the funct7 bits)
  localparam SHIFT_IMM_IS_SHAMT = 1;

  localparam N_RANDOM = 20000;

  // ---------------------------------------------------------------------------
  // Opcodes
  // ---------------------------------------------------------------------------
  localparam [6:0] OP_LUI    = 7'b0110111;
  localparam [6:0] OP_AUIPC  = 7'b0010111;
  localparam [6:0] OP_JAL    = 7'b1101111;
  localparam [6:0] OP_JALR   = 7'b1100111;
  localparam [6:0] OP_BRANCH = 7'b1100011;
  localparam [6:0] OP_LOAD   = 7'b0000011;
  localparam [6:0] OP_STORE  = 7'b0100011;
  localparam [6:0] OP_IMM    = 7'b0010011;
  localparam [6:0] OP_REG    = 7'b0110011;
  localparam [6:0] OP_FENCE  = 7'b0001111;
  localparam [6:0] OP_SYSTEM = 7'b1110011;

  // Instruction ids (coverage + names)
  localparam ID_ILLEGAL = 40;

  // ---------------------------------------------------------------------------
  // DUT
  // ---------------------------------------------------------------------------
  reg  [31:0] instr;
  wire [4:0]  rs1, rs2, rd;
  wire [2:0]  funct3;
  wire [31:0] imm;
  wire        reg_write, mem_read, mem_write;
  wire        alu_src_a_pc, alu_src_b_imm;
  wire        branch, jal, jalr;
  wire [3:0]  alu_op;
  wire        illegal;

  rv32i_decoder dut (
    .instr         (instr),
    .rs1           (rs1),
    .rs2           (rs2),
    .rd            (rd),
    .funct3        (funct3),
    .imm           (imm),
    .reg_write     (reg_write),
    .mem_read      (mem_read),
    .mem_write     (mem_write),
    .alu_src_a_pc  (alu_src_a_pc),
    .alu_src_b_imm (alu_src_b_imm),
    .branch        (branch),
    .jal           (jal),
    .jalr          (jalr),
    .alu_op        (alu_op),
    .illegal       (illegal)
  );

  // ---------------------------------------------------------------------------
  // Immediate extraction (reference)
  // ---------------------------------------------------------------------------
  function [31:0] imm_i(input [31:0] i);
    imm_i = {{20{i[31]}}, i[31:20]};
  endfunction
  function [31:0] imm_s(input [31:0] i);
    imm_s = {{20{i[31]}}, i[31:25], i[11:7]};
  endfunction
  function [31:0] imm_b(input [31:0] i);
    imm_b = {{19{i[31]}}, i[31], i[7], i[30:25], i[11:8], 1'b0};
  endfunction
  function [31:0] imm_u(input [31:0] i);
    imm_u = {i[31:12], 12'b0};
  endfunction
  function [31:0] imm_j(input [31:0] i);
    imm_j = {{11{i[31]}}, i[31], i[19:12], i[20], i[30:21], 1'b0};
  endfunction

  // ---------------------------------------------------------------------------
  // Encoders
  // ---------------------------------------------------------------------------
  function [31:0] enc_r(input [6:0] f7, input [4:0] s2, input [4:0] s1,
                        input [2:0] f3, input [4:0] d, input [6:0] op);
    enc_r = {f7, s2, s1, f3, d, op};
  endfunction

  function [31:0] enc_i(input [11:0] im, input [4:0] s1, input [2:0] f3,
                        input [4:0] d, input [6:0] op);
    enc_i = {im, s1, f3, d, op};
  endfunction

  function [31:0] enc_s(input [11:0] im, input [4:0] s2, input [4:0] s1,
                        input [2:0] f3);
    enc_s = {im[11:5], s2, s1, f3, im[4:0], OP_STORE};
  endfunction

  function [31:0] enc_b(input [12:0] im, input [4:0] s2, input [4:0] s1,
                        input [2:0] f3);
    enc_b = {im[12], im[10:5], s2, s1, f3, im[4:1], im[11], OP_BRANCH};
  endfunction

  function [31:0] enc_u(input [19:0] im, input [4:0] d, input [6:0] op);
    enc_u = {im, d, op};
  endfunction

  function [31:0] enc_j(input [20:0] im, input [4:0] d);
    enc_j = {im[20], im[10:1], im[11], im[19:12], d, OP_JAL};
  endfunction

  // ---------------------------------------------------------------------------
  // Reference model: results land in the e_* regs
  // ---------------------------------------------------------------------------
  reg        e_illegal;
  reg        e_use_rs1, e_use_rs2, e_use_rd, e_use_f3, e_use_imm;
  reg [31:0] e_imm;
  reg        e_reg_write, e_mem_read, e_mem_write;
  reg        e_branch, e_jal, e_jalr;
  reg        e_check_alu, e_src_a_pc, e_src_b_imm;
  reg [3:0]  e_alu_op;
  integer    e_id;

  task model(input [31:0] i);
    reg [6:0] op;
    reg [2:0] f3;
    reg [6:0] f7;
    begin
      op = i[6:0];
      f3 = i[14:12];
      f7 = i[31:25];

      e_illegal = 1'b1;
      e_use_rs1 = 0; e_use_rs2 = 0; e_use_rd = 0; e_use_f3 = 0; e_use_imm = 0;
      e_imm = 32'd0;
      e_reg_write = 0; e_mem_read = 0; e_mem_write = 0;
      e_branch = 0; e_jal = 0; e_jalr = 0;
      e_check_alu = 0; e_src_a_pc = 0; e_src_b_imm = 0;
      e_alu_op = 4'd0;
      e_id = ID_ILLEGAL;

      case (op)
        OP_LUI: begin
          e_illegal = 0; e_id = 0; e_use_rd = 1; e_use_imm = 1; e_imm = imm_u(i);
          e_reg_write = 1;
          if (CHECK_LUI_ALU) begin
            e_check_alu = 1; e_src_b_imm = 1; e_alu_op = LUI_ALU_OP;
          end
        end
        OP_AUIPC: begin
          e_illegal = 0; e_id = 1; e_use_rd = 1; e_use_imm = 1; e_imm = imm_u(i);
          e_reg_write = 1;
          e_check_alu = 1; e_src_a_pc = 1; e_src_b_imm = 1; e_alu_op = ALU_ADD;
        end
        OP_JAL: begin
          e_illegal = 0; e_id = 2; e_use_rd = 1; e_use_imm = 1; e_imm = imm_j(i);
          e_reg_write = 1; e_jal = 1;
        end
        OP_JALR: begin
          if (f3 == 3'b000) begin
            e_illegal = 0; e_id = 3; e_use_rs1 = 1; e_use_rd = 1; e_use_f3 = 1;
            e_use_imm = 1; e_imm = imm_i(i); e_reg_write = 1; e_jalr = 1;
          end
        end
        OP_BRANCH: begin
          if (f3 != 3'b010 && f3 != 3'b011) begin
            e_illegal = 0; e_use_rs1 = 1; e_use_rs2 = 1; e_use_f3 = 1; e_use_imm = 1;
            e_imm = imm_b(i); e_branch = 1;
            case (f3)
              3'b000: e_id = 4;   // BEQ
              3'b001: e_id = 5;   // BNE
              3'b100: e_id = 6;   // BLT
              3'b101: e_id = 7;   // BGE
              3'b110: e_id = 8;   // BLTU
              default: e_id = 9;  // BGEU
            endcase
          end
        end
        OP_LOAD: begin
          if (f3 == 3'b000 || f3 == 3'b001 || f3 == 3'b010 ||
              f3 == 3'b100 || f3 == 3'b101) begin
            e_illegal = 0; e_use_rs1 = 1; e_use_rd = 1; e_use_f3 = 1; e_use_imm = 1;
            e_imm = imm_i(i); e_reg_write = 1; e_mem_read = 1;
            e_check_alu = 1; e_src_b_imm = 1; e_alu_op = ALU_ADD;
            case (f3)
              3'b000: e_id = 10;  // LB
              3'b001: e_id = 11;  // LH
              3'b010: e_id = 12;  // LW
              3'b100: e_id = 13;  // LBU
              default: e_id = 14; // LHU
            endcase
          end
        end
        OP_STORE: begin
          if (f3 == 3'b000 || f3 == 3'b001 || f3 == 3'b010) begin
            e_illegal = 0; e_use_rs1 = 1; e_use_rs2 = 1; e_use_f3 = 1; e_use_imm = 1;
            e_imm = imm_s(i); e_mem_write = 1;
            e_check_alu = 1; e_src_b_imm = 1; e_alu_op = ALU_ADD;
            case (f3)
              3'b000: e_id = 15;  // SB
              3'b001: e_id = 16;  // SH
              default: e_id = 17; // SW
            endcase
          end
        end
        OP_IMM: begin
          e_illegal = 0;
          e_use_rs1 = 1; e_use_rd = 1; e_use_f3 = 1; e_use_imm = 1;
          e_imm = imm_i(i); e_reg_write = 1; e_check_alu = 1; e_src_b_imm = 1;
          case (f3)
            3'b000: begin e_id = 18; e_alu_op = ALU_ADD;  end  // ADDI
            3'b010: begin e_id = 19; e_alu_op = ALU_SLT;  end  // SLTI
            3'b011: begin e_id = 20; e_alu_op = ALU_SLTU; end  // SLTIU
            3'b100: begin e_id = 21; e_alu_op = ALU_XOR;  end  // XORI
            3'b110: begin e_id = 22; e_alu_op = ALU_OR;   end  // ORI
            3'b111: begin e_id = 23; e_alu_op = ALU_AND;  end  // ANDI
            3'b001: begin                                       // SLLI
              e_id = 24; e_alu_op = ALU_SLL;
              if (f7 != 7'b0000000) e_illegal = 1;
              if (SHIFT_IMM_IS_SHAMT) e_imm = {27'b0, i[24:20]};
            end
            3'b101: begin                                       // SRLI / SRAI
              if (f7 == 7'b0000000)      begin e_id = 25; e_alu_op = ALU_SRL; end
              else if (f7 == 7'b0100000) begin e_id = 26; e_alu_op = ALU_SRA; end
              else                       e_illegal = 1;
              if (SHIFT_IMM_IS_SHAMT) e_imm = {27'b0, i[24:20]};
            end
          endcase
        end
        OP_REG: begin
          e_use_rs1 = 1; e_use_rs2 = 1; e_use_rd = 1; e_use_f3 = 1;
          e_reg_write = 1; e_check_alu = 1; e_src_b_imm = 0;
          if (f7 == 7'b0000000) begin
            e_illegal = 0;
            case (f3)
              3'b000: begin e_id = 27; e_alu_op = ALU_ADD;  end
              3'b001: begin e_id = 29; e_alu_op = ALU_SLL;  end
              3'b010: begin e_id = 30; e_alu_op = ALU_SLT;  end
              3'b011: begin e_id = 31; e_alu_op = ALU_SLTU; end
              3'b100: begin e_id = 32; e_alu_op = ALU_XOR;  end
              3'b101: begin e_id = 33; e_alu_op = ALU_SRL;  end
              3'b110: begin e_id = 35; e_alu_op = ALU_OR;   end
              3'b111: begin e_id = 36; e_alu_op = ALU_AND;  end
            endcase
          end else if (f7 == 7'b0100000) begin
            if (f3 == 3'b000)      begin e_illegal = 0; e_id = 28; e_alu_op = ALU_SUB; end
            else if (f3 == 3'b101) begin e_illegal = 0; e_id = 34; e_alu_op = ALU_SRA; end
          end
        end
        OP_FENCE: begin
          // only funct3 == 0 is base RV32I (FENCE.I belongs to Zifencei)
          if (f3 == 3'b000) begin e_illegal = 0; e_id = 37; end
        end
        OP_SYSTEM: begin
          // only ECALL / EBREAK are base RV32I (CSR ops belong to Zicsr)
          if (i == 32'h0000_0073) begin e_illegal = 0; e_id = 38; end
          if (i == 32'h0010_0073) begin e_illegal = 0; e_id = 39; end
        end
        default: ;
      endcase

      // an illegal instruction carries no control side effects
      if (e_illegal) begin
        e_use_rs1 = 0; e_use_rs2 = 0; e_use_rd = 0; e_use_f3 = 0; e_use_imm = 0;
        e_imm = 32'd0;
        e_reg_write = 0; e_mem_read = 0; e_mem_write = 0;
        e_branch = 0; e_jal = 0; e_jalr = 0;
        e_check_alu = 0; e_src_a_pc = 0; e_src_b_imm = 0; e_alu_op = 4'd0;
        e_id = ID_ILLEGAL;
      end
    end
  endtask

  function [8*7-1:0] name_of(input integer id);
    case (id)
      0: name_of = "LUI";    1: name_of = "AUIPC";  2: name_of = "JAL";
      3: name_of = "JALR";   4: name_of = "BEQ";    5: name_of = "BNE";
      6: name_of = "BLT";    7: name_of = "BGE";    8: name_of = "BLTU";
      9: name_of = "BGEU";  10: name_of = "LB";    11: name_of = "LH";
     12: name_of = "LW";    13: name_of = "LBU";   14: name_of = "LHU";
     15: name_of = "SB";    16: name_of = "SH";    17: name_of = "SW";
     18: name_of = "ADDI";  19: name_of = "SLTI";  20: name_of = "SLTIU";
     21: name_of = "XORI";  22: name_of = "ORI";   23: name_of = "ANDI";
     24: name_of = "SLLI";  25: name_of = "SRLI";  26: name_of = "SRAI";
     27: name_of = "ADD";   28: name_of = "SUB";   29: name_of = "SLL";
     30: name_of = "SLT";   31: name_of = "SLTU";  32: name_of = "XOR";
     33: name_of = "SRL";   34: name_of = "SRA";   35: name_of = "OR";
     36: name_of = "AND";   37: name_of = "FENCE"; 38: name_of = "ECALL";
     39: name_of = "EBREAK";
     default: name_of = "ILLEGAL";
    endcase
  endfunction

  // ---------------------------------------------------------------------------
  // Checker
  // ---------------------------------------------------------------------------
  integer errors;
  integer checks;
  integer hits [0:40];

  task mismatch(input [31:0] i, input [8*9-1:0] what,
                input [31:0] got, input [31:0] expd);
    begin
      errors = errors + 1;
      if (errors <= 50)
        $display("[%0t] FAIL expect=%0s instr=%h field=%0s got=%h exp=%h",
                 $time, name_of(e_id), i, what, got, expd);
    end
  endtask

  task check(input [31:0] i);
    begin
      instr = i;
      #1;
      model(i);
      checks = checks + 1;
      if (!e_illegal) hits[e_id] = hits[e_id] + 1;

      if (illegal   !== e_illegal)   mismatch(i, "illegal",   illegal,   e_illegal);
      if (reg_write !== e_reg_write) mismatch(i, "reg_write", reg_write, e_reg_write);
      if (mem_read  !== e_mem_read)  mismatch(i, "mem_read",  mem_read,  e_mem_read);
      if (mem_write !== e_mem_write) mismatch(i, "mem_write", mem_write, e_mem_write);
      if (branch    !== e_branch)    mismatch(i, "branch",    branch,    e_branch);
      if (jal       !== e_jal)       mismatch(i, "jal",       jal,       e_jal);
      if (jalr      !== e_jalr)      mismatch(i, "jalr",      jalr,      e_jalr);

      if (e_use_rs1 && rs1    !== i[19:15]) mismatch(i, "rs1",    rs1,    i[19:15]);
      if (e_use_rs2 && rs2    !== i[24:20]) mismatch(i, "rs2",    rs2,    i[24:20]);
      if (e_use_rd  && rd     !== i[11:7])  mismatch(i, "rd",     rd,     i[11:7]);
      if (e_use_f3  && funct3 !== i[14:12]) mismatch(i, "funct3", funct3, i[14:12]);
      if (e_use_imm && imm    !== e_imm)    mismatch(i, "imm",    imm,    e_imm);

      if (e_check_alu) begin
        if (alu_op        !== e_alu_op)     mismatch(i, "alu_op",    alu_op,        e_alu_op);
        if (alu_src_b_imm !== e_src_b_imm)  mismatch(i, "src_b_imm", alu_src_b_imm, e_src_b_imm);
        if (alu_src_a_pc  !== e_src_a_pc)   mismatch(i, "src_a_pc",  alu_src_a_pc,  e_src_a_pc);
      end
    end
  endtask

  // ---------------------------------------------------------------------------
  // Test sections
  // ---------------------------------------------------------------------------
  integer n, k, f, b, op_i, f3_i, f7_i;

  // 1. Encoders vs hand-assembled words (guards against a wrong model/encoder)
  task encoder_selftest;
    integer bad;
    begin
      bad = 0;
      if (enc_i(12'd5, 5'd0, 3'b000, 5'd1, OP_IMM)         !== 32'h0050_0093) bad = bad + 1; // addi x1,x0,5
      if (enc_r(7'h00, 5'd2, 5'd1, 3'b000, 5'd3, OP_REG)   !== 32'h0020_81B3) bad = bad + 1; // add  x3,x1,x2
      if (enc_r(7'h20, 5'd2, 5'd1, 3'b000, 5'd3, OP_REG)   !== 32'h4020_81B3) bad = bad + 1; // sub  x3,x1,x2
      if (enc_i({7'h20, 5'd3}, 5'd1, 3'b101, 5'd1, OP_IMM) !== 32'h4030_D093) bad = bad + 1; // srai x1,x1,3
      if (enc_i(12'd8, 5'd2, 3'b010, 5'd5, OP_LOAD)        !== 32'h0081_2283) bad = bad + 1; // lw   x5,8(x2)
      if (enc_s(12'd8, 5'd5, 5'd2, 3'b010)                 !== 32'h0051_2423) bad = bad + 1; // sw   x5,8(x2)
      if (enc_b(13'd8, 5'd2, 5'd1, 3'b000)                 !== 32'h0020_8463) bad = bad + 1; // beq  x1,x2,+8
      if (enc_u(20'h12345, 5'd5, OP_LUI)                   !== 32'h1234_52B7) bad = bad + 1; // lui  x5,0x12345
      if (enc_j(21'd0, 5'd1)                               !== 32'h0000_00EF) bad = bad + 1; // jal  x1,0
      if (enc_i(12'd0, 5'd1, 3'b000, 5'd0, OP_JALR)        !== 32'h0000_8067) bad = bad + 1; // jalr x0,0(x1)
      if (bad != 0) begin
        $display("TB BUG: %0d encoder self-test mismatches", bad);
        errors = errors + bad;
      end
    end
  endtask

  // 2. Directed: every RV32I instruction, several register/immediate combos
  reg [4:0]  ra, rb, rc;
  reg [11:0] im;
  reg [2:0]  f3v;

  task directed_all;
    begin
      for (k = 0; k < 4; k = k + 1) begin
        case (k)
          0: begin ra = 5'd1;  rb = 5'd2;  rc = 5'd3;  im = 12'h001; end
          1: begin ra = 5'd31; rb = 5'd30; rc = 5'd29; im = 12'h7FF; end
          2: begin ra = 5'd0;  rb = 5'd0;  rc = 5'd0;  im = 12'h800; end
          default: begin ra = $urandom; rb = $urandom; rc = $urandom; im = $urandom; end
        endcase

        check(enc_u({im, 8'hA5}, rc, OP_LUI));
        check(enc_u({im, 8'h5A}, rc, OP_AUIPC));
        check(enc_j({im[11], 9'h0AB, im[10:0]} & ~21'd1, rc));
        check(enc_i(im, ra, 3'b000, rc, OP_JALR));

        for (f = 0; f < 8; f = f + 1) begin
          f3v = f;
          check(enc_b({im, 1'b0}, rb, ra, f3v));        // BEQ..BGEU (funct3 2,3 illegal)
          check(enc_i(im, ra, f3v, rc, OP_LOAD));       // LB..LHU   (3,6,7 illegal)
          check(enc_s(im, rb, ra, f3v));                // SB..SW    (3..7 illegal)
          if (f != 1 && f != 5) check(enc_i(im, ra, f3v, rc, OP_IMM));
          check(enc_r(7'h00, rb, ra, f3v, rc, OP_REG));
          check(enc_r(7'h20, rb, ra, f3v, rc, OP_REG)); // SUB / SRA (rest illegal)
        end
        check(enc_i({7'h00, im[4:0]}, ra, 3'b001, rc, OP_IMM));  // SLLI
        check(enc_i({7'h00, im[4:0]}, ra, 3'b101, rc, OP_IMM));  // SRLI
        check(enc_i({7'h20, im[4:0]}, ra, 3'b101, rc, OP_IMM));  // SRAI

        check({4'b0000, 4'b1111, 4'b1111, ra, 3'b000, rc, OP_FENCE});      // FENCE iorw,iorw
        check({4'b1000, 4'b0011, 4'b0011, 5'd0, 3'b000, 5'd0, OP_FENCE});  // FENCE.TSO
      end
      check(32'h0000_0073);   // ECALL
      check(32'h0010_0073);   // EBREAK
      check(32'h0000_0013);   // NOP (addi x0,x0,0)
    end
  endtask

  // 3. Immediate boundary sweeps
  reg [11:0] v12 [0:7];
  reg [12:0] v13 [0:7];
  reg [20:0] v21 [0:7];
  reg [19:0] v20 [0:5];
  reg [31:0] w;

  task imm_sweeps;
    begin
      v12[0] = 12'h000; v12[1] = 12'h001; v12[2] = 12'h7FF; v12[3] = 12'h800;
      v12[4] = 12'hFFF; v12[5] = 12'h555; v12[6] = 12'hAAA; v12[7] = 12'h0FE;
      v13[0] = 13'h0000; v13[1] = 13'h0002; v13[2] = 13'h0FFE; v13[3] = 13'h1000;
      v13[4] = 13'h1FFE; v13[5] = 13'h0AAA; v13[6] = 13'h1554; v13[7] = 13'h07FE;
      v21[0] = 21'h000000; v21[1] = 21'h000002; v21[2] = 21'h0FFFFE; v21[3] = 21'h100000;
      v21[4] = 21'h1FFFFE; v21[5] = 21'h0AAAAA; v21[6] = 21'h155554; v21[7] = 21'h0007FE;
      v20[0] = 20'h00000; v20[1] = 20'h00001; v20[2] = 20'h7FFFF;
      v20[3] = 20'h80000; v20[4] = 20'hFFFFF; v20[5] = 20'hA5A5A;

      for (n = 0; n < 8; n = n + 1) begin
        check(enc_i(v12[n], 5'd7, 3'b000, 5'd9, OP_IMM));
        check(enc_i(v12[n], 5'd7, 3'b010, 5'd9, OP_LOAD));
        check(enc_i(v12[n], 5'd7, 3'b000, 5'd9, OP_JALR));
        check(enc_s(v12[n], 5'd6, 5'd7, 3'b010));
        check(enc_b(v13[n], 5'd6, 5'd7, 3'b001));
        check(enc_j(v21[n], 5'd1));
      end
      for (n = 0; n < 6; n = n + 1) begin
        check(enc_u(v20[n], 5'd8, OP_LUI));
        check(enc_u(v20[n], 5'd8, OP_AUIPC));
      end
      // walking one through the bits that carry operands / immediates
      for (b = 7; b < 32; b = b + 1) begin
        w = 32'd1 << b;
        check(enc_i(12'd0, 5'd1, 3'b000, 5'd1, OP_IMM)  | w);
        check(enc_i(12'd0, 5'd1, 3'b000, 5'd1, OP_JALR) | w);
        check(enc_b(13'd0, 5'd1, 5'd1, 3'b000)          | w);
        check(enc_j(21'd0, 5'd1)                        | w);
      end
    end
  endtask

  // 4. Every (opcode, funct3, funct7) combination -> legality + controls
  reg [6:0] t_op, t_f7;
  reg [2:0] t_f3;

  task field_sweep;
    begin
      for (op_i = 0; op_i < 128; op_i = op_i + 1)
        for (f3_i = 0; f3_i < 8; f3_i = f3_i + 1)
          for (f7_i = 0; f7_i < 128; f7_i = f7_i + 1) begin
            t_op = op_i; t_f3 = f3_i; t_f7 = f7_i;
            ra = $urandom; rb = $urandom; rc = $urandom;
            check({t_f7, rb, ra, t_f3, rc, t_op});
          end
    end
  endtask

  // 5. Constrained random
  reg [6:0] ops [0:10];

  task random_test;
    begin
      ops[0] = OP_LUI;    ops[1] = OP_AUIPC;  ops[2] = OP_JAL;   ops[3] = OP_JALR;
      ops[4] = OP_BRANCH; ops[5] = OP_LOAD;   ops[6] = OP_STORE; ops[7] = OP_IMM;
      ops[8] = OP_REG;    ops[9] = OP_FENCE;  ops[10] = OP_SYSTEM;
      for (n = 0; n < N_RANDOM; n = n + 1) begin
        w = $urandom;
        case ($urandom % 4)
          0: ;                                    // fully random word
          1: w[6:0] = ops[$urandom % 11];         // legal opcode, random rest
          2: w[1:0] = 2'b11;                      // 32-bit-looking encodings
          default: begin                          // legal opcode, tame funct7
            w[6:0]   = ops[$urandom % 11];
            w[31:25] = ($urandom % 2) ? 7'h00 : 7'h20;
          end
        endcase
        check(w);
      end
      // all-zeros / all-ones / compressed-looking words must be illegal
      check(32'h0000_0000);
      check(32'hFFFF_FFFF);
      check(32'h0000_4501);
    end
  endtask

  // ---------------------------------------------------------------------------
  // Main
  // ---------------------------------------------------------------------------
  integer missing, id;

  initial begin
    errors = 0; checks = 0; missing = 0;
    for (id = 0; id <= 40; id = id + 1) hits[id] = 0;
    instr = 32'd0;
    #1;

    encoder_selftest;
    directed_all;
    imm_sweeps;
    field_sweep;
    random_test;

    for (id = 0; id < 40; id = id + 1)
      if (hits[id] == 0) begin
        $display("COVERAGE HOLE: %0s never exercised", name_of(id));
        missing = missing + 1;
      end

    $display("--------------------------------------------------");
    $display("checks=%0d  errors=%0d  uncovered=%0d", checks, errors, missing);
    if (errors == 0 && missing == 0) $display("*** TEST PASSED ***");
    else                             $display("*** TEST FAILED ***");
    $finish;
  end

  // watchdog
  initial begin
    #100_000_000;
    $display("*** TIMEOUT ***");
    $finish;
  end

endmodule
