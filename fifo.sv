
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
 * FIFO  (first in, first out)
 * this problem is similar to the LIFO hardware you designed earlier
 * in the semester.  However, you "push" new data in, and you "pop"
 * off the oldest data that you have.  That is, the first thing you put
 * in is the first thing to take out.  
 * More properly, this is a queue, not a stack.
 *
 * You may assume that you will never be asked to add items to a full queue,
 * or to remove items from an empty queue.
 *
 * Hint: you will probably want to maintain three counters.  One pointing
 * to the place where you add data, one pointing to the place you remove data
 * and one indicating how many items there are in the memory.
 */


module fifo  #( 
                parameter int bW ,
                parameter int eC ,
		parameter int ptrW = $clog2(eC),
		parameter int cntW = $clog2(eC+1) 
              )
              ( 
                // push interface 
                input  logic [bW-1:0] pushData,
                input  logic          push,
                output logic          full,
                // pop interface
                output logic [bW-1:0] popData,
                input  logic          pop,
                output logic          empty,
                // Globals
                input logic           clk,
                input logic           rst
		);
   
   
   logic [$clog2(eC)-1:0] popAddr, pushAddr, itemsCnt;


   counter13 #(eC) pushCounter(.inc(push && !full), .dec(1'b0), .clk(clk), .rst(rst), .cnt(pushAddr));
   counter13 #(eC) popCounter(.inc(pop && !empty), .dec(1'b0), .clk(clk), .rst(rst), .cnt(popAddr));
   counter13 #(eC + 1) itemsCounter(.inc(push && !full), .dec(pop && !empty), .clk(clk), .rst(rst), .cnt(itemsCnt));
   
   assign full = (itemsCnt == eC);
   assign empty = (itemsCnt == '0);
   

   memory #(bW,eC) mymem( .readAddr (popAddr),
		          .writeAddr(pushAddr),
		          .writeData(pushData),
		          .writeEn  (push && !full),
		          .readData (popData),
		          .clk      (clk)
                        );

   
   
endmodule
