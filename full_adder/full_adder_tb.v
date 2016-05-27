`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:11:25 02/04/2016
// Design Name:   full_adder
// Module Name:   C:/Users/Developer/Documents/ECE3135/full_adder/full_adder_tb.v
// Project Name:  full_adder
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: full_adder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module full_adder_tb;

	// Inputs
	reg A;
	reg B;
	reg Cin;

	// Outputs
	wire S;
	wire Cout;

	// Instantiate the Unit Under Test (UUT)
	full_adder uut (
		.A(A), 
		.B(B), 
		.Cin(Cin), 
		.S(S), 
		.Cout(Cout)
	);

	initial begin
		// Initialize Inputs
		A = 0;
		B = 0;
		Cin = 0;

		// Wait 100 ns for global reset to finish
		#2;
        
		// Add stimulus here
		#2; A=0; B=0; Cin=1;
		#2; A=0; B=1; Cin=0;
		#2; A=0; B=1; Cin=1;
		#2; A=1; B=0; Cin=0;
		#2; A=1; B=0; Cin=1;
		#2; A=1; B=1; Cin=0;
		#2; A=1; B=1; Cin=1;
		#2; $finish;

	end
      
endmodule

