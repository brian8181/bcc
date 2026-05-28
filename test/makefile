BLD=build
SRC=.

all: $(BLD)/test_while.asm 	$(BLD)/test5.asm

$(BLD)/test_while.asm: $(SRC)/test_while.txt
	../build/bcc $^ -o $@

$(BLD)/test5.asm: $(SRC)/test5.txt
	../build/bcc $^ -o $@

clean:
	rm -f $(BLD)test_while.asm
	rm -f $(BLD)/test5.asm
