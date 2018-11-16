# Test beq and jump and link

addi $t0,$zero,119
addi $t1,$zero,101
addi $t2,$zero,101
addi $t3,$zero,116

beq $t1,$t2,JUMPHERE
  j PLEASESTOP
  
LIMK:
  addi $t3,$t3,1
  jr $ra
  
JUMPHERE:
  jal LIMK
  
addi $t3,$t3,1

PLEASESTOP:

  

