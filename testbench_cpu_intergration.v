`timescale 1ns / 1ps

module tb_single_cycle_cpu;

    // Signals
    reg clk;
    reg rst;

    // Instantiate DUT
    single_cycle_cpu uut (
        .clk(clk),
        .rst(rst)
    );

    // Clock Generation (50 MHz)
    always begin
        #10 clk = ~clk; // Toggles every 10 ns
    end

    // Testbench Initialization
    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;

        // Apply Reset
        #25 rst = 0;

        // Run simulation for sufficient time
        #1000;
        $stop;
    end

    // Monitor PC and Registers
    initial begin
        $monitor("Time: %dns | PC: %h | R1: %d | R2: %d | R3: %d | R4: %d",
                 $time, uut.pc_out, uut.register_file[1], uut.register_file[2], uut.register_file[3], uut.register_file[4]);
    end

endmodule
