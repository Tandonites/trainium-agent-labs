`timescale 1ns/1ps

module tb_cpu8;
    reg clk;
    reg reset_n;
    reg enable;
    reg [7:0] instruction;
    wire [7:0] acc;
    wire [7:0] pc;
    wire [7:0] data_out;
    wire carry;
    wire halted;

    cpu8 dut (
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .instruction(instruction),
        .acc(acc),
        .pc(pc),
        .data_out(data_out),
        .carry(carry),
        .halted(halted)
    );

    reg [7:0] expected_acc;
    reg [7:0] expected_pc;
    reg [7:0] expected_out;
    reg expected_carry;
    reg expected_halted;
    reg [7:0] program_mem [0:15];
    reg [31:0] random_state;
    integer edges;
    integer base_value;
    integer operand;
    integer opcode;
    integer i;

    task check_state;
        begin
            if (acc !== expected_acc || pc !== expected_pc ||
                data_out !== expected_out || carry !== expected_carry ||
                halted !== expected_halted) begin
                $display("Error: CPU8 state mismatch at checked edge %0d", edges);
                if (acc !== expected_acc) $display("Error: acc mismatch");
                if (pc !== expected_pc) $display("Error: pc mismatch");
                if (data_out !== expected_out) $display("Error: data_out mismatch");
                if (carry !== expected_carry) $display("Error: carry mismatch");
                if (halted !== expected_halted) $display("Error: halted mismatch");
                $finish;
            end
        end
    endtask

    // Integer arithmetic in the scoreboard checks eight-bit truncation and carry.
    task advance_model;
        integer immediate;
        integer total;
        begin
            immediate = instruction % 16;
            if (!reset_n) begin
                expected_acc = 0;
                expected_pc = 0;
                expected_out = 0;
                expected_carry = 0;
                expected_halted = 0;
            end else if (enable && !expected_halted) begin
                case (instruction / 16)
                    1: begin
                        expected_acc = immediate;
                        expected_pc = (expected_pc + 1) % 256;
                    end
                    2: begin
                        total = expected_acc + immediate;
                        expected_acc = total % 256;
                        expected_carry = total >= 256;
                        expected_pc = (expected_pc + 1) % 256;
                    end
                    3: begin
                        expected_acc = expected_acc ^ immediate;
                        expected_pc = (expected_pc + 1) % 256;
                    end
                    4: begin
                        expected_acc = expected_acc & immediate;
                        expected_pc = (expected_pc + 1) % 256;
                    end
                    5: expected_pc = immediate;
                    6: begin
                        if (expected_acc == 0) expected_pc = immediate;
                        else expected_pc = (expected_pc + 1) % 256;
                    end
                    7: begin
                        expected_out = expected_acc;
                        expected_pc = (expected_pc + 1) % 256;
                    end
                    8: expected_halted = 1;
                    default: expected_pc = (expected_pc + 1) % 256;
                endcase
            end
        end
    endtask

    // All stimulus changes happen with clk low; outputs settle for one ns.
    task cycle;
        input [7:0] word;
        input run_enable;
        begin
            if (clk !== 0) begin
                $display("Error: testbench stimulus changed with clk high");
                $finish;
            end
            instruction = word;
            enable = run_enable;
            #2;
            check_state;
            clk = 1;
            edges = edges + 1;
            advance_model;
            #1;
            check_state;
            #1;
            clk = 0;
            #1;
            check_state;
        end
    endtask

    task apply_reset;
        input run_enable;
        begin
            instruction = 8'h2F;
            enable = run_enable;
            reset_n = 0;
            expected_acc = 0;
            expected_pc = 0;
            expected_out = 0;
            expected_carry = 0;
            expected_halted = 0;
            #1;
            check_state;
            cycle(8'h2F, run_enable);
            cycle(8'h7F, !run_enable);
            reset_n = 1;
            #1;
            check_state;
        end
    endtask

    task set_acc;
        input integer value;
        integer j;
        begin
            cycle(8'h10, 1);
            for (j = 0; j < value / 15; j = j + 1) cycle(8'h2F, 1);
            cycle(8'h20 | (value % 15), 1);
        end
    endtask

    initial begin
        clk = 0;
        reset_n = 1;
        enable = 0;
        instruction = 0;
        edges = 0;
        random_state = 32'h7A19C5E3;
        #1;
        apply_reset(0);

        // First enabled edge, output register, and paused execution.
        cycle(8'h1B, 1);
        cycle(8'h70, 1);
        for (i = 0; i < 5; i = i + 1) cycle(8'h2F, 0);
        cycle(8'h21, 1);
        cycle(8'h70, 1);

        // Every possible accumulator/immediate pair for ADD, including overflow.
        for (base_value = 0; base_value < 256; base_value = base_value + 1)
            for (operand = 0; operand < 16; operand = operand + 1) begin
                set_acc(base_value);
                cycle(8'h20 | operand, 1);
            end

        // Every opcode and immediate, with carry already set before execution.
        // Non-ADD instructions must preserve carry; ignored operands are varied.
        for (opcode = 0; opcode < 16; opcode = opcode + 1)
            for (operand = 0; operand < 16; operand = operand + 1) begin
                apply_reset(1);
                set_acc(255);
                cycle(8'h21, 1);
                cycle(8'h15, 1);
                cycle((opcode * 16) | operand, 1);
                cycle(8'h70, 1);
            end

        // Both outcomes of JZ, with every possible target.
        apply_reset(0);
        for (operand = 0; operand < 16; operand = operand + 1) begin
            cycle(8'h10, 1);
            cycle(8'h60 | operand, 1);
            cycle(8'h11, 1);
            cycle(8'h60 | operand, 1);
        end

        // Exercise pc rollover through an uninterrupted instruction stream.
        apply_reset(1);
        for (i = 0; i < 300; i = i + 1) cycle(8'h0F, 1);

        // Halt freezes all state for both enable levels, and reset restarts it.
        set_acc(255);
        cycle(8'h21, 1);
        cycle(8'h70, 1);
        cycle(8'h8F, 1);
        for (i = 0; i < 8; i = i + 1) cycle(8'h2F, i % 2);
        apply_reset(0);
        cycle(8'h1D, 1);
        cycle(8'h70, 1);
        cycle(8'h80, 1);
        apply_reset(1);
        cycle(8'h17, 1);

        // Fetch a short program using the DUT's current pc.
        for (i = 0; i < 16; i = i + 1) program_mem[i] = 0;
        program_mem[0] = 8'h10;
        program_mem[1] = 8'h63;
        program_mem[2] = 8'h1F;
        program_mem[3] = 8'h15;
        program_mem[4] = 8'h2B;
        program_mem[5] = 8'h70;
        program_mem[6] = 8'h38;
        program_mem[7] = 8'h4F;
        program_mem[8] = 8'h5A;
        program_mem[9] = 8'h10;
        program_mem[10] = 8'h80;
        apply_reset(1);
        for (i = 0; i < 20; i = i + 1) begin
            if (pc < 16) cycle(program_mem[pc], 1);
            else cycle(8'h00, 1);
        end
        if (acc !== 8'd8 || data_out !== 8'd16 || pc !== 8'd10 || halted !== 1'b1) begin
            $display("Error: CPU8 program did not reach its specified final state");
            $finish;
        end

        // Seeded instruction/enable changes with regular resets after halt.
        apply_reset(0);
        for (i = 0; i < 512; i = i + 1) begin
            random_state = random_state ^ (random_state << 13);
            random_state = random_state ^ (random_state >> 17);
            random_state = random_state ^ (random_state << 5);
            if (i % 23 == 0) apply_reset(random_state[8]);
            cycle(random_state[7:0], random_state[9]);
        end

        $display("All test cases passed: CPU8 (%0d checked edges)", edges);
        $finish;
    end

    initial begin
        #2000000;
        $display("Error: CPU8 testbench timeout");
        $finish;
    end
endmodule
