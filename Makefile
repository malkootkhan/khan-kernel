FILES=./build/kernel.asm.o

all: ./bin/boot/boot.bin $(FILES)
	dd if=./bin/boot/boot.bin >> ./bin/khan-os.bin
./bin/boot/boot.bin: ./src/boot/boot.asm
	nasm -f bin ./src/boot/boot.asm -o ./bin/boot/boot.bin
./build/kernel.asm.o: ./src/kernel/kernel.asm
	nasm -f elf -g ./src/kernel/kernel.asm -o ./build/kernel.asm.o
clean:
	rm -rf ./bin/boot/boot.bin
