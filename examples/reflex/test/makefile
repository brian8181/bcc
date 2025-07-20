CXX=g++
CC=gcc
LEX=reflex
YACC=bison
SRC=.
BLD=build
OBJ=build

all: $(BLD)/lex $(BLD)/ccomments

$(BLD)/lex: $(BLD)/lex.yy.cpp
	$(CXX) $(BLD)/lex.yy.cpp -o $(BLD)/lex

$(BLD)/lex.yy.cpp: $(SRC)/flexexample2.l
	$(LEX) --header-file=$(BLD)/flexexample2.l.hpp -o $(BLD)/lex.yy.cpp $(SRC)/flexexample2.l

$(BLD)/ccomments: $(BLD)/ccomments.yy.cpp
	$(CXX) $(BLD)/ccomments.yy.cpp -o $(BLD)/ccomments

$(BLD)/ccomments.yy.cpp: $(SRC)/ccomments.l
	$(LEX) --header-file=$(BLD)/ccomments.yy.hpp -o $(BLD)/ccomments.yy.cpp $(SRC)/ccomments.l


# clean build & obj directories
.PHONY: clean
clean:
	-rm -f $(OBJ)/*.
	-rm -f $(BLD)/*
