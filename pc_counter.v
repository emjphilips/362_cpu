module pc_counter( 
  input [31:0] pc_in, 
  input [31:0] pc_out);

  always @(posedge clk or posedge rst) begin
	if (rst) 
	     pc_out <= 32'b0;
	else 
    pc_out <= pc_in;
end 
endmodule 
