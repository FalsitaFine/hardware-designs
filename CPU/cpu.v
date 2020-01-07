//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
//the CPU module from 4.13.4 of the textbook from the online companion material
//The initial register and memory state are read from .dat files and the
//resulting register and memory state are each printed into corresponding .dat
//files
module CPU (clock);
   parameter LW = 6'b100011, SW = 6'b101011, BEQ = 6'b000100, no_op = 32'b0000000_0000000_0000000_0000000, ALUop = 6'b0,
             BNE = 6'b000101, JRTop = 6'b011110, LWCABop=6'b011111;
   integer fd,code,str,t;
   input clock;
   reg[31:0] PC, Regs[0:31], IMemory[0:1023], DMemory[0:1023], // separate memories
             IFIDIR, IDEXA, IDEXB, IDEXC,IDEXD, IDEXIR, EXMEMIR, EXMEMB, // pipeline registers
             EXMEMALUOut, MEMWBValue, MEMWBIR; // pipeline registers
   wire [4:0] IDEXrs, IDEXrt, IDEXrd,IDEXrshamt,EXMEMrd, MEMWBrd, EXMEMrt, IFIDrs, IFIDrt,IFIDrshamt,IFIDrd; //hold register fields
   wire [5:0] EXMEMop, MEMWBop, IDEXop, IFIDop; //Hold opcodes
   wire [31:0] Ain, Bin,Cin,Din;
   reg flush, outbound;
   //declare the bypass signals
   wire takebranch, stall, bypassAfromMEM, bypassAfromALUinWB,bypassBfromMEM, bypassBfromALUinWB,
        bypassAfromLWinWB, bypassBfromLWinWB;
   wire bypassIDEXAfromWB, bypassIDEXBfromWB;
   wire bypassCfromMEM,bypassCfromALUinWB,bypassCfromLWinWB;
   wire bypassDfromMEM,bypassDfromALUinWB,bypassDfromLWinWB;
   wire bypassAfromLWCABinWB,bypassBfromLWCABinWB,bypassCfromLWCABinWB,bypassDfromLWCABinWB;
   assign IDEXrs = IDEXIR[25:21]; assign IDEXrt = IDEXIR[20:16]; 
   assign IDEXrd = IDEXIR[15:11]; assign IDEXrshamt=IDEXIR[10:6];
   assign EXMEMrd = EXMEMIR[15:11]; assign EXMEMrt = EXMEMIR[20:16];
   assign MEMWBrd = MEMWBIR[15:11]; assign EXMEMop = EXMEMIR[31:26];
   assign MEMWBop = MEMWBIR[31:26];  assign IDEXop = IDEXIR[31:26];
   assign IFIDop = IFIDIR[31:26]; assign IFIDrs = IFIDIR[25:21];
   assign IFIDrt = IFIDIR[20:16]; assign IFIDrshamt=IFIDIR[10:6];
   assign IFIDrd = IFIDIR[15:11];
   // The bypass to input A from the MEM stage for an ALU operation
   assign bypassAfromMEM = (IDEXrs == EXMEMrd) & (IDEXrs != 0) & (EXMEMop == ALUop); // yes, bypass
   // The bypass to input B from the MEM stage for an ALU operation
   assign bypassBfromMEM = (IDEXrt == EXMEMrd)&(IDEXrt != 0) & (EXMEMop == ALUop); // yes, bypass
   // The bypass to input C from the MEM stage for an ALU operation
   assign bypassCfromMEM = (IDEXrshamt == EXMEMrd)&(IDEXrshamt != 0) & (EXMEMop == ALUop); // yes, bypass
   // The bypass to input D from the MEM stage for an ALU operation
   assign bypassDfromMEM = (IDEXrd == EXMEMrd) & (IDEXrd != 0) & (EXMEMop == ALUop); // yes, bypass
   // The bypass to input A from the WB stage for an ALU operation
   assign bypassAfromALUinWB =( IDEXrs == MEMWBrd) & (IDEXrs != 0) & (MEMWBop == ALUop);
   // The bypass to input B from the WB stage for an ALU operation
   assign bypassBfromALUinWB = (IDEXrt == MEMWBrd) & (IDEXrt != 0) & (MEMWBop == ALUop);
   // The bypass to input C from the WB stage for an ALU operation
   assign bypassCfromALUinWB = (IDEXrshamt == MEMWBrd) & (IDEXrshamt != 0) & (MEMWBop == ALUop);
   // The bypass to input D from the WB stage for an ALU operation
   assign bypassDfromALUinWB =( IDEXrd == MEMWBrd) & (IDEXrd != 0) & (MEMWBop == ALUop);
   // The bypass to input A from the WB stage for an LW operation
   assign bypassAfromLWinWB =( IDEXrs == MEMWBIR[20:16]) & (IDEXrs != 0) & (MEMWBop == LW);
   // The bypass to input B from the WB stage for an LW operation
   assign bypassBfromLWinWB = (IDEXrt == MEMWBIR[20:16]) & (IDEXrt != 0) & (MEMWBop == LW);
   // The bypass to input C from the WB stage for an LW operation
   assign bypassCfromLWinWB = (IDEXrshamt == MEMWBIR[20:16]) & (IDEXrshamt != 0) & (MEMWBop == LW);
   // The bypass to input D from the WB stage for an LW operation
   assign bypassDfromLWinWB = ( IDEXrd == MEMWBIR[20:16]) & (IDEXrd != 0) & (MEMWBop == LW) & (IDEXop == LWCABop);
   // The bypass to input A from the WB stage for an lwcab operation
   assign bypassAfromLWCABinWB =( IDEXrs == MEMWBIR[25:21]) & (IDEXrs != 0) & (MEMWBop == LWCABop);
   // The bypass to input B from the WB stage for an lwcab operation
   assign bypassBfromLWCABinWB = (IDEXrt == MEMWBIR[25:21]) & (IDEXrt != 0) & (MEMWBop == LWCABop);
   // The bypass to input C from the WB stage for an lwcab operation
   assign bypassCfromLWCABinWB = (IDEXrshamt == MEMWBIR[25:21]) & (IDEXrshamt != 0) & (MEMWBop == LWCABop);
   // The bypass to input D from the WB stage for an lwcab operation
   assign bypassDfromLWCABinWB =( IDEXrd == MEMWBIR[25:21]) & (IDEXrd != 0) & (MEMWBop == LWCABop);
    
   // The A input to the ALU is bypassed from MEM if there is a bypass there,
   // Otherwise from WB if there is a bypass there, and otherwise comes from the IDEX register
   assign Ain = bypassAfromMEM? EXMEMALUOut :
               (bypassAfromALUinWB | bypassAfromLWinWB | bypassAfromLWCABinWB)? MEMWBValue : IDEXA;
   // The B input to the ALU is bypassed from MEM if there is a bypass there,
   // Otherwise from WB if there is a bypass there, and otherwise comes from the IDEX register
   assign Bin = bypassBfromMEM? EXMEMALUOut :
               (bypassBfromALUinWB | bypassBfromLWinWB | bypassBfromLWCABinWB)? MEMWBValue: IDEXB;
   // The C input to the ALU is bypassed from MEM if there is a bypass there,
   // Otherwise from WB if there is a bypass there, and otherwise comes from the IDEX register
   assign Cin = bypassCfromMEM? EXMEMALUOut :
               (bypassCfromALUinWB | bypassCfromLWinWB | bypassCfromLWCABinWB)? MEMWBValue: IDEXC; 
   // The D input to the ALU is bypassed from MEM if there is a bypass there,
   // Otherwise from WB if there is a bypass there, and otherwise comes from the IDEX register
   assign Din = bypassDfromMEM? EXMEMALUOut :
               (bypassDfromALUinWB | bypassDfromLWinWB | bypassDfromLWCABinWB)? MEMWBValue: IDEXD;      
   //Forwarding from the WB stage to the decode stage
   assign bypassIDEXAfromWB = (MEMWBIR != no_op) & (IFIDIR != no_op) &
   (((IFIDIR[25:21] == MEMWBIR[20:16]) & (MEMWBop == LW)) | ( (MEMWBop == ALUop) & (MEMWBrd == IFIDrs)));
   assign bypassIDEXBfromWB = (MEMWBIR != no_op) & (IFIDIR != no_op) &
   (((IFIDIR[20:16] == MEMWBIR[20:16]) & (MEMWBop == LW)) | ( (MEMWBop == ALUop) & (MEMWBrd == IFIDrt)));
   //only for determine branch or not, no need Cin or Din
  
   // The signal for detecting a stall based on the use of a result from LW
   assign stall = ((IDEXIR[31:26] == LW) && // source instruction is a load
         ((((IFIDop == LW)|(IFIDop == SW)) && (IFIDrs == IDEXrt)) | // stall for address calc
          ((IFIDop == LWCABop)&&((IFIDrt == IDEXrt)|(IFIDrd == IDEXrt))) | // stall for lwcab
          ((IFIDop == ALUop) && ((IFIDrs == IDEXrt) | (IFIDrt == IDEXrt) | (IFIDrshamt == IDEXrt)))| // ALU use
          ((IFIDop == JRTop) &&  (IFIDrs == IDEXrt)) | // for JRT
          ((IFIDop == SW) &&  ((IFIDrs == IDEXrt) | (IFIDrt == IDEXrt))) | //stall for SW
          //stall for LW
          (((IFIDop == BEQ)|(IFIDop == BNE)) && ((IFIDrs == IDEXrt) | (IFIDrt == IDEXrt))))) |
          ((EXMEMIR[31:26] == LW) && ((IFIDop==BEQ)|(IFIDop==BNE)) && ((IFIDrs==EXMEMrt)|(IFIDrt==EXMEMrt))) |
          //for ALU
          ((IDEXIR[31:26] == ALUop) && ((IFIDop==BEQ)|(IFIDop==BNE)) && ((IFIDrs==IDEXrd) | (IFIDrt==IDEXrd))) |
          //Stall for lwcab(same with LW)
          ((IDEXIR[31:26] == LWCABop) &&
          ((((IFIDop == LW)|(IFIDop == SW)) && (IFIDrs == IDEXrs)) | // stall for address calc
          ((IFIDop == LWCABop)&&((IFIDrt == IDEXrs)|(IFIDrd == IDEXrs))) | // stall for lwcab
          ((IFIDop == ALUop) && ((IFIDrs == IDEXrs) | (IFIDrt == IDEXrs) | (IFIDrshamt==IDEXrs)))| // ALU use
          ((IFIDop == JRTop) &&  (IFIDrs == IDEXrt)) |  // for JRT
          ((IFIDop == SW) &&  ((IFIDrs == IDEXrs) | (IFIDrt == IDEXrs)))));

   //Signal for a taken branch: instruction is BEQ and registers are equal
   assign takebranch = ((IDEXIR[31:26]==BEQ) && (Ain == Bin)) |
                       ((IDEXIR[31:26]==BNE) && (Ain != Bin));
  
   reg [10:0] i; //used to initialize registers
   initial begin
      t=0 ;
      #1 //delay of 1, wait for the input ports to initialize
      PC = 0;
      IFIDIR = no_op; IDEXIR = no_op; EXMEMIR = no_op; MEMWBIR = no_op; // put no_ops in pipeline registers
      for (i=0;i<=31;i=i+1) Regs[i]=i; //initialize registers -- just so they aren't don't cares
      for(i=0;i<=1023;i=i+1) IMemory[i]=0;
      for(i=0;i<=1023;i=i+1) DMemory[i]=0;
      fd=$fopen("/home/cuixx327/Desktop/lab2test/regs.dat","r");
      i=0; while(!$feof(fd)) begin
        code=$fscanf(fd, "%b\n", str);
        Regs[i]=str;
        i=i+1;
      end
      i=0; fd=$fopen("/home/cuixx327/Desktop/lab2test/dmem.dat","r");
      while(!$feof(fd)) begin
        code=$fscanf(fd, "%b\n", str);
        DMemory[i]=str;
        i=i+1;
      end
      i=0; fd=$fopen("/home/cuixx327/Desktop/lab2test/imem.dat","r");
      while(!$feof(fd)) begin
        code=$fscanf(fd, "%b\n", str);
        IMemory[i]=str;
        i=i+1;
      end
      #396
      i=0; fd =$fopen("/home/cuixx327/Desktop/lab2test/mem_result.dat","w" ); //open memory result file
      while(i < 32)
      begin
        str = DMemory[i];  //dump the first 32 memory values
        $fwrite(fd, "%b\n", str);
        i=i+1;
      end
      $fclose(fd);
      i=0; fd =$fopen("/home/cuixx327/Desktop/lab2test/regs_result.dat","w" ); //open register result file
      while(i < 32)
      begin
        str = Regs[i];  //dump the register values
        $fwrite(fd, "%b\n", str);
        i=i+1;
      end
      $fclose(fd);
   end
  
   always @(flush)begin
    if(flush)begin
    //branch is taken, next op should be changed into nop
        IFIDIR <= no_op;
        IDEXIR <= no_op;
    end       
   end
  
   always @ (posedge clock) begin
         t = t + 1;
         flush <= 0;
         if (~stall) begin // the first three pipeline stages stall if there is a load hazard
            //IF stage
            if (~takebranch) begin
               IFIDIR <= IMemory[PC>>2];
               PC <= PC + 4;
            end else begin // a taken branch is in ID; instruction in IF is wrong; insert a no_op and reset the PC
            flush <= 1;
            //two stages need flush
           
               PC <= PC + ({{16{IDEXIR[15]}}, IDEXIR[15:0]}<<2) - 4; 
              
            end        
           
            //ID stage        
            if ( ~bypassIDEXAfromWB ) begin
                  IDEXA <= Regs[IFIDIR[25:21]];
                end
            else begin
                  IDEXA <= MEMWBValue;
                end
               
            if ( ~bypassIDEXBfromWB) begin
              IDEXB <= Regs[IFIDIR[20:16]]; // get two registers
              end
            else begin
              IDEXB <= MEMWBValue;
              end
            IDEXC <= Regs[IFIDIR[10:6]];
            IDEXD <= Regs[IFIDIR[15:11]];
            IDEXIR <= IFIDIR;  //pass along IR
         end
         else begin  //Freeze first two stages of pipeline; inject a nop into the ID output
            IDEXIR <= no_op;
         end
        
         //EX stage of the pipeline
         if ((IDEXop==LW) |(IDEXop==SW))  // address calculation & copy B
           begin
              EXMEMALUOut <= Ain +{{16{IDEXIR[15]}}, IDEXIR[15:0]};
              EXMEMIR <= IDEXIR; EXMEMB <= Bin;
           end
         else if (IDEXop == JRTop)
           begin
               if (Ain == 0) begin
               EXMEMALUOut <= 1;
               PC <= PC + ({{16{IDEXIR[15]}}, IDEXIR[15:0]}<<2) - 4;
               EXMEMIR <= IDEXIR; EXMEMB <= Bin;
               flush <= 1;
           end
           else begin
               EXMEMIR <= no_op;
           end
         end
         else if (IDEXop == LWCABop)begin
           if(Bin < Din)begin
               EXMEMALUOut <= Bin;
               outbound <= 0;
           end
           else begin
               EXMEMALUOut <= 0;
               outbound <= 1;
           end
           EXMEMIR <= IDEXIR; EXMEMB <= Bin;
         end
         else if (IDEXop==ALUop) case (IDEXIR[5:0]) //case for the various R-type instructions
                  29: begin
                      if(Ain < Bin) begin
                           EXMEMALUOut = Cin;
                           EXMEMIR <= IDEXIR; EXMEMB <= Bin;
                      end
                      else
                           EXMEMIR <= no_op;
                      end
                  32: begin
                         EXMEMALUOut <= Ain + Bin;  //ADD operation
                      end
                  36: begin // AND operation
                         EXMEMALUOut <= Ain & Bin;
                      end
                  37: begin // OR operation
                         EXMEMALUOut <= Ain | Bin;
                      end
                  42: begin // SLT operation
                         if(Ain < Bin) begin
                           EXMEMALUOut = 32'b1;
                         end
                         else begin
                           EXMEMALUOut = 32'b0;
                         end
                      end
                  default: begin  end //other R-type operations: subtract, SLT, etc.
                endcase
          //pass along the IR & B register
         if(IDEXop == ALUop && IDEXIR[5:0] != 29) begin
         EXMEMIR <= IDEXIR; EXMEMB <= Bin;
         end
       
         //MEM stage
         if (EXMEMop==ALUop | EXMEMop ==JRTop) MEMWBValue <= EXMEMALUOut; //pass along ALU result
         else if (EXMEMop == LW) MEMWBValue <= DMemory[EXMEMALUOut>>2];
         else if (EXMEMop == LWCABop) begin
           if(outbound) begin
            MEMWBValue <=0;
           end
           else begin
           MEMWBValue <= DMemory[EXMEMALUOut>>2];
         end
         end
        
         else if (EXMEMop == SW) DMemory[EXMEMALUOut>>2] <= EXMEMB; //store
        
         //WB stage
         MEMWBIR <= EXMEMIR; //pass along IR
         if ((MEMWBop == JRTop)) Regs[MEMWBIR[25:21]] <= MEMWBValue; // jrt
         else if (MEMWBop == LWCABop) Regs[MEMWBIR[25:21]] <= MEMWBValue;// lwcab
         else if ((MEMWBop == ALUop) & (MEMWBrd != 0)) Regs[MEMWBrd] <= MEMWBValue; // ALU operation
         else if ((MEMWBop == LW)& (MEMWBIR[20:16] != 0)) begin
                  Regs[MEMWBIR[20:16]] <= MEMWBValue;
              end
      end
   endmodule