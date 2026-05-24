/*
 * @file Name:  ./driver.cpp
 * @date: Thu, Sep 11, 2025  4:06:25 PM
 * @version:    0.0.1
 */

#include <iostream>
#include <cstring>
#include <unistd.h> /* for STDIN_FILENO */
#if defined(_WIN32)
// Windows-specific code (e.g., MSYS2 UCRT64)
#include <winsock2.h>
#elif defined(__linux__)
// Linux-specific code (e.g., Fedora, Ubuntu)
#include <sys/select.h>
#elif defined(__unix__)
// Other Unix-like systems (e.g., BSD, macOS)
#include <sys/select.h>
#endif
#include <string>
#include <getopt.h>
#include <set>
#include <filesystem>
#include "driver.hpp"
#include "lexer.hpp"
#include "pparser.tab.hpp"
//#include "cpp.tab.hpp"
#include "parser.hpp"
#include "bash_color.hpp"
#include "utility.hpp"
#include "log.hpp"
#include "streamy.hpp"

using std::cerr;
using std::cout;
using std::endl;
using std::string;
namespace fs = std::filesystem;

constexpr int SRC_IDX_OFFSET = 0;
constexpr int CONFIG_IDX_OFFSET = 0;

static bool config_flag = false;
static bool output_file_flag = false;
static bool dump_flag = false;
static bool verbose_flag = false;

//[[maybe_unused]] static vector<token_value_t> g_match_squence;

// create parser
static yy::parser yyparser;
//static yy::preprocessor pparser;

/**
 * @name lex
 * @return yy::parser::symbol_type
 */
// yy::parser::symbol_type pp_lex()
// {
//     TRACE();
// 	return lexer::instance().get_token();
// }

/**
 * @name lex
 * @return yy::parser::symbol_type
 */
yy::parser::symbol_type lex()
{
    TRACE();
	return lexer::instance().get_token();
}

// /**
//  * @name load_config
//  * @param const string& path
//  * @return void
//  */
// void streamy::load_config(const string& path)
// {
//     const unsigned int ID_NAME_VALUE_PAIR = 0;
//     const unsigned int ID_NAME            = 1;
//     const unsigned int ID_VALUE           = 2;
//     const unsigned int ID_NUMERIC_LITERAL = 2;
//     const unsigned int ID_STRING_LITERAL  = 3;

//     // get configuration file by lines
//     vector<string> lines;
//     read_lines(path, lines);
//     // create one only section (global)
//     string section_name = "global";
//     map<string, string> section_map;
//     pair<string, map<string, string>> sp(section_name, section_map);
//     map_sections_config.insert(sp);

//     int len = lines.size();
//     for(int i = 0; i < len; ++i)
//     {
//         string line = lines[i];
//         regex rgx = regex(CONFIG_PAIR);
//         smatch match;
//         regex_match(line, match, rgx);

//         if(match[ID_NAME_VALUE_PAIR].matched)
//         {
//             // get name
//             string symbol_name = match[ID_NAME].str();

//             // get value
//             string value = (match[ID_VALUE].matched) ?
//                 match[ID_NUMERIC_LITERAL].str() : match[ID_STRING_LITERAL].str();

//             // create pair
//             pair<string, string> p(symbol_name, value);
//             map_sections_config[section_name].insert(p);
//         }
//     }
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
    const auto options_string = "hVdc:o:v";
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
            cout << "Help message" << endl;
            return 0;
        case 'V':
            cout << "Version 0.0.1" << endl;
            return 0;
        case 'c':
            config_flag = true;
            g_config_file = optarg;
            break;
        case 'o':
            output_file_flag = true;
            g_output_file = optarg;
            break;
        case 'd':
            dump_flag = true;
            break;
        case 'v':
            verbose_flag = true;
            break;
        default:
            cerr << "Unknown option: " << option << endl;
            return 1;
        }
    }
    
    streamy strmy;
    strmy.load_config("test/config/test.conf");
    strmy.assign("x", "this is x");
    strmy.assign("y", "this is y");
    string x = strmy.get_map_vars()["x"];
    string y = strmy.get_map_vars()["y"];
    strmy.display("test/templates/test_vars.tpl"); 

    for (const auto& [key, value] : g_tokens) 
    {
        token_t tok = value;
        std::cout << "key:" << key << " { name:" << tok.name << ", index:" << tok.index << " }\n";
    }


    // do pre pocess
    
           
    const int offset = optind + SRC_IDX_OFFSET-1;
	// lexer::instance().init(argc-offset-1, argv+offset+1);
    // lexer::instance().set_state(&PRE_PROCESS);
    
    lexer::instance().init(argc-offset-1, argv+offset+1);
    lexer::instance().set_state(&INITIAL);
    yyparser.parse();
    

	return 0;
}

#ifndef _WIN32
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
#endif

/**
 * @brief main function
 * @param argc : param count in argv
 * @param argv : command line parameters
 * @return 0 success : or error
 */
int main(int argc, char *argv[])
{
    try
    {
#ifndef _WIN32
        char *argv_cpy[sizeof(char *) * argc + 1];
        if (stdin_ready(STDIN_FILENO))
        {
            std::string buffer;
            std::cin >> buffer;
            memcpy(argv_cpy, argv, sizeof(char *) * argc);
            argv_cpy[argc] = &buffer[0];
            ++argc;
            return parse_options(argc, argv_cpy);
        }
#endif
        return parse_options(argc, argv);
    }
    catch (std::runtime_error &ex)
    {
        std::cout << ex.what() << std::endl;
        std::exit(-1);
    }
    catch (std::logic_error &ex)
    {
        std::cout << ex.what() << std::endl;
        std::exit(-1);
    }
}
