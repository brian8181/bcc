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
#include "pparser.tab.hpp"

static string g_config_file = "default.conf";
static string g_output_dir = "./test/build";
static string g_output_file = "out.obj";
static string g_input_file = "in.txt";

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

#ifndef _TEST123_
/**
 * @brief driver entry point for the application
 * @param argc
 * @param argv
 * @return
 */
int main(int argc, char* argv[]);
#endif

/**
 * @brief
 * @param
 */

yy::parser::symbol_type lex();

#endif // SCANNER_HPP_
