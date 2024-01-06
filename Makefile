FILES=./build/kernel.asm.o

all: ./bin/boot/boot.bin ./bin/kernel.bin
	rm -rf ./bin/khan-os.bin
	dd if=./bin/boot/boot.bin >> ./bin/khan-os.bin
	dd if=./bin/kernel.bin >> ./bin/khan-os.bin
	dd if=/dev/zero bs=512 count=100 >> ./bin/khan-os.bin
./bin/kernel.bin: $(FILES)
	i686-elf-ld -g -relocatable $(FILES) -o ./build/kernelful.o
	i686-elf-gcc -T ./src/linker.ld -o ./bin/kernel.bin -ffreestanding -O0 -nostdlib ./build/kernelful.o
./bin/boot/boot.bin: ./src/boot/boot.asm
	nasm -f bin ./src/boot/boot.asm -o ./bin/boot/boot.bin
./build/kernel.asm.o: ./src/kernel/kernel.asm
	nasm -f elf -g ./src/kernel/kernel.asm -o ./build/kernel.asm.o
clean:
	rm -rf ./bin/boot/boot.bin
