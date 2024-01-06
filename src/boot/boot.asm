ORG 0	; bootloader take start from this address

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
[BITS 32]
load32:
	mov ax,DATA_SEG
	mov ds,ax
	mov es,ax
	mov fs,ax
	mov gs,ax
	mov ss,ax
	mov ebp,0x00200000
	mov esp,ebp
jmp $
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


times 510-($ - $$) db 0		;repeat the specified number of times to write zero in the memory
dw 0xAA55			;boot signature it shows the end of bootloader and also tells the bios that it is a valid boot sector

