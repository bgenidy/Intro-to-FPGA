`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:42:20 02/25/2016 
// Design Name: 
// Module Name:    display 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module display(CLK, SW, DISP, AN);
	
	input CLK;
	input [2:0] SW;
	output [6:0] DISP;
	reg [6:0] DISP;
	reg [3:0] CNTR;
	output [3:0] AN;
	reg [3:0] AN;
	reg [24:0] CLKCNTR;
	
	initial CNTR=4'b0001;
	
	always @ (posedge CLK)
	begin
		CLKCNTR=CLKCNTR+1;
		if (CLKCNTR==25000000)
		begin
			CLKCNTR=0;
	
			if(CNTR==4'b0001) CNTR=4'b1000;
			else CNTR=CNTR>>1;
		
			AN=~CNTR;
		
			if(SW==3'b100)
			begin
			
				case(CNTR)
					4'b1000: DISP=7'b0100100;
					4'b0100: DISP=7'b0100100;
					4'b0010: DISP=7'b0100100;
					4'b0001: DISP=7'b0100100;
					default: AN=4'b1111;
				endcase

			end

			else if(SW==3'b010)
			begin
	
				case(CNTR)
					4'b1000: DISP=7'b1111001;
					4'b0100: DISP=7'b1111001;
					4'b0010: DISP=7'b1111001;
					4'b0001: DISP=7'b1111001;
					default: AN=4'b1111;
				endcase

			end
			
			// Add codes here
			
			else if(SW==3'b001)
			begin
	
				case(CNTR)
					4'b1000: DISP=7'b1000000;
					4'b0100: DISP=7'b1000000;
					4'b0010: DISP=7'b1000000;
					4'b0001: DISP=7'b1000000;
					default: AN=4'b1111;
				endcase

			end
			
			else
				AN=4'b1111;
		
		end
	end
	
endmodule
