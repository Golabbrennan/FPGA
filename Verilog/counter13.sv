/*
 * a modulo 13 up/down counter
 * (i..e. when going up, counts 0,1,2...12, 0, 1, 2, 3)
 * 
 */

module counter13
  #(
    parameter int m=13,  // Maximum
    parameter int b=$clog2(m)  // Bitwidth 
    )
   (
    input  logic         inc,
    input  logic         dec,
   
    input  logic         clk,
    input  logic         rst,

    output logic [b-1:0] cnt 
    );
   
   logic [b-1:0] next;
   dff #(b) mydff(.d(next), .rst(rst), .en(1'b1), .clk(clk), .q(cnt));
   
   
   always_comb begin
      unique case (1'b1)
	(inc && !dec) : next = (cnt == m-1) ? '0  : cnt + 1'b1;
	(dec && !inc) : next = (cnt == '0)  ? m-1 : cnt - 1'b1;
	default:        next = cnt;
      endcase
   end
endmodule 
