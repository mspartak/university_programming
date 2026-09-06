`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lviv Polytechnic National University
// Engineer: Mankovskyy Spartak
// 
// Create Date: 06/09/2026 09:41:58 PM
// Design Name: 
// Module Name: design
// Project Name: DSP IP block
// Target Devices: Cmod S7 (based on Spartan-7 FPGA)
// Tool Versions: 
// Description: DSP block.
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
    input signed [15:0] in_sample_A, // Вхідний відлік сигналу x[n]
    input signed [15:0] in_coeff_B,  // Коефіцієнт фільтра h[n]
    output signed [31:0] out_mac_P   // Поточне значення акумулятора
);

    // Внутрішня шина для повного 48-бітного виходу DSP блоку
    wire [47:0] dsp_raw_output;

    // Підключення згенерованого макросу DSP48 
    dsp_macro_0 your_classic_dsp (
        .CLK(clk),  
        .SCLRP(rst),      
        .A(in_sample_A),    // 16-бітний відлік сигналу
        .B(in_coeff_B),     // 16-бітний коефіцієнт
        .P(dsp_raw_output)  // 48-бітний вихід
    );

    // Зрізаємо старші біти, оскільки для нашої розрядності достатньо 32 біти 
    assign out_mac_P = dsp_raw_output[31:0];
        
endmodule
