/**
 * @file    apm.hpp
 * @version version 0.0.1
 * @date    Wed, 17 Jun 2026 19:07:46 +0000
 */
#ifndef _apm_HPP
#define _apm_HPP

#include <string>

using std::string;

void print_help();
void print_version();
int parse_options(int argc, char* argv[]);

#endif
