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
    input [3:0] seg_in,
    output reg [7:0] seg_out
    );
    
    always@(*) begin
    case(seg_in)
    4'b0000: seg_out <= 8'b00000011;//0
    4'b0001: seg_out <= 8'b10011111;
    4'b0010: seg_out <= 8'b00100101;
    4'b0011: seg_out <= 8'b00001101;
    4'b0100: seg_out <= 8'b10011001;
    4'b0101: seg_out <= 8'b01001001;
    4'b0110: seg_out <= 8'b01000001;
    4'b0111: seg_out <= 8'b00011111;
    4'b1000: seg_out <= 8'b00000001;   
    4'b1001: seg_out <= 8'b00001001;
    4'b1010: seg_out <= 8'b00010001;//A
    4'b1011: seg_out <= 8'b11000001;//b
    4'b1100: seg_out <= 8'b01100011;//C
    4'b1101: seg_out <= 8'b10000101;//d
    4'b1110: seg_out <= 8'b01100001;//E
    4'b1111: seg_out <= 8'b01110001;//F
    default: seg_out <= 8'b00000011;
    endcase
    end
endmodule
