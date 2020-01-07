`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2018 03:20:19 PM
// Design Name: 
// Module Name: seven_seg
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


module seven_seg_compare1(
    input [3:0] seg_in,
    input [3:0] seg_in_2,
    output reg [7:0] seg_out_compare
    );
    
    always@(*) begin
    if (seg_in == seg_in_2)
    begin
    seg_out_compare <= 8'b10000011;//U
    end
    else
    begin
    seg_out_compare <= 8'b11100011;//L
    end
    
    end
endmodule
