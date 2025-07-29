%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int yylex(void);
void yyerror(const char *msg);
%}

%union {
    int num;
    char* str;
}

%token <str> INT FLOAT CHAR VOID
%token <str> REFERENCE POINTER
%token <str> RETURN
%token <str> IF ELSE FOR DO WHILE CONTINUE BREAK SWITCH CASE GOTO DEFAULT
%token <str> PRIVATE PROTECTED PUBLIC INLINE
%token <str> STATIC CONST UNSIGNED VOLATILE MUTABLE REGISTER RESTRICT
%token <str> SCOPE_RESOLUTION SHIFT_LEFT SHIFT_RIGHT MODULUS
%token <str> BIT_AND BIT_OR BIT_XOR BIT_NOT
%token <str> ESCAPE
%token <str> NUMBER
%token <str> ID
%token <str> ARG
%token <str> COLON
%token <str> SPACE
%type <str> files
%type <str> file
%type <str> function
%type <str> scopes
%type <str> scope
%type <str> lines
%type <str> line
%type <str> declaration
%type <str> params
%type <str> param
%type <str> type
%type <str> type_modifier
%type <str> numeric_expr
%type <str> expr
%start program

%%

program:
    files                               { printf("program: files\n"); }
    ;

files:
    file                                { printf("files: file\n"); }
    | files file                        { printf("files: files file\n"); }
    ;

file:
    scopes                              { printf("file: scopes\n"); }
    ;

scopes:
    scope                               { printf("scopes: scope\n"); }
    | scopes scope                      { printf("scopes: scopes scope\n"); }
    ;

scope:
    lines                               { printf("scope: lines=\"%s\"\n", $1); }
    | '{' lines '}'                     { printf("scope: '{' lines=\"%s\" '}'\n", $2);  }
    ;

lines:
    line                                { printf("lines: line=\"%s\"\n", $1); }
    | lines line                        { printf("lines: lines=\"%s\" line\"%s\"\n", $1, $2); }
    ;

line:
    expr ';'                            { printf("line: expr=\"%s\"\n", $1); }
    ;

expr:
    declaration                         { printf("expr: declaration=\"%s\"\n", $1); }
    | function                          { printf("expr: function=\"%s\"\n", $1); }
    | ID '=' expr                       { printf("expr: ID '=' expr\n"); }
    | numeric_expr                      { printf("expr: numeric_expr=\"%s\"\n", $1); }
    | IF '(' expr ')' expr              { printf("expr: IF '(' expr=\"%s\" ')' expr=\"%s\"\n", $3, $5); }
    | IF '(' expr ')' '{' expr ';' '}'  { printf("expr: IF '(' expr=\"%s\" ')' '{' expr=\"%s\" ';' '}'\n", $3, $6); }
    ;

numeric_expr:
    NUMBER                              { printf("binary_op: NUMBER=\"%s\"\n", $1); }
    | numeric_expr '+' numeric_expr     {
                                            char buffer[64];
                                            sprintf(buffer, "%s + %s", $1, $3);
                                            printf("%s\n", buffer);
                                        }
    | numeric_expr '-' numeric_expr     {
                                            char buffer[64];
                                            sprintf(buffer, "%s - %s", $1, $3);
                                            printf("%s\n", buffer);
                                        }
function:
    declaration '(' ')'                 { printf("function: declaration '(' ')'\n"); }
    | declaration '(' params ')'        { printf("function: declaration '(' params ')' )\n"); }
    ;

declaration:
    type ID                             { printf("declaration: type=\"%s\" ID=\"%s\"\n", $1, $2); }
    | type_modifier type ID             { printf("declaration: type_modifier=\"%s\" type=\"%s\" ID=\"%s\"\n", $1, $2, $3); }
    ;


params:
    param                               { printf("params: param=\"%s\" \n", $1); }
    | params ',' param                  { printf("params: params=\"%s\" , param=\"%s\"\n", $1, $3); }
    ;

param:
    ARG                                 { printf("param: ARG=\"%s\"\n", $1); }
    ;

type_modifier:
    STATIC                              { printf("type_modifier: STATIC\n"); }
    | CONST                             { printf("type_modifier: CONST\n"); }
    | UNSIGNED                          { printf("type_modifier: VOID\n"); }
    | VOLATILE                          { printf("type_modifier: VOLATILE\n"); }
    | MUTABLE                           { printf("type_modifier: MUTABLE\n"); }
    | REGISTER                          { printf("type_modifier: REGISTER\n"); }
    | RESTRICT                          { printf("type_modifier: RESTRICT\n"); }
    ;

type:
    INT                                 { printf("type: INT\n"); }
    | FLOAT                             { printf("type: FLOAT\n"); }
    | CHAR                              { printf("type: CHAR\n"); }
    | VOID                              { printf("type: VOID\n"); }
    | type REFERENCE                    { printf("type: type REFERENCE\n"); }
    | type POINTER                      { printf("type: type POINTER\n"); }
    ;


%%

void yyerror(const char *msg)
{
    fprintf(stderr, "Parse error: %s\n", msg);
}
