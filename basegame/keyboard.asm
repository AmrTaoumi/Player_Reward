.globl 	takeChar
takeChar:
	li 		$t0,	0xffff0000  # load address of reciever control 
takeChar_loop:
	lb 		$t1,	($t0)	#	check reciever status
	beq 	$t1,	$0,	takeChar_loop	# loop until a key is recieved
	li 		$t2,	0xffff0004	# load address of reciever data
	lb 		$v0,	($t2)	# store the data in v0
	sge 	$t3,	$v0,	'A'	# check if its bigger than 'A'
	sle 	$t4,	$v0,	'Z' # check if its less than 'Z'
	
	and		$t3,	$t4,	$t3	# combine checks
	beq		$t3,	1,	capital_offset	#if equals 1 then branch to offset
	j 		char_check	# if not then skip conversion 
capital_offset:
	addi 	$v0,	$v0,	0x20 # convert to lowercase
  
char_check:	
	beq 	$v0,	'w',	goUp #	check if 'w' key is pressed
	beq 	$v0,	's',	goDown #	check if 'w' key is pressed
	beq 	$v0,	'd',	goLeft #	check if 'w' key is pressed
	beq 	$v0,	'a',	goRight #	check if 'w' key is pressed
	
	j 	takeChar_loop # loop back if wrong input

goUp:
	addi 	$s0,	$s0,	-1 # decrement y
	j 		return	
	
goDown:
	addi 	$s0,	$s0,	1 # increment y
	j 		return
	
goLeft:
	addi 	$s1,	$s1,	1	# increment x
	j 		return
	
goRight:
	addi 	$s1,	$s1,	-1	# decrement x
	
return:
	# clearing the display
	li 		$t9,	0x07	
	sb 		$t9,	0xffff000c	
	
	j 		valid_coordinates # jump to validation 
