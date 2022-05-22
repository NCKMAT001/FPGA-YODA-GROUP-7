`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UCT HPES
// Engineer: NCKMAT001,CHTDIV004,NJRKIN001
// 
// Create Date: 21.05.2022 23:35:38
// Design Name: 
// Module Name: TB
// Project Name: YODA
// Target Devices: NEXYS DDR4 
// Tool Versions: 
// Description: IMPLEMENT ALL MODULES
// 
// Dependencies: 
// 
// Revision: FINAL
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module TB;
    reg clk;
    wire [31:0] sineoutput_1, sineoutput_2, sineoutput_3, min_S1, max_S1, min_S21, max_S21, min_S22, max_S22;
    wire on, complete;
    wire [31:0] stdev_min_S1, stdev_min_S21, stdev_min_S22, stdev_max_S1, stdev_max_S21, stdev_max_S22;
    reg [2:0] interval = 1; //interval for section 2
    
    //initates and connects the sound generator to the testBench
    soundgen baseSoundGen(
        .clk(clk),
        .interval(interval),
        .on(on),
        .complete(complete),
        .sineoutput_1(sineoutput_1),
        .sineoutput_2(sineoutput_2),
        .sineoutput_3(sineoutput_3)
    );
    
    //initates and connects the maxmin filter to the testBench
	//Section 1: Min Max Amplitude
    maxmin maxmin_S1(
        .clk(clk),
        .on(on),
        .sound(sineoutput_1),
        .min(min_S1),
        .max(max_S1)
    );
	
	// Section 2: Interval Based Min Max Amplitude
	//This filtering process has to implemented for the max points and min points separately,
	//resulting to two sets of outputs.
	//SET 1
	    maxmin maxmin_S21(
        .clk(clk),
        .on(on),
        .sound(sineoutput_2),
        .min(min_S21),
        .max(max_S21)
    );
	//SET 2
	    maxmin maxmin_S22(
        .clk(clk),
        .on(on),
        .sound(sineoutput_3),
        .min(min_S22),
        .max(max_S22)
    );
   
   //initates and connects the std dev to the testBench 
    stdev stdev1(
        .clk(clk),
        .complete(complete),
        .interval(interval),
        .min_S1(min_S1),
        .max_S1(max_S1),
        .min_S21(min_S21),
        .max_S21(max_S21),
        .min_S22(min_S22),
        .max_S22(max_S22),
        .stdev_min_S1(stdev_min_S1),
        .stdev_max_S1(stdev_max_S1),
        .stdev_min_S21(stdev_min_S21),
        .stdev_max_S21(stdev_max_S21),
        .stdev_min_S22(stdev_min_S22),
        .stdev_max_S22(stdev_max_S22)
    );
    
    //frequency control
    parameter freq = 100000000; //100 MHz
    parameter SIZE = 535000; 
    parameter clockRate = 0.001; //clock time (make this an output from the sine modules)
    
    //Generate a clock with the above frequency control
    initial
    begin 
    clk = 1'b0;
    end
    always #clockRate clk = ~clk; //#1 is one nano second delay (#x controlls the speed)
    
endmodule
