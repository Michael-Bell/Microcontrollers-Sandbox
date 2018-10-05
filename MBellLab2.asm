; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR
			#include <P18F8720.inc>
; CONFIG2H
			CONFIG  WDT = OFF             	; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit)) 
RES_VECT	CODE    0x0000					; processor reset vector
			GOTO    START				   	; go to beginning of program

; TODO ADD INTERRUPTS HERE IF USED

i			set	0x30	
		

inc_reg		macro	addr 					; Macro is called each time a counter increments, passing along an address as the argument
	        incf	addr					; Increment the counter or "addr"
			GOTO	EN_LOP					; jump to end of loop to determine if loop again or end. This jumps over remaining logic for if odd/even
			endm
		
MAIN_PROG	CODE					 		; let linker place main program

IF_EVEN		inc_reg	0x50 					; These GOTOS are called from Main program. They are used to keep my Skip-logic from going out of order 
IF_ODD		inc_reg	0x51
IF_ZERO		inc_reg	0x55
	
	

; We need to get 10 values into the FSR... 
; Easiest way is to just write my values into the Register viewer and copy them in...
START		LFSR	FSR0,	0x300			; Set my FSR to Address 300	  
			MOVFF	0x00,	POSTINC0		; Start copying from lower register to FSR
			MOVFF	0x01,	POSTINC0		; I could also just write to higher registers, but this is easier...
			MOVFF	0x02,	POSTINC0
			MOVFF	0x03,	POSTINC0
			MOVFF	0x04,	POSTINC0
			MOVFF	0x05,	POSTINC0
			MOVFF	0x06,	POSTINC0
			MOVFF	0x07,	POSTINC0
			MOVFF	0x08,	POSTINC0
			MOVFF	0x09,	POSTINC0    	; All the values are loaded into the FSR from lower register
			
			LFSR	FSR0,	0x300	    	; Reset FSR0 to read it back
			clrf	i,A		    			; Set counter to Zero
READ_NEXT	MOVF	POSTINC0, 0				; Copy the data from current FSR address to WREG and increment FSR
				
											; !!! NOTE: 0xFE8 is the address for the WREG. 
											; !!! 		There seems to be an issue where it does not work if you just use "W"

			BTFSS	0XFE8,	0	    		; Check if LSB bit is set. If it is, the next line is skipped
			GOTO	ST_EVEN		    		; If previous bit is not set, number is even and jump to st_even
			GOTO	IF_ODD		    		; If 2 lines ago bit was set (odd) jump to if_odd for incrementing register
ST_EVEN		TSTFSZ	0xFE8		    		; Evaluate if WREG is Zero. If Zero the next line is skipped
			GOTO	IF_EVEN		    		; If previous line was not zero, then it must be even and we skip to the if_even label
			GOTO	IF_ZERO		    		; If 2 lines ago was zero last line was skipped and it must be 0x00. Skip to if_zero label
EN_LOP		movlw	0A	    				; move '10'd into the WREG b/c we need to loop over 10 values total
			incf	i	    				; add 1 to i (loop counter)
			cpfslt	i,A	    				; compare i>10; If i<=10 then skip the next line
			bra	Exit_loop   				; if i >=10 then jump to the exit_loop label
			GOTO	READ_NEXT   			; if i less than 10 jump back
Exit_loop	movlw	0x000 					; Junk statement. Just copies 0x00 to wreg, just there to keep debugger happy when I step through.
			END	