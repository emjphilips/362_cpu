`define FIRST_ENCODE 32'b00000000000000000000000000_110111 
`define HALT_ENCODE  32'b00000000000000000000000000_111111 
//`define NEXT_PC_IMM  1'b1
//`define NEXT_PC_4    1'b0

module decoding_logic (
    input wire [31:0] in_encode,
    output reg [2:0] alu_control,
    output reg is_halt 
); 
    input wire clk;
    input wire rst; 
    wire [31:0] pc_next; 
	wire [31:0] pc_out;

pc_counter counter (
	.clk(clk), .rst(rst), .pc_in(pc_next), .pc_out(pc_out)
); 

adder_pc adding_pc (
	.pc(pc_out), .pc_next(pc_next)
);

/*   always @* begin 
        next_pc = `NEXT_PC_4; 
        is_halt = 1'b0; 
        alu_control = 3'b000; 

        case (in_encode)
    `FIRST_ENCODE: begin 
        next_pc = `NEXT_PC_IMM; 
        alu_control = 3'b010; 
    end 

    `HALT_ENCODE: begin 
        next_pc = 1'b0; 
        is_halt = 1'b1; 
    end 
*/
    32'b00000000000000000000000000_000000: begin 
        alu_control = 3'b000; 
        assign next_pc = pc + 4; 
    end 

    32'b00000000000000000000000000_000001: begin 
        alu_control = 3'b001; 
        assign next_pc = pc + 4; 
    end 

    32'b00000000000000000000000000_000010: begin 
         alu_control = 3'b010;
        assign next_pc = pc + 4; 
    end 

    32'b00000000000000000000000000_000011: begin 
         alu_control = 3'b011;
        assign next_pc = pc + 4; 
    end 

    32'b00000000000000000000000000_000100: begin 
         alu_control = 3'b100;
         assign next_pc = pc + 4;                
    end 

    32'b00000000000000000000000000_000111: begin 
         alu_control = 3'b111;
        assign next_pc = pc + 4; 
    end 
            
    default: begin
        alu_control = 3'b000;
        assign next_pc = pc + 4; 
    end 
endcase

