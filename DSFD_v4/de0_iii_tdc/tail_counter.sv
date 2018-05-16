module tail_counter  (input clk, input rst, input start, input stop,	
							output[5:0] code, output wrena);
//seems to be working
//in tail gives n-1, need to add 1
logic wr_en;
logic[1:0] ctl;
logic[5:0] ctr, ctr_out;

assign code = ctr_out;
assign wrena = wr_en;
assign ctl = {start, stop};

always_ff @ (posedge clk or negedge rst)
	begin
		if(!rst)
			begin
				wr_en <= 0;
				ctr <= 0;
				ctr_out <= 0;
			end
		else 
			begin				
				case(ctl)
					2'b00:
						begin
							//ctr_ena <= 0;		//start = 0; stop = 0; do nothing
							ctr <= ctr + 1;
							wr_en <= 0;
						end
					2'b01: 
						begin
							//start = 0; stop = 1; stop counter
							ctr_out <= ctr + 1;
							ctr <= 0;
							wr_en <= 1;
						end
					2'b10: 
						begin
							//start = 1; stop = 0; start counter
							ctr <= 0;
							wr_en <= 0;
						end
					2'b11:
						begin
							//start = 1; stop = 1;
							//if start and stop conditions occur simultaneously:
							//for head counter (in start)- no output, integer counter increments;
							//for tail counter (in stop) - no output, integer counter increments;
							ctr <= 0;
							ctr_out <= 0;
							wr_en <= 1;
						end
				endcase
			end
	end	
endmodule
