%{
#include "parser.tab.h"
#include <string.h>

/*
int yyerror(char *s);
char *yytext;
int yylex();
int fileno(FILE *);
*/

%}

digit   [0-9]
id      [a-zA-Z_][a-zA-Z0-9_]*

%x streaming
%x escape
%x comment

%%

"int"       { return INT; }
"float"     { return FLOAT; }
"return"    { return RETURN; }
"if"        { return IF; }
"else"      { return ELSE; }
"("         { return LPAREN; }
")"         { return RPAREN; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
"="         { return '='; }
";"         { return ';'; }
"+"         { return '+'; }
"-"         { return '-'; }
"*"         { return '*'; }
"/"         { return '/'; }
"=="        { return EQ; }
"<"         { return '<'; }
">"         { return '>'; }
{id}        { yylval.str = strdup(yytext); return IDENTIFIER; }
{digit}+    { yylval.num = atoi(yytext); return NUMBER; }
[ \t\n]+    { /* skip whitespace */ }
<<EOF>>     { return END_OF_FILE; }
.           { printf("Unexpected character: %s\n", yytext); }

%%

int yywrap() {
    return 1;
}

