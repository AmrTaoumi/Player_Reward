.data

gameover:	.asciiz "GAME OVER"
score:		.asciiz "Score: "

.text
.globl main,	inner_loop, check_coalition, score,	gameover, outer_loop, collided,	valid_coordinates

main:	
	li   	$s5,	0		# Initialize score to 0
	li   	$a1,	7		# grid inside size
	
	# Generate player position
	li   	$v0,	42      	# syscall 42 to randomize a number with a higher bound
	syscall
	addi 	$a0,	$a0,	1	# offset by 1
	move 	$s0,	$a0		# player's row
	li   	$v0,	42
	syscall				# syscall
	addi 	$a0,	$a0,	1	# offset by 1
	move 	$s1,	$a0		# player's column 
	
	
	jal  	generate_reward		# call generate_reward
	
valid_coordinates:
	jal 	check_coalition		# Check collision after grid is printed	
	jal 	check_reward		# Check if player got reward
	la   	$a0,	score		# initialize score in arguement register
	jal  	print_string		# print score string
	
	# Print the score directly
	move 	$a0,	$s5	# Move score to $a0
	jal  	print_integer	# Call function to print integer
	
	# Print a newline after the score
	li   	$a0,	10	# Newline character
	jal  	printChar
	
	li   	$t1,	0	# row index
	li   	$t2,	9	# grid size

outer_loop:
	beq  	$t1,	$t2,	takeChar	# if $t1 == $t2 --> goto takeChar
	li   	$t3,	0	# column index

inner_loop:	
	beq  	$t3,	$t2,	newline		# if  $t3 == $t2 --> goto newline
	
	# Border checks
	li   	$t4,	0	# initialize grid border index for checking
	beq  	$t1,	$t4,	print_hash	# if $t1 == $t4  --> goto print_hash
	beq  	$t3,	$t4,	print_hash      # if $t3 == $t4  --> goto print_hash
	li   	$t4,	8       # initialize grid border index for checking
	beq  	$t1,	$t4,	print_hash	# if $t1 == $t4  --> goto print_hash
	beq  	$t3,	$t4,	print_hash	# if $t3 == $t4  --> goto print_hash

	# Position checks
	bne 	$t1,	$s0,	not_player	# if $t1 != $s0 --> goto not_player
	bne 	$t3,	$s1,	not_player	# if $t3 != $s0 --> goto not_player
	j 		print_player	# jump to print_player if no conditions above are met

not_player:
	bne 	$t1,	$s2,	not_reward	# if $t1 != $s2 --> goto not_reward
	bne 	$t3,	$s3,	not_reward	# if $t1 != #s3 --> goto not_reward
	j 		print_reward	# jump to print_reward if no conditions are met above

not_reward:
	j 	print_space	# jump to print_enemy if no conditions are met above

	
print_hash:
	li   	$a0,	'#'	# initiaize hash in argument
	jal  	printChar   # call printChar
	j		after_print		# jump to after_print

print_player:
	li		$a0,	'P'	 	# initiaize P in argument
	jal  	printChar	# call printChar
	j		after_print		# jump to after_print

print_reward:
	jal  	check_reward   # call check_reward
	li   	$a0,	'R'	   
	jal  	printChar	# call printChar
	j	after_print	# jump to after_print

print_space:
	li   	$a0,	' '	# initiaize P in argument
	jal  	printChar	# call printChar

after_print:
	addi 	$t3,	$t3,	1 #increment column index
	j		inner_loop	#jump to innerloop

exit:
	li   	$v0,	10  # syscall for exit
	syscall 	#syscall

check_coalition:
	beq 	$s0,	0,	collided	#player row == 0 --> goto collided
	beq 	$s1,	0,	collided	#player column == 0 --> goto collided
	beq 	$s0,	8,	collided	#player row == 8 --> goto collided
	beq 	$s1,	8,	collided	#player column == 8 --> goto collided
	jr 		$ra

collided:
	li 		$t9,	12	# load 12
	sb 		$t9,	0xffff000c	# clear display
	
	la 		$a0,	score	#load score string
	jal 	print_string	# call print string function

	move 	$a0,	$s5		# move score number to $a0
	jal 	print_integer	#print the score number
	
	li   	$a0,	10	# Newline character
	jal  	printChar	# call print character

	la 		$a0,	gameover  #load gameover string
	jal 	print_string # call print string
	j 		exit 	#jump to exit
