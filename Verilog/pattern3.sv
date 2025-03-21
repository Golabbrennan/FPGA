/*
 * detect the pattern 1 0 0 1
 * allow the pattern to overlap
 */

module pattern3

(
    input logic a,
    input logic clk,
    input logic rst,
    output logic z
);

   typedef enum  logic [2:0] {S0 = 3'b000,S1, S2, S3, S4} states;

   states s, next;

   logic [2:0] 	 also_s;

   assign s = states'(also_s);

   assign z = (s == S4);

   
   dff #(3) mydff(.d(next), .clk(clk), .rst(rst), .en(1'b1), .q(also_s));

   
   
   always_comb begin
      unique case(s)
	S0 : next = a ? S1 : S0;
	S1 : next = a ? S1 : S2;
	S2 : next = a ? S1 : S3;
	S3 : next = a ? S4 : S0;
	S4 : next = a ? S1 : S2;
	default: next = s;
      endcase // unique case (s)
         end

endmodule

