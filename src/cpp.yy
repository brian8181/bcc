%require "3.2"
%language "c++"

%{
    #define YYDEBUG 1
%}

%define api.parser.class {preprocessor}
%define api.value.type variant
%code
{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    
    #include <iostream>
    #include <string>
    #include <iomanip>
    #include <map>
    #include <vector>
    #include "lexer.hpp"
    #include "fileio.hpp"
	#include "utility.hpp"
    #include "log.hpp"
	#include "bash_color.hpp"
    
    using std::vector;
    using std::string;
    using std::cout;
    using std::endl;
    using std::pair;
    using std::map;

	#define PARSER_LOG TRUE

    #undef INFO_COLOR
    #define INFO_COLOR FMT_FG_CYAN
}

%code
{
	namespace yy
	{
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
}

%define api.token.constructor
%code
{
    // declare yylex
    namespace yy
    {
        auto yylex() -> preprocessor::symbol_type;
    }

    char* STRDUP(char* s);
    /* string literal buffer */
    char buf[100];
    char *s;
    
    static int m_file_count = 0;
    void print_symtab();

}

%code
{
	/* namespace yy
	{
		// Return the next token.
		auto yylex () -> parser::symbol_type
		static int count = 0;
		switch (int stage = count++)
		{
		case 0:
		return parser::make_TEXT ("I have three numbers for you.");
		case 1: case 2: case 3:
			return parser::make_NUMBER (stage);
		case 4:
		return parser::make_TEXT ("And that’s all!");
		default:
			return parser::make_YYEOF ();
		}
	} */
}

%token SKIP_TOKEN UNDEFINED
%token <std::string> TEST_TOKEN 
%token END_OF_FILES
%token END_OF_FILE 0
%token PRINT
%token <std::string> IDENTIFIER 
%token<std::string> UNESCAPED_TEXT
%nonassoc IFX
%nonassoc IFDEF IFNDEF ENDIF DEFINE UNDEF INCLUDE PRAGMA


/* %type <std::string> param
%type < std::vector< std::string> > params */
%type <std::string> file
%type < std::vector< std::string > > files
%type <std::string> print_function
%type <std::string> preprocessor
%start preprocessor

%%
/**
 * @name complier
 */
preprocessor:
    TEST_TOKEN                                                 {
                                                                    INFO("preprocessor: | TEST_TOKEN=" << $1);
                                                               }  
   | files  END_OF_FILES                                       {
                                                                    INFO("preprocessor: files.size=" << $1.size() << " END_OF_FILES");
                                                                    print_symtab();
																	cout << "processed files ..." << endl;
																	int len = $1.size();
																	for(int i = 0; i < len; ++i)
																	{
																		cout << $1[i] << endl;
																	}

                                                                    cout << FMT_FG_DARK_GREY << "PARSER compiler: | files" << endl;
                                                                    cout << FMT_FG_DARK_GREY << "*********************** STOPPING **********************" << FMT_RESET << endl;
                                                                    cout << FMT_FG_DARK_GREY << "*                     Terminating.                    *" << FMT_RESET << endl;
                                                                    cout << FMT_FG_DARK_GREY << "************************* Done ************************" << FMT_RESET << endl;
																	SYST("system halting ...");
																	std::exit(0);
                                                                }
                                                                ;
/**
 * @name files
 * @brief files list
 */
files[result]:
	file                                                        {
																	 INFO("files: | file=\"" << $file << "\"");
																	 $result.push_back($file);
																}
    | files[file_list] file                                     {
																	INFO("files: | files file=\"" << $file << "\"");
																	$file_list.push_back($file);
																	$result = $file_list;
																}
                                                                ;
/**
 * @name file
 */
file:
	file_content END_OF_FILE
						                                        {
                                                                    INFO("file: blocks.size END_OF_FILE");

																	string name;
																	//lexer::instance().get_current_infile(name);
																	$file = name;

                                                                    cout << FMT_FG_DARK_GREY << "file: | blocks END_OF_FILE" << endl;
                                                                    cout << FMT_FG_DARK_GREY << "*******************************************************" << FMT_RESET << endl;
                                                                    cout << FMT_FG_DARK_GREY << "*                      End Of File                    *" << FMT_RESET << endl;
                                                                    cout << FMT_FG_DARK_GREY << "*******************************************************" << FMT_RESET << endl;
                                                                }
                                                                ;
file_content:       
    %empty                                                         
    | file_content stmt                                                 {}
    | file UNESCAPED_TEXT                                       {}
                                                                ;

 
stmt:
    IFDEF IDENTIFIER UNESCAPED_TEXT ENDIF %prec IFX                 { INFO("expr: | IFDEF IDENTIFIER UNESCAPED_TEXT ENDIF %prec IFX"); }
    | IFNDEF IDENTIFIER UNESCAPED_TEXT ENDIF %prec IFX              { INFO("expr: | IFNDEF IDENTIFIER UNESCAPED_TEXT ENDIF %prec IFX"); }
    | DEFINE IDENTIFIER                                             { INFO("expr: | DEFINE IDENTIFIER"); }
    | UNDEF  IDENTIFIER                                             { INFO("expr: | UNDEF IDENTIFIER"); }
    | PRAGMA  /*todo*/                                              { INFO("expr: | DEFINE IDENTIFIER"); }
                                                                    ;
%%
#undef PARSER_LOG

void print_symtab()
{
    /* for (const auto& [key, value] : _symtab)
        std::cout << '[' << key << "] = " << (char*)(value.val) << endl; */
}

namespace yy
{
    /**
     * @name yylex
     */
    /* auto yylex() -> preprocessor::symbol_type
    {
        return lex();
    } */
    
    /**
     * @name parser::error
     */
    auto preprocessor::error(const std::string& msg) -> void
    {
        std::cerr << msg << '\n';
    }
}
