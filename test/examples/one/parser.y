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

line: 
    expr ';'    { printf("line\n"); $$ = $1; }
    ;

expr:
    NUMBER  { $$ = $1; printf("expr = %i\n", $$); }
    ;

%%

void yyerror(const char *msg) 
{
    fprintf(stderr, "Parse error: %s\n", msg);
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

