#ifndef _BASH_COLOR_HPP
#define _BASH_COLOR_HPP

 #include <string.h>
 #include <stdio.h>

// shell color constants
const char* FMT_RESET             = "\033[0m";
const char* FMT_RESET_BOLD        = "\033[21m";
const char* FMT_RESET_DIM         = "\033[22m";
const char* FMT_RESET_ITALIC      = "\033[23m";
const char* FMT_RESET_UNDERLINE   = "\033[24m";
const char* FMT_RESET_BLINK       = "\033[25m";
const char* FMT_RESET_REVERSE     = "\033[27m";
const char* FMT_RESET_HIDDEN      = "\033[28m";
const char* FMT_BOLD              = "\033[1m";
const char* FMT_ITALIC            = "\033[3m";
const char* FMT_DIM               = "\033[2m";
const char* FMT_UNDERLINE         = "\033[4m";
const char* FMT_BLINK             = "\033[5m";
const char* FMT_REVERSE           = "\033[7m";
const char* FMT_HIDDEN            = "\033[8m";
const char* FMT_FG_DEFUALT        = "\033[39m";
const char* FMT_FG_RED            = "\033[31m";
const char* FMT_FG_GREEN          = "\033[32m";
const char* FMT_FG_YELLOW         = "\033[33m";
const char* FMT_FG_BLUE           = "\033[34m";
const char* FMT_FG_MAGENTA        = "\033[35m";
const char* FMT_FG_CYAN           = "\033[36m";
const char* FMT_FG_LIGHT_GREY     = "\033[37m";
const char* FMT_FG_DARK_GREY      = "\033[90m";
const char* FMT_FG_LIGHT_RED      = "\033[91m";
const char* FMT_FG_LIGHT_GREEN    = "\033[92m";
const char* FMT_FG_LIGHT_YELLOW   = "\033[93m";
const char* FMT_FG_LIGHT_BLUE     = "\033[94m";
const char* FMT_FG_LIGHT_MAGENTA  = "\033[95m";
const char* FMT_FG_LIGHT_CYAN     = "\033[96m";
const char* FMT_FG_WHITE          = "\033[97m";
const char* FMT_BG_DEFUALT        = "\033[49m";
const char* FMT_BG_BLACK          = "\033[40m";
const char* FMT_BG_RED            = "\033[41m";
const char* FMT_BG_GREEN          = "\033[42m";
const char* FMT_BG_YELLOW         = "\033[43m";
const char* FMT_BG_BLUE           = "\033[44m";
const char* FMT_BG_MAGENTA        = "\033[45m";
const char* FMT_BG_CYAN           = "\033[46m";
const char* FMT_BG_DARK_GREY      = "\033[100m";
const char* FMT_BG_LIGHT_RED      = "\033[101m";
const char* FMT_BG_LIGHT_GREEN    = "\033[102m";
const char* FMT_BG_LIGHT_YELLOW   = "\033[103m";
const char* FMT_BG_LIGHT_BLUE     = "\033[104m";
const char* FMT_BG_LIGHT_MAGENTA  = "\033[105m";
const char* FMT_BG_LIGHT_CYAN     = "\033[106m";
const char* FMT_BG_WHITE          = "\033[107m";

void sprintfmt( char* s, const char * FMT, ... )
{
    int len = (strlen(FMT) + strlen(s) + strlen(FMT_RESET)) + 1;
    char* nstr = (char*)malloc(len);
    nstr[0] = '\0';
    strcat( strcat( strcat(nstr, FMT), s), FMT_RESET);
    //s = &nstr;
    printf(nstr);
}

#define RESET_UNDELINE(s) sprintfmt(s, FMT_RESET_UNDELINE)
#define RESET_ITALIC(s) sprintfmt(s, FMT_RESET_ITALIC)
#define RESET_REVERSE(s) sprintfmt(s, FMT_RESET_REVERSE)
#define RESET_BOLD(s) sprintfmt(s, FMT_RESET_BOLD)
#define RESET_DIM(s) sprintfmt(s, FMT_RESET_DIM)
#define RESET(s) sprintfmt(s, FMT_RESET)
#define DEFAULT(s) sprintfmt(s, FMT_FG_DEFUALT)
#define DIM(s) sprintfmt(s, FMT_DIM)
#define BOLD(s) sprintfmt(s, FMT_BOLD)
#define UNDELINE(s) sprintfmt(s, FMT_UNDELINE)
#define REVERSE(s) sprintfmt(s, FMT_REVERSE)
#define ITALIC(s) sprintfmt(s, FMT_ITALIC)
#define WHITE(s) sprintfmt(s, FMT_FG_WHITE)
#define GREY(s) sprintfmt(s, FMT_FG_GREY)
#define MAGENTA(s) sprintfmt(s, FMT_FG_MAGENTA)
#define BLUE(s) sprintfmt(s, FMT_FG_BLUE)
#define CYAN(s) sprintfmt(s, FMT_FG_CYAN)
#define YELLOW(s) sprintfmt(s, FMT_FG_YELLOW)
#define RED(s) sprintfmt(s, FMT_FG_RED)
#define GREEN(s) sprintfmt(s, FMT_FG_GREEN)

#endif
