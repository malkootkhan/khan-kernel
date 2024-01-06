ProtectedMode is successfully adddded in this commit
to run:yyyooou  caann  build and run by qemuit will show nothing  bt at least it will not crash then
gdb: run gdb in gdb run "target remote | qemu-system-x86_64 -hda ./bin/boot/boot.bin -S -gdb stdio" press c to continue and press ctrl+c will show the position it is right now: 
cmd:info registers: show you the registers and protected mode you can confirm: layout asm to show assembly etc
ProtectedMode: explain by assembly instructions at link:https://wiki.osdev.org/Protected_Mode

DISK: read sector into memory: https://www.ctyme.com/intr/rb-0607.htm



we have to download build and install cross compiler given on the
following link
https://wiki.osdev.org/GCC_Cross-Compiler
As we can't use gcc that is targeted for linux not for our own kernel

The best site for materials related to this course

https://wiki.osdev.org/

here you can find everything related to os development and assembly and interrupts etc
