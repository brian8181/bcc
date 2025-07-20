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

LEX=reflex
SRC=src
BLD=build
OBJ=build

all: $(BLD)/lexer
	 $(LEX) -o $(BLD)/lexer.l
	 $(CXX) -std=c++17 -Wno-write-strings -o $(BLD)/lexer $(BLD)/lex.yy.c

$(BLD)/lexer: $(BLD)/lexer.yy.c 
	 $(CXX) -std=c++17 -Wno-write-strings $(BLD)/lexer.yy.c -o $(BLD)/hlc

$(BLD)/lexer.yy.c: $(SRC)/lexer.l 
	$(LEX) -o $(BLD)/lexer.yy.c $(SRC)/lexer.l   
