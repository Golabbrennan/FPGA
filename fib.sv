
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


//
// produce the Fibonacci sequence: 1,1,2,3,5,8,13,21,34,...
// the values must be correct up to the limits of the given bitwidth (bW)
// Your module must work correctly for arbitrary bitwidths.
//
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
   //1 1 2 3 5 8 13
   //(0, 1), (1,1), (1,2), (2,3) (3,5), (5,8)
   // 1  2    1 2    1 2    1 2   1 2    1 2
endmodule
