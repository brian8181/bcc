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

%token <str> INT FLOAT CHAR
%token <str> REFERENCE POINTER
%token <str> RETURN
%token <str> IF ELSE FOR DO WHILE CONTINUE BREAK SWITCH CASE GOTO DEFAULT VOID
%token <str> PRIVATE PROTECTED PUBLIC
%token <str> STATIC CONST UNSIGNED VOLATILE MUTABLE REGISTER
%token <str> SCOPE_RESOLUTION SHIFT_LEFT SHIFT_RIGHT MODULUS
%token <str> BIT_AND BIT_OR BIT_XOR BIT_NOT
%token <str> ESCAPE
%token <str> NUMBER
%token <str> ID
%token <str> ARG
%token <str> COLON
%token <str> SPACE
%type <str> program
%type <str> files
%type <str> file
%type <str> function
%type <str> scopes
%type <str> scope
%type <str> lines
%type <str> line
%type <str> declaration
%type <str> type
%type <str> expr


%%

program:
    files           { printf("program: files\n"); }
    ;

files:
    file            { printf("files: file\n"); }
    | files file    { printf("files: files file\n"); }
    ;

file:
    scopes          { printf("file: scopes\n"); }
    ;

scopes:
    scope           { printf("scopes: scope\n"); }
    | scopes scope  { printf("scopes: scopes scope\n"); }
    ;

scope:
    lines           { printf("scope: lines\n"); }
    | '{' lines '}'   { printf("scope: '{' lines() '}'\n");  }
    ;

lines:
    line            { printf("lines: line\n"); }
    | lines line    { printf("lines: lines line\n"); }
    ;

line:
    expr ';'        { printf("line: expr\n"); }
    ;

expr:
    declaration                         { printf("expr: declaration=\"%s\"\n", $1); }
    | function                          { printf("expr: function=\"%s\"\n", $1); }
    | ID '=' expr                       { printf("expr: ID '=' expr\n"); }
    | NUMBER                            { printf("expr: NUMBER=\"%s\"\n", $$); }
    | IF '(' expr ')' expr              { printf("expr: IF '(' expr=\"%s\" ')' expr=\"%s\"\n", $3, $5); }
    | IF '(' expr ')' '{' expr ';' '}'  { printf("expr: IF '(' expr=\"%s\" ')' '{' expr=\"%s\" ';' '}'\n", $3, $6); }
    ;

function:
    declaration '(' ')'                 { printf("function: declaration '(' ')'\n"); }
    | declaration '(' params ')'        { printf("function: declaration '(' params ')' )\n"); }
    ;

declaration:
    type ID                             { printf("declaration: type ID\n"); }
    | type_modifier type ID             { printf("declaration: type_modifier type ID\n"); }
    ;


params:
    param                               { printf("params: param \n"); }
    | params ',' param                  { printf("params: params ',' param\n"); }
    ;

param:
    ARG                                 { printf("param: ARG\n"); }
    ;

type_modifier:
    STATIC                        { printf("type_modifier: STATIC\n"); }
    | CONST
    | UNSIGNED
    | VOLATILE
    | MUTABLE
    | REGISTER
    ;

type:
    INT               { printf("type: INT\n"); }
    | FLOAT           { printf("type: FLOAT\n"); }
    | CHAR            { printf("type: CHAR\n"); }
    | type REFERENCE  { printf("type: type REFERENCE\n"); }
    | type POINTER    { printf("type: type POINTER\n"); }
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
