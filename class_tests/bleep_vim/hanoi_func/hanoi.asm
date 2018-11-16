# Function call test: recursive Tower of Hanoi problem
addi $sp, $zero, 0x3ffc
main:
# Set up arguments for call to hanoi_test
addi  $a0, $zero, 4	# arg0 = 4
addi  $a1, $zero, 8	# arg1 = 8
jal   hanoi_test

# Jump to "exit", rather than falling through to subroutines
j     program_end

#------------------------------------------------------------------------------
# Hanoi test function. Equivalent C code:
#     int hanoi_test(arg0, arg1) {
#         return hanoi(arg0) + hanoi(arg1);
#     }
# By MIPS calling convention, expects arguments in
# registers a0 and a1, and returns result in register v0.
hanoi_test:
# We will use s0 and s1 registers in this function, plus the ra register
# to return at the end. Save them to stack in case caller was using them.
addi  $sp, $sp, -12	# Allocate three words on stack at once for three pushes
sw    $ra, 8($sp)	# Push ra on the stack (will be overwritten by hanoi function calls)
sw    $s0, 4($sp)	# Push s0 onto stack
sw    $s1, 0($sp)	# Push s1 onto stack

# a1 may be overwritten by called functions, so save it to s1 (saved temporary),
# which called function won't change, so we can use it later for the second hanoi call
add  $s1, $zero, $a1

# Call hanoi(arg0), save result in s0
# arg0 is already in register a0, placed there by caller of hanoi_test
jal   hanoi		# Call hanoi(4), returns in register v0
add   $s0, $zero, $v0	# Move result to s0 so we can call hanoi again without overwriting

# Call hanoi(arg1), save result in s1
add   $a0, $zero, $s1	# Move original arg1 into register a0 for function call
jal   hanoi
add   $s1, $zero, $v0	# Move result to s1

# Add hanoi(arg0) and hanoi(arg1) into v0 (return value for hanoi_test)
add   $v0, $s0, $s1

# Restore original values to s0 and s1 registers from stack before returning
lw    $s1, 0($sp)	# Pop s1 from stack
lw    $s0, 4($sp)	# Pop s0 from stack
lw    $ra, 8($sp)	# Pop ra from the stack so we can return to caller
addi  $sp, $sp, 12	# Adjust stack pointer to reflect pops

jr    $ra		# Return to caller

#------------------------------------------------------------------------------
# Recursive Hanoi function:
#
#     int hanoi(int n) {
#         if (n == 1) return 1;  // Base case
#         int hanoi_1 = Hanoi(n - 1);
#         return 2*hanoi_1+1;
#     }
hanoi:
# Test base case. If we're in a base case, return directly (no need to use stack)
bne   $a0, 1, hanoi_body
addi   $v0, $zero,1	# a0 == 0 -> return 0
jr    $ra

hanoi_body:
# Create stack frame for hanoi: push ra and s0
addi  $sp, $sp, -8	# Allocate two words on stack at once for two pushes
sw    $ra, 4($sp)	# Push ra on the stack (will be overwritten by recursive function calls)
sw    $s0, 0($sp)	# Push s0 onto stack

# Call hanoi(n-1), save result in s0
add   $s0, $zero, $a0	# Save a0 argument (n) in register s0
addi  $a0, $a0, -1	# a0 = n-1
jal   hanoi
add   $s0, $v0, $v0     # s0 = 2 * hanoi(n-1)
addi  $v0, $s0, 1       # s0 = 2 * hanoi(n-1) + 1

# Restore registers and pop stack frame
lw    $ra, 4($sp)
lw    $s0, 0($sp)
addi  $sp, $sp, 8

jr    $ra	# Return to caller


#------------------------------------------------------------------------------
# Jump loop to end execution, so we don't fall through to .data section
program_end:
j    program_end
