# @name     apm
# @file:    makefile
# @date:    Wed Jun 17 14:07:46 CDT 2026
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

APP=apm
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

all: $(BLD)/apm $(BLD)/libapm.so $(BLD)/libapm.a $(BLD)/TEST_apm #

$(BLD)/apm: $(OBJ)/main.o $(OBJ)/apm.o
	 $(CXX) $(CXXFLAGS) $(OBJ)/main.o $(OBJ)/apm.o -o $(BLD)/apm #

$(BLD)/libapm.so: $(OBJ)/main.o $(BLD)/apm.o
	$(CXX) $(CXXFLAGS) $(CXXEXTRA) --shared $(OBJ)/main.o $(BLD)/apm.o -o $(BLD)/libapm.so
	-chmod 755 $(BLD)/libapm.so

$(BLD)/libapm.a: $(OBJ)/main.o $(BLD)/apm.o
	-ar rvs $(BLD)/libapm.a $(OBJ)/main.o $(BLD)/apm.o
	-chmod 755 $(BLD)/libapm.a

$(OBJ)/apm.o: $(SRC)/apm.cpp
	$(CXX) $(CXXFLAGS) $(CXXEXTRA) -c $(SRC)/apm.cpp -o $(OBJ)/apm.o

$(BLD)/TEST_apm: $(OBJ)/apm.o $(OBJ)/TEST_apm.o
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
	cp ./$(BLD)/apm ./$(prefix)/bin/apm
uninstall:
	-rm ./$(prefix)/bin/apm
clean:
	@ECHO "removing files ..."
	-rm -f $(OBJ)/*
	-rm -f $(BLD)/*

help:
	@echo
	@echo  'Project: apm : version 0.0.1 : Wed Jun 17 14:07:46 CDT 2026 simple "apm" framework.'
	@echo
	@echo  '    make [-f] [target]'
	@echo
	@echo  '   -Make Targets ...'
	@echo
	@echo  '        * all                              - build all'
	@echo  '        * $(BLD)/apm:          - re/build apm'
	@echo  '        * $(BLD)/apm_utest:    - re/build apm_utest, unit testing'
	@echo  '        * clean                            - remove most generated files but keep the config'
	@echo
