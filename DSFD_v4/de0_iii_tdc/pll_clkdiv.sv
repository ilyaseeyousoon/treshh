module pll_clkdiv (input[7:0] in_clk, input rst, output[7:0] out_clk);

localparam CLK_DIV = 80;

logic[31:0] counters[7:0];
logic[7:0] clkout;

genvar i;

assign out_clk = clkout;

generate
for(i = 0; i < 8; i++)
	begin : gen
		always_ff @ (posedge in_clk[i] or negedge rst)
			begin
				if(!rst)
					begin
						counters[i] <= 0;
						clkout[i] <= 0;
					end
				else
					begin
						if(counters[i] < CLK_DIV) counters[i] <= counters[i] + 1;
						else
							begin
								counters[i] <= 0;
								clkout[i] <= ~clkout[i];
							end
					end
			end
	end
endgenerate
endmodule

		