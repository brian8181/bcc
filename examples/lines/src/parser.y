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

%token INT FLOAT RETURN
%token <num> NUMBER
%token <str> ID
%type <num> expr
%type <num> line

%%

program:
    lines   { printf("program\n"); }
    ;

lines:
    line
    | lines line
    ;

line:
    expr ';'    { printf("line: expr ;\n"); $$ = $1; }
    ;

expr:
    INT ID { printf("expr INT ID \"%s\"\n", $2); }
    | ID '=' expr           { $$ = $3; printf("expr ID = expr\n"); }
    | RETURN expr                    { printf("Returning %d\n", $2); }
    | NUMBER  { $$ = $1; printf("expr NUMBER = %i\n", $$); }
    ;

%%

void yyerror(const char *msg)
{
    fprintf(stderr, "Parse error: %s\n", msg);
}
/*
int main()
{
    return yyparse();
} */
