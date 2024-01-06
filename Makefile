
all:
	nasm -f bin ./src/boot/boot.asm -o ./bin/boot/boot.bin
clean:
	rm -rf ./bin/boot/boot.bin
