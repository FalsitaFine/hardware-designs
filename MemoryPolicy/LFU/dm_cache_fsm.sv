`timescale 1ns / 1ps

//TODO 
//modify the cache FSM so that it implements 
//an n-way set associative cache
//also implement two replacement strategies
//LRU(least recently used) and MRU(most recently used) 

import cache_def::*; 

/*cache finite state machine*/
module dm_cache_fsm(input  bit clk, input  bit rst,
        input  cpu_req_type  cpu_req,       
        //CPU request input (CPU->cache)
        input  mem_data_type  mem_data,     
        //memory response (memory->cache)
        output mem_req_type   mem_req,      
        //memory request (cache->memory)
        output cpu_result_type cpu_res      
        //cache result (cache->CPU)
    );
  timeunit  1ns;  
  timeprecision  1ps;
  /*write  clock*/
  typedef enum {idle, compare_tag, allocate, write_back} cache_state_type;
  /*FSM state register*/
  cache_state_type vstate,rstate;
  int way_helper,tagFound;
  /*interface signals to tag memory*/
  int way;
  int controller;
  int LFUCounter[0:N-1][0:1023];
  int QLRU[1024][$];
  int QMRU[1024][$];
  int min;
  cache_tag_type tag_read[0:N-1];                 //tag  read  result
  cache_tag_type tag_write;                //tag  write  data
  cache_req_type tag_req;                  //tag  request
  /*interface signals to cache data memory*/
  cache_data_type data_read;               //cache  line  read  data
  cache_data_type data_write;              //cache  line  write  data
  cache_req_type data_req;                 //data  req
  /*temporary variable for cache controller result*/
  cpu_result_type v_cpu_res;  
  /*temporary variable for memory controller request*/
  mem_req_type v_mem_req;
  assign mem_req = v_mem_req;              //connect to output ports
  assign cpu_res = v_cpu_res; 

  initial begin
    for(int i = 0; i<N; i++)
      for(int j = 0; j<1024;j++)
      LFUCounter[i][j] = 0;
end
    always_comb begin
        /*-------------------------default values for all signals------------*/
        /*no state change by default*/
        vstate = rstate;                  
        v_cpu_res = '{0, 0, 0}; tag_write = '{0, 0, 0}; 
        /*read tag by default*/
        tag_req.we = '0;             
        /*direct map index for tag*/
         tag_req.index = cpu_req.addr[13:4];
        /*read current cache line by default*/
        data_req.we  =  '0;
        /*direct map index for cache data*/
        data_req.index = cpu_req.addr[13:4];
        /*modify correct word (32-bit) based on address*/
        data_write = data_read;        
        case(cpu_req.addr[3:2])
        2'b00:data_write[31:0]  =  cpu_req.data;
        2'b01:data_write[63:32]  =  cpu_req.data;
        2'b10:data_write[95:64]  =  cpu_req.data;
        2'b11:data_write[127:96] = cpu_req.data;
        endcase
        /*read out correct word(32-bit) from cache (to CPU)*/
        case(cpu_req.addr[3:2])
        2'b00:v_cpu_res.data  =  data_read[31:0];
        2'b01:v_cpu_res.data  =  data_read[63:32];
        2'b10:v_cpu_res.data  =  data_read[95:64];
        2'b11:v_cpu_res.data  =  data_read[127:96];
        endcase
        /*memory request address (sampled from CPU request)*/
        v_mem_req.addr = cpu_req.addr; 
        /*memory request data (used in write)*/
        v_mem_req.data = data_read; 
        v_mem_req.rw  = '0;
        //if(mem_data.ready)
        //v_mem_req.valid = '0;
        
        //------------------------------------Cache FSM-------------------------
        case(rstate)
            /*idle state*/
            idle : begin
            controller = 0;
                         // $display("<<<<<<<<<<<<<<<<<idle" );

                /*If there is a CPU request, then compare cache tag*/
                if (cpu_req.valid)
                   vstate = compare_tag;
                end
            /*compare_tag state*/ 
            compare_tag : begin
                                //      $display("<<<<<<<<<<<<<<<<<compare_tag" );
//if(vstate == rstate) $display("vstate = rstate");
//if(vstate != rstate) $display("vstate != rstate");
                                                    
                                                                            

              /*cache hit (tag match and cache entry is valid)*/
              min = 0;
              way_helper=0;

              tagFound = 0;
              while(way_helper < N && tagFound == 0)begin
          //    $display("Way = %d",way_helper );
           //   $display("HERE!!!");
         //     $display("Tag_wanting: %d Tag_Found: %d",cpu_req.addr[TAGMSB:TAGLSB],tag_read[way_helper].tag );

              if (cpu_req.addr[TAGMSB:TAGLSB] == tag_read[way_helper].tag && tag_read[way_helper].valid) begin
                  v_cpu_res.ready = '1;
                  tagFound = 1;
                  way = way_helper;
                  /*write hit*/
                  if (cpu_req.rw) begin 
                  /*read/modify cache line*/
              //    $display("data.req triggered with way = %d",way_helper );

                    tag_req.we = '1; data_req.we = '1;
                  /*no change in tag*/
                   //               $display("[1]count at way %d added ", way_helper);
                                  if(controller != 1) begin
                                  LFUCounter[way_helper][data_req.index]++;         
                                  controller = 1;         
                                  end

                    tag_write.tag = tag_read[way_helper].tag; 
                    tag_write.valid = '1;
                  /*cache line is dirty*/
                    tag_write.dirty = '1;           
                  end 
              /*xaction is finished*/
              vstate = idle; 
              end 
              /*If tag in this way doesn't match, match with the next way tag.*/
              else way_helper = way_helper + 1;end
              /*cache miss*/
              if(tagFound ==0) begin 
           //    $display("tag not found" );

                /*generate new tag and decide a way*/
                 min = LFUCounter[0][data_req.index];
                 for(way_helper = 0;way_helper < N;way_helper ++)begin
                                     //          $display("count at way %d is %d ", way_helper,LFUCounter[way_helper][data_req.index] );

                                   if(LFUCounter[way_helper][data_req.index] < min)
                                   min = LFUCounter[way_helper][data_req.index];                
                               end
                                          //    $display("min = %d",min );

                               for(way_helper = 0;way_helper < N;way_helper ++)begin
                             // $display("count at way %d is %d ", way_helper,LFUCounter[way_helper][data_req.index] );

                                   if (LFUCounter[way_helper][data_req.index] == min)begin
                                       way = way_helper;
                                       LFUCounter[way_helper][data_req.index] = 0;
                         //              $display("[2]count at way %d changed into zero ", way_helper);

                                 //             $display("final way chosen = %d",way );

                                       break;
                                   end                
                               end
                tag_req.we = '1; 
                tag_write.valid = '1;
                /*new tag*/
                tag_write.tag = cpu_req.addr[TAGMSB:TAGLSB];
                /*cache line is dirty if write*/
                tag_write.dirty = cpu_req.rw;
                /*generate memory request on miss*/
                v_mem_req.valid = '1; 
                /*compulsory miss or miss with clean block*/
                if (tag_read[way].valid == 1'b0 || tag_read[way].dirty == 1'b0) begin
                     /*wait till a new block is allocated*/
                  //   $display("next vstate = allocate");
                  //   rstate = allocate;

                     vstate = allocate;
                     end
                else begin
                     /*miss with dirty line*/
                        /*write back address*/
                        v_mem_req.addr = {tag_read[way].tag, cpu_req.addr[TAGLSB-1:0]};
                        v_mem_req.rw = '1; 
                        /*wait till write is completed*/
                   //    $display("next vstate = wb");
                     //   rstate = write_back;
                        vstate = write_back;
                end
              end 
            end
            /*wait for allocating a new cache line*/
            allocate: begin        
                        controller = 0;
 
                               //       $display("<<<<<<<<<<<<<<<<<allocate" );
            //     $display("(allocate)data.req NOT triggered with current way = %d",way );

               v_mem_req.valid = '0;   
               /*memory controller has responded*/
               if (mem_data.ready) begin
               /*re-compare tag for write miss (need modify correct word)*/
               vstate = compare_tag; 
               data_write = mem_data.data;
               way = way_helper;
               /*update cache line data*/
         //      $display("data.req triggered with wI = %d",way_helper );
           //    $display("(allocate)data.req triggered with way = %d",way );


               data_req.we = '1; 
               end 
            end
            /*wait for writing back dirty cache line*/
            write_back : begin         
                        controller = 0;

                                 //     $display("<<<<<<<<<<<<<<<<<write_back" );

               /*write back is completed*/
               if (mem_data.ready) begin
                  /*issue new memory request (allocating a new line)*/
                  v_mem_req.valid = '1;            
                  v_mem_req.rw = '0;     
                        
                  vstate = allocate; 
               end
            end
        endcase
    end //end always_comb
       
    always_ff @(posedge(clk)) begin
        if (rst) 
          rstate <= idle;       //reset to idle state
        else 
          rstate <= vstate;

        //print the queue value
    end //end always_ff
    
    /*connect cache tag/data memory*/
    dm_cache_tag  ctag(.*);
    dm_cache_data cdata(.*);
    
endmodule