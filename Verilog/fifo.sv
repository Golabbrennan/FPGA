
module fifo  #( 
                parameter int bW ,
                parameter int eC ,
		parameter int ptrW = $clog2(eC),
		parameter int cntW = $clog2(eC+1) 
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
   
   
   logic [$clog2(eC)-1:0] popAddr, pushAddr, itemsCnt;


   counter13 #(eC) pushCounter(.inc(push && !full), .dec(1'b0), .clk(clk), .rst(rst), .cnt(pushAddr));
   counter13 #(eC) popCounter(.inc(pop && !empty), .dec(1'b0), .clk(clk), .rst(rst), .cnt(popAddr));
   counter13 #(eC + 1) itemsCounter(.inc(push && !full), .dec(pop && !empty), .clk(clk), .rst(rst), .cnt(itemsCnt));
   
   assign full = (itemsCnt == eC);
   assign empty = (itemsCnt == '0);
   

   memory #(bW,eC) mymem( .readAddr (popAddr),
		          .writeAddr(pushAddr),
		          .writeData(pushData),
		          .writeEn  (push && !full),
		          .readData (popData),
		          .clk      (clk)
                        );
   
endmodule
