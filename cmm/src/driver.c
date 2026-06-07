/*
 * @file Name:  ./driver.cpp
 * @date: Thu, Sep 11, 2025  4:06:25 PM
 * @version:    0.0.1
 */

#include <iostream>
#include <cstring>
#include <unistd.h> /* for STDIN_FILENO */
#include <sys/select.h>
#include <cstdlib>
#include <getopt.h>

#ifdef VER2
#include "parser.tab.hpp"
#else
#include "pparser.tab.hpp"
#endif
#include "bash_color.h"

int SRC_IDX_OFFSET = 0;
int CONFIG_IDX_OFFSET = 0;

static bool preprocess_flag = false;
static bool compile_flag = false;
static bool output_file_flag = false;
static bool dump_flag = false;
static bool verbose_flag = false;

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
// create parser
//static yy::parser yyparser;

/**
 * @name lex
 * @return yy::parser::symbol_type
 */
// yy::parser::symbol_type lex()
// {
// 	return lexer::instance().get_token();
// }

/**
 * @brief parse command line options
 * @param argc
 * @param argv
 * @return int
 */
int parse_options(const int argc, char *argv[])
{
    // TRACE();
    int option;
    const auto options_string = "hVdpco:v";
    const struct option long_options[] = {
        {"help", no_argument, nullptr, 'h'},
        {"version", no_argument, nullptr, 'V'},
        {"config", 0, nullptr, 'c'},
        {"out", 0, nullptr, 'o'},
        {"dump", no_argument, nullptr, 'd'},
        {"verbose", no_argument, nullptr, 'v'},
        {nullptr, 0, nullptr, 0}};

    while ((option = getopt_long(argc, argv, options_string, long_options, nullptr)) != -1)
    {
        switch (option)
        {
        case 'h':
            ///cout << "Help message" << endl;
            return 0;
        case 'V':
            //cout << "Version 0.0.1" << endl;
            return 0;
        case 'c':
			compile_flag = true;
            break;
		case 'p':
            preprocess_flag = true;
            break;
        case 'o':
			if(output_file_flag)
			{
				//ERROR("Only one '-o' param allowed.");
				return 1;
			}
            output_file_flag = true;
            //g_output_file = optarg;
            break;
        case 'd':
            dump_flag = true;
            break;
        case 'v':
            verbose_flag = true;
            break;
        default:
            //cerr << "Unknown option: " << option << endl;
            return 1;
        }
    }

	// const int offset = optind;
	// if(compile_flag && argc-offset > 1)
	// {
	// 	ERROR("Only one file can be input with '-c' option.");
	// 	return 1;
	// }
    // // call c preprocessor
	// SYST("Starting pre-processing phase...");
	// vector<string> files;
	// for(int i = 0; (i+offset) < argc; ++i)
	// {
	// 	std::stringstream ss;
	// 	string file = fs::path(argv[i+offset]).stem().string();
	// 	string path = "build/";
	// 	path.append(file);
	// 	files.push_back(path);
	// 	ss << "cpp -E -P -I./include/ " << argv[i+offset] << " > ";
	// 	ss << "build/" << file << ".i";
	// 	INFO(ss.str());
	// 	system(ss.str().c_str());
	// }
	// SYST("Pre-processing phase completed.");

	// // lex, parse ...
	// SYST("Compiling...");
	// for(int i = 0; i < files.size(); ++i)
	// {
	// 	lexer::instance().init(files[i]);
    // 	lexer::instance().set_state(&PARSER);
    // 	yyparser.parse();
	// }
	// SYST("finished.");
	return 0;
}

/**
 * @brief  stdin_ready function
 * @param filedes
 * @param int filedes : the file handle
 * @return ready or error code
 */
int stdin_ready(int filedes)
{
    fd_set set;
    // declare/initialize zero timeout
#ifndef CYGWIN
    struct timespec timeout = {.tv_sec = 0};
#else
    timeval timeout = {.tv_sec = 0};
#endif
    // initialize the file descriptor set
    FD_ZERO(&set);
    FD_SET(filedes, &set);
    // check stdin_ready is ready on filedes
#ifndef CYGWIN
    return pselect(filedes + 1, &set, NULL, NULL, &timeout, NULL);
#else
    return select(filedes + 1, &set, nullptr, nullptr, &timeout);
#endif
}

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
