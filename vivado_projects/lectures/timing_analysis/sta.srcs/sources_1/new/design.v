`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lviv Polytechnic National University
// Engineer: Mankovskyy Spartak
// 
// Create Date: 08/21/2026 09:41:58 PM
// Design Name: 
// Module Name: design
// Project Name: Demonstrating STA
// Target Devices: Cmod S7 (based on Spartan-7 FPGA)
// Tool Versions: 
// Description: This design implements a standard Register-to-Register path 
//              (Launch Flip-Flop → Combinational Logic → Capture Flip-Flop) 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// Візуальна підказка:
// clk -> reg_launch (Запуск) ----[ затримка comb_wire ]----> data_out (Фіксація) -> clk
module sta_demo (
    input wire clk,
    input wire rst,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);

    // 1. Тригер-джерело (Launch Flip-Flop / Source Register)
    reg [3:0] reg_launch;
    
    // Регістр для комбінаторної логіки
    reg [3:0] comb_wire;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_launch <= 4'h0;
        end else begin
            reg_launch <= data_in;
        end
    end

    // 2. Шлях комбінаторної логіки (створює затримку даних)
    // Додаємо арифметику, щоб змусити Vivado використати елементи LUT та логіку переносу
    always @(*) begin
        comb_wire = reg_launch << 1;
        comb_wire = comb_wire ^ 4'hFF; // інвертування
    end

    // 3. Тригер-приймач (Capture Flip-Flop / Destination Register)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 4'h0;
        end else begin
            data_out <= comb_wire;
        end
    end
    
endmodule
