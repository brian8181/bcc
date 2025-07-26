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

%token <str> INT FLOAT RETURN
%token <str> IF ELSE FOR DO WHILE CONTINUE BREAK SWITCH CASE GOTO DEFAULT VOID
%token <str> PRIVATE PROTECTED PUBLIC
%token <str> STATIC CONST UNSIGNED VOLATILE MUTABLE REGISTER
%token <str> SCOPE_RESOLUTION SHIFT_LEFT SHIFT_RIGHT MODULUS
%token <str> BIT_AND BIT_OR BIT_XOR BIT_NOT
%token <str> ESCAPE
%token <str> NUMBER
%token <str> ID
%type <str> line
%type <str> terminal
%type <str> expr

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
    IF { $$ = "if";  printf("token: %s", $$); }
    |
    INT ID { printf("expr INT ID \"%s\"\n", $2); }
    | ID '=' expr           { $$ = $3; printf("expr ID = expr\n"); }
    | RETURN expr                    { printf("Returning %d\n", $2); }
    | NUMBER  { $$ = $1; printf("expr NUMBER = %s\n", $$); }
    | IF '(' expr ')' line { printf("%s(%s)\n\t%s", $1, $3, $5); }
    | IF '(' expr ')' '{' expr ';' '}' { printf("%s(%s)\n\t{ %s; }", $1, $3, $6); }
    ;

/* terminal:
    IF { printf("token: %s", $1); }
    |   ELSE { printf("token: %s", $1); }
    |   DO { printf("token: %s", $1); }
    |   WHILE { printf("token: %s", $1); }
    |   FOR { printf("token: %s", $1); }
    |   BREAK { printf("token: %s", $1); }
    |   CONTINUE { printf("token: %s", $1); }
    ; */

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
