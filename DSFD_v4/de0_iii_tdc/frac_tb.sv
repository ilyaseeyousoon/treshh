`timescale 1ns/1ps

module frac_tb;

logic clk, rst, start, stop, int_wrena, fr_wrena_h, fr_wrena_t, signal, mod, signal_d, mod_d;
logic h_start, h_stop, t_start, t_stop, wrena;
logic[11:0] int_code, fr_code_h, fr_code_t, o_time;
logic[31:0] clk_div_s, clk_div_m;


initial begin
rst = 0;
#130 rst = 1;
end

initial begin
clk = 1'b1; 
forever #10 clk = ~clk;
end

initial begin
start = 0;
#170 start = 1;
#20 start = 0;
#40 start = 1;
#20 start = 0;
#20 start = 1;
#20 start = 0;
end

initial begin
stop = 0;
#390 stop = 1;
#20 stop = 0;
end

initial begin
clk_div_s = 0;
clk_div_m = 0;
end

initial begin
signal = 0;
//forever #400 signal = ~signal;
end

initial begin
mod = 0;
//forever #1000 mod = ~mod;
end

always_ff @ (posedge clk)
	begin
		mod_d <= mod;
		signal_d <= signal;
		
		if(clk_div_m == 99) 
			begin
				clk_div_m = 0;
				mod <= ~mod;
			end
		else clk_div_m <= clk_div_m + 1;
		
		if(clk_div_s == 17) 
			begin
				clk_div_s = 0;
				signal <= ~signal;
			end
		else clk_div_s <= clk_div_s + 1;
	end

assign h_start = mod_d ^ mod;//!mod_d && mod;
assign h_stop = signal_d ^ signal;

assign t_start = signal_d ^ signal;
assign t_stop = mod_d ^ mod;//mod_d && !mod;

time_counter ctr_test (clk, rst, signal, mod, o_time, wrena);

endmodule
