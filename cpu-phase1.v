module single_cycle_cpu (clk,rst);
    input wire clk;
    input wire rst; 
    wire [31:0] result1;
    wire [31:0] result2; 
    wire [31:0] encoded;
    wire is_halt;
    reg createdump; 
    wire next_pc; 
    wire [31:0] alu_result;
    wire [2:0] alu_control;
    wire zero;
    wire [31:0] mux_out;
    wire [1:0] sel;
    
    reg [31:0] pc; 

always @(posedge clk or posedge rst) begin
	if (rst) 
	     pc <= 32'b0;
	else if (next_pc)
	     pc <= pc + 4;
end 
//alu code 
 alu_cpu myalu(
  .a(result1), .b(result2), .alu_control(alu_control),
	 .result(alu_result), .zero(zero), .clk(clk)
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


//decoding logic 
decoding_logic mylog(
 .in_encode (encode), .next_pc(next_pc),
	 .alu_control(alu_control), .is_halt(is_halt)
); 

endmodule
