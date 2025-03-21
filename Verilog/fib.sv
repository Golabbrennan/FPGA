
module fib
#( bW = 3 )
(
  input  logic clk,
  input  logic rst,
  output logic [bW-1:0] fibnum
);

   logic [bW-1:0] 	next_one, next_two, one;
   logic [bW-1:0] 	two;

   assign next_one = rst ? two + 1'b1 : two;
   assign next_two = one + two;

   
   dff #(bW) dffone(.d(next_one), .clk(clk), .rst(rst), .en(1'b1), .q(one));
   
   dff #(bW) dfftwo(.d(next_two), .clk(clk), .rst(rst), .en(1'b1), .q(two));
   
   assign fibnum = one;

endmodule
