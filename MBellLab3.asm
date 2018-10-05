; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR
			#include <P18F8720.inc>
; CONFIG2H
			CONFIG  WDT = OFF             	; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit)) 
RES_VECT	CODE    0x0000					; processor reset vector
			GOTO    START				   	; go to beginning of program

	
	
MAIN_PROG	CODE					 		; let linker place main program
	
i		set 0
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
			
		org 0x7000
MyTable		db 0x04,0x05,0x02,0x09,0x01,0x00,0x03,0x07,0x08,0x06
		    
		END	