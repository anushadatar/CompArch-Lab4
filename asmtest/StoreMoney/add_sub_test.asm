# Loads values into $t1 and $t2, adds them together then subtracts an immediate from the result

addi $t1,$zero,100
addi $t2,$zero,100

add $t3,$t1,$t2

subi $t0,$t3,50


  
