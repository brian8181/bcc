# @file: parsr/makefile
# @date: Wed, Jan 14, 2026 10:24:46 AM
# @version: 0.0.1
YACC=bison
BLD=build
SRC=src/parser

all: $(BLD)/parsercxx

	$(BLD)/parsercxx: $(BLD)/parsercxx.cc
		$(CXX) -g -std=c++14 -I$(BLD) -o $@ $<

	$(BLD)/parsercxx.cc $(BLD)/parsercxx.hh: $(SRC)/parsercxx.yy
		$(YACC) $(SRC)/parsercxx.yy --header -o $(BLD)/parsercxx.cc
