; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR
			#include <P18F8720.inc>
; CONFIG2H
			CONFIG  WDT = OFF             	; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit)) 
RES_VECT		CODE    0x0000					; processor reset vector
			GOTO    START				   	; go to beginning of program

	
	
MAIN_PROG		CODE					 		; let linker place main program

START			movlw 0x00					; junk statment, used to make organization of code easier
	
i			set 0x01	
			movlw 0
			movwf TBLPTRL
			movlw 0x70
			movwf TBLPTRH
			movlw 0
			movwf TBLPTRU
			LFSR FSR0, 0x30	; reset my FSR0 to 0x30
		
			; So what I'm doing is taking my program memory, writing it to working memory, ordering it in the working memory, then writing the sorted values back into the program memory. 
Loop			tblrd*+
			movff TABLAT,POSTINC0	    ; Copy table to fsr
			incf i			    ; Add 1 to count
			movlw 0x05		    ; Set max iterations
			subwf i, 0		    ; Sub count from max, store in wreg
			bz  EndLoop		    ; if previous math is 0 max=count, branch to end			!!! Note that it's more efficient to decrement, skip if zero. Then all these lines becomes 1 line. 
			GOTO Loop		    ; otherwise loop again
EndLoop			movlw 0x0		    ; BS cycle to help organization
		
			LFSR FSR0, 0x30	; reset my FSR0 to 0x30
counter			set 0x50		
			movlw 0x0
			movwf counter	; set greater than 10 counter to 0
			movlw 0x05
			movwf i		; give countdown 5 iterations
			
Loop3			movff INDF0, 0x10
			movlw 0x0A  ; Set Wreg to hold 10d in hex
			bcf        STATUS,C 
			CPFSGT 0x10	; skip next line if f is greater than 10d
			bra lessthan	; not skipped branch to label
			bra greater	; greater than label
			
			
join_loop		movff 0x10, POSTINC0	; both rejoin loop for common code	
			DECFSZ  i             				; decrement i counter, skip over next line when its at 0
			BRA     Loop3		; if not at 0 yet, rerun the loop
EndLoop3		bra ENDPROG		; if at 0 then branch to end of program jumping over the other code
			
greater			RRCF 0x10,1		; Rotate right without carry
			incf counter		; this is the same as /2
			bra join_loop
			

lessthan		RLCF 0x10,1		; rotate left no carry, same as x2
			bra join_loop
			
ENDPROG			movlw 0x0						; BS Command at the end to set breakpoint to
			org 0x7000
MyTable			db 0x01,0x03,0x09,0x08,0x7F
		    
		END	
