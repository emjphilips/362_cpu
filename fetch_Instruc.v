
module fetch_instruc (
    input wire clk,            
    input wire rst,             
    input wire [31:0] pc_in,    
    output reg [31:0] pc_out,     
    output reg [31:0] instruction 
);

    reg [31:0] instruction_memory [0:255]; 


    initial begin
        instruction_memory[0] = 32'b00000000000000000000000000_000001; 
        instruction_memory[1] = 32'b00000000000000000000000000_000010;
        instruction_memory[2] = 32'b00000000000000000000000000_000011;
        instruction_memory[3] = 32'b00000000000000000000000000_000110;
        instruction_memory[4] = 32'b00000000000000000000000000_000111;
        instruction_memory[5] = 32'b00000000000000000000000000_000101;
      
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            pc_out <= 32'b0; 
        else
            pc_out <= pc_in; 
    end

    always @(*) begin
        instruction = instruction_memory[pc_out[31:2]]; 
    end
endmodule
