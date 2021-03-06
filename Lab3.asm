ORG 0000H
LJMP START

ORG 0013H
LJMP INT01

ORG 0100H
START:
	SETB EA	; allow interrupt
	SETB EX1	; allow external interrupt INT1
	MOV DPTR, #0DFF8H	; address of ADC0808 is 1101-1111-1111-1000
	MOVX @DPTR, A	; write to activate A/D
	
MAIN:
	MOV A, 34H
	MOV B, #32H	; 50
	MUL AB	; A*B result in BA
	MOV R0, A	; lower 8 bit
	MOV R1, B	; higher 8 bit

	MOV B, #0AH	; *10/256
	MUL AB	; A*B result in BA
	MOV R0, B
	MOV 32H, B

	MOV A, R1	; convert to decimal
	MOV B, #0AH	; 10
	DIV AB	; A/B result in B
	MOV 30H, A
	MOV 31H, B

	LCALL DISPLAY
	LCALL DELAY
	LJMP MAIN

ORG 0200H
INT01:
	PUSH PSW
	PUSH ACC
	PUSH DPH
	PUSH DPL
	MOV DPTR, #0DFF8H
	MOVX A, @DPTR	; read A/D result
	MOV 34H, A	; keep AD result in 34H
	MOV DPTR, #0DFF8H
	MOVX @DPTR, A	; A/D convert by writing
	POP DPL
	POP DPH
	POP ACC
	POP PSW
RETI

DISPLAY:
	MOV R1, 30H
	MOV DPTR, #DISTABLE
	MOV A, R1
	MOVC A, @A+DPTR
	MOV DPTR, #7FF8H
	MOVX @DPTR, A

	MOV R1, 31H
	MOV DPTR, #DISTABLE2	; display dot
	MOV A, R1
	MOVC A, @A+DPTR
	MOV DPTR, #7FF9H
	MOVX @DPTR, A
	
	MOV R1, 32H
	MOV DPTR, #DISTABLE
	MOV A, R1
	MOVC A, @A+DPTR
	MOV DPTR, #7FFAH
	MOVX @DPTR, A
	
	MOV R1, 33H
	MOV DPTR, #DISTABLE
	MOV A, R1
	MOVC A, @A+DPTR
	MOV DPTR, #7FFBH
	MOVX @DPTR, A
RET

DELAY:
	MOV R5, #0FFH	; 255
LOOP1:
	MOV R6, #0FFH	; 255
LOOP2:
	NOP
	NOP
	NOP
	DJNZ R6, LOOP2
	DJNZ R5, LOOP1
RET

DISTABLE2:
DB 040H, 079H, 024H, 030H
DB 19H, 12H, 02H, 078H
DB 00H, 10H, 08H, 03H
DB 046H, 021H, 06H, 0EH

DISTABLE:
DB 0C0H,0F9H,0A4H,0B0H
DB 99H,92H,82H,0F8H
DB 80H,90H,88H,83H
DB 0C6H,0A1H,86H,8EH
	
END
