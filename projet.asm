.data

	hello: .asciiz 		"\nBienvenue !\n"
	msgChoix: .asciiz 	"\nTapez 1: saisir un numero de carte bancaire pour en verifier la validite\nTapez 2: Affichage d'un numero valide\nTapez 3: Quitter le programme\n\n>>>> "
	choixCarte: .asciiz	"Choisissez quel type de carte vous voulez :\n1- American Express\n2- Diners Club\n3- Discover\n4- InstaPayment\n5- JCB\n6- Maestro\n7- MasterCard\n8- VISA\n9- VISA Electron\n>>>>"
	msgReChoisir: .asciiz 	"\nChiffre saisi incorrect, \nVeuillez choisir parmis les propositions presentees\n"
	espace: .asciiz 	"\n\n"
	
	temp1: .asciiz		"\nVous avez choisit le choix numero 1\n\n"
	temp2: .asciiz		"\nVous avez choisit le choix numero 2\n\n"
	temp3: .asciiz		"\nVous avez choisit de sortir\n"
	
	choixCarte1: .asciiz	"\nVous avez choisis le type de carte American Express\n\n>>>>"
	choixCarte2: .asciiz	"\nVous avez choisis le type de carte Diners Club\n\n>>>>"
	choixCarte3: .asciiz	"\nVous avez choisis le type de carte Discover \n\n>>>>"
	choixCarte4: .asciiz	"\nVous avez choisis le type de carte InstaPayment\n\n>>>>"
	choixCarte5: .asciiz	"\nVous avez choisis le type de carte JCB\n\n>>>>"
	choixCarte6: .asciiz	"\nVous avez choisis le type de carte Maestro\n\n>>>>"
	choixCarte7: .asciiz	"\nVous avez choisis le type de carte MasterCard\n\n>>>>"
	choixCarte8: .asciiz	"\nVous avez choisis le type de carte VISA\n\n>>>>"
	choixCarte9: .asciiz	"\nVous avez choisis le type de carte VISA Electron\n\n>>>>"
  
	numeroCarte: .space 20
  	successMessage: .asciiz "\nLe numero est valide!\n"
  	failMessage: .asciiz "\nLe numero n'est pas valide!\n"
  	
  	
.text


# Entree dans le programme
li $v0 4
la $a0 hello
syscall

menu:
	# presentation des options
	li $v0 4
	la $a0 msgChoix
	syscall
	
	# Choix du service par l'utilisateur enregistre dans une variable non temporaire
	li $v0 5
	syscall
	move $s0 $v0

	# Branch au service correspondant au numero entre
	beq $s0 1 choix1
	beq $s0 2 choix2
	beq $s0 3 choix3
	
	# Message d'erreur si le chiffre saisit est different de 1, 2 ou 3
	li $v0 4
	la $a0 msgReChoisir
	syscall
	
	# retour au menu tant qu'une valeur valide n'est pas saisit
	b menu
	
#------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------

choix1:
	# service numero 1

 	# lire numero de carte (test: 376701449043032)
	li $v0, 8
	la $a0, numeroCarte
	li $a1, 20
	syscall


	# somme
	li $t0, 0 			# somme
	li $t1, 0			# compteur i (commence a 14)
	li $t2, 9 			# 9
	li $t3, 0 			#compteur a
	li $t4, 2 			#mod 2
  
	j longueur 			# longueur du numero


longueur:				# lire la longueur du numero
	la $a0, numeroCarte
	addi $t0, $zero, -1 		# -1 pour normaliser
	jal longueur.loop
	

longueur.loop:
	lb $t5, 0($a0) 			#charger le caractere a $a0
	beqz $t5, calcul 		#si on atteint le caractere null continuer la boucle

	addi $a0, $a0, 1 		#incrementer la position du pointeur
	addi $t0, $t0, 1 		#incrementer le compteur

	j longueur.loop 		# on continue comme on a trouve la longueur
	

calcul:
	addi $t1, $t0, -2 		# comme on ne veut pas inclure le derniere chiffre de la carte, on soustrait 1 a la longueur 
	add $s4, $zero, $t1 		# sauvegarder la valeur pour l'utiliser a la fin
	addi $t0, $zero, 0 
   
	j calcul.loop


calcul.loop:
	blt $t1, $zero, check
	la $a1, numeroCarte
	addu $a1,$a1,$t1  		# $a1 = &str[x]. x est dans $t0
	lbu $t5,($a1)     		# lire le caractere
   
	addi $t5, $t5, -48		# le caractere est en ascii, on soustrait alors -48 (position du 0)
   
	div $t3, $t4 			# a % 2
	mfhi $s0 			# recuperer le mod dans le hi register et le stocker dans $s0
   
	beq $s0, $zero, modVal 		# i % 2 == 0

   	j loop_end



loop_end:

	bgt $t5, $t2, subVal 		# si valeur > 9
   
	add $t0, $t0, $t5		# ajouter a la somme
	addi $t1, $t1, -1 		# i--
	addi $t3, $t3, 1 		# a++
   	j calcul.loop
   	
   	
   
modVal:
   	mul $t5, $t5, $t4 		# multiplier par 2
   	j loop_end


subVal:
   	sub $t5,$t5,$t2
   	j loop_end 			# valeur max est 18 - 9 = 9 donc beq ne sera plus execute

check:
   	addi $s1, $zero, 10
   	div $t0, $s1 			# somme % 10
   	mfhi $s0 			# recuperer le mod dans le hi register et le stocker dans $s0
   	sub $t0, $s1, $s0
      
   	# on recupere la derniere valeur de la carte (max + 1)
   	addi $s4, $s4, 1 		# ajouter 1 car on cherche la derniere valeur
   	add $t4, $zero, $s4
   
   	la $a1, numeroCarte
   	addu $a1,$a1,$t4  		# $a1 = &str[x].  assumes x is in $t0
	lbu $t5,($a1)
   
   	
   	addi $t5, $t5, -48		# le caractere est en ascii, on soustrait alors -48 (position du 0)
  
   	# check result
   	li $v0, 4
   
   	beq $t0, $t5, checkSuccess 	# si resultat = dernier chiffre carte bancaire
   
   	la $a0, failMessage
   	syscall
   
   	j end
   	
   
checkSuccess:
   	la $a0, successMessage
   	syscall
   
   	j end
   
end:
   	b menu

#------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------


#$t2 est la variable aleatoire 

#$t3 est la variable faisant office de verificateur pour chiffre pair ou impair

#$t5 est la longueur du code de carte a generer

#$t8 est le dernier chiffre du code de carte calcule initialise a  10

#$t9 est la somme de tous les chiffres


choix2:
	# service numero 2	
	li $v0 4
	la $a0 temp2
	syscall

	li $t2 0
	li $t3 1
	li $t5 15
	li $t8 10
	li $t9 0
	
	li $v0 4
	la $a0 choixCarte
	syscall
	
	j verifCarte
	
	
verifCarte:	
	li $v0 5		# Choix du service par l'utilisateur du type de carte souhaite
	syscall
	move $s1 $v0

	beq $s1 1 Carte1	# Branch au service correspondant a la carte
	beq $s1 2 Carte2
	beq $s1 3 Carte3
	beq $s1 4 Carte4
	beq $s1 5 Carte5
	beq $s1 6 Carte6
	beq $s1 7 Carte7
	beq $s1 8 Carte8
	beq $s1 9 Carte9
	
	li $v0 4
	la $a0 msgReChoisir
	syscall
	
	j verifCarte
	
	
loop:
	beq $t5 $zero finLoop
	
	li $a1, 9		#sequence pour generer un nombre aleatoire
    	li $v0, 42  
    	syscall
	add $a0, $a0, 1  
    	
    	li $v0, 1
	syscall
	
	move $t2 $a0
	
	beq $t3 1 chiffreImpair
	beq $t3 2 chiffrePaire
	
	

sommeLoop:
	add $t9 $t9 $t2		#somme de tous les entiers aleatoires
	
	sub $t5 $t5 1
	j loop
	
	


finLoop:

	bgt $t9 9 modSomme

	sub $t8 $t8 $t9
	
	li $v0 1
	move $a0 $t8
	syscall
	
	li $v0 4
	la $a0 espace
	syscall
	
	j menu
	


chiffreImpair:
	mul $t2 $t2 2
	bgt $t2 9 moinsNeuf	#si $t2 est superieur a 9
	addi $t3 $t3 1		#on ajoute 1 pour que le chiffre suivant soit compte comme impair, et au tour d'apres $t1 vaudra a  nouveau 1
	j sommeLoop
	
	
moinsNeuf:
	subi $t2 $t2 9
	addi $t3 $t3 1		#on ajoute 1 pour que le chiffre suivant soit compte comme impair, et au tour d'apres $t1 vaudra a  nouveau 1
	j sommeLoop
	


chiffrePaire:
	subi $t3 $t3 1
	j sommeLoop


modSomme:			#boucles pour faire le modulo de la derniere valeur
	bgt $t9 9 modSommeBis
	j finLoop
	
	
modSommeBis:
	subi $t9 $t9 10
	j modSomme
	
	
#######################################################
### CHOIX DES CARTES
#######################################################	

Carte1:
	li $v0 4
	la $a0 choixCarte1
	syscall 
	j loop
	
Carte2:
	li $v0 4
	la $a0 choixCarte2
	syscall 
	j loop
	
Carte3:
	li $v0 4
	la $a0 choixCarte3
	syscall 
	j loop
	
Carte4:
	li $v0 4
	la $a0 choixCarte4
	syscall 
	j loop
	
Carte5:
	li $v0 4
	la $a0 choixCarte5
	syscall 
	j loop
	
Carte6:
	li $v0 4
	la $a0 choixCarte6
	syscall 
	j loop
	
Carte7:
	li $v0 4
	la $a0 choixCarte7
	syscall 
	j loop

Carte8:
	li $v0 4
	la $a0 choixCarte8
	syscall 
	j loop
	
Carte9:
	li $v0 4
	la $a0 choixCarte9
	syscall 
	j loop
	
	
	
	
	
#------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------
	
choix3:
	# sortie du programme
	li $v0 4
	la $a0 temp3
	syscall
	
	li $v0 10
	syscall
