`timescale 1ns / 1ps
module ripple_carry_four_bit(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    input [2:0] control,
    output Cout,
    output [3:0] result
    );
	wire[2:0] carry;
		
one_bit_ALU fa0 (A[0],B[0],Cin,2,carry[0],result[0]);
one_bit_ALU fa1 (A[1],B[1],carry[0],2,carry[1],result[1]);
one_bit_ALU fa2 (A[2],B[2],carry[1],2,carry[2],result[2]);
one_bit_ALU fa3 (A[3],B[3],carry[2],2,Cout,result[3]);


//students need to fill in this skeleton


endmodule
