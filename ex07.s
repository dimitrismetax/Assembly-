.data
strings:  .asciiz  " "
message1: .asciiz  "Insert the numbers you want and insert '0' or press enter to stop the insertion. \n"
message2: .asciiz  "\nPress a number, to see the lowers of that which there are in the list.\n"
		.text

		.globl main
		.globl phase1
		.globl initlz
		.globl loop
		.globl end
		.globl phase2
		.globl phase3
		.globl return
		.globl loop1

main:
		addi $2, $0, 4
		la $4, message1
		syscall
		jal node_allocate 	#allocate 8 bytes
		sw $0,($v0) #insert 0 on dummy node
		sw $0,4($v0)
		la $s0,($v0) #	load address of dummy node in s0
		la $s1,($v0) #	load address of dummy node in s1

loop:	jal read_int #call of read int
		beq $v0,$0,phase1 #if x==0 end the insertion mode go to print mode
		slti $t0,$v0,0 #if x<0
		bne $t0,$0,phase1 #end the insertion mode go to print mode

		add $t0,$0,$v0 # t0=x
		beq $s0,$s1,initlz # go to initlz only once for the first insertion on list

		jal node_allocate #call malloc

		sw $t0,($v0) #place x in the data of the new node
		sw $0,4($v0) # set the nextptr =0
		la $t0,($v0) # load address of the new node on t0
		sw $t0,4($s1) # point to the last node
		la $s1,($v0) #change s1 to be on the last node
		j 	loop

phase1: addi $2,$0, 4
        la $4, message2
        syscall
        jal read_int #call read int
		add $s1,$0,$v0 # s1=x
		slti $t0,$s1,0 #check if x<0
		bne $t0,$0,exit #exit program if x <0
		lw $s2,4($s0) #load the first node of the list

phase2:
		add $a0,$0,$s2 #a0=s2
		add $a1,$0,$s1 #a1=s1
		jal search_list #call search list
		j phase1

exit:	addi $v0,$0,10 #program exit
		syscall

initlz:  	jal node_allocate #malloc

		sw $t0,($v0) #place the value that was read to the node
		la $t0,($v0) #load the address of the new node
		sw $t0,4($s0) #point to the new node with the dummy node
		la $s1,($v0) #load address of new node on s1

		j loop

read_int :
		addi $v0,$0,5
		syscall
		jr $ra

print_node:
		lw $t1,0($a0)
		slt $t0,$t1,$a1
		bne $t0,$0,end
		jr $ra

end:
        addi $v0,$0,1
		add $a0,$0,$t1
		syscall
		la $a0,strings
		addi $v0,$0,4
		syscall
		jr $ra

node_allocate:

		addi $v0,$0,9
		addi $a0,$0,8
		syscall
		jr $ra

search_list:

loop1:	addi $sp,$sp,-16
		sw  $a0,0($sp)
		sw  $a1,4($sp)
		sw  $ra,8($sp)

		beq $a0,$0,return
		slti $t0,$a0,0
		bne $t0,$0,return

		jal	print_node

		lw  $a0,0($sp)
		lw  $a1,4($sp)
		lw  $ra,8($sp)
		addi $sp,$sp,16

		lw $a0,4($a0)
		j loop1
return:	jr $ra
