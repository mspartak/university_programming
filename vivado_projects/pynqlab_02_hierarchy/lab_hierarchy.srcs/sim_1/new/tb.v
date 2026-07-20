`timescale 1ns / 1ps

module tb();

  reg x0;   // Button
  reg x1;   // Button 
  reg x2;   // Button 
  reg x3;   // Button  
  wire y1;  // LED y1
  
  // Instantiate design under test
  top dut(.x0(x0),
          .x1(x1),
          .x2(x2),
          .x3(x3),                     
          .y1(y1));
          
  initial begin
      // Generate signals combinations.
      x0 = 1'b0;
      x1 = 1'b0;
      x2 = 1'b0;  
      x3 = 1'b0;        
      #2
      x0 = 1'b1;
      x1 = 1'b1;
      x2 = 1'b0;  
      x3 = 1'b0;           
      #2
      x0 = 1'b0;
      x1 = 1'b1;
      x2 = 1'b1;  
      x3 = 1'b0;           
      #2
      x0 = 1'b0;
      x1 = 1'b0;
      x2 = 1'b1;  
      x3 = 1'b1;            
      #2
      x0 = 1'b0;
      x1 = 1'b1;
      x2 = 1'b0;  
      x3 = 1'b1;  
      #2
      x0 = 1'b1;
      x1 = 1'b0;
      x2 = 1'b1;  
      x3 = 1'b0;
      #2
      x0 = 1'b1;
      x1 = 1'b0;
      x2 = 1'b0;  
      x3 = 1'b1;
      #2 
      x0 = 1'b0;
      x1 = 1'b0;
      x2 = 1'b0;  
      x3 = 1'b0; 
  end

endmodule 