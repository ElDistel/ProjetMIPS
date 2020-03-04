.data
	hello: .asciiz 		"\nBienvenue !\n"
	msgChoix: .asciiz 	"\nTapez 1: saisir un num�ro de carte bancaire pour en v�rifier la validit�\nTapez 2: Affichage d'un numero valide\nTapez 3: Quitter le programme\n\n >>>> "
	msgReChoisir: .asciiz 	"\nChiffre saisi incorrect, \nVeuillez choisir parmis les propositions pr�sent�es\n"
	espace: .asciiz 	"\n\n"
	
	temp1: .asciiz		"\nVous avez choisi le choix numero 1\n\n"
	temp2: .asciiz		"\nVous avez choisi le choix numero 2\n\n"
	temp3: .asciiz		"\nVous avez choisi de sortir\n"
	
	# sentences
	providerFound: .asciiz "\nL'emetteur de la carte est: "
	providerNotFound: .asciiz "\nL'emetteur de la carte n'a pas ete trouve.\n"
	
	# noms
	visaName: .asciiz "Visa"
	visaElectronName: .asciiz "Visa Electron"
	masterCardName: .asciiz "MasterCard"
	maestroName: .asciiz "Maestro"
	americanExpressName: .asciiz "American Express"
	dinersClubName: .asciiz "Diners Club - International"
	discoverName: .asciiz "Discover"
	instaPaymentName: .asciiz "InstaPayment"
	jbcName: .asciiz "JCB"
	
	# emetteurs
	visa: .asciiz "4"
	visaElectron: .asciiz "4026,417500,4508,4844,4913,4917"
	masterCard: .asciiz "51,52,53,54,55"
	maestro: .asciiz "5018,5020,5038,2893,6304,6759,6781,6762,6763"
	americanExpress: .asciiz "34,37"
	dinersClub: .asciiz "36"
	discover: .asciiz "6011,644,645,646,647,648,649,65"
	instaPayment: .asciiz "637,638,639"
	
	# emetteurs plages
	discoverRange: .word 622126, 622925
	jcbRange: .word 3528, 3589
	masterCardRange: .word 222100, 272099

	# listes
	cardList: .word visaElectron, visa, masterCard, maestro, americanExpress, dinersClub, discover, instaPayment
	cardNamesList: .word visaElectronName, visaName, masterCardName, maestroName, americanExpressName, dinersClubName, discoverName, instaPaymentName
	
  ###
  
	numeroCarte: .space 20
  	successMessage: .asciiz "\nLe numero est valide!\n"
  	failMessage: .asciiz "\nLe numero n'est pas valide!\n"
.text


# Entree dans le programme
li $v0 4
la $a0 hello
syscall

menu:
	# pr�sentation des options
	li $v0 4
	la $a0 msgChoix
	syscall
	
	# Choix du service par l'utilisateur enregistr� dans une variable non temporaire
	li $v0 5
	syscall
	move $s0 $v0

	# Branch au service correspondant au numero entr�
	beq $s0 1 choix1
	beq $s0 2 choix2
	beq $s0 3 choix3
	
	# Message d'erreur si le chiffre saisit est diff�rent de 1, 2 ou 3
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

  # lire numero de carte (test: 376701449043032)
  li $v0, 8
  la $a0, numeroCarte
  li $a1, 20
  syscall

  # somme
  li $t0, 0 # somme
  li $t1, 0 # compteur i (commence a 14)
  li $t2, 9 # 9
  li $t3, 0 #compteur a
  li $t4, 2 #mod 2
  
  j longueur # longueur du numero

# lire la longueur du numero
longueur:
   la $a0, numeroCarte
   addi $t0, $zero, -1 # -1 pour normaliser
   jal longueur.loop

longueur.loop:
   lb $t5, 0($a0) #charger le caractere a $a0
   beqz $t5, calcul #si on atteint le caractere null continuer la boucle

   addi $a0, $a0, 1 #incrementer la position du pointeur
   addi $t0, $t0, 1 #incrementer le compteur

   j longueur.loop # on continue comme on a trouve la longueur

calcul:
   addi $t1, $t0, -2 # comme on ne veut pas inclure le derniere chiffre de la carte, on soustrait 1 a la longueur 
   add $s4, $zero, $t1 # sauvegarder la valeur pour l'utiliser a la fin
   addi $t0, $zero, 0 
   
   j calcul.loop

calcul.loop:
   blt $t1, $zero, check
   #li $s0, 4 #iterator
   la $a1, numeroCarte
   addu $a1,$a1,$t1  # $a1 = &str[x]. x est dans $t0
   lbu $t5,($a1)      # lire le caractere
   
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
   j calcul.loop
   
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
   addi $s4, $s4, 1 # ajouter 1 car on cherche la derniere valeur
   add $t4, $zero, $s4
   
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
     
   li $s5, 0 # i
   
   j checkSuccess.loop
   
checkSuccess.loop:
   mul $s2, $s5, 4 # i * 4 pour se deplacer dans un tableau
   la $a0, cardList # charger la liste de cartes
   addu $a0,$a0,$s2
   lw $a1, ($a0) # $a1 est les nombre de debut des cartes bancaires
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
   la $a0, espace
   syscall
   li $v0, 1
   move $a0, $s5
   syscall
   li $v0, 4
      la $a0, espace
   syscall
  
   mul $s2, $s5, 4 # i * 4 pour se deplacer dans un tableau
   la $a1, cardNamesList # charger la liste des noms de carte
   addu $a1,$a1,$s2
   lw $a0, ($a1) # $a1 est les nombre de debut des cartes bancaires
   syscall
   j end
 
checkSuccess.end:
   # checker les plages
   li $v0, 4
   la $a0, providerNotFound
   syscall
   la $a0, espace
   syscall
   j end
   
end:
   b menu
   
# variables obligatoires de la fonction:
# => $a1 = chiffres de debut specifiques a la carte
checkCardProvider:
   li $s2, 0 # match = false
   lb $a0, 0($a1)
   la $a2, numeroCarte

checkCardProvider.loop:
   beqz $a0, checkCardProvider.finish # si 0 , refaire check a la fin
   beq $a0, 44, checkCardProvider.virgule #si trouve une virgule
   
   lb $s1, ($a2)
     
   beq $s1, $a0, checkCardProvider.match # si caractere est egal
   
   j checkCardProvider.nonMatch
   
   # non match
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
   bgt $s2, $zero, checkCardProvider.isValid # si les numeros sont valides on accepte
   # sinon on met a 0 l'index du code de la carte
   la $a2, numeroCarte
   move $s2, $zero

   j checkCardProvider.incr

checkCardProvider.incr:
   addiu $a1, $a1, 1
   lb $a0, ($a1)
   j checkCardProvider.loop
   
checkCardProvider.isValid:
   # ?
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


#$t2 est la variable aleatoire 

#$t3 est la variable faisant office de vÃ©rificateur pour chiffre pair ou impair

#$t5 est la longueur du code de carte

#$t8 est le dernier chiffre du code de carte calculÃ© initialisÃ© Ã  10

#$t9 est la somme de tous les chiffres


choix2:
	# service numero 2	
	li $v0 4
	la $a0 temp2
	syscall
	
	#nombre de chiffres de la carte sans compter le dernier
	li $t5 11
	li $t3 1
	
loop:
	beq $t5 $zero finLoop
	
	li $a1, 9		#sequence pour gÃ©nÃ©rer un nombre aleatoire
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
	bgt $t2 9 moinsNeuf	#si $t2 est superieur a� 9
	addi $t3 $t3 1		#on ajoute 1 pour que le chiffre suivant soit compte comme impair, et au tour d'aprÃ¨s $t1 vaudra Ã  nouveau 1
	j sommeLoop
	
	
moinsNeuf:
	subi $t2 $t2 9
	addi $t3 $t3 1		#on ajoute 1 pour que le chiffre suivant soit comptÃ© comme impair, et au tour d'aprÃ¨s $t1 vaudra Ã  nouveau 1
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
