%option c++ noyywrap
%option lexer=ExampleLexer

%{
#include <iostream>
%}

%%

[0-9]+              { std::cout << "NUMBER: " << yytext << "\n"; }
[a-zA-Z_][a-zA-Z0-9_]* { std::cout << "IDENTIFIER: " << yytext << "\n"; }
[+*/=-]              { std::cout << "OPERATOR: " << yytext << "\n"; }
[ \t\r\n]+           { /* skip whitespace */ }
.                    { std::cout << "UNKNOWN: " << yytext << "\n"; }

%%
