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


module seven_seg(
    input [2:0] seg_in,
    output reg [7:0] seg_out
    );
    
    always@(*) begin
    case(seg_in)
    3'b000: seg_out <= 8'b00000011;//0
    3'b001: seg_out <= 8'b10011111;//1
    3'b010: seg_out <= 8'b00100101;//2
    3'b011: seg_out <= 8'b00001101;//3
    3'b100: seg_out <= 8'b10011001;//4
    3'b101: seg_out <= 8'b01001001;//5
    3'b110: seg_out <= 8'b01000001;//6
    default: seg_out <= 8'b00000011;
    endcase
    end
endmodule
