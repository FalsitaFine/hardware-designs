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


module seven_seg_result(
    input [1:0] seg_in,
    output reg [7:0] seg_out
    );
    
    always@(*) begin
    case(seg_in)
    2'b00: seg_out <= 8'b00000011;//0
    2'b01: seg_out <= 8'b00010001;//A
    2'b10: seg_out <= 8'b10000011;//U
    2'b11: seg_out <= 8'b11100011;//L
    default: seg_out <= 8'b00000011;
    endcase
    end
endmodule
