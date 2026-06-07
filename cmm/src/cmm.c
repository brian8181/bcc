/**
 * @file    cmm.c
 * @version version 0.0.1
 * @date    Sun, 07 Jun 2026 03:21:16 +0000
 */
#include <stdio.h>
#include <getopt.h>
#include "bash_color.h"
#include "cmm.h"

const char* VERSION_STRING = "0.0.1";
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
	printf("cmm: %s\n", VERSION_STRING);
}

void print_help()
{
	printf("%sUsage:  %s\n%scmm [-hvr][...] %s\n", FMT_FG_WHITE, FMT_RESET, FMT_FG_WHITE, FMT_RESET);
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
				return 0;
			case 'v':
				print_version();
				return 0;
		}
	}

	if (argc < DEFAULT_ARGC) // not correct number of args
	{
		char* err=  "Expected argument after options, -h for help\n";
		printf("%s", err);
		return -1;
	}

	char* path = argv[0];   // get exe file path
	printf("%s\n", path);
	
	return 0;
}
