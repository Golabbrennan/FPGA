
//integrator

module integrator
#(
    parameter int bW = 8 ,
    parameter int sW = 16 ,
    parameter int eC = 8,
    parameter int aW = $clog2(eC+1)
 )
 (  input  logic [bW-1:0] d,
    input  logic          d_vld, //d is valid
    output logic          d_rdy, //rdy for d
     
    output logic [sW-1:0] sum,
    output logic          sum_vld, //sum is valid
    input  logic          sum_rdy, //rdy for sum

    input  logic          clk,
    input  logic          rst 
 );

   logic [3:0] cnt;
   counter13 #(eC+1) counter(.inc((d_vld && d_rdy) || (sum_rdy && sum_vld)), .dec(1'b0), .clk(clk), .rst(rst), .cnt(cnt));
   assign sum_vld = cnt == 4'd8;
   assign d_rdy = cnt != 4'd8;

   logic [sW-1:0] nextSum;
   
   dff #(sW) mydff(.d(nextSum), .clk(clk), .rst(rst), .en(1'b1), .q(sum));
   
   always_comb begin
      unique case(1'b1)
	(d_vld && d_rdy) : nextSum = sum + d;
	(sum_vld && sum_rdy) : nextSum = '0;
	default : nextSum = sum;
      endcase
   end

endmodule
