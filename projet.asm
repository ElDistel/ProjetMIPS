.data
numeroCarte: .space 20
successMessage: .asciiz "\nLe numero est valide!\n"
failMessage: .asciiz "\nLe numero n'est pas valide!\n"
.text

# lire numero de carte (test: 376701449043032)
li $v0, 8
la $a0, numeroCarte
li $a1, 20
#move $t5, $a0
syscall

# afficher numero de carte
la $a0,numeroCarte
li $v0,4
syscall

# somme
li $t0, 0 # somme
#li $t1, 14 # nombre d'iterations
li $t1, 13 # compteur i (commence a 14)
li $t2, 9 # 9
li $t3, 0 #compteur a
li $t4, 2 #mod 2
loop:
   blt $t1, $zero, check
   #li $s0, 4 #iterator
   la $a1, numeroCarte
   addu $a1,$a1,$t1  # $a1 = &str[x].  assumes x is in $t0
   lbu $t5,($a1)      # read the character
   
   # afficher caractere
   #move $a0, $t5
   #li $v0,11
   #syscall
   
   # le caractere est en ascii, on soustrait alors -48 (position du 0)
   addi $t5, $t5, -48
   
   div $t3, $t4 # a % 2
   mfhi $s0 # recuperer le mod dans le hi register et le stocker dans $s0
   
   beq $s0, $zero, modVal # i % 2 == 0

   j loop_end

loop_end:

   bgt $t5, $t2, subVal # si valeur > 9
   
   add $t0, $t0, $t5 # ajouter a la somme
   # add
   addi $t1, $t1, -1 # i--
   addi $t3, $t3, 1 # a++
   j loop
   
modVal:
   #add $s0, $zero, $t5
   #addi $s0, $zero, 2
   mul $t5, $t5, $t4 # multiplier par 2
   j loop_end

subVal:
   sub $t5,$t5,$t2
   j loop_end # valeur max est 18 - 9 = 9 donc beq ne sera plus execute


check:
   addi $s1, $zero, 10
   div $t0, $s1 # somme % 10
   mfhi $s0 # recuperer le mod dans le hi register et le stocker dans $s0
   sub $t0, $s1, $s0
      
   # on recupere la derniere valeur de la carte (max + 1)
   addi $t4, $zero, 14
   la $a1, numeroCarte
   addu $a1,$a1,$t4  # $a1 = &str[x].  assumes x is in $t0
   lbu $t5,($a1)
   
   # le caractere est en ascii, on soustrait alors -48 (position du 0)
   addi $t5, $t5, -48
  
   # check result
   li $v0, 4
   
   beq $t0, $t5, checkSuccess ## si resultat = dernier chiffre carte bancaire
   
   la $a0, failMessage
   syscall
   
   j end
   
checkSuccess:
   la $a0, successMessage
   syscall
   
   j end
   
end:
    li $v0,10
    syscall

