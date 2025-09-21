`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lviv Polytechnic National University
// Engineer: Mankovskyy Spartak
// 
// Create Date: 09/14/2025 09:41:58 PM
// Design Name: 
// Module Name: design
// Project Name: Lab_01 : Simple truth table implementation
// Target Devices: Cmod S7 (based on Spartan-7 FPGA)
// Tool Versions: 
// Description: Push buttons and LEDs will be turned off and on according to given truth table.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input wire x1,
    input wire x2,
    output wire y1,
    output wire y2,
    output wire y3,
    output wire y4
    );
    
    assign y1 = x1 | !x2;
    assign y2 = !x1 & x2;
    assign y3 = x1 & !x2;
    assign y4 = x2;
        
endmodule
