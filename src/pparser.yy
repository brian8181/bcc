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

%token CONST VOLATILE STATIC
%token UNSIGNED SIGNED LONG REGISTER SHORT
%token INT FLOAT CHAR VOID
%token STRUCT TYPEDEF
%token HASH_INCLUDE HASH_DEFINE HASH_UDEF HASH_IF HASH_IFDEF HASH_IFNDEF
%token <std::string> INDIRECT_MEMBER ARRAY
%token AND OR NOT BIT_AND BIT_OR BIT_XOR BIT_NOT RSHIFT LSHIFT
%token BACKSLASH QUESTION_MARK COLON SEMI_COLON DOUBLE_QUOTE SINGLE_QUOTE BACK_SLASH
%token COMMA LBRACKET RBRACKET LBRACE RBRACE LPAREN RPAREN DOT

%token <std::string> IDENTIFIER 
%token <std::string> STRING_LITERAL NUMERIC_LITERAL REAL_LITERAL CHAR_LITERAL
%nonassoc IFX
%nonassoc IF ELSE ELSEIF DO WHILE FOR BREAK CONTINUE RETURN CASE SWITCH DEFAULT PRINT
%left EQ ASSIGN
%left GREATER_THAN_EQUAL LESS_THAN_EQUAL NOT_EQUAL LESS_THAN GREATER_THAN
%left ADD SUB
%left MUL DIV MOD
%nonassoc UMINUS

/* %type <std::string> param
%type < std::vector< std::string> > params */
%type <std::string> file
%type < std::vector< std::string > > files
%type <std::string> stmt
%type < std::vector< std::string > > stmts
/*
%type <std::string> block
%type < std::vector< std::string > > blocks
*/

%type <std::string> print_function
%type < std::pair<std::string, std::string> >  assign_expr
%type <std::string> expr
/* %type <std::string> access_modfiers */
%type <std::string> access_modfier type_modifier modifiers
%type <std::string> intregal_type
%type <std::string> decel function_decel
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
/*
block:
    file block END_OF_FILE
    | LBRACE block RBRACE
    ; */

/**
 * @name stmts
 * @brief statments list
 */
stmts[result]:
    //%empty
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
                                                                    INFO("stmt: | expr=" << $expr << " SEMI_COLON");
                                                                    WARN("expr: not an l-side"); 
                                                                }
    | decel SEMI_COLON                                          { 
                                                                    INFO("stmt: | decel SEMI_COLON"); 
                                                                    stringstream ss;
                                                                    ss << "// " << $decel  << ";"; 
                                                                    lexer::instance().write_ostream(ss.str());
                                                                    INFO("strm << " << FMT_FG_YELLOW << ss.str() << FMT_RESET);
                                                                }
    | function_decel SEMI_COLON                                 {
                                                                    INFO("stmt: | function_decel SEMI_COLON");

                                                                }
   | decel ASSIGN expr SEMI_COLON                              { 
                                                                    INFO("stmt: | decel ASSIGN expr SEMI_COLON"); 
                                                                    _symtab[$decel].val = new int(std::atoi($expr.c_str()));
                                                                    stringstream ss;
                                                                    ss << "// " << $decel << " = " << $expr << ";"; 
                                                                    lexer::instance().write_ostream(ss.str());
                                                                    INFO("strm << " << FMT_FG_YELLOW << ss.str() << FMT_RESET);
                                                                    // testing lexer stream operator overload !
                                                                    cout << lexer::instance();
                                                                }
    | assign_expr SEMI_COLON                                    { 
                                                                    INFO("stmt: assign_expr SEMI_COLON");
                                                                    //INFO("stmt: IDENTIFIER ASSIGN expr SEMI_COLON"); 
                                                                    if(_symtab.find($1.first) != _symtab.end())
                                                                    {
                                                                        _symtab[$assign_expr.first].val = new int(std::atoi($assign_expr.second.c_str()));
                                                                        
                                                                        stringstream ss;
                                                                        ss << "// type<" << _symtab[$assign_expr.first].stype << "> id<" <<  $assign_expr.first << "> = " << $assign_expr.second << ";"; 
                                                                        lexer::instance().write_ostream(ss.str());
                                                                        INFO("strm << " << FMT_FG_YELLOW << ss.str() << FMT_RESET);
                                                                    }
                                                                    else
                                                                    {
                                                                        //INFO("UNDEFINED symbol, \"" << $assign_expr.first << "\"");
                                                                    }
                                                                }
    | HASH_INCLUDE STRING_LITERAL                               {
                                                                    INFO("stmt: | HASH_INCLUDE STRING_LITERAL=" << $2 << " SEMI_COLON");
                                                                    lexer::instance().push_include($STRING_LITERAL);
                                                                    $$ = $STRING_LITERAL;
                                                                }
    | print_function SEMI_COLON                                 {
                                                                     INFO("stmt: print_function SEMI_COLON"); 
                                                                     INFO($1); 
                                                                     $$ = $1;
                                                                }
    | WHILE LPAREN expr RPAREN stmt                             { INFO("expr: | WHILE LPAREN expr RPAREN stmt"); }
    | IF LPAREN expr RPAREN stmt %prec IFX                      { INFO("expr: | IF LPAREN expr RPAREN stmt %prec IFX"); }
|   | IF LPAREN expr RPAREN stmt ELSE stmt                      { INFO("expr: | IF LPAREN expr RPAREN stmt ELSE stmt"); }
    | LBRACE stmts RBRACE                                       { INFO("expr: | LBRACE stmts RBRACE"); }
    | error SEMI_COLON                                          
    | error RBRACE                                              
    ;


/**
 * @name expr
 * @brief Numerical / logical exprssions
 */
expr[result]:
    IDENTIFIER                                                  { 
                                                                    INFO("PARSER expr: | IDENTIFIER");
                                                                    $$ = *((int*)_symtab[$IDENTIFIER].val); //? val may not be int
                                                                }
    | NUMERIC_LITERAL                                           {
                                                                    INFO("PARSER expr: | NUMERICAL_LITERAL");
                                                                    stringstream ss;
                                                                    ss << std::atoi($NUMERIC_LITERAL.c_str());
                                                                    $result= ss.str();
                                                                }
    | REAL_LITERAL                                              {
                                                                    INFO("PARSER expr: | REAL_LITERAL");
                                                                    stringstream ss;
                                                                    ss << std::atof($REAL_LITERAL.c_str());
                                                                    $result = ss.str();
                                                                }
    | SUB expr %prec UMINUS                                     {
                                                                    INFO("expr: | SUB expr %prec UMINUS");
                                                                    stringstream ss;
                                                                    ss << -std::atoi($expr.c_str());
                                                                    $result = ss.str();
                                                                }
    | expr[lhs] ADD[op] expr[rhs]                               {
																	INFO("PARSER expr: | expr ADD expr");
																	stringstream ss;
                                                                    ss << (std::atoi($lhs.c_str()) + std::atoi($rhs.c_str()));
                                                                    $result = ss.str();
                                                                    INFO("$result=" << $result);
																}
    | expr[lhs] SUB[op] expr[rhs]                               {
																	INFO("PARSER expr: | expr SUB expr");
																	stringstream ss;
                                                                    ss << (std::atoi($lhs.c_str()) - std::atoi($rhs.c_str()));
                                                                    $result = ss.str();
                                                                    INFO("$result=" << $result);
																}
    | expr[lhs] MUL[op] expr[rhs]                               {
																	INFO("PARSER expr: | expr MUL expr");
																	stringstream ss;
                                                                    ss << (std::atoi($lhs.c_str()) * std::atoi($rhs.c_str()));
                                                                    $result = ss.str();
                                                                    INFO("$result=" << $result);
																}
    | expr[lhs] DIV[op] expr[rhs]                               {
																	INFO("PARSER expr: | expr DIV expr");
																	stringstream ss;
                                                                    ss << (std::atoi($lhs.c_str()) / std::atoi($rhs.c_str()));
                                                                    $result = ss.str();
                                                                    INFO("$result=" << $result);
																}
    | expr[lhs] MOD[op] expr[rhs]                               {
																	INFO("PARSER expr: | expr MOD expr");
																	stringstream ss;
                                                                    ss << (std::atoi($lhs.c_str()) % std::atoi($rhs.c_str()));
                                                                    $result = ss.str();
                                                                    INFO("$result=" << $result);
																}
    | expr[lhs] EQ[op] expr[rhs]                                {
																	INFO("PARSER expr: | expr EQ expr");
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
    | expr[lhs] AND[op] expr[rhs]                               {
																	INFO("PARSER expr: | expr AND expr");
																	$result = (std::atoi($lhs.c_str()) && std::atoi($rhs.c_str()));
																}
    | expr[lhs] OR[op] expr[rhs]                                {
																	INFO("PARSER expr: | expr OR expr");
																	$result = (std::atoi($lhs.c_str()) || std::atoi($rhs.c_str()));
																}
    | NOT expr[lhs]                                             {
																	INFO("PARSER expr: | NOT expr");
																	$result = !(std::atoi($lhs.c_str()));
																}
    | expr[lhs] RSHIFT[op] expr[rhs]                            {
																	INFO("PARSER expr: | expr RSHIFT expr");
																	$result = (std::atoi($lhs.c_str()) >> std::atoi($rhs.c_str()));
																}
    | expr[lhs] LSHIFT[op] expr[rhs]                            {
																	INFO("PARSER expr: | expr LSHIFT expr");
																	$result = (std::atoi($lhs.c_str()) << std::atoi($rhs.c_str()));
																}
    | expr[lhs] BIT_AND[op] expr[rhs]                           {
																	INFO("PARSER expr: | expr BIT_AND expr");
																	$result = (std::atoi($lhs.c_str()) & std::atoi($rhs.c_str()));
																}
    | expr[lhs] BIT_OR[op] expr[rhs]                            {
																	INFO("PARSER expr: | expr BIT_OR expr");
																	$result = (std::atoi($lhs.c_str()) | std::atoi($rhs.c_str()));
																}
     | expr[lhs] BIT_XOR[op] expr[rhs]                          {
																	INFO("PARSER expr: | expr BIT_XOR expr");
																	$result = (std::atoi($lhs.c_str()) ^ std::atoi($rhs.c_str()));
																}
    | BIT_NOT expr[lhs]                                         {
																	INFO("PARSER expr: | BITNOT expr");
																	$result = ~(std::atoi($lhs.c_str()));
																}
    | expr[lhs] NOT_EQUAL[op] expr[rhs]                         {
																	INFO("PARSER expr: | expr NOT_EQUAL expr");
																	$result = (std::atoi($lhs.c_str()) != std::atoi($rhs.c_str()));
																}
    | LPAREN expr[exp] RPAREN                                   {
																	INFO("PARSER expr: | LPAREN expr RPAREN");
                                                                    $result = $exp;
																}
                                                                ;
function_decel:
    intregal_type[type] IDENTIFIER[lhs] LPAREN RPAREN              {
                                                                        INFO("function_decel: | intregal_type[type] IDENTIFIER[lhs] LPAREN RPAREN");
                                                                        _symbol_t lhs = { $lhs, $type, 0, 0 }; // new symbol, unassigned!
                                                                        _symtab[$lhs] = lhs;                   // add to symbol table, unassigned!
                                                                    
                                                                        stringstream strm;
                                                                        strm << $type << " " << $lhs << "()";
                                                                        $function_decel = strm.str();

                                                                        stringstream ss;
                                                                        ss << "// " << "type<" << $type << "> " << "id<" << $lhs << "> ()";  
                                                                        lexer::instance().write_ostream(ss.str());
                                                                        INFO("strm << " << FMT_FG_YELLOW << ss.str() << FMT_RESET);
                                                                    }
    | intregal_type[type] IDENTIFIER[lhs] LPAREN params_decel RPAREN      {
                                                                        INFO("function_decel: | | intregal_type[type] IDENTIFIER[lhs] LPAREN params RPAREN");
                                                                        _symbol_t lhs = { $lhs, $type, 0, 0 }; // new symbol, unassigned!
                                                                        _symtab[$lhs] = lhs;                   // add to symbol table, unassigned!
                                                                    
                                                                        stringstream strm;
                                                                        strm << $type << " " << $lhs << "()";
                                                                        $function_decel = strm.str();

                                                                        stringstream ss;
                                                                        ss << "// " << "type<" << $type << "> " << "id<" << $lhs << "> ()";  
                                                                        lexer::instance().write_ostream(ss.str());
                                                                        INFO("strm << " << FMT_FG_YELLOW << ss.str() << FMT_RESET);
                                                                    }                                                        
                                                                    ;
/**
 * @name params
 */
params:
    expr
    | params COMMA expr
    ;
/**
 * @name params_decel
 */
params_decel:
    decel
    | params COMMA decel
    ;
/**
 * @name assign_expr
*/    
assign_expr:
    IDENTIFIER ASSIGN expr                                      {
                                                                    INFO("assign_expr: IDENTIFIER ASSIGN expr");
                                                                    std::pair<std::string, std::string> p = { $1, $3 };
                                                                    $$ = p;
                                                                }
                                                                ;
/**
 * @name decel
 * @brief decelration
 */                                                                
decel:
    intregal_type[type] IDENTIFIER[lhs]                             {
                                                                        INFO("decel: | type IDENTIFIER");
                                                                        _symbol_t lhs = { $lhs, $type, 0, 0 }; // new symbol, unassigned!
                                                                        _symtab[$lhs] = lhs;                   // add to symbol table, unassigned!
                                                                        
                                                                        stringstream ss;
                                                                        ss << "type<" << $type << "> " << "id<" << $lhs << ">";  
                                                                        $decel = ss.str();

                                                                        // write this to output
                                                                        lexer::instance().write_ostream(ss.str());
                                                                        INFO("strm << " << FMT_FG_YELLOW << ss.str() << FMT_RESET);
                                                                    }
                                                                    ;

print_function:
    PRINT LPAREN expr RPAREN                                        {
                                                                        INFO("print_function: | PRINT LPAREN expr RPAREN"); 
                                                                        $$=$3;
                                                                    };

/**
 * @name intreagl_type
 * @brief intergal type
 */
intregal_type:
    INT                                                         { INFO("intergal_type: | INT"); $$="int"; }
    | FLOAT                                                     { INFO("intergal_type: | INT"); $$="float"; }
    | CHAR                                                      { INFO("intergal_type: | INT"); $$="char"; }
    | VOID
                                                                ;
/**
 * @name modifiers
 */
modifiers:
    %empty
    | modifiers type_modifier
    | modifiers access_modfier
    ;
/**
 * @name type_modfier
 */
type_modifier:
    SIGNED
    | UNSIGNED
    | LONG
    | SHORT
    ;
/**
 * @name access_modifier
 * @brief access_modifier   
 */
access_modfier:
    CONST
    | VOLATILE
    | STATIC 
    | REGISTER
    ;
%%

#undef PARSER_LOG

/**
*/
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

/**
*/
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

/**
*/
bool is_name(const std::pair<string, string>& p, const string& str)
{
    return (p.first == str);
}

/**
*/
char* STRDUP(char* s)
{
    char* dup = (char*)malloc(strlen(s) + 1);
    strcpy(dup, s);
    return dup;
}

/**
*/
nvalue* alloc_nvalue(char* name, char* value)
{
    nvalue* nval = (nvalue*)malloc( sizeof( nvalue ) );
    nval->name = STRDUP(name);
    nval->value = STRDUP(value);
    nval->next = 0;
    return nval;
}

/**
*/
void free_nvalue(nvalue* nv)
{
    free(nv->name);
    free(nv->value);
    free(nv);
}

/**
*/
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
    /**
     * @name yylex
     */
    auto yylex() -> parser::symbol_type
    {
        return lex();
    }
    
    /**
     * @name parser::error
     */
    auto parser::error(const std::string& msg) -> void
    {
        std::cerr << msg << '\n';
    }
}
