`timescale 1ns / 1ps 
module lab8_tb( ); 

 wire [7:0] q;
 wire [7:0] seg_out;
 wire [3:0] anode;
 reg clk;
 reg BNT;
 reg [15:0] SW;
 wire [15:0] Xout;
 wire [15:0] Yout;


// instantiate the unit under test uut
lab8_top test(q,seg_out,anode,clk,BNT,SW,Xout,Yout); 

// stimulus (inputs) 
initial begin 
clk = 'b0;
#10 // wait for global reset 
SW=16'b0000000000000000; clk= !clk; //0 degree
#10 
SW=16'b0110010000000000; clk= !clk; //90 degree
#10 
SW=16'b0011001000000000; clk= !clk; //45 degree

end 

// results (outputs) 
initial begin 
#5 $display("X = %b, Y = %b,",Xout,Yout);
#10 $display("X = %b, Y = %b,",Xout,Yout);
#10 $display("X = %b, Y = %b,",Xout,Yout);
#10 $display("X = %b, Y = %b,",Xout,Yout);

$display("End Simulation"); 
end 

endmodule

