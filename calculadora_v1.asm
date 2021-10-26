.data
#Strings usadas para pedir e exibir informacoes
	#p_ : pedir
	p_opcao: .asciiz "Insira a opcao: "
	p_num: .asciiz "Insira um numero: "
	p_base: .asciiz "Insira a base para converter: "
	#e_ : exibir
	e_quebra: .asciiz "\n"
	e_resultado: .asciiz "Resultado: "
	e_menu: .asciiz "1 - Soma\t2 - Sub\t\t3 - Div\n4 - Mult\t5 - Exp\t\t6 - Log (base 10)\n7 - Bin\t\t8 - Hex\t\t9 - Dec\n\t\t0 - Sair\n"
.text
	ori $t3, $zero, 0 	#carrega 0 em $t3 : auxiliar (recebe o resultado das contas) 
	ori $t4, $zero, 1	#carrega 0 em $t4 : controle de looping
	ori $t5, $zero, 1	#carrega 1 em $t5 : incremento
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
		slti $t3, $t0, 9		# se valor eh menor que 9, $t3=1
		beq $t3, $zero, main		# se $t3 == 0, volta pra main
		
		#acessa as contas
		beq $t0, $zero, finish		#finaliza programa
		beq $t0, 1, Soma		#pula pra soma
		beq $t0, 2, Sub			#pula pra sub
		beq $t0, 3, Div			#pula pra div
		beq $t0, 4, Mult		#pula pra mult
		beq $t0, 5, Exp			#pula pra exp
		beq $t0, 6, Log			#pula pra log
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
		
	Soma:				#faz a soma
		la $a0, p_num		#carrega string de pedir numero
		jal printarString	#printa a string
		jal pegarNumero		#pega o valor desse numero
		move $t1, $v0		#move o valor para $t1
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
		move $t1, $v0		#move o valor para $t1
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
		move $t1, $v0		#move o valor para $t1
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
		move $t1, $v0		#move o valor para $t1
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
		move $t1, $v0		#move o valor para $t1
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
			
	Log:
		la $a0, p_num		#carrega string de pedir numero
		jal printarString	#printa a string
		jal pegarNumero		#pega o valor desse numero
		move $t1, $v0		#move o valor para $t1
			
	Bin:
		la $a0, p_num		#carrega string de pedir numero
		jal printarString	#printa a string
		jal pegarNumero		#pega o valor desse numero
		move $t1, $v0		#move o valor para $t1
		
	Hex:
		la $a0, p_num		#carrega string de pedir numero
		jal printarString	#printa a string
		jal pegarNumero		#pega o valor desse numero
		move $t1, $v0		#move o valor para $t1
		
	Dec:
		la $a0, p_num		#carrega string de pedir numero
		jal printarString	#printa a string
		jal pegarNumero		#pega o valor desse numero
		move $t1, $v0		#move o valor para $t1
		
	finish:
		li, $v0, 10
		syscall 
