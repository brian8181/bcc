// File:    bash_color.hpp
// Date:    Sun Dec 15 05:46:02 PM CST 2024
// Version: 0.0.1

#ifndef _BASH_COLOR_HPP
#define _BASH_COLOR_HPP

#include <stdio.h>

// shell color constants
char* FMT_RESET             = "\033[0m";
char* FMT_RESET_BOLD        = "\033[21m";
char* FMT_RESET_DIM         = "\033[22m";
char* FMT_RESET_UNDERLINE   = "\033[24m";
char* FMT_RESET_BLINK       = "\033[25m";
char* FMT_RESET_REVERSE     = "\033[27m";
char* FMT_RESET_HIDDEN      = "\033[28m";
char* FMT_BOLD              = "\033[1m";
char* FMT_DIM               = "\033[2m";
char* FMT_UNDERLINE         = "\033[4m";
char* FMT_BLINK             = "\033[5m";
char* FMT_REVERSE           = "\033[7m";
char* FMT_HIDDEN            = "\033[8m";
char* FMT_FG_DEFUALT        = "\033[39m";
char* FMT_FG_RED            = "\033[31m";
char* FMT_FG_GREEN          = "\033[32m";
char* FMT_FG_YELLOW         = "\033[33m";
char* FMT_FG_BLUE           = "\033[34m";
char* FMT_FG_MAGENTA        = "\033[35m";
char* FMT_FG_CYAN           = "\033[36m";
char* FMT_FG_LIGHT_GREY     = "\033[37m";
char* FMT_FG_DARK_GREY      = "\033[90m";
char* FMT_FG_LIGHT_RED      = "\033[91m";
char* FMT_FG_LIGHT_GREEN    = "\033[92m";
char* FMT_FG_LIGHT_YELLOW   = "\033[93m";
char* FMT_FG_LIGHT_BLUE     = "\033[94m";
char* FMT_FG_LIGHT_MAGENTA  = "\033[95m";
char* FMT_FG_LIGHT_CYAN     = "\033[96m";
char* FMT_FG_WHITE          = "\033[97m";
char* FMT_BG_DEFUALT        = "\033[49m";
char* FMT_BG_BLACK          = "\033[40m";
char* FMT_BG_RED            = "\033[41m";
char* FMT_BG_GREEN          = "\033[42m";
char* FMT_BG_YELLOW         = "\033[43m";
char* FMT_BG_BLUE           = "\033[44m";
char* FMT_BG_MAGENTA        = "\033[45m";
char* FMT_BG_CYAN           = "\033[46m";
char* FMT_BG_DARK_GREY      = "\033[100m";
char* FMT_BG_LIGHT_RED      = "\033[101m";
char* FMT_BG_LIGHT_GREEN    = "\033[102m";
char* FMT_BG_LIGHT_YELLOW   = "\033[103m";
char* FMT_BG_LIGHT_BLUE     = "\033[104m";
char* FMT_BG_LIGHT_MAGENTA  = "\033[105m";
char* FMT_BG_LIGHT_CYAN     = "\033[106m";
char* FMT_BG_WHITE          = "\033[107m";

void println(char* color, char * str)
{
    printf("%sstr%s\n", color, FMT_RESET );
}

#define PRINT_BLUE(str) println(char* str)


#endif
