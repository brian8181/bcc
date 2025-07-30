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
CXXFLAGS=-Wall -std=c++20 -fPIC
CCFLAGS=
SRC=src
BLD?=build
OBJ?=build

# lib settings
LDFLAGS = -static -lcppunit -L/usr/local/lib/
INCLUDES = -I/usr/local/include/cppunit/

ifdef DEBUG
	CXXFLAGS +=-g -DDEBUG
endif

ifdef CYGWIN
	CXXFLAGS += -DCYGWIN
endif

all: $(BLD)/bcc

rebuild: clean all

$(BLD)/bcc: $(BLD)/lexer.yy.c $(BLD)/parser.tab.c
	 $(CC) $(CCFLAGS) $(BLD)/parser.tab.c $(BLD)/lexer.yy.c -o $(BLD)/bcc

$(BLD)/lexer.yy.c: $(SRC)/lexer.l
	$(FLEX) $(FLEXFLAGS) -o $(BLD)/lexer.yy.c $(SRC)/lexer.l

$(BLD)/parser.tab.c: $(SRC)/parser.y
	$(YACC) $(YACCFLAGS) $(SRC)/parser.y -o $(BLD)/parser.tab.c

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
