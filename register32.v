module register32(
    input [4:0] addr1,
    input [4:0] addr2,
    input [4:0] write_reg,
    input [31:0] data_in,
    output [31:0] out1,
    output [31:0] out2,
    input clk,
    input rst,
    input ranwi
);
    reg [31:0] r [0:31];
    integer i;

    assign out1 = (addr1 != 5'b0) ? r[addr1] : 32'b0; // x0 is always 0
    assign out2 = (addr2 != 5'b0) ? r[addr2] : 32'b0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                r[i] <= 32'b0;
            end
        end else if (ranwi && (write_reg != 5'b0)) begin
            r[write_reg] <= data_in;
        end
    end
endmodule 
