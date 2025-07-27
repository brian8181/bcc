SRC=src
BLD=build
OBJ=build

all: $(BLD)/lex.yy.cpp $(BLD)/flexexample7.tab.cxx

$(BLD)/lex.yy.cpp $(BLD)/lex.yy.hpp: $(SRC)/flexexample7.lxx
	reflex --flex --bison-locations $(SRC)/flexexample7.lxx --header-file=$(BLD)/lex.yy.hpp -o $(BLD)/lex.yy.cpp
	mv lex.yy.h $(BLD)/lex.yy.h

$(BLD)/flexexample7.tab.cxx:
	bison -d $(SRC)/flexexample7.yxx -o $(BLD)/flexexample7.tab.cxx
	#mv flexexample7.tab.hxx $(BLD)/flexexample7.tab.hxx

clean:
	-rm $(BLD)/*
