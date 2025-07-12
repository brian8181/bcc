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
