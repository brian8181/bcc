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
%token <str> NUMBER
%token <str> ID
%token <str> ARG
%token <str> SPACE TAB NEWLINE END_OF_FILE
%token <str> LEFT_BRACE RIGHT_BRACE LEFT_CURLY RIGHT_CURLY LEFT_PAREN RIGHT_PAREN
%token <str> STATIC CONST UNSIGNED VOLATILE MUTABLE REGISTER RESTRICT INLINE
%token <str> SHIFT_LEFT SHIFT_RIGHT MODULUS
%token <str> BIT_AND BIT_OR BIT_XOR BIT_NOT LOGICAL_NOT LOGICAL_AND LOGICAL_OR
%token <str> ADDITION SUBTRACTION MUTIPLICATION DIVISION
%token <str> LESS_THAN GREATER_THAN
%token <str> COMMA SEMICOLON COLON DOUBLE_QUOTE SINGLE_QUOTE QUESTION_MARK DOT AT_SYMBOL
%token <str> PRIVATE PROTECTED PUBLIC
%token <str> ADDRESS_OF SCOPE_RESOLUTION
%token <str> DIRECT_TO_POINTER INDIRECT_TO_POINTER
%token <str> DIRECT_MEMBER_SELECT INDIRECT_MEMBER_SELECT
%token <str> IF ELSE FOR DO WHILE CONTINUE BREAK SWITCH CASE GOTO DEFAULT RETURN
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
%type <str> pointer_to_member
%type <str> member_select
%type <str> access_specifier
%type <str> numeric_expr
%type <str> expr
%type <str> statement
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
    statement ';'                       { printf("line: statement=\"%s\"\n", $1); }
    ;
statement:
    expr                                { printf("statement: expr=\"%s\"\n", $1); }
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
    ;
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
access_specifier:
        PUBLIC
        | PROTECTED
        | PRIVATE
        ;
type_modifier:
    STATIC                              { printf("type_modifier: STATIC\n"); }
    | CONST                             { printf("type_modifier: CONST\n"); }
    | UNSIGNED                          { printf("type_modifier: VOID\n"); }
    | VOLATILE                          { printf("type_modifier: VOLATILE\n"); }
    | MUTABLE                           { printf("type_modifier: MUTABLE\n"); }
    | REGISTER                          { printf("type_modifier: REGISTER\n"); }
    | RESTRICT                          { printf("type_modifier: RESTRICT\n"); }
    | INLINE
    ;
type:
    INT                                 { printf("type: INT\n"); }
    | FLOAT                             { printf("type: FLOAT\n"); }
    | CHAR                              { printf("type: CHAR\n"); }
    | VOID                              { printf("type: VOID\n"); }
    | type REFERENCE                    { printf("type: type REFERENCE\n"); }
    | type POINTER                      { printf("type: type POINTER\n"); }
    ;
flow_control:
    FOR
    | WHILE
    | DO
    | BREAK
    | CONTINUE
    | IF
    | ELSE
    | SWITCH
    | CASE
    | GOTO
    | DEFAULT
    | RETURN
    ;
space:
    SPACE
    | TAB
    | NEWLINE
    | END_OF_FILE
    ;
operator:
    ADDITION
    | SUBTRACTION
    | MUTIPLICATION
    | DIVISION
    | LESS_THAN
    | GREATER_THAN
    | BIT_AND
    | BIT_OR
    | BIT_XOR
    | BIT_NOT
    | LOGICAL_NOT
    | LOGICAL_AND
    | LOGICAL_OR
    | SHIFT_LEFT
    | SHIFT_RIGHT
    | MODULUS
    | LEFT_BRACE
    | LEFT_CURLY
    | LEFT_PAREN
    | RIGHT_BRACE
    | RIGHT_CURLY
    | RIGHT_PAREN
    | COMMA
    | COLON
    | SEMICOLON
    | DOUBLE_QUOTE
    | SINGLE_QUOTE
    | QUESTION_MARK
    | DOT
    | AT_SYMBOL
    | ADDRESS_OF
    | SCOPE_RESOLUTION
    ;
member_select:
    DIRECT_MEMBER_SELECT
    | INDIRECT_MEMBER_SELECT
    ;
pointer_to_member:
    INDIRECT_TO_POINTER
    | DIRECT_TO_POINTER
    ;

%%

void yyerror(const char *msg)
{
    fprintf(stderr, "Parse error: %s\n", msg);
}
