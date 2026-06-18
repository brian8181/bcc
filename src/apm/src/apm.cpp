/**
 * @file    apm.hpp
 * @version version 0.0.1
 * @date    Wed, 17 Jun 2026 19:07:46 +0000
 */
#include <iostream>
#include <getopt.h>
#include "apm.hpp"
#include "bash_color.hpp"

using std::string;
using std::cout;
using std::cerr;
using std::endl;

const string VERSION_STRING = "0.0.1";
const int DEFAULT_ARGC = 0;
const unsigned short VERBOSE          = 0x01;
const unsigned short DEFAULTS         = 0x00;
const unsigned short FIELDS           = 0x02;
unsigned short options = DEFAULTS;
char DELIMITER = ',';

static struct option long_options[] =
{
        {"verbose", no_argument, 0, 'v'},
        {"help", no_argument, 0, 'h'},
        {"version", no_argument, 0, 'r'},
};

unsigned short OPTION_FLAGS = DEFAULTS;

void print_version()
{
	cout << VERSION_STRING << endl;
}

void print_help()
{
	cout	<< endl
			<< FMT_BOLD      << FMT_FG_GREEN << "Usage: " << FMT_RESET << endl
			<< FMT_BOLD      << " $APP_NAME " << FMT_RESET << " "
			<< FMT_FG_BLUE   << "[-hvr][...]"             << FMT_RESET << " "
         												  <<  endl << endl;
}

int parse_options(int argc, char* argv[])
{
	int opt = 0;
	int option_index = 0;
	optind = 0;
	while ((opt = getopt_long(argc, argv, "hv ", long_options, &option_index)) != -1)
	{
		switch (opt)
		{
			case 'h':
				print_help();
			case 'v':
				print_version();
				return 0;
		}
	}

	if (argc < DEFAULT_ARGC) // not correct number of args
	{
		cerr << "Expected argument after options, -h for help" << endl;
		return -1;
	}

	string path = argv[0];   // get exe file path
	cout << argv[0] << endl;

	return 0;
}
