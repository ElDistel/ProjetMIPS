.data
numeroCarte: .space 20
.text
li $v0, 8
la $a0, numeroCarte
li $a1, 20
move $t0, $a0
syscall

la $a0,numeroCarte
li $v0,4
syscall

#.lcall oop
#beq ,,end
#j loop
#end:

