`timescale 1ns/1ps

// Self-checking exhaustive testbench for an 8-bit ALU.
//
// DUT interface:
//   module alu (
//     input  [7:0] A, B,
//     input  [2:0] opcode,   // 000 ADD, 001 SUB, 010 AND, 011 OR,
//                            // 100 XOR, 101 SLL, 110 SRL, 111 NOT
//     output [7:0] Y,
//     output       carry,
//     output       zero
//   );
//
// Conventions checked:
//   ADD       : carry = carry-out of A + B
//   SUB       : carry = borrow (1 when A < B); set SUB_CARRY_IS_NO_BORROW = 1
//               if your ALU uses A + ~B + 1 and reports its carry-out instead
//   AND/OR/XOR: carry = 0
//   NOT       : Y = ~A (B is ignored), carry = 0
//   Shifts    : shift amount = B[2:0]; Y shifts A
//               SHIFT_CARRY_MODE = 0 -> carry must be 0
//                                  1 -> carry = last bit shifted out (0 if amount is 0)
//                                  2 -> carry is not checked for shifts
//   zero      : 1 when Y == 0, for every operation

module alu_tb;

    localparam [2:0] OP_ADD = 3'b000,
                     OP_SUB = 3'b001,
                     OP_AND = 3'b010,
                     OP_OR  = 3'b011,
                     OP_XOR = 3'b100,
                     OP_SLL = 3'b101,
                     OP_SRL = 3'b110,
                     OP_NOT = 3'b111;

    localparam SUB_CARRY_IS_NO_BORROW = 0;
    localparam SHIFT_CARRY_MODE       = 0;

    reg  [7:0] A, B;
    reg  [2:0] opcode;
    wire [7:0] Y;
    wire       carry, zero;

    integer errors = 0;
    integer checks = 0;

    alu dut (
        .A      (A),
        .B      (B),
        .opcode (opcode),
        .Y      (Y),
        .carry  (carry),
        .zero   (zero)
    );

    // Reference model
    reg [8:0] exp_full;
    reg [7:0] exp_y;
    reg       exp_carry;
    reg       exp_zero;
    reg       check_carry;
    reg [2:0] shamt;

    task compute_expected;
        input [7:0] a;
        input [7:0] b;
        input [2:0] op;
        begin
            exp_carry   = 1'b0;
            check_carry = 1'b1;
            shamt       = b[2:0];
            case (op)
                OP_ADD: begin
                    exp_full  = {1'b0, a} + {1'b0, b};
                    exp_y     = exp_full[7:0];
                    exp_carry = exp_full[8];
                end
                OP_SUB: begin
                    exp_full  = {1'b0, a} - {1'b0, b};
                    exp_y     = exp_full[7:0];
                    exp_carry = SUB_CARRY_IS_NO_BORROW ? ~exp_full[8] : exp_full[8];
                end
                OP_AND: exp_y = a & b;
                OP_OR : exp_y = a | b;
                OP_XOR: exp_y = a ^ b;
                OP_SLL: begin
                    exp_y = a << shamt;
                    if (SHIFT_CARRY_MODE == 1)
                        exp_carry = (shamt == 0) ? 1'b0 : a[8 - shamt];
                    if (SHIFT_CARRY_MODE == 2) check_carry = 1'b0;
                end
                OP_SRL: begin
                    exp_y = a >> shamt;
                    if (SHIFT_CARRY_MODE == 1)
                        exp_carry = (shamt == 0) ? 1'b0 : a[shamt - 1];
                    if (SHIFT_CARRY_MODE == 2) check_carry = 1'b0;
                end
                OP_NOT: exp_y = ~a;
                default: exp_y = 8'bx;
            endcase
            exp_zero = (exp_y == 8'h00);
        end
    endtask

    task check;
        input [7:0] a;
        input [7:0] b;
        input [2:0] op;
        begin
            A = a; B = b; opcode = op;
            #1;
            compute_expected(a, b, op);
            checks = checks + 1;
            if (Y !== exp_y || zero !== exp_zero ||
                (check_carry && carry !== exp_carry)) begin
                errors = errors + 1;
                if (errors <= 50)
                    $display("FAIL t=%0t op=%b A=%h B=%h | got Y=%h C=%b Z=%b | exp Y=%h C=%b Z=%b",
                             $time, op, a, b, Y, carry, zero, exp_y, exp_carry, exp_zero);
            end
        end
    endtask

    integer i, j, k;

    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);

        // Directed corner cases
        check(8'h00, 8'h00, OP_ADD);   // zero result
        check(8'hFF, 8'h01, OP_ADD);   // carry out, wraps to zero
        check(8'hFF, 8'hFF, OP_ADD);   // max + max
        check(8'h7F, 8'h01, OP_ADD);   // signed overflow boundary
        check(8'h55, 8'h55, OP_SUB);   // equal -> zero, no borrow
        check(8'h00, 8'h01, OP_SUB);   // borrow, wraps to FF
        check(8'h80, 8'h01, OP_SUB);
        check(8'hF0, 8'h0F, OP_AND);   // disjoint -> zero
        check(8'hAA, 8'h55, OP_OR);    // complementary -> FF
        check(8'hFF, 8'hFF, OP_XOR);   // identical -> zero
        check(8'h81, 8'h01, OP_SLL);   // MSB shifted out
        check(8'h81, 8'h07, OP_SLL);   // max shift amount
        check(8'h81, 8'h00, OP_SLL);   // zero shift amount
        check(8'h81, 8'h01, OP_SRL);   // LSB shifted out, zero fill
        check(8'h80, 8'h07, OP_SRL);
        check(8'h00, 8'h00, OP_NOT);   // -> FF
        check(8'hFF, 8'h00, OP_NOT);   // -> zero result
        check(8'hAA, 8'h00, OP_NOT);   // -> 55
        check(8'h55, 8'hFF, OP_NOT);   // B must be ignored

        // Exhaustive: every opcode x every A x every B (524,288 checks)
        for (k = 0; k < 8; k = k + 1)
            for (i = 0; i < 256; i = i + 1)
                for (j = 0; j < 256; j = j + 1)
                    check(i[7:0], j[7:0], k[2:0]);

        if (errors == 0)
            $display("PASS: %0d checks, 0 errors", checks);
        else
            $display("FAIL: %0d checks, %0d errors (first 50 shown)", checks, errors);
        $finish;
    end

endmodule
