# @name     abc
# @file:    makefile
# @date:    Wed May 27 01:43:33 PM CDT 2026
# @version: version 0.0.1

# g++ warnings
#-Wall -Wextra -Wpedantic -Wshadow -Wconversion -Werror -Wundef
#-fsanitize=undefined,address -Wfloat-equal -Wformat-nonliteral
#-Wformat-security -Wformat-y2k -Wformat=2 -Wimport -Winvalid-pch
#-Wlogical-op -Wmissing-declarations -Wmissing-field-initializers
#-Wmissing-format-attribute -Wmissing-include-dirs -Wmissing-noreturn
#-Wnested-externs -Wpacked -Wpointer-arith -Wredundant-decls
#-Wstack-protector -Wstrict-null-sentinel -Wswitch-enum -Wwrite-strings

SHELL:=bash

APP=abc
CXX=g++
CXXFLAGS=-Wall -std=c++20 -fPIC
CXXEXTRA=-Wno-template-body
CXXCPP=
LDFLAGS=
LIBS=

SRC = src
BLD = build
OBJ = build
TST = build

# lib settings
LIBS=-L/usr/lib -L/usr/lib64 -L/usr/local/lib -L/usr/local/lib64
INCLUDES=-I/usr/local/include/cppunit/
LDFLAGS=$(INCLUDES) $(LIBS)

ifndef RELEASE
	CXXFLAGS +=-g -DDEBUG
endif

ifdef CYGWIN
	CXXFLAGS +=-DCYGWIN
	LDFLAGS += -lfmt -lcppunit.dll
else
	LDFLAGS += -lfmt -lcppunit
endif

all: $(BLD)/abc $(BLD)/libabc.so $(BLD)/libabc.a $(BLD)/TEST_abc #

$(BLD)/abc: $(OBJ)/main.o $(OBJ)/abc.o
	 $(CXX) $(CXXFLAGS) $(OBJ)/main.o $(OBJ)/abc.o -o $(BLD)/abc #

$(BLD)/libabc.so: $(OBJ)/main.o $(BLD)/abc.o
	$(CXX) $(CXXFLAGS) $(CXXEXTRA) --shared $(OBJ)/main.o $(BLD)/abc.o -o $(BLD)/libabc.so
	-chmod 755 $(BLD)/libabc.so

$(BLD)/libabc.a: $(OBJ)/main.o $(BLD)/abc.o
	-ar rvs $(BLD)/libabc.a $(OBJ)/main.o $(BLD)/abc.o
	-chmod 755 $(BLD)/libabc.a

$(OBJ)/abc.o: $(SRC)/abc.cpp
	$(CXX) $(CXXFLAGS) $(CXXEXTRA) -c $(SRC)/abc.cpp -o $(OBJ)/abc.o

$(BLD)/TEST_abc: $(OBJ)/abc.o $(OBJ)/TEST_abc.o
	$(CXX) $(CXXFLAGS) $^ $(LDFLAGS) -o $@

# rules <?= "\nTEST\n ?>
# copy header to build dir
$(BLD)/%.hpp: $(SRC)/%.hpp
	-cp $^ $@

$(OBJ)/%.o: ./$(SRC)/%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

#
.PHONY: all clean install unintsall rebuild help

rebuild: clean all

install:
	cp ./$(BLD)/abc ./$(prefix)/bin/abc
uninstall:
	-rm ./$(prefix)/bin/abc
clean:
	@ECHO "removing files ..."
	-rm -f $(OBJ)/*
	-rm -f $(BLD)/*

help:
	@echo
	@echo  'Project: abc : version 0.0.1 : Wed May 27 01:43:33 PM CDT 2026 simple "abc" framework.'
	@echo
	@echo  '    make [-f] [target]'
	@echo
	@echo  '   -Make Targets ...'
	@echo
	@echo  '        * all                              - build all'
	@echo  '        * $(BLD)/abc:          - re/build abc'
	@echo  '        * $(BLD)/abc_utest:    - re/build abc_utest, unit testing'
	@echo  '        * clean                            - remove most generated files but keep the config'
	@echo
