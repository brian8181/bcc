// File Name:  ./lexer_tester.cpp
// File Name:  ./lexer_tester.cpp
// Build Date: Fri Dec 29 03:20:34 AM CST 2023
// Version:    0.1.0

#include <iostream>
#include <cstring>
#include <unistd.h>         /* for STDIN_FILENO */
#include <sys/select.h>     /* for pselect   */
#include <string>
#include <getopt.h>
#include <filesystem>
#include "bash_color.hpp"
#include "utility.hpp"
#include "streamy.hpp"

using namespace std;

int parse_options(int argc, char* argv[])
{
	// test match_single

	string exp = "abc";
	string text = "abc";
	bool match = match_single(exp, text);
	cout << "exp: " << "\"" << exp << "\"" << " matching " << "\"" << text << "\"" " : matched=" << (match ? "true":"false") << endl;

	exp = "abc";
	text = "abcabc";
	match = match_single(exp, text);
	cout << "exp: " << "\"" << exp << "\"" << " matching " << "\"" << text << "\"" " : matched=" << (match ? "true":"false") << endl;

    // array of values ...
    vector<string> citys = { "Mesquite",  "Dallas", "Addison", "New York",     "London",
                             "Barcelona", "Madrid", "Paris",   "Las Angelels", "Las Vegas",
                             "Garland",   "Richardson", "Plano"};

    // initial configuration ...
    const string project_folder = "/home/brian/src/streamy-cpp";
    const string config_path = "/home/brian/src/streamy-cpp/test/config/lexer_tester.conf";

    streamy sm(project_folder + "/test/templates", project_folder + "/test/compile", project_folder + "/test/config", project_folder + "/test/cache");
    sm.load_config(config_path);
	sm.get_map_config()["test"] = "Config Var ...TESTING";
    sm.assign("citys", citys);
    sm.assign("headers", "HEADERS");
    sm.assign("page_title", "*PAGE_TITLE*");
    sm.assign("body", "**THE BODY**");
    sm.assign("admin_email", "admin@something.com");
    sm.assign("version", "0.1");
    sm.assign("version_date", "Feb, 14 2022");

	map<string, map<string, string>> config = sm.get_map_config_sections();
	map<string, map<string, string>>::iterator end = config.end();
	for(map<string, map<string, string>>::iterator iter = config.begin(); iter != end; ++iter)
	{
		string section_name = iter->first;
		cout << "[" + section_name + "]" << endl;
		map<string, string> cfg_section = iter->second;
		map<string, string>::iterator end = cfg_section.end();
		for(map<string, string>::iterator section_iter = cfg_section.begin(); section_iter != end; ++section_iter)
		{
			cout << "key = " << section_iter->first << " : value = " << section_iter->second << endl;
		}
	}

	if(argc < 2)
    {
        cout << "No file parameter." << endl;
        cout << "usage: "  << "lex_tester.cgi " << "[path to template file]" << endl;
        return -1;
    }

	string file_path = project_folder + "/test/templates/" + argv[1];
    filesystem::path file = file_path;
	if(!file_exist(file.string()))
	{
		cout << file.filename() << " : file not found ..." << endl;
        cout << "usage: "  << "lex_tester.cgi " << "[path to template file]" << endl;
		return -1;
	}

	cout << endl << FMT_FG_RED << "{ Begin streamy standard out --> ...}" << FMT_RESET << endl;
    string tmpl(file.filename());
    sm.display(tmpl);
	cout << endl << FMT_FG_RED << "{ End streamy standard out --> ...}" << FMT_RESET << endl;

    return 0;
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
