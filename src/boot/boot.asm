ORG 0	; bootloader take start from this address

BITS 16		;16 bits architecture is selected [here the targeted architeture is x8086] 

_start:
	jmp short start
	nop
times 33 db 0

start:
	jmp 0x7C0:step2


step2:
	cli		;interrupt disable
	mov ax,0x7C0
	mov ds,ax
	mov es,ax
	mov ax,0
	mov ss,ax
	mov sp,0x7C00
	sti		;interrupt enable


;AH = 02h
;AL = number of sectors to read (must be nonzero)
;CH = low eight bits of cylinder number
;CL = sector number 1-63 (bits 0-5)
;high two bits of cylinder (bits 6-7, hard disk only)
;DH = head number
;DL = drive number (bit 7 set for hard disk)
;ES:BX -> data buffer

;Return:
;CF set on error
;if AH = 11h (corrected ECC error), AL = burst length
;CF clear if successful
;AH = status (see #00234)
;AL = number of sectors transferred (only valid if CF set for some
;BIOSes)

	mov ah,0x02	; read sector command
	mov al,1	; sector one to be read
	mov ch,0	; cylinder low eight bits It is a way the data store in memory forming some cylindical shape
	mov cl,2	; sector number I mean the sector is to be read but its location is 2
	mov dh,0	; Head number
	mov bx, buffer
	int 0x13
	jc error
	jmp $			;infinite loop
error: 
	mov si, error_msg
	call print
	jmp $

print:
	mov bx,0		;clear bx register
.loop:
	lodsb			;load single character to ax register al part lower portion of ax reg is al and upper ah
	cmp al,0		;the end of message is specified 0 so it compare if it zero
	je .done		;jump to .done if equal je=jump if equal
	call print_char		;call print_char routine
	jmp .loop		;jump to .loop label 
.done:
	ret
print_char:
	mov ah,0eh		;copy 0eh to the upper part of ax reg and it is a specific command for printing char to screen 
	int 0x10		;it is interrupt that cause printing to occur
	ret

error_msg db 'Failed to load sector', 0

times 510-($ - $$) db 0		;repeat the specified number of times to write zero in the memory
dw 0xAA55			;boot signature it shows the end of bootloader and also tells the bios that it is a valid boot sector

buffer: db ''
