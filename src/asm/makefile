hw: hw.asm
	nasm -f elf64 hw.asm -o hw.o
	ld hw.o -o hw

print_five:
	# Step 1: Assemble the file into a 64-bit Linux object file (ELF64 format)
	nasm -f elf64 print_five.asm -o print_five.o
	# Step 2: Use GCC to link the object file against the C standard library
	gcc -no-pie print_five.o -o print_five
	# Step 3: Run your binary
	./print_five

clean:
	rm hw.o hw
	rm print_five.o print_five