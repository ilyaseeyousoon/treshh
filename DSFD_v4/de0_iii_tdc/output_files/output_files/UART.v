module UART #(
//сountOfStrobe = Fclk(Гц)/Vuart(бит/c) = 200*10^6 / 500000 = 400
                            parameter countOfStrobe = 100    // Параметр, который высчитывается из соотношения Fclk[Гц] / V[бит/c]
                                                            // соответствует тому, сколько тактов приходится на передачу одного
                                                            // бита данных при выбраной скорости UART(бит/с) и тактовой частоте CLK (Гц)
                            )(
                            input clk,                       // Тактовая частота
                            input [7:0] data,              // Данные, которые собираемся передать по TX
                            input data_rdy,                // Строб, который соответствует тому, что данные валидные и их нужно передать
                            output reg tx = 1,          // Выходной порт, передает данные по последовательному интерфейсу
                            output reg transm_rdy = 1   // Строб, который сигнализирует о том, что данные переданы и блок готов к передаче новых данных
                            );
     
    reg [1:0] state = 2'b00;     // Регистр, который будет менять значение в зависимости от состояния нашего модуля
    reg [7:0] cntStrobe = 0;     // Регистр - счетчик, который будет накапливаться до необходимого числа стробов (до countOfStrobe)
    reg [4:0] cntBit = 0;         // Регистр - счетчик, указываюший на номер передаваемого бита из data
    reg [7:0] shiftData;         // Сдвиговый регистр, в который мы записываем входные данные (data), а затем последовательно, побитово
                                 // передаем по TX
     
    always @(posedge clk)
    begin
	 
	 
	 
        case(state)
            2'b00 :    begin
                        if (data_rdy)
                        begin
                            state <= 2'b01;
                            shiftData <= data;
                            transm_rdy <= 0;         
                            tx <= 0;
                        end
                    end
            2'b01 :    begin
                        if (cntBit == 0)
                        begin
                            if (cntStrobe < countOfStrobe)
                                cntStrobe <= cntStrobe + 1;
                            else
                            begin
                                cntStrobe <= 0;
                                cntBit <= 1;
                                tx <= shiftData[0];
                                shiftData[6:0] <= shiftData[7:1];
                            end
                        end
                        if (cntBit > 0 && cntBit < 9)
                        begin
                            if (cntStrobe < countOfStrobe)
                                cntStrobe <= cntStrobe + 1;
                            else
                            begin
                                cntStrobe <= 0;
                                cntBit <= cntBit + 1;
                                tx <= shiftData[0];
                                shiftData[6:0] <= shiftData[7:1];
                            end
                        end
                        if (cntBit == 9)
                        begin
                            if (cntStrobe < countOfStrobe)
                            begin
                                cntStrobe <= cntStrobe + 1;                             
                                tx <= 1;
                            end
                            else
                            begin
                                cntStrobe <= 0;
                                cntBit <= 0;
                                transm_rdy <= 1;
                                state <= 2'b00;
                            end
                        end
                    end
             
        endcase
    end
endmodule