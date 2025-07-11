%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex();
%}

%union {
    int num;
    char* str;
}

%type <num> expr
%token <num> NUMBER
%token <str> IDENTIFIER
%token INT FLOAT RETURN
%token IF ELSE LPAREN RPAREN LBRACE RBRACE EQ

%%

program:
    function { printf("program\n"); }
    | statements { printf("wooohooo!\n"); }
    ;

function:
    INT IDENTIFIER '(' ')' '{' statements '}'
    ;

statements:
    statements statement
    | statement
    ;

statement:
    if_statement
    | expr ';'
    ;

if_statement:
    IF LPAREN expr RPAREN LBRACE statement RBRACE 
        { 
            char* p = "0";
            int r = atoi(p);
            printf("result=%i\n", r);
            if(r) { printf("IF_TRUE\n"); } else { printf("IF_FALSE\n"); } 
        }
    | IF LPAREN expr RPAREN LBRACE statement RBRACE ELSE LBRACE statement RBRACE 
        { 
            printf("IF_ELSE\n"); 
        }
    ;

expr:
      expr '+' expr               { $$ = $1 + $3; }
    | expr '-' expr               { $$ = $1 - $3; }
    | expr '<' expr               { $$ = $1 < $3; }
    | expr '>' expr               { $$ = $1 > $3; }
    | expr EQ expr                { $$ = $1 == $3; }
    | NUMBER                      { $$ = $1; }
    | IDENTIFIER                  { /* $$ = $1; */ }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Parse error: %s\n", s);
}

int main() {
    return yyparse();
}
