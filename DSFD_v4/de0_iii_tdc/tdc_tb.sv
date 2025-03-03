`timescale 1ns/1ps

module tdc_tb;

logic clk, mod, wr;
logic[7:0] led, dac;
logic[1:0] key;

initial begin
clk = 0;
forever #10 clk = ~clk;
end

initial begin
key = 0;
#40 key[1] = 1;
#40 key[0] = 1;
end

DE0_TDC tdc (clk, led, key, 1'b1, mod, dac, wr);

endmodule
