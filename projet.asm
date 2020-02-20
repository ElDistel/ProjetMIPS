.data
numeroCarte: .space 20
.text

# lire numero de carte
li $v0, 8
la $a0, numeroCarte
li $a1, 20
move $t5, $a0
syscall

# afficher numero de carte
la $a0,numeroCarte
li $v0,4
syscall

# somme
li $t0, 0 # somme
#li $t1, 14 # nombre d'iterations
li $t1, 3 # compteur i (commence a 14)
li $t2, 0 # nombre min
li $t3, 0 #compteur a

loop:
   beq $t1, $t2, affiche
   #li $s0, 4 #iterator
   la $a1, numeroCarte
   addu $a1,$a1,$t3  # $a1 = &str[x].  assumes x is in $t0
   lbu $t4,($a1)      # read the character
   
   # afficher caractere
   #move $a0, $t4
   #li $v0,11
   #syscall
   
   # le caractere est en ascii, on soustrait alors -48 (position du 0)
   addi $t4, $t4, -48
   add $t0, $t0, $t4
   # add
   addi $t1, $t1, -1 # i--
   addi $t3, $t3, 1 # a++
   j loop
affiche:
    li $v0, 1
    move $a0, $t0
    syscall
    li $v0,10
    syscall

#.lcall oop
#beq ,,end
#j loop
#end:

