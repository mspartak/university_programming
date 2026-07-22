`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lviv Polytechnic National University
// Engineer: Mankovskyy Spartak
// 
// Create Date: 09/14/2025 09:41:58 PM
// Design Name: 
// Module Name: design
// Project Name: Serial interface
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
// Data Transmitter (parallel to serial interface)
// ====================================================================
module transmitter(
  input [7:0] data,
  input clk,
  input load,
  output clk_out,
  output data_out
);  
  reg [7:0] buffer = 8'b00000000;
  reg [1:0] state = 2'b00; /* 00b - IDLE, 01b - SEND_HIGH, 10b - SEND_LOW */
  reg [4:0] bit_counter;
  reg clk_out = 1'b0;
  
  assign data_out = buffer[0];
 
  always @(posedge clk)
  begin  
    case (state)
    /* IDLE */   
    2'b00: 
      begin  
        clk_out <= 1'b0;
        if (load == 1'b1) begin
          buffer <= data;
          state <= 2'b01;
          bit_counter <= 8;
        end          
      end
    /* SEND_HIGH */   
    2'b01: 
      begin
        clk_out <= 1'b1;
        state   <= 2'b10;
      end  
    /* SEND_LOW */  
    2'b10: 
      begin
        clk_out <= 1'b0;
        bit_counter <= bit_counter - 1;
        buffer [7:0] <= {1'b0, buffer[7:1]}; /* right shift */
        if (bit_counter == 1) 
        begin
          state <= 2'b00;  
        end  
        else begin
          state <= 2'b01; /* Switch to SEND_HIGH */       
        end 
      end
    endcase
  end // always
endmodule

// ====================================================================
// Top design
// ====================================================================
module top( 
    input clk,          // External board reference clock
    input wire x1,      // button 1: start data #1 transmit
    input wire x2,      // button 2: start data #2 transmit
    output wire y1,     // Clock Wizard locked status signal
    output wire y2,     // Serial data clock
    output wire y3,     // Serial data
    output wire y4      // reserved
);  

  reg load_data = 1'b0;
  reg [7:0]new_data = 8'b00000000; 
  
  wire sync_rst;      // Safe synchronized reset for the 6MHz clock domain  
  wire clk_6mhz;
    
  // internal synchronous reset  
  assign sync_rst = !y1;   
     
  // Connect Xilinx Clock Wizard component
  clk_wiz_0 my_clock_manager (
    .clk_in1  (clk),      // Input clock 12 MHz from Cmod S7 pin M9
    .clk_out1 (clk_6mhz), // Clock wizard output clock (6 MHz)
    .locked   (y1)        // Clock locked status signal
  );  

  /* serial transmitter */
  transmitter my_tx(
    .data(new_data),
    .clk(clk_6mhz),
    .load(load_data),
    .clk_out(y2),
    .data_out(y3)
    );
    
  reg x1_past = 1'b0;
  reg x2_past = 1'b0;

  always @(posedge clk_6mhz) begin
      x1_past <= x1;
      x2_past <= x2;
  end

  /* key pressed detection logic */
  wire x1_pressed = x1 && !x1_past;
  wire x2_pressed = x2 && !x2_past;

  always @(posedge clk_6mhz) begin
    if (sync_rst) begin
      load_data <= 1'b0;
    end else begin
      if (x1_pressed && !load_data) begin
        /* load new data corresponding to button 1 */
        new_data = 8'b11101001;
        load_data <= 1'b1;
      end  
      else if (x2_pressed && !load_data) begin
        /* load new data corresponding to button 2 */
        new_data = 8'b01110101;
        load_data <= 1'b1;         
      end else begin
        load_data <= 1'b0;
      end
    end
  end
      
endmodule
 