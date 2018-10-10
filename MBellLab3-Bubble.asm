; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR
			#include <P18F8720.inc>
; CONFIG2H
			CONFIG  WDT = OFF             	; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit)) 
RES_VECT	CODE    0x0000					; processor reset vector
			GOTO    START				   	; go to beginning of program

	
	
MAIN_PROG	CODE					 		; let linker place main program
	
i			set 0		; i is a generic counter address. The thing it is counting changes throughout the program 
nsort		set 0x11	; this is the current block being evaluated
loop		set 0x10	; this is the total blocks being evaluated this loop
all_sort	set 0x15
START		movlw 0x00					; junk statment, used to make organization of code easier
	
	
			; this is all to setup the table pointer. You could also write the table pointer directly
			;movlw LOW MyTable
			;movwf TBLPTRL
			;movlw HIGH MyTable
			;movwf TBLPTRH
			;movlw UPPER MyTable
			;movwf TBLPTRU
			
			movlw 7000 
			movwf TBLPTR	; It's easier to just write the table pointer
			
			LFSR FSR0, 0x30	; reset my FSR0 to 0x30
		
			; So what I'm doing is taking my program memory, writing it to working memory, ordering it in the working memory, then writing the sorted values back into the program memory. 
Loop		tblrd*+
			movff TABLAT,POSTINC0	    ; Copy table to fsr
			incf i			    ; Add 1 to count
			movlw 0x0A		    ; Set max iterations
			subwf i, 0		    ; Sub count from max, store in wreg
			bz  EndLoop		    ; if previous math is 0 max=count, branch to end			!!! Note that it's more efficient to decrement, skip if zero. Then all these lines becomes 1 line. 
			GOTO Loop		    ; otherwise loop again
EndLoop		movlw 0x0		    ; BS cycle to help organization
		
		
			LFSR FSR0, 0x30		    ; Reset FSR to start
			movlw 0x30
			movwf nsort			; Nsort holds the FSR address of the current block being evaluated. It will evaluate nsort and nsort+1. 
			movlw 0x00
			movwf loop			; loop holds the current number of blocks we are offsetting by. So 0x30+loop = nsort ;note that loop and Loop are different things. 
			movlw 0x0B
			movwf all_sort
			CLRF i
		
ISort		movlw 0x30
			addwf loop,0
			movwf nsort ; if starting new grouping far right set new nsort var
			; again loop is the offset to the right that we start evaluating from. nsort is the current evaluating block, we work to the left until we get to the first value
			; [nsort]/#
			; #/[nsort]/#
			; #/#/[nsort]/#
			; etc.....
		
		
ISort_I		movff nsort, 0xFE9	; force lfsr to file register value of nsort. LFSR requires a literal so I'm writing directly to the register instead. This will need to be rewritten for different cpu. 
			movff POSTINC0,0x12	; Copy first position to temp location
			movff INDF0, 0x13		; Read second position
			movf 0x13,w			; Also store in wreg
			cpfsgt 0x12	; if 0x13>0x12 branch to start
			bra ISORT_B_END
			movff 0x12, POSTDEC0	; if needing swap just copy them back to FSR backwards; So copy larger one in, decrement fsr
			movff 0x13, INDF0		; copy second value and leave FSR at that address
ISORT_B_END	decf nsort  ; move 1 group down to left
			movf nsort,w
			sublw 0x2F	; Subtract the value of 1 file before start of the fsr array from the current fsr pointer. If 0, this means we just finished evaluating 0x30/0x31 and need to restart the process with the next loop
			bnz ISort_I	; If it is not zero we are still working left in the same loop and should coninue evaluating the next two blocks
			incf loop   ; If starting the next big loop: add 1 to total groupings needed to check for the next iteration 
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
		


			movlw 7000
			movwf TBLPTR
			;bra SKIP_ERASE
			
			; the logic for enabling write is taken from the datasheets
			; Essentially settign certain bits (flags) in the control registers sets up the device to temporarily lock the CPU from responding to interupts, then dump the 8byte Table holding register into the program memory
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

			
SKIP_ERASE			
			movlw 7000
			movwf TBLPTR
			LFSR FSR0, 0x30
			movlw 0x02						; I'm using nsort here as a timer. It just counts 2->0 so we iterate programming twice - get 2x 8 byte groups to program memory
			movwf nsort	
			
TWO_WORDS
			movlw 0x08							; i is counting 8->0 so we load the holding register with 8 bytes of data
			movwf i
			
WRITE_WORD_TO_HREGS
			MOVFF   POSTINC0, WREG            	; get low byte of buffer data 
			movwf	TABLAT		   				; present data to table latch
			TBLWT*+                            	; write data to holding register
			DECFSZ  i             				; decrement i counter, skip over next line when its at 0
			BRA     WRITE_WORD_TO_HREGS			; branch to get next byte of data
			; otherwise skip above line and program the 8 bytes
						
PROGRAM_MEMORY
			movlw 0x8						; Table Pointer previously went from starting address to start+8, move pointer back to starting address
			subwf	TBLPTR,1				; otherwise it will flash program memory starting at start+8 which I don't want
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
			NOP
			NOP
			BSF     INTCON, GIE            ; re-enable interrupts
			movlw 0x8						; move table pointer back to start+8 so the next iteration writes the next 8 bytes instead of the same 8 bytes
			addwf TBLPTR,1
			DECFSZ  nsort             ; looping from Two words twice so we write 2 words
			BRA     TWO_WORDS
			BCF     EECON1, WREN           ; disable write to memory
		
;PROGRAM_MEMORY

		
			movlw 0x0						; BS Command at the end to set breakpoint to
		org 0x7000
MyTable		db 0x04,0x05,0x03,0x09,0x01,0x00,0x02,0x07,0x08,0x06
		    
		END	
