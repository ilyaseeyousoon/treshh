module integer_counter (input clk, input rst, input start, input stop, input front, 
								output[9:0] cnt_out, output wrena);

//shows 1 half-period more now
logic[9:0] counter;
logic[2:0] ctl;
logic wr_en, ctr_ena;

assign ctl = {start, stop, front};

assign cnt_out = counter;
assign wrena = wr_en;

always_ff @ (posedge clk or negedge rst)
	begin
		if(!rst)
			begin
				counter <= 0;
				wr_en <= 0;
				ctr_ena <= 0;
			end
		else
			begin				
				case(ctl)
					3'b100:	//start = 1, stop = 0, xor = 0: wait for incoming pulse
						begin
							ctr_ena <= 1;
							wr_en <= 0;
						end
					3'b010: 	//start = 0, stop = 1, xor = 0: stop counter, wrena = 1
						begin
							ctr_ena <= 0;
							wr_en <= 1;
						end
					3'b101:	//start and front simultaneously
						begin
							ctr_ena <= 1;
							counter <= counter + 1;
							wr_en <= 0;
						end
					3'b011:	//stop and front simultaneously
						begin
							ctr_ena <= 0;
							counter <= counter + 1;
							wr_en <= 1;
						end
					3'b001:	//only front: increment counter if ena = 1
						begin
							if(ctr_ena) counter <= counter + 1;
							else counter <= 0;
							wr_en <= 0;
						end
					default:
						begin
							wr_en <= 0;
						end
				endcase
			end
	end

endmodule
