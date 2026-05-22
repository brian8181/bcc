%require "3.2"
%language "c++"
%define api.value.type variant
%code
{

    #include <iostream>
    #include <string>
    #include <iomanip>
    #include <list>
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "bash_color.h"
    #include "bash_color.h"
    #include "pcxx.hh"
    #include "symtab.h"

    using std::string;
    using std::cout;
    using std::endl;
    using std::pair;

    typedef std::pair< std::string, std::string > attribute;

    // print a list of strings
    auto operator<<(std::ostream& o, const std::vector<std::string>& ss) -> std::ostream&
    {
        o << '{';
        const char *sep = "";
        for(const auto& s: ss)
        {
            o << sep << s;
            sep = ", ";
        }
        return o << '}';
    }
}

%define api.token.constructor
%code
{
    namespace yy
    {
        // return the next token
        auto yylex() -> parser::symbol_type
        {
            static int i = 0;
            static int count = 0;
            switch(int stage = count++)
            {
            case 0:
                return parser::make_NUMBER(666);
            case 1:
                return parser::make_END();
            }
            return 0;
        }
    }
}

%code
{
    int yylex(void);
    int yyerror(char * s);
    char* STRDUP(char* s);
    /* string literal buffer */
    char buf[100];
    char *s;

    typedef struct nvalue
    {
        char* name;
        char* value;
        struct nvalue* next;
    } nvalue;

    static nvalue* pnv_head = 0;
    nvalue* alloc_nvalue(char* name, char* value);
    void free_nvalue(nvalue* nv);
    void free_all_nvalues();
    typedef std::pair< std::string, std::string > attribute;
}

%token END 0 _("end of input")
%type files file block blocks
%type<std::pair< std::string, std::string >*> attrib
%type<std::string> built_in
%type<std::string> attributes
%token<int> NUMBER
%token<std::string> DOLLAR_SIGN DOT INDIRECT_MEMBER COMMA EQUAL
%token<std::string> STRING_LITERAL NUMERIC_LITERAL
%token<std::string> ID CONST_ID
%token<std::string> LBRACE RBRACE LBRACKET RBRACKET LPAREN RPAREN
%token<std::string> CONFIG_LOAD INCLUDE REQUIRE INSERT ASSIGN
%token<std::string> VAR_ATTRIB VALUE_ATTRIB FILE_ATTRIB FILE_NAME
%type<std::string> symbol sub_proc array qualafied_id
%start complier

%%

complier:
    files                                                       {
                                                                    std::cout <<  FMT_FG_GREEN << "PARSER complier: | files" << FMT_RESET << endl;
                                                                    cout << FMT_FG_YELLOW << "*********************** STOPPING **********************" << FMT_REVERSE << FMT_RESET << endl;
                                                                    cout << FMT_FG_YELLOW << "*                     Terminating.                    *" << FMT_REVERSE << FMT_RESET << endl;
                                                                    cout << FMT_FG_YELLOW << "************************* Done ************************" << FMT_REVERSE << FMT_RESET << endl;
                                                                }
    ;

files:
    file                                                        { cout << FMT_FG_YELLOW << "PARSER files: | file" << FMT_RESET << endl; }
    | files file                                                { cout << FMT_FG_YELLOW << "PARSER files: | files file" << FMT_RESET << endl; }
                                                                ;

file:
    blocks END                                                  {
                                                                    cout << FMT_FG_YELLOW << "PARSER file: | blocks END_OF_FILE" << FMT_RESET << endl;
                                                                    cout << FMT_FG_YELLOW << "*******************************************************" << FMT_REVERSE << FMT_RESET << endl;
                                                                    cout << FMT_FG_YELLOW << "*                      End Of File                    *" << FMT_REVERSE << FMT_RESET << endl;
                                                                    cout << FMT_FG_YELLOW << "*******************************************************" << FMT_REVERSE << FMT_RESET << endl;
                                                                }
                                                                ;

blocks:
    block                                                       {
                                                                    cout << FMT_FG_YELLOW << "PARSER blocks: | block" << FMT_RESET << endl;
                                                                }
    | blocks block                                              {
                                                                    cout << FMT_FG_YELLOW << "PARSER blocks: | blocks block" << FMT_RESET << endl;
                                                                }
                                                                ;

block:
    LBRACE sub_proc RBRACE                                      {
                                                                    cout << FMT_FG_YELLOW << "PARSER block: | LBRACE sub_porc RBRACE" << FMT_RESET << endl;
                                                                }
    | LBRACE array RBRACE                                       {
                                                                    cout << FMT_FG_YELLOW << "PARSER block: | LBRACE array RBRACE" << FMT_RESET << endl;
                                                                }
    | LBRACE symbol RBRACE                                      {
                                                                    cout << FMT_FG_YELLOW << "PARSER block: | LBRACE symbol RBRACE" << FMT_RESET << endl;
                                                                }
    | LBRACE qualafied_id RBRACE                                {
                                                                    cout << FMT_FG_YELLOW << "PARSER block: | LBRACE qualafied_id RBRACE" << FMT_RESET << endl;
                                                                }
     | LBRACE built_in RBRACE                                   {
                                                                    cout << FMT_FG_YELLOW << "PARSER block: | LBRACE built_in RBRACE" << FMT_RESET << endl;

                                                                    //free_all_nvalues();
                                                                }
    | NUMBER                                                    {
                                                                    cout << FMT_FG_RED
                                                                            << "block: NUMBER"
                                                                        << FMT_RESET << endl;   }
                                                                ;

qualafied_id:
    symbol DOT ID                                               {
                                                                    cout << FMT_FG_YELLOW
                                                                            << "PARSER qualafied_id: | symbol DOT ID"
                                                                         << FMT_RESET << endl;
                                                                }
    | symbol INDIRECT_MEMBER ID                                 { cout << FMT_FG_YELLOW << "PARSER qualafied_id: | symbol INDIRECT_MEMBER ID" << FMT_RESET << endl; }
    | qualafied_id DOT ID                                       { cout << FMT_FG_YELLOW << "PARSER qualafied_id: | qualafied_id DOT ID" << FMT_RESET << endl; }
    | qualafied_id INDIRECT_MEMBER ID                           { cout << FMT_FG_YELLOW << "PARSER qualafied_id: | qualafied_id INDIRECT_MEMBER ID" << FMT_RESET << endl; }
                                                                ;

sub_proc:
    symbol LPAREN params RPAREN                                 {
                                                                    cout << FMT_FG_YELLOW
                                                                            << "PARSER sub_proc: | symbol LPAREN params RPAREN"
                                                                        << FMT_RESET << endl;
                                                                    $$=$1;
                                                                }
                                                                ;

array:
    symbol LBRACKET NUMERIC_LITERAL RBRACKET                    {
                                                                    cout << FMT_FG_YELLOW
                                                                            << "PARSER array: | symbol=\"" << $1 << "\" LBRACKET NUMERIC_LITERAL=\"" << $3 << "\" RBRACKET"
                                                                        << FMT_RESET << endl;;
                                                                    $$=$1;
                                                                }
                                                                ;

params:
    /*empty*/
    | symbol                                                    { cout << FMT_FG_YELLOW << "PARSER params: | symbol" << FMT_RESET << endl; }
    | params COMMA symbol                                       { cout << FMT_FG_YELLOW << "PARSER qualafied_id: | params COMMA symbol" << FMT_RESET << endl; }
                                                                ;

symbol:
    DOLLAR_SIGN ID                                              {
                                                                    cout << FMT_FG_YELLOW << "PARSER symbol: | ID=\"" << $1 << "\"" << FMT_RESET << endl;;
                                                                    $$=$2;
                                                                }
    | CONST_ID                                                  {
                                                                    cout << FMT_FG_YELLOW << "PARSER symbol: | CONST_ID=\"" << $1 << "\"" << FMT_RESET << endl;;
                                                                    $$=$1;
                                                                }
                                                                ;

built_in:
    CONFIG_LOAD attributes                                      {
                                                                    cout << FMT_FG_YELLOW << "PARSER built_in: | CONFIG_LOAD FILE_ATTRIB=\""
                                                                            << $1 << "\" EQUAL STRING_LITERAL=\"$2\""
                                                                         << FMT_RESET << endl;
                                                                }
    | INCLUDE attributes                                        {
                                                                    cout << FMT_FG_YELLOW
                                                                            << "PARSER built_in: | INCLUDE FILE_ATTRIB=\"%s\" EQUAL STRING_LITERAL=\"\""
                                                                         << FMT_RESET << endl;
                                                                }
    | REQUIRE attributes                                        {
                                                                    cout << FMT_FG_YELLOW
                                                                            << "PARSER built_in: | REQUIRE FILE_ATTRIB=\"%s\" EQUAL STRING_LITERAL=\"\""
                                                                         << FMT_RESET << endl;

                                                                }
    | INSERT attributes                                         {
                                                                    cout << FMT_FG_YELLOW
                                                                            << "PARSER built_in: | INSERT FILE_ATTRIB=\"\" EQUAL STRING_LITERAL=\"\""
                                                                         << FMT_RESET << endl;

                                                                }
    | ASSIGN attributes                                         {
                                                                    cout << FMT_FG_YELLOW
                                                                            << "PARSER built_in: | INSERT FILE_ATTRIB=\"\" EQUAL STRING_LITERAL=\"\""
                                                                         << FMT_RESET << endl;
                                                                }
                                                                ;

attributes:
    attrib                                                     {
                                                                    cout << FMT_FG_YELLOW << "PARSER attribute: | attribute={name=\"\"; value=\"\"\n" << FMT_RESET << endl;
                                                               }
    | attributes attrib                                        {
                                                                    cout << FMT_FG_YELLOW
                                                                            << "PARSER attributes: | attribute={name=\"\"; value=\"\"\n"
                                                                         << FMT_RESET << endl;
                                                               }
                                                               ;

attrib:
    VALUE_ATTRIB EQUAL STRING_LITERAL                          {
                                                                    cout << FMT_FG_YELLOW << "PARSER name_value: | VALUE_ATTRIB=\""
                                                                        << $1 << "\" EQUAL STRING_LITERAL=\""
                                                                        << buf << "\"" << FMT_RESET << endl;

                                                                    // std::pair<std::string, std::string>*  p($1, $2);
                                                                    // $$ = p;
                                                                    std::pair<std::string, std::string>*  ppair = new std::pair<std::string, std::string>($1, $2);
                                                                    $$ = ppair;
                                                               }
    | VAR_ATTRIB EQUAL STRING_LITERAL                          {
                                                                    cout << FMT_FG_YELLOW
                                                                            << "PARSER name_value: | VAR_ATTRIB=\"\" EQUAL STRING_LITERAL=\"\""
                                                                         << FMT_FG_GREEN << FMT_RESET << endl;

                                                                    std::pair<std::string, std::string>*  ppair = new std::pair<std::string, std::string>($1, $2);
                                                                    $$ = ppair;
                                                                }
    | FILE_ATTRIB EQUAL STRING_LITERAL                          {
                                                                    cout << FMT_FG_YELLOW
                                                                            << "PARSER name_value: | FILE_ATTRIB=\""
                                                                            << $1 << "\" EQUAL STRING_LITERAL=\""
                                                                            << $2 << "\""
                                                                         << FMT_RESET << endl;

                                                                    std::pair<std::string, std::string>*  ppair = new std::pair<std::string, std::string>($1, $2);
                                                                    $$ = ppair;
                                                               }
                                                               ;

%%

char* STRDUP(char* s)
{
    char* dup = (char*)malloc(strlen(s) + 1);
    strcpy(dup, s);
    return dup;
}

nvalue* alloc_nvalue(char* name, char* value)
{
    nvalue* nval = (nvalue*)malloc( sizeof( nvalue ) );
    nval->name = STRDUP(name);
    nval->value = STRDUP(value);
    nval->next = 0;
    return nval;
}

void free_nvalue(nvalue* nv)
{
    free(nv->name);
    free(nv->value);
    free(nv);
}

void free_all_nvalues()
{
    if(!pnv_head)
        return;

    nvalue* cur = pnv_head;
    nvalue* next = pnv_head->next;
    while(cur != 0)
    {
        free_nvalue(cur);
        cur = next;
        next = cur->next;
    }
}
/*
int yyerror(char * s)
{
    fprintf(stderr, "%s\n", s);
    return 0;
};

int main(int argc, char** argv)
{
    extern FILE *yyin;
    for(int i = 1; i < argc; ++i)
    {
        yyin = fopen(argv[i], "r");
        if(!yyin)
            printf("error opening file: %s ...", argv[i]);


        cout << FMT_FG_YELLOW << "************************* RUN *************************" << FMT_REVERSE << FMT_RESET << endl;
        cout << FMT_FG_YELLOW << "* Terminate listing with ; to see parsed AST          *" << FMT_REVERSE << FMT_RESET << endl;
        cout << FMT_FG_YELLOW << "* Terminate parser with Ctrl-D ...                    *" << FMT_REVERSE << FMT_RESET << endl;
        cout << FMT_FG_YELLOW << "%s* parsing file=\"%s\"                       *%s\n", FMT_REVERSE, FMT_ITALIC, argv[i], FMT_RESET);
        cout << FMT_FG_YELLOW << "************************* Done ************************" << FMT_REVERSE << FMT_RESET << endl;

        yyparse();

        cout << FMT_FG_YELLOW << "%sclosing file=\"%s\"%s\n", FMT_ITALIC, FMT_FG_CYAN, argv[i], FMT_RESET);
        fclose(yyin);
        free(yyin);
        yyin = 0;

    }
s    exit(0);
}
*/

namespace yy
{
    // report an error to the user
    auto parser::error(const std::string& msg) -> void
    {
        std::cerr << msg << '\n';
    }
}

int main()
{
    yy::parser parse;
    return parse();
}
