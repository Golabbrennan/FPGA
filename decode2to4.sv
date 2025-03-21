

module decode2to4
(
  input  logic [1:0] a,
  output logic [3:0] z
);
   always_comb begin
      unique case (a)
	2'd0 : z = 4'd1;
	2'd1 : z = 4'd2;
	2'd2 : z = 4'd4;
	2'd3 : z = 4'd8;
	default : z = '0;
      endcase // unique case (a)
   end
   
endmodule


