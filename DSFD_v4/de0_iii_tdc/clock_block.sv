module clock_block(input clk, rst, input del, output[5:0] clocks, output[5:0] inv_clocks);

logic[5:0] clks, del_clks, inv_clks;
logic pll_locked;
logic pll_locked2;

tdc_pll pll_inst (.areset(~rst), .inclk0(clk), .c0(clks[0]), .c1(clks[1]), 
						.c2(clks[2]), .c3(clks[3]),.c4(clks[4]), .locked(pll_locked));
						
pll_spi pll_inst2 (.areset(~rst), .inclk0(clk), .c0(clks[5]), .locked(pll_locked2));
					
					
assign inv_clks = ~clks;
assign del_clks = clks;
assign clocks = del_clks;
assign inv_clocks = inv_clks;
endmodule