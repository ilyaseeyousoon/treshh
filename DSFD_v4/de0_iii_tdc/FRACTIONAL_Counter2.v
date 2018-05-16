// (c) D.Shelestov // 24-10-2014 Bauman MSTU SEC Photonics and IR-Technology
// Fractional Counter - not standard version
module FRACTIONAL_Counter2(clk, clk_en, mod, signal, frac_out, frac_raw, signal_raw, neg_max_out,buffer_neg1_out, frac_wr);

	// Input Ports
	input clk;
	input clk_en;
	input mod;
	input signal;

	// Output Port
	output [15:0] frac_out;
	output [15:0] frac_raw;
	output signal_raw;
	output [15:0] neg_max_out;
	output [15:0] buffer_neg1_out; 
	output frac_wr;
	
	assign signal_raw = signal;
	reg [15:0] frac_out = 0;
	reg [15:0] frac_raw = 0;
	
	reg[15:0] frac = 0;
	reg[15:0] pos_max = 0;
	reg[15:0] neg_max = 0;
	reg[15:0] buffer_pos1 = 0; 
	reg[15:0] buffer_pos2 = 0;
	reg[15:0] buffer_neg1 = 0;
	reg[15:0] buffer_neg2 = 0;
	reg[15:0] neg_max_out = 0;
	reg[15:0] buffer_neg1_out = 0;
	reg pos_start = 0; 
	reg neg_start = 0;
	
		
	// Edge detection addon
	reg signal_prev = 0;
	always@(posedge clk) signal_prev = signal;
	wire signal_posedge = !signal_prev & signal;
	
	reg mod_prev = 0;
	always@(posedge clk) mod_prev = mod;
	wire mod_xor;
	assign mod_xor = mod_prev ^ mod;
	
	// Main 16-bit Fractional Counter 
	always@(posedge clk)
		begin
			frac_raw <= frac;
			if (signal_posedge)	frac <= 0;		
			else if (clk_en) frac <= frac + 1;
				  else frac <= 0;
		end
	
	// Modulation BOTHedges Event hadler 	
	wire mod_posedge = !mod_prev & mod;
	wire mod_negedge = mod_prev & !mod;
	
	always@(posedge clk)
	begin
		// modulation posedge event
		if (mod_posedge)
			begin
			if (!(signal_posedge)) buffer_pos1 <= frac;
			else buffer_pos1 <= 0;
			pos_start = 1; 
			end
		else pos_start = 0;
		
		// modulation negedge event
		if (mod_negedge)
			begin
			if (!(signal_posedge))	
				begin buffer_neg1 <= frac;
						buffer_neg1_out <= frac; // debug
				end
			else
				begin buffer_neg1 <= 0;
						buffer_neg1_out <= 0; // debug
				end
			neg_start = 1; 
			end
		else neg_start = 0; 
	end
		
	// Output register update	
	always@(posedge clk)
	if (mod_xor)
			if (mod) frac_out <= frac + buffer_neg2;
			else 		frac_out <= frac + buffer_pos2;

	
	
	// maximum search cycles
	always@(posedge clk)
	if ( pos_start | (pos_max > 0))
		if (frac >= pos_max)
			if (frac == 0) pos_max <= 1;
			else pos_max <= frac;
		else 
		begin
			buffer_pos2 <= pos_max - buffer_pos1;
			pos_max <= 0;
		end
		
	always@(posedge clk)
	if ( neg_start | (neg_max > 0))
		if (frac >= neg_max) 
			if (frac == 0) neg_max <= 1;
			else neg_max <= frac;
		else 
		begin
			buffer_neg2 <= neg_max - buffer_neg1;
			neg_max_out <= neg_max;  // debug
			neg_max <= 0;
		end
	
endmodule
