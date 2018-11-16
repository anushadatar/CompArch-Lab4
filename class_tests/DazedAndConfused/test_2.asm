# Modify the elements in an array
# Tests lw, slt, sw specifically

# Preconditions: 
#    Array base address stored in register $t0
#    Array size (# of words) stored in register $t1
la 	$t0, my_array		# Store array base address in register (la pseudoinstruction)
addi	$t1, $zero, 8		# 16 elements in array

# Initialize variables
addi	$t2, $zero, 0		# i, the current array element being accessed
addi	$t3, $t0, 0		# address of my_array[i] (starts from base address for i=0)
addi	$t4, $zero, 10
addi	$t7, $zero, 4

# Python Pseudocode:
#a = [1,3,5,7,9,11,13,15]
#for i in range(len(a)):
#    a[i] += 6
#    if a[i] < 10:
#        a[i] -= 4
#    else:
#        a[i] = a[i] + 7


LOOPSTART:
beq $t2, $t1, LOOPEND

lw $t5, 0($t3)
addi $t5, $t5, 6
slt $t6, $t5, $t4 # if $t5 < $t4, $t6 = 0
beq $t6, $zero, ELSE
sub $t5, $t5, $t7
j CONTINUE_LOOP

CONTINUE_LOOP:
sw $t5, 0($t3)
addi $t2, $t2, 1
addi $t3, $t3, 4
j LOOPSTART

ELSE:
addi $t5, $t5, 7
j CONTINUE_LOOP

LOOPEND:
j LOOPEND



# Pre-populate array data in memory
.data
my_array: # my_array[0]
0x00000001
0x00000003	
0x00000005
0x00000007
0x00000009
0x0000000b
0x0000000d
0x0000000f