/*
 * lifo buffer
 *  if push and pop happen at the same time, let pop happen before push.
 *  that is, overwrite the top of stack
 *
 * popData should always reflect the value at top of stack,
 * irrespective of the push/pop control lines.
 *
 */
module lifo 
  #( 
     parameter int bW ,
     parameter int eC 
     )
   ( 
                // push interface 
  input  logic [bW-1:0] pushData,
  input  logic          push,
  output logic          full,
                // pop interface
  output logic [bW-1:0] popData,
  input  logic          pop,
  output logic          empty,
                // Globals
  input logic           clk,
  input logic           rst
 );

   logic [$clog2(eC)-1:0] occ, pushAdd, popAdd;

   assign popAdd = occ - 1'b1;
   assign pushAdd = pop ? popAdd : occ;
   
   counter13 #(eC + 1) mycounter(.inc(push), .dec(pop), .clk(clk), .rst(rst), .cnt(occ));
   assign full = (occ == eC);
   assign empty = (occ == '0);
   
   memory #(bW, eC) mymemory(popAdd, pushAdd, pushData, push, popData, clk);
      
endmodule

