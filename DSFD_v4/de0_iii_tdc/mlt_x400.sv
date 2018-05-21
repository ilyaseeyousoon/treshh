//module mlt_x400 (input clk, input rst, input[9:0] int_data[7:0], input[6:0] frac_data[7:0], input start, 
//					  output[19:0] out_16, output out_dval);
module mlt_x400 (input clk, input rst, input[9:0] int_data[15:0], input[6:0] frac_data[15:0], input start, 
					  output[36:0] out_16, output out_dval);


//logic[6:0] frac_delay[7:0];
//logic[15:0] mult_out[7:0];
//logic[16:0] sum_st_1[7:0];
logic[6:0] frac_delay[15:0];
logic[15:0] mult_out[15:0];
logic[32:0] sum_st_1[15:0];

//logic[17:0] sum_st_2[3:0];
//logic[18:0] sum_st_3[1:0];
//logic[19:0] sum_st_4;3
logic[33:0] sum_st_2[7:0];
logic[34:0] sum_st_3[3:0];
logic[35:0] sum_st_4[1:0];
logic[36:0] sum_st_5;

logic[5:0] lr_ena;
					  
genvar g;
generate
	for(g = 0; g < 16; g++) begin : gen_mult
		mult_x50 mlt_inst (~rst, start, clk, int_data[g], mult_out[g]);
	end
endgenerate

assign out_dval = lr_ena[5];
assign out_16 = sum_st_5;

integer i;

always_ff @ (posedge clk or negedge rst)
	begin
		if(!rst)
			begin
				lr_ena <= 0;
			end
		else
			begin
				lr_ena <= {lr_ena[4:0], start};
				for(i = 0; i < 1; i++)//изменение числа каналов
					begin
				//if((i !=1)&& (i != 2) && (i!=3))
				//	begin
						frac_delay[i] <= (start) ? frac_data[i] : 0;
						sum_st_1[i] <= (lr_ena[0]) ? (mult_out[i] + frac_delay[i]) : 0;
					//end
					end
					for(i = 0; i < 8; i++)
					sum_st_2[i] <= (lr_ena[1]) ? (sum_st_1[i*2] + sum_st_1[i*2+1]) : 0;
					
				for(i = 0; i < 4; i++)
					sum_st_3[i] <= (lr_ena[2]) ? (sum_st_2[i*2] + sum_st_2[i*2+1]) : 0;
					
				for(i = 0; i < 2; i++)
					sum_st_4[i] <= (lr_ena[3]) ? (sum_st_3[i*2] + sum_st_3[i*2+1]) : 0;
					
				//sum_st_4 <= (lr_ena[3]) ? (sum_st_3[0] + sum_st_3[1]) : 0;
				sum_st_5 <= (sum_st_4[0] + sum_st_4[1]);
				
			end
	end
	
endmodule
	
