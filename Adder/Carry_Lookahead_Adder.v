`timescale 1ns / 1ps
module Carry_Lookahead_Adder(
    input [5:0] A,
    input [5:0] B,
    output Cout,
    output [5:0] S,
    input Cin
    );

wire [5:0] P; //propagate values are stored here
wire [5:0] G; //generate values are stores
wire [5:0] C; //carry for each bit position

PG_Block pgb(A,B,P,G);
Carry_Block_1 cb1(C[0],P,G,Cin);

Carry_Block_2 cb2(C[1],P,G,Cin);

Carry_Block_3 cb3(C[2],P,G,Cin);

Carry_Block_4 cb4(C[3],P,G,Cin);

Carry_Block_5 cb5(C[4],P,G,Cin);

Carry_Block_6 cb6(C[5],P,G,Cin);

assign S[0] = P[0] ^ Cin;
assign S[1] = P[1] ^ C[0];
assign S[2] = P[2] ^ C[1];
assign S[3] = P[3] ^ C[2];
assign S[4] = P[4] ^ C[3];
assign S[5] = P[5] ^ C[4];
assign Cout = C[5];
endmodule
