module imem_instru (
    input wire [31:0] pc,        
    input wire clk,              
    input wire reset,            
    input wire stall,            
    output reg [31:0] inst,      
    output reg done              
);

    reg [31:0] memory [0:255];   
    integer i;

    initial begin
        // Initialize memory (optional)
        for (i = 0; i < 256; i = i + 1) begin
            memory[i] = 32'b0;
        end
        done = 1'b1; 
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            done <= 1'b1;
            inst <= 32'b0;
        end else if (!stall) begin
            inst <= memory[pc[7:0]]; 
            done <= 1'b1; 
        end else begin
            inst <= inst; 
            done <= done;  
        end
    end
endmodule
