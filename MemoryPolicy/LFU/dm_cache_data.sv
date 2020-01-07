`timescale 1ns / 1ps

//TODO
//modify the cache so that it 
//is set associative
import cache_def::*; 

/*cache: data memory, single port, 1024 blocks*/
module dm_cache_data(input  bit clk, 
    input  cache_req_type  data_req,//data request/command, e.g. RW, valid
    input int way,
    input  cache_data_type data_write, //write port (128-bit line) 
    output cache_data_type data_read); //read port
    timeunit 1ns; timeprecision 1ps;
    cache_data_type data_mem[0:N-1][0:1023];
  
  initial  begin
    for (int i=0; i < N; i++)       begin
          for(int j = 0; j < 1024;j++)
          data_mem[i][j] = 0;
    end
  end
  
  assign  data_read  =  data_mem[way][data_req.index];
  
  always_ff  @(posedge(clk))  begin
    if  (data_req.we) begin
      data_mem[way][data_req.index] <= data_write;
      $display("%t: [Cache] write @ index=%x with data=%x within way# %d", $time, data_req.index, data_write, way );
      end
  end
endmodule

/*cache: tag memory, single port, 1024 blocks*/
module dm_cache_tag(input  bit clk, //write clock
    input  cache_req_type tag_req, //tag request/command, e.g. RW, valid
    input int way,
    input  cache_tag_type tag_write,//write port    
    output cache_tag_type tag_read[0:N-1]);//read port
  timeunit 1ns; timeprecision 1ps;
  cache_tag_type tag_mem[0:N-1][0:1023];
  initial  begin
      for (int i=0; i < N; i++)       begin
        for(int j = 0; j < 1024;j++)
            tag_mem[i][j] = 0;
      end
  end
  always_ff @(*)begin
    for (int i=0; i < N; i++)
      tag_read[i] = tag_mem[i][tag_req.index]; 
  end
  

  always_ff  @(posedge(clk))  begin
    if  (tag_req.we)
      tag_mem[way][tag_req.index] <= tag_write;
  end
endmodule