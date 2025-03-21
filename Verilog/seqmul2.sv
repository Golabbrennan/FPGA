
module seqmul2
#(
    parameter int bW
 )
 (  input  logic [bW-1:0]    a,
    input  logic [bW-1:0]    b,
    input  logic             ab_vld, //ab is valid
    output logic             ab_rdy, //rdy for ab
     
    output logic [bW+bW-1:0] prod,
    output logic             p_vld, //product is valid
    input  logic             p_rdy, //rdy for product

    input  logic             clk,
    input  logic             rst 
 );

   logic [$clog2(bW)-1:0]    cnt;
   logic [bW-1:0] 	     next_a, next_b, aout, bout;
   logic [bW+bW-1:0] 	     next_prod;
   
   logic [bW+bW-1:0] 	     t_prod;
   
   
   counter13 #(bW + 1) counter(.inc((ab_vld && ab_rdy) || (!ab_rdy && !p_vld) || (p_vld && p_rdy)) ,.dec(1'b0), .clk(clk), .rst(rst), .cnt(cnt)); //CHECK LATER IF RIGHT
   
   
   dff #(bW) dffa(.d(a), .clk(clk), .en(ab_vld && ab_rdy), .rst(rst), .q(aout));
   dff #(bW) dffb(.d(b), .clk(clk), .en(ab_vld && ab_rdy), .rst(rst), .q(bout));

   always_comb begin
      unique case (1'b1)
	(ab_rdy && ab_vld) : next_a = a;
	default : next_a = aout;
      endcase // unique case (1'b1)
   end

   always_comb begin
      unique case (1'b1)
	(ab_rdy && ab_vld) : next_b = b;
	default : next_b = bout;
      endcase // unique case (1'b1)
   end

   dff #(bW + bW) proddff(.d(next_prod), .clk(clk), .rst(rst), .en(1'b1), .q(t_prod));
   
   always_comb begin
      unique case (1'b1)
	(ab_rdy && ab_vld) : next_prod = next_b[cnt] ? (next_a << cnt) : '0;
	p_vld : next_prod = t_prod;
	default : next_prod = bout[cnt] ? t_prod + (aout << cnt) : t_prod;
      endcase // unique case (1'b1)
   end

   assign ab_rdy = (cnt == '0);
   
   assign p_vld = (cnt == bW);

   assign prod = t_prod;
   

endmodule
