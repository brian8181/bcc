# @file: makefile
# @date: Mon Sep  8 00:03:12 CDT 2025
# @version: 0.0.2
APP = bcc
CXX = g++
#CXX = x86_64-pc-cygwin-g++
CC = gcc
#LEX = reflex
LEX = flex
#YACC = bison -y
YACC = bison
YFLAGS = -YYDEBUG
CXXFLAGS = -std=gnu++17 -fPIC
CCFLAGS = -g -DLEX_TEST -DDEBUG
LDFLAGS =
FLEXFLAGS = --flex
BISONFLAGS = -y -d --html --graph
BLD = build
OBJ = build
SRC = src
AST = ast
TST = $(SRC)/unit_test

SRC_EXT=cpp
HDR_EXT=hpp
OBJ_EXT=obj

FMT_RESET=\e[0m
FMT_ITALIC=\e[3m
FMT_RED='\e[31m'
FMT_GREEN=\e[32m
FMT_YELLOW='\e[33m'
FMT_BLUE='\e[34m'
FMT_CYAN='\e[36m'
FMT_INFO=$(FMT_ITALIC)$(FMT_GREEN)
FMT_WARN=$(FMT_ITALIC)$(FMT_YELLOW)

# lib settings
INCLUDES=-I/usr/local/include/cppunit/ -I"/home/brian/src/boost_1_91_0" -I./$(SRC) -I./$(BLD) -I./$(TST)
LIBS=-L/usr/lib -L/usr/lib64 -L/usr/local/lib -L/usr/local/lib64 -lfmt

ifdef CLANG
	CXX=clang++
endif

ifndef RELEASE
	CXXFLAGS+=-ggdb -DDEBUG -DWARNINGS -DTRACING -DYYDEBUG -DLEX_TEST
endif

ifdef CYGWIN
	CXXFLAGS += -DCYGWIN
	INCLUDES += -I"/home/brian/src/boost_1_91_0"
	LIBS += /usr/local/lib/libfmt.a -lcppunit.dll
endif
ifdef MSYS_UCRT
	INCLUDES += -I/ucrt64/include/boost
	LIBS += /usr/lib/libfmt.dll.a
endif

LDFLAGS=$(INCLUDES) $(LIBS)

# ifdef TRACEING
# CXXFLAGS += -DTRACING
# endif

CXXFLAGS+=-DTEST_ONLY
#CXXFLAGS+=DDEBUG1

HEADERS= \
$(SRC)/bash_color.hpp \
$(SRC)/log.hpp \
$(SRC)/fileio.hpp \
$(SRC)/auto_ptr.hpp \
$(SRC)/utility.hpp \
$(SRC)/ast.hpp \
$(BLD)/pparser.tab.hpp \
$(SRC)/parser.hpp \
$(SRC)/lexer.hpp \
$(SRC)/on_token.hpp \
$(SRC)/driver.hpp \
$(SRC)/def.hpp \
$(SRC)/table.hpp \
$(SRC)/def.h \


HEADER_ONLY= \
//$(BLD)/cpp.tab.hpp \
$(BLD)/pparser.tab.hpp \
$(SRC)/def.hpp \
$(SRC)/log.hpp \
$(SRC)/table.hpp

OBJS= \
$(OBJ)/fileio.o \
$(OBJ)/auto_ptr.o \
$(OBJ)/utility.o \
$(BLD)/pparser.tab.o \
$(OBJ)/parser.o \
$(OBJ)/lexer.o \
$(OBJ)/on_token.o \
$(OBJ)/driver.o \
$(OBJ)/symtab.o \
#$(OBJ)/index.o
#$(OBJ)/def.o

TST_OBJS= \
$(OBJ)/fileio.o \
$(OBJ)/auto_ptr.o \
$(OBJ)/utility.o \
$(OBJ)/symtab.o \
$(OBJ)/lexer.o \
$(OBJ)/on_token.o \
$(OBJ)/ast.o \
$(OBJ)/TEST_lex.o \
$(OBJ)/TEST_general.o \
$(OBJ)/TEST_symbol_table.o \
$(OBJ)/TEST_ast.o \
$(OBJ)/TEST_assign_expr.o \
$(OBJ)/TEST_expr.o

# SOURCES=$(SRC)/bash_color.hpp \
# $(SRC)/log.hpp \
# $(SRC)/fileio.hpp $(OBJ)/fileio.o \
# $(SRC)/auto_ptr.hpp $(OBJ)/auto_ptr.o \
# $(SRC)/utility.hpp $(OBJ)/utility.o \
# $(SRC)/ast.hpp \
# $(BLD)/cpp.tab.hpp $(BLD)/cpp.tab.o \
# $(BLD)/pparser.tab.hpp $(BLD)/pparser.tab.o \
# $(SRC)/parser.hpp $(OBJ)/parser.o \
# $(SRC)/lexer.hpp $(OBJ)/lexer.o \
# $(SRC)/driver.hpp $(OBJ)/driver.o \
SOURCES=$(HEADERS) $(OBJS)

# build everything
world: $(BLD)/$(APP) $(BLD)/TEST_lex $(BLD)/lib$(APP).a

# build all
all: $(BLD)/$(APP) $(BLD)/TEST_lex

$(BLD)/$(APP): $(OBJS) $(SRC)/def.hpp
	$(CXX) $(CXXFLAGS) $^ $(LDFLAGS) -o $@

$(BLD)/path_append: $(OBJ)/path_append.o
	$(CXX) $(CXXFLAGS) $^ -o $@

$(BLD)/pparser.tab.cpp $(BLD)/pparser.tab.hpp: $(SRC)/pparser.yy $(SRC)/lexer.cpp
	$(YACC) --debug $(SRC)/pparser.yy --header=$(BLD)/pparser.tab.hpp -o $(BLD)/pparser.tab.cpp

$(OBJ)/pparser.tab.o: $(OBJ)/pparser.tab.cpp $(BLD)/pparser.tab.hpp $(BLD)/bash_color.hpp $(SRC)/log.hpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -DYYDEBUG -c $< -o $@

$(BLD)/find_find_substrs: $(OBJ)/find_substrs.o
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $^ -o $@

$(BLD)/ast: $(OBJ)/ast.o
	$(CXX) $(CXXFLAGS) $^ -o $@

$(BLD)/lib$(APP).so: $(OBJS) $(SRC)/def.h
	$(CXX) $(CXXFLAGS) --shared $(OBJS) -o $(BLD)/lib$(APP).so
	chmod 755 $(BLD)/lib$(APP).so

$(BLD)/lib$(APP).a:
	ar rvs $(BLD)/lib$(APP).a $(OBJS)
	chmod 755 $(BLD)/lib$(APP).a

$(BLD)/TEST_lex: $(TST_OBJS) $(OBJ)/main.o
	$(CXX) $(CXXFLAGS) -I/src -I/build  $^ -L/usr/lib -L/usr/lib64 -L/usr/local/lib -L/usr/local/lib64 -lfmt -I/usr/local/include/cppunit -lcppunit $(LDFLAGS) -o $@

# copy header files
$(BLD)/%.h : $(SRC)/%.h
	cp $^ $@

$(BLD)/%.hpp: $(SRC)/%.hpp
	cp $^ $@

# build object files
$(OBJ)/%.o: $(SRC)/%.c $(SRC)/%.h
	$(CC) $(CCFLAGS) -c $< -o $@

$(OBJ)/%.o: $(SRC)/%.cpp $(SRC)/%.hpp
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -c $< -o $@

$(OBJ)/%.o: $(TST)/%.cpp $(TST)/%.hpp # $(HEADERS)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

.PHONY: all rebuild dist install uninstall clean help
rebuild: clean all

dist:
	tar -czvf $(APP).tar.gz ./src ./include ./makefile ./README.md ./LICENSE ./CHANGELOG.md

install:
	#cp ./$(BLD)/$(APP) ./$(prefix)/bin/$(APP)

uninstall:
	#-rm ./$(prefix)/bin/$(APP)

clean:
	@echo -e "$(FMT)cleaning ...$(FMT_RESET)"
	-rm -rf ./$(OBJ)/*
	-rm -rf ./$(BLD)/*

help:
	@echo  '  all              - build all'
	@echo  '  $(APP)           - build $(APP) executable'
	@echo  '  clean            - remove all files from build dir'
	@echo  '  install          - copy files to usr/local'
	@echo  '  rebuild          - clean and build all'
	@echo  '  help             - this help message'
