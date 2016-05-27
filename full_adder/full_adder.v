`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:09:10 01/21/2016 
// Design Name: 
// Module Name:    full_adder 
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
module full_adder(A, B, Cin, S, Cout);
	 input A,B,Cin;
	 output S, Cout;
	 
	 assign S = A^B^Cin;
	 assign Cout = (A&B)|(Cin&(A|B));
	 /*Alternate Code
	 wire t, t1, t2; //temp
	 
	xor(S,A,B,Cin);
	or(Cout, and(t, A,B), and(t1, Cin, or(t2,A,B)));
	*/
endmodule
