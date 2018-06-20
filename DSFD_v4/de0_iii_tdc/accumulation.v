module accumulation (input clk,input valid_data,input rst, input [15:0] input_signal, output [19:0] result);


reg [19:0] main_summ,main_summ_buf = 20'd0;
reg [9:0] main_counter = 10'd0;




	always @(posedge clk) begin

		if (!rst) begin
		main_counter<=0;
		main_summ<=0;
		end
		else begin
		
			if((main_counter < 9)&&(valid_data==1)) begin
			
			main_counter<=main_counter+1;
			main_summ<=main_summ+input_signal;
			main_summ_buf<=0;
			end
			else begin
			if((main_counter >= 9)) begin
			main_summ_buf<=main_summ;
			main_counter<=0;
			main_summ<=0;
			end
			
			end
		

		
		
		end




	end

    
assign   result = main_summ_buf ;








endmodule