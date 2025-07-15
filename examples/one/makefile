CC=gcc
CXX=g++
BISON=bison
LEX=reflex
CCFLAGS=
CXXFLAGS=-std=c++17
YYFLAGS=
LFLAGS=
BLD=build
SRC=src
OBJ=build

all:
	$(BISON) $(YYFLAGS) -o$(BLD)/parser.tab.c -d $(SRC)/parser.y
	$(LEX) $(LFLAGS) -o$(BLD)/lexer.yy.c $(SRC)/lexer.l 
	g++ $(CXXFLAGS) -o $(BLD)/parser $(BLD)/parser.tab.c $(BLD)/lexer.yy.c


.PHONY: clean
clean: 
	-rm build/*

