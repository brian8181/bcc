CXX       = c++
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

all: flexexample3xx flexexample11xx

flexexample3: flexexample3.l flexexample3.y
			$(YACC) -d flexexample3.y
			$(REFLEX) $(REFLAGS) --flex --bison --header-file flexexample3.l
			$(CC) $(CXXFLAGS) -c y.tab.c
			$(CXX) $(CXXFLAGS) -o $@ y.tab.o lex.yy.cpp $(LIBREFLEX)
			./flexexample3 < flexexample3.test

flexexample3xx: flexexample3.lxx flexexample3.yxx
			$(BISON) -d flexexample3.yxx
			$(REFLEX) $(REFLAGS) --flex --bison --header-file flexexample3.lxx
			$(CXX) $(CXXFLAGS) -o $@ flexexample3.tab.cxx lex.yy.cpp $(LIBREFLEX)
			./flexexample3xx < flexexample3.test

flexexample11xx: flexexample11.lxx flexexample11.yxx
			$(BISON) -d flexexample11.yxx
			$(REFLEX) $(REFLAGS) --bison-complete --bison-locations flexexample11.lxx
			$(CXX) $(CXXFLAGS) -o $@ parser.cpp scanner.cpp $(LIBREFLEX)
			./flexexample11xx < flexexample11.test

.PHONY: clean
clean:
	-rm y.tab.o lex.yy.cpp
	-rm flexexample3xx
	-rm flexexample11xx
	-rm parser.cpp parser.hpp 
	-rm scanner.cpp scanner.hpp
	-rm lex.yy.h
