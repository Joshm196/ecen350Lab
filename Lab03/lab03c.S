.section .text
.globl lab03c

lab03c:
	ADRP X0, my_array // load base address of my_array
	ADD X0, X0, :lo12:my_array // get full address of my_array

	//ADRP X1, initial_value // load base address of initial_value
	//ADD X1, X1, :lo12:initial_value // get full address of initial_value
	LDR X1, =initial_value //Load the inital value directly.
	LDR X4, [X1] // j holds value of initial_value

        MOV X3, XZR // initialize i to 0

startLoop:
	CMP X3, #10 // comparing i and 10
	BGE endLoop // if i >= 10, then exit loop
	STR X4, [X0, X3, LSL #3] // updates array[i] to value of j 	
	ADD X4, X4, #1 // increment j by 1
	ADD X3, X3, #1 // increment i by 1
	B startLoop

endLoop:
	BR LR

.section .data

initial_value:
.quad 5 // first digit of UIN

.globl my_array
my_array:
.space 80 // (10 quad words)*(8 bytes each)=80 bytes
