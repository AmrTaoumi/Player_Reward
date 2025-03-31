.globl check_reward,	generate_reward
check_reward:
	addi 	$sp,	$sp,	-4	# allocate memory in the stack
	sw   	$ra,	0($sp)	#save the address in the stack
	#if position of P not equal to position of reward, jump to reward_end, else add 5 to the score
	bne  	$s0,	$s2,	reward_end	
	bne  	$s1,	$s3,	reward_end
	addi 	$s5,	$s5,	5	# Add 5 to score
	beq  	$s5,	100,	collided #when score is 100, jump to collided to end the game
	jal  	generate_reward	# generate new reward position
reward_end:
	lw   	$ra,	0($sp)	#load address from the stack
	addi 	$sp,	$sp,	4 #restore the stack
	jr   	$ra #jump back to the caller
	
generate_reward:
	addi 	$sp,	$sp,	-4 # allocate memory in the stack
	sw   	$ra,	0($sp)	#save the address in the stack
	li   	$a1,	7	# load 7 as higher bound 
	li   	$v0,	42	# syscall 42 to generate random number with range from 0 to higher bound
	syscall 

	add  	$a0,	$a0,	$s0 # add row of P to the random number
	div  	$a0,	$a0,	7	# divide by seven
	mfhi 	$t0		# store the remainder in $t0
	move 	$s2,	$t0	# move to reward row
	addi 	$s2,	$s2,	1 # offset by 1
	
	
	li   	$v0,	42 	# syscall 42 to generate random number with range from 0 to higher bound
	syscall	
	add  	$a0,	$a0,	$s0	# add column of P to the random number
	div  	$a0,	$a0,	7	# divide by seven
	mfhi 	$t0		# store the remainder in $t0
	move 	$s3,	$t0 	# move to reward column
	addi 	$s3,	$s3,	1	# offset by 1
	
	lw   	$ra,	0($sp)	#load the address from the stack
	addi 	$sp,	$sp,	4	#restore the stack
	jr   	$ra	# jump back to the caller
