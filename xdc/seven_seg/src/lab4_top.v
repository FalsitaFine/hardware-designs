`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2018 02:01:15 PM
// Design Name: 
// Module Name: lab4_top
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


module lab4_top(
 output [7:0] q,
 output [7:0] seg_out,
 output [3:0] anode,
 input clk,
 input rst,
 input stp
 );


 reg seed = 8'b00000001;
 wire [7:0]interim_q;
 wire [7:0]out_seg_1;
 wire [7:0]out_seg_2;
 wire [7:0]out_seg_3;
 wire [7:0]out_seg_4;
wire cout, cout2;
 clock_divider CDIV (cout, clk);
 clock_divider #(.timeconst(15)) CDIV2 (cout2, clk);

 lfsr LSFR (interim_q, seed, rst, cout,stp);
// seven_seg SSEG(interim_q[3:0], q);
 assign q = interim_q;
 seven_seg SSEG1(interim_q[3:0], out_seg_1);
 seven_seg SSEG2(interim_q[7:4], out_seg_2);
 seven_seg SSEG3(interim_q[5:2], out_seg_3);
 seven_seg SSEG4(interim_q[6:3], out_seg_4);

Mux MUX1(cout2,seg_out,anode,out_seg_1,out_seg_2,out_seg_3,out_seg_4);



endmodule