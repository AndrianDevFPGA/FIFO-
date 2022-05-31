/*
  Author : Rakotojaona Nambinina
  email : Andrianoelisoa.Rakotojaona@gmail.com
  Description : Synchronized FIFO Written in Verilog HDL
*/

module fifo(
           clk,
           rst,
           wr,
           rd,
           wrData,
           rdData,
           full,
           empty
            );
  parameter DEPTH = 56;
  input clk;
  input rst;
  input wr;
  input rd;
  input [7:0] wrData;
  output reg [7:0] rdData;
  output wire full;
  output wire empty;
  
  //create memory for fifo 
  reg [7:0] memory [DEPTH -1 :0];
  
  reg [7:0] wrPointer;
  reg [7:0] rdPointer;
  
  reg [8:0] pointerFifo;
  
  // fifo full 
  assign full= (pointerFifo  == DEPTH-1)? 1:0;
  // fifo empty 
  assign empty = (pointerFifo == 0)? 1:0;
  
  // WRITE DATA 
  always @ (posedge clk)
    begin
      if (rst)
        begin
          wrPointer <= 0;
        end 
      else
        begin
          if (wr)
            begin
              memory [wrPointer] <= wrData;
              wrPointer <= wrPointer +1 ;
            end
        end
    end
  
  // READ DATA 
  always @ (posedge clk)
    begin
      if (rst)
        begin
          rdPointer <= 0;
        end 
      else
        begin
          if (rd)
            begin
              rdData  <=memory [rdPointer];
              rdPointer <= rdPointer + 1;
            end
        end
    end
    
    // controll full empty 
    always @ (posedge clk)
      begin
        if (rst)
          begin
            pointerFifo <=8'd0;
          end 
        else
          begin
            if (wr ==1'b0 && rd == 1'b0)
              begin
                pointerFifo <= pointerFifo ;
              end 
            else if (wr ==1'b1 && rd == 1'b0)
              begin
                pointerFifo <= pointerFifo + 1'b1 ;
              end 
            else if (wr == 1'b0 && rd == 1'b1)
              begin
                pointerFifo <= pointerFifo - 1'b1;
              end 
            else
              begin
                pointerFifo <= pointerFifo ;
              end 
          end 
      end 
  
endmodule


/*
    Test bench
    
module tbFifo(

    );
    
  parameter DEPTH = 56;
  reg clk;
  reg rst;
  reg wr;
  reg rd;
  reg [7:0] wrData;
  wire  [7:0] rdData;
  wire  full;
  wire  empty;
    
    fifo uut(
           clk,
           rst,
           wr,
           rd,
           wrData,
           rdData,
           full,
           empty
            );
 
   initial
     begin
       clk =0;
       rst =1;
       wr =0;
       rd=0;
       wrData =8'd1;
       #10 
       rst =0;
       #100 
       wr = 1;
       #150 
       wr = 0;
       #100 
       rd = 1;
       #100 
       rd =0;
       #200 
       wr = 1;
       #300 
       wr=0;
     end 
   
   always 
     begin
       #5 clk = ! clk;
     end 

endmodule

*/
