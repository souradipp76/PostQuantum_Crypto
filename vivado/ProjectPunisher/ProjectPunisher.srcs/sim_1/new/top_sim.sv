`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.04.2019 11:18:30
// Design Name: 
// Module Name: top_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_sim(

    );
logic start;
logic clock;
logic reset;

initial clock = 0;

initial begin
#5 start = 1;
#12 start = 0;
end

top_module tm (
    .clock(clock),
    .start_top(start),
    .reset(reset));

always
#2 clock = ~clock;



endmodule
