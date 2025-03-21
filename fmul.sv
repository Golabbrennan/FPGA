
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
 * fmul-- implement a single precision floating point multiply
 *       assume input numbers are IEEE format
 *       You many assume inpts will not be denormals, NANs, or INFIN,
 *       You many assume output will not be overflow or denormal
 *       Implement truncate style rounding. 
 *
 *       When result is zero, proper sign must be maintained.
 *       That is, zero can be plus zero (+0) or minus zero (-0).
 *       (e.g. +0 * negative = -0, -0 * 0 = -0, etc.)
 *
 * IEEE single format is 1 bit sign bit
 *                       8 bit exponent in excess 127
 *                       23 bit fractional mantissa
 *              value is  -1^s * 1.m * 2^(e-127)
 *                (where  a^b means a raised to the b power)
 */

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
