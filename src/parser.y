%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void debug(char* msg);
void yyerror(const char *s);
int yylex();

// Symbol table
#define MAX_SYMBOLS 100

typedef struct {
    char *name;
    int value;
    int is_initialized;
} Symbol;

Symbol symbols[MAX_SYMBOLS];
int symbol_count = 0;

int lookup(char* name) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbols[i].name, name) == 0) return i;
    }
    return -1;
}

void declare(char* name) {
    if (lookup(name) != -1) {
        fprintf(stderr, "Error: Variable '%s' already declared.\n", name);
        exit(1);
    }
    symbols[symbol_count].name = strdup(name);
    symbols[symbol_count].is_initialized = 0;
    symbols[symbol_count].value = 0;
    symbol_count++;
}

void assign(char* name, int value) {
    int idx = lookup(name);
    if (idx == -1) {
        fprintf(stderr, "Error: Variable '%s' not declared.\n", name);
        exit(1);
    }
    symbols[idx].value = value;
    symbols[idx].is_initialized = 1;
}

int get_value(char* name) {
    int idx = lookup(name);
    if (idx == -1 || symbols[idx].is_initialized == 0) {
        fprintf(stderr, "Error: Variable '%s' not initialized.\n", name);
        exit(1);
    }
    return symbols[idx].value;
}

%}

%union {
    int num;
    char* str;
}

%token <str> INT FLOAT CHAR VOID
%token <str> REFERENCE POINTER
%token <str> ASSIGNMENT
%token <str> ARG
%token <str> SPACE TAB NEWLINE END_OF_FILE
%token <str> LBRACE RBRACE LCURLY RCURLY LPAREN RPAREN
%token <str> STATIC CONST UNSIGNED VOLATILE MUTABLE REGISTER RESTRICT INLINE
%token <str> SHIFT_LEFT SHIFT_RIGHT MODULUS
%token <str> EQUALS LOGICAL_NOT LOGICAL_AND LOGICAL_OR BIT_AND BIT_OR BIT_XOR BIT_NOT
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
//%type <str> expr
%type <str> statement
%start program


%type <num> expr
%token <num> NUMBER
%token <str> ID
%left '<' '>' EQ
%left "+" "-";
%left "*" "/";
%token END_OF_FILE
/* %start <str> program */

%%

/*program:
    END_OF_FILE { printf("program:EOF\n"); }
    | function { printf("program:fucntion\n"); }
    | statements END_OF_FILE { printf("program:statements\n"); }
    ;
*/

/* program:
    statements
    ;

function:
    INT IDENTIFIER LPAREN RPAREN LBRACE statements RBRACE { printf("function\n"); }
    ;

statements:
    statement
    | if_statement
    | statements statement
    | statements if_statement
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
            char* p = "0";
            int r = atoi(p);
            printf("result=%i\n", r);
             if(r) { printf("IF_ELSE_TRUE\n"); } else { printf("IF_ELSE_FALSE\n"); }
        }
    /* ;

statement:
    INT IDENTIFIER ';'                    { declare($2); }
    | IDENTIFIER '=' expr ';'             { assign($1, $3); }
    | RETURN expr ';'                     { printf("Returning %d\n", $2); }
    ;
/*
expr:
    INT IDENTIFIER ';'           { printf("expr:INT_IDENTIFIER\n"); }
    | expr '+' expr                { $$ = $1 + $3; }
    | expr '-' expr               { $$ = $1 - $3; }
    | expr '<' expr               { $$ = $1 < $3; }
    | expr '>' expr               { $$ = $1 > $3; }
    | expr EQ expr                { $$ = $1 == $3; }
    | INT                         { printf("expr:INT\n"); }
    | NUMBER                      { $$ = $1; }
    | IDENTIFIER                  { $$ = get_value($1); printf("expr:IDENTIFIER\n"); }
    ; */

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

void debug(char* msg)
{
#ifdef DEBUG
    /* COLOR_RED(msg); */
    printf(msg);
#endif
}

void yyerror(const char *s)
{
    fprintf(stderr, "Parse error: %s\n", s);
}

/* int main()
{
    return yyparse();
} */

/*
int main(int argc, char* argv[])
{
   if (argc > 1)
   {
		FILE *file;
		file = fopen(argv[1], "r");
		if (!file)
        {
			fprintf(stderr,"could not open %s\n",argv[1]);
			exit(1);
		}
		yyin = file;
	}
    else
    {
        fprintf(stderr, "Missing filename paramter, help ->\n");
        fprintf(stderr, "lex [OPTION]... [FilE]...\n");
        fprintf(stderr, "Interactive mode...\n");
        yyin = stdin;
    }

    yyparse();
    return 0;
}
*/
