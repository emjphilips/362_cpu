module alu(
    input [31:0] a,
    input [31:0] b,
    input [2:0] alu_control,
    output reg [31:0] result,
    output reg zero,
    input clk
);
    always @(posedge clk) begin
        case (alu_control)
            3'b000: result <= a & b; // AND
            3'b001: result <= a | b; // OR
            3'b010: result <= a + b; // ADD
            3'b110: result <= a - b; // SUB
            // Add more operations as needed
            default: result <= 0;
        endcase
        zero <= (result == 0);
    end
endmodule

