`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:14:40 04/19/2016 
// Design Name: 
// Module Name:    bcd2sseg 
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
module bcd2sseg(output reg [6:0] sseg, input [3:0] bcd);
	always @(bcd)
	begin
		case(bcd)
		4'b0000: sseg <= 7'b0111111;
		4'b0001: sseg <= 7'b0000110;
		4'b0010: sseg <= 7'b1011011;
		4'b0011: sseg <= 7'b1001111;
		4'b0100: sseg <= 7'b1100110;
		4'b0101: sseg <= 7'b1101101;
		4'b0110: sseg <= 7'b1111101;
		4'b0111: sseg <= 7'b0000111;
		4'b1000: sseg <= 7'b1111111;
		4'b1001: sseg <= 7'b1101111;
		//implement all the way to 15 using hex
		default: sseg <= 7'b1111111;
		endcase
	end
endmodule
