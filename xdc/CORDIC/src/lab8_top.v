`timescale 1ns / 1ps



module lab8_top(
 output [7:0] q,
 output [7:0] seg_out,
 output [3:0] anode,
 input clk,
 input BNT,
 input [15:0] SW,
 output [15:0]Xout,
 output [15:0]Yout

 );
reg signed [15:0]X,Y;
reg signed [15:0] tan_rom [15:0];
reg signed [15:0]Z;
reg sign;
//reg signed[15:0] Xout,Yout;
wire [7:0]out_seg_1;
wire [7:0]out_seg_2;
wire [7:0]out_seg_3;
wire [7:0]out_seg_4;
wire cout;
wire cout2;

wire carry;
wire sum;
integer i;
integer j;

clock_divider CDIV (cout, clk);
clock_divider #(.timeconst(15)) CDIV2 (cout2, clk);



//initialize
initial
begin
X = 16'b0010011100001001;
Y = 16'b0000000000000000;

tan_rom[0] = 16'b0011001001000011;
tan_rom[1] = 16'b0001110110101100;
tan_rom[2] = 16'b0000111110101101;
tan_rom[3] = 16'b0000011111110101;
tan_rom[4] = 16'b0000001111111110;
tan_rom[5] = 16'b0000000111111111;
tan_rom[6] = 16'b0000000011111111;
tan_rom[7] = 16'b0000000001111111;
tan_rom[8] = 16'b0000000000111111;
tan_rom[9] = 16'b0000000000011111;
tan_rom[10] = 16'b0000000000001111;
tan_rom[11] = 16'b0000000000000111;
tan_rom[12] = 16'b0000000000000011;
tan_rom[13] = 16'b0000000000000001;
tan_rom[14] = 16'b0000000000000000;
tan_rom[15] = 16'b0000000000000000;

end

reg signed[15:0] x_shift;
reg signed[15:0] y_shift;
//reg signed[15:0] y_shift_seri;

reg tempsum;
reg tempcout;
reg cin;
reg cinx;

always@(SW)
begin
Z = SW;
X = 16'b0010011100001001;
Y = 16'b0000000000000000;

for(i = 0; i<=15; i = i + 1)
begin
x_shift = X >>> i;
y_shift = Y >>> i;

sign = Z[15];
if (sign == 0)
begin
//Z>=0

Z = Z - tan_rom[i];
X = X - y_shift;
Y = Y + x_shift;
end
else
begin
//Z<0

// Bit serial implement for Z and X in this part, for demo.
/*
cin = 0;
cinx = 0;
for (j=0;j<=15;j=j+1)
begin
tempsum = Z[j]^tan_rom[i][j]^cin;
tempcout= (Z[j]&tan_rom[i][j])|(tan_rom[i][j]&cin)|(Z[j]&cin);
cin = tempcout;
Z[j] = tempsum;
end
for (j=0;j<=15;j=j+1)
begin
tempsum = X[0]^(Y[j]>>>i)^cinx;
tempcout= (X[0]&(Y[j]>>>i))|((Y[j]>>>i)&cinx)|(X[0]&cinx);
X = X>>>1;
cinx = tempcout;
X[15] = tempsum;
end
*/

Z = Z + tan_rom[i];
X = X + y_shift;
Y = Y - x_shift;
end





end

end


 seven_seg SSEG1(X[3:0], out_seg_1);
 seven_seg SSEG2(X[7:4], out_seg_2);
 seven_seg SSEG3(X[11:8], out_seg_3);
 seven_seg SSEG4(X[15:12], out_seg_4);
assign Xout = X;
assign Yout = Y;
Mux MUX1(cout2,seg_out,anode,out_seg_4,out_seg_3,out_seg_2,out_seg_1);

endmodule