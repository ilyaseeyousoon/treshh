module spi_data_transm

(	
	// General signals
	clk, spi_clk_i,clk_20k, spi_mosi, spi_clk, spi_ss,diffout

);

input clk; // Main Clock 250 MHz 

	// SPI Interface
	input spi_clk_i; // 5 MHz for SPI from PLL 	
	input clk_20k;
	output spi_mosi;
	output spi_clk;
	output spi_ss;
	input [15:0] diffout;
	
// SPI service regs	
	reg [4:0] spi_state = 0;
	reg spi_write = 0; 
	reg spi_write_prev = 0;
	reg spi_mosi = 0;
	reg spi_ss = 1;
	reg clkout_prev = 0; 
	reg clkout = 0;
	assign spi_clk = spi_clk_i;
	wire clkout_xor = clkout_prev ^ clkout;
	
	// metastability suppression for 250 MHz
	
	always@(posedge clk) clkout_prev = clkout;
	
	// MOD Signal generating
	
	always@(posedge clk) 
	 if (clk_20k) clkout <= ~clkout;
	
	// main process + SPI transfer initiating
	always@(posedge clk) 
   if (clkout_xor) 
		begin
			if (!clkout) 	
				begin 
				spi_write = 0; // NEG_EDGE to prepare next SPI transfer
				end
			else 
				begin 
				spi_write = 1; // POS_EDGE to start SPI transfer
				end
		end
	
	// spi_write POS_EDGE highlighting	
	always@(negedge spi_clk_i) spi_write_prev = spi_write;
	
	wire spi_write_posedge = !spi_write_prev & spi_write;
	wire spi_write_negedge = spi_write_prev & !spi_write;
	// SPI Transfer Procedure	
	always@(negedge spi_clk_i) 
	case(spi_state)
	0: 	begin if (spi_write_posedge) spi_state = 1; end
	1:		begin spi_mosi = diffout[15]; spi_state = 2; spi_ss = 0; end
	2:		begin spi_mosi = diffout[14]; spi_state = 3; 	end
	3:		begin spi_mosi = diffout[13]; spi_state = 4; 	end
	4:		begin spi_mosi = diffout[12]; spi_state = 5; 	end
	5:		begin spi_mosi = diffout[11]; spi_state = 6; 	end
	6:		begin spi_mosi = diffout[10]; spi_state = 7; 	end
	7:		begin spi_mosi = diffout[9];  spi_state = 8; 	end
	8:		begin spi_mosi = diffout[8];  spi_state = 9; 	end
	9:		begin spi_mosi = diffout[7];  spi_state = 10; 	end
	10:	begin spi_mosi = diffout[6];  spi_state = 11; 	end
	11:	begin spi_mosi = diffout[5];  spi_state = 12; 	end
	12:	begin spi_mosi = diffout[4];  spi_state = 13; 	end
	13:	begin spi_mosi = diffout[3];  spi_state = 14; 	end
	14:	begin spi_mosi = diffout[2];  spi_state = 15; 	end
	15:	begin spi_mosi = diffout[1];  spi_state = 16; 	end
	16:	begin spi_mosi = diffout[0];  spi_state = 17; 	end
	17:	begin spi_mosi = 0; 				spi_state = 0; spi_ss = 1; end
	endcase






















endmodule