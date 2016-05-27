`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:04:00 03/03/2016
// Design Name:   mp_counter
// Module Name:   C:/Users/Developer/Documents/ECE3135/mpcounter/tb_mp_counter.v
// Project Name:  mpcounter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mp_counter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_mp_counter;

	// Inputs
	reg CLK;
	reg EN;
	reg RST;
	reg STYLE;

	// Outputs
	wire [6:0] DISP;
	wire [3:0] AN;
	wire [3:0] ONES;
	wire [3:0] TENS;

	// Instantiate the Unit Under Test (UUT)
	mp_counter uut (
		.CLK(CLK), 
		.EN(EN), 
		.RST(RST), 
		.STYLE(STYLE), 
		.DISP(DISP), 
		.AN(AN), 
		.ONES(ONES), 
		.TENS(TENS)
	);

	initial begin
		// Initialize Inputs
		CLK = 0;
		EN = 0;
		RST = 0;
		STYLE = 0;

		// Wait 100 ns for global reset to finish
		#20;
        
		// Add stimulus here
		#1 RST = 1;
		#1 RST = 0;
		
		#1 STYLE = 1;
		#1 EN = 1;
		
		#40 EN = 0;
		#5 RST = 1;
		#1 RST = 0;
		
		#1 STYLE =0;
		#1 EN = 1;
		#40 $finish;

	end
	
	always begin
		#1 CLK=~CLK;
	end
      
endmodule

