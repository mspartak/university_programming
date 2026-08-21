`timescale 1ns / 1ps

module tb;

    // Вхідні сигнали (тестові регістри)
    reg clk;
    reg rst;
    reg [3:0] data_in;

    // Вихідні сигнали
    wire [3:0] data_out;

    // Ініціалізація нашого модуля (DUT)
    sta_demo uut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Генератор тактового сигналу: період 10 нс (частота 100 МГц)
    always begin
        #5 clk = ~clk;
    end

    initial begin
        // Початкова ініціалізація
        clk = 0;
        rst = 1;
        data_in = 4'h0;

        // Подача сигналу скидання (Reset)
        #20;
        rst = 0;
        
        // Подача тестових даних
        #10 data_in = 4'h1;
        #10 data_in = 4'h2;
        #10 data_in = 4'h4;
        
        #50;
        $finish;
    end
      
endmodule
