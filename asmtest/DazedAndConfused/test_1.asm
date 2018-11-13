# Tests several instructions, including addi, beq, sub, jal, j, add, jr

# Pseudo Code
# a = 15
# b = 26
# c = 18
# while (a != c) {
# 	c = c - 1
# 	b = b + a
# }
# d = b - a
# $t0 should end as f
# $t1 should end as 47
# $t2 should end as f
# $t3 should end as 1
# $t4 should end as 38

addi $t0, $zero, 15
addi $t1, $zero, 26
addi $t2, $zero, 18
addi $t3, $zero, 1

LOOPSTART:
beq $t0, $t2, SUB
sub $t2, $t2, $t3
jal ADD
j LOOPSTART


SUB:
sub $t4, $t1, $t0
j END_PROGRAM

ADD:
add $t1, $t1, $t0 
jr $ra

END_PROGRAM:
j END_PROGRAM