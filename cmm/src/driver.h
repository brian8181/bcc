/**
 * @file driver.hpp
 * @brief Header file for driver.cpp
 * @version 1.0
 * @date 2024-06-01
 */
#ifndef SCANNER_HPP_
#define SCANNER_HPP_
#define YYDEBUG 1

#include "fileio.hpp"

#ifdef VER2
#include "parser.tab.hpp"
#else
#include "pparser.tab.hpp"
#endif

/**
 * @brief parse command line options
 * @param argc
 * @param argv
 * @return
 */
int parse_options(int argc, char* argv[]);

/**
 * @brief check if stdin is ready for reading
 * @param filedes
 * @return
 */
int stdin_ready (int filedes);

/**
 * @brief driver entry point for the application
 * @param argc
 * @param argv
 * @return
 */
int main(int argc, char* argv[]);

/**
 * @brief
 * @param
 */

//yy::parser::symbol_type lex();

#endif // SCANNER_HPP_
