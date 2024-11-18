module dmem_instru (
    input wire [31:0] addr,        
    input wire [31:0] write_data,  
    input wire mem_read,           
    input wire mem_write,
    input wire clk,                
    input wire reset,            
    input wire stall,              
    output reg [31:0] read_data,   
    output reg done                
);

    reg [31:0] memory [0:255];     
    integer i;
    initial begin
 
        for (i = 0; i < 256; i = i + 1) begin
            memory[i] = 32'b0;
        end
        done = 1'b1;  
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            done <= 1'b1;
            read_data <= 32'b0;
        end else if (!stall) begin
            if (mem_read) begin
              read_data <= memory[addr[7:0]]; 
            end else if (mem_write) begin
                memory[addr[7:0]] <= write_data; 
            end
            done <= 1'b1;
        end else begin
            done <= done;  
        end
    end
endmodule
