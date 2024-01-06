ORG 0x7C00	; bootloader take start from this address

BITS 16		;16 bits architecture is selected [here the targeted architeture is x8086] 

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start


_start:
	jmp short start
	nop
times 33 db 0

start:
	jmp 0:step2


step2:
	cli		;interrupt disable
	mov ax,0x7C0
	mov ds,ax
	mov es,ax
	mov ss,ax
	mov sp,0x7C00
	sti		;interrupt enable
load_protected:
	cli
	lgdt[gdt_descriptor]
	mov eax,cr0
	or eax,01
	mov cr0,eax
	jmp CODE_SEG:load32
	jmp $
;GDT
gdt_start:
gdt_null:
dd 0x00
dd 0x00

;offset
gdt_code:
dw 0xffff
dw 0
db 0
db 0x9a
db 11001111b
db 0
gdt_data:
dw 0xffff
dw 0
db 0
db 0x92
db 11001111b
db 0
gdt_end:

gdt_descriptor:
	dw gdt_end - gdt_start-1
	dd gdt_start


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

[BITS 32]
load32:
	mov eax,1
	mov ecx,100
	mov edi,0x00100000
	call ata_lba_read
	jmp CODE_SEG:0x0100000

ata_lba_read:
	mov ebx,eax	;backup the lba
	;send the highest 8 bits of lba to hard disk controller
	shr eax,24	;shift to the right by 24 bits
	or eax,0x0E	;This select the master drive
	mov dx,0x1F6
	out dx,al	;the 'out' instruction talk to the external bus I mean need to send on bus
	;finished sending hieghest 8 bits of the lba

	;sending the total sectors to read
	mov eax,ecx
	mov dx,0x1F2
	out dx,al
	;Finished sending the total sectors to read

	;sending more bits of the LBA
	mov eax,ebx	;restore the backup LBA
	mov dx,0x1F3
	out dx,al
	;finish sending the backup LBA

	;sending more bits of the LBA
	mov dx,0x1F4
	mov eax,ebx;restore the backup LBA
	shr eax,8
	out dx,al
	;finish sending more bits of the LBA

	;send upper 16 bits of the LBA
	mov dx,0x1F5
	mov eax,ebx
	shr eax,16
	out dx,al
	;Finished sending lba

	mov dx,0x1F7
	mov al,0x20
	out dx,al

; Read all sectors into memory
.next_sector:
	push ecx

;checking if we need to read
.try_again:
	mov dx,0x1F7
	in al,dx
	test al,8
	jz .try_again

	;we need to read 256 words at a time
	mov ecx,256
	mov dx,0x1F0
	rep insw
	pop ecx
	loop .next_sector
	;End of reading sectors into memory
	ret
	


times 510-($ - $$) db 0		;repeat the specified number of times to write zero in the memory
dw 0xAA55			;boot signature it shows the end of bootloader and also tells the bios that it is a valid boot sector

