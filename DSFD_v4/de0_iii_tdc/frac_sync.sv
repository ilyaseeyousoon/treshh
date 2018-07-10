parameter CTR_NUM = 1;	//number of counters

module frac_sync (input[CTR_NUM-1:0] clocks, input rst, input[6:0] in_data[CTR_NUM-1:0], input[CTR_NUM-1:0] in_wr, 
					  output[6:0] out_data[CTR_NUM-1:0], output valid);

localparam st_wait = 0, st_ena_off = 1, st_change_clock = 2, st_read_data = 3, st_ena_on = 4, st_ret_clock = 5;

logic ena, data_ready, clear_wr, sync_read, out_valid;
logic[2:0] state, next_state;					  
logic[6:0] data[CTR_NUM-1:0], sync_data[CTR_NUM-1:0];
logic[CTR_NUM-1:0] data_wr;
logic[1:0] lr_wrdata, lr_clear[CTR_NUM-1:0], lr_ena[CTR_NUM-1:0];

genvar i;
integer j;

generate
	for(i = 0; i < CTR_NUM; i++)
		begin : gen
			always_ff @ (posedge clocks[i] or negedge rst)
				begin
					if(!rst)
						begin
							data[i] <= 0;
							data_wr[i] <= 0;
							lr_ena[i] <= 0;
							lr_clear[i] <= 0;
						end
					else
						begin
							lr_ena[i] <= {lr_ena[i][0], ena};
							lr_clear[i] <= {lr_clear[i][0], clear_wr};
							
							if(lr_ena[i][1])
								begin
									if(in_wr[i]) 
										begin
											data[i] <= in_data[i];
											data_wr[i] <= 1;
										end
									//else if(lr_clear[i][1]) data_wr[i] <= 0;
								end
							if(lr_clear[i][1]) data_wr[i] <= 0;
						end
				end
		end
endgenerate

assign out_data = sync_data;
assign valid = out_valid;
assign data_ready = lr_wrdata[1];

always_ff @ (posedge clocks[0] or negedge rst)
	begin
		if(!rst)
			begin
				lr_wrdata <= 0;
				state <= st_wait;
				for(j = 0; j < CTR_NUM; j++)
					sync_data[j] <= 0;
			end
		else
			begin
				state <= next_state;
				lr_wrdata <= {lr_wrdata[0], /*data_wr[0]&data_wr[2]&data_wr[3]};*/&data_wr};

				if(sync_read)
					begin
						out_valid <= 1;
						for(j = 0; j < CTR_NUM; j++)
							sync_data[j] <= data[j];
					end
				else out_valid <= 0;
			end
	end
	
always @ (*)
	begin
		case(state)
			st_wait:
				if(data_ready) next_state = st_ena_off;
				else next_state = st_wait;
			st_ena_off: next_state = st_change_clock;
			st_change_clock: next_state = st_read_data;
			st_read_data: next_state = st_ret_clock;
			st_ret_clock: next_state = st_ena_on;
			st_ena_on: 
				if(!lr_wrdata[1]) next_state = st_wait;
				else next_state = st_ena_on;
			default: next_state = st_wait;
		endcase
	end
	
always @ (state)
	begin
		case(state)
			st_wait:
				begin
					ena = 1;	
					sync_read = 0;
					clear_wr = 0;
				end
			st_ena_off:
				begin
					ena = 0;
					sync_read = 0;
					clear_wr = 0;
				end
			st_change_clock:
				begin
					ena = 0;
					sync_read = 0;
					clear_wr = 0;
				end
			st_read_data:
				begin
					ena = 0;
					sync_read = 1;
					clear_wr = 0;
				end
			st_ret_clock:
				begin
					ena = 0;
					sync_read = 0;
					clear_wr = 1;
				end
			st_ena_on:
				begin
					ena = 0;					
					sync_read = 0;
					clear_wr = 0;
				end
			default:
				begin
					ena = 1;
					sync_read = 0;
					clear_wr = 0;
				end
		endcase
	end
	
endmodule
