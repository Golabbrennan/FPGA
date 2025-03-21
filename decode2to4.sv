
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
 * design a module named: decode2to4
 *
 * this module takes a 2 bit input named a (lower case letter a)
 * and gives a 4 bit output named z (lower case letter z)
 *
 * the output is described by the following table:
 *
 *  0  ->  1
 *  1  ->  2
 *  2  ->  4
 *  3  ->  8
 *
 */

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


