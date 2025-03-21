
/*
 *
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
 *
 * This module is an FIR filter. (finite inpulse response) 
 * It implement the function:
 *  y sub i  =  sum (from k=0 to k=N) t sub k times x sub i-k
 *  For your design, let t sub k = 1/8 and use a history count of 5.
 *  In other words, in any given cycle, output the
 *  sum of the previous five cycles divided by 8.
 *  For the first 4 clocks when there are fewer than 5 values, assume
 *  zeros for the missing values.
 *
 */
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
