BLD=build
SRC=src
BASE=calc
BISON=bison
BISONFLAGS=
CXX=g++
FLEX=flex
FLEXFLAGS=

all: $(BLD)/calc

# %.cpp %.hh %.html %.gv: %.yy
# 	$(BISON) $(BISONFLAGS) --html --graph -o $*.cpp $<

$(BLD)/parser.cpp: $(SRC)/parser.yy
	$(BISON) $(BISONFLAGS) --html --graph -o $(BLD)/parser.cpp --header=$(BLD)/parser.hpp $(SRC)/parser.yy

$(BLD)/scanner.cpp: $(SRC)/scanner.ll
	$(FLEX) $(FLEXFLAGS) -o $(BLD)/scanner.cpp $(SRC)/scanner.ll

$(BLD)/parser.o: $(BLD)/parser.cpp
	$(CXX) $(CXXFLAGS) -c $(BLD)/parser.cpp -o $(BLD)/parser.o

$(BLD)/scanner.o: $(BLD)/scanner.cpp
	$(CXX) $(CXXFLAGS) -c $(BLD)/scanner.cpp -o $(BLD)/scanner.o

$(BLD)/calc.o: $(SRC)/calc.cpp
	$(CXX) $(CXXFLAGS) -c $(SRC)/calc.cpp -o $(BLD)/calc.o

$(BLD)/driver.o:
		$(CXX) $(CXXFLAGS) -c $(SRC)/driver.cpp -o $(BLD)/driver.o

$(BLD)/calc: $(BLD)/calc.o $(BLD)/driver.o $(BLD)/parser.o $(BLD)/scanner.o
	$(CXX) $(BLD)/calc.o $(BLD)/driver.o $(BLD)/parser.o $(BLD)/scanner.o -o $(BLD)/calc

run: $(BLD)/calc
	@echo "Type arithmetic expressions.  Quit with ctrl-d."
	./$< -

.PHONY: clean
clean:
	-rm -f $(BLD)/*