ORG 0	; bootloader take start from this address

BITS 16		;16 bits architecture is selected [here the targeted architeture is x8086] 

_start:
	jmp short start
	nop
times 33 db 0

start:
	jmp 0x7C0:step2


handle_zero:
	mov ah,0eh
	mov al,'A'
	mov bx,0
	int 0x10
	iret

step2:
	cli		;interrupt disable
	mov ax,0x7C0
	mov ds,ax
	mov es,ax
	mov ax,0
	mov ss,ax
	mov sp,0x7C00
	sti		;interrupt enable
	
	mov word[ss:0x00],handle_zero
	mov word[ss:0x02],0x7C0
	
	mov ax, 0
	div ax		;divide by zero it will create exception/interrupt which is handled in handle_zero

	mov si, message		;copy the address of 'hello World!' basically address is message to si register
	call print		;call print routine
	jmp $			;infinite loop

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

message: db 'Hello world!',0	;ended with 0
times 510-($ - $$) db 0		;repeat the specified number of times to write zero in the memory
dw 0xAA55			;boot signature it shows the end of bootloader and also tells the bios that it is a valid boot sector

