`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2018 01:59:44 PM
// Design Name: 
// Module Name: lsfr
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

module lfsr (output reg [7:0]q, output reg [7:0]qs, input [7:0]seed, input rst, input clock, input stp, input roll);
wire din;
assign din = q[1]^q[2]^q[3]^q[7];
always@(posedge clock)
begin
if(~roll)
begin
if(~rst)
begin
q<={q[6:0],din};
end
else
begin
q<=seed;
end
end
if(roll)
begin
qs<={q[6:0],din};
end
end


endmodule
