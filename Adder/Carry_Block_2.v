`timescale 1ns / 1ps

module Carry_Block_2(
    output Cout,
    input [5:0] p,
    input [5:0] g,
    input Cin
    );
	
	assign Cout = g[1] | (p[1]&g[0]) | (p[1]&p[0]&Cin);


endmodule
