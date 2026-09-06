`timescale 1ns / 1ps

module tb();
   // 1. Оголошення сигналів для підключення до модуля (UUT)
    reg clk;
    reg rst;
    reg signed [15:0] test_A;
    reg signed [15:0] test_B;
    reg signed [31:0] test_C;
    
    wire signed [31:0] out_P;

    // 2. Ініціалізація модуля, який тестуємо (Unit Under Test - UUT)
    top uut (
        .clk(clk),
        .rst(rst),
        .alloc_A(test_A),
        .alloc_B(test_B),
        .alloc_C(test_C),
        .out_P(out_P)
    );

    // 3. Генератор тактового сигналу (Clock Generator)
    // Період 10 нс = частота 100 МГц
    always begin
        #5 clk = ~clk;
    end

    // 4. Основний блок стимулів (Test Stimulus)
    initial begin
        // Початкові значення
        clk = 0;
        rst = 1;
        test_A = 0;
        test_B = 0;
        test_C = 0;

        // Тримаємо скидання 20 нс (2 такти)
        #20;
        rst = 0;
        #10; // Чекаємо один чистий такт

        // --- Тест : Просте множення та додавання ---
        // Очікуємо: P = (2 * 3) + 10 = 16
        // Зверніть увагу на затримку конвеєра!
        test_A = 16'd2;
        test_B = 16'd3;
        test_C = 32'd10;
        #50;       
        // --- Тест : Обнулення входів ---
        test_A = 16'd0;
        test_B = 16'd0;
        test_C = 32'd0;        
        // Чекаємо кілька тактів, щоб усі результати пройшли через конвеєр до виходу
        #50;

        // Зупинка симуляції
        $display("Симуляція завершена успішно.");
        $finish;
    end

endmodule 