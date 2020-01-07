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


module lab4_top(
 output [7:0] q,
 output [7:0] seg_out,
 output [3:0] anode,
 input clk,
 input rst,
 input stp,
 input roll
 );
parameter START = 3'b000;
parameter COUNT = 3'b001;
parameter CHECK = 3'b010;
parameter AGAIN = 3'b011;
parameter CHKAG = 3'b100;
parameter WINNN = 3'b101;
parameter LOOSE = 3'b110;
parameter BFAGN = 3'b111;

 reg seed = 8'b00000011;
 wire [7:0]interim_q;
 wire [7:0]interim_qs;
 wire [7:0]out_seg_1;
 wire [7:0]out_seg_2;
 wire [7:0]out_seg_3;
 wire [7:0]out_seg_4;
 wire cout, cout2;
 reg [2:0]state;
 reg [2:0]next_state;
 reg [1:0]result;
 reg [2:0]dice_1;
 reg [2:0]dice_2;
 reg point;
 
 initial
 begin
 state = 3'b000;
 next_state = 3'b000;
 result = 2'b00;
 dice_1 = 3'b000;
 dice_2 = 3'b000;
 point = 4'b0000;
 end
 

 clock_divider CDIV (cout, clk);
 clock_divider #(.timeconst(15)) CDIV2 (cout2, clk);

 lfsr LSFR (interim_q, seed, rst, cout);
// seven_seg SSEG(interim_q[3:0], q);
 assign q = interim_q;
 assign qs = interim_qs;
 seven_seg SSEG1(dice_1, out_seg_1);
 seven_seg SSEG2(dice_2, out_seg_2);
 seven_seg_result SSEGR(result, out_seg_4);
 //seven_seg_compare2 SSEG4(interim_qs[3:0],interim_qs[7:4], out_seg_3);
  
always@(state or roll)
begin
case(state)
    
    START:
    begin
    
    //reset
        result = 2'b00; // Show nothing(0)    
        point = 0;
        dice_1 = 0;
        dice_2 = 0;
    
    //begin    
        if(roll)
        next_state = COUNT;
        else
        next_state = START;
    end
    
    COUNT:
    begin
        if(~roll)
        begin
            case(interim_q[2:0])
            3'b000:
            dice_1 = 3'b011;
            3'b111:
            dice_1 = 3'b100;
            default:
            dice_1 = interim_q[2:0];
            endcase
            
            case(interim_q[5:3])
            3'b000:
            dice_2 = 3'b011;
            3'b111:
            dice_2 = 3'b100;
            default:
            dice_2 = interim_q[5:3];
            endcase
         
            next_state = CHECK;
        
        end  
        else
        next_state = COUNT;
    end
    
    CHECK:
    begin
        case(dice_1 + dice_2)
        7:
        next_state = WINNN;
        11:
        next_state = WINNN;
        2:
        next_state = LOOSE;
        3:
        next_state = LOOSE;
        12:
        next_state = LOOSE;
        default:
        begin
        result = 2'b01; // Show A
        point = dice_1 + dice_2;
        next_state = BFAGN;
        end
        endcase
    end
    
    BFAGN:
    begin
        result = 2'b01; // Show A
        if(roll)
        next_state = AGAIN;
        else
        next_state = BFAGN;
    end
    
    
    AGAIN:
    begin
        result = 2'b01; // Show A
        if(~roll)
        begin
        case(interim_q[2:0])
        3'b000:
        dice_1 = 3'b011;
        3'b111:
        dice_1 = 3'b100;
        default:
        dice_1 = interim_q[2:0];
        endcase
        
        case(interim_q[5:3])
        3'b000:
        dice_2 = 3'b011;
        3'b111:
        dice_2 = 3'b100;
        default:
        dice_2 = interim_q[5:3];
        endcase
     
        next_state = CHKAG;
        
        end
        
        else
        next_state = AGAIN;
    end
    
    
    CHKAG:
    begin
        if(dice_1 + dice_2 == point)
        next_state = WINNN;
        
        else if(dice_1 + dice_2 == 7)
        next_state = LOOSE;
        
        else next_state = BFAGN;
    end
    
    
    WINNN:
    begin
        result = 2'b10; //WINNN
        next_state = WINNN;
    end
    
    LOOSE:
    begin
        result = 2'b11; //LOOSE
        next_state = LOOSE;
    end

endcase
end


always@(posedge clk)
begin
if(rst)
state = START;
else
state = next_state;
end



Mux MUX1(cout2,seg_out,anode,out_seg_1,out_seg_2,out_seg_3,out_seg_4);



endmodule