hw: hw.asm
	nasm -f elf64 hw.asm -o hw.o -l hw.lst
	ld hw.o -o hw

print_five:
	# Step 1: Assemble the file into a 64-bit Linux object file (ELF64 format)
	nasm -f elf64 print_five.asm -o print_five.o -l print_five.lst
	# Step 2: Use GCC to link the object file against the C standard library
	gcc -no-pie print_five.o -o print_five
	# Step 3: Run your binary
	./print_five

test: test.asm
	nasm -f elf64 test.asm -o build/test.o -l build/test.lst
	ld build/test.o -o build/test

stack_var: stack_var.asm
	nasm -f elf64 stack_var.asm -o build/stack_var.o -l build/stack_var.lst
	ld build/stack_var.o -o build/stack_var

clean:
	rm hw.o hw
	rm print_five.o print_five
	rm -rf build/*