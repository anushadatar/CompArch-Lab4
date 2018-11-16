li $t0, 10
li $sp, 0x00003ffc

Main:
	add $a0, $t0, $zero
	jal Fibonacci
	add $a0, $zero, $zero
	j end



Fibonacci:
	beq $a0, $zero, return_zero
	beq $a0, 1, return_one
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	addi $a0, $a0, -1 # Calculate n-1
	addi $sp, $sp, -4
	sw $a0, 0($sp)    # Store n-1 to .data
	jal Fibonacci
	lw $a0, 0($sp) # Read n-1 from .data
	sw $v0, 0($sp) # replace at the address of n-1 the result of F(n-1)
	addi $a0, $a0, -1 # Calculate n-2
	jal Fibonacci
	lw $t0, 0($sp)    # Load F(n-1) to $t0
	addi $sp, $sp, 4
	add $v0, $v0, $t0
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

return_zero:
	add $v0, $zero, $zero
	jr $ra

return_one:
	addi $v0, $zero, 1
	jr $ra

end:
	j end