module phase_controller200 (input clk, input rst, input [1:0] key_ctl, input   [1:0]sw_ctl, output mod);

// clk10k
//localparam clk_right_fine = 10000, clk_left_fine = 9998, clk_right_coarse = 10049, clk_left_coarse = 9949, 
//	  clk_base = 9999, clk_right_2500=12500,clk_left_2500=7500 ,clk_5000=5000;

// clk100k
//localparam clk_right_fine = 1000, clk_left_fine = 998, clk_right_coarse = 1049, clk_left_coarse = 949, 
//	  clk_base = 999, clk_right_2500=1250,clk_left_2500=750 ,clk_5000=500;


// clk20k 	  
localparam clk_right_fine = 625, clk_left_fine = 998, clk_right_coarse = 1049, clk_left_coarse = 949, 
	  clk_base = 624, clk_right_2500=12500,clk_left_2500=1500 ,clk_5000=1000;		
	  
/*
localparam clk_right_fine = 100000, clk_left_fine = 99998, clk_right_coarse = 100049, clk_left_coarse = 99949, 
		  clk_base = 99999;	
	*/	
	
logic[15:0] clk_max;
logic[15:0] clk_div;
logic[1:0] key_ctl_d, key_ctl_q;
logic clk_10k, left_press, right_press, left_hold, right_hold;

assign left_press = !key_ctl_d[0] & key_ctl_q[0];
assign right_press = !key_ctl_d[1] & key_ctl_q[1];

assign mod = clk_10k;

always @ (posedge clk or negedge rst)
	begin
		if(!rst)
			begin
				clk_div <= 0;
				clk_10k <= 0;
				key_ctl_d <= 0;
				key_ctl_q <= 0;
				left_hold <= 0;
				right_hold <= 0;
				clk_max <= clk_base;
			end
		else
			begin
			
				key_ctl_d <= key_ctl;
				key_ctl_q <= key_ctl_d;
				
				if(left_press & !left_hold)
					begin
						left_hold <= 1;
						
						case(sw_ctl[1:0])
						2'd0: begin  clk_max  <=clk_left_fine;   end
						2'd1: begin  clk_max  <=clk_left_coarse; end
						2'd2:  begin  clk_max  <=clk_left_2500;   end
						2'd3:  begin  clk_max  <=clk_5000;   end
						endcase
						
						
						
					//	clk_max <= (sw_ctl) ? clk_left_coarse : clk_left_fine;
					end
				else if (right_press & !right_hold)
					begin
						right_hold <= 1;
						//clk_max <= (sw_ctl) ? clk_right_coarse : clk_right_fine;
						
						case(sw_ctl[1:0])
						2'd0: begin  clk_max  <=clk_right_fine;   end
						2'd1: begin  clk_max  <=clk_right_coarse; end
						2'd2:  begin  clk_max  <=clk_right_2500;   end
						2'd3:  begin  clk_max  <=clk_5000;   end
						endcase
					end
				
				if(key_ctl_q[0]) left_hold <= 0;
				if(key_ctl_q[1]) right_hold <= 0;
				
				if(clk_div == clk_max) 
					begin																													
						clk_div <= 0;
						clk_10k <= ~clk_10k;
						clk_max <= clk_base;
					end
				else clk_div <= clk_div + 1;
			
			end
	end
	
endmodule
