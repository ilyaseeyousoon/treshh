module UART 
//сountOfStrobe = Fclk(Гц)/Vuart(бит/c) = 200*10^6 / 500000 = 400
                            
                            (
									 input clk_20m,
                            input [15:0] data,              // Данные, которые собираемся передать по TX
                            input data_rdy,                // Строб, который соответствует тому, что данные валидные и их нужно передать
                            output  tx = 1,          // Выходной порт, передает данные по последовательному интерфейсу
                            output  transm_rdy = 1   // Строб, который сигнализирует о том, что данные переданы и блок готов к передаче новых данных
                            );
     

	  
	  
	  reg enb_flag,data_rdy_flag,data_rdy_wait,wait_enb=0;
	  reg [3:0] data_count=4'd0;
	  reg [7:0] data_temp_case=8'd0;
	  wire [7:0] data_temp;
	  assign data_temp=data_temp_case;
	  
	  
	  
	  always @(posedge clk_20m)
begin
     
	  if(data_rdy && data_rdy_flag==0 && data_rdy_wait==0) 
	 begin
	 data_rdy_flag<=1;
	 data_count<=0;
	 end
	 else
	 begin
	 if(data_rdy==0 && data_rdy_flag==1 && data_rdy_wait==0)
	 data_rdy_flag<=0;
	 end
	 
	 
	 
	 
	 case(data_count)
	 
	 4'd0: begin   
	 if (data_rdy_flag==1 && transm_rdy==0 && enb_flag==0)
	 begin
	 enb_flag=1;
	 data_temp_case<=8'd123;
	 data_count<=data_count+1;
	 data_rdy_wait=1;
	 end
    end
	 
	 4'd1: begin   
    if(enb_flag==1)
	 begin
	 wait_enb<=1;
	 end
	 
	 if(wait_enb==1 ) begin
	 enb_flag=0;
	 data_count<=data_count+1;
	 wait_enb<=0;
	 
	 end
	 end
	 
	 

	 4'd2: begin   
	 if (transm_rdy==0 && enb_flag==0)
	 begin
	 enb_flag=1;
	 //data_temp_case <= data[15:8];
	 data_temp_case<=data[15:8];
	 data_count<=data_count+1;
	 end
	 end
	 
	 4'd3: begin   
	    if(enb_flag==1)
	 begin
	 wait_enb<=1;
	 end
	 if(wait_enb==1) begin
	 enb_flag=0;
	 data_count<=data_count+1;
	 wait_enb<=0;
	 end
	 end
	 
	 4'd4: begin   
	 if (transm_rdy==0 && enb_flag==0)
	 begin
	 enb_flag=1;
	 //data_temp_case <= data[15:8];
	 data_temp_case<=data[7:0];
	 data_count<=data_count+1;
	 end
	 end
	 
	 
	 
	 4'd5: begin   
	    if(enb_flag==1)
	 begin
	 wait_enb<=1;
	 end
	 if(wait_enb==1 ) begin
	 enb_flag=0;
	 wait_enb<=0;
	 data_rdy_wait=0;
	 data_count<=0;
	 end
	 end
	 

		endcase
		
		
end



	  
async_transmitter async_transmitter_1(clk_20m,enb_flag, data_temp_case, tx, transm_rdy );
	  
	  
	  
	  
	  
	  
	  
	  
	  
endmodule