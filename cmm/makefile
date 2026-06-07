# @name     cmm
# @file:    makefile
# @date:    Sat Jun  6 22:21:16 CDT 2026
# @version: version 0.0.1
SHELL:=bash

APP=cmm
CC=gcc
CCFLAGS=
LDFLAGS=
LIBS=

SRC = src
BLD = build
OBJ = build
TST = build

# lib settings
LIBS=-L/usr/lib -L/usr/lib64 -L/usr/local/lib -L/usr/local/lib64
LDFLAGS=$(INCLUDES) $(LIBS)

all: $(BLD)/cmm

$(BLD)/cmm: $(OBJ)/main.o $(OBJ)/cmm.o
	 $(CC) $(CCFLAGS) $(OBJ)/main.o $(OBJ)/cmm.o -o $(BLD)/cmm #

# $(BLD)/libcmm.so: $(OBJ)/main.o $(BLD)/cmm.o
# 	$(CC) $(CCFLAGS) --shared $(OBJ)/main.o $(BLD)/cmm.o -o $(BLD)/libcmm.so
# 	-chmod 755 $(BLD)/libcmm.so

# $(BLD)/libcmm.a: $(OBJ)/main.o $(BLD)/cmm.o
# 	-ar rvs $(BLD)/libcmm.a $(OBJ)/main.o $(BLD)/cmm.o
# 	-chmod 755 $(BLD)/libcmm.a

$(OBJ)/cmm.o: $(SRC)/cmm.c
	$(CC) $(CCFLAGS) -c $(SRC)/cmm.c -o $(OBJ)/cmm.o

# copy header to build dir
$(BLD)/%.h: $(SRC)/%.h
	-cp $^ $@

$(OBJ)/%.o: ./$(SRC)/%.c
	$(CC) $(CCFLAGS) -c -o $@ $<

#
.PHONY: all clean install unintsall rebuild help

rebuild: clean all

install:
	cp ./$(BLD)/cmm ./$(prefix)/bin/cmm
uninstall:
	-rm ./$(prefix)/bin/cmm
clean:
	@ECHO "removing files ..."
	-rm -f $(OBJ)/*
	-rm -f $(BLD)/*

help:
	@echo
	@echo  'Project: cmm : version 0.0.1 : Sat Jun  6 22:21:16 CDT 2026 simple "cmm" framework.'
	@echo
	@echo  '    make [-f] [target]'
	@echo
	@echo  '   -Make Targets ...'
	@echo
	@echo  '        * all                              - build all'
	@echo  '        * $(BLD)/cmm:          - re/build cmm'
	@echo  '        * $(BLD)/cmm_utest:    - re/build cmm_utest, unit testing'
	@echo  '        * clean                            - remove most generated files but keep the config'
	@echo
