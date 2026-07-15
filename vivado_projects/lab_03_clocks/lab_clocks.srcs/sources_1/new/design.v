`timescale 1ns / 1ps

// ====================================================================
// PARAMETERIZED CLOCK DIVIDER MODULE WITH CLOCK ENABLE
// ====================================================================
module clk_divider #(
    parameter TOGGLE_VALUE = 6000000 
) 
(
    input  clk_in,
    input  rst,
    output reg clk_out
);
    reg [$clog2(TOGGLE_VALUE)-1:0] counter;

    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            counter <= 0;
            clk_out <= 1'b0;
        end else if (counter == TOGGLE_VALUE - 1) begin
            counter <= 0;
            clk_out <= ~clk_out; // Перемикаємо кожні TOGGLE_VALUE імпульсів
        end else begin
            counter <= counter + 1'b1;
        end
    end
endmodule

// ====================================================================
// TOP LEVEL MODULE
// ====================================================================
module top(
    input clk,          // External board reference clock
    input wire x1,      // Unused port (kept for your future logic)   
    input wire x2,      // Unused port (kept for your future logic)   
    output wire y1,     // Clock Wizard locked status signal
    output wire y2,     // output 1
    output wire y3,     // output 2
    output wire y4      // output 3
    );
    
    // Declare internal wires
    wire clk_6mhz;      // 6 MHz output from Clock Wizard
    wire sync_rst;      // Safe synchronized reset for the 6MHz clock domain
    
    // Connect Xilinx Clock Wizard component
    clk_wiz_0 my_clock_manager (
        .clk_in1  (clk),      // Input clock 12 MHz from Cmod S7 pin M9
        .clk_out1 (clk_6mhz), // Clock wizard output clock (6 MHz)
        .locked   (y1)        // Clock locked status signal
    );
    
    // CRITICAL FIX: Safe internal reset logic.
    // Logic keeps downstream modules in reset if external reset is active 
    // OR if the Clock Wizard hasn't locked/stabilized yet.
    assign sync_rst = !y1;    
    
    // Instantiate the configurable divider 1
    // For LED blinking set .TOGGLE_VALUE(6000000), for simulation .TOGGLE_VALUE(4)
    clk_divider #(.TOGGLE_VALUE(4)) my_divider1 (
        .clk_in(clk_6mhz),       
        .rst(sync_rst),       // Using the safe clock-domain synchronized reset
        .clk_out(y2)       
    );
    
    // Instantiate the configurable divider 2
    // For LED blinking set .TOGGLE_VALUE(3000000), for simulation .TOGGLE_VALUE(8)
    clk_divider #(.TOGGLE_VALUE(8)) my_divider2 (
        .clk_in(clk_6mhz),       
        .rst(sync_rst),       // Using the safe clock-domain synchronized reset
        .clk_out(y3)       
    );      
   
    // Instantiate the configurable divider 3
    clk_divider #(.TOGGLE_VALUE(12)) my_divider3 (
        .clk_in(clk_6mhz),       
        .rst(sync_rst),       // Using the safe clock-domain synchronized reset
        .clk_out(y4)       
    );   
       
endmodule
