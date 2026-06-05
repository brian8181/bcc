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
CXXFLAGS=-std=gnu++17 -fPIC
CCFLAGS = -g -DLEX_TEST
LDFLAGS =
FLEXFLAGS = --flex
BISONFLAGS = -y -d --html --graph
OPTIONS=
DEBUG=
WARN=

PRJ = .
BLD = $(PRJ)/build
OBJ = $(PRJ)/$(BLD)
SRC = $(PRJ)/src
AST = $(PRJ)/ast
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
FMT=$(FMT_INFO)

# lib settings
INCLUDES=-I/usr/local/include/cppunit/ -I"/home/brian/src/boost_1_91_0" -I./$(SRC) -I./$(BLD) -I./$(TST)
LIBS=-L/usr/lib -L/usr/lib64 -L/usr/local/lib -L/usr/local/lib64 -lfmt
LDFLAGS=$(INCLUDES) $(LIBS) $(INC)

ifdef VER2
	CXXFLAGS+=-DVER2
endif

ifdef OPTIONS
	CXXFLAGS+=-DOPTIONS
endif

ifdef CLANG
	@echo "$(FMT)CLANG ...$(FMT_RESET)"
	CXX=clang++
endif

ifdef WARNING
	CXXFLAGS+=-DWARNING
endif

ifndef RELEASE
	CXXFLAGS+=-ggdb -DDEBUG -DWARNINGS -DTRACING -DYYDEBUG -DLEX_TEST
endif

ifdef CYGWIN
	@echo "$(FMT)CYGWIN ...$(FMT_RESET)"
	CXXFLAGS += -DCYGWIN
	INCLUDES += -I"/home/brian/src/boost_1_91_0"
	LIBS += /usr/local/lib/libfmt.a -lcppunit.dll
endif
ifdef MSYS_UCRT
	@echo "$(FMT)MSYS_UCRT ...$(FMT_RESET)"
	INCLUDES += -I/ucrt64/include/boost
	LIBS += /usr/lib/libfmt.dll.a
endif

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
$(SRC)/lexer.hpp \
$(SRC)/on_token.hpp \
$(SRC)/driver.hpp \
$(SRC)/def.hpp \
$(SRC)/table.hpp \
$(SRC)/def.h \

HEADER_ONLY= \
$(BLD)/pparser.tab.hpp \
$(SRC)/def.hpp \
$(SRC)/log.hpp \
$(SRC)/table.hpp

OBJS= \
$(OBJ)/fileio.o \
$(OBJ)/auto_ptr.o \
$(OBJ)/utility.o \
$(OBJ)/pparser.tab.o \
$(OBJ)/lexer.o \
$(OBJ)/driver.o \
$(OBJ)/symtab.o \


OBJS2= \
$(OBJ)/fileio.o \
$(OBJ)/auto_ptr.o \
$(OBJ)/utility.o \
$(OBJ)/parser.tab.o \
$(OBJ)/lexer.o \
$(OBJ)/on_token.o \
$(OBJ)/driver.o \
$(OBJ)/symtab.o \

TST_OBJS= \
$(OBJ)/fileio.o \
$(OBJ)/auto_ptr.o \
$(OBJ)/utility.o \
$(OBJ)/symtab.o \
$(OBJ)/lexer.o \
$(OBJ)/on_token.o \
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
# $(SRC)/ast/variant.hpp \
# $(BLD)/cpp.tab.hpp $(BLD)/cpp.tab.o \
# $(BLD)/pparser.tab.hpp $(BLD)/pparser.tab.o \
# $(SRC)/parser.hpp $(OBJ)/parser.o \
# $(SRC)/lexer.hpp $(OBJ)/lexer.o \
# $(SRC)/driver.hpp $(OBJ)/driver.o \
SOURCES=$(HEADERS) $(OBJS)

# build all
all: $(BLD)/$(APP)
	@echo "$(FMT)finished building ...$(FMT_RESET)"

# build everything
#world: $(BLD)/$(APP) $(BLD)/TEST_lex $(BLD)/lib$(APP).a

$(BLD)/$(APP): $(OBJS) $(SRC)/defv1.hpp $(OBJ)/on_tokenv1.o
	@echo "$(FMT)$(RELEASE)-building prequisite -> $^ ... \nbuilding -> $@ ...$(FMT_RESET)"
	$(CXX) $(CXXFLAGS) $^ $(LDFLAGS) -o $@

$(BLD)/$(APP)2: $(OBJS2) $(SRC)/v2/def.hpp $(OBJ)/v2/on_token.o 
	@echo "$(FMT)$(RELEASE)-building prequisite -> $^ ... \nbuilding -> $@ ...$(FMT_RESET)"
	$(CXX) $(CXXFLAGS) -DVER2 $^ $(LDFLAGS) -o $@

$(BLD)/parser.tab.cpp $(BLD)/parser.tab.hpp: $(SRC)/parser.yy 
	@echo "$(FMT)building prequisite -> $^ ... \nbuilding -> $@ ...$(FMT_RESET)"
	$(YACC) --debug $(SRC)/parser.yy --header=$(BLD)/parser.tab.hpp -o $(BLD)/parser.tab.cpp

$(BLD)/parser.tab.cpp $(BLD)/parser.tab.hpp: $(SRC)/parser.yy 
	@echo -e "$(FMT)building prequisite -> $^ ... \nbuilding -> $@ ...$(FMT_RESET)"
	$(YACC) --debug $(SRC)/parser.yy --header=$(BLD)/parser.tab.hpp -o $(BLD)/parser.tab.cpp

$(BLD)/pparser.tab.cpp $(BLD)/pparser.tab.hpp: $(SRC)/pparser.yy $(SRC)/lexer.cpp
	@echo "$(FMT)building prequisite -> $^ ... \nbuilding -> $@ ...$(FMT_RESET)"
	$(YACC) --debug $(SRC)/pparser.yy --header=$(BLD)/pparser.tab.hpp -o $(BLD)/pparser.tab.cpp

$(OBJ)/pparser.tab.o: $(OBJ)/pparser.tab.cpp $(BLD)/pparser.tab.hpp $(BLD)/bash_color.hpp $(SRC)/log.hpp
	@echo "$(FMT)building prequisite -> $^ ... \nbuilding -> $@ ...$(FMT_RESET)"
	$(CXX) $(CXXFLAGS) $(INCLUDES) -DYYDEBUG -c $< -o $@

$(BLD)/find_find_substrs: $(OBJ)/find_substrs.o
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $^ -o $@

$(BLD)/ast: $(OBJ)/ast.o
	$(CXX) $(CXXFLAGS) $^ -o $@

$(BLD)/lib$(APP).so: $(OBJS) $(SRC)/def.h
	@echo "$(FMT)building prequisite -> $^ ... \nbuilding -> $@ ...$(FMT_RESET)"
	$(CXX) $(CXXFLAGS) --shared $(OBJS) -o $(BLD)/lib$(APP).so
	chmod 755 $(BLD)/lib$(APP).so

$(BLD)/lib$(APP).a:
	@echo "$(FMT)building -> $@ ...$(FMT_RESET)"
	ar rvs $(BLD)/lib$(APP).a $(OBJS)
	chmod 755 $(BLD)/lib$(APP).a

$(BLD)/TEST_lex: $(TST_OBJS) $(TST)/main.o
	@echo "$(FMT)building prequisite -> $^ ... \nbuilding -> $@ ...$(FMT_RESET)"
	$(CXX) $(CXXFLAGS) $^ $(LDFLAGS) -o $@

$(BLD)/vtest: $(SRC)/variant.cpp
	$(CXX) $(CXXFLAGS) $^ -o $@

# copy header files
$(BLD)/%.h : $(SRC)/%.h
	@echo "$(FMT)copy $^ -> $@ ...$(FMT_RESET)"
	cp $^ $@

$(BLD)/%.hpp: $(SRC)/%.hpp
	@echo "$(FMT)copy $^ -> $@ ...$(FMT_RESET)"
	cp $^ $@

# build object files
$(OBJ)/%.o: $(SRC)/%.c $(SRC)/%.h
	@echo "$(FMT)building -> $@ ...$(FMT_RESET)"
	$(CC) $(CCFLAGS) -c $< -o $@

$(OBJ)/%.o: $(SRC)/%.cpp $(SRC)/%.hpp
	@echo "$(FMT)building $< -> $@ ...$(FMT_RESET)"
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -c $< -o $@

$(OBJ)/%.o: $(TST)/%.cpp $(TST)/%.hpp
	@echo "$(FMT)building $< -> $@ ...$(FMT_RESET)"
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

.PHONY: all rebuild dist install uninstall clean help
rebuild: clean all

dist:
	tar -czvf $(APP).tar.gz ./src ./include ./makefile ./README.md ./LICENSE ./CHANGELOG.md

install:
	#cp $(BLD)/$(APP) ./$(prefix)/bin/$(APP)

uninstall:
	#-rm $(prefix)/bin/$(APP)

clean:
	@echo "$(FMT)cleaning ...$(FMT_RESET)"
	-rm -rf $(OBJ)/*
	-rm -rf $(BLD)/*

help:
	@echo  '  all              - build all'
	@echo  '  $(APP)           - build $(APP) executable'
	@echo  '  clean            - remove all files from build dir'
	@echo  '  install          - copy files to usr/local'
	@echo  '  rebuild          - clean and build all'
	@echo  '  help             - this help message'
