`timescale 1ns / 1ps

module Carry_Block_1(
    output Cout,
    input [5:0] p,
    input [5:0] g,
    input Cin
    );
	
	 assign Cout = g[0] | (p[0]&Cin);

endmodule


//get the solution for the carry lookahead adder !
