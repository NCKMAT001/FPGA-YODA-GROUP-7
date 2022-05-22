`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UCT HPES
// Engineer: NCKMAT001,CHTDIV004,NJRKIN001
// 
// Create Date: 21.05.2022 23:35:38
// Design Name: 
// Module Name: soundgen
// Project Name: YODA
// Target Devices: NEXYS DDR4 
// Tool Versions: 
// Description: Generate sine waves from mem file (LUT)
// 
// Dependencies: 
// 
// Revision: FINAL
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module soundgen(
    input clk ,
    input wire [1:0] interval,
    output reg on,
    output reg complete,
    output reg [31:0] sineoutput_1, sineoutput_2, sineoutput_3
    );
	
    parameter SIZE = 535000;  // Number of values in mem file
    reg [31:0] rom_memory [SIZE-1:0]; // create 32 bit register to store values indexed by SIZE
	
    integer i,j,k,l;//Declare variables to move through file
	
initial begin
    $readmemh("sound.mem", rom_memory); //Use this command instead of BRAM i.e. prac 3.2 issue
    
	i = 0; //set ints to 0
    j = 0;
    l = 0;
    k = 0;
    
    if (interval == 2) begin
        k = (SIZE/2); 
    end 
    else if (interval == 3) begin       
        l = (SIZE/3)*2;
        k = (SIZE/3);
    end
    
    on = 1'b0;
    complete = 1'b0;
end
    
//At every positive edge of the clock, output a sine wave sample.
always@(posedge clk) begin
    if (interval == 1) begin
        sineoutput_1 = rom_memory[i];
    end else if (interval == 2) begin
        sineoutput_1 = rom_memory[i];
        sineoutput_2 = rom_memory[k];
    end else if (interval == 3) begin
        sineoutput_1 = rom_memory[i];
        sineoutput_2 = rom_memory[k];
        sineoutput_3 = rom_memory[l];
    end
    
    if (j == 1) begin
        on = 1'b1;
    end
    
    i = i + 1;
    j = j + 1;
    
    if (interval == 1) begin
        if (i == SIZE) begin
            complete = 1'b1;
            i = 0;
        end
    end 
	else if (interval == 2) begin
        k = k + 1;
        if(k == SIZE) begin
            complete = 1'b1;
            k = SIZE/2;
        end if(i == SIZE/2) begin
            complete = 1'b1;
            i = 0;
            end
    end 
	else if (interval == 3) begin
        k = k+ 1;
        l = l+ 1;
        if(k == 2*SIZE/3) begin
            k = SIZE/3;
            complete = 1'b1;
        end if (l == SIZE) begin
            l = 2*(SIZE/3);
            complete = 1'b1;
        end if(i == SIZE/3) begin
            i = 0;
            complete = 1'b1;
            end
    end
end
endmodule