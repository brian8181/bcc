# File Name:  if_else_parser/makefile
# Build Date: Wed Apr 23 22:44:01 CDT 2025
# Version:    0.1.1

APP=parser
CXX=g++
CC=gcc
BISON=bison
LEX=flex
LEX_POSTFIX=yy.c
BISONFLAGS= -y -d --html --graph
BISON_POSTFIX=tab.c
CXXFLAGS=-Wall -std=c++17 -fPIC
CCFLAGS=
SRC=src
BLD=src/build
OBJ=src/build

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

all: $(BLD)/$(APP) #$(BLD)/reflexer.yy.cpp

rebuild: clean all

$(BLD)/$(APP): $(BLD)/lexer.yy.c $(BLD)/$(APP).tab.c $(OBJ)/main.o
	 $(CC) $(CCFLAGS) $(BLD)/$(APP).tab.c $(BLD)/lexer.yy.c $(BLD)/main.o -o $(BLD)/$(APP)

$(BLD)/$(APP)xx: $(SRC)/main.obj $(BLD)/reflexer.yy.cpp $(BLD)/$(APP).tab.cpp
	 $(CXX) $(CXXFLAGS) $(SRC)/main.obj $(BLD)/$(APP).tab.cpp $(BLD)/reflexer.yy.cpp -o $(BLD)/$(APP)xx

$(BLD)/lexer.yy.c: $(SRC)/lexer.l
	$(LEX) -o $(BLD)/lexer.yy.c --header-file=$(BLD)/lexer.yy.h $(SRC)/lexer.l

$(BLD)/reflexer.yy.cpp: $(SRC)/reflexer.ll
	reflex --flex -o $(BLD)/reflexer.yy.cpp $(SRC)/reflexer.ll

$(BLD)/$(APP).tab.cpp: $(SRC)/$(APP).yy
	$(BISON) $(BISONFLAGS) $(SRC)/$(APP).yy -o $(BLD)/$(APP).tab.cpp

$(BLD)/$(APP).tab.c: $(SRC)/$(APP).y
	$(BISON) $(BISONFLAGS) $(SRC)/$(APP).y -o $(BLD)/$(APP).tab.c

$(OBJ)/main.obj: $(SRC)/main.cpp
	$(CXX) $(CXXFLAGS) -c $(SRC)/main.cpp -o $(OBJ)/main.obj

$(OBJ)/%.o: $(SRC)/%.c $(BLD)/$(APP).tab.c
	$(CC) $(CCFLAGS) -c -o $@ $<

.PHONY: clean
clean:
	-rm -f $(BLD)/*
	-rm -f $(OBJ)/*

.PHONY: help
help:
	@echo  '  all                        - build all'
	@echo  '  clean                      - remove all files from build dir'
