# test to check jump and branch

start:
	li $t1,10
	li $t2,20
	j do_work

branch:
	bne $t1,$t2,make_equal
	j end

do_work:
	addi $t1,$t1,5
	j branch

make_equal:
	li $t1,10
	li $t2,10
	j branch

end:
	j end
