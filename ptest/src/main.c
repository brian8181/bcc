#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "build/parser.tab.h"
#include "build/lexer.yy.h"

int main(int argc, char* argv[])
{
    // #ifdef DEBUG
    // skip exe path ...
   argc--; argv++;
   if (argc > 0)
   {
		FILE *file;
		file = fopen(argv[0], "r");
		if (!file)
        {
			fprintf(stderr,"could not open %s\n", argv[0]);
			exit(1);
		}
		yyin = file;
	}
    else
    {
        fprintf(stderr, "\nMissing filename paramter, help ->\n");
        fprintf(stderr, "lex [OPTION]... [FilE]...\n");
        fprintf(stderr, "Interactive mode...\n\n");
        yyin = stdin;
    }

    yyparse();
    // #endif

    return 0;
}
