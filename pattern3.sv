
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
 * detect the pattern 1 0 0 1
 * allow the pattern to overlap
 *
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

