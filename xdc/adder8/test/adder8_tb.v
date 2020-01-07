`timescale 1ns / 1ps 
module adder8_tb( ); 
reg cin; 
reg [7:0] a,b; 
wire cout; 
wire [7:0] s; 

// instantiate the unit under test uut
adder8 uut(cout,s,a,b,cin); 

// stimulus (inputs) 
initial begin 
#10 // wait for global reset 
a=8'b00000000; b=8'b00000000; cin=1'b0; 
#10 
a=8'b11111111; b=8'b00000001; cin=1'b0; 
#10 
a=8'b10101010; b=8'b01010101; cin=1'b0; 
#10 
a=8'b11110000; b=8'b00001111; cin=1'b1; 
end 

// results (outputs) 
initial begin 
#5 $display("a = %b, b = %b, cin = %b",a,b,cin); $display("s = %b, cout = %b",s,cout);
#10 $display("a = %b, b = %b, cin = %b",a,b,cin); $display("s = %b, cout = %b",s,cout); 
#10 $display("a = %b, b = %b, cin = %b",a,b,cin); $display("s = %b, cout = %b",s,cout); 
$display("End Simulation"); 
end 

endmodule

