`timescale 1ns/1ps

module ph_tb;

logic clk, rst;
logic[1:0] key;
logic mod;

initial begin
clk = 0;
forever #10 clk = ~clk;
end

initial begin
rst = 0;
#60 rst = 1;
end

initial begin
key = 0;
#40 begin 
	key[1] = 1;
	key[0] = 1;
end

#200 key[0] = 0;
#100 key[0] = 1;

#2000 key[0] = 0;
#100 key[0] = 1;
end

phase_controller ph_inst (clk, rst, key, 1'b1, mod);

endmodule
