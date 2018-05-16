module tdc (input[7:0] pll_clk, input rst, input signal, input mod, output[19:0] out_time, output dval, output test);

parameter CTR_NUM = 8;

logic[9:0] int_mlt_data[7:0];
logic[6:0] frac_mlt_data[7:0];
logic[6:0] frac_num[CTR_NUM-1:0], frac_sync_data[CTR_NUM-1:0], frac_sync_out[CTR_NUM-1:0];
logic[9:0] int_num[CTR_NUM-1:0], int_sync_data[CTR_NUM-1:0], int_sync_out[CTR_NUM-1:0];
logic[1:0] lr_signal[CTR_NUM-1:0], lr_mod[CTR_NUM-1:0];
logic[CTR_NUM-1:0] f_ctr_wrena, i_ctr_wrena;
logic pll_locked, i_sync_wr, f_sync_wr, s_out_int, s_out_fr, mlt_dval, mlt_wr;


genvar i;
generate
	for(i = 0; i < CTR_NUM; i++)
		begin : gen
			time_counter  tc_inst (pll_clk[i], rst, lr_signal[i][1], lr_mod[i][1], 
										  frac_num[i], int_num[i], f_ctr_wrena[i]);
			
			assign int_mlt_data[i] = int_sync_out[i];
			assign frac_mlt_data[i] = frac_sync_out[i];
			
			always_ff @ (posedge pll_clk[i] or negedge rst)
				begin
					if(!rst)
						begin
							lr_signal[i] <= 0;
							lr_mod[i] <= 0;
						end
					else
						begin
							lr_signal[i] <= {lr_signal[i][0], signal};
							lr_mod[i] <= {lr_mod[i][0], mod};
						end
				end
		end
endgenerate

assign test = signal;

frac_sync fr_sync  (pll_clk, rst, frac_num, f_ctr_wrena, frac_sync_data, f_sync_wr);
int_sync	 i_sync   (pll_clk, rst, int_num, f_ctr_wrena, int_sync_data, i_sync_wr);
mlt_x400  mlt_inst (pll_clk[0], rst, int_mlt_data, frac_mlt_data, mlt_wr, out_time, dval);

integer j;

always_ff @ (posedge pll_clk[0] or negedge rst)
	begin
		if(!rst)
			begin
				for(j = 0; j < CTR_NUM; j++)
					begin
						int_sync_out[j] <= 0;
						frac_sync_out[j] <= 0;
						s_out_int <= 0;
						s_out_fr <= 0;
					end
			end
		else
			begin
				if(i_sync_wr) 
					begin
						s_out_int <= 1;
						for(j = 0; j < CTR_NUM; j++)
							int_sync_out[j] <= int_sync_data[j];
					end
						
				if(f_sync_wr)
					begin
						s_out_fr <= 1;
						for(j = 0; j < CTR_NUM; j++)
							frac_sync_out[j] <= frac_sync_data[j];
					end
					
				if(s_out_fr & s_out_int)
					begin
						mlt_wr <= 1;
						s_out_fr <= 0;
						s_out_int <= 0;
					end
				else mlt_wr <= 0;
				
			end
	end

endmodule
