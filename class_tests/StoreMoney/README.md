We have created two assembly tests - one to test basic addition and subtraction functionality, and one to test storing immediates, branching, and jump and link.

* <b> add_sub_test</b>

Expected Results:
This test adds the value 100 to registers $t1 and $t2 and then adds the contents of $t1 and $t2 to $t3. This yields the value 200 in $t3. 
Then, it subtracts the value 50 from $t3 and stores the value in $t0. Then, the value in $t0 should be equal to 150. 

Methods tested:
This test verifies the functionality of addi, subi, and add.

* <b> yeet </b>

Expected results:
This test adds decimal values to registers $t0, $t1, $t2, and $t3 such that $t0 equals 119, $t1 and $t2 equal 101, and $t3 equal 116. Then, it checks if the registers $t1 and $t2 hold equal values -
as the characters (almost) spell out the word "yeet," they are of course equal. Then, it adds one to the value at $t3, jumps back, and 
adds one to $t3 again, so the total value at $t0 is equal to 121 and the other registers hold their original states.

Methods tested:
This test verifies the functionality of addi, beq, j, jr, and jal.
