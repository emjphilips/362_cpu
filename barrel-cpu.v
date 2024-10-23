
module barrel_shifter(
    input [31:0] data_in,
    input [4:0] shift_amount,
    input dir, // 0 for left, 1 for right
    output reg [31:0] data_out,
    input clk
);
    always @(posedge clk) begin
        if (dir == 0) // Left shift
            data_out <= data_in << shift_amount;
        else // Right shift
            data_out <= data_in >> shift_amount;
    end
endmodule
