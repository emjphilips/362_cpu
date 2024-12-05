module memory2c (
    output reg [31:0] data_out,
    input [31:0] data_in,
    input [31:0] addr,
    input enable,
    input wr,
    input createdump,
    input clk,
    input rst
);

    reg [7:0] mem [0:65535]; // 64KB memory
    integer mcd;
    integer i;

    initial begin
        // Initialize memory with zero
        for (i = 0; i < 65536; i = i + 1) begin
            mem[i] = 8'd0;
        end
    end

    // Read logic: only read when `enable` is high and `wr` is low
    always @(*) begin
        if (enable && ~wr) begin
            data_out = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]}; // 4-byte read
        end else begin
            data_out = 32'b0; // Default to 0 if not reading
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            // Reset memory contents on reset
            for (i = 0; i < 65536; i = i + 1) begin
                mem[i] <= 8'd0;
            end
        end else if (enable && wr) begin
            // Write data to memory (byte-wise)
            mem[addr+3] <= data_in[31:24];
            mem[addr+2] <= data_in[23:16];
            mem[addr+1] <= data_in[15:8];
            mem[addr]   <= data_in[7:0];
        end

        // Create dump file when createdump is asserted
        if (createdump) begin
            mcd = $fopen("dumpfile", "w");
            for (i = 0; i < 65536; i = i + 1) begin
                $fdisplay(mcd, "%4h %2h", i, mem[i]);
            end
            $fclose(mcd);
        end
    end
endmodule
