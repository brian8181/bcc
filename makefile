# File Name:  if_else_parser/makefile
# Build Date: Wed Apr 23 22:44:01 CDT 2025
# Version:    0.1.1

APP=if_else_parser
CXX=g++
CC=gcc
YACC=bison
FLEX=flex
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

all: 
	$(YACC) -d $(SRC)/parser.y -o $(BLD)/parser.tab.c
	$(FLEX) -o $(BLD)/lexer.yy.c $(SRC)/lexer.l 
	$(CC) $(BLD)/parser.tab.c $(BLD)/lexer.yy.c -o $(BLD)/bcc

rebuild: clean all

$(BLD)/bcc: ./$(OBJ)/parser.tab.c
	 $(CC) $(CFLAGS) -o ./$(BLD)/bcc ./$(OBJ)/parser.tab.c 

$(OBJ)/%.o: ./$(SRC)/%.c
	$(CC) $(CCFLAGS) -c -o $@ $<

.PHONY: clean
clean:
	-rm -f ./$(OBJ)/*.o
	-rm -f ./$(BLD)/*.o
	-rm -f ./$(BLD)/if_else_parser*

.PHONY: help
help:
	@echo  '  all                        - build all'
	@echo  '  clean                      - remove all files from build dir'
	@echo  '  install                    - copy files to usr/local'
	@echo  '  dist                       - create distribution, tar.gz'
