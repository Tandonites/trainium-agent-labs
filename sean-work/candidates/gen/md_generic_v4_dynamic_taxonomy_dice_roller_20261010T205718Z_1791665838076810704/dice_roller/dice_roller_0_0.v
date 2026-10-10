module dice_roller (
    input clk,
    input rst_n,
    input [1:0] die_select,
    input roll,
    output reg [7:0] rolled_number
);

    // Define the number of sides for each die select
    localparam [3:0] SIDES = 4'd4, 6'd6, 8'd8, 20'd20;

    // Determine the number of sides based on die_select
    reg [3:0] sides;
    always @(die_select) begin
        case (die_select)
            2'b00: sides = 4'd4;
            2'b01: sides = 6'd6;
            2'b10: sides = 8'd8;
            2'b11: sides = 20'd20;
            default: sides = 4'd4;
        endcase
    end

    // Random number generator using a simple linear feedback shift register (LFSR)
    reg [7:0] lfsr;
    reg [7:0] lfsr_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lfsr <= 8'd0;
        end else begin
            lfsr_next = {lfsr[6:0], (lfsr[7] ^ lfsr[5])};
            lfsr <= lfsr_next;
        end
    end

    // Generate a random number between 0 and (sides - 1)
    reg [7:0] random_val;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            random_val <= 8'd0;
        end else begin
            random_val <= lfsr;
        end
    end

    // Logic to trigger roll on rising clock edge when roll is high
    reg roll_active;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            roll_active <= 1'b0;
        end else begin
            if (roll) begin
                roll_active <= 1'b1;
            end else begin
                roll_active <= 1'b0;
            end
        end
    end

    // Generate the rolled number
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rolled_number <= 8'd0;
        end else if (roll_active) begin
            // Map random_val (0 to 255) to 1 to sides
            rolled_number <= (random_val % sides) + 1;
        end
    end

endmodule
