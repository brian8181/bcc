// File Name:  ./index.cpp
// Build Date: Thu Dec 21 09:06:55 AM CST 2023
// Version:    0.0.2

#include <iostream>
#include <cstring>
#include <unistd.h>         /* for STDIN_FILENO */
#include <sys/select.h>     /* for pselect   */
#include <string>
#include <getopt.h>
#include "streamy.hpp"

using namespace std;

int parse_options(int argc, char* argv[])
{
    // testing values ...
    vector<string> citys = { "Mesquite",  "Dallas", "Addison", "New York",     "London",
                             "Barcelona", "Madrid", "Paris",   "Las Angelels", "Las Vegas",
                             "Garland",   "Richardson", "Plano"};

    // initial configuration ...
    const string project_folder = "/home/brian/src/streamy-cpp";
    const string config_path = "./test/conf";

    // out variables : so the function may return by reference not value
    std::map<string, string> config;
    std::map<string, string> vars;
    string s_out;

    // steamy-cpp ...
	streamy sm(project_folder + "/test/templates", project_folder + "/test/compile", project_folder + "/test/config", project_folder + "/test/cache");
    sm.load_config(config_path);
    sm.assign("citys", citys);
    sm.get_map_config().insert(pair<string, string>("version", "2000"));
    sm.get_map_config().insert(pair<string, string>("mail_message", "No Mail!"));
    sm.get_map_config().insert(pair<string, string>("admin_email", "webmaster@streamy-cpp.com"));
    sm.get_map_vars().insert(pair<string, string>("version", "2000"));
    sm.get_map_vars().insert(pair<string, string>("mail_message", "No Mail!"));
    sm.get_map_vars().insert(pair<string, string>("admin_email", "webmaster@streamy-cpp.com"));
    sm.assign("headers", "HEADERS");

    sm.assign("page_title", "*PAGE_TITLE*");
    sm.assign("body", "**THE BODY**");
    sm.assign("admin_email", "admin@something.com");
    sm.assign("version", "0.1");
    sm.assign("version_date", "Feb, 14 2022");
    sm.display("test_vars.tpl");

    // read / display ...
    map<string, string>::iterator end = sm.get_map_config().end();
    for (map<string, string>::iterator iter = sm.get_map_config().begin(); iter != end; ++iter)
    {
        cout << "key: " << iter->first << " , value: " << iter->second << endl;
    }
    return 0;
}

int stdin_ready (int filedes)
{
	fd_set set;
	// declare/initialize zero timeout ...
	struct timespec timeout = { .tv_sec = 0 };
	// initialize the file descriptor set ...
	FD_ZERO(&set);
	FD_SET(filedes, &set);
	// check stdin_ready is ready on filedes ...
	return pselect(filedes + 1, &set, NULL, NULL, &timeout, NULL);
}

int main(int argc, char* argv[])
{
	try
	{
		if(stdin_ready(STDIN_FILENO))
		{
			std::string buffer;
			std::cin >> buffer;
			// add piped buffer to end of argv ...
			char* argvtmp[sizeof(char*) * argc+1];
			memcpy(argvtmp, argv, sizeof(char*) * argc);
			argvtmp[argc] = &buffer[0];
			argv = argvtmp;
			++argc;
		}
		return parse_options(argc, argv);
	}
	catch(std::logic_error& ex)
	{
	 	std::cout << ex.what() << std::endl;

        int* arr[10];

        // int** pp; &
        // int* pa = &arr[0];
        // int* pb+=(&pa-&pb)

	}
}
