# Tests xori function specifically
# Return value should be 42 in register $t3: The answer to life, the universe, and everything

# Pseudocode
# a = 11
# b = 10
# c = 101
# if (a != c):
# 	a = a + 10
# else:
#	xori a with 79
# $t3 should equal 42 in decimal, 2a in hex

addi $t0, $zero, 11
addi $t1, $zero, 10
addi $t2, $zero, 101

MAIN:
bne $t0, $t2, KEEP_ADDING
xori $t3, $t0, 79
j END

KEEP_ADDING:
add $t0, $t0, $t1
j MAIN

END:
j END




