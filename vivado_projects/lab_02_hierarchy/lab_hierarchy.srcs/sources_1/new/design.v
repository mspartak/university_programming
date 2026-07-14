`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lviv Polytechnic National University
// Engineer: Mankovskyy Spartak
// 
// Create Date: 09/14/2025 09:41:58 PM
// Design Name: 
// Module Name: design
// Project Name: Lab_02 : Modules Hierarchy
// Target Devices: Cmod S7 (based on Spartan-7 FPGA)
// Tool Versions: 
// Description: n/a.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// Top design module.
module top(
  input x0,
  input x1,
  input x2,
  input x3,  
  output y1
);
 
  wire w1;
  wire w2;
  
  and2 D1(.a(x0),
          .b(x1),
          .y(w1));
          
  and2 D2(.a(x2),
          .b(x3),
          .y(w2)); 
          
  or2 D3(.a(w1),
         .b(w2),
         .y(y1)); 
  
endmodule


// Create AND logic gate with 2 inputs a and b and output y.
module and2(
  input a,
  input b,
  output y
);
 
  assign y = a & b;
  
endmodule
  
// Create OR logic gate with 2 inputs a and b and output y.
module or2(
  input a,
  input b,
  output y
);
 
  assign y = a | b;
  
endmodule

