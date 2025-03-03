module head_counter  (input clk, input rst, input start, input stop,	
				  output[5:0] code, output wrena);
//works correctly
logic wr_en, out_wr, ctr_ena, ctr_rst, wr_block;
logic[1:0] ctl;
logic[5:0] ctr, ctr_out;

assign code = (wr_block) ? 0 : ctr_out;
assign wrena = wr_en;
assign ctl = {start, stop};

always_ff @ (posedge clk or negedge rst)
	begin
		if(!rst)
			begin
				ctr_ena <= 0;
				ctr_rst <= 0;
				out_wr <= 0;
				wr_en <= 0;
				wr_block <= 0;
				ctr <= 0;
				ctr_out <= 0;
			end
		else 
			begin				
				case(ctl)
					2'b00:
						begin
							//ctr_ena <= 0;		//start = 0; stop = 0; do nothing
							out_wr <= 0;
							ctr_rst <= 0;
							wr_block <= 0;
						end
					2'b01: 
						begin
							ctr_ena <= 0;		//start = 0; stop = 1; stop counter
							if(ctr_ena) out_wr <= 1;
							ctr_rst <= 0;
							wr_block <= 0;
						end
					2'b10: 
						begin
							ctr_rst <= (ctr_ena) ? 1'b1 : 1'b0;
							ctr_ena <= 1;		//start = 1; stop = 0; start counter
							out_wr <= 0;
							wr_block <= 0;
						end
					2'b11:
						begin
							//start = 1; stop = 1;
							//if start and stop conditions occur simultaneously:
							//for head counter (in start)- no output, integer counter increments;
							//for tail counter (in stop) - no output, integer counter increments;
							out_wr <= 1; //maybe 1? 
							ctr_rst <= 0;
							wr_block <= 1;
						end
				endcase
				
				if(ctr_ena) 
					begin
						ctr <= (ctr_rst) ? 0 : ctr + 1;
					end
				else ctr <= 0;
				
				if(out_wr)
					begin
						ctr_out <= ctr;
						wr_en <= 1;
					end
				else wr_en <= 0;
			end
	end	
endmodule
