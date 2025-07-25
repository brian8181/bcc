# File Name:  if_else_parser/makefile
# Build Date: Wed Apr 23 22:44:01 CDT 2025
# Version:    0.1.1

APP=lines
CXX=g++
CC=gcc
YACC=bison
FLEX=reflex
YACCFLAGS=-d -Wcounterexamples
BISONFLAGS=-Wcounterexamples --html --graph
FLEXFLAGS?=--flex
CXXFLAGS=-Wall -std=c++20 -fPIC
CCFLAGS=
SRC=src
BLD?=build
OBJ?=build

# lib settings
LIBS=-L/usr/lib -L/usr/lib64 -L/usr/local/lib -L/usr/local/lib64
INCLUDES=-I/usr/local/include/cppunit/
LDFLAGS=$(INCLUDES) $(LIBS)

ifdef DEBUG
	CXXFLAGS += -DDEBUG
endif

ifdef CYGWIN
	CXXFLAGS +=-DCYGWIN
	LDFLAGS += -lfmt -lcppunit.dll
else
	LDFLAGS += -lfmt -lcppunit
endif

# all:
# 	$(BISON) $(YYFLAGS) -o$(BLD)/parser.tab.c -d $(SRC)/parser.y
# 	$(LEX) $(LFLAGS) -o$(BLD)/lexer.yy.c $(SRC)/lexer.l
# 	g++ $(CXXFLAGS) -o $(BLD)/parser $(BLD)/parser.tab.c $(BLD)/lexer.yy.c

all: $(BLD)/lines

rebuild: clean all

$(BLD)/lines: $(BLD)/lexer.yy.c $(BLD)/parser.tab.c
	 $(CXX) $(CCFLAGS) $(BLD)/parser.tab.c $(BLD)/lexer.yy.c -o $(BLD)/lines

$(BLD)/lexer.yy.c: $(SRC)/lexer.l
#$(FLEX) $(FLEXFLAGS) -o $(BLD)/lexer.yy.c $(SRC)/lexer.l
	flex -o $(BLD)/lexer.yy.c $(SRC)/lexer.l

$(BLD)/parser.tab.c: $(SRC)/parser.y
	$(YACC) $(YACCFLAGS) $(SRC)/parser.y -o $(BLD)/parser.tab.c

$(OBJ)/%.o: $(SRC)/%.c
	$(CXX) $(CCFLAGS) -c -o $@ $<

.PHONY: clean
clean:
	-rm -f $(BLD)/*
	-rm -f $(OBJ)/*

.PHONY: help
help:
	@echo  '  all                        - build all'
	@echo  '  clean                      - remove all files from build dir'
