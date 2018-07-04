// Copyright (C) 1991-2013 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.

// PROGRAM		"Quartus II 64-Bit"
// VERSION		"Version 13.1.0 Build 162 10/23/2013 SJ Web Edition"
// CREATED		"Wed Jul 04 17:23:00 2018"

module test_blocl_led(
	Input_led,
	SEG_2DP,
	SEG_3DP,
	SEG_1DP,
	SEG_0DP,
	SEG_0,
	SEG_1,
	SEG_2,
	SEG_3
);


input wire	[7:0] Input_led;
output wire	SEG_2DP;
output wire	SEG_3DP;
output wire	SEG_1DP;
output wire	SEG_0DP;
output wire	[6:0] SEG_0;
output wire	[6:0] SEG_1;
output wire	[6:0] SEG_2;
output wire	[6:0] SEG_3;

wire	[7:0] led_wires;
wire	[6:0] oSEG-D;
wire	[6:0] oSEG-H;
wire	[6:0] oSEG_0;
wire	[6:0] oSEG_1;
wire	[7:0] TxD_display;

assign	SEG_2DP = 1;
assign	SEG_3DP = 1;
assign  TxD_display=Input_led;



SEG7_LUT	b2v_inst1(
	.iDIG(TxD_display[3:0]),
	.oSEG_DP(SEG_0DP),
	.oSEG(oSEG_0));






SEG7_LUT	b2v_inst2(
	.iDIG(TxD_display[7:4]),
	.oSEG_DP(SEG_1DP),
	.oSEG(oSEG_1));




assign	SEG_0 = oSEG_0;
assign	SEG_1 = oSEG_1;
assign	SEG_2 = oSEG-H;
assign	SEG_3 = oSEG-D;
assign	oSEG-D[6] = 0;
assign	oSEG-D[5] = 0;
assign	oSEG-D[4] = 0;
assign	oSEG-D[2] = 1;
assign	oSEG-D[3] = 1;
assign	oSEG-D[1] = 0;
assign	oSEG-D[0] = 0;
assign	oSEG-H[6] = 0;
assign	oSEG-H[5] = 0;
assign	oSEG-H[4] = 0;
assign	oSEG-H[2] = 0;
assign	oSEG-H[1] = 0;
assign	oSEG-H[0] = 1;
assign	oSEG-H[3] = 1;

endmodule
