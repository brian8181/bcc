#!/bin/php

<?php
    $APPNAME=$argv[1];
    $DATE=date("l") ;
    ?>

# File:  ./makefile
# Date: <?php echo "$DATE\n"; ?>
# Version:    0.1.0

CXX=g++
CXXFLAGS=-Wall -std=c++17
CXXEXTRA=-fPIC
APP_NAME=<?php echo "$APPNAME\n"; ?>
BLD=build
OBJ=build
SRC=src
DEBUG=1

# INSERT <?php echo("\r$DATE"); ?>

ifdef DEBUG
	CXXFLAGS += -g -DDEBUG
endif

all: $(BLD)/<?php echo $APPNAME ?> $(BLD)/lib<?php echo $APPNAME ?>.so $(BLD)/lib<?php echo $APPNAME ?>.a 

$(BLD):
	-echo testing ...
	#-if not exist $(BLD) mkdir "./$(BLD)"
	exit 1

$(BLD)/<?php echo $APPNAME ?>: $(OBJ)/<?php echo $APPNAME ?>.o #CCSK_PREREQUISTE#
	 $(CXX) $(CXXFLAGS) -o $(BLD)/<?php echo $APPNAME ?> $(OBJ)/<?php echo $APPNAME ?>.o #CCSK_PREREQUISTE#

$(BLD)/lib<?php echo $APPNAME ?>.so: $(BLD)/<?php echo $APPNAME ?>.o
	$(CXX) $(CXXFLAGS) $(CXXEXTRA) --shared $(BLD)/<?php echo $APPNAME ?>.o -o $(BLD)/lib<?php echo $APPNAME ?>.so
	-chmod 755 $(BLD)/lib<?php echo $APPNAME ?>.so

$(BLD)/lib<?php echo $APPNAME ?>.a: $(BLD)/<?php echo $APPNAME ?>.o
	-ar rvs $(BLD)/lib<?php echo $APPNAME ?>.a $(BLD)/<?php echo $APPNAME ?>.o
	-chmod 755 $(BLD)/lib<?php echo $APPNAME ?>.a

$(OBJ)/<?php echo $APPNAME ?>.o: $(SRC)/<?php echo $APPNAME ?>.cpp
	$(CXX) $(CXXFLAGS) $(CXXEXTRA) -c $(SRC)/<?php echo $APPNAME ?>.cpp -o $(OBJ)/<?php echo $APPNAME ?>.o

#CCSK_RULE#

.PHONY: all clean
clean:
	-rm -f $(OBJ)/*.
	-rm -f $(BLD)/*
