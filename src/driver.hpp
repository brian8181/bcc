/* Driver for calc++.   -*- C++ -*-

   Copyright (C) 2005-2015, 2018-2021 Free Software Foundation, Inc.

   This file is part of Bison, the GNU Compiler Compiler.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

#ifndef DRIVER_HH
#define DRIVER_HH

#include <string>
#include <map>
#include "parser.hpp"

// give flex the prototype of yylex we want
# define YY_DECL yy::parser::symbol_type yylex(driver& drv)
YY_DECL; // declare it for the parser's sake

// conduct scanning and parsing
class driver
{
public:
    driver();
    int parse(const std::string& f);
    void scan_begin();
    void scan_end();

public:
    std::map<std::string, int> variables;
    int result;             // run the parser on file F, return 0 on success
    std::string file;       // file being parsed
    bool trace_parsing;     // generate parser debug traces
    bool trace_scanning;    // generate scanner debug traces
    yy::location location;  // token's location used by the scanner
};

#endif // ! DRIVER_HH
