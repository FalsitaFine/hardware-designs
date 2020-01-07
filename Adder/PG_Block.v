`timescale 1ns / 1ps
module PG_Block(
    input [5:0] A,
    input [5:0] B,
    output [5:0] P,
    output [5:0] G
    );

assign P[0] = A[0] ^ B[0];
assign P[1] = A[1] ^ B[1];
assign P[2] = A[2] ^ B[2];
assign P[3] = A[3] ^ B[3];
assign P[4] = A[4] ^ B[4];
assign P[5] = A[5] ^ B[5];
assign G = A & B;

endmodule
