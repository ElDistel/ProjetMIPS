.data
	hello: .asciiz 		"\nBienvenue !\n"
	msgChoix: .asciiz 	"\nTapez 1: saisir un numero de carte bancaire pour en verifier la validite\nTapez 2: Generation et affichage d'un numero valide\nTapez 3: Quitter le programme\n\n>>>> "
	choixCarte: .asciiz	"Choisissez quel type de carte vous voulez :\n1- American Express\n2- Diners Club\n3- Discover\n4- InstaPayment\n5- JCB\n6- Maestro\n7- MasterCard\n8- VISA\n9- VISA Electron\n>>>>"
	msgReChoisir: .asciiz 	"\nChiffre saisi incorrect, \nVeuillez choisir parmis les propositions presentees\n"
	espace: .asciiz 	"\n\n"
	msgTaille16a19: .asciiz 	"\nVeuillez entrer la taille du code souhaite entre 16 et 19, tapez 1 pour choisir aleatoirement\n>>>>"
	msgTaille13ou16ou19: .asciiz	"\nVeuillez entrer la taille du code souhaite entre 13, 16 ou 19, tapez 1 pour choisir aleatoirement\n>>>>"
	
	temp1: .asciiz		"\nVous avez choisi le choix numero 1\n\n"
	temp2: .asciiz		"\nVous avez choisi le choix numero 2\n\n"
	temp3: .asciiz		"\nVous avez choisi de sortir\n"
	
	choixCarte1: .asciiz	"\nVous avez choisis le type de carte American Express, carte a 15 chiffres\n\n>>>>"
	choixCarte2: .asciiz	"\nVous avez choisis le type de carte Diners Club, carte a 14 chiffres\n\n>>>>"
	choixCarte3: .asciiz	"\nVous avez choisis le type de carte Discover \n\n"
	choixCarte4: .asciiz	"\nVous avez choisis le type de carte InstaPayment, carte a 16 chiffres\n\n>>>>"
	choixCarte5: .asciiz	"\nVous avez choisis le type de carte JCB\n\n"
	choixCarte6: .asciiz	"\nVous avez choisis le type de carte Maestro\n\n"
	choixCarte7: .asciiz	"\nVous avez choisis le type de carte MasterCard, carte a 16 chiffres\n\n>>>>"
	choixCarte8: .asciiz	"\nVous avez choisis le type de carte VISA\n\n"
	choixCarte9: .asciiz	"\nVous avez choisis le type de carte VISA Electron, carte a 16 chiffres\n\n>>>>"
	
	carte1: .word 34,37
	carte2: .word 36
	carte3: .word 6011, 644, 645, 646, 647, 648, 649, 65, 622126 	#jusqu'a 622925
	carte4: .word 637, 638, 639
	# la carte 5 est entierement une plage donc on genere son debut par ma sequence gestion de plage
	carte6: .word 5018, 5020, 5038, 2893, 6304, 6759, 6781, 6762, 6763
	carte7: .word 51, 52, 53, 54, 55, 222100
	# la carte 8 commence uniquement par 4 donc pas besoin de le stocker en .word
	carte9: .word 4026, 417500, 4508, 4844, 4913, 4917
	
#------------------------------------------------------------------------------------------------
#--------------------------- Variables pour la verification d'un numero -------------------------
#------------------------------------------------------------------------------------------------	
	
	# sentences
	providerFound: .asciiz 			"\nL'emetteur de la carte est: "
	providerNotFound: .asciiz 		"\nL'emetteur de la carte n'a pas ete trouve.\n"	
	
	# noms
	visaName: .asciiz 		"Visa"
	visaElectronName: .asciiz 	"Visa Electron"
	masterCardName: .asciiz 	"MasterCard"
	maestroName: .asciiz 		"Maestro"
	americanExpressName: .asciiz 	"American Express"
	dinersClubName: .asciiz 	"Diners Club - International"
	discoverName: .asciiz 		"Discover"
	instaPaymentName: .asciiz 	"InstaPayment"
	jbcName: .asciiz 		"JCB"
	
	# emetteurs
	visa: .asciiz 			"4"
	visaElectron: .asciiz 		"4026,417500,4508,4844,4913,4917"
	masterCard: .asciiz 		"51,52,53,54,55"
	maestro: .asciiz 		"5018,5020,5038,2893,6304,6759,6781,6762,6763"
	americanExpress: .asciiz 	"34,37"
	dinersClub: .asciiz 		"36"
	discover: .asciiz 		"6011,644,645,646,647,648,649,65"
	instaPayment: .asciiz 		"637,638,639"
	
	# emetteurs plages
	discoverRange: .word 622126, 622925
	jcbRange: .word 3528, 3589
	masterCardRange: .word 222100, 272099

	# listes
	cardList: .word visaElectron, visa, masterCard, maestro, americanExpress, dinersClub, discover, instaPayment
	cardNamesList: .word visaElectronName, visaName, masterCardName, maestroName, americanExpressName, dinersClubName, discoverName, instaPaymentName

  
	numeroCarte: .space 32	
	successMessage: .asciiz 	"\nLe numero est valide!\n"
  	failMessage: .asciiz 		"\nLe numero n'est pas valide!\n"
  	askMessage: .asciiz 		"\nVeuillez entrer le numero de CB: "
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
	
	# Choix du service par l'utilisateur
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




#------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------

choix1:
	# service numero 1

  	
  	li $v0, 4				# afficher message
  	la $a0, askMessage
  	syscall
  
  	
  	li $v0, 8				# lire numero de carte
  	la $a0, numeroCarte
  	li $a1, 20
  	syscall

  	# somme
  	li $t0, 0 				# somme
  	li $t1, 0 				# compteur i
  	li $t2, 9 				# 9
  	li $t3, 1 				#compteur a
  	li $s5, 2
  
	j longueur 				# longueur du numero



longueur:					# lire la longueur du numero
   	la $a1, numeroCarte
   	addi $t0, $zero, 0
   	j longueur.loop


longueur.loop:
   	lb $t5, ($a1) 				#charger le caractere a $a0
   
   	beqz $t5, calcul			#si on atteint le caractere null sortir de la boucle
  	beq $t5, 10, calcul 			#si on atteint le caractere Backspace sortir de la boucle 
   	beq $t5, 8, calcul 			#si on atteint le caractere NL sortir de la boucle
   
   	addi $a1, $a1, 1 			#incrementer la position du pointeur
   	addi $t0, $t0, 1 			#incrementer le compteur

   	j longueur.loop 			# on continue comme on a trouve la longueur


calcul:
   	sub $t1, $t0, 2 			# comme on ne veut pas inclure le derniere chiffre de la carte, on soustrait 1 a la longueur 
     
   	add $s4, $zero, $t1 			# sauvegarder la valeur pour l'utiliser a la fin
   	addi $t0, $zero, 0
   	la $a1, numeroCarte
   	addu $a1,$a1, $t1
   
	j calcul.loop


calcul.loop:
   	bltz $t1, check
   
   	lbu $t5,($a1)				# lire le caractere
   
   	addi $t5, $t5, -48			# le caractere est en ascii, on soustrait alors -48 (position du 0)
  
   	div $t3, $s5 				# a % 2
	mfhi $s0 				# recuperer le mod dans le hi register et le stocker dans $s0
   
	bnez $s0, modVal 			# i % 2 != 0 impaire

loop_end:
   	bgt $t5, 9, subVal 			# si valeur > 9
   
   	add $t0, $t0, $t5 			# ajouter a la somme
   	addi $a1, $a1, -1 			# i--
   	addi $t1, $t1, -1 			# i--
   	addi $t3, $t3, 1 			# a++
   
   	j calcul.loop
  
    
modVal:
	mul $t5, $t5, 2 			# multiplier par 2
	j loop_end
   

subVal:
	sub $t5,$t5,9
	j loop_end 				# valeur max est 18 - 9 = 9 donc beq ne sera plus execute


check:   
	addi $s1, $zero, 10
	div $t0, $s1 				# somme % 10
	mfhi $s0 				# recuperer le mod dans le hi register et le stocker dans $s0
	sub $t0, $s1, $s0
      
   	# on recupere la derniere valeur de la carte (max + 1)
   	addi $s4, $s4, 1 			# ajouter 1 car on cherche la derniere valeur
	add $t4, $zero, $s4
   
	la $a1, numeroCarte
	addu $a1,$a1,$t4  			# pointeur + $t4 pour trouver la valeur tab[x]
	lbu $t5,($a1) 				# charger caractere
   
	addi $t5, $t5, -48			# le caractere est en ascii, on soustrait alors -48 (position du 0)

	li $v0, 4				# check result
   
   	beq $t0, $t5, checkSuccess 		# si resultat = dernier chiffre carte bancaire
   
   	la $a0, failMessage
   	syscall
   
   	j end
   	
   
checkSuccess:
   	la $a0, successMessage
   	syscall
     
   	li $s5, 0 				# i
   
   	j checkSuccess.loop
   
   
checkSuccess.loop:
	mul $s2, $s5, 4 			# i * 4 pour se deplacer dans un tableau
	la $a0, cardList 			# charger la liste de cartes
	addu $a0,$a0,$s2
	lw $a1, ($a0) 				# $a1 est les nombre de debut des cartes bancaires
	j checkCardProvider
   

checkSuccess.continue:
	# on continue dans les type de cartes
	addi $s5,$s5,1
	ble $s5, 8, checkSuccess.loop
   
	j checkSuccess.end
   
   
checkSuccess.success:
	li $v0, 4
	la $a0, providerFound
	syscall  
	mul $s2, $s5, 4 			# i * 4 pour se deplacer dans un tableau
	la $a1, cardNamesList 			# charger la liste des noms de carte
	addu $a1,$a1,$s2
	lw $a0, ($a1) 				# $a1 est les nombre de debut des cartes bancaires
	syscall
	j end
	
 
checkSuccess.end:				# checker les plages
   
   	# pour jcb
   	addi $t0, $zero, 4 			# on cherche le nombre des 4 premiers chiffre
	la $a2, jbcName 			# name
	la $a3, jcbRange 			# range
	lw $s3, 0($a3) 				# start range
	lw $s4, 4($a3) 				# end range
	jal checkCardProvider.ranges 		# check if its in range
   
   	# pour discover
	addi $t0, $zero, 6 			# on cherche le nombre des 6 premiers chiffre
	la $a2, discoverName 			# name
   	la $a3, discoverRange 			# range
	jal checkCardProvider.ranges 		# check if its in range
   
	# pour masterCard
	addi $t0, $zero, 6 			# on cherche le nombre des 6 premiers chiffre
	la $a2, masterCardName 			# name
	la $a3, masterCardRange 		# range
	jal checkCardProvider.ranges 		# check if its in range
   
	# not found
	li $v0, 4
	la $a0, providerNotFound
 	syscall
   
	la $a0, espace
	syscall
	j end

      
end:

	li $v0, 4
	la $a0, espace
	syscall

	b menu
   
# =============================== #

checkCardProvider.ranges:

	la $a1, numeroCarte
	li $t1, 1 				# multiplicateur 
	li $s2, 0 				# resultat
	lw $s3, 0($a3) 				# start range
	lw $s4, 4($a3) 				# end range
	addi $t0, $t0, -1 			# index commence par 0 et pas par 1
	addu $a1, $a1, $t0 			# pointeur + index
	j checkCardProvider.ranges.loop
   

checkCardProvider.ranges.loop:
   
	lb $s1, ($a1) 				# load byte
	addi $s1, $s1, -48 			# normalise number
	mul $s1, $s1, $t1
   
	add $s2, $s2, $s1
   
	mul $t1, $t1, 10 
	addi $a1, $a1, -1
	addi $t0, $t0, -1
	bgez $t0, checkCardProvider.ranges.loop
   
	j checkCardProvider.ranges.checkGreater
   
   
checkCardProvider.ranges.checkGreater:
	bge $s2, $s3, checkCardProvider.ranges.checkLess
	jr $ra 					# non trouve
   

checkCardProvider.ranges.checkLess:
	ble $s2, $s4, checkCardProvider.ranges.found
	jr $ra 					# trouver


checkCardProvider.ranges.found:
	li $v0, 4
	la $a0, providerFound
	syscall
	move $a0, $a2				 # emetteur
	syscall

	j end
	

   
# variables obligatoires de la fonction:
# => $a1 = chiffres de debut specifiques a la carte
checkCardProvider:
	li $s2, 0					 # match = false
	lb $a0, 0($a1)
	la $a2, numeroCarte


checkCardProvider.loop:
	beqz $a0, checkCardProvider.finish 		# si 0 , refaire check a la fin
	beq $a0, 44, checkCardProvider.virgule 		#si trouve une virgule
   
	lb $s1, ($a2)
     
	beq $s1, $a0, checkCardProvider.match 		# si caractere est egal
   
	j checkCardProvider.nonMatch			# non match
   
   
checkCardProvider.nonMatch:
	addiu $a1, $a1, 1
	lb $a0, ($a1)
   
	beqz $a0, checkCardProvider.moveFinish
	bne $a0, 44, checkCardProvider.nonMatch
   
	move $s2, $zero
   
	j checkCardProvider.loop
   
   
checkCardProvider.match:
	addiu $s2, $zero, 1
	addiu $a2, $a2, 1   
	
	j checkCardProvider.incr
	
   
checkCardProvider.virgule:
	bgt $s2, $zero, checkCardProvider.isValid 		# si les numeros sont valides on accepte								
	la $a2, numeroCarte
	move $s2, $zero						# sinon on met a 0 l'index du code de la carte
	
	j checkCardProvider.incr
	

checkCardProvider.incr:
	addiu $a1, $a1, 1
	lb $a0, ($a1)
	
	j checkCardProvider.loop
	
   
checkCardProvider.isValid:

	j checkSuccess.success
	

checkCardProvider.moveFinish:
	move $s2, $zero
	
	j checkCardProvider.finish
	

checkCardProvider.finish:
	bgt $s2, $zero, checkCardProvider.isValid

 	j checkSuccess.continue

#------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------


#$t1 est une adresse temporaire

#$t3 est la variable faisant office de verificateur pour chiffre pair ou impair

#$t4 est la variable contenant la determination aleatoire du debut du code de carte

#$t5 est la longueur du code de carte a generer

#$t6 est un compteur utilise lors du traitement du debut de code de carte par defaut

#$t7 est le debut de carte genere aleatoirement

#$t8 est le dernier chiffre du code de carte calcule initialise a  10

#$t9 est la somme de tous les chiffres


choix2:
	# service numero 2	
	li $v0 4
	la $a0 temp2
	syscall

	li $t3 1
	li $t5 15		#on donne un nombre par defaut pour un code a 16 chiffres
	li $t9 0
	
	li $v0 4
	la $a0 choixCarte
	syscall
	
	li $v0 5		# Choix du service par l'utilisateur du type de carte souhaite
	syscall
	move $s0 $v0
	
	j verifCarte
	
	
verifCarte:
	beq $s0 1 Carte1init	# Branch au service correspondant a la carte
	beq $s0 2 Carte2init
	beq $s0 3 Carte3init
	beq $s0 4 Carte4init
	beq $s0 5 Carte5init
	beq $s0 6 Carte6init
	beq $s0 7 Carte7init
	beq $s0 8 Carte8init
	beq $s0 9 Carte9init
	
	li $v0 4
	la $a0 msgReChoisir
	syscall
	
	li $v0 5		# Choix du service par l'utilisateur du type de carte souhaite
	syscall
	move $s0 $v0
	
	j verifCarte
	
	
#######################################################
### LOOP DE VALEURS ALEATOIRES
###
###
### Ce loop est celui qui genere tous les
### nombres aleatoires apres le debut choisit par 
### l'utilisateur en fonction de la carte
#######################################################
	
	
loop:	
	beq $t5 $zero finLoop
	
	li $a1, 9		#sequence pour generer un nombre aleatoire

    	li $v0, 42  
    	syscall
	add $a0, $a0, 0  

    	
    	li $v0, 1
	syscall
	
	move $t6 $a0
	
	jal verifParite
	j sommeLoop
	

sommeLoop:
	add $t9 $t9 $t6		#somme de tous les entiers aleatoires
	
	sub $t5 $t5 1
	j loop
	


finLoop:
	bgt $t9 10 modSomme
	
	li $t8 10
	
	sub $t8 $t8 $t9
	
	li $v0 1
	move $a0 $t8
	syscall
	
	li $v0 4
	la $a0 espace
	syscall
	
	
	j menu
	
	
#######################################################
### OPERATIONS DE PARITE ET MODULO
###
###
### Cette sections regroupe toutes les operations
### de parite qui seront utilisees par le
#######################################################
	


verifParite:
	beq $t3 1 chiffreImpair
	beq $t3 2 chiffrePair


chiffreImpair:

	mul $t6 $t6 2
	bgt $t6 9 moinsNeuf	#si $t6 est superieur a 9
chiffreImpairSuite:
	addi $t3 $t3 1		#on ajoute 1 pour que le chiffre suivant soit compte comme impair, et au tour d'apres $t1 vaudra a  nouveau 1
	jr $ra
	
	
moinsNeuf:
	subi $t6 $t6 9
	j chiffreImpairSuite

	


chiffrePair:
	subi $t3 $t3 1
	jr $ra


modSomme:			#boucles pour faire le modulo de la derniere valeur
	bgt $t9 10 modSommeBis
	j finLoop
	
	
modSommeBis:
	subi $t9 $t9 10
	j modSomme
	
	
#######################################################
### CHOIX DES CARTES
###
###
### Initialisation du debut du code en fonction 
### de l'indice du tableau de valeurs choisit 
### par l'utilisateur puis un retour au loop
### classique avec generation d'un autre nombre 
### aleatoire a chaque tour
#######################################################


Carte1init:
	li $v0 4
	la $a0 choixCarte1
	syscall
	
	li $t5 14		#nombre de  chiffres du code American express
	li $t3 2
	
	li $a1, 2		#sequence pour generer un nombre aleatoire
    	li $v0, 42  		
    	syscall
	add $a0, $a0, 0
	
	mul $t4 $a0 4		# multiplication de l'index à acceder par 4 etant donne que les indices sont stockes 4 par 4
	la $a1 carte1		# on load carte 1
	add $a1 $a1 $t4		# on ajoute l'indice a acceder a l'indice du premier element
	lw $t7 ($a1)		# on le load dans $t7

	li $v0 1
	move $a0 $t7
	syscall			# on affiche le nombre choisi
	
	jal nbrVerifRegister
	j loop
	
	# meme systeme de fonctionnement pour toutes les cartes
	
	
Carte2init:
	li $v0 4
	la $a0 choixCarte2
	syscall
	
	li $t5 13		#nombre de  chiffres du code Diners Club

	la $a1 carte2
	lw $t7 ($a1)
	
	li $v0 1
	move $a0 $t7
	syscall
	
	jal nbrVerifRegister
	j loop
	

Carte3init:
	li $v0 4
	la $a0 choixCarte3
	syscall
	
	jal choixTaille16a19
	
	li $a1, 9	
    	li $v0, 42  
    	syscall
	add $a0, $a0, 0
	
	mul $t4 $a0 4
	la $a1 carte3
	add $a1 $a1 $t4
	lw $t7 ($a1)
	
	jal plageCarte
	
	li $v0 1
	move $a0 $t7
	syscall
	
	jal nbrVerifRegister
	j loop
	
	
	
	
Carte4init:
	li $v0 4
	la $a0 choixCarte4
	syscall
	
	li $a1, 3		
    	li $v0, 42  
    	syscall
	add $a0, $a0, 0
	
	mul $t4 $a0 4			
	la $a1 carte4
	add $a1 $a1 $t4
	lw $t7 ($a1)
	
	li $v0 1
	move $a0 $t7
	syscall
	
	jal nbrVerifRegister
	j loop
	
	
Carte5init:
	li $v0 4
	la $a0 choixCarte5
	syscall
	
	jal choixTaille16a19

	li $t7 3528
	
	jal plageCarte
	
	li $v0 1
	move $a0 $t7
	syscall
	
	jal nbrVerifRegister
	j loop
	
	
	
Carte6init:
	li $v0 4
	la $a0 choixCarte6
	syscall
	
	jal choixTaille16a19
	
	li $a1, 9		
    	li $v0, 42  
    	syscall
	add $a0, $a0, 0
	
	mul $t4 $a0 4
	la $a1 carte6
	add $a1 $a1 $t4
	lw $t7 ($a1)
	
	li $v0 1
	move $a0 $t7
	syscall
	
	jal nbrVerifRegister
	j loop
	
	
	
Carte7init:
	li $v0 4
	la $a0 choixCarte7
	syscall
	
	li $a1, 6		
    	li $v0, 42  
    	syscall
	add $a0, $a0, 0
	
	mul $t4 $a0 4
	la $a1 carte7
	add $a1 $a1 $t4
	lw $t7 ($a1)
	
	jal plageCarte
	
	li $v0 1
	move $a0 $t7
	syscall
	
	jal nbrVerifRegister
	j loop



Carte8init:				# Pas besoin d'autres boucles ou fonctions pour uniquement un 4 en debut de code de carte
	li $v0 4
	la $a0 choixCarte8
	syscall
	
	jal choixTaille13ou16ou19
	
	li $t7 4
	
	li $v0 1
	move $a0 $t7
	syscall
	
	jal nbrVerifRegister
	j loop
	
	
Carte9init:
	li $v0 4
	la $a0 choixCarte9
	syscall
	
	li $a1, 6		
    	li $v0, 42  
    	syscall
	add $a0, $a0, 0
	
	mul $t4 $a0 4
	la $a1 carte9
	add $a1 $a1 $t4
	lw $t7 ($a1)
	
	li $v0 1
	move $a0 $t7
	syscall
	
	jal nbrVerifRegister
	j loop
	
	
	
#######################################################
### SEQUENCE DE GESTION DES PLAGES GENEREES
###
###
### Cette sequence permet la generation d'un nombre
### aleatoire compris dans la plage si au prealable
### le choix de l'element du tableau choisit 
### le nombre le plus bas de la plage
#######################################################		
	
	
	
plageCarte:
	beq $t7 622126 plageCarte3
	beq $t7 3528 plageCarte5
	beq $t7 222100 plageCarte7
	jr $ra
	

plageCarte3:
	li $a1, 800		# on met dans $a1 le nombre de chiffres qu'on veut dans l'aleatoire a savoir ici de 0 a 799
    	li $v0, 42  		# on genere l'aleatoire
    	syscall
	add $a0, $a0, 622126	# on ajoute 622126 etant la valeur la plus basse a generer, on a donc genere un debut de code entre 622126 et 622925
	move $t7 $a0
	jr $ra	
	
	# meme fonctionnement pour les cartes 5 et 7
	
plageCarte5:
	li $a1, 62		
    	li $v0, 42  
    	syscall
	add $a0, $a0, 3528
	move $t7 $a0
	jr $ra	
	
plageCarte7:
	li $a1, 50000		
    	li $v0, 42  
    	syscall
	add $a0, $a0, 222100
	move $t7 $a0
	jr $ra	
	
	
	
	
	
	
#######################################################
### SEQUENCE DE GESTION DU CHOIX DE LA TAILLE
###
###
### L'utilisateur va ici choisir en fonction
### du nombre de chiffres possibles de la carte
### choisie au prealable combien de chiffre il veut
### pour le code genere
#######################################################	
	
	
choixTaille16a19:
	li $v0 4
	la $a0 msgTaille16a19
	syscall
	
	li $v0 5
	syscall
	move $t8 $v0
	
	beq $t8 1 alea16a19
	beq $t8 16 choixTaille16
	beq $t8 17 choixTaille17
	beq $t8 18 choixTaille18
	beq $t8 19 choixTaille19
	
	li $v0 4
	la $a0 msgReChoisir
	syscall
	
	j choixTaille16a19
	
	
choixTaille13ou16ou19:
	li $v0 4
	la $a0 msgTaille13ou16ou19
	syscall
	
	li $v0 5
	syscall
	move $t8 $v0
	
	beq $t8 1 alea13ou16ou19
	beq $t8 13 choixTaille13
	beq $t8 16 choixTaille16
	beq $t8 19 choixTaille19
	
	li $v0 4
	la $a0 msgReChoisir
	syscall
	
	j choixTaille13ou16ou19	#taille - 1 car le dernier chiffre sera la difference du modulo de la somme
	
	
alea16a19:
	li $a1, 4		#sequence pour generer un nombre aleatoire qui sera la taille du code a generer
    	li $v0, 42  
    	syscall
	add $a0, $a0, 0
	
	addi $t5 $a0 15
	beq $t5 16 choixTaille16
	beq $t5 17 choixTaille17
	beq $t5 18 choixTaille18
	beq $t5 19 choixTaille19
	
	jr $ra
alea13ou16ou19:
	li $a1, 3		#sequence pour generer un nombre aleatoire qui sera la taille du code a generer
    	li $v0, 42  
    	syscall
	add $a0, $a0, 0
	
	move $t5 $a0		#on prend un nombre entre 0 et 2, le mutliplie par 3 et lui ajoute 13 ce qui donne 13, 16 ou 19
	mul $t5 $t5 3
	addi $t5 $t5 12
	
	beq $t5 17 choixTaille17
	beq $t5 18 choixTaille18
	beq $t5 19 choixTaille19
	jr $ra	
choixTaille13:
	li $t5 12
	li $t3 2		# on initialise $t3 a 2 car une taille de 13 est impaire et donc pour traiter correctement l'algorithme de luhn il faut commencer par un nombre de place paire
	jr $ra
choixTaille16:
	li $t5 15
	jr $ra
choixTaille17:
	li $t5 16
	li $t3 2		# idem que pour la taille 13, la taille 15, 17 et 19 sont impaires
	jr $ra
choixTaille18:
	li $t5 17
	jr $ra
choixTaille19:
	li $t5 18
	li $t3 2
	jr $ra

	
	
#######################################################
### SEQUENCE DE GESTION DE LA SOMME AVEC LE DEBUT DE CARTE
###
###
### le nombre entre dans la boucle en fonction
### de son ordre de grandeur puis
### se voit etre decremente jusqu'a ce qu'il soit nul
### chaque valeur des unites, dizaine, centaines, ect
### sera incrementee dans la somme totale.
#######################################################	
	
nbrVerifRegister:
	move $t1 $ra
	j nbrVerif

nbrVerif:				#ordre de grandeur dans lequel le nombre entre dans la boucle
	li $t6 0
	bgt $t7 99999 sup99999
	bgt $t7 9999 sup9999
	bgt $t7 999 sup999	
	bgt $t7 99 sup99	
	bgt $t7 9 sup9	
	bgt $t7 0 sup0		
	

	
sup99999:
	bgt $t7 99999 sup99999bis	# si le nombre a 6 chiffres on lui enleve un 100 000eme par un 100 000eme jusqu'a ce qu'on ait recupere son exacte valeur
	subi $t5 $t5 1			# on decremente la taille totale a generer
	jal verifParite			# on verifie sa parite pour lui attribuer les bons changements
	add $t9 $t9 $t6			# on l'ajoute a la somme totale
	li $t6 0			# on re initialise $t6 a 0 pour qu'il puisse stocker les valeurs suivantes
	j sup9999			# on passe au rang inferieur a savoir 10 000eme, et ainsi de suite jusqu'a ce que $t7 soit egal a 0
	
sup99999bis:	
	subi $t7 $t7 100000		# decremente $t7 pour en trouver la valeur ici au rang 100 000eme
	addi $t6 $t6 1	
	j sup99999
	
		
				
sup9999:
	bgt $t7 9999 sup9999bis
	subi $t5 $t5 1
	jal verifParite
	add $t9 $t9 $t6
	li $t6 0
	j sup999
	
sup9999bis:	
	subi $t7 $t7 10000
	addi $t6 $t6 1	
	j sup9999	

	
sup999:
	bgt $t7 999 sup999bis
	subi $t5 $t5 1
	jal verifParite
	add $t9 $t9 $t6
	li $t6 0
	j sup99
	
sup999bis:	
	subi $t7 $t7 1000
	addi $t6 $t6 1	
	j sup999
	
	
sup99:
	bgt $t7 99 sup99bis
	subi $t5 $t5 1
	jal verifParite
	add $t9 $t9 $t6
	li $t6 0
	j sup9
	
sup99bis:	
	subi $t7 $t7 100
	addi $t6 $t6 1	
	j sup99
	
	
sup9:
	bgt $t7 9 sup9bis
	subi $t5 $t5 1
	jal verifParite
	add $t9 $t9 $t6
	li $t6 0
	j sup0
	
sup9bis:	
	subi $t7 $t7 10
	addi $t6 $t6 1	
	j sup9
sup0:
	bgt $t7 0 sup0bis
	subi $t5 $t5 1
	jal verifParite
	add $t9 $t9 $t6
	li $t6 0
	jr $t1				#retour a l'endroit ou la fonction a ete appelee a l'origine
	
sup0bis:	
	subi $t7 $t7 1
	addi $t6 $t6 1	
	j sup0
	
	
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
