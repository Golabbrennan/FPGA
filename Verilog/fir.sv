//Finite Impulse Response
module fir
#(
  bW=8,
  hC=5
 )
(
  input  logic [bW-1:0] x,
  output logic [bW-1:0] y,
  input  logic clk,
  input  logic rst
);

   logic [bW-1:0] din0, din1, din2, din3, din4, dout0, dout1, dout2, dout3, dout4;
   
   logic [2:0] count;
   counter13 #(5) myCounter(.inc(1'b1), .dec(1'b0), .clk(clk), .rst(rst), .cnt(count));


   assign din0 = count == 3'd0 ? x : dout0;
   assign din1 = count == 3'd1 ? x : dout1;
   assign din2 = count == 3'd2 ? x : dout2;
   assign din3 = count == 3'd3 ? x : dout3;
   assign din4 = count == 3'd4 ? x : dout4;

   logic [bW+2:0] total;
   
   assign total = (dout0 + dout1 + dout2 + dout3 + dout4);
   assign y =  total[2+bW:3];
   

   
   dff #(bW) my_dff0(.d(din0), .clk(clk) ,.en(1'b1), .rst(rst), .q(dout0));
   dff #(bW) my_dff1(.d(din1), .clk(clk) ,.en(1'b1), .rst(rst), .q(dout1));
   dff #(bW) my_dff2(.d(din2), .clk(clk) ,.en(1'b1), .rst(rst), .q(dout2));
   dff #(bW) my_dff3(.d(din3), .clk(clk) ,.en(1'b1), .rst(rst), .q(dout3));
   dff #(bW) my_dff4(.d(din4), .clk(clk) ,.en(1'b1), .rst(rst), .q(dout4));
   

   
endmodule //fir
