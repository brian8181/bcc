/**
 * @file    cmm.hpp
 * @version version 0.0.1
 * @date    Sun, 07 Jun 2026 03:21:16 +0000
 */
#include <stdio.h>
#include <unistd.h>         /* for STDIN_FILENO */
#include <sys/select.h>     /* for pselect   */
#include <getopt.h>
#include <string.h>
#include "cmm.h"


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
	char* argv_cpy[sizeof(char*) * (argc+1)];
	if(stdin_ready(STDIN_FILENO))
	{
		char* buffer;
		//std::cin >> buffer;
		memcpy(argv_cpy, argv, sizeof(char*) * argc);
		argv_cpy[argc] = &buffer[0];
		++argc;
		return parse_options(argc, argv_cpy);
	}
	return parse_options(argc, argv);
}
