// design  module for fifo
`timescale 1ns/1ps
module fifo(clk,reset,wr_en,rd_en,din,dout,full,empty);
  input clk,reset;
  input wr_en,rd_en;
  input [7:0]din;
  output [7:0]dout;
  output full,empty;
  
  // memory (RAM) declaration
  reg[7:0]mem[0:15];
  //datatype declaration
  wire clk,reset;
  wire wr_en,rd_en;
  wire [7:0]din;
  reg [7:0]dout;
  reg [4:0]addr;
  integer i;
  assign full = (addr == 5'b10000)?1'b1 :1'b0;
  assign empty = (addr == 5'b00000)?1'b1 : 1'b0;
  
  // declaring the counters and 
  // at starting they all will be initialized with zero 
  always@(posedge clk)
    begin
      if (reset)
         begin  
                 addr = 4'b0000;
                 for(i = 0; i<15 ; i = i+1);
                 mem[i] = 0;
           end 
      else 
        if(wr_en | rd_en) // read or write process
          begin 
            if(wr_en && (!full))
              mem[addr] = din;
              addr = addr + 1;
          end
           else 
              if(rd_en &&(!empty))
                 begin
                   dout = mem[0];
                   mem[0] = mem[1];
                   mem[1] = mem[2];
                   mem[2] = mem[3];
                   mem[3] = mem[4];
                   mem[4] = mem[5];
                   mem[5] = mem[6];
                   mem[6] = mem[7];
                   mem[7] = mem[8];
                   mem[8] = mem[9];
                   mem[9] = mem[10];
                   mem[10] = mem[11];
                   mem[11] = mem[12];
                   mem[12] = mem[13];
                   mem[13] = mem[14];
                   mem[14] = mem[15];
                   mem[15] = 0;
                   addr = addr - 1;
                   
                 end 
           end
   
endmodule


// testbench of the fifo module 
`timescale 1ns/1ps
module test_fifo; // no port declaration
  
  reg clk,reset;
  reg wr_en,rd_en;
  reg [7:0]din;
  wire [7:0]dout;
  wire full,empty;
  
  // DUT instantiation
  fifo UUT(clk,reset,wr_en,rd_en,din,dout,full,empty);
  
  // initializing the clk to zero
  initial begin 
    clk = 0;
  end 
   
   // using task function to initalize the reset
  task rst;
   
    begin
      #10 reset = 1;
    
    #20 reset = 0;
    end
  endtask
   // clk generation 
   always #5 clk = ~clk; //  time = 10 ns timeperiod 
  
  // write and read initializing 
  task wr_rd_init;
       begin 
       wr_en = 0;
       rd_en = 0;
       din = 0;
       end 
  endtask
  //write process 
  task write;
    input [7:0]wdata;
      begin 
        @(posedge clk)
        begin
          wr_en = 1;
          din = wdata;
        end 
      end
  endtask 
  // write all 16 bits of data 
  task write16;
    begin 
      write(8'hf1);
      write(8'hf2);
      write(8'hf3);
      write(8'hf4);
      write(8'hf5);
      write(8'hf6);
      write(8'hf7);
      write(8'hf8);
      write(8'hf9);
      write(8'hfa);
      write(8'hfb);
      write(8'hfc);
      write(8'hfd);
      write(8'hfe);
      write(8'hf1);
      write(8'hf2);
      write(8'hf3);
      
    end
  endtask
  // ending the write task 
  task endwrite;
    begin 
      wr_en = 0;
      din = 0;
    end
  endtask
  
  
  // read process 
  task read;
    begin 
       @(posedge clk)
     begin  
       rd_en = 1;
     end 
    end 
  endtask 
  // writing read  16 

  task read16;
    begin 
      read;read;read;read;
      read;read;read;read;
      read;read;read;read;
      read;read;read;read;
    end
  endtask 
  
  //ending read task
  task endread;
    begin 
      @(posedge clk)
      begin
        rd_en = 0;
      end 
    end 
  endtask
  // actual process done here calling all the task functions 
  initial begin
    rst;
    wr_rd_init;
    write16;
  endwrite;
    #2 read16;   // after some delay read process is started
    #10 endwrite;
    
    #10$stop;
  end 
  
  // for wave form generation 
  initial begin 
    $dumpfile("dump.vcd");
    $dumpvars(1,test_fifo);
  end 
endmodule
    
    
  
    