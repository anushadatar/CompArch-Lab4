# Assembly Test Cases
For our test cases, we attempted to test the functionality of all of the instructions our CPU should be able to handle.

### Test Case 1
This tests a variety of instructions, including addi, beq, sub, jal, j, add, jr. It consists of a while loop and modifies elements accordingly. When it finishes running, the following registers should contain the corresponding values:
$t0 -> 0x0000000f
$t1 -> 0x00000047
$t2 -> 0x0000000f
$t3 -> 0x00000001
$t4 -> 0x00000038

### Test Case 2
This tests how our CPU handles arrays. It specifically targets the lw, slt, and sw instructions. It takes in an array and modifies each element of the array accordingly. It consists of a for loop and a nested if-else statement. Additionally, it makes use of the pseudocode la instructions and assumes the CPU is able to load data from the .data section of the assembly code. When it finishes running, the array should contain the following elements:
0x00000003
0x00000005
0x00000012
0x00000014
0x00000016
0x00000018
0x0000001a
0x0000001c

### Test Case 3
This test case specifically targets the xori and bne instruction. It consists of an if-else statement and should result in the decimal value 42 (The answer to life, the universe, and everything!), or 2a in hexadecimal, in register $t3.
