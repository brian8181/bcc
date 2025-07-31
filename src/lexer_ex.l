%option c++ noyywrap
%option lexer=ExampleLexer

%{
#include <iostream>
#include <stdlib.h>
#include "parser.tab.h"
%}

%%

"return"    { return RETURN; std::cout << "OP:" << yytext  << "\n"; }
"if"        { return IF; std::cout << "OP:" << yytext  << "\n"; }
"else"      { return ELSE; std::cout << "OP:" << yytext  << "\n"; }
"do"        { return DO; std::cout << "OP:" << yytext  << "\n"; }
"while"     { return WHILE; std::cout << "OP:" << yytext  << "\n"; }
"for"       { return FOR; std::cout << "OP:" << yytext  << "\n"; }
"continue"  { return CONTINUE; std::cout << "OP:" << yytext  << "\n"; }
"switch"    { return SWITCH; std::cout << "OP:" << yytext  << "\n"; }
"case"      { return CASE; std::cout << "OP:" << yytext  << "\n"; }
"break"     { return BREAK; std::cout << "OP:" << yytext  << "\n"; }
"goto"      { return GOTO; std::cout << "OP:" << yytext  << "\n"; }
"default"   { return DEFAULT; std::cout << "OP:" << yytext  << "\n"; }
"void"      { return VOID; std::cout << "OP:" << yytext  << "\n"; }

"="         { return '='; std::cout << "OP:" << yytext  << "\n"; }
";"         { return ';'; std::cout << "OP:" << yytext  << "\n"; }
"+"         { return '+'; std::cout << "OP:" << yytext  << "\n"; }
"-"         { return '-'; std::cout << "OP:" << yytext  << "\n"; }
","         { return ','; std::cout << "OP:" << yytext  << "\n"; }
"("         { return '('; std::cout << "OP:" << yytext  << "\n"; }
")"         { return ')'; std::cout << "OP:" << yytext  << "\n"; }
"{"         { return '{'; std::cout << "OP:" << yytext  << "\n"; }
"}"         { return '}'; std::cout << "OP:" << yytext  << "\n"; }
"["         { return '['; std::cout << "OP:" << yytext  << "\n"; }
"]"         { return ']'; std::cout << "OP:" << yytext  << "\n"; }
"<"         { return '<'; std::cout << "OP:" << yytext  << "\n"; }
">"         { return '>'; std::cout << "OP:" << yytext  << "\n"; }
"#"         { return '#'; std::cout << "OP:" << yytext  << "\n"; }
"$"         { return '$'; std::cout << "OP:" << yytext  << "\n"; }
"%"         { return '%'; std::cout << "OP:" << yytext  << "\n"; }
"^"         { return '^'; std::cout << "OP:" << yytext  << "\n"; }
"\""        { return '"'; std::cout << "OP:" << yytext  << "\n"; }
"'"         { return '\''; std::cout << "OP:" << yytext  << "\n"; }
"/"         { return '/'; std::cout << "OP:" << yytext  << "\n"; }
"~"         { return '~'; std::cout << "OP:" << yytext  << "\n"; }
":"         { return ':'; std::cout << "OP:" << yytext  << "\n"; }
[ \t\r\n]+             { /* skip whitespace */ }
.                      { std::cout << "UNKNOWN: " << yytext << "\n"; }

%%
