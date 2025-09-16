`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2025 09:41:58 PM
// Design Name: 
// Module Name: design
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
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
