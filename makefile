# File Name:  makefile
# Build Date: Wed Apr 23 22:44:01 CDT 2025
# Version:    0.1.1

APP=bcc
CXX=g++
CC=gcc
YACC=bison
FLEX=flex
YACCFLAGS=-d
BISONFLAGS=-y --html --graph
FLEXFLAGS?=
CXXFLAGS=-std=c++17 -fPIC
CCFLAGS=
SRC=src
BLD?=build
OBJ?=$(BLD)
LEXER_NAME=lexer
PARSER_NAME=parser

# lib settings
LDFLAGS = -static -lcppunit -L/usr/local/lib/
INCLUDES = -I/usr/local/include/cppunit/

ifdef DEBUG
	CXXFLAGS +=-g -DDEBUG
endif

ifdef CYGWIN
	CXXFLAGS += -DCYGWIN
endif

all: $(BLD)/$(APP) $(BLD)/lex

rebuild: clean all

$(BLD)/$(APP): $(BLD)/$(LEXER_NAME).yy.c $(BLD)/$(PARSER_NAME).tab.c
	 $(CC) $(CCFLAGS) $(BLD)/$(PARSER_NAME).tab.c $(BLD)/$(LEXER_NAME).yy.c -o $(BLD)/$(APP)

$(BLD)/$(LEXER_NAME).yy.c: $(SRC)/$(LEXER_NAME).l
	$(FLEX) $(FLEXFLAGS) -o $(BLD)/$(LEXER_NAME).yy.c $(SRC)/$(LEXER_NAME).l

$(BLD)/$(PARSER_NAME).tab.c: $(SRC)/$(PARSER_NAME).y
	$(YACC) $(YACCFLAGS) $(SRC)/$(PARSER_NAME).y -o $(BLD)/$(PARSER_NAME).tab.c

$(BLD)/lexer.cpp: $(SRC)/lexer_ex.l
	reflex --flex -o $(BLD)/lexer.cpp $(SRC)/lexer_ex.l

$(BLD)/lex: $(BLD)/lexer.cpp
	$(CXX) $(CXXFLAGS) $(BLD)/lexer.cpp -o $(BLD)/lex

$(OBJ)/%.o: $(SRC)/%.c
	$(CC) $(CCFLAGS) -c -o $@ $<

.PHONY: clean
clean:
	-rm -f $(BLD)/*
	-rm -f $(OBJ)/*


.PHONY: help
help:
	@echo  '  all                        - build all'
	@echo  '  clean                      - remove all files from build dir'
