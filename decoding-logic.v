
//`define FIRST_ENCODE 32'b00000000000000000000000000_110111 
//`define HALT_ENCODE  32'b00000000000000000000000000_111111 
//`define NEXT_PC_IMM  1'b1
//`define NEXT_PC_4    1'b0

module decoding_logic (
    input [31:0] instruction,
    output reg [4:0] rs,        // Source register 1
    output reg [4:0] rt,        // Source register 2
    output reg [4:0] rd,        // Destination register
    output reg [2:0] alu_control 
);
    wire [5:0] opcode = instruction[31:26];
    wire [5:0] funct  = instruction[5:0];
    wire [31:0] pc_next; 
    wire [31:0] pc_out;

    always @(*) begin
        rs = instruction[25:21];
        rt = instruction[20:16];
        rd = instruction[15:11];
        alu_control = 3'b000;

        case (opcode)
            6'b000000: begin 
                case (funct)
                    6'b100000: alu_control = 3'b000; // AND
                    6'b100010: alu_control = 3'b001; // OR
                    6'b100100: alu_control = 3'b010; // ADD
                    6'b100101: alu_control = 3'b011; // SUB
                    6'b101010: alu_control = 3'b111; // MUL
                    default: alu_control = 3'b000;
                endcase
            end
            default: alu_control = 3'b000;
        endcase
    end
endmodule
