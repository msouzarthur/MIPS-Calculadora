.data
#Strings usadas para pedir e exibir informacoes
	intro: .asciiz "A calculadora aceita somente inteiros\nDigite a opcao e insira o(s) numeros(s)\n"
	vazio: 
	#p_ : pedir
	p_opcao: .asciiz "Insira a opcao: "
	p_num: .asciiz "Insira um numero: "
	p_base: .asciiz "Insira a base para converter: "

	#e_ : exibir
	e_a: .asciiz "A"
	e_b: .asciiz "B"
	e_c: .asciiz "C"
	e_d: .asciiz "D"
	e_e: .asciiz "E"
	e_f: .asciiz "F"
	e_espaco: .asciiz " "
	e_quebra: .asciiz "\n"
	e_resultado: .asciiz "Resultado: "
	e_menu: .asciiz "1 - Soma\t2 - Sub\t\t3 - Div\n4 - Mult\t5 - Exp\t\t6 - Fibonacci\n7 - Dec->Bin\t8 - Dec->Hex\t9 - Bin->Dec\n\t\t0 - Sair\n"

.text
	ori $t3, $zero, 0 	#carrega 0 em $t3 : auxiliar (recebe o resultado das contas) 
	ori $t4, $zero, 1	#carrega 0 em $t4 : controle de looping
	ori $t5, $zero, 1	#carrega 1 em $t5 : incremento

	#exibe a introducao
	la $a0, intro
	jal printarString
	main:
		#exibe o menu
		la $a0, e_menu
		jal printarString

		#pega opcao
		la $a0, p_opcao			#carrega string que sera usada
		jal printarString		#chama printarString
		jal pegarNumero			#chama pegarNumero
		move $t0, $v0			#resgata opcao e salva em $t0
		
		#validacao da opcao
		slti $t3, $t0, 0		# se valor eh menor que 0, $t3=1
		bne $t3, $zero, main		# se $t3 != 0, volta pra main
		slti $t3, $t0, 10		# se valor eh menor que 9, $t3=1
		beq $t3, $zero, main		# se $t3 == 0, volta pra main
		
		beq $t0, $zero, finish		#finaliza programa
		
		#pega o primeiro algarismo (tudo tem ao menos 1 algarismo)
		la $a0, p_num		#carrega string de pedir numero
		jal printarString	#printa a string
		jal pegarNumero		#pega o valor desse numero
		move $t1, $v0		#move o valor para $t1
		
		#acessa as contas
		beq $t0, 1, Soma		#pula pra soma
		beq $t0, 2, Sub			#pula pra sub
		beq $t0, 3, Div			#pula pra div
		beq $t0, 4, Mult		#pula pra mult
		beq $t0, 5, Exp			#pula pra exp
		beq $t0, 6, Fib			#pula pra fibonacci
		beq $t0, 7, Bin			#pula pra bin
		beq $t0, 8, Hex			#pula pra hex
		beq $t0, 9, Dec			#pula pra dec
		
	printarString:			#exibe a string que foi carregada e retorna
		li $v0, 4		
		syscall
		jr $ra
		
	pegarNumero:			#pega o valor de um inteiro e retorna
		li $v0, 5
		syscall
		jr $ra
	
	resultado:			#exibe o valor armazenado em $t3 e retorna
		ori $t4, $zero, 1 	#reseta $t4
		ori $t5, $zero, 1	#reseta $t5
		la $a0, e_resultado	#carrega string de exibicao
		jal printarString	#printa a string
		li $v0, 1		#exibicao de inteiros
		move $a0, $t3		#move o valor para $a0
		syscall			#printa o valor
		la $a0, e_quebra	#carrega a string de espaco
		jal printarString	#printa a string
		j main			#volta pro main
		
	Soma:	
		la $a0, p_num		#carrega string de pedir numero
		jal printarString	#printa a string
		jal pegarNumero		#pega o valor desse numero
		move $t2, $v0		#move o valor para $t2
		add $t3, $t1, $t2	#calcula e salva em $t3
		j resultado		#exibe o resultado
	
	Sub:
		la $a0, p_num		#carrega string de pedir numero
		jal printarString	#printa a string
		jal pegarNumero		#pega o valor desse numero
		move $t2, $v0		#move o valor para $t2
		sub  $t3, $t1, $t2	#calcula e salva em $t3
		j resultado		#exibe o resultado
	
	Div:
		la $a0, p_num		#carrega string de pedir numero
		jal printarString	#printa a string
		jal pegarNumero		#pega o valor desse numero
		move $t2, $v0		#move o valor para $t2
		div $t1, $t2		#calcula divisao
		mflo $t3		#move o resultado para $t3
		j resultado		#exibe o resultado
	
	Mult:
		la $a0, p_num		#carrega string de pedir numero
		jal printarString	#printa a string
		jal pegarNumero		#pega o valor desse numero
		move $t2, $v0		#move o valor para $t2
		mult $t1, $t2		#calcula multiplicacao
		mflo $t3		#move o resultado para $t3
		j resultado		#exibe o resultado
	
	Exp:
		la $a0, p_num		#carrega string de pedir numero
		jal printarString	#printa a string
		jal pegarNumero		#pega o valor desse numero
		move $t2, $v0		#move o valor para $t2
		ori $t3, $t1, 0		#copia $t1 para $t3
		calc:			#bloco de looping
			mult $t3, $t1		#multiplica (acumula as mult)
			mflo $t3		#resgata o valor para $t3
			add $t4, $t4, $t5	#incrementa $t4
			beq $t4, $t2, resultado #se $t4 == $t2, termina o looping
			bne $t4, $t2, calc	#se $t4 != $t2, reinicia o looping
			
	Fib:
		la $a0, p_num		#carrega string de pedir numero
		jal printarString	#printa a string
		jal pegarNumero		#pega o valor desse numero
		move $t1, $v0		#move o valor para $t1
		ori $t3, $zero, 0	#zera resultado
		
		#Exibe 0 e 1 inciais da sequencia
		li $v0, 1		#exibicao de inteiros
		move $a0, $t3		#move o valor para $a0
		syscall			#printa o valor
		la $a0, e_espaco	#carrega string de espaco
		jal printarString	#printa a string
		
		add $t3, $t4, $zero	#primeira soma
		li $v0, 1		#exibicao de inteiros
		move $a0, $t3		#move o valor para $a0
		syscall			#printa o valor
		la $a0, e_espaco	#carrega string de espaco
		jal printarString	#printa a string
		
		li $v0, 1		#exibicao de inteiros
		move $a0, $t3		#move o valor para $a0
		syscall			#printa o valor
		la $a0, e_espaco	#carrega string de espaco
		jal printarString	#printa a string
		
		add $t3, $t3, $t4	#segunda soma	
		calcFib:
			slt $t2, $t1, $t3	#se $t3>$t1
			beq $t1, $t3, resultado	#se $t3==$t1
			beq $t2, 1, resultado	#quebra looping
			li $v0, 1		#exibicao de inteiros
			move $a0, $t3		#move o valor para $a0
			syscall			#printa o valor
			la $a0, e_espaco	#carrega string de espaco
			jal printarString	#printa a string
			ori $t5, $t3, 0		#salva resultado
			add $t3, $t3, $t4	#acumula
			ori $t4, $t5, 0	#atualiza $t4
			j calcFib
			
	Bin:
		ori $t2, $zero, 2	#$t2 recebe 2
		ori $t4, $zero, 0	#$t4 recebe 0
		la $a0, e_resultado	#carrega a string de resultado
		jal printarString	#printa a string
		
	calcBin:			#push na pilha
		div $t1, $t2		#$t1 / $t4
		mfhi $t3		#move o resto para $t3
		mflo $t1		#move o resultado para $t1
		addiu $sp, $sp, -4	
		sw $t3, ($sp)		
		add $t4, $t4, $t5	
		bne $t1, 0, calcBin	#se t2 == 1, repete
		
	showBin:			#pop na pilha
		lw $t3, ($sp)
		addiu $sp, $sp, 4
		li $v0, 1		#exibicao de inteiros
		move $a0, $t3		#move o valor para $a0
		syscall			#printa o valor
		sub $t4, $t4, $t5	#decrementa looping
		bne $t4, 0, showBin	#looping exibicao
		#return	
		la $a0, e_quebra	#carrega string de quebra
		jal printarString	#printa a string
		j main			#volta pro menu

	Hex:
		ori $t2, $zero, 16	#$t2 recebe 16
		ori $t4, $zero, 0	#$t4 recebe 0
		la $a0, e_resultado	#carrega a string de resultado
		jal printarString	#printa a string
		
	calcHex:			#empilhar
		div $t1, $t2		#$t1 / $t4
		mfhi $t3		#move o resto para $t3
		mflo $t1		#move o resultado para $t1
		addiu $sp, $sp, -4	
		sw $t3, ($sp)		
		add $t4, $t4, $t5	#incrementa contador (.length)
		bne $t1, 0, calcHex	#se t2 == 1, repete
		
	auxHex:				#desempilha
		lw $t3, ($sp)
		addiu $sp, $sp, 4
		#se o desempilhado corresponde a um char
		bge $t3, 10, showCharHex
		#se o desempilhado corresponde a um numero
		ble $t3, 10, showHex
		j auxHex
		
	showHex:
		li $v0, 1		#exibicao de inteiros
		move $a0, $t3		#move o valor para $a0
		syscall			#printa o valor
		sub $t4, $t4, $t5	#decrementa looping
		bne $t4, 0, auxHex	#looping exibicao
		#return
		la $a0, e_quebra	#carrega string de quebra
		jal printarString	#printa a string
		j main			#volta pro menu
		
	showCharHex:
		beq $t3, 10, a
		a: la $a0, e_a
		j showCharHexTest
		beq $t3, 11, bb
		bb: la $a0, e_b
		j showCharHexTest
		beq $t3, 12, c
		c: la $a0, e_c
		j showCharHexTest
		beq $t3, 13, d
		d: la $a0, e_d
		j showCharHexTest
		beq $t3, 14, e
		e: la $a0, e_e
		j showCharHexTest
		beq $t3, 15, f
		f: la $a0, e_f
		j showCharHexTest
	showCharHexTest:
		jal printarString
		sub $t4, $t4, $t5	#decrementa looping
		bne $t4, 0, auxHex	#looping exibicao
		#return
		la $a0, e_quebra	#carrega string de quebra
		jal printarString	#printa a string
		j main			#volta pro menu
		
	Dec:
		
	finish:
		li, $v0, 10
		syscall 
