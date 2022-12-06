.data
table: .space 43
#static int *Prev = new int[45]={-1,-1,...,-1};
Prev: .word -1:45
#Prev: .word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
#static char *piece = new char[3];
piece: .space 3
#------------------------------------------------------
check1: .asciiz "\ncheck1\n"
check2: .asciiz "\ncheck2\n"
check3: .asciiz "\ncheck3\n"
check4: .asciiz "\ncheck4\n"
check5: .asciiz "\ncheck5\n"
test_piece: .asciiz "\npiece = "
endl:.asciiz"\n"
player1_lose1: .asciiz "Violation: Inappropriate column 3 times. Player 1 lose!\nCongratulations! Player 2 is the winner!!!\n"
player2_lose1: .asciiz "Violation: Inappropriate column 3 times. Player 2 lose!\nCongratulations! Player 1 is the winner!!!\n"
Undo_1: .asciiz "Player 1 is running out of UNDO move. Choose again!\n"
Undo_2: .asciiz "Player 2 is running out of UNDO move. Choose again!\n"
rand: .asciiz "Randomly choose the starting player: "
p1: .asciiz "Player 1.\n"
p2: .asciiz "Player 2.\n"
chooseXO: .asciiz "Please pick the piece (X or O) ? : "
invalid_piece: .asciiz "\nInvalid piece. Choose again!\n"
turn_p1: .asciiz"Turn player 1.\n(Press \'-5\' if Player 2 want to UNDO)\nSelect column: "
turn_p2: .asciiz"Turn player 2.\n(Press \'-5\' if Player 1 want to UNDO)\nSelect column: "
undo: .asciiz "Undo!\n"
empty_table: .asciiz "The table is empty, cannot UNDO. Choose again!\n"
Inappropriate_col: .asciiz "Inappropriate column! Choose again.\n\n"
full_col: .asciiz "Inappropriate move: column is full! Please choose again.\n\n"
draw: .asciiz  "DRAW!\n"
win_p1: .asciiz "\nPlayer 1 is the winner!!!\n"
win_p2: .asciiz "\nPlayer 2 is the winner!!!\n"

.text
main:
	
	#static int wrong_move_1 = 0 =s0;
	li $s0,0
	#static int wrong_move_2 = 0 =s1;
	li $s1,0
	#static int undo1 = 0 =s2;
	li $s2,0
	#static int undo2 = 0 =s3;
	li $s3,0
	#static int prev_Idx = -1 = s4;
	li $s4,0
	#static int key = 1 = s5
	li $s5,1	
	# Prev = s7
	la $s7,Prev
	jal init
	jal pick_Player
	jal printBoard	
	jal turn_switch
	#turn_switch -> line 312
	j end
	# Note : function should return value to $v1 after being called
#-------------------------------------------------------------------------
#this part only contain functions
fullColumn:
#parameter: (int col=$a0)
	#t0=table
	la $t0,table
	#$t0=table+col 
	add $t0,$t0,$a0
	#t2=table[col]
	lb $t2,0($t0)
	#if table[col]!=' ', goto return1
	bne $t2,' ',fullColumn_return1
	j fullColumn_return0
	fullColumn_return1:
		li $v0,1
		jr $ra
	fullColumn_return0:
		li $v0,0
		jr $ra
#-----------------------------------------
fullTable:	
	# t8=table
	la $t8,table
	#for (int i=0;i<6;i++)
	#t0=i
	li $t0,0
	for_i_table:
		#-------------		
			#for (int j=0;j<7;j++)
			#t2=j
			li $t2,0
			for_j_table:
				#-------------
				#print a[i*7+j]
				#t3=i*7
				mul $t3,$t0,7
				#t3+=j
				add $t3,$t3,$t2
				#print i*7+j				
				#t5=t8
				move $t5,$t8
				# t5 = table+(i*7+j)
				add $t5,$t5,$t3	
				#if (a[7 * i + j] == ' ') return 0;
				# a[7*i+j]= temp t6
				lb $t6,0($t5)
				beq $t6,' ',fullTable_return0
				
				j fullTable_return0_end
				fullTable_return0:
					li $v0,0
					jr $ra
				fullTable_return0_end:
				#-------------
				#j++
				addi $t2,$t2,1
				#temp t9=7
				li $t9,7
				slt $t1,$t2,$t9
				beq $t1,1,for_j_table
			for_j_table_end:	
		#-------------
		#i++
		addi $t0,$t0,1
		#temp t9=6
		li $t9,6
		slt $t1,$t0,$t9
		beq $t1,1,for_i_table
	for_i_table_end:
#return 1
li $v0,1
jr $ra
#-----------------------------------------
init:
	la $t1,table
	#count=t0
	li $t0,0
	init_loop:
		#-------------
		#temp t2='x'
		li $t2,' '
		#table[0]=t2
		sb $t2,0($t1)
		#-------------
		#count++
		addi $t0,$t0,1
		#table++
		addi $t1,$t1,1
		#temp t9=42
		li $t9,42
		#if count<42,goto loop
		slt $t5,$t0,$t9
		beq $t5,1,init_loop
	init_loop_end:
jr $ra
#-----------------------------------------

printBoard:
	#print('\n')
	la $a0,'\n'
	li $v0,11
	syscall
	# t8=table
	la $t8,table
	#for (int i=0;i<6;i++)
	#t0=i
	li $t0,0
	for_i:
		#-------------
		#print('|')
		la $a0,'|'
		li $v0,11
		syscall
			#for (int j=0;j<7;j++)
			#t2=j
			li $t2,0
			for_j:
				#-------------
				#print a[i*7+j]
				#t3=i*7
				mul $t3,$t0,7
				#t3+=j
				add $t3,$t3,$t2
				#print i*7+j
				#add $a0,$t3,$0
				#li $v0,1
				#syscall
				#t5=s1
				move $t5,$t8
				add $t5,$t5,$t3
				#print a[i*7+j]
				lb $a0,0($t5)
				li $v0,11
				syscall	
				#print(' ') if j!=6
				bne $t2,6,print_space
				j print_space_end
				print_space:
					#printing
					li $a0,' '
					li $v0,11
					syscall
				print_space_end:
						
				#-------------
				#j++
				addi $t2,$t2,1
				#temp t9=7
				li $t9,7
				slt $t1,$t2,$t9
				beq $t1,1,for_j
			for_j_end:
		#print('|')
		li $a0,'|'
		li $v0,11
		syscall
		#print endl
		la $a0,endl
		li $v0,4
		syscall
		
		#-------------
		#i++
		addi $t0,$t0,1
		#temp t9=6
		li $t9,6
		slt $t1,$t0,$t9
		beq $t1,1,for_i
	for_i_end:
	
	#i=t5
	li $t5,0
	#for (int i=0;i<2;i++)
	for_i2:
		#-------------
		#print(' ')
		li $a0,' '
		li $v0,11
		syscall
		#for (int j=0;j<7;j++)
		#j=t6
		li $t6,0
		for_j2:
			#-------------
			#if i(t5)==1, goto condition2
			beq $t5,1,condition2
			#if (i==0)			
			#print("- ")
			li $a0,'-'
			li $v0,11
			syscall
			li $a0,' '
			li $v0,11
			syscall			
			j condition2_end
			#if (i==1)
			condition2:
			#print(j)
			move $a0,$t6
			li $v0,1
			syscall
			#print(' ')
			li $a0,' '
			li $v0,11
			syscall
			condition2_end:
			#-------------
			#j++
			addi $t6,$t6,1
			# temp t0=7
			li $t0,7
			slt $t1,$t6,$t0
			beq $t1,1,for_j2
		for_j2_end:
		#print('\n')
		li $a0,'\n'
		li $v0,11
		syscall
		
		#-------------
		#i++
		addi $t5,$t5,1
		#temp t0=2
		li $t0,2
		slt $t1,$t5,$t0
		beq $t1,1,for_i2
	for_i2_end:
jr $ra
#-----------------------------------------
over_wrong:
#Note:
#static int wrong_move_1 = 0 =s0;
#static int wrong_move_2 = 0 =s1;
	#if (wrong_move_1 == 3)-> player1_lose announcement
	beq $s0,3,player1_lose
	j player1_lose_end
	player1_lose:
		#printing
		li $v0,4
		la $a0,player1_lose1
		syscall
		#return 1
		li $v0,1
		jr $ra
	player1_lose_end:
	
	#if (wrong_move_2 == 3)-> player2_lose announcement
	beq $s1,3,player2_lose
	j player2_lose_end
	player2_lose:
		#printing
		li $v0,4
		la $a0,player2_lose1
		syscall
		#return 1
		li $v0,1
		jr $ra
	player2_lose_end:
	
	#return 0
	li $v0,0
jr $ra


#-----------------------------------------
over_undo1:
# Note:
#static int undo1 = 0 =s2;
	#if (undo1 == 3)-> choose again announcement
	beq $s2,3,Undo1
	j Undo1_end
	Undo1:
		#printing
		li $v0,4
		la $a0,Undo_1
		syscall
		#return 1
		li $v1,1
		jr $ra
	Undo1_end:	
	#return 0
	li $v1,0
jr $ra
#-----------------------------------------
over_undo2:
#static int undo2 = 0 =s3;
	#if (undo2 == 3)-> choose again announcement
	beq $s3,3,Undo2
	j Undo2_end
	Undo2:
		#printing
		li $v0,4
		la $a0,Undo_2
		syscall
		#return 1
		li $v1,1
		jr $ra
	Undo2_end:
	#return 0
	li $v1,0
jr $ra
#-----------------------------------------
turn_switch:
# Note:
#static int wrong_move_1  =s0;
#static int wrong_move_2 =s1;
#static int undo1 =s2;
#static int undo2=s3;
#static int prev_Idx = s4;
#static int key  = s5
# Prev = s7
#init value
#int col = 0 = s6
li $s6,0
#table = t0
la $t0,table
#while(col!=-1)
while_col:
	#-------------
	#------------check1>
	#li $v0,4
	#la $a0,check1
	#syscall
	#------------check1>
	#if (key==1)
	beq $s5,1,key1
	bne $s5,1,key2
	j key1_end
	key1:
		#--------------------------------------------------key1>	
		#print("Turn player 1.\nSelect column: ");
		li $v0,4
		la $a0,turn_p1
		syscall
		# cin>>col
		li $v0,5
		syscall
		move $s6,$v0
		#if (col==-5)
		#----------------------------Undo_process1>
		beq $s6,-5,Undo_process1
		j Undo_process1_end
		Undo_process1:
			# if (over_undo2() == 1) continue;
			jal over_undo2
			beq $v1,1,while_col
			
			# if (Prev[0] != -1)
			#------------------------pr1>
			#temp t7=Prev[0]
			lw $t7,0($s7)
			bne $t7,-1,pr1
			j pr1_end
			pr1:
				 #cout << "Undo!\n";
				 li $v0,4
				 la $a0,undo
				 syscall
				 #a[Prev[0]] = ' ';
				 #a+Prev[0]= temp t2
				 la $t0,table
				 add $t2,$t0,$t7
				 # temp t3=' '
				 li $t3,' '
				 sb $t3,0($t2)
				 #undo2++
				 addi $s3,$s3,1
				 #printBoard(a)
				 jal printBoard
				 #Prev--
				 addi $s7,$s7,-4
				 #key=2
				 li $s5,2
				 # continue
				 j while_col				 
			pr1_end:
			#------------------------pr1>
			# cout << "The table is empty, cannot UNDO. Choose again!\n";
			li $v0,4
			la $a0,empty_table
			syscall
		Undo_process1_end:
		#----------------------------Undo_process1>
		
		#Exception 1
		#if (col < 0 || col > 6)->goto Exception1_1
		#------------------------------------------Exc1_1>
		slt $t1,$s6,$0
		beq $t1,1,Exception1_1
		#temp t4=6
		li $t4,6
		slt $t1,$t4,$s6
		beq $t1,1,Exception1_1
		
		j Exception1_1_end
		Exception1_1:
			#wrong_move_1++;
			addi $s0,$s0,1
			#if (over_wrong() == 1) break;
			jal over_wrong
			#beq $v0,1,while_col_end
			beq $v0,1,end
			#cout << "Inappropriate column! Choose again.\n\n";
			li $v0,4
			la $a0,Inappropriate_col
			syscall
			#continue;
			j while_col			
		Exception1_1_end:
		#------------------------------------------Exc1_1>
		
		#Exception2
		# if (fullColumn(a, col) == 1), goto Exception2_1
		#------------------------------------Exc2_1>
		#parameter int col = a0
		move $a0,$s6
		jal fullColumn
		beq $v0,1,Exception2_1
		
		j Exception2_1_end
		Exception2_1:
			# wrong_move_1++;
			addi $s0,$s0,1
			#if (over_wrong() == 1) break;
			jal over_wrong
			#beq $v0,1,while_col_end
			beq $v0,1,end
			#cout << "Inappropriate move: column is full! Please choose again.\n\n";
			li $v0,4
			la $a0,full_col
			syscall
			#continue;
			j while_col
		Exception2_1_end:
		#------------------------------------Exc2_1>
		#switch key to 2
		li $s5,2
		#------------check2>
		#li $v0,4
		#la $a0,check2
		#syscall
		#------------check2>
		#fill in the table
		#------------------------------------table_fill>
		#int row = 5 =temp t5
		li $t5,5
		#while (a[row * 7 + col] != ' ') row--;
		#--------------------------------while_row>
		#temp t4=row*7
		mul $t4,$t5,7
		#t4+=col
		add $t4,$t4,$s6
		#a+row*7+col =temp t6
		la $t0,table
		add $t6,$t0,$t4
		#a[row*7+col] = temp t8
		lb $t8,0($t6)
		
		bne $t8,' ',while_row
		j while_row_end
		while_row:
			#--------------------
			#row--
			addi $t5,$t5,-1
			#--------------------
			#while conditioning part
			#temp t4=row*7
			mul $t4,$t5,7
			#t4+=col
			add $t4,$t4,$s6
			#a+row*7+col =temp t6
			la $t0,table
			add $t6,$t0,$t4
			#a[row*7+col] = temp t8
			lb $t8,0($t6)		
			bne $t8,' ',while_row
		while_row_end:
		#--------------------------------while_row>
		#a[row * 7 + col] = piece[1];
		#--------------------assign>
		#temp t4=row*7
		mul $t4,$t5,7
		#t4+=col
		add $t4,$t4,$s6
		#a+row*7+col =temp t6
		la $t0,table
		add $t6,$t0,$t4
		# piece = temp t9
		la $t9,piece
		#piece[1]=temp t8
		lb $t8,1($t9)
		#------------check piece>
		#move $a0,$t8
		#li $v0,11
		#syscall
		#------------check piece>
		#assign to a[row * 7 + col]
		sb $t8,0($t6)
		#--------------------assign>		
		#------------------------------------table_fill>
		#------------check3>
		#li $v0,4
		#la $a0,check3
		#syscall
		#------------check3>
		#Prev update
		#-------------------------prevUpdate>
		#Prev++
		addi $s7,$s7,4
		#prev_Idx = row * 7 + col;
		move $s4,$t4
		#Prev[0] = prev_Idx;
		sw $s4,0($s7)
		#--------------------------prevUpdate> 
		
		#Wincheck
		#-------------------------winCheck>
		li $a1,1
		jal winCheck
		#-------------------------winCheck>
		
		#printBoard
		jal printBoard
		#------------check4>
		#li $v0,4
		#la $a0,check4
		#syscall
		#------------check4>
		#Exception3		
		#if (fullTable(a) == 1) {cout << "DRAW!\n"; break;}
		#------------------------------------Exc3_1>            
		jal fullTable
		beq $v0,1,Exception3_1
		j Exception3_1_end
		Exception3_1:
			#cout << "DRAW!\n";
			li $v0,4
			la $a0,draw
			syscall
			#break;
			#j while_col_end
			j end
		Exception3_1_end:		
		#------------------------------------Exc3_1>
		#------------check5>
		#li $v0,4
		#la $a0,check5
		#syscall
		#------------check5>
		j key2_end
		#--------------------------------------------------key1>		
	key1_end:
	
	#if (key==2)
	beq $s6,2,key2
	j key2_end
	key2:
		#-------------
		#--------------------------------------------------key2>	
		#print("Turn player 2.\nSelect column: ");
		li $v0,4
		la $a0,turn_p2
		syscall
		# cin>>col
		li $v0,5
		syscall
		move $s6,$v0
		#if (col==-5)
		#----------------------------Undo_process2>
		beq $s6,-5,Undo_process2
		j Undo_process2_end
		Undo_process2:
			# if (over_undo1() == 1) continue;
			jal over_undo1
			beq $v1,1,while_col
			
			# if (Prev[0] != -1)
			#------------------------pr1>
			#temp t7=Prev[0]
			lw $t7,0($s7)
			bne $t7,-1,pr2
			j pr2_end
			pr2:
				 #cout << "Undo!\n";
				 li $v0,4
				 la $a0,undo
				 syscall
				 #a[Prev[0]] = ' ';
				 la $t0,table
				 #a+Prev[0]= temp t2
				 add $t2,$t0,$t7
				 # temp t3=' '
				 li $t3,' '
				 sb $t3,0($t2)
				 #undo1++
				 addi $s2,$s2,1
				 #printBoard(a)
				 jal printBoard
				 #Prev--
				 addi $s7,$s7,-4
				 #key=1
				 li $s5,1
				 # continue
				 j while_col				 
			pr2_end:
			#------------------------pr1>
			# cout << "The table is empty, cannot UNDO. Choose again!\n";
			li $v0,4
			la $a0,empty_table
			syscall
		Undo_process2_end:
		#----------------------------Undo_process2>
		
		#Exception 1
		#if (col < 0 || col > 6)->goto Exception1_2
		#------------------------------------------Exc1_2>
		slt $t1,$s6,$0
		beq $t1,1,Exception1_2
		#temp t4=6
		li $t4,6
		slt $t1,$t4,$s6
		beq $t1,1,Exception1_2
		
		j Exception1_2_end
		Exception1_2:
			#wrong_move_2++;
			addi $s1,$s1,1
			#if (over_wrong() == 1) break;
			jal over_wrong
			#beq $v0,1,while_col_end
			beq $v0,1,end
			#cout << "Inappropriate column! Choose again.\n\n";
			li $v0,4
			la $a0,Inappropriate_col
			syscall
			#continue;
			j while_col			
		Exception1_2_end:
		#------------------------------------------Exc1_2>
		
		#Exception2
		# if (fullColumn(a, col) == 1), goto Exception2_2
		#------------------------------------Exc2_2>
		#parameter int col = a0
		move $a0,$s6
		jal fullColumn
		beq $v0,1,Exception2_2
		
		j Exception2_2_end
		Exception2_2:
			# wrong_move_2++;
			addi $s1,$s1,1
			#if (over_wrong() == 1) break;
			jal over_wrong
			#beq $v0,1,while_col_end
			beq $v0,1,end
			#cout << "Inappropriate move: column is full! Please choose again.\n\n";
			li $v0,4
			la $a0,full_col
			syscall
			#continue;
			j while_col
		Exception2_2_end:
		#------------------------------------Exc2_2>
		#switch key to 1
		li $s5,1
		
		#fill in the table
		#------------------------------------table_fill>
		#int row = 5 =temp t5
		li $t5,5
		#while (a[row * 7 + col] != ' ') row--;
		#--------------------------------while_row2>
		#temp t4=row*7
		mul $t4,$t5,7
		#t4+=col
		add $t4,$t4,$s6
		#a+row*7+col =temp t6
		la $t0,table
		add $t6,$t0,$t4
		#a[row*7+col] = temp t8
		lb $t8,0($t6)
		
		bne $t8,' ',while_row2
		j while_row2_end
		while_row2:
			#--------------------
			#row--
			addi $t5,$t5,-1
			#--------------------
			#while conditioning part
			#temp t4=row*7
			mul $t4,$t5,7
			#t4+=col
			add $t4,$t4,$s6
			#a+row*7+col =temp t6
			la $t0,table
			add $t6,$t0,$t4
			#a[row*7+col] = temp t8
			lb $t8,0($t6)		
			bne $t8,' ',while_row2
		while_row2_end:
		#--------------------------------while_row2>
		#a[row * 7 + col] = piece[2];
		#--------------------assign2>
		#temp t4=row*7
		mul $t4,$t5,7
		#t4+=col
		add $t4,$t4,$s6
		#a+row*7+col =temp t6
		la $t0,table
		add $t6,$t0,$t4
		# piece = temp t9
		la $t9,piece
		#piece[2]=temp t8
		lb $t8,2($t9)
		#assign to a[row * 7 + col]
		sb $t8,0($t6)
		#--------------------assign2>		
		#------------------------------------table_fill>
		
		#Prev update
		#-------------------------prevUpdate>
		#Prev++
		addi $s7,$s7,4
		#prev_Idx = row * 7 + col;
		move $s4,$t4
		#Prev[0] = prev_Idx;
		sw $s4,0($s7)
		#--------------------------prevUpdate> 
		
		#Wincheck
		#-------------------------winCheck>
		#we will do this function later
		li $a1,2
		jal winCheck
		#-------------------------winCheck>
		
		#printBoard
		jal printBoard
		#Exception3		
		#if (fullTable(a) == 1) {cout << "DRAW!\n"; break;}
		#------------------------------------Exc3_2>            
		jal fullTable
		beq $v0,1,Exception3_2
		j Exception3_2_end
		Exception3_2:
			#cout << "DRAW!\n";
			li $v0,4
			la $a0,draw
			syscall
			#break;
			#j while_col_end
			j end
		Exception3_2_end:		
		#------------------------------------Exc3_2>
		#--------------------------------------------------key2>		
		#-------------
	key2_end:
	#-------------
	bne $s6,-1,while_col
while_col_end:	
jr $ra
#-----------------------------------------
pick_Player:
# Note:
# key = s5
	#char temp=' ' =t2
	li $t2,' '
	#printing("Randomly choose the starting player: ");
	li $v0,4
	la $a0,rand
	syscall
	#random = t3 
	#---------------
	# we will get random number from 0 to (2-1), return to $a0
	li $a1,2
	li $v0,42
	syscall
	#random=a0+1
	addi $t3,$a0,1
	
	#---------------
	beq $t3,1,random1
	bne $t3,1,random2
	j random1_end
	random1:
		#-------------------1>
		#printing("Player 1.\n")
		li $v0,4
		la $a0,p1
		syscall
		#key=1
		li $s5,1
		# while (temp != 'x' && temp != 'o')
		#------------------------------------#
		#---------------------------
		# conditioning part
		#1st condition
		bne $t2,'x',second_cond1
		j while_xo1_end
		second_cond1:
			bne $t2,'o',while_xo1
			j while_xo1_end
	
		j while_xo1_end
		#---------------------------
		while_xo1:
			#-------------------
			#printing("Please pick the piece (X or O) ? : ")
			li $v0,4
			la $a0,chooseXO
			syscall
			#cin>>temp
			li $v0,12
			syscall
			move $t2,$v0
			# piece = t4
			la $t4,piece
			#  if (temp == 'x'),...else if (temp == 'o'),... else ...
			#<--------------------->
			# temp 'x' = t5
			li $t5,'x'
			# temp 'o' = t6
			li $t6,'o'
			beq $t2,'x',temp1x
			j temp1x_end
			
			#if (temp == 'x')
			temp1x:
				#-------------
				# piece[1] = 'x';
				la $t4,piece
				sb $t5,1($t4)
                		#piece[2] = 'o';
				sb $t6,2($t4)
				#-------------
			j else1_end
			temp1x_end:
		
			beq $t2,'o',temp1o
			j temp1o_end
			
			#else if (temp == 'o')	
			temp1o:
				#-------------
				#piece[1] = 'o';
				sb $t6,1($t4)
                		#piece[2] = 'x';
                		sb $t5,2($t4)
				#-------------
			j else1_end
			temp1o_end:
		
			#else
			else1:
				#-------------
				#print("Invalid piece. Choose again!\n")
				li $v0,4
				la $a0,invalid_piece
				syscall
				#-------------
			else1_end:
			#<--------------------->
			#-------------------
			# conditioning part
			bne $t2,'x',second_cond_in1
			j while_xo1_end
			second_cond_in1:
				bne $t2,'o',while_xo1
				j while_xo1_end
		#---------------------------
		while_xo1_end:
		#------------------------------------#
		
		#-------------------1>		
	random1_end:
	
	beq $t3,2,random2
	j random2_end
	random2:
		#-------------------2>
		#printing("Player 2.\n")
		li $v0,4
		la $a0,p2
		syscall
		#key=2
		li $s5,2
		# while (temp != 'x' && temp != 'o')
		#------------------------------------#
		#---------------------------
		# conditioning part
		#1st condition
		bne $t2,'x',second_cond2
		j while_xo2_end
		second_cond2:
			bne $t2,'o',while_xo2
			j while_xo2_end
	
		j while_xo2_end
		#---------------------------
		while_xo2:
			#-------------------
			#printing("Please pick the piece (X or O) ? : ")
			li $v0,4
			la $a0,chooseXO
			syscall
			#cin>>temp
			li $v0,12
			syscall
			move $t2,$v0
			# piece = t4
			la $t4,piece
			#  if (temp == 'x'),...else if (temp == 'o'),... else ...
			#<--------------------->
			# temp 'x' = t5
			li $t5,'x'
			# temp 'o' = t6
			li $t6,'o'
			beq $t2,'x',temp2x
			j temp2x_end
			
			#if (temp == 'x')
			temp2x:
				#-------------
				# piece[1] = 'o';
				sb $t6,1($t4)
                		#piece[2] = 'x';
				sb $t5,2($t4)
				#-------------
			j else2_end
			temp2x_end:
		
			beq $t2,'o',temp2o
			j temp2o_end
			
			#else if (temp == 'o')	
			temp2o:
				#-------------
				#piece[1] = 'x';
				sb $t5,1($t4)
                		#piece[2] = 'o';
                		sb $t6,2($t4)
				#-------------
			j else2_end
			temp2o_end:
		
			#else
			else2:
				#-------------
				#print("Invalid piece. Choose again!\n")
				li $v0,4
				la $a0,invalid_piece
				syscall
				#-------------
			else2_end:
			#<--------------------->
			#-------------------
			# conditioning part
			bne $t2,'x',second_cond_in2
			j while_xo2_end
			second_cond_in2:
				bne $t2,'o',while_xo2
				j while_xo2_end
		#---------------------------
		while_xo2_end:
		#------------------------------------#
		
		#-------------------2>
	random2_end:
jr $ra
#-----------------------------------------
winCheck:
#init value
#table = t0
la $t0,table
	#for (int r = 0; r < 6; r++)
	# r = temp t5
	li $t5,0
	for_r:
		#------------------------------------------------------------------for_r>
		#for (int c = 0; c < 7; c++)
		# c = temp t6
		li $t6,0
		for_c:
			#----------------------------------------------------------for_c>
			# 1. check null space
			#   if (a[r * 7 + c] == ' ') continue:
			#-------------------------------null_space>
			#temp t3=r*7+c
			mul $t3,$t5,7
			add $t3,$t3,$t6
			#temp t4 = table + (r*7+c)
			la $t0,table
			add $t4,$t0,$t3
			#temp t7 = table[r*7+c]
			lb $t7,0($t4)
			beq $t7,' ',check_null
			
			j check_null_end
			check_null:
				#c++
				addi $t6,$t6,1
				#continue
				j for_c
			check_null_end:
			#-------------------------------null_space>			
			# char cur = a[r * 7 + c] = t7
			
			# 2. check vertically to Upper tokens
			#-------------------------------------------------------------cond1>
			#if (r + 3 < 6) &&  (a[(r + 1) * 7 + c] == cur) 
			# && if (a[(r + 2) * 7 + c] == cur) &&  if (a[(r + 3) * 7 + c] == cur)
			#if (r + 3 < 6)
			# temp t3= r+3
			addi $t3,$t5,3
			#temp t4=6
			li $t4,6
			slt $t1,$t3,$t4
			beq $t1,1,cond1_1
			
			j cond1_1_end
			cond1_1:
				#if (a[(r + 1) * 7 + c] == cur) 
				#temp t3=(r+1)*7+c
				addi $t3,$t5,1
				mul $t3,$t3,7
				add $t3,$t3,$t6
				#temp t4 = table + ((r+1)*7+c)
				la $t0,table
				add $t4,$t0,$t3
				#a[(r+1)*7+c]= temp t8
				lb $t8,0($t4)
				beq $t8,$t7,cond1_2
				
				j cond1_2_end
				cond1_2:
					# if (a[(r + 2) * 7 + c] == cur)
					#temp t3=(r+2)*7+c
					addi $t3,$t5,2
					mul $t3,$t3,7
					add $t3,$t3,$t6
					#temp t4 = table + ((r+2)*7+c)
					la $t0,table
					add $t4,$t0,$t3
					#a[(r+2)*7+c]= temp t8
					lb $t8,0($t4)
					beq $t8,$t7,cond1_3
					
					j cond1_3_end
					cond1_3:
						#  if (a[(r + 3) * 7 + c] == cur)
						#temp t3=(r+2)*7+c
						addi $t3,$t5,3
						mul $t3,$t3,7
						add $t3,$t3,$t6
						#temp t4 = table + ((r+3)*7+c)
						la $t0,table
						add $t4,$t0,$t3
						#a[(r+3)*7+c]= temp t8
						lb $t8,0($t4)
						beq $t8,$t7,cond1_4
						
						j cond1_4_end
						cond1_4:							
							# if a1=1 ->p1 win else p2 win
							beq $a1,1,p1_win
							beq $a1,2,p2_win
						cond1_4_end:
						
					cond1_3_end:
					
				cond1_2_end:
				
			cond1_1_end:	
			#-------------------------------------------------------------cond1>
			
			# 3. check horizontally to right tokens
			#-------------------------------------------------------------cond2>
			#  if (c + 3 < 7) && (a[(r)*7 + c + 1] == cur)
                	# && (a[(r)*7 + c + 2] == cur) && (a[(r)*7 + c + 3] == cur)
                	#  if (c + 3 < 7)
                	# temp t3 = c + 3
                	addi $t3,$t6,3
                	#temp t4=7
                	li $t4,7
                	slt $t1,$t3,$t4
                	beq $t1,1,cond2_1
                	
                	j cond2_1_end
                	cond2_1:
                		# if (a[(r)*7 + c + 1] == cur)
                		#temp t3=(r)*7+c+1
				mul $t3,$t5,7
				add $t3,$t3,$t6
				addi $t3,$t3,1
				#temp t4 = table + ((r)*7+c+1)
				la $t0,table
				add $t4,$t0,$t3
				#a[(r+1)*7+c]= temp t8
				lb $t8,0($t4)
				beq $t8,$t7,cond2_2
				
				j cond2_2_end
				cond2_2:
					# if (a[(r)*7 + c + 2] == cur)
					#temp t3=(r)*7+c+2
					mul $t3,$t5,7
					add $t3,$t3,$t6
					addi $t3,$t3,2
					#temp t4 = table + ((r)*7+c+2)
					la $t0,table
					add $t4,$t0,$t3
					#a[(r+1)*7+c]= temp t8
					lb $t8,0($t4)
					beq $t8,$t7,cond2_3
					
					j cond2_3_end
					cond2_3:
						# if (a[(r)*7 + c + 3] == cur)
						#temp t3=(r)*7+c+2
						mul $t3,$t5,7
						add $t3,$t3,$t6
						addi $t3,$t3,3
						#temp t4 = table + ((r)*7+c+3)
						la $t0,table
						add $t4,$t0,$t3
						#a[(r)*7+c+3]= temp t8
						lb $t8,0($t4)
						beq $t8,$t7,cond2_4
					
						j cond2_4_end
						cond2_4:
							# if a1=1 ->p1 win else p2 win
							beq $a1,1,p1_win
							beq $a1,2,p2_win
						cond2_4_end:
					cond2_3_end:					
				cond2_2_end:
                	cond2_1_end:
                	#-------------------------------------------------------------cond2>
                	
                	# 4. check diagonally Up-Left
                	#-------------------------------------------------------------cond3>
                	# if (r + 3 < 6) && (c - 3 >= 0)
                	#&& (a[(r + 1) * 7 + c - 1] == cur) && (a[(r + 2) * 7 + c - 2] == cur)
                        #&& (a[(r + 3) * 7 + c - 3] == cur)
                        
                        # if (r + 3 < 6) 
                        # temp t3 = r + 3
                        addi $t3,$t5,3
                        # temp t4 = 6
                        li $t4,6
                        slt $t1,$t3,$t4
                        beq $t1,1,cond3_1
                        
                        j cond3_1_end
                        cond3_1:
                        	# if (c - 3 >= 0)
                        	# temp t3 = c - 3
                        	addi $t3,$t6,-3
                        	bge $t3,0,cond3_2
                        	
                        	j cond3_2_end
                        	cond3_2:
                        		#(a[(r + 1) * 7 + c - 1] == cur)
                        		#temp t3=(r+1)*7+c -1
					addi $t3,$t5,1
					mul $t3,$t3,7
					add $t3,$t3,$t6
					addi $t3,$t3,-1
					#temp t4 = table + ((r+1)*7+c-1)
					la $t0,table
					add $t4,$t0,$t3
					#a[(r+1)*7+c-1]= temp t8
					lb $t8,0($t4)
					beq $t8,$t7,cond3_3
					
					j cond3_3_end
					cond3_3:
						# if (a[(r + 2) * 7 + c - 2] == cur)
						#temp t3=(r+2)*7+c -2
						addi $t3,$t5,2
						mul $t3,$t3,7
						add $t3,$t3,$t6
						addi $t3,$t3,-2
						#temp t4 = table + ((r+2)*7+c-2)
						la $t0,table
						add $t4,$t0,$t3
						#a[(r+2)*7+c-2]= temp t8
						lb $t8,0($t4)
						beq $t8,$t7,cond3_4
						
						j cond3_4_end
						cond3_4:
							# if (a[(r + 3) * 7 + c - 3] == cur)
							#temp t3=(r+3)*7+c - 3
							addi $t3,$t5,3
							mul $t3,$t3,7
							add $t3,$t3,$t6
							addi $t3,$t3,-3
							#temp t4 = table + ((r+3)*7+c-3)
							la $t0,table
							add $t4,$t0,$t3
							#a[(r+3)*7+c-3]= temp t8
							lb $t8,0($t4)
							beq $t8,$t7,cond3_5
							
							j cond3_5_end
							cond3_5:
								# if a1=1 ->p1 win else p2 win
								beq $a1,1,p1_win
								beq $a1,2,p2_win
							cond3_5_end:
						cond3_4_end:
						
					cond3_3_end:
                        	cond3_2_end:                        	
                        cond3_1_end:
                	#-------------------------------------------------------------cond3>
                	
                	# 5 . check diagonally Up-Right
                	#-------------------------------------------------------------cond4>
                	# if (r + 3 < 6) && (c + 3 < 7) &&
                	# a[(r + 1) * 7 + c + 1] == cur) && (a[(r + 2) * 7 + c + 2] == cur)
                        # $$ (a[(r + 3) * 7 + c + 3] == cur)
                	
                	# if (r + 3 < 6)
                	# temp t3 = r+3
                	addi $t3,$t5,3
                	# temp t4= 6
                	li $t4,6
                	slt $t1,$t3,$t4
                	beq $t1,1,cond4_1
                	
                	j cond4_1_end
                	cond4_1:
                		# if (c + 3 < 7)
                		# temp t3 = c+3
                		addi $t3,$t6,3
                		# temp t4 = 7
                		li $t4,7
                		slt $t1,$t3,$t4
                		beq $t1,1,cond4_2
                		
                		j cond4_2_end
                		cond4_2:
                			# if (a[(r + 1) * 7 + c + 1] == cur)
                        		#temp t3=(r+1)*7+c + 1
					addi $t3,$t5,1
					mul $t3,$t3,7
					add $t3,$t3,$t6
					addi $t3,$t3,1
					#temp t4 = table + ((r+1)*7+c+1)
					la $t0,table
					add $t4,$t0,$t3
					#a[(r+1)*7+c+1]= temp t8
					lb $t8,0($t4)
					beq $t8,$t7,cond4_3
					
					j cond4_3_end
					cond4_3:
						# if (a[(r + 2) * 7 + c + 2] == cur)
						#temp t3=(r+2)*7+c +2
						addi $t3,$t5,2
						mul $t3,$t3,7
						add $t3,$t3,$t6
						addi $t3,$t3,2
						#temp t4 = table + ((r+2)*7+c+2)
						la $t0,table
						add $t4,$t0,$t3
						#a[(r+2)*7+c+2]= temp t8
						lb $t8,0($t4)
						beq $t8,$t7,cond4_4
						
						j cond4_4_end
						cond4_4:
							# if (a[(r + 3) * 7 + c + 3] == cur)
							#temp t3=(r+3)*7+c + 3
							addi $t3,$t5,3
							mul $t3,$t3,7
							add $t3,$t3,$t6
							addi $t3,$t3,3
							#temp t4 = table + ((r+3)*7+c+3)
							la $t0,table
							add $t4,$t0,$t3
							#a[(r+3)*7+c+3]= temp t8
							lb $t8,0($t4)
							beq $t8,$t7,cond4_5
							
							j cond4_5_end
							cond4_5:
								# if a1=1 ->p1 win else p2 win
								beq $a1,1,p1_win
								beq $a1,2,p2_win
							cond4_5_end:
						cond4_4_end:						
					cond4_3_end:
                		cond4_2_end:
                	cond4_1_end:
                	
                	#-------------------------------------------------------------cond4>
			#----------------------------------------------------------for_c>
			#c++
			addi $t6,$t6,1
			#temp t2 = 7
			li $t2,7
			# if c<7, goto for_c
			slt $t1,$t6,$t2
			beq $t1,1,for_c
		for_c_end:
		#----------------------------------------------------------------for_r>
		#r++
		addi $t5,$t5,1
		# temp t2 = 6
		li $t2,6
		# if r<6, goto for_r
		slt $t1,$t5,$t2
		beq $t1,1,for_r
	for_r_end:
	# Winning announcment
	#---------------------------------------------winning>
	j p1_win_end	
	p1_win:
		jal printBoard
		#printString("Player ... is the winner!!!\n");
		#remember to check this one again
		li $v0,4
		la $a0,win_p1
		syscall
		j end
	p1_win_end:
	
	j p2_win_end
	p2_win:
		jal printBoard
		#printString("Player ... is the winner!!!\n");
		#remember to check this one again
		li $v0,4
		la $a0,win_p2
		syscall
		j end
	p2_win_end:
	#---------------------------------------------winning>
#return 0
li $v1,0
jr $ra
#-----------------------------------------------------------------------------------
end:
li $v0,10
syscall
