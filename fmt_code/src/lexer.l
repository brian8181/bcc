%{

//      The basic source character set consists of 96 characters:
//      the space character, the control characters representing horizontal tab,
//      vertical tab, form feed, and new-line, plus the following 91 graphical characters
//
//      a b c d e f g h i j k l m n o p q r s t u v w x y z
//      A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
//      0 1 2 3 4 5 6 7 8 9
//      _ { } [ ] # ( ) < > % : ; . ? * + - / ˆ & | ˜ ! = , \ " ’

#include "parser.tab.h"
#include <string.h>

%}

digit   [0-9]
id      [a-zA-Z_][a-zA-Z0-9_]*

%%

"int"       { yylval.str = strdup(yytext); return INT; }
"float"     { yylval.str = strdup(yytext); return FLOAT; }
"char"      { yylval.str = strdup(yytext); return CHAR; }
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
"private"   { yylval.str = strdup(yytext); return PRIVATE; }
"protected" { yylval.str = strdup(yytext); return PROTECTED; }
"public"    { yylval.str = strdup(yytext); return PUBLIC; }
"inline"    { yylval.str = strdup(yytext); return INLINE; }
"static"    { yylval.str = strdup(yytext); return STATIC; }
"const"     { yylval.str = strdup(yytext); return CONST; }
"unsigned"  { yylval.str = strdup(yytext); return UNSIGNED; }
"volatile"  { yylval.str = strdup(yytext); return VOLATILE; }
"register"  { yylval.str = strdup(yytext); return REGISTER; }
"restrict"  { yylval.str = strdup(yytext); return RESTRICT; }
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
"."         { yylval.str = strdup(yytext); return DIRECT_MEMBER_SELECT; }
"->"        { yylval.str = strdup(yytext); return INDIRECT_MEMBER_SELECT; }
".*"        { yylval.str = strdup(yytext); return INDIRECT_TO_POINTER; }
"->*"       { yylval.str = strdup(yytext); return DIRECT_TO_POINTER; }
__{id}      { yylval.str = strdup(yytext); return ARG; }
{id}        { yylval.str = strdup(yytext); return ID; }
{digit}+    { yylval.str = strdup(yytext); return NUMBER; }
[ \t\n]+    ; // Skip whitespace
.           { printf("Unexpected character: %s\n", yytext); }

%%

int yywrap(void)
{
    return 1;
}

int main(int argc, char* argv[])
{
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
    return 0;
}
