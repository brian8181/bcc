%require "3.2"
%language "c++"

%{
    #define YYDEBUG 1
%}

%define api.value.type variant
%code
{
    #include <iostream>
    #include <string>
    #include <iomanip>
    #include <list>
    #include <map>
    #include <vector>
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "fileio.hpp"
	#include "utility.hpp"
    #include "log.hpp"
    #include "symtab.h"
    #include "driver.hpp"
    #include "lexer.hpp"
	#include "bash_color.hpp"

    using std::vector;
    using std::string;
    using std::cout;
    using std::endl;
    using std::pair;
    using std::map;

	#define PARSER_LOG TRUE

    #undef INFO_COLOR
    #define INFO_COLOR FMT_FG_BLUE

	typedef std::pair< std::string, std::string > attribute;
	//typedef std::string stmt_t;
	//typedef std::vector< std::string > stmts_t;
    typedef std::pair< std::string, std::string > attrib_t;
    typedef std::vector< attrib_t > attributes_t;

    std::map<string, string> stab;

    typedef struct symbol_t
    {
        std::string name;
        symbol_t* parent;
        std::vector<symbol_t> members;
    } symbol_t;

    typedef struct modifier_t
    {
        std::string name;
        std::string params;
    } modifier_t;
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
        auto yylex() -> parser::symbol_type;
    }

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

    bool get_value(const string& name, /*out*/ string& val);
    bool set_value(const string& name, const string& val);
    bool is_name(const std::pair<string, string>& p, const string& str);

    //%type<std::vector< modifier_t > > modifiers
    //%type<modifier_t> modifier
	#include "table.hpp"

	static int m_file_count = 0;

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

%token <std::string> CONST VOLATILE STATIC
%token <std::string> UNSIGNED SIGNED INLINE
%token INT FLOAT CHAR
%token INCLUDE
%token IF ELSE ELSEIF DO WHILE FOREACH BREAK CONTINUE
%token <std::string> INDIRECT_MEMBER ARRAY
%token <std::string> IDENTIFIER 
%token <std::string> STRING_LITERAL NUMERIC_LITERAL
%token CARROT DASH BACKSLASH QUESTION_MARK SEMI_COLON DOUBLE_QUOTE SINGLE_QUOTE BACK_SLASH AT AMPERSAND AND OR NOT
%token COMMA OPEN_BRACKET CLOSE_BRACKET OPEN_BRACE CLOSE_BRACE OPEN_PAREN CLOSE_PAREN DOT


%type <std::string> file
%type < std::vector< std::string > > files
%type <std::string> stmt
%type < std::vector< std::string > > stmts
/*
%type <std::string> block
%type < std::vector< std::string > > blocks
*/

%nonassoc IFX
%nonassoc ELSE ELSEIF IF WHILE BREAK
%left EQUAL EQUALS
%left GREATER_THAN_EQUAL LESS_THAN_EQUAL  NOT_EQUAL LESS_THAN GREATER_THAN COMMA
%left PLUS MINUS
%left MULTIPLY DIVIDE MODULUS
%type <std::string> expr
/* %type <std::string> access_modfiers */
%type <std::string> access_modfier
%type <std::string> intregal_type
%type <std::string> decel
%type <std::string> compiler
%start compiler

%%
/**
 * @name complier
 */
compiler:
    TEST_TOKEN                                                 {
                                                                            INFO("complier: | TEST_TOKEN=" << $1);
                                                               }  
   | files  END_OF_FILES                                       {
																	INFO("compiler: files.size=" << $1.size() << " END_OF_FILES");

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
    | files[file_list] file                                                {
																	INFO("files: | files file=\"" << $file << "\"");
																	$file_list.push_back($file);
																	$result = $file_list;
																}
                                                                ;
/**
 * @name file
 */
file:
	stmts END_OF_FILE
						                                        {
                                                                    INFO("file: blocks.size=" << $1.size() << " END_OF_FILE");

																	string name;
																	lexer::instance().get_current_infile(name);
																	$file = name;

                                                                    cout << FMT_FG_DARK_GREY << "file: | blocks END_OF_FILE" << endl;
                                                                    cout << FMT_FG_DARK_GREY << "*******************************************************" << FMT_RESET << endl;
                                                                    cout << FMT_FG_DARK_GREY << "*                      End Of File                    *" << FMT_RESET << endl;
                                                                    cout << FMT_FG_DARK_GREY << "*******************************************************" << FMT_RESET << endl;
                                                                }
                                                                ;
/**
 * @name stmts
 * @brief statments list
 */
stmts[result]:
    /* %empty */
    stmt[lhs]                                                   { 
                                                                    INFO("stmts: | stmt"); 
                                                      				$result.push_back($lhs);
                                                                }
    | stmts[lhs] stmt[rhs]			                            {
																	INFO("stmts: | stmts stmt");
																	$lhs.push_back($rhs);
																	$result = $lhs;
																}
                                                                ;
/**
 * @name stmt
 * @brief statement
 */
stmt:
    expr  SEMI_COLON                                            {
                                                                    INFO("stmt: | expr SEMI_COLON");
                                                                    WARN("expr: not an l-side"); 
                                                                }
    | decel SEMI_COLON                                          { 
                                                                    INFO("stmt: | decel SEMI_COLON"); 
                                                                    stringstream ss;
                                                                    ss << "// " << ";"; 
                                                                    lexer::instance().write_ostream(ss.str());
                                                                    INFO("strm << " << FMT_FG_YELLOW << ss.str() << FMT_RESET);
                                                                }
    | decel EQUAL IDENTIFIER SEMI_COLON                         { 
                                                                    INFO("stmt: | decel EQUAL IDENTIFIER SEMI_COLONL"); 
                                                                    symbol_table[$1] = $3;
                                                                    stringstream ss;
                                                                    ss << "// " << " = " << $IDENTIFIER << ";"; 
                                                                    lexer::instance().write_ostream(ss.str());
                                                                    INFO("strm << " << FMT_FG_YELLOW << ss.str() << FMT_RESET);
                                                                    // testing lexer stream operator overload !
                                                                    cout << lexer::instance();
                                                                }
    | decel EQUAL expr SEMI_COLON                               { 
                                                                    INFO("stmt: | decel EQUAL expr SEMI_COLON"); 
                                                                    symbol_table[$1] = $3;
                                                                    stringstream ss;
                                                                    ss << "// " << " = " << $expr << ";"; 
                                                                    lexer::instance().write_ostream(ss.str());
                                                                    INFO("strm << " << FMT_FG_YELLOW << ss.str() << FMT_RESET);
                                                                    // testing lexer stream operator overload !
                                                                    cout << lexer::instance();
                                                                }
     | IDENTIFIER EQUAL IDENTIFIER SEMI_COLON                   { 
                                                                    INFO("stmt: IDENTIFIER EQUAL IDENTIFIER SEMI_COLON"); 
                                                                    if(symbol_table.find($1) != symbol_table.end())
                                                                    {
                                                                        ERROR("UNDEFINED symbol, \"$1\"");
                                                                        return -1;
                                                                    }

                                                                    // symbol_table[$1] = $3;
                                                                    //  stringstream ss;
                                                                    // ss << "// " << $IDENTIFIER << " = " << $expr << ";"; 
                                                                    // lexer::instance().write_ostream(ss.str());
                                                                    // INFO("strm << " << FMT_FG_YELLOW << ss.str() << FMT_RESET);
                                                                }                                           
    | IDENTIFIER EQUAL expr SEMI_COLON                          { 
                                                                    INFO("stmt: IDENTIFIER EQUAL expr SEMI_COLON"); 
                                                                    if(symbol_table.find($IDENTIFIER) != symbol_table.end())
                                                                    {
                                                                        ERROR("UNDEFINED symbol, \"$IDENTIFIER\"");
                                                                        return -1;
                                                                    }

                                                                    symbol_table[$1] = $3;
                                                                     stringstream ss;
                                                                    ss << "// " << $IDENTIFIER << " = " << $expr << ";"; 
                                                                    lexer::instance().write_ostream(ss.str());
                                                                    INFO("strm << " << FMT_FG_YELLOW << ss.str() << FMT_RESET);
                                                                }
    ;
    
/**
 * @name expr
 * @brief Numerical / logical exprssions
 */
expr[result]:
    NUMERIC_LITERAL                                             { $result=$NUMERIC_LITERAL; }
    | expr[lhs] PLUS[op] expr[rhs]                              {
																	INFO("PARSER expr: | expr PLUS expr");
																	stringstream ss;
                                                                    ss << (std::atoi($lhs.c_str()) + std::atoi($rhs.c_str()));
                                                                    $result = ss.str();
                                                                    INFO("$result=" << $result);
																}
    | expr[lhs] MINUS[op] expr[rhs]                             {
																	INFO("PARSER expr: | expr MINUS expr");
																	stringstream ss;
                                                                    ss << (std::atoi($lhs.c_str()) - std::atoi($rhs.c_str()));
                                                                    $result = ss.str();
                                                                    INFO("$result=" << $result);
																}
    | expr[lhs] MULTIPLY[op] expr[rhs]                          {
																	INFO("PARSER expr: | expr MULTIPLY expr");
																	stringstream ss;
                                                                    ss << (std::atoi($lhs.c_str()) * std::atoi($rhs.c_str()));
                                                                    $result = ss.str();
                                                                    INFO("$result=" << $result);
																}
    | expr[lhs] DIVIDE[op] expr[rhs]                            {
																	INFO("PARSER expr: | expr DIVIDE expr");
																	stringstream ss;
                                                                    ss << (std::atoi($lhs.c_str()) / std::atoi($rhs.c_str()));
                                                                    $result = ss.str();
                                                                    INFO("$result=" << $result);
																}
    | expr[lhs] MODULUS[op] expr[rhs]                           {
																	INFO("PARSER expr: | expr MODULUS expr");
																	stringstream ss;
                                                                    ss << (std::atoi($lhs.c_str()) % std::atoi($rhs.c_str()));
                                                                    $result = ss.str();
                                                                    INFO("$result=" << $result);
																}
    | expr[lhs] EQUALS[op] expr[rhs]                            {
																	INFO("PARSER expr: | expr EQUALS expr");
																	$result = (std::atoi($lhs.c_str()) == std::atoi($rhs.c_str()));
                                                                    INFO("$result=" << $result);
																}
    | expr[lhs] LESS_THAN[op] expr[rhs]                         {
																	INFO("PARSER expr: | expr LESS_THAN expr");
																	$result = (std::atoi($lhs.c_str()) < std::atoi($rhs.c_str()));
                                                                    INFO("$result=" << $result);
																}
    | expr[lhs] GREATER_THAN[op] expr[rhs]                      {
																	INFO("PARSER expr: | expr GREATER_THAN expr");
																	$result = (std::atoi($lhs.c_str()) > std::atoi($rhs.c_str()));  
                                                                    INFO("$result=" << $result);
																}
    | expr[lhs] GREATER_THAN_EQUAL[op] expr[rhs]                {
																	INFO("PARSER expr: | expr GREATER_THAN_EQUAL expr ");
																	$result = (std::atoi($lhs.c_str()) >= std::atoi($rhs.c_str()));
																}
    | expr[lhs] LESS_THAN_EQUAL[op] expr[rhs]                   {
																	INFO("PARSER expr: | expr LESS_THAN_EQUAL expr");
																	$result = (std::atoi($lhs.c_str()) <= std::atoi($rhs.c_str()));
																}
    | expr[lhs] NOT_EQUAL[op] expr[rhs]                         {
																	INFO("PARSER expr: | expr NOT_EQUAL expr");
																	$result = (std::atoi($lhs.c_str()) != std::atoi($rhs.c_str()));
																}
    | OPEN_PAREN expr[exp] CLOSE_PAREN                          {
																	INFO("PARSER expr: | OPEN_PAREN expr CLOSE_PAREN");
                                                                    $result = $exp;
																}
                                                                ;
/**
 * @name decel
 * @brief decelration
 */                                                                
decel:
    intregal_type IDENTIFIER                                    {
                                                                    INFO("decel: | type IDENTIFIER");
                                                                    // __symbol s = {$2, $1, 0, 0};
                                                                    // tab[$2] = s;
                                                                    symbol_table[$2] = "empty";
                                                                    $decel = $2;

                                                                    stringstream ss;
                                                                    ss << "// " << "type<" << $intregal_type << "> " << "id<" << $IDENTIFIER << ">";  
                                                                    lexer::instance().write_ostream(ss.str());
                                                                    INFO("strm << " << FMT_FG_YELLOW << ss.str() << FMT_RESET);
                                                                }
                                                                ;
/**
 * @name intreagl_type
 * @brief intergal type
 */
intregal_type:
    INT                                                         { INFO("intergal_type: | INT"); $$="int"; }
    | FLOAT                                                     { INFO("intergal_type: | INT"); $$="int"; }
    | CHAR                                                      { INFO("intergal_type: | INT"); $$="int"; }
    | access_modfier INT                                        { INFO("intergal_type: | access_modfier INT"); $$="int"; }
    | access_modfier FLOAT                                      { INFO("intergal_type: | access_modfier FLOAT"); $$="float"; }
    | access_modfier CHAR                                       { INFO("intergal_type: | access_modfier CHAR"); $$="char"; }
                                                                ;
/**
access_modfiers:
    '%' '#' '$'
    ;
*/
/**
 * @brief access_modifier
 */
access_modfier:
    CONST
    | VOLATILE
    | STATIC 
    ;
%%

#undef PARSER_LOG

bool get_value(const string& name, /*out*/ string& val)
{
    if(symbol_table.find(name) != symbol_table.end())
    {
        val = symbol_table[name];
        return true;
    }
    INFO("symbol, (" << name << "), not found!");
    return false;
}

bool set_value(const string& name, const string& val)
{
    if(symbol_table.find(name) != symbol_table.end())
    {
        symbol_table[name] = val;
        INFO("symbol updated: " << name << " = " << val);
        return true;
    }
    INFO("symbol, (" << name << "), not found!");
    return false;
}

bool is_name(const std::pair<string, string>& p, const string& str)
{
    return (p.first == str);
}

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

namespace yy
{
    auto yylex() -> parser::symbol_type
    {
        return lex();
    }

    auto parser::error(const std::string& msg) -> void
    {
        std::cerr << msg << '\n';
    }


}
