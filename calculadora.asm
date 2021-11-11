.data
#Strings usadas para pedir e exibir informacoes
	intro: .asciiz "A calculadora aceita somente inteiros\nDigite a opcao e insira o(s) numeros(s)\n"
	#espaco reservado pra escrever as conversoes
	vazio: .space 16
	
	#p_ : strings de pedir
	p_opcao: .asciiz "Insira a opcao: "
	p_num: .asciiz "Insira um numero: "

	#e_ : strings de exibir
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
	ori $t3, $zero, 0 	#carrega 0 em $t3 : resultado das contas / auxiliar
	ori $t4, $zero, 1	#carrega 1 em $t4 : sempre usado pra contagem/looping
	ori $t5, $zero, 1	#carrega 1 em $t5 : incremento
	ori $t7, $zero, 0	#carrega 0 em $t7 : tamanho do historico
	
	#exibe a introducao
	la $a0, intro			#carrega a string de intro
	jal printarString		#exibe a string
	
	main:				#bloco main
		la $a0, e_menu		#carrega string de menu
		jal printarString	#printa a string

		la $a0, p_opcao		#carrega string de opcao
		jal printarString	#printa a string
		jal pegarNumero		#chama pegarNumero
		move $t0, $v0		#resgata opcao e salva em $t0
		
		#validacao da opcao
		slti $t3, $t0, 0	# se valor eh menor que 0, $t3=1
		bne $t3, $zero, main	# se $t3 != 0, volta pra main
		slti $t3, $t0, 10	# se valor eh maior que 9, $t3=1
		beq $t3, $zero, main	# se $t3 == 0, volta pra main		

		#excecoes de primeiro algarismo
		beq $t0, $zero, finish	#finaliza programa
		beq $t0, 9, Dec		#pula pra dec
		
		#pega o primeiro algarismo (tudo tem ao menos 1 algarismo)
		la $a0, p_num		#carrega string de pedir numero
		jal printarString	#printa a string
		jal pegarNumero		#pega o valor desse numero
		move $t1, $v0		#move o valor para $t1
		
		#acessa as contas
		beq $t0, 1, Soma	#pula pra soma
		beq $t0, 2, Sub		#pula pra sub
		beq $t0, 3, Div		#pula pra div
		beq $t0, 4, Mult	#pula pra mult
		beq $t0, 5, Exp		#pula pra exp
		beq $t0, 6, Fib		#pula pra fibonacci
		beq $t0, 7, Bin		#pula pra bin
		beq $t0, 8, Hex		#pula pra hex
		
	printarString:	#exibe a string que foi carregada e retorna
		li $v0, 4		
		syscall
		jr $ra
		
	pegarNumero:	#pega o valor de um inteiro e retorna
		li $v0, 5
		syscall
		jr $ra
	
	resultado:	#exibe o valor armazenado em $t3 e retorna
		ori $t4, $zero, 1 	#reseta $t4
		ori $t5, $zero, 1	#reseta $t5
		la $a0, e_resultado	#carrega string de exibicao
		jal printarString	#printa a string
		li $v0, 1		#exibicao de inteiros
		move $a0, $t3		#move o valor para $a0
		syscall			#printa o valor
		la $a0, e_quebra	#carrega string de quebrar (\n)
		jal printarString	#printa a string
		j main			#volta pro main
		
	Soma:				#soma
		la $a0, p_num		#carrega string de pedir numero
		jal printarString	#printa a string
		jal pegarNumero		#pega o valor desse numero
		move $t2, $v0		#move o valor para $t2
		add $t3, $t1, $t2	#calcula e salva em $t3
		j resultado		#exibe o resultado
	
	Sub:				#subtracao
		la $a0, p_num		#carrega string de pedir numero
		jal printarString	#printa a string
		jal pegarNumero		#pega o valor desse numero
		move $t2, $v0		#move o valor para $t2
		sub  $t3, $t1, $t2	#calcula e salva em $t3
		j resultado		#exibe o resultado
	
	Div:				#divisao
		la $a0, p_num		#carrega string de pedir numero
		jal printarString	#printa a string
		jal pegarNumero		#pega o valor desse numero
		move $t2, $v0		#move o valor para $t2
		div $t1, $t2		#calcula divisao
		mflo $t3		#move o resultado para $t3
		j resultado		#exibe o resultado
	
	Mult:				#multiplicacao
		la $a0, p_num		#carrega string de pedir numero
		jal printarString	#printa a string
		jal pegarNumero		#pega o valor desse numero
		move $t2, $v0		#move o valor para $t2
		mult $t1, $t2		#calcula multiplicacao
		mflo $t3		#move o resultado para $t3
		j resultado		#exibe o resultado
	
	Exp:				#exponenciacao
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
			
	Fib:				#fibonacci
		la $a0, p_num		#carrega string de pedir numero
		jal printarString	#printa a string
		ori $t3, $zero, 0	#zera resultado
		
		#Exibe 0 e 1 inciais da sequencia
		li $v0, 1		#exibicao de inteiros
		move $a0, $t3		#move o valor para $a0
		syscall			#printa o valor
		la $a0, e_espaco	#carrega string de espaco
		jal printarString	#printa a string
		
		add $t3, $t4, $zero	#primeira soma (0+1)
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
		
		add $t3, $t3, $t4	#segunda soma (1+1)
		calcFib:
			slt $t2, $t1, $t3	#se $t3>$t1, $t2=1
			beq $t1, $t3, resultado	#se $t3==$t1 -> resultado
			beq $t2, 1, resultado	#quebra looping se já atingiu o valor
			li $v0, 1		#exibicao de inteiros
			move $a0, $t3		#move o valor para $a0
			syscall			#printa o valor
			la $a0, e_espaco	#carrega string de espaco
			jal printarString	#printa a string
			ori $t5, $t3, 0		#salva resultado
			add $t3, $t3, $t4	#incrementa
			ori $t4, $t5, 0		#atualiza $t4
			j calcFib
			
	Bin:				#binario
		ori $t2, $zero, 2	#$t2 recebe 2
		ori $t4, $zero, 0	#$t4 recebe 0
		la $a0, e_resultado	#carrega a string de resultado
		jal printarString	#printa a string
		
	pushBin:			#push na pilha
		div $t1, $t2		#$t1 / $t2
		mfhi $t3		#move o resto para $t3
		mflo $t1		#move o quociente para $t1
		addiu $sp, $sp, -4	#da push na pilha
		sw $t3, ($sp)		#salva t3 na pilha
		add $t4, $t4, $t5	#incrementa contador (.length)
		bne $t1, 0, pushBin	#se t1 != 0, ainda ha calculos
		
	popBin:				#pop na pilha
		lw $t3, ($sp)		#salva topo da pilha em $t3
		addiu $sp, $sp, 4	#da pop na pilha
		li $v0, 1		#exibicao de inteiros
		move $a0, $t3		#move o valor para $a0
		syscall			#printa o valor
		sub $t4, $t4, $t5	#decrementa looping
		bne $t4, 0, popBin	#se ainda houver numeros, repete
		
		#return	
		la $a0, e_quebra	#carrega string de quebra
		jal printarString	#printa a string
		j main			#volta pro menu

	Hex:
		ori $t2, $zero, 16	#$t2 recebe 16
		ori $t4, $zero, 0	#$t4 recebe 0
		la $a0, e_resultado	#carrega string de resultado
		jal printarString	#printa a string
		
	pushHex:			#push na pilha
		div $t1, $t2		#$t1 / $t4
		mfhi $t3		#move o resto para $t3
		mflo $t1		#move o resultado para $t1
		addiu $sp, $sp, -4	#da push na pilha
		sw $t3, ($sp)		#salva t3
		add $t4, $t4, $t5	#incrementa contador (.length)
		bne $t1, 0, pushHex	#se t1 != 0, ainda ha calculos
		
	popHex:				#pop na pilha
		lw $t3, ($sp)		#salva em t3
		addiu $sp, $sp, 4	#da pop na pilha
		
		#se o pop corresponde a um char
		bge $t3, 10, showCharHex
		
		#se o pop corresponde a um numero
		blt $t3, 10, showHex
		
	showHex:
		li $v0, 1		#exibir inteiro
		move $a0, $t3		#move o valor para $a0
		syscall			#printa o valor
		sub $t4, $t4, $t5	#decrementa looping
		bne $t4, 0, popHex	#looping exibicao
		#return
		la $a0, e_quebra	#carrega string de quebra
		jal printarString	#printa a string
		j main			#volta pro menu
		
	showCharHex:
		beq $t3, 10, a		#printa: 10 -> A
		beq $t3, 11, bb		#printa: 11 -> B
		beq $t3, 12, c		#printa: 12 -> C
		beq $t3, 13, d		#printa: 13 -> D
		beq $t3, 14, e		#printa: 14 -> E
		beq $t3, 15, f		#printa: 15 -> F
		a: 	la $a0, e_a		#carrega "A"
			j showCharHexTest	#printa 
			
		bb: 	la $a0, e_b		#carrega "B"
			j showCharHexTest	#printa
			
		c: 	la $a0, e_c		#carrega "C"
			j showCharHexTest	#printa
			
		d: 	la $a0, e_d		#carrega "D"
			j showCharHexTest	#printa
			
		e: 	la $a0, e_e		#carrega "E"
			j showCharHexTest	#printa
			
		f: 	la $a0, e_f		#carrega "F"
			j showCharHexTest	#printa
			
	showCharHexTest:
		jal printarString	#printa a string carregada
		sub $t4, $t4, $t5	#decrementa looping
		bne $t4, 0, popHex	#repete se ha numero para exibicao
		
		#return
		la $a0, e_quebra	#carrega string de quebra
		jal printarString	#printa a string
		j main			#volta pro menu
		
	Dec:				#bin pra dec
		la $a0, p_num		#carrega string de pedir numero
		jal printarString	#printa a string

		#pega a string / entrada
		la $a0, vazio		#aponta pro espaco de 16
		li $a1, 16              #tamanho maximo 16 
		li $v0, 8               #pegar string
		syscall			#pega a string
		
		ori $t3, $zero, 0	#reseta a soma
		
		la $t1, vazio		#aponta pro endereco
		ori $t4, $zero, 16	#contador vai pra 16

	calcDec:
		lb $a0, ($t1)		#carrega o primeiro byte
		#se $a0 = 49 (1), se $a0 = 48 (0)
		#usa 48 pra conversao de tabela ascii
		blt $a0, 48, printarDec	#se for menor que 48, pula pra print
		add $t1, $t1, 1		#incrementa posicao
		sub $a0, $a0, 48	#subtrai pra converter
		sub $t4, $t4, 1		#decrementa contador
		beq $a0, 0, zero	#se achou 0 -> zero
		beq $a0, 1, um		#se achou 1 -> um
		j printarDec		#exibe
	
	zero:	#so retorna pra nao dar conflito com printarDec
		j calcDec
	
	um:
		sllv $t6, $t5, $t4	#faz o calculo
		add $t3, $t3, $t6	#acumula a soma
		move $a0, $t3		#move o resultado
		j calcDec	
			
	printarDec:
		#resultado foi acumulado no restante e agora é dividido por 2
		srlv $t3, $t3, $t4	#$t3 / 2^$t4
		#mostra resultado
		la $a0, e_resultado	#carrega string de resultado
		jal printarString	#printa a string
		move $a0, $t3		#move o resultado
		li $v0, 1		#print de inteiro
		syscall			#printa o valor
		la $a0, e_quebra	#carrega string de resultado
		jal printarString	#printa a string
		j main

	finish:	
		li, $v0, 10
		syscall