//Floating point multiplier

module fmul
(
  input  logic [31:0] a,
  input  logic [31:0] b,
  output logic [31:0] z
);
   logic 	      as, bs;
   logic [7:0] 	      ae, be;
   logic [22:0]       fa, fb;
   logic [47:0]       out;
   logic [8:0] 	      test;
   
   assign z[31]       = a[31] ^ b[31];
   
   assign {as, ae, fa} = a;
   assign {bs, be, fb} = b;
   assign z[30:23] = test[7:0];
   assign z[22:0] = out[47] == 1'b1 ? out[46:24] : out[45:23];
   
   assign test = ((a[30:0] == '0) || (b[30:0] == '0)) ? '0 : out[47] == 1'b1 ? ae + be - 8'd126 : ae + be - 8'd127;
   
   assign out = {1'b1, fa} * {1'b1, fb}; //fa == '0 ? fb == '0 ? fa * fb;
   
endmodule
