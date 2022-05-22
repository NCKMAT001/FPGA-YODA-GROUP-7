`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UCT HPES
// Engineer: NCKMAT001,CHTDIV004,NJRKIN001
// 
// Create Date: 21.05.2022 23:35:38
// Design Name: 
// Module Name: maxmin
// Project Name: YODA
// Target Devices: NEXYS DDR4 
// Tool Versions: 
// Description: FIND MAX AND MIN VALS FROM AUDIO FILE
// 
// Dependencies: 
// 
// Revision: FINAL
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module maxmin(
    input clk,
    input wire [31:0] sound,
    output reg [31:0] max,
    output reg [31:0] min
    );
always@(posedge clk) begin
    if (enable == 1'b1) begin
        if (sound > max) begin
            max = sound;
            $display("Current maximum = ",max);
        end 
        if (sound < min) begin
            min = sound;
            $display("Current minimum = ",min);
        end
    end 
    else begin
        max = sound;
        min = sound;
    end
end
endmodule
