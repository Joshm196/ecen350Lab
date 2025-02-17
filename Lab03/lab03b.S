.section .text
.globl lab03b

lab03b:	
	ADRP X0, UIN // load base address of UIN
	ADD X0, X0, :lo12:UIN // get full address of UIN
	LDR X1, [X0] // holds value of UIN

        MOV X2, XZR // initialize i to 0

startLoop:
	CMP X2, #10 // comparing i and 10
	BGE endLoop // if i >= 10, then end loop
	SUB X1, X1, #1 // decrements UIN by 1
	STR X1, [X0] // store updated value back to memory
	ADD X2, X2, #1 // increment i by 1
	B startLoop // repeat loop

endLoop:
	MOV X0, X1 // moving final UIN value to X0
	BR LR // returning final value

.section .data

UIN:
.quad 28
