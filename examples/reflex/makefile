CXX=g++
LEX=reflex

all:
	$(LEX) --flex -o example_lexer.hpp ./example.l
	$(CXX) -std=c++17  main.cpp -o lexer_example
