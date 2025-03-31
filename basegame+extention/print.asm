.globl print_string,	print_integer,	printChar,	newline,	after_print

.text
printChar:
	lw	$t5,	0xffff0008 # load address of transmitter control
	andi	$t5,	$t5,	1	# check for the ready bit
	beq  	$t5,	$zero,	printChar	# loop back if transmitter is busy
	sw   	$a0,	0xffff000c	# write character into the transmitter data
	jr   	$ra		# return to caller
	
print_string:
	lw	$t1,	0xffff0008	# load address of transmitter control
	andi	$t1,	$t1,	1 # check for the ready bit
	
	beq	$t1,	$zero,	print_string	#polling
	lb	$t1,	($a0)	   # load next character from the string
	beqz	$t1,	printed	   # exit if the null terminator is reached
	  
	sb	$t1,	0xffff000c   # write character into the transmitter data
	addi	$a0,	$a0,	1	#increment pointer
	j	print_string	# repear
printed:
	jr	$ra # return to caller
	
print_integer:
	addi	$sp,	$sp,	-12 # allocate stack memory
	sw	$s0,	0($sp)	# storing $s0
	sw	$s1,	4($sp)	# storing $s1
	sw	$ra,	8($sp)  # storing return address
	
	move 	$s0,	$a0	# Move the number to $s0
	li   	$t1,	0	# Digit counter
	li   	$s1,	0	# Reversed number
	li   	$t2,	10	# Divisor
	
	# If the number is 0,	directly print 0
	bnez 	$s0,	reverse_number
	li   	$a0,	'0'
	jal  	printChar
	j	print_int_end
	
reverse_number:
	beqz 	$s0,	print_digits #proceed when all digits reserved
	div  	$s0,	$t2	# divide by 10
	mfhi 	$t0	   	# Remainder (last digit)
	mflo 	$s0	   	# Quotient (remaining digits)
	mul  	$s1,	$s1,	10	# Shift reversed number left
	add  	$s1,	$s1,	$t0	# Add the last digit
	addi 	$t1,	$t1,	1	# Increment digit counter
	j	reverse_number
	
print_digits:
	beqz 	$t1,	print_int_end # exit when all digits are printed
	div  	$s1,	$t2	# divide by 10
	mfhi 	$a0	# Get next digit to print
	mflo 	$s1	# Update reversed number
	addi 	$a0,	$a0,	'0'	# Convert to ASCII
	jal  	printChar	# Print the digit
	addi 	$t1,	$t1,	-1	# Decrement digit counter
	j	print_digits
	
print_int_end:
	lw   	$s0,	0($sp) # restore a0
	lw   	$s1,	4($sp) # restore $s1
	lw   	$ra,	8($sp)	# restore return address
	addi 	$sp,	$sp,	12 # deallocate memory 
	jr   	$ra	#return to caller


newline:
	li   	$a0,	'\n'	# load newline
	jal  	printChar	# print the new line
	addi 	$t1,	$t1,	1	# increment row index
	j	outer_loop	# resume

after_print:
	addi 	$t3,	$t3,	1	# increment column 
	j	inner_loop	# resume
