; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR
			#include <P18F8720.inc>
; CONFIG2H
			CONFIG  WDT = OFF             	; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit)) 
RES_VECT	CODE    0x0000					; processor reset vector
			GOTO    START				   	; go to beginning of program

	
	
MAIN_PROG	CODE					 		; let linker place main program
	
i			set 0
nsort		set 0x11	; this is the current block being evaluated
loop		set 0x10	; this is the total blocks being evaluated this loop
all_sort	set 0x15
START		movlw 0x00					; junk statment, used to make organization of code easier
	
			movlw LOW MyTable
			movwf TBLPTRL
			movlw HIGH MyTable
			movwf TBLPTRH
			movlw UPPER MyTable
			movwf TBLPTRU
			
			LFSR FSR0, 0x30
		
		
Loop		tblrd*+
			movff TABLAT,POSTINC0	    ; Copy table to fsr
			incf i			    ; Add 1 to count
			movlw 0x0A		    ; Set max iterations
			subwf i, 0		    ; Sub count from max, store in wreg
			bz  EndLoop		    ; if previous math is 0 max=count, branch to end
			GOTO Loop		    ; otherwise loop again
EndLoop		movlw 0x0		    ; BS cycle to help organization
		
		
			LFSR FSR0, 0x30		    ; Reset FSR to start
			movlw 0x30
			movwf nsort
			movlw 0x00
			movwf loop
			movlw 0x0B
			movwf all_sort
			CLRF i
		
ISort		movlw 0x30
			addwf loop,0
			movwf nsort ; if starting new grouping far right set new nsort var
		
		
ISort_I		movff nsort, 0xFE9	; force lfsr to file register value of nsort
			movff POSTINC0,0x12	; Copy first position to temp location
			movff INDF0, 0x13		; Read second position
			movf 0x13,w			; Also store in wreg
			cpfsgt 0x12	; if 0x13>0x12 branch to start
			bra ISORT_B_END
			movff 0x12, POSTDEC0	; if needing swap just copy them back to FSR backwards
			movff 0x13, INDF0
ISORT_B_END	decf nsort  ; move 1 group down to left
			movf nsort,w
			sublw 0x2F
			bnz ISort_I
			incf loop   ; add 1 to total groupings needed to check for the next iteration
			movf loop,w		    ; copy loop var to w
			sublw 0x09		    ; loop-11=?
			bnz  ISort		    ; as long as not 0 yet, restart
		
		 
Exit_ISORT	movlw 0x00		
; Loop through here until all sorted
	; Loop here for each bracket is sorted XXX
	    ; sort the current right most bracket
	    ; sort brackets going left until 1 is not changed
	    ; break to XXX with 1 more bracket added

		
Exit_loop	movlw	0x000 					; Junk statement. Just copies 0x00 to wreg, just there to keep debugger happy when I step through.
		


			movlw LOW MyTable
			movwf TBLPTRL
			movlw HIGH MyTable
			movwf TBLPTRH
			movlw UPPER MyTable
			movwf TBLPTRU
			movff TBLPTRH, 0x40
			movff TBLPTRL, 0x41
			movff TBLPTRU, 0x42
ERASE_BLOCK 
			BSF     EECON1, EEPGD             ; point to Flash program memory
			BCF     EECON1, CFGS              ; access Flash program memory
			BSF     EECON1, WREN              ; enable write to memory
			BSF     EECON1, FREE              ; enable block Erase operation
			BCF     INTCON, GIE               ; disable interrupts
			MOVLW   55h
			MOVWF   EECON2                    ; write 55h
			MOVLW   0AAh
			MOVWF   EECON2                    ; write 0AAh
			BSF     EECON1, WR                ; start erase (CPU stall)
			BSF     INTCON, GIE               ; re-enable interrupts		
			TBLRD*- 
			movff TBLPTRH, 0x40
			movff TBLPTRL, 0x41
			movff TBLPTRU, 0x42
			
			movlw LOW MyTable
			movwf TBLPTRL
			movlw HIGH MyTable
			movwf TBLPTRH
			movlw UPPER MyTable
			movwf TBLPTRU
			
			
			movff TBLPTRL, 0x42
			movff TBLPTRH, 0x41
			movff TBLPTRU, 0x40
			LFSR FSR0, 0x30
			movlw 0x02
			movwf nsort

			
TWO_WORDS
			movlw 0x08
			movwf i
			
WRITE_WORD_TO_HREGS
			MOVFF   POSTINC0, WREG            ; get low byte of buffer data
			Movwf	0x26
			movwf	TABLAT		   ; present data to table latch
			TBLWT*+                           ; write data, perform a short write 
			; to internal TBLWT holding register.
			DECFSZ  i             ; loop until done
			BRA     WRITE_WORD_TO_HREGS

						
PROGRAM_MEMORY
			BSF     EECON1, EEPGD          ; point to Flash program memory
			BCF     EECON1, CFGS           ; access Flash program memory
			BSF     EECON1, WREN           ; enable write to memory
			BCF     INTCON, GIE            ; disable interrupts
			MOVLW   55h
			MOVWF   EECON2                 ; write 55H
			MOVLW   0AAh
			MOVWF   EECON2                 ; write AAH
			BSF     EECON1, WR             ; start program (CPU stall)
			NOP
			;TBLRD*-

			NOP
			NOP
			BSF     INTCON, GIE            ; re-enable interrupts
			DECFSZ  nsort             ; loop until done
			BRA     TWO_WORDS
			BCF     EECON1, WREN           ; disable write to memory
	
;PROGRAM_MEMORY

		
			movlw 0x0						; BS Command at the end to set breakpoint to
		org 0x7000
MyTable		db 0x04,0x05,0x03,0x09,0x01,0x00,0x02,0x07,0x08,0x06
		    
		END	