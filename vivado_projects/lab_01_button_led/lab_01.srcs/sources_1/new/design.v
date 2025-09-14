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
    input x1,
    input x2,
    output y1,
    output y2,
    output y3,
    output y4
    );
    
    reg [3:0] dummy = 0;
    
    assign y1 = dummy[0];
    assign y2 = dummy[1];
    assign y3 = dummy[2];
    assign y4 = dummy[3];
    
endmodule
