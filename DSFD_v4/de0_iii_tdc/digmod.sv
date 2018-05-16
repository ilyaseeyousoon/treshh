module digmod (input clk, input clk_mod, input rst, output signal);

//set c-1!!
localparam c_low = 49, b_low = 29, n_low = 21, p_low = 20;
localparam c_high = 51, b_high = 20, n_high = 20, p_high = 19;

logic freq_change, dm_signal;
logic[15:0] dm_c, dm_b, dm_n, dm_p;

//dm_sv dm2_inst (clk, rst, dm_c, dm_b, dm_n, dm_p, dm_signal);
dm_min dm_inst (clk, rst, clk_mod, dm_signal);

always_ff @ (posedge clk_mod or negedge rst)
	begin
		if(!rst)
			begin
				freq_change <= 0;
				dm_c <= c_low;
				dm_b <= b_low;
				dm_n <= n_low;
				dm_p <= p_low;
			end
		else 
			begin
				freq_change <= ~freq_change;
		
				dm_c <= (freq_change) ? c_low : c_high;
				dm_b <= (freq_change) ? b_low : b_high;
				dm_n <= (freq_change) ? n_low : n_high;
				dm_p <= (freq_change) ? p_low : p_high;
			end
	end

assign signal = dm_signal;

endmodule
