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
%type <str> type
%type <str> type_modifier
%type <str> expr
%start <str> program


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
    | NUMBER                            { printf("expr: NUMBER=\"%s\"\n", $$); }
    | IF '(' expr ')' expr              { printf("expr: IF '(' expr=\"%s\" ')' expr=\"%s\"\n", $3, $5); }
    | IF '(' expr ')' '{' expr ';' '}'  { printf("expr: IF '(' expr=\"%s\" ')' '{' expr=\"%s\" ';' '}'\n", $3, $6); }
    ;

function:
    declaration '(' ')'                 { printf("function: declaration '(' ')'\n"); }
    | declaration '(' params ')'        { printf("function: declaration '(' params ')' )\n"); }
    ;

declaration:
    type ID                             { printf("declaration: type=\"%s\" ID=\"%s\"\n", $1, $2); $$=$1; }
    | type_modifier type ID             { printf("declaration: type_modifier=\"%s\" type=\"%s\" ID=\"%s\"\n", $1, $2, $3); $$=$1; }
    ;


params:
    param                               { printf("params: param \n"); }
    | params ',' param                  { printf("params: params ',' param\n"); }
    ;

param:
    ARG                                 { printf("param: ARG\n"); }
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
