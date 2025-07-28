%{
#include "ptest1.tab.h"
#include <string.h>
%}

digit   [0-9]
id      [a-zA-Z_][a-zA-Z0-9_]*
type    int|float|char
ref     '&'
point   '*'

%%

"int"       { return INT; }
"float"     { return FLOAT; }
"char"      { return CHAR; }
"return"    { return RETURN; }
"if"        { return IF; }
"else"      { return ELSE; }
"do"        { return DO; }
"while"     { return WHILE; }
"for"       { return FOR; }
"continue"  { return CONTINUE; }
"switch"    { return SWITCH; }
"case"      { return CASE; }
"break"     { return BREAK; }
"goto"      { return GOTO; }
"default"   { return DEFAULT; }
"void"      { return VOID; }
"private"   { return PRIVATE; }
"static"    { return STATIC; }
"const"     { return CONST; }
"UNSIGNED"  { return UNSIGNED; }
"volatile"  { return VOLATILE; }
"register"  { return REGISTER; }
"="         { return '='; }
";"         { return ';'; }
"("         { return '('; }
")"         { return ')'; }
"{"         { return '{'; }
"}"         { return '}'; }
"+"         { return '+'; }
"-"         { return '-'; }
","         { return ','; }
"["         { return '['; }
"]"         { return ']'; }
"::"        { return SCOPE_RESOLUTION; }
":"         { return ':'; }
"&"         { return REFERENCE; }
"*"         { return POINTER; }
{id}        { yylval.str = strdup(yytext); return ID; }
{digit}+    { yylval.str = strdup(yytext); return NUMBER; }
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
*/

int main(int argc, char* argv[])
{
    // #ifdef DEBUG
    // skip exe path ...
   argc--; argv++;
   if (argc > 0)
   {
		FILE *file;
		file = fopen(argv[0], "r");
		if (!file)
        {
			fprintf(stderr,"could not open %s\n", argv[0]);
			exit(1);
		}
		yyin = file;
	}
    else
    {
        fprintf(stderr, "\nMissing filename paramter, help ->\n");
        fprintf(stderr, "lex [OPTION]... [FilE]...\n");
        fprintf(stderr, "Interactive mode...\n\n");
        yyin = stdin;
    }

    yyparse();
    // #endif

    return 0;
}
