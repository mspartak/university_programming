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
    input reset,        // External hardware reset pin
    input clk,          // External board reference clock
    input wire x1,      // Unused port (kept for your future logic)
    input wire x2,      // Unused port (kept for your future logic)   
    output wire y1,     // Clock Wizard locked status signal
    output wire y2,     // Toggling LED indicator
    output wire y3,     // 1 Hz clock enable pulse
    output wire y4      // Exposed 6 MHz clock
    );
    
    // Declare internal wires
    wire clk_6mhz;      // 6 MHz output from Clock Wizard
    wire pulse_1;      // Pulse from the divider 1
    wire pulse_2;      // Pulse from the divider 2
    wire pulse_3;      // Pulse from the divider 3
    wire sync_rst;      // Safe synchronized reset for the 6MHz clock domain
    
    // Register for the toggling y-outputs
    reg y2_reg = 0;
    reg y3_reg = 0;
    reg y4_reg = 0;
    
    // Connect Xilinx Clock Wizard component
    clk_wiz_0 my_clock_manager (
        .clk_in1  (clk),      // Input clock 12 MHz from Cmod S7 pin M9
        .reset    (reset),    // Connected to external reset pin
        .clk_out1 (clk_6mhz), // Clock wizard output clock (6 MHz)
        .locked   (y1)        // Clock locked status signal
    );
    
    // CRITICAL FIX: Safe internal reset logic.
    // Logic keeps downstream modules in reset if external reset is active 
    // OR if the Clock Wizard hasn't locked/stabilized yet.
    assign sync_rst = reset || (!y1);
    
    // Assign internal signals to top-level outputs
    assign y2 = y2_reg;
    assign y3 = y3_reg;
    assign y4 = y4_reg;
    
    // Instantiate the configurable divider 1
    clk_divider #(.DIV_VALUE(4)) my_divider1 (
        .clk_in(clk_6mhz),       
        .rst(sync_rst),       // Using the safe clock-domain synchronized reset
        .clk_en(pulse_1)       
    );
    
    // Instantiate the configurable divider 2
    clk_divider #(.DIV_VALUE(8)) my_divider2 (
        .clk_in(clk_6mhz),       
        .rst(sync_rst),       // Using the safe clock-domain synchronized reset
        .clk_en(pulse_2)       
    );      
   
    // Instantiate the configurable divider 3
    clk_divider #(.DIV_VALUE(12)) my_divider3 (
        .clk_in(clk_6mhz),       
        .rst(sync_rst),       // Using the safe clock-domain synchronized reset
        .clk_en(pulse_3)       
    );   
    
    // Toggle the LED safely
    always @(posedge clk_6mhz or posedge sync_rst) begin
        if (sync_rst) begin
            y2_reg <= 1'b0;       // Force a stable '0' state during reset/lock-time
            y3_reg <= 1'b0;       // Force a stable '0' state during reset/lock-time
            y4_reg <= 1'b0;       // Force a stable '0' state during reset/lock-time
        end else 
        begin
            if (pulse_1) begin           
                y2_reg <= ~y2_reg;        // Safely toggle the LED state
            end
            if (pulse_2) begin           
                y3_reg <= ~y3_reg;        // Safely toggle the LED state
            end
            if (pulse_3) begin           
                y4_reg <= ~y4_reg;        // Safely toggle the LED state
            end
        end
    end
       
endmodule
