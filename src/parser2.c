%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(const char *msg);
%}

%union {
    int num;
    char* str;
}

%token <num> NUMBER
%token <str> ID
%token INT FLOAT RETURN

%type <num> expr

%%

program:
    function
    ;

function:
    INT ID '(' ')' '{' stmt_list '}'
    ;

stmt_list:
    stmt_list stmt
    |
    ;

stmt:
    RETURN expr ';'      { printf("Returning %d\n", $2); }
    ;

expr:
    expr '+' expr        { $$ = $1 + $3; }
    | expr '-' expr      { $$ = $1 - $3; }
    | NUMBER             { $$ = $1; }
    ;

%%

void yyerror(const char *msg) {
    fprintf(stderr, "Parse error: %s\n", msg);
}
