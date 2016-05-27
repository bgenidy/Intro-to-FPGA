`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:23:30 03/03/2016 
// Design Name: 
// Module Name:    reset 
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
module reset(DISP, CLK, TENS, ONES, AN);

	input CLK;
	input TENS, ONES;
	output [6:0] DISP;
	output [3:0] AN;
	reg [17:0] DISPCNTR;
	
	wire[3:0] TENS, ONES;
	
	always @ (posedge CLK)
	begin
		DISPCNTR<=DISPCNTR+1;

		if (DISPCNTR==250000)
		begin

			DISPCNTR<=0;
			AN[1]<=~AN[1];
			AN[0]<=~AN[0];
			AN[2]<=1;
			AN[3]<=1;			

			if (AN[1])
			begin
				

				case (TENS)
					0: DISP=7'b1000000;
					1: DISP=7'b1111001;
					2: DISP=7'b0100100;
					3: DISP=7'b0110000;
					4: DISP=7'b0011001;
					5: DISP=7'b0010010;
					6: DISP=7'b0000010;
					7: DISP=7'b1111000;
					8: DISP=7'b0000000;
					9: DISP=7'b0010000;
					default: DISP=7'b1111111;
				endcase
			end

			else if (AN[0])
			begin
				//Add codes here
				
				case (ONES)
					0: DISP=7'b1000000;
					1: DISP=7'b1111001;
					2: DISP=7'b0100100;
					3: DISP=7'b0110000;
					4: DISP=7'b0011001;
					5: DISP=7'b0010010;
					6: DISP=7'b0000010;
					7: DISP=7'b1111000;
					8: DISP=7'b0000000;
					9: DISP=7'b0010000;
					default: DISP=7'b1111111;
				endcase
				
			end
		end
	end
endmodule