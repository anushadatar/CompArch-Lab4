# compute 3*n by doing n+n+n

li $t1, 4
nop
nop
nop
nop
sub $t2,$t1,$t1 # add 4+4
nop
nop
nop
nop
add $a0,$t2,$t1 # add the third 4
