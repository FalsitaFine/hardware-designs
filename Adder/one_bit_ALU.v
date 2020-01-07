`timescale 1ns / 1ps
module one_bit_ALU(
    input A,
    input B,
    input Cin,
    input [2:0] control,
    output Cout,
    output result);

reg temp_Cout;
reg temp_result;
always @(A,B,Cin,control) begin
case(control)
0: begin
temp_result <= A & B;
end
		
1: begin
temp_result <= A | B;
end

2: begin
temp_Cout <= (B&Cin) | (A&Cin) | (A&B);
temp_result <= (A ^ B ^ Cin);
end
default:
begin
temp_Cout <= 0;
temp_result <= 0;
end
endcase
end
assign Cout = temp_Cout;
assign result = temp_result;


endmodule
