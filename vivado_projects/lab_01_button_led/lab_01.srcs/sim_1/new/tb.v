`timescale 1ns / 1ps

module tb();

reg [1:0] buttons;
wire led1;
wire led2;
wire led3;
wire led4;

top dut(
 .x1(buttons[0]),
 .x2(buttons[1]),
 .y1(led1),
 .y2(led2),
 .y3(led3),
 .y4(led4)
);

initial begin

#10 buttons = 2'b11;

end

endmodule 