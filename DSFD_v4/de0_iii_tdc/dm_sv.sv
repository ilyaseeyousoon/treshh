module dm_sv (input clk, input rst, input[15:0] C, input[15:0] B, input[15:0] N, input[15:0] P,
				  output signal);
				  
logic[15:0] seq_ctr, dm_load, dm_ctr;
logic mux_sel, term_count, div;

always_ff @ (posedge clk or negedge rst)
	begin
		if(!rst) seq_ctr <= 0;
		else
			begin
				if(term_count)
					begin
						if(seq_ctr == 0) seq_ctr <= C - 1;
						else seq_ctr <= seq_ctr - 1;
					end
			end
	end

always_ff @ (posedge clk or negedge rst)
	begin
		if(!rst) dm_ctr <= 0;
		else
			begin
				if(term_count) dm_ctr <= dm_load;
				else dm_ctr <= dm_ctr - 1;
			end
	end
	
always_ff @ (posedge clk or negedge rst)
	begin
		if(!rst) div <= 0;
		else
			begin
				if(term_count) div <= ~div;
			end
	end
	
assign mux_sel = (seq_ctr < B) ? 1'b1 : 1'b0;
assign dm_load = (mux_sel) ? P - 1 : N - 1;
assign term_count = (dm_ctr == 0) ? 1'b1 : 1'b0;
assign signal = div;

endmodule

	
	