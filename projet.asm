.data
	hello: .asciiz 		"\nBienvenue !\n"
	msgChoix: .asciiz 	"\nTapez 1: saisir un numéro de carte bancaire pour en vérifier la validité\nTapez 2: Affichage d'un numero valide\nTapez 3: Quitter le programme\n\n -"
	msgReChoisir: .asciiz 	"\nChiffre saisi incorrect, \nVeuillez choisir parmis les propositions présentées\n"
	
	temp1: .asciiz		"\nVous avez choisit le choix numero 1\n"
	temp2: .asciiz		"\nVous avez choisit le choix numero 2\n"
	temp3: .asciiz		"\nVous avez choisit de sortir\n"
	
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
	
	
choix1:
	# service numero 1
	li $v0 4
	la $a0 temp1
	syscall
	
	b menu
	
	
choix2:
	# service numero 2	
	li $v0 4
	la $a0 temp2
	syscall
	
	b menu
	
choix3:
	# sortie du programme
	li $v0 4
	la $a0 temp3
	syscall
	
	li $v0 10
	syscall
	