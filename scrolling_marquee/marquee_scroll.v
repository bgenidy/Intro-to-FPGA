`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:57:53 03/31/2016 
// Design Name: 
// Module Name:    marquee_scroll 
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
module marquee_scroll (CLK,EN,RST,STYLE,Speed,DISP,AN,LEDs);
		input CLK;
		input Speed;
		input EN;
		input RST;
		input STYLE;
		output AN;
		wire[3:0] AN;
		reg [25:0] CLKCNTR;
		reg [25:0] SPEED_COUNTER;
		output [6:0] DISP;
		output LEDs;
		reg [7:0] LEDs;

		reg[55:0] Words;
		wire [27:0] selected_words;		
		assign selected_words = Words[55:28];

	  //every one or half second (speed ) scroll the marquee
		always@(posedge CLK)
		begin
			 if(!RST)
			 begin
				 Words = {		 
					// set your words here
					//GFEDCBA
					7'b1110111,//Each of the following lines specifies a single character
					7'b0100000,
					7'b1111111,
					7'b0000100,
					7'b1111101,
					7'b1000000,
					7'b0111111,
					7'b0010000
					};
					
				  CLKCNTR = 0;
				  LEDs = 7'b0000111;// set the amount of LEDs that you want to have on during the rotation
			 end
			 
			 else
			 begin
			 
			 CLKCNTR =  CLKCNTR + 1;

			 if(CLKCNTR == SPEED_COUNTER)
			 begin
				CLKCNTR = 0;
			   if(EN)
			     begin
				  if(STYLE == 1'b0)
				    begin
					  Words = {Words[6:0],Words[55:7]};// simple vector allowing a circular rotatioin by placing the last character at the begining of the word	
					  LEDs  = {LEDs[0],LEDs[6:1]};// doing a similar rotation as above but with LEDs rather than characters
				    end
				
				  else if(STYLE == 1'b1)
				  begin
				     Words = {Words[49:0],Words[55:49]};// vector allowing rotation by placing the first character at the end of the word	
					  LEDs  = {LEDs[5:0],LEDs[6]};// doing a similar rotation as above
				  end
				end
          end
		  end
		end
		
		always@(Speed)
		begin
			if(Speed == 1'b0)
				SPEED_COUNTER = 50000000;//choose a right number here that scroll speed = 1HZ since basys II clk is 50MHz then 50M allows for 1 Hz clk
			else
				SPEED_COUNTER = 25000000;//choose a right number here that scroll speed = 0.5HZ since basys II clk is 50MHz then 25M allows for 0.5 Hz clk
		end
		
	scrolling_display scroll(RST, DISP,CLK, selected_words,AN);
	endmodule

///////////////////////////////////////////////////////////////////
module scrolling_display (RST,DISP,CLK,selected_words,AN);

	input CLK;
	input RST;
	input [27:0] selected_words;
	output [6:0] DISP;
	output[3:0] AN;
	reg [6:0] DISP;
	reg[3:0] AN;
	reg[3:0] CNTR;
	reg [17:0] DISPCNTR;
	
	wire [6:0] display_separated [3:0];

	assign {display_separated[3],display_separated[2],display_separated[1],display_separated[0]} = selected_words;
	
	always @ (posedge CLK)
	begin
		if(!RST)
		begin
			CNTR = 4'b0001;
			DISP= 7'b1111111;
		end
		  
		else 
		begin
			DISPCNTR=DISPCNTR+1;
			if (DISPCNTR==250000)
			begin
			  DISPCNTR=0;
			  if(CNTR==4'b0001) CNTR=4'b1000;
			  else CNTR=CNTR>>1;
			  
			  AN=~CNTR;
			  
			  case (CNTR)
			  //2 dimensional array storing the values for the 4 7-seg displays
				4'b1000: DISP=display_separated [3];
				4'b0100: DISP=display_separated [2];
				4'b0010: DISP=display_separated [1];
				4'b0001: DISP=display_separated [0];			
				default: DISP=7'b1111111;
			  endcase
			end
		end
	end
endmodule

