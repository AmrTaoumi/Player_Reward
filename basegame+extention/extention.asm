.globl generate_enemy,	update_enemy,	check_enemy_collisions,	print_enemy

generate_enemy:
	addi 	$sp,	$sp,	-4 # allocating memory to the stack
	sw   	$ra,	0($sp) #save the address in the stack
	
	
enemy_position_loop:
	li   	$a1,	7	# Range for random number
	li   	$v0,	42	# Random number syscall
	syscall
	addi 	$a0,	$a0,	1	# Add 1 to avoid border
	move 	$s6,	$a0	# enemy row
	
	li   	$v0,	42	# syscall for random number with higher bound
	syscall		#syscall
	addi 	$a0,	$a0,	1	# offset by 1
	move 	$s7,	$a0	# enemy column
	
	# Check if enemy is on player
	beq  	$s6,	$s0,	enemy_position_loop 
	beq  	$s7,	$s1,	enemy_position_loop
	
	# Check if enemy is on reward
	beq  	$s6,	$s2,	enemy_position_loop
	beq  	$s7,	$s3,	enemy_position_loop
	
	lw   	$ra,	0($sp)  #load address from stack
	addi 	$sp,	$sp,	4 #restore the stack
	jr   	$ra #jump to the address

update_enemy:
	addi 	$sp,	$sp,	-4 # allocating memory to the stack
	sw   	$ra,	0($sp) #save the address in the stack
	
	move 	$t8,	$s6	# Backup enemy row
	move 	$t9,	$s7	# Backup enemy column
	

	slt  	$t0,	$s6,	$s0	#  enemy row < player row --> t0 = 1
	bne  	$t0,	$zero,	enemy_move_down
	sgt  	$t0,	$s6,	$s0	#  enemy row > player row --> $t0 = 1
	bne  	$t0,	$zero,	enemy_move_up
	j	check_enemy_column	# Same row,	check column
	
enemy_move_down:
	addi 	$s6,	$s6,	1	# Move enemy down
	j	check_enemy_collisions
	
enemy_move_up:
	addi 	$s6,	$s6,	-1	# Move enemy up
	j	check_enemy_collisions
	
check_enemy_column:
	slt  	$t0,	$s7,	$s1	#  if enemy column < player column --> $t0 = 1
	bne  	$t0,	$zero,	enemy_move_right
	sgt  	$t0,	$s7,	$s1	#  if enemy column > player column --> $t0 = 1
	bne  	$t0,	$zero,	enemy_move_left
	j	check_enemy_collisions	# check collision
	
enemy_move_right:
	addi 	$s7,	$s7,	1	# Move enemy right
	j	check_enemy_collisions
	
enemy_move_left:
	addi 	$s7,	$s7,	-1	# Move enemy left
	
check_enemy_collisions:
	# check if enemy is on border
	beq  	$s6,	0,	revert_move
	beq  	$s7,	0,	revert_move
	beq  	$s6,	8,	revert_move
	beq  	$s7,	8,	revert_move
	
	# Check if enemy is trying to move onto reward
	beq  	$s6,	$s2,	check_reward_col
	j	check_player_collision
	
check_reward_col:
	beq  	$s7,	$s3,	revert_move	# Enemy is trying to move onto reward
	j	check_player_collision
	
revert_move:
	move 	$s6,	$t8	# Restore enemy row
	move 	$s7,	$t9	# Restore enemy column
	j	enemy_update_end # jump to end the update
	
check_player_collision:
	beq  	$s6,	$s0,	check_enemy_col # 
	j	enemy_update_end	# jump to end the update
	
check_enemy_col:
	beq  	$s7,	$s1,	enemy_collided
	j	enemy_update_end	# jump to end the update
	
enemy_collided:
	j	collided	# Jump to game over routine
	
enemy_update_end:
	lw   	$ra,	0($sp) # load the address
	addi 	$sp,	$sp,	4	# restore the stack
	jr   	$ra	 #jump back to the original address

print_enemy:
	li   	$a0,	'E'	# load E into argument
	jal  	printChar	# jump to printchar
	j	after_print	#jump to afterprint
