
/*
 1;95;0c*
 *  EEE 333 Fall 2024 Final Exam.  Due 23:59 December 6, 2024.
 *
 * This is your EEE 333 Final Exam and this submission should
 * represent your individual work. You should not discuss the exam
 * or its solutions with other students.
 * The use of ChatGPT, other AI resources, or on-line information is NOT acceptable.
 *
 * Resources you may may utilize include your prior homework submissions, labs,
 * lecture notes, and textbook.  You may also seek clarification for exam
 * questions on EdDiscussion, in class, or in office hours.
 *
 * You are encouraged to take verification code provided to you by the instructor
 * this semester and use with your final exam.
 *
 * The penalty for any violation of the honor code, may include a referral to
 * ECEE for an ethics violation and a zero in the course.
 *
 * You may submit your exam multiple times.  However, you are limited
 * to 15 submissions.  Your best score from those first 15 submissions
 * is what will be recorded.  Problems solved after those 15 submissions
 * will be ignored.
 *
 */



/*
 * Build a sequential multiplier that takes two bW width numbers a and b and
 * produces the 2*bW number prod, the product of a and b.
 * Your sequential multiplier may have registers, a counter, an adder,
 * and shifters.
 * YOU MAY NOT USE the * operator to get verilog to produce a product for you!
 *
 * You should use an ab_rdy/ab_vld handshake to obtain the factors a and b
 * similar to how you obtained d values in the integrator project. (from HW5)
 * You communicate the product back to the top file using p_rdy/p_vld, just
 * as you communicated the integrator sum.
 *
 * The value for bW is specified by the top file.  Be aware that the grader
 * top file may use a different value for bW, so your verilog code should
 * not make any assumptions about the value of bW, and should work for
 * any value of bW > 2.
 *
 * If you use an *, I will chnage your score on the assignment to a 0.
 * That is, the grader does not check, but I will do a check after the due date.
 * NO CREDIT if you use *, even if the grader told you it was OK.
 *
 */
//seqmu2.vp

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
