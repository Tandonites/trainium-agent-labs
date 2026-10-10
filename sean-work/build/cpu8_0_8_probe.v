`timescale 1ns/1ps
module probe;
  reg clk = 0;
  reg reset_n = 1;
  reg enable = 0;
  reg [7:0] instruction = 0;
  wire [7:0] acc;
  wire [7:0] _checker_ref_acc;
  wire [7:0] pc;
  wire [7:0] _checker_ref_pc;
  wire [7:0] data_out;
  wire [7:0] _checker_ref_data_out;
  wire carry;
  wire _checker_ref_carry;
  wire halted;
  wire _checker_ref_halted;
  cpu8 dut (.clk(clk), .reset_n(reset_n), .enable(enable), .instruction(instruction), .acc(acc), .pc(pc), .data_out(data_out), .carry(carry), .halted(halted));
  _checker_reference reference (.clk(clk), .reset_n(reset_n), .enable(enable), .instruction(instruction), .acc(_checker_ref_acc), .pc(_checker_ref_pc), .data_out(_checker_ref_data_out), .carry(_checker_ref_carry), .halted(_checker_ref_halted));
  initial begin
    #1 reset_n = 0;
    #1 
    $display("P 0 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #3 clk = 1;
    #1 
    $display("P 1 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #4 clk = 1;
    #1 
    $display("P 2 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 reset_n = 1;
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 3 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 4 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 5 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 6 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 7 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 8 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 9 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 10 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 11 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 12 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 13 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 14 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 15 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 16 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 17 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 18 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 19 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 20 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 21 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 22 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 23 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 24 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 25 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 26 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 27 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 28 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 29 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 30 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 31 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 32 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 33 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 34 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 35 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 36 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 37 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 38 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 39 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 40 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 41 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 42 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 43 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 44 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 45 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 46 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 47 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 48 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 49 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 50 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 51 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 52 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 53 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 54 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 55 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 56 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 57 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 58 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 59 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 60 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 61 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 62 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 63 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 64 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 65 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 66 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 67 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 68 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 69 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 70 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 71 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 72 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 73 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 74 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 75 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 76 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 77 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 78 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 79 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 80 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 81 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 82 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 83 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 84 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 85 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 86 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 87 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 88 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 89 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 90 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 91 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 92 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 93 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 94 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 95 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 96 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 97 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 98 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 99 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 100 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 101 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 102 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 103 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 104 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 105 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 106 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 107 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 108 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 109 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 110 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 111 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 112 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 113 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 114 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 115 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 116 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 117 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 118 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 119 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 120 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 121 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 122 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 123 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 124 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 125 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 126 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 127 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 128 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 129 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 130 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 131 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 132 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 133 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 134 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 135 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 136 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 137 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 138 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 139 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 140 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 141 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 142 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 143 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 144 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 145 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 146 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 147 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 148 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 149 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 150 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 151 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 152 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 153 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 154 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 155 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 156 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 157 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 158 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 159 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 160 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 161 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 162 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 163 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 164 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 165 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 166 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 167 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 168 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 169 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 170 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 171 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 172 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 173 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 174 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 175 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 176 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 177 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 178 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 179 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 180 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 181 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 182 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 183 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 184 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 185 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 186 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 187 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 188 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 189 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 190 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 191 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 192 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 193 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 194 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 195 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 196 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 197 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 198 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 199 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 200 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 201 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 202 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 203 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 204 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 205 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 206 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 207 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 208 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 209 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 210 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 211 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 212 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 213 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 214 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 215 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 216 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 217 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 218 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 219 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 220 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 221 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 222 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 223 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 224 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 225 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 226 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 227 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 228 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 229 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 230 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 231 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 232 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 233 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 234 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 235 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 236 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 237 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 238 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 239 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 240 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 241 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 242 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 243 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 244 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 245 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 246 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 247 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 248 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 249 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 250 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 251 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 252 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 253 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 254 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 255 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 256 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 257 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 258 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 98;
    #4 clk = 1;
    #1 
    $display("P 259 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 227;
    #4 clk = 1;
    #1 
    $display("P 260 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 10;
    #4 clk = 1;
    #1 
    $display("P 261 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 247;
    #4 clk = 1;
    #1 
    $display("P 262 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 124;
    #4 clk = 1;
    #1 
    $display("P 263 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 235;
    #4 clk = 1;
    #1 
    $display("P 264 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 212;
    #4 clk = 1;
    #1 
    $display("P 265 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 247;
    #4 clk = 1;
    #1 
    $display("P 266 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 91;
    #4 clk = 1;
    #1 
    $display("P 267 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 228;
    #4 clk = 1;
    #1 
    $display("P 268 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 55;
    #4 clk = 1;
    #1 
    $display("P 269 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 35;
    #4 clk = 1;
    #1 
    $display("P 270 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 35;
    #4 clk = 1;
    #1 
    $display("P 271 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 24;
    #4 clk = 1;
    #1 
    $display("P 272 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 204;
    #4 clk = 1;
    #1 
    $display("P 273 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 252;
    #4 clk = 1;
    #1 
    $display("P 274 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 136;
    #4 clk = 1;
    #1 
    $display("P 275 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 180;
    #4 clk = 1;
    #1 
    $display("P 276 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 154;
    #4 clk = 1;
    #1 
    $display("P 277 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 37;
    #4 clk = 1;
    #1 
    $display("P 278 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 25;
    #4 clk = 1;
    #1 
    $display("P 279 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 18;
    #4 clk = 1;
    #1 
    $display("P 280 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 217;
    #4 clk = 1;
    #1 
    $display("P 281 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 84;
    #4 clk = 1;
    #1 
    $display("P 282 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 143;
    #4 clk = 1;
    #1 
    $display("P 283 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 90;
    #4 clk = 1;
    #1 
    $display("P 284 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 80;
    #4 clk = 1;
    #1 
    $display("P 285 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 163;
    #4 clk = 1;
    #1 
    $display("P 286 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 52;
    #4 clk = 1;
    #1 
    $display("P 287 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 141;
    #4 clk = 1;
    #1 
    $display("P 288 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 113;
    #4 clk = 1;
    #1 
    $display("P 289 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 133;
    #4 clk = 1;
    #1 
    $display("P 290 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 15;
    #4 clk = 1;
    #1 
    $display("P 291 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 235;
    #4 clk = 1;
    #1 
    $display("P 292 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 234;
    #4 clk = 1;
    #1 
    $display("P 293 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 23;
    #4 clk = 1;
    #1 
    $display("P 294 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 215;
    #4 clk = 1;
    #1 
    $display("P 295 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 181;
    #4 clk = 1;
    #1 
    $display("P 296 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 200;
    #4 clk = 1;
    #1 
    $display("P 297 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 160;
    #4 clk = 1;
    #1 
    $display("P 298 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 156;
    #4 clk = 1;
    #1 
    $display("P 299 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 211;
    #4 clk = 1;
    #1 
    $display("P 300 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 85;
    #4 clk = 1;
    #1 
    $display("P 301 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 186;
    #4 clk = 1;
    #1 
    $display("P 302 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 180;
    #4 clk = 1;
    #1 
    $display("P 303 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 16;
    #4 clk = 1;
    #1 
    $display("P 304 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 234;
    #4 clk = 1;
    #1 
    $display("P 305 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 56;
    #4 clk = 1;
    #1 
    $display("P 306 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 205;
    #4 clk = 1;
    #1 
    $display("P 307 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 36;
    #4 clk = 1;
    #1 
    $display("P 308 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 139;
    #4 clk = 1;
    #1 
    $display("P 309 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 23;
    #4 clk = 1;
    #1 
    $display("P 310 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 254;
    #4 clk = 1;
    #1 
    $display("P 311 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 224;
    #4 clk = 1;
    #1 
    $display("P 312 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 313 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 125;
    #4 clk = 1;
    #1 
    $display("P 314 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 77;
    #4 clk = 1;
    #1 
    $display("P 315 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 74;
    #4 clk = 1;
    #1 
    $display("P 316 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 31;
    #4 clk = 1;
    #1 
    $display("P 317 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 85;
    #4 clk = 1;
    #1 
    $display("P 318 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 236;
    #4 clk = 1;
    #1 
    $display("P 319 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 52;
    #4 clk = 1;
    #1 
    $display("P 320 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 204;
    #4 clk = 1;
    #1 
    $display("P 321 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 140;
    #4 clk = 1;
    #1 
    $display("P 322 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 73;
    #4 clk = 1;
    #1 
    $display("P 323 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 23;
    #4 clk = 1;
    #1 
    $display("P 324 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 204;
    #4 clk = 1;
    #1 
    $display("P 325 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 81;
    #4 clk = 1;
    #1 
    $display("P 326 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 61;
    #4 clk = 1;
    #1 
    $display("P 327 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 47;
    #4 clk = 1;
    #1 
    $display("P 328 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 210;
    #4 clk = 1;
    #1 
    $display("P 329 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 8;
    #4 clk = 1;
    #1 
    $display("P 330 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 251;
    #4 clk = 1;
    #1 
    $display("P 331 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 66;
    #4 clk = 1;
    #1 
    $display("P 332 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 17;
    #4 clk = 1;
    #1 
    $display("P 333 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 173;
    #4 clk = 1;
    #1 
    $display("P 334 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 33;
    #4 clk = 1;
    #1 
    $display("P 335 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 38;
    #4 clk = 1;
    #1 
    $display("P 336 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 9;
    #4 clk = 1;
    #1 
    $display("P 337 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 20;
    #4 clk = 1;
    #1 
    $display("P 338 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 179;
    #4 clk = 1;
    #1 
    $display("P 339 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 212;
    #4 clk = 1;
    #1 
    $display("P 340 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 174;
    #4 clk = 1;
    #1 
    $display("P 341 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 214;
    #4 clk = 1;
    #1 
    $display("P 342 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 134;
    #4 clk = 1;
    #1 
    $display("P 343 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 133;
    #4 clk = 1;
    #1 
    $display("P 344 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 60;
    #4 clk = 1;
    #1 
    $display("P 345 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 55;
    #4 clk = 1;
    #1 
    $display("P 346 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 173;
    #4 clk = 1;
    #1 
    $display("P 347 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 211;
    #4 clk = 1;
    #1 
    $display("P 348 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 107;
    #4 clk = 1;
    #1 
    $display("P 349 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 70;
    #4 clk = 1;
    #1 
    $display("P 350 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 126;
    #4 clk = 1;
    #1 
    $display("P 351 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 164;
    #4 clk = 1;
    #1 
    $display("P 352 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 179;
    #4 clk = 1;
    #1 
    $display("P 353 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 251;
    #4 clk = 1;
    #1 
    $display("P 354 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 91;
    #4 clk = 1;
    #1 
    $display("P 355 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 83;
    #4 clk = 1;
    #1 
    $display("P 356 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 29;
    #4 clk = 1;
    #1 
    $display("P 357 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 150;
    #4 clk = 1;
    #1 
    $display("P 358 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 85;
    #4 clk = 1;
    #1 
    $display("P 359 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 48;
    #4 clk = 1;
    #1 
    $display("P 360 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 4;
    #4 clk = 1;
    #1 
    $display("P 361 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 69;
    #4 clk = 1;
    #1 
    $display("P 362 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 180;
    #4 clk = 1;
    #1 
    $display("P 363 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 95;
    #4 clk = 1;
    #1 
    $display("P 364 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 43;
    #4 clk = 1;
    #1 
    $display("P 365 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 109;
    #4 clk = 1;
    #1 
    $display("P 366 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 15;
    #4 clk = 1;
    #1 
    $display("P 367 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 200;
    #4 clk = 1;
    #1 
    $display("P 368 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 218;
    #4 clk = 1;
    #1 
    $display("P 369 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 56;
    #4 clk = 1;
    #1 
    $display("P 370 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 209;
    #4 clk = 1;
    #1 
    $display("P 371 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 162;
    #4 clk = 1;
    #1 
    $display("P 372 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 239;
    #4 clk = 1;
    #1 
    $display("P 373 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 154;
    #4 clk = 1;
    #1 
    $display("P 374 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 18;
    #4 clk = 1;
    #1 
    $display("P 375 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 31;
    #4 clk = 1;
    #1 
    $display("P 376 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 48;
    #4 clk = 1;
    #1 
    $display("P 377 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 212;
    #4 clk = 1;
    #1 
    $display("P 378 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 30;
    #4 clk = 1;
    #1 
    $display("P 379 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 23;
    #4 clk = 1;
    #1 
    $display("P 380 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 213;
    #4 clk = 1;
    #1 
    $display("P 381 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 29;
    #4 clk = 1;
    #1 
    $display("P 382 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 155;
    #4 clk = 1;
    #1 
    $display("P 383 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 49;
    #4 clk = 1;
    #1 
    $display("P 384 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 248;
    #4 clk = 1;
    #1 
    $display("P 385 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 183;
    #4 clk = 1;
    #1 
    $display("P 386 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 387 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 388 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 389 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 390 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 391 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 392 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 393 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 394 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 395 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 396 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 397 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 398 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 399 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 400 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 401 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 402 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 403 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 0;
    #4 clk = 1;
    #1 
    $display("P 404 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 0;
    #4 clk = 1;
    #1 
    $display("P 405 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 0;
    #4 clk = 1;
    #1 
    $display("P 406 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 0;
    #4 clk = 1;
    #1 
    $display("P 407 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 0;
    #4 clk = 1;
    #1 
    $display("P 408 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 409 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 410 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 411 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 412 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 413 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 414 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 415 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 416 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 417 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 418 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 419 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 420 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #1 reset_n = 0;
    #1 
    $display("P 421 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #3 clk = 1;
    #1 
    $display("P 422 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #4 clk = 1;
    #1 
    $display("P 423 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 reset_n = 1;
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 424 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 425 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 426 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 427 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 428 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 429 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 430 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 431 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 432 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 433 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 434 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 0;
    instruction = 0;
    #1 reset_n = 0;
    #1 
    $display("P 435 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #3 clk = 1;
    #1 
    $display("P 436 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #4 clk = 1;
    #1 
    $display("P 437 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 reset_n = 1;
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 438 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 439 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 440 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 441 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 442 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 443 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 444 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 445 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 446 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 447 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #4 clk = 1;
    #1 
    $display("P 448 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    enable = 1;
    instruction = 255;
    #1 reset_n = 0;
    #1 
    $display("P 449 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #3 clk = 1;
    #1 
    $display("P 450 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #4 clk = 1;
    #1 
    $display("P 451 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 reset_n = 1;
    #4 clk = 1;
    #1 
    $display("P 452 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    #4 clk = 1;
    #1 
    $display("P 453 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    #4 clk = 1;
    #1 
    $display("P 454 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    #4 clk = 1;
    #1 
    $display("P 455 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    #4 clk = 1;
    #1 
    $display("P 456 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    #4 clk = 1;
    #1 
    $display("P 457 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    #4 clk = 1;
    #1 
    $display("P 458 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    #4 clk = 1;
    #1 
    $display("P 459 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    #4 clk = 1;
    #1 
    $display("P 460 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    #4 clk = 1;
    #1 
    $display("P 461 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    #4 clk = 1;
    #1 
    $display("P 462 %b %b %b %b %b %b %b %b %b %b", acc, pc, data_out, carry, halted, _checker_ref_acc, _checker_ref_pc, _checker_ref_data_out, _checker_ref_carry, _checker_ref_halted);
    #4 clk = 0;
    #1 
    $finish;
  end
endmodule
