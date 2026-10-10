`timescale 1ns/1ps
module probe;
  reg clk = 0;
  reg rst_n = 1;
  reg [1:0] die_select = 0;
  reg roll = 0;
  wire [7:0] rolled_number;
  wire [7:0] _checker_ref_rolled_number;
  dice_roller dut (.clk(clk), .rst_n(rst_n), .die_select(die_select), .roll(roll), .rolled_number(rolled_number));
  _checker_reference reference (.clk(clk), .rst_n(rst_n), .die_select(die_select), .roll(roll), .rolled_number(_checker_ref_rolled_number));
  initial begin
    #1 rst_n = 0;
    #1 
    $display("P 0 %b %b", rolled_number, _checker_ref_rolled_number);
    #3 clk = 1;
    #1 
    $display("P 1 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #4 clk = 1;
    #1 
    $display("P 2 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 rst_n = 1;
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 3 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 4 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 5 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 6 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 7 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 8 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 9 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 10 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 11 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 12 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 13 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 14 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 15 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 16 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 17 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 18 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 19 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 20 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 21 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 22 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 23 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 24 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 25 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 26 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 27 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 28 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 29 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 30 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 31 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 32 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 33 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 34 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 35 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 36 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 37 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 38 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 39 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 40 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 41 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 42 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 43 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 44 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 45 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 46 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 47 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 48 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 49 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 50 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 51 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 52 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 53 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 54 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 55 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 56 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 57 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 58 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 59 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 60 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 61 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 62 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 63 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 64 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 65 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 66 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 67 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 68 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 69 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 70 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 71 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 72 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 73 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 74 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 75 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 76 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 77 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 78 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 79 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 80 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 81 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 82 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 83 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 84 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 85 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 86 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 87 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 88 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 89 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 90 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 91 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 92 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 93 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 94 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 95 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 96 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 97 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 98 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 99 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 100 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 101 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 102 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 103 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 104 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 105 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 106 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 107 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 108 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 109 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 110 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 111 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 112 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 113 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 114 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 115 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 116 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 117 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 118 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 119 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 120 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 121 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 122 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 123 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 124 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 125 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 126 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 127 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 128 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 129 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 130 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 131 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 132 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 133 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 134 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 135 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 136 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 137 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 138 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 139 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 140 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 141 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 142 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 143 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 144 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 145 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 146 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 147 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 148 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 149 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 150 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 151 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 152 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 153 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 154 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 155 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 156 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 157 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 158 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 159 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 160 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 161 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 162 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 163 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 164 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 165 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 166 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 167 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 168 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 169 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 170 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 171 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 172 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 173 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 174 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 175 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 176 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 177 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 178 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 179 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 180 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 181 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 182 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 183 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 184 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 185 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 186 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 187 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 188 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 189 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 190 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 191 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 192 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 193 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 194 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 195 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 196 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 197 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 198 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 199 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 200 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 201 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 202 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 203 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 204 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 205 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 206 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 207 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 208 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 209 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 210 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 211 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 212 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 213 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 214 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 215 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 216 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 217 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 218 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 219 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 220 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 221 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 222 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 223 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 224 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 225 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 226 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 227 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 228 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 229 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 230 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 231 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 232 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 233 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 234 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 235 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 236 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 237 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 238 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 239 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 240 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 241 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 242 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 243 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 244 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 245 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 246 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 247 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 248 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 249 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 250 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 251 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 252 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 253 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 254 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 255 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 256 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 257 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 258 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 259 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 260 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 1;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 261 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 1;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 262 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 263 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 1;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 264 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 265 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 1;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 266 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 1;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 267 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 268 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 269 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 270 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 1;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 271 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 272 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 273 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 1;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 274 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 275 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 276 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 277 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 278 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 1;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 279 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 280 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 281 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 282 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 1;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 283 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 0;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 284 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 1;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 285 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 286 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 287 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 288 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 1;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 289 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 290 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 1;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 291 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 292 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 293 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 0;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 294 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 295 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 1;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 296 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 297 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 298 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 0;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 299 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 1;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 300 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 301 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 0;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 302 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 1;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 303 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 304 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 0;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 305 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 306 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 0;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 307 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 308 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 309 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 1;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 310 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 0;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 311 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 1;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 312 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 313 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 314 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 0;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 315 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 316 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 317 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 318 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 319 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 320 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 321 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 322 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 323 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 1;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 324 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 325 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 1;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 326 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 327 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 1;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 328 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 0;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 329 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 0;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 330 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 331 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 332 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 1;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 333 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 0;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 334 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 335 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 336 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 337 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 338 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 339 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 340 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 341 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 1;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 342 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 343 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 1;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 344 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 345 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 346 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 347 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 348 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 349 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 350 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 1;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 351 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 352 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 353 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 354 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 355 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 0;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 356 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 357 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 1;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 358 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 359 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 360 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 0;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 361 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 362 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 0;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 363 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 0;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 364 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 365 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 1;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 366 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 367 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 0;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 368 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 0;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 369 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 370 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 0;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 371 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 372 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 373 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 374 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 375 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 0;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 376 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 377 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 378 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 2;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 379 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 1;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 380 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 1;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 381 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 382 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 0;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 383 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 0;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 384 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 385 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 0;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 386 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 0;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 387 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 0;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 388 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 0;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 389 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 0;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 390 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 0;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 391 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 392 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 393 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 394 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 395 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 396 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 397 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 398 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 399 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 400 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 401 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 402 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 403 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 404 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 405 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 406 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 407 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 0;
    #4 clk = 1;
    #1 
    $display("P 408 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 409 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 410 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 411 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 412 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 413 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 414 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 415 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 416 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 417 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 418 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 419 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 420 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #1 rst_n = 0;
    #1 
    $display("P 421 %b %b", rolled_number, _checker_ref_rolled_number);
    #3 clk = 1;
    #1 
    $display("P 422 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #4 clk = 1;
    #1 
    $display("P 423 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 rst_n = 1;
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 424 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 425 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 426 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 427 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 428 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 429 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 430 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 431 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 432 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 433 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 434 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 0;
    roll = 0;
    #1 rst_n = 0;
    #1 
    $display("P 435 %b %b", rolled_number, _checker_ref_rolled_number);
    #3 clk = 1;
    #1 
    $display("P 436 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #4 clk = 1;
    #1 
    $display("P 437 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 rst_n = 1;
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 438 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 439 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 440 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 441 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 442 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 443 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 444 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 445 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 446 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 447 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #4 clk = 1;
    #1 
    $display("P 448 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    die_select = 3;
    roll = 1;
    #1 rst_n = 0;
    #1 
    $display("P 449 %b %b", rolled_number, _checker_ref_rolled_number);
    #3 clk = 1;
    #1 
    $display("P 450 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #4 clk = 1;
    #1 
    $display("P 451 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 rst_n = 1;
    #4 clk = 1;
    #1 
    $display("P 452 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    #4 clk = 1;
    #1 
    $display("P 453 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    #4 clk = 1;
    #1 
    $display("P 454 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    #4 clk = 1;
    #1 
    $display("P 455 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    #4 clk = 1;
    #1 
    $display("P 456 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    #4 clk = 1;
    #1 
    $display("P 457 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    #4 clk = 1;
    #1 
    $display("P 458 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    #4 clk = 1;
    #1 
    $display("P 459 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    #4 clk = 1;
    #1 
    $display("P 460 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    #4 clk = 1;
    #1 
    $display("P 461 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    #4 clk = 1;
    #1 
    $display("P 462 %b %b", rolled_number, _checker_ref_rolled_number);
    #4 clk = 0;
    #1 
    $finish;
  end
endmodule
