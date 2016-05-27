`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:14:25 04/19/2016 
// Design Name: 
// Module Name:    alarm_clock 
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
module alarm_clock(
	output [6:0] sseg, //7seg display
	output [3:0] dgt, //AN
	output reg pm, //LED0
	output reg [1:0] alarmlight, //LED 1-2
	input [3:0] bcd, //sw0-3
	input [3:0] load,//btn
	input sel24,//SW4
	input [1:0] enalarm,//sw5-6 enable alarm
	input clock);//B8
	
	wire [6:0] sseg1;
	wire [3:0] disp;
	reg [17:0] prescaler;
	reg [1:0] state;
	reg [3:0] time24[3:0];
	reg [3:0] time12[3:0]; //keeps track of 12 hour time
	reg [3:0] alarm1 [3:0];
	reg [3:0] alarm112[3:0]; //keeps track of 12 hour time
	reg [3:0] alarm2 [3:0];
	reg [3:0] alarm212[3:0]; //keeps track of 12 hour time
	reg [7:0] scan;
	reg [7:0] tick;
	reg [5:0] sec;
	reg [5:0] min;
	
	bcd2sseg M1(sseg1,disp);
	dgt_decode M2 (dgt,state);
	mux3 M3(disp, time24[state], time12[state], alarm1[state], alarm112[state], alarm2[state], alarm212[state], bcd[3:2], sel24);
	//scanning frequency = 500 Hz
	//prescaler = 100000
	
	always @(posedge clock)
	begin
		prescaler = prescaler +1;
		if(prescaler>100000) update_scan;
		
		//enables the alarm light when alarm time strikes
		if(enalarm[0] && {time24[3], time24[2], time24[1], time24[0]}=={alarm1[3], alarm1[2], alarm1[1], alarm1[0]}) alarmlight[0] = 1;
		else alarmlight[0] = 0;
		
		if(enalarm[1] && {time24[3], time24[2], time24[1], time24[0]}=={alarm2[3], alarm2[2], alarm2[1], alarm2[0]}) alarmlight[1] = 1;
		else alarmlight[1] = 0;
	end
	
	always@(posedge clock)
	begin
		//sychronize 12hr mode with 24hr mode
		time12[0]<=time24[0];
		time12[1]<=time24[1];
		{time12[3],time12[2]} <= syncalarm(time24[3], time24[2]);
		alarm112[0]<=alarm1[0];
		alarm112[1]<=alarm1[1];
		{alarm112[3],alarm112[2]} <= syncalarm(alarm1[3], alarm1[2]);
		alarm212[0]<=alarm2[0];
		alarm212[1]<=alarm2[1];
		{alarm212[3],alarm212[2]} <= syncalarm(alarm2[3], alarm2[2]);
	end
	
	always @(bcd[3],bcd[2])
	begin
		//makes sure that pm is enabled when time rolls out
		case(bcd[3:2])
		0: pm = (time24[3]>=1 && time24[2]>=2) || (time24[3]==2) ? 1:0;
		1: pm = (alarm1[3]>=1 && alarm1[2]>=2) || (alarm1[3]==2) ? 1:0;
		2: pm = (alarm2[3]>=1 && alarm2[2]>=2) || (alarm2[3]==2) ? 1:0;
		default: pm = (time24[3]>=1 && time24[2]>=2) || (time24[3]==2) ? 1:0;
		endcase
	end
	
	assign sseg = ~sseg1;
				
	task update_scan;
	begin
		prescaler = 0;
		state = state + 1;
		scan = scan + 1;
		if(scan > 100)
		begin
			scan = 0;
			tick = tick + 1;
			adj_process;
			
			if(bcd[1:0] == 2) update_clock;
		end
		
		if(tick > 5)
		begin
			tick = 0;
			sec = sec+1;
			if(bcd[1:0] == 1) update_clock;
			if(sec > 60) 
			begin
				sec=0;
				min = min + 1;
				if(bcd[1:0] == 0 || bcd[1:0]==3) update_clock;
				if(min>60) min = 0;
			end
		end
	end
	endtask
	
	task update_clock;
		begin
			time24[0] = time24[0] + 1;
			if(time24[0]>9)
			begin
				time24[0] = 0;
				time24[1] = time24[1]+1;
				if(time24[1]>5)
				begin
					time24[1] = 0;
					time24[2] = time24[2] +1;
					
					if((time24[2]>9) && (time24[3]<2))
					begin
						time24[2] = 0;
						time24[3] = time24[3] + 1;
					end
					else if((time24[2]>3) && (time24[3]>1))
					begin
						time24[2] = 0;
						time24[3] = 0;
					end
				end
			end
		end
	endtask

	task inc_min1(inout reg[3:0] min1, inout reg[3:0] min10, inout reg[3:0] hour1,inout reg[3:0] hour10);
		begin
			min1 = min1 + 1;
			if(min1>9) min1 = 0;
		end
	endtask
	
	task inc_min10(inout reg[3:0] min1, inout reg[3:0] min10, inout reg[3:0] hour1,inout reg[3:0] hour10);
		begin
			min10 = min10 + 1;
			if(min10>5) min10 = 0;
		end
	endtask
	
	task inc_hour1(inout reg[3:0] min1, inout reg[3:0] min10, inout reg[3:0] hour1,inout reg[3:0] hour10);
		begin
			hour1 = hour1+1;
			
			if(hour1>9 || (hour10==2 && hour1>3)) hour1 = 0;
		end
	endtask
	
	task inc_hour10(inout reg[3:0] min1, inout reg[3:0] min10, inout reg[3:0] hour1,inout reg[3:0] hour10);
		begin
			hour10 = hour10 + 1;
			if(hour10==2 && hour1>3) hour1 = 3; //to prevent users from setting the clock to an improper state
			
			if(hour10>2) hour10 = 0;
		end
	endtask
	
	task adj_process;
		if(bcd[3:2] == 0)
		begin
			if(load[3]) inc_hour10(time24[0], time24[1], time24[2], time24[3]);
			if(load[2]) inc_hour1(time24[0], time24[1], time24[2], time24[3]);
			if(load[1]) inc_min10(time24[0], time24[1], time24[2], time24[3]);
			if(load[0]) inc_min1(time24[0], time24[1], time24[2], time24[3]);
		end
		else if(bcd[3:2] == 1)
		begin
			if(load[3]) inc_hour10(alarm1[0], alarm1[1], alarm1[2], alarm1[3]);
			if(load[2]) inc_hour1(alarm1[0], alarm1[1], alarm1[2], alarm1[3]);
			if(load[1]) inc_min10(alarm1[0], alarm1[1], alarm1[2], alarm1[3]);
			if(load[0]) inc_min1(alarm1[0], alarm1[1], alarm1[2], alarm1[3]);
		end
		else if(bcd[3:2] == 2)
		begin
			if(load[3]) inc_hour10(alarm2[0], alarm2[1], alarm2[2], alarm2[3]);
			if(load[2]) inc_hour1(alarm2[0], alarm2[1], alarm2[2], alarm2[3]);
			if(load[1]) inc_min10(alarm2[0], alarm2[1], alarm2[2], alarm2[3]);
			if(load[0]) inc_min1(alarm2[0], alarm2[1], alarm2[2], alarm2[3]);
		end
		else //added so that any other one will default to regular time
		begin
			if(load[3]) inc_hour10(time24[0], time24[1], time24[2], time24[3]);
			if(load[2]) inc_hour1(time24[0], time24[1], time24[2], time24[3]);
			if(load[1]) inc_min10(time24[0], time24[1], time24[2], time24[3]);
			if(load[0]) inc_min1(time24[0], time24[1], time24[2], time24[3]);
		end
	endtask
	
	//the following function takes in the 10 hour and 1 hour
	function [7:0] syncalarm(input [3:0] hr10, input [3:0] hr1);
	begin
		case({hr10,hr1})
		8'h00: syncalarm = 8'h12;
		8'h01: syncalarm = 8'h01;
		8'h02: syncalarm = 8'h02;
		8'h03: syncalarm = 8'h03;
		8'h04: syncalarm = 8'h04;
		8'h05: syncalarm = 8'h05;
		8'h06: syncalarm = 8'h06;
		8'h07: syncalarm = 8'h07;
		8'h08: syncalarm = 8'h08;
		8'h09: syncalarm = 8'h09;
		8'h10: syncalarm = 8'h10;
		8'h11: syncalarm = 8'h11;
		8'h12: syncalarm = 8'h12;
		8'h13: syncalarm = 8'h01;
		8'h14: syncalarm = 8'h02;
		8'h15: syncalarm = 8'h03;
		8'h16: syncalarm = 8'h04;
		8'h17: syncalarm = 8'h05;
		8'h18: syncalarm = 8'h06;
		8'h19: syncalarm = 8'h07;
		8'h20: syncalarm = 8'h08;
		8'h21: syncalarm = 8'h09;
		8'h22: syncalarm = 8'h10;
		8'h23: syncalarm = 8'h11;
		8'h24: syncalarm = 8'h12;
		default: syncalarm = {hr10,hr1};
		endcase
	end
	endfunction
endmodule
