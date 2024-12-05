module single_cycle_cpu (clk,rst);
    input wire clk;
    input wire rst; 
    wire [31:0] result1;
    wire [31:0] result2; 
    wire [31:0] encoded;
   // wire is_halt;
    reg createdump; 
    wire [31:0] alu_result;
    wire [2:0] alu_control;
    wire zero;
    wire [31:0] mux_out;
    wire [1:0] sel;
    wire [31:0] pc_next; 
    wire [31:0] pc_out;
    wire [31:0] instruction;
    wire [4:0] rs, rt, rd;
   // wire [31:0] reg_data1, reg_data2;

    reg [31:0] register_file [0:31];


pc_counter counter (
	.clk(clk), .rst(rst), .pc_in(pc_next), .pc_out(pc_out)
); 

adder_pc adding_pc (
	.pc(pc_out), .pc_next(pc_next)
); 

fetch_instruc fetch (
	.clk(clk), .rst(rst), .pc_in(pc_next), .pc_out(pc_out), .instruction(instruc)  
);

alu_cpu myalu(
	.a(register_file[rs]), .b(register_file[rt]), .alu_control(alu_control), .result(alu_result), .zero(zero),
);

decoding_logic mylog (
	.instruction(instruc) , .rs(rs), .rt(rt),  .rd(rd), .alu_control(alu_control) 
);

//register code 
register32 myregs(
   .addr1(encoded[19:15]), .addr2(encoded[24:20]),
	 .write_reg(encoded[11:7]), .data_in(alu_result),
	 .out1(result1), .out2(result2), .clk(clk), 
	 .rst(rst), .ranwi(1'b1) 
);

//4-1mux
mux4to1 mymux(
  .in({result1, result2, 32'b0, 32'b0}), .sel(sel),
	 .out(mux_out), .clk(clk)
);

//memory 
memory mymem(
  .data_out(encoded), .data_in(32'b0), .addr(pc), .enable(1'b1), 
	.wr(1'b0), .createdump(createdump), .clk(clk), .rst(rst) 
);


    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Simulation control
    initial begin
        // Initialize reset
        reset = 1;
        #10 reset = 0;
        #100 $finish;
    end

    // Display PC and instruction values
    always @(posedge clk) begin
        $display("PC = %h, Instruction = %h", pc_out, instruction);
    end
endmodule
