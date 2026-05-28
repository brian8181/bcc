/**
 * @file    abc.hpp
 * @version version 0.0.1
 * @date    Wed, 27 May 2026 18:43:33 +0000
 */
#include <iostream>
#include <string>
#include <cstring>
#include <unistd.h>         /* for STDIN_FILENO */
#include <sys/select.h>     /* for pselect   */
#include <string>
#include <getopt.h>
#include "config.hpp"
#include "abc.hpp"


// constants
const int DEFAULT_ARGC = 2;
const string VERSION_STRING = "rx 2.90";

// options flags
const unsigned short VERBOSE = 0x01;
const unsigned short IGNORE_CASE = 0x02;
const unsigned short SINGLE_MATCH = 0x04;
const unsigned short PRETTY_PRINT = 0x08;
const unsigned short GROUPS = 0x10;
const unsigned short EXTENDED_REGX = 0x20;
const unsigned short REGEX_OPTIONS = 0x40;
const unsigned short SEARCH_FROM_FILE = 0x80;
const unsigned short REGEX_FROM_FILE = 0x100;
const unsigned short DEFAULTS = PRETTY_PRINT | EXTENDED_REGX;

// Set Defaults
unsigned short OPTION_FLAGS = DEFAULTS;
regex::flag_type REGX_FLAGS = regex::ECMAScript;

static struct option long_options[] =
{
	{"verbose", no_argument, 0, 'v'},
	{"help", no_argument, 0, 'h'},
	{"icase", no_argument, 0, 'i'},
	{"single", no_argument, 0, 's'},
	{"groups", no_argument, 0, 'g'},
	{"pretty", no_argument, 0, 'P'},        //default
	{"no-pretty", no_argument, 0, 'p'},
	{"version", no_argument, 0, 'r'},
	{"not_extended", no_argument, 0, 'e'},
	{"extended", no_argument, 0, 'E'},      //default
	{"options", required_argument, 0, 'o'}, //default
	{"file", required_argument, 0, 'f'},
	{"regex_file", required_argument, 0, 'x'}
};

map<std::string, regex::flag_type> regex_flags =
{
	{"ECMAScript", regex::ECMAScript},
	{"basic", regex::basic},
	{"extended", regex::extended},
	{"awk", regex::awk},
	{"grep", regex::grep},
	{"egrep", regex::egrep},
	{"icase", regex::icase},
	{"nosubs", regex::nosubs},
	{"optimize", regex::optimize},
	{"collate", regex::collate},//
	//{"multiline". regex::multiline} (since C++17)
};

void print_version()
{
	cout << VERSION_STRING << endl;
}

void print_help()
{
	cout << "Usage: "
		<< FMT_BOLD << "rx" << FMT_RESET << " "
		<< FMT_UNDERLINE << "[OPTION]..." << FMT_RESET << " "
		<< FMT_UNDERLINE << "PATTERN" << FMT_RESET << " "
		<< FMT_UNDERLINE << "INPUT..." << FMT_RESET << endl;
}

void print_match_header( const string& pattern, const string& src, int count, int len )
{
	if( OPTION_FLAGS & PRETTY_PRINT )
	{
		if( len > 1 ) cout << count << ": "; // input number / count
		cout << FMT_FG_RED << ( ( OPTION_FLAGS & SINGLE_MATCH ) ? "Single Match Pattern: " : "Match Pattern: " ) << FMT_RESET
			<< "'" << FMT_FG_YELLOW << pattern << FMT_RESET << "'"
			<< " -> "
			<< FMT_FG_RED << "Input: " << FMT_RESET
			<< "'" << FMT_FG_YELLOW << src << FMT_RESET << "'";
	}
}

/**
 * @brief  stdin_ready function
 * @param  int filedes : the file handle
 * @return ready or error code
 */
int stdin_ready (int filedes)
{
        fd_set set;
        // declare/initialize zero timeout
#ifndef CYGWIN
        struct timespec timeout = { .tv_sec = 0 };
#else
        struct timeval timeout = { .tv_sec = 0 };
#endif
        // initialize the file descriptor set
        FD_ZERO(&set);
        FD_SET(filedes, &set);

        // check stdin_ready is ready on filedes
#ifndef CYGWIN
        return pselect(filedes + 1, &set, NULL, NULL, &timeout, NULL);
#else
        return select(filedes + 1, &set, NULL, NULL, &timeout);
#endif
}

/**
 * @brief main function
 * @param argc : param count in argv
 * @param argv : command line parameters
 * @return 0 success : or error
 */
int main(int argc, char* argv[])
{
	try
	{
		char* argv_cpy[sizeof(char*) * (argc+1)];
		if(stdin_ready(STDIN_FILENO))
		{
			std::string buffer;
			std::cin >> buffer;
			memcpy(argv_cpy, argv, sizeof(char*) * argc);
			argv_cpy[argc] = &buffer[0];
			++argc;
			return parse_options(argc, argv_cpy);
		}
		return parse_options(argc, argv);
	}
	catch(std::runtime_error& ex)
	{
	 	std::cout << ex.what() << std::endl;
		std::exit(-1);
	}
	catch(std::logic_error& ex)
	{
		std::cout << ex.what() << std::endl;
		std::exit(-1);
	}
}
