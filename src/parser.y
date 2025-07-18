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

%type <num> expr
%token <num> NUMBER
%token <str> IDENTIFIER
%token INT FLOAT RETURN
%token IF ELSE LPAREN RPAREN LBRACE RBRACE
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

program:
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
    ;
    
statement:
    INT IDENTIFIER ';'                    { declare($2); }
    | IDENTIFIER '=' expr ';'             { assign($1, $3); }
    | RETURN expr ';'                     { printf("Returning %d\n", $2); }
    ;

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

int main() 
{
    return yyparse();
}

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
