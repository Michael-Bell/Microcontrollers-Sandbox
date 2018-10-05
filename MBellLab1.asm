; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR

; CONFIG2H
				CONFIG  WDT = OFF       ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit)) 
RES_VECT		CODE    0x0000			; processor reset vector
				GOTO    START			; go to beginning of program

; TODO ADD INTERRUPTS HERE IF USED
#define N_A 0x20
#define N_B 0x25

set_to_5		macro addr				; Macro that takes argument for address
		        MOVLW 5					; LOAD 5 TO W
				MOVWF addr				; SEND To ADDRESS
				GOTO PROG_END
				endm
		
MAIN_PROG		CODE					; let linker place main program
		
CASE_EQUAL		set_to_5    0x51		; Used GOTO to prevent macro from dumping in the wrong spot during runtime
CASE_GT			set_to_5    0x52
CASE_LT			set_to_5    0x50


START			MOVLW	2	    		; take the first value
				MOVWF	0x20	    	; send it to N_A 0x20
				MOVLW	4	    		; take second value
				MOVWF	0x25	    	; and send it to N_B 0x25
			    ; NOTE: These steps could be done manually at runtime as well


				CPFSEQ	0x20	    	; Evaluate if the content of wreg (second value) is equal to first address; if it is skip one line
				GOTO	CASE_NONEQUAL	; If != then this line is evaluated. Then jump to the nonequal label
				GOTO	CASE_EQUAL 		; If 2 lines ago was equal we skip to this line; then jump to label case_equal which calls the set_to_5 function
		
CASE_NONEQUAL	CPFSGT	0x20	    	; IS B>A? 
				GOTO	CASE_GT	    	; if B<A its skipped; otherwise B>A case
				CPFSLT	0x20	    	; IF B>A skip, otherwise is B<A		
				GOTO	CASE_LT	    	; if B<A GOTO case
		

PROG_END		MOVF 0x0
				END	