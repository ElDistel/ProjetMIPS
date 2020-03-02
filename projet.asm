.data
	hello: .asciiz 		"\nBienvenue !\n"
	msgChoix: .asciiz 	"\nTapez 1: saisir un numéro de carte bancaire pour en vérifier la validité\nTapez 2: Affichage d'un numero valide\nTapez 3: Quitter le programme\n\n >>>> "
	msgReChoisir: .asciiz 	"\nChiffre saisi incorrect, \nVeuillez choisir parmis les propositions présentées\n"
	espace: .asciiz 	"\n\n"
	
	temp1: .asciiz		"\nVous avez choisit le choix numero 1\n\n"
	temp2: .asciiz		"\nVous avez choisit le choix numero 2\n\n"
	temp3: .asciiz		"\nVous avez choisit de sortir\n"
	
	numeroCarte: .space 20
.text


# Entree dans le programme
li $v0 4
la $a0 hello
syscall

menu:
	# présentation des options
	li $v0 4
	la $a0 msgChoix
	syscall
	
	# Choix du service par l'utilisateur enregistré dans une variable non temporaire
	li $v0 5
	syscall
	move $s0 $v0

	# Branch au service correspondant au numero entré
	beq $s0 1 choix1
	beq $s0 2 choix2
	beq $s0 3 choix3
	
	# Message d'erreur si le chiffre saisit est différent de 1, 2 ou 3
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
	li $v0 4
	la $a0 temp1
	syscall
	
	
	
	b menu


#------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------


#$t2 est la variable aleatoire 

#$t3 est la variable faisant office de vérificateur pour chiffre pair ou impair

#$t5 est la longueur du code de carte

#$t8 est le dernier chiffre du code de carte calculé initialisé à 10

#$t9 est la somme de tous les chiffres


choix2:
	# service numero 2	
	li $v0 4
	la $a0 temp2
	syscall
	
	#nombre de chiffres de la carte sans comopter le dernier
	li $t5 11
	li $t3 1
	
loop:
	beq $t5 $zero finLoop
	
	li $a1, 9		#sequence pour générer un nombre aleatoire
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
	
	li $t8 10
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
	bgt $t2 9 moinsNeuf	#si $t2 est superieur à 9
	addi $t3 $t3 1		#on ajoute 1 pour que le chiffre suivant soit compté comme impair, et au tour d'après $t1 vaudra à nouveau 1
	j sommeLoop
	
	
moinsNeuf:
	subi $t2 $t2 9
	addi $t3 $t3 1		#on ajoute 1 pour que le chiffre suivant soit compté comme impair, et au tour d'après $t1 vaudra à nouveau 1
	j sommeLoop
	


chiffrePaire:
	subi $t3 $t3 1
	j sommeLoop


modSomme:			#boucles pour faire le modulo de la derniere valeur
	bgt $t9 10 modSommeBis
	j finLoop
	
	
modSommeBis:
	subi $t9 $t9 10
	j modSomme
	
	
	
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
	
