module byass_data(input clk, input rst, input [1:0] dval, input[19:0]input_to_byass, output[7:0] out_data_byass);



reg[3:0] count_byass=5;
reg[7:0] output_buf=0;

reg count_plus_flag,count_min_flag=0;

always @ (posedge clk )
begin 
     if(!rst)
        begin 
	   count_byass [3:0] <= 4'd5;

        end

		  else 
		  begin 
		   
				
				if((dval[1]==0 ) && (count_plus_flag==0))
				begin 
				
						if(count_byass<12)
						begin
						count_byass<=count_byass+1;
						end
						count_plus_flag<=1;
						
				end
		  
					else
					begin 
		      
						if(dval[1]==1)
						begin 	
						count_plus_flag<=0;
						end
		  
					end
		  

				if((dval[0]==0 ) && (count_min_flag==0))
				begin 
				
						if(count_byass>0)
						begin
						count_byass<=count_byass-1;
						end
						count_min_flag<=1;
						
				end
		  
			   else
				begin 
		      
						if(dval[0]==1)
						begin 	
						count_min_flag<=0;
						end
		  
			   end		  
		  
		  case (count_byass)
		  
			0 : output_buf[7:0]<=  input_to_byass[7:0];
			1 : output_buf[7:0]<=  input_to_byass[8:1] ;
			2 : output_buf[7:0]<=  input_to_byass[9:2];
			3 : output_buf[7:0]<=  input_to_byass[10:3] ;
			4 : output_buf[7:0]<=  input_to_byass[11:4];
			5 : output_buf[7:0]<=  input_to_byass[12:5] ;
			6 : output_buf[7:0]<=  input_to_byass[13:6];
			7 : output_buf[7:0]<=  input_to_byass[14:7] ;
			8 : output_buf[7:0]<=  input_to_byass[15:8];
			9 : output_buf[7:0]<=  input_to_byass[16:9] ;
			10 : output_buf[7:0]<=  input_to_byass[17:10];
			11 : output_buf[7:0]<=  input_to_byass[18:11] ;	
			12 : output_buf[7:0]<=  input_to_byass[19:12];
			
  default : output_buf[7:0]<=input_to_byass[14:7];
			
			endcase
		  
		  
	     end 
end

assign out_data_byass[7:0] = output_buf[7:0];



endmodule