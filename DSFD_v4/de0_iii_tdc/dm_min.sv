module dm_min (input clk, input rst, input mod, output signal, output out_mod);

localparam st_wait = 0, st_hf = 1, st_mf = 2, st_lf = 3;
localparam div_hf = 42 - 1, div_mf = 40 - 1, div_lf = 38 - 1;
localparam half_hf = 21 - 1, half_mf = 20 - 1, half_lf = 19 - 1;
localparam h_cycles = 2, l_cycles = 2, m_cycles = 501;

logic[9:0] cycle_ctr, cycle_max;
logic[6:0] ctr, ctr_max, ctr_half;
logic[1:0] state, next_state;
logic count_complete, ctr_ena, mod_d, mod_q, mod_xor, out_signal, mf_count_cmplt, cc_d;

always_ff @ (posedge clk or negedge rst)
	begin
		if(!rst)
			begin
				state <= st_wait;
				mod_d <= 0;
				mod_q <= 0;
				ctr <= 0;
				cycle_ctr <= 0;
				out_signal <= 1;
				cc_d <= 0;
			end
		else
			begin
				state <= next_state;
				mod_d <= mod;
				mod_q <= mod_d;
				cc_d <= count_complete;
				
				if(ctr_ena)
					begin
						if(ctr < ctr_max) ctr <= ctr + 1;
						else ctr <= 0;
					end
				
				if(mf_count_cmplt) cycle_ctr <= 0;
				else if(count_complete) cycle_ctr <= cycle_ctr + 1;
					
				if((ctr == ctr_max) || (ctr == ctr_half)) 
					out_signal <= ~out_signal;
//				
//				if(cc_d)
//					begin
//						if(cycle_ctr < cycle_max) cycle_ctr <= cycle_ctr + 1;
//						else cycle_ctr <= 0;
//					end
			end
	end

assign mod_xor = mod ^ mod_d;
assign count_complete = (ctr == ctr_max) ? 1'b1 : 1'b0;
assign mf_count_cmplt = (cycle_ctr == cycle_max) ? 1'b1 : 1'b0;
assign signal = out_signal;
assign out_mod = mod_d;

always @ (*)
	begin
		case(state)
			st_wait:
				begin
					if(mod_xor) next_state = st_hf;
					else next_state = st_wait;
				end
			st_hf:
				begin
					if(mf_count_cmplt) next_state = st_mf;
					else next_state = st_hf;
				end
			st_mf:
				begin
					if(mf_count_cmplt) next_state = st_lf;
					else next_state = st_mf;
				end
			st_lf:
				begin
					if(mf_count_cmplt) next_state = st_hf;
					else next_state = st_lf;
				end
			default: next_state = st_wait;
		endcase
	end
	
always @ (state)
	begin
		case(state)
			st_wait:	
				begin
					ctr_ena = 0;
					ctr_max = div_hf;
					ctr_half = half_hf;
					cycle_max = h_cycles;
				end
			st_hf: 
				begin
					ctr_ena = 1;
					ctr_max = div_hf;
					ctr_half = half_hf;
					cycle_max = h_cycles;
				end
			st_mf: 
				begin
					ctr_ena = 1;
					ctr_max = div_mf;
					ctr_half = half_mf;
					//ctr_max = div_hf;
					//ctr_half = half_hf;
					cycle_max = m_cycles;
				end
			st_lf: 
				begin
					ctr_ena = 1;
					ctr_max = div_lf;
					ctr_half = half_lf;
					//ctr_max = div_hf;
					//ctr_half = half_hf;
					cycle_max = l_cycles;
				end
			default:
				begin
					ctr_ena = 0;
					ctr_max = div_hf;
					ctr_half = half_hf;
					cycle_max = h_cycles;
				end
		endcase
	end
	
endmodule
