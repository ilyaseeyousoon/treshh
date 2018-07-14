module time_counter (input clk, input rst, input signal, input mod, 
							  output[10:0] frac_part, output[10:0] int_part, output wrena );
							  
//!!! Problem in latching data from tail negative counter

logic hp_wr, hn_wr, tp_wr, tn_wr, ip_wr, in_wr, p_data_valid, n_data_valid,
		signal_d, mod_d, wr_en, neg_wr_en, signal_q;

logic[2:0] p_data_rdy, n_data_rdy, lr_mod_pos, lr_mod_neg;		
logic[10:0] hp_code, hn_code, tp_code, tn_code, hp_reg, hn_reg, tp_reg, tn_reg;
logic[10:0] fr_sum, fr_sum_d;
logic[10:0] ip_code, in_code, ip_reg, in_reg, int_out, int_out_d;
logic[11:0] out_time;
logic[3:0] lr_mod, lr_signal;

head_counter head_ctr_pos (clk, rst, mod_posedge, signal_xor, hp_code, hp_wr);
head_counter head_ctr_neg (clk, rst, mod_negedge, signal_xor, hn_code, hn_wr);

tail_counter tail_ctr_pos (clk, rst, signal_xor, mod_negedge, tp_code, tp_wr);
tail_counter tail_ctr_neg (clk, rst, signal_xor, mod_posedge, tn_code, tn_wr);

integer_counter int_ctr_pos (clk, rst, mod_posedge, mod_negedge, signal_xor, ip_code, ip_wr);
integer_counter int_ctr_neg (clk, rst, mod_negedge, mod_posedge, signal_xor, in_code, in_wr);

assign mod_posedge = !mod_d && mod;		
assign mod_negedge = mod_d && !mod;		
assign signal_xor = signal_d ^ signal;
//assign signal_xor = signal_d;

assign p_data_valid = & p_data_rdy && !mod_d;
assign n_data_valid = & n_data_rdy && mod_d;

assign frac_part = fr_sum;
assign int_part = int_out;
assign wrena = wr_en;

always_ff @ (posedge clk or negedge rst)
	begin
		if(!rst)
			begin
				signal_d <= 0;
				signal_q <= 0;
				mod_d <= 0;
				out_time <= 0;
				wr_en <= 0;
				lr_mod <= 0;
				lr_signal <= 0;
				p_data_rdy <= 0;
				n_data_rdy <= 0;
				hp_reg <= 0;
				hn_reg <= 0;
				tp_reg <= 0;
				tn_reg <= 0;
				ip_reg <= 0;
				in_reg <= 0;
				fr_sum <= 0;
				int_out <= 0;
				lr_mod_pos <= 0;
				lr_mod_neg <= 0;
			end
		else
			begin
				signal_d <= signal;
				mod_d <= mod;
				
				if(hp_wr)
					begin
						hp_reg <= hp_code;
						p_data_rdy[2] <= 1'b1;
					end
				if(tp_wr)
					begin
						tp_reg <= tp_code;
						p_data_rdy[1] <= 1'b1;
					end
				if(ip_wr)
					begin
						ip_reg <= ip_code;
						p_data_rdy[0] <= 1'b1;
					end
				
				if(hn_wr) 
					begin
						hn_reg <= hn_code;
						n_data_rdy[2] <= 1'b1;
					end
				if(tn_wr) 
					begin
						tn_reg <= tn_code;
						n_data_rdy[1] <= 1'b1;
					end
				if(in_wr)
					begin
						in_reg <= in_code;
						n_data_rdy[0] <= 1'b1;
					end
				
				if(p_data_valid)	//send data from positive counters
					begin
						fr_sum <= hp_reg + tp_reg;
						int_out <= ip_reg - 1;
						wr_en <= 1;
						p_data_rdy <= 0;
					end
				else 
					if(n_data_valid)	//send data from negative counters
					begin
						fr_sum <= hn_reg + tn_reg;
						int_out <= in_reg - 1;
						wr_en <= 1;
						n_data_rdy <= 0;
					end
				else wr_en <= 0;
			end
	end
	
endmodule
