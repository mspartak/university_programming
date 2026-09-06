`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lviv Polytechnic National University
// Engineer: Mankovskyy Spartak
// 
// Create Date: 06/09/2026 09:41:58 PM
// Design Name: 
// Module Name: design
// Project Name: DSP implicit
// Target Devices: Cmod S7 (based on Spartan-7 FPGA)
// Tool Versions: 
// Description: Lesson DSP.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module top(
    input clk,
    input rst,
    input signed [15:0] alloc_A,
    input signed [15:0] alloc_B,
    input signed [31:0] alloc_C,
    output reg signed [31:0] out_P
);
    reg signed [15:0] r_A;
    reg signed [15:0] r_B;
    reg signed [31:0] r_C;
    reg signed [31:0] r_mult;

    always @(posedge clk) begin
        if (rst) begin
            r_A    <= 0; r_B <= 0; r_C <= 0;
            r_mult <= 0; out_P <= 0;
        end else begin
            r_A    <= alloc_A;  // Крок конвеєра 1 (Вхід)
            r_B    <= alloc_B;
            r_C    <= alloc_C;
            r_mult <= r_A * r_B; // Крок конвеєра 2 (Множення)
            out_P  <= r_mult + r_C; // Крок конвеєра 3 (Акумуляція)
        end
    end
endmodule
