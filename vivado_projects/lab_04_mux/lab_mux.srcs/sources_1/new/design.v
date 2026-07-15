`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lviv Polytechnic National University
// Engineer: Mankovskyy Spartak
// 
// Create Date: 09/14/2025 09:41:58 PM
// Design Name: 
// Module Name: design
// Project Name: Signals multiplexer
// Target Devices: Cmod S7 (based on Spartan-7 FPGA)
// Tool Versions: 
// Description: n/a
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

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


module top( 
    input clk,          // External board reference clock
    input wire x1,      // Unused port (kept for your future logic)   
    input wire x2,      // switch signal by user button click
    output wire y1,     // Clock Wizard locked status signal
    output wire y2,     // output
    output wire y3,     // output
    output wire y4      // output
);  

  reg [1:0] switch = 2'b00;
  wire sync_rst;      // Safe synchronized reset for the 6MHz clock domain
  
  wire [2:0] a;
  wire [2:0] b;
  
  wire clk_6mhz;
  wire pulse_1;
  wire pulse_2;
  wire pulse_3;
  
  // Assign multiplexer outputs  
  assign y2 = (a[0] & ((~switch[0]) & (~switch[1])))
    | (a[1] & ((switch[0]) & (~switch[1])))
    | (a[2] & ((~switch[0]) & (switch[1])));
  
  assign y3 = (b[0] & ((~switch[0]) & (~switch[1])))
    | (b[1] & ((switch[0]) & (~switch[1])))
    | (b[2] & ((~switch[0]) & (switch[1])));
    
  // internal synchronous reset  
  assign sync_rst = !y1;  
  
  // assign signals to inputs a and b
  assign a[0] = pulse_1;
  assign a[1] = pulse_2;
  assign a[2] = pulse_3;
  
  assign b[0] = pulse_3;
  assign b[1] = pulse_2;
  assign b[2] = pulse_1;
     
    // Connect Xilinx Clock Wizard component
    clk_wiz_0 my_clock_manager (
        .clk_in1  (clk),      // Input clock 12 MHz from Cmod S7 pin M9
        .clk_out1 (clk_6mhz), // Clock wizard output clock (6 MHz)
        .locked   (y1)        // Clock locked status signal
    );
    
    // Instantiate the configurable divider 1
    // For LED blinking set .TOGGLE_VALUE(6000000), for simulation .TOGGLE_VALUE(2)
    clk_divider #(.TOGGLE_VALUE(2)) my_divider1 (
        .clk_in(clk_6mhz),       
        .rst(sync_rst),       // Using the safe clock-domain synchronized reset
        .clk_out(pulse_1)       
    );
    
    // Instantiate the configurable divider 2
    // For LED blinking set .TOGGLE_VALUE(3000000), for simulation .TOGGLE_VALUE(4)
    clk_divider #(.TOGGLE_VALUE(4)) my_divider2 (
        .clk_in(clk_6mhz),       
        .rst(sync_rst),       // Using the safe clock-domain synchronized reset
        .clk_out(pulse_2)       
    );      
   
    // Instantiate the configurable divider 3
    clk_divider #(.TOGGLE_VALUE(8)) my_divider3 (
        .clk_in(clk_6mhz),       
        .rst(sync_rst),       // Using the safe clock-domain synchronized reset
        .clk_out(pulse_3)       
    );       


  reg x1_past = 1'b0;

  always @(posedge clk_6mhz) begin
      x1_past <= x1;
  end

  wire x1_pressed = x1 && !x1_past;
 
  // To discuss why is not used "always @(posedge x1_pressed)"
  always @(posedge clk_6mhz or posedge sync_rst) begin
    if (sync_rst) begin
      switch <= 2'b00;
    end else if (x1_pressed) begin
      if (switch == 2) begin
        switch <= 0;
      end else begin
        switch <= switch + 1;
      end
    end
  end // always
  
endmodule
 