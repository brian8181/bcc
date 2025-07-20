%{
#include "parser.tab.h"
#include <string.h>
#include "bash_color.h"

// # define  YYEOF 0                    /* "end of file"  */
// # define YYerror 256                /* error  */
// # define YYUNDEF 257                 /* "invalid token"  */
// # define INT 258                     /* INT  */
// # define FLOAT 259                   /* FLOAT  */
// # define RETURN 260                  /* RETURN  */
// # define NUMBER 261                  /* NUMBER  */
// # define ID 62                       /* ID  */
// # define WHILE 0x10
// # define FOR 0x20  
// # define DO 0x40
// # define BREAK 0x80
// # define CONTINUE 0x100

%}
%%
"int"                  { printf("%sint%s\n",FMT_FG_BLUE, FMT_RESET ); }
"float"                { printf("%sfloat%s\n",FMT_FG_BLUE, FMT_RESET ); }
"idx"                  { printf("X"); }
[a-zA-Z_][a-zA-Z0-9_]* { printf("TEST"); printf("%s%s%s\n",FMT_FG_GREEN, FMT_RESET, yytext ); }
";"                    { return ';'; }
[ \t\n]+    ; // Skip whitespace
.                      { printf("Unexpected character: %s\n", yytext); }

%%

int yywrap(void) { return 1; }

int main(int argc, char** argv)
{
    if(argc > 1) 
    {
        if(!(yyin = fopen(argv[1], "r")))
        {
            perror(argv[1]);
            return (1);
        }
    }
    yylex();
    return 0;
}
