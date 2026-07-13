`timescale 1ns / 1ps

// ====================================================================
// PARAMETERIZED CLOCK DIVIDER MODULE WITH CLOCK ENABLE
// ====================================================================
module clk_divider #(
    parameter DIV_VALUE = 6000000 // Default division factor (e.g., 6 MHz to 1 Hz)
) 
(
    input  clk_in,     // Main input clock (e.g., 6 MHz from Clock Wizard)
    input  rst,        // Reset signal (active high)
    output reg clk_en  // Clock Enable pulse (active high for exactly 1 clk_in cycle)
);
    // Automatically calculate the required bit-width for the counter during compilation
    reg [$clog2(DIV_VALUE)-1:0] counter;

    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            counter <= 0;
            clk_en  <= 0;
        end else begin
            if (counter == DIV_VALUE - 1) begin
                counter <= 0;
                clk_en  <= 1; // Assert the enable pulse for exactly 1 clock cycle
            end else begin
                counter <= counter + 1;
                clk_en  <= 0; // Remain low during all other cycles
            end
        end
    end
endmodule

// ====================================================================
// TOP LEVEL MODULE
// ====================================================================
module top(
    input wire x1,
    input wire x2,
    input clk,
    output wire y1,
    output wire y2,
    output wire y3,
    output wire y4
    );
    
    // Declare internal wires
    wire clk_6mhz;      // 6 MHz output from Clock Wizard
    wire pulse_1hz;     // Enable pulse from the divider
    wire rst_internal;  // Internal safe reset based on lock status
    
    // Register for the toggling LED
    reg led_1Hz_reg = 0;
    
    // Safe internal reset logic (Active-high reset while clock is NOT locked)
    assign rst_internal = !y1; 
    
    // Assign internal signals to top-level outputs
    assign y2 = led_1Hz_reg;
    assign y3 = pulse_1hz;
    assign y4 = clk_6mhz;
    
    // Connect Xilinx Clock Wizard component
    clk_wiz_0 my_clock_manager (
        .clk_in1  (clk),      // Input clock 12 MHz from Cmod S7 pin M9
        .reset    (1'b0),     // Hardwired reset to low level (disabled)
        .clk_out1 (clk_6mhz), // Clock wizard output clock (6 MHz)
        .locked   (y1)        // Clock locked status signal
    );
    
    // Instantiate the configurable divider (Set to DIV_VALUE=10 for simulation testing)
    // Note: Change 10 to 6000000 when generating Bitstream for the actual hardware!
    clk_divider #(.DIV_VALUE(10)) my_1hz_gen (
        .clk_in(clk_6mhz),       
        .rst(rst_internal),
        .clk_en(pulse_1hz)       
    );   
    
    // FIXED: Toggle the LED safely by adding reset condition to prevent 'X' states
    always @(posedge clk_6mhz or posedge rst_internal) begin
        if (rst_internal) begin
            led_1Hz_reg <= 1'b0;       // Force a stable '0' state during reset/lock-time
        end else if (pulse_1hz) begin
            led_1Hz_reg <= ~led_1Hz_reg; // Safely toggle the LED state
        end
    end
       
endmodule
