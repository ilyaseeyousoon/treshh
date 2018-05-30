module diff(input clk, input rst, input dval, input[36:0] mlt,input clk_10k, output[19:0] out_data, output o_dval);

logic[36:0] in_buf_1, in_buf_2;
logic[37:0] diff, diff_1;
logic[15:0] wr_delay;
logic buf1_rdy, buf2_rdy, out_valid, recv;

logic[7:0] test_ctr;

assign out_data = diff_1[19:0];
assign o_dval = &wr_delay;

always_ff @ (posedge clk or negedge rst)
	begin
		if(!rst) 
			begin
				in_buf_1 <= 0;
				in_buf_2 <= 0;
				buf1_rdy <= 0;
				buf2_rdy <= 0;
				recv <= 0;
				out_valid <= 0;
				diff <= 0;
				diff_1 <= 0;
				wr_delay <= 16'hFFFF;
				
				test_ctr <= 0;
			end
		else 
			begin
				wr_delay <= {wr_delay[14:0], ~out_valid};
				diff_1 <= diff ;//+ 20'h00180;
				
				if(dval & !recv) 
					begin
						in_buf_1 <= mlt;
						buf1_rdy <= 1;
						recv <= 1;
					end
				if(dval & recv) 
					begin
						in_buf_2 <= mlt;
						buf2_rdy <= 1;
						recv <= 0;
					end
				if(buf1_rdy & buf2_rdy)
					begin
						buf1_rdy <= 0;
						buf2_rdy <= 0;
						test_ctr <= test_ctr + 1;
						if(clk_10k==1)// добавил проверку для 20 Кгц. на 10 будет фигня 
						begin
						//diff <= in_buf_1-in_buf_2 + 20'h007F0;
						diff <= in_buf_2+in_buf_1 + 20'h007F0;
						end
						else
						begin
						diff <= in_buf_2+in_buf_1 + 20'h007F0;
						end
						out_valid <= 1;
					end
				else out_valid <= 0;
			end
	end
	
endmodule
