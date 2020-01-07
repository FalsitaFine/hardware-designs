`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2018 02:09:32 PM
// Design Name: 
// Module Name: Mux
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


module Mux(
    input clk,
    output reg [7:0]seg_out,
    output reg [3:0]anode,
    input [7:0]seg_out_1,
    input [7:0]seg_out_2,
    input [7:0]seg_out_3,
    input [7:0]seg_out_4
    );
    reg [1:0]counter;
always@(posedge clk)
begin
counter = counter + 1;
end
always@(*)
begin
case(counter)
2'b00:
begin
seg_out = seg_out_1;
anode = 4'b1110;
end

2'b01:
begin
seg_out = seg_out_2;
anode = 4'b1101;

end

2'b10:
begin
seg_out = seg_out_3;
anode = 4'b1011;

end

2'b11:
begin
seg_out = seg_out_4;
anode = 4'b0111;

end
endcase
end





endmodule
