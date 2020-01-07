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


module lab6_top(
 output [7:0] q,
 output [7:0] seg_out,
 output [3:0] anode,
 input clk,
 input [2:0] BNT,
 input [7:0] SW
 );
parameter RST = 3'b010;
parameter MOD = 3'b110;
parameter STR = 3'b111;
reg [7:0]dispout_0;
reg [7:0]dispout_1;
reg [7:0]dispout_2;
reg [7:0]dispout_3;

reg [7:0]memory[19:0];
reg [4:0]dispindex;
reg [4:0]modindex;
reg [4:0]timer;
integer xi;
integer xj;
clock_divider CDIV (cout, clk);
clock_divider #(.timeconst(15)) CDIV2 (cout2, clk);



//initialize
initial
begin
dispindex = 0;
modindex = 0;
timer = 0;
for(xi = 0; xi<20; xi = xi+1)
begin
memory[xi] = 8'b11111111;
end
end


always@(posedge cout)
begin
case(BNT)

RST:
begin
modindex = 0;
dispindex = 0;
for(xi = 0; xi<20; xi = xi+1)
begin
memory[xi] = 8'b11111111;
end
end


MOD:
begin
dispout_3 = 8'b11100011; // L
dispout_2 = 8'b11111111;
dispout_1 = 8'b11111111;
dispout_0 = SW;
end

STR:
begin
if (memory[modindex-1] != SW)
begin
memory[modindex] = SW;
modindex = modindex + 1;
dispout_3 = 8'b00000011; // O
dispout_2 = 8'b11111111;
dispout_1 = 8'b11111111;
dispout_0 = memory[modindex-1];
end
end

3'b000:
begin

if (timer>=10)

    begin
    
    if (dispindex >= modindex)
        begin
        dispindex = 0;
        end
    dispout_3 = memory[dispindex+3];
    dispout_2 = memory[dispindex+2];
    dispout_1 = memory[dispindex+1];
    dispout_0 = memory[dispindex];
    dispindex = dispindex + 1;
        timer = 0;

    end
    

timer = timer + 1;
end



default: //DISP
begin
if (timer >= 10)
begin
if (dispindex >= modindex)
begin
dispindex = 0;
end
dispout_3 = memory[dispindex+3];
dispout_2 = memory[dispindex+2];
dispout_1 = memory[dispindex+1];
dispout_0 = memory[dispindex];
dispindex = dispindex + 1;
timer = 0;

end

timer = timer + 1;


end


endcase
end

Mux MUX1(cout2,seg_out,anode,dispout_0,dispout_1,dispout_2,dispout_3);

endmodule