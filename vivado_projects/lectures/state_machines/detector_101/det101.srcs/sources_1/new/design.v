`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lviv Polytechnic National University
// Engineer: Mankovskyy Spartak
// 
// Create Date: 09/14/2025 09:41:58 PM
// Design Name: 
// Module Name: design
// Project Name: detector 101
// Target Devices: n/a
// Tool Versions: 
// Description: Detects sequence "101"
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module seq_det_101_moore (
    input clk,
    input reset,
    input in,
    output reg out
);
    // Використання параметрів для гнучкості кодування Vivado
    localparam S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
    reg [1:0] state, next_state;

    // Block 1: Sequential State Register
    always @(posedge clk) begin
        if (reset) state <= S0;
        else state <= next_state;
    end

    // Block 2: Next State Combinational Logic
    always @* begin
        next_state = state; // Захист від INFER-1 (Latches)
        case (state)
            S0: next_state = (in) ? S1 : S0;
            S1: next_state = (in) ? S1 : S2;
            S2: next_state = (in) ? S3 : S0;
            S3: next_state = (in) ? S1 : S2; // Overlapping detection
            default: next_state = S0;
        endcase
    end

    // Block 3: Output Combinational Logic
    always @* begin
        out = (state == S3);
    end
endmodule


