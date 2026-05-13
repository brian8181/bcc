CXX       = g++
REFLEX    = reflex
REFLAGS   =
LIBREFLEX =  /usr/local/lib64/libreflex_static_lib.a

YACC      = bison -y
BISON     = bison

INCPCRE2  = /opt/local/include
LIBPCRE2  = -L/opt/local/lib -lpcre2-8

INCBOOST  = /opt/local/include
# LIBBOOST  = -L/opt/local/lib -lboost_regex
# LIBBOOST  = -L/opt/homebrew/lib -lboost_regex-mt
LIBBOOST  = -L/opt/local/lib -lboost_regex-mt

CXXOFLAGS = -O2
CXXWFLAGS = -Wall -Wunused -Wextra
CXXIFLAGS = -I. -I../include -I $(INCBOOST)
CXXMFLAGS =
# CXXMFLAGS =-DDEBUG
CXXFLAGS  = $(CXXWFLAGS) $(CXXOFLAGS) $(CXXIFLAGS) $(CXXMFLAGS)


CC=gcc
BISON=bison
LEX=flex
BISONFLAGS= -y -d --html --graph

LEX=reflex
SRC=src
BLD=build
OBJ=build

all: $(BLD)/lexer $(BLD)/lexer.yy.c

$(BLD)/lexer: $(BLD)/lexer.yy.c $(BLD)/parser.tab.cpp
	$(CXX) -std=c++17 -Wno-write-strings $(BLD)/lexer.yy.c $(BLD)/parser.tab.cpp -o $(BLD)/hlc

$(BLD)/parser.tab.cpp: $(SRC)/parser.yy
	$(BISON) -y $(BISONFLAGS) $(SRC)/parser.yy -o $(BLD)/parser.tab.cpp

$(BLD)/lexer.yy.c: $(SRC)/lexer.l
	$(LEX) --flex --bison -o $(BLD)/lexer.yy.c $(SRC)/lexer.l

clean:
	-rm -f $(BLD)/*
	-rm -f $(OBJ)/*
