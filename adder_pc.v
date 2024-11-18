module adder_pc (
  input [31:0] pc, 
  output [31:0] next_pc
); 
assign pc_next = pc + 4; 

endmodule 
 
