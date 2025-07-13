%{
#include "parser.tab.h"
#include <string.h>
%}

digit   [0-9]
id      [a-zA-Z_][a-zA-Z0-9_]*

%%

"int"       { return INT; }
"float"     { return FLOAT; }
"return"    { return RETURN; }

{id}        { yylval.str = strdup(yytext); return ID; }
{digit}+    { yylval.num = atoi(yytext); return NUMBER; }

"="         { return '='; }
";"         { return ';'; }
"("         { return '('; }
")"         { return ')'; }
"{"         { return '{'; }
"}"         { return '}'; }
"+"         { return '+'; }
"-"         { return '-'; }
[ \t\n]+    ; // Skip whitespace
.           { printf("Unexpected character: %s\n", yytext); }

%%

int yywrap(void) { return 1; }

/*
int main()
{
    while (yylex() != 0) ;
    return 0;
}
*/

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
    printf("%8d%8d%8d\n", lines, words, chars);
    return 0;
}
