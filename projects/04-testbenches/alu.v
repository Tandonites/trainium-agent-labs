module alu (
    input [7:0] A,
    input [7:0] B,
    input [2:0] opcode,
    output reg [7:0] Y,
    output reg carry,
    output reg zero
);

always @(*) begin
    case (opcode)
        3'b000: begin // ADD
            {carry, Y} = A + B;
            zero = (Y == 8'b0);
        end
        3'b001: begin // SUB
            {carry, Y} = A - B;
            zero = (Y == 8'b0);
        end
        3'b010: begin // AND
            Y = A & B;
            zero = (Y == 8'b0);
        end
        3'b011: begin // OR
            Y = A | B;
            zero = (Y == 8'b0);
        end
        3'b100: begin // XOR
            Y = A ^ B;
            zero = (Y == 8'b0);
        end
        3'b101: begin // SLL
            Y = A << B[2:0];
            zero = (Y == 8'b0);
        end
        3'b110: begin // SRL
            Y = A >> B[2:0];
            zero = (Y == 8'b0);
        end
        3'b111: begin // NOT_A
            Y = ~A;
            zero = (Y == 8'b0);
        end
    endcase
end

endmodule
