module pipelined_processor (
    input wire clk,              
    input wire reset,             
    output wire [31:0] result  
);

    // Internal signals
    reg [31:0] pc;
    wire [31:0] inst_if, inst_id, inst_ex;
    wire [31:0] read_data_mem;
    reg stall_imem, stall_dmem;  
    wire done_imem, done_dmem;
    
    // Instruction memory (IMEM)
    imem_instru stalling_imem (
        .pc(pc),
        .clk(clk),
        .reset(reset),
        .stall(stall_imem),
        .inst(inst_if),
        .done(done_imem)
    );

    // Data memory (DMEM)
    dmem_instru stalling_dmem (
        .addr(inst_ex[31:0]),  
        .write_data(inst_ex),   
        .mem_read(1'b1),    
        .mem_write(1'b0),     
        .clk(clk),
        .reset(reset),
        .stall(stall_dmem),
        .read_data(read_data_mem),
        .done(done_dmem)
    );

    // Pipeline registers and stages
    reg [31:0] id_reg, ex_reg, mem_reg, wb_reg;
    reg stall_pipeline;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 0;
            id_reg <= 32'b0;
            ex_reg <= 32'b0;
            mem_reg <= 32'b0;
            wb_reg <= 32'b0;
            stall_pipeline <= 0;
        end else begin
            // Handle IF stage with stall
            if (!stall_pipeline) begin
                id_reg <= inst_if;  
                ex_reg <= id_reg;   
                mem_reg <= ex_reg;  
                wb_reg <= mem_reg;  
            end
        end
    end

    // Stall detection logic for pipeline (example logic)
    always @(*) begin
        // Stall if IMEM or DMEM is not done
        stall_imem = !done_imem;
        stall_dmem = !done_dmem;
        stall_pipeline = stall_imem || stall_dmem;
    end

    assign result = wb_reg;  

endmodule
