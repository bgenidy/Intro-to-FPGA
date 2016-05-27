`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:13:45 03/10/2016 
// Design Name: 
// Module Name:    encode_decode4to2_2to4 
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
module encode_decode4to2_2to4(ENCout, DECout, FLAG, DECin, ENCin, EN);

	input EN;
	input [1:0] DECin;
	input [3:0] ENCin;
	output [3:0] DECout;
	output [1:0] ENCout;
	output FLAG;
	
	dec2to4 m1(DECout, DECin, EN);
	prienc4to2 m2(ENCout,FLAG,ENCin,EN);

endmodule

module dec2to4 (DECout, DECin, EN);

  input [1:0] DECin;
  input EN;
  output reg [3:0] DECout;

  always @ (DECin or EN)
    if(EN == 1)
		casex(DECin)
			3 : DECout = 4'b1000;
			2 : DECout = 4'b0100;
			1 : DECout = 4'b0010;
			0 : DECout = 4'b0001;
		endcase
	 else
		DECout = 0;
	 
endmodule

module prienc4to2 (ENCout, FLAG, ENCin, EN);

	// Declear of the input-output
	output reg [1:0] ENCout;
	output FLAG;
	input [3:0] ENCin;
	input EN;
	
	assign FLAG = ENCin >= 1 ? 1 : 0;
	
	always @ (ENCin)
	begin
		if(EN == 0)
			casex(ENCin)
				4'b1xxx: ENCout = 3;
				4'b01xx: ENCout = 2;
				4'b001x: ENCout = 1;
				4'b0001: ENCout = 0;
				default: begin
					ENCout=3'bxxx;
				end
			endcase
		else
			ENCout = 0;
	end
endmodule
