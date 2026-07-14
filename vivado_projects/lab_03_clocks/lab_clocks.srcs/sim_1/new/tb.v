`timescale 1ns / 1ps  // 1 unit = 1 ns, precision = 1 ps (Crucial for Xilinx Clock Wizard!)

module tb();

    // Inputs to the DUT (registers)
    reg [1:0] buttons;
    reg       tb_clk;
    reg       tb_reset;

    // Outputs from the DUT (wires)
    wire led1; // Maps to y1 (locked)
    wire led2; // Maps to y2 (led_1Hz_reg)
    wire led3; // Maps to y3 (pulse_1hz)
    wire led4; // Maps to y4 (clk_6mhz)

    // Instantiate the Device Under Test (DUT)
    top dut (
        .reset(tb_reset),
        .clk(tb_clk),
        .x1(buttons[0]),
        .x2(buttons[1]),        
        .y1(led1),
        .y2(led2),
        .y3(led3),
        .y4(led4)
    );

    // 1. 12 MHz Input Clock Generator
    // Total period = 83.3333 ns. Half-period = 41.6667 ns.
    initial begin
        tb_clk = 0;
        forever #41.6667 tb_clk = ~tb_clk;     
    end
  
    // 2. Simulation Control and Stimulus Scenario
    initial begin
        // Initialize inputs to a clean state to avoid 'X' values
        buttons = 2'b00;
        
        tb_reset = 1'b1;        
        #800;
        tb_reset = 1'b0;

    end
  
endmodule
