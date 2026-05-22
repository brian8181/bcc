%require "3.2"
%language "c++"

%{
    #define YYDEBUG 1
%}

%define api.value.type variant
%code
{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    
    #include <iostream>
    #include <string>
    #include <iomanip>
    #include <list>
    #include <map>
    #include <vector>
    #include "fileio.hpp"
	#include "utility.hpp"
    #include "log.hpp"
    #include "symtab.h"
    #include "driver.hpp"
    #include "lexer.hpp"
	#include "bash_color.hpp"
    #include "table.hpp"

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
%token INCLUDE DEFINE UNDEF HASH_IF IFDEF IFNDEF HASH_ERROR PRAGMA
%token <std::string> TEST_TOKEN 

%token END_OF_FILES
%token END_OF_FILE 0

%token INC     
%token ADD_EQ  
%token SUB_EQ  
%token MUL_EQ  
%token DIV_EQ  
%token MOD_EQ  
%token OR_EQ   
%token AND_EQ  
%token NOT_EQ  
%token XOR_EQ  
%token LSFT_EQ 
%token RSFT_EQ 
%token TENERARY

%token BIT_AND
%token BIT_NOT
%token BIT_OR 
%token BIT_XOR
%token LSHIFT 
%token RSHIFT 
%token LSFT	  
%token RSFT  	

%token DEREF		
%token ADDR		 
%token REF				
%token STRUCT	
%token TYPEDEF

%token HEXADECIMAL_LITERAL 	
%token OCTAL_DECIMAL_LITERAL
         

%token CONST VOLATILE STATIC 
%token UNSIGNED SIGNED LONG REGISTER SHORT
%token INT FLOAT CHAR VOID STRING DOUBLE SINGLE

%token <std::string> INDIRECT_MEMBER 
%token AND OR NOT 
%token BACKSLASH QUESTION_MARK COLON SEMI_COLON DOUBLE_QUOTE SINGLE_QUOTE
%token COMMA LBRACKET RBRACKET LBRACE RBRACE DOT PTR ASTERICK
 
%token <std::string> IDENTIFIER 
%token <std::string> STRING_LITERAL NUMERIC_LITERAL REAL_LITERAL CHAR_LITERAL
%nonassoc IFX
%nonassoc IF ELSE ELSEIF DO WHILE FOR BREAK CONTINUE RETURN CASE SWITCH DEFAULT LABEL GOTO PRINT
%left EQ NEQ GEQ LEQ LT GT ASSIGN
%nonassoc  LPAREN RPAREN
%left ADD DASH
%left MUL DIV MOD
%nonassoc UMINUS

/* %type <std::string> param
%type < std::vector< std::string> > params */
%type < std::list< std::string > > args
%type < std::string > arg
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
%type intregal_type
%type <std::string> decel func_param_decels param_decels function_decel function_call
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
                                                                    print_symtab();
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
 * @type std::vector< std::string >
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
 * @brief input file
 * @type std::string : "file path"
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
    | IDENTIFIER LBRACKET NUMERIC_LITERAL RBRACKET ASSIGN expr SEMI_COLON   {
                                                                                INFO("stmt: | IDENTIFIER LBRACKET NUMERIC_LITERAL RBRACKET ASSIGN expr SEMI_COLON");
                                                                            }
    | function_decel SEMI_COLON                                 {
                                                                    INFO("stmt: | function_decel SEMI_COLON");
                                                                }
    | decel ASSIGN expr SEMI_COLON                               { 
                                                                    INFO("stmt: | decel ASSIGN expr SEMI_COLON"); 
                                                                    // _symtab[$decel].val = new int(std::atoi($expr.c_str()));
                                                                    // stringstream ss;
                                                                    // ss << "// " << $decel << " = " << $expr << ";"; 
                                                                    // lexer::instance().write_ostream(ss.str());
                                                                    // INFO("strm << " << FMT_FG_YELLOW << ss.str() << FMT_RESET);
                                                                    // // testing lexer stream operator overload !
                                                                    // cout << lexer::instance();
                                                                }
    | decel ASSIGN params_list SEMI_COLON                       {
                                                                    INFO("stmt: | decel ASSIGN params_list SEMI_COLON");
                                                                }
                                                                
    | assign_expr SEMI_COLON                                    { 
                                                                    INFO("stmt: assign_expr SEMI_COLON");
                                                                    INFO("stmt: IDENTIFIER ASSIGN expr SEMI_COLON"); 
                                                                    if(_symtab.find($1.first) != _symtab.end())
                                                                    {
                                                                        char* cstr = new char($assign_expr.second.size()+1);
                                                                        std::strcpy(cstr, $assign_expr.second.c_str());
                                                                        _symtab[$assign_expr.first].val = (void*)cstr;
                                                                        
                                                                        stringstream ss;
                                                                        ss << "// type<" << _symtab[$assign_expr.first].stype << "> id<" <<  $assign_expr.first << "> = " << $assign_expr.second << ";"; 
                                                                        
                                                                        stringstream ostrm;
                                                                        ostrm << _symtab[$assign_expr.first].stype << " " << $assign_expr.first << " = " <<  $assign_expr.second << ";\n";
                                                                        lexer::instance().write_ostream(ostrm.str());
                                                                        INFO("strm << " << FMT_FG_YELLOW << ss.str() << FMT_RESET);
                                                                    }
                                                                    else
                                                                    {
                                                                        INFO("UNDEFINED symbol");
                                                                    }
                                                                }
    | INCLUDE STRING_LITERAL                               {
                                                                    INFO("stmt: | INCLUDE STRING_LITERAL=" << $2 << " SEMI_COLON");
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
    // | error SEMI_COLON                                          
    // | error RBRACE                                               
                                                                ;

/**
 * @name expr
 * @brief Numerical / logical exprssions
 */
expr[result]:
    IDENTIFIER                                                  { 
                                                                    INFO("PARSER expr: | IDENTIFIER");
                                                                    //$$ = *((int*)_symtab[$IDENTIFIER].val); //? val may not be int
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
    | CHAR_LITERAL                                              {
                                                                    INFO("PARSER expr: | CHAR_LITERAL");
                                                                    stringstream ss;
                                                                    ss << $CHAR_LITERAL;
                                                                    $result = ss.str();
                                                                }
    | DASH expr %prec UMINUS                                     {
                                                                    INFO("expr: | DASH expr %prec UMINUS");
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
    | expr[lhs] DASH[op] expr[rhs]                               {
																	INFO("PARSER expr: | expr DASH expr");
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
    | expr[lhs] NEQ[op] expr[rhs]                               {
																	INFO("PARSER expr: | expr NEQ expr");
																	$result = (std::atoi($lhs.c_str()) != std::atoi($rhs.c_str()));
                                                                    INFO("$result=" << $result);
																}
    | expr[lhs] LT[op] expr[rhs]                                {
																	INFO("PARSER expr: | expr LT expr");
																	$result = (std::atoi($lhs.c_str()) < std::atoi($rhs.c_str()));
                                                                    INFO("$result=" << $result);
																}
    | expr[lhs] GT[op] expr[rhs]                                {
																	INFO("PARSER expr: | expr GT expr");
																	$result = (std::atoi($lhs.c_str()) > std::atoi($rhs.c_str()));  
                                                                    INFO("$result=" << $result);
																}
    | expr[lhs] GEQ[op] expr[rhs]                               {
																	INFO("PARSER expr: | expr GEQ expr ");
																	$result = (std::atoi($lhs.c_str()) >= std::atoi($rhs.c_str()));
																}
    | expr[lhs] LEQ[op] expr[rhs]                               {
																	INFO("PARSER expr: | expr LEQ expr");
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
																	INFO("PARSER expr: | BIT_NOT expr");
																	$result = ~(std::atoi($lhs.c_str()));
																}
    | LPAREN expr[exp] RPAREN                                   {
																	INFO("PARSER expr: | LPAREN expr RPAREN");
                                                                    $result = $exp;
																}
                                                                ;
/**
 * @name function_call
 */
function_call:
    IDENTIFIER[lhs] LPAREN RPAREN                               {
                                                                    INFO("function_call: IDENTIFIER[lhs] LPAREN RPAREN");
                                                                }
    | IDENTIFIER[lhs] params_list                               {
                                                                    INFO("function_call: IDENTIFIER[lhs] params_list");
                                                                } 
                                                                ;
/**
 * @name function_decel
 */                                                                 
function_decel:
    decel LPAREN RPAREN                                         {
                                                                    INFO("function_decel: | decl LPAREN_FUNC RPAREN");
                                                                    // _symbol_t lhs = { $lhs, $type, 0, 0 }; // new symbol, unassigned!
                                                                    // _symtab[$lhs] = lhs;                   // add to symbol table, unassigned!
                                                                
                                                                    // stringstream strm;
                                                                    // strm << $type << " " << $lhs << "()";
                                                                    // $function_decel = strm.str();
                                                                    // lexer::instance().write_ostream(strm.str());
                                                                    // stringstream ss;
                                                                    // ss << "// " << "type<" << $type << "> " << "id<" << $lhs << "> ()";  
                                                                    // INFO("strm << " << FMT_FG_YELLOW << ss.str() << FMT_RESET);
                                                                }
    | decel func_param_decels                                   {
                                                                    INFO("function_decel: intregal_type[type] IDENTIFIER[lhs] params_decel_list");
                                                                    //_symbol_t lhs = { $lhs, $type, 0, 0 }; // new symbol, unassigned!
                                                                    // _symtab[$lhs] = lhs;                   // add to symbol table, unassigned!
                                                                
                                                                    // stringstream strm;
                                                                    // strm << $type << " " << $lhs << "()";
                                                                    // $function_decel = strm.str();
                                                                    // lexer::instance().write_ostream(strm.str());
                                                                    // stringstream ss;
                                                                    // ss << "// " << "type<" << $type << "> " << "id<" << $lhs << "> ()";  
                                                                    // INFO("strm << " << FMT_FG_YELLOW << ss.str() << FMT_RESET);
                                                                }                                                        
                                                                ;
/**
 * @name pramas_list
 */
params_list:
    LPAREN params RPAREN                                        {
                                                                    INFO("params_list: LPAREN params RPAREN");
                                                                }
    | LBRACE params RBRACE                                      {
                                                                    INFO("params_list: LBRACKET params RBRACKET");
                                                                }
                                                                ;
/**
 * @name params
 */
params:
    expr                                                        {       
                                                                      INFO("params: expr");
                                                                }
    | params COMMA expr                                         {
                                                                      INFO("params: params COMMA expr");
                                                                }
                                                                ;
/**
 * @name params_decel_list
 */
func_param_decels:
    LPAREN param_decels RPAREN                                  {
                                                                    INFO("params_decel_list: LPAREN_FUNC params_decel RPAREN");
                                                                }
                                                                ;
/**
 * @name params_decel
 */
param_decels:
    decel                                                       {
                                                                    INFO("params_decel: decel");
                                                                }
    | param_decels COMMA decel                                  {
                                                                    INFO("params_decel: params_decel COMMA decel");
                                                                }
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
    intregal_type IDENTIFIER                                      {
                                                                        INFO("intregal_type: | INT IDENTIFIER");
                                                                  }
    | decel LBRACKET NUMERIC_LITERAL RBRACKET                     { 
                                                                        INFO("intregal_type: | decel LBRACKET NUMERIC_LITERAL RBRACKET");
                                                                  }
    | INT IDENTIFIER[lhs]                                         {
                                                                    INFO("decel: | INT IDENTIFIER");
                                                                    _symbol_t lhs = { $lhs, "INT", eINT, 0 }; // new symbol, unassigned!
                                                                    _symtab[$lhs] = lhs;                   // add to symbol table, unassigned!

                                                                    stringstream ss;
                                                                    ss << "type<" << "INT" << "> " << "id<" << $lhs << ">";  
                                                                    $decel = ss.str();   
                                                                    
                                                                    stringstream ostrm;
                                                                    ostrm << "INT" << " " << $lhs << ";\n"; 
                                                                    // write this to output
                                                                    lexer::instance().write_ostream(ostrm.str());

                                                                    INFO("strm << " << FMT_FG_YELLOW << ss.str() << FMT_RESET);
                                                                }
    | STRING IDENTIFIER[lhs]                                    {
                                                                    INFO("decel: | STRING IDENTIFIER");
                                                                    _symbol_t lhs = { $lhs, "STRING", 0, 0 }; // new symbol, unassigned!
                                                                    _symtab[$lhs] = lhs;                   // add to symbol table, unassigned!

                                                                    stringstream ss;
                                                                    ss << "type<" << "STRING" << "> " << "id<" << $lhs << ">";  
                                                                    $decel = ss.str();   
                                                                    
                                                                    stringstream ostrm;
                                                                    ostrm << "STRING" << " " << $lhs << ";\n"; 
                                                                    // write this to output
                                                                    lexer::instance().write_ostream(ostrm.str());

                                                                    INFO("strm << " << FMT_FG_YELLOW << ss.str() << FMT_RESET);
                                                                }
    | CHAR IDENTIFIER[lhs]                                       {
                                                                    INFO("decel: | CHAR IDENTIFIER");
                                                                    _symbol_t lhs = { $lhs, "CHAR", 0, 0 }; // new symbol, unassigned!
                                                                    _symtab[$lhs] = lhs;                   // add to symbol table, unassigned!

                                                                    stringstream ss;
                                                                    ss << "type<" << "CHAR" << "> " << "id<" << $lhs << ">";  
                                                                    $decel = ss.str();   
                                                                    
                                                                    stringstream ostrm;
                                                                    ostrm << "CHAR" << " " << $lhs << ";\n"; 
                                                                    // write this to output
                                                                    lexer::instance().write_ostream(ostrm.str());

                                                                    INFO("strm << " << FMT_FG_YELLOW << ss.str() << FMT_RESET);
                                                                }
    | FLOAT IDENTIFIER[lhs]                                     {
                                                                    INFO("decel: | FLOAT IDENTIFIER");
                                                                    _symbol_t lhs = { $lhs, "FLOAT", 0, 0 }; // new symbol, unassigned!
                                                                    _symtab[$lhs] = lhs;                   // add to symbol table, unassigned!

                                                                    stringstream ss;
                                                                    ss << "type<" << "FLOAT" << "> " << "id<" << $lhs << ">";  
                                                                    $decel = ss.str();   
                                                                    
                                                                    stringstream ostrm;
                                                                    ostrm << "FLOAT" << " " << $lhs << ";\n"; 
                                                                    // write this to output
                                                                    lexer::instance().write_ostream(ostrm.str());

                                                                    INFO("strm << " << FMT_FG_YELLOW << ss.str() << FMT_RESET);
                                                                }
     | VOID IDENTIFIER[lhs]                                     {
                                                                    INFO("decel: | VOID IDENTIFIER");
                                                                    _symbol_t lhs = { $lhs, "VOID", eVOID | eFUNC, 0 }; // new symbol, unassigned!
                                                                    _symtab[$lhs] = lhs;                                // add to symbol table, unassigned!

                                                                    stringstream ss;
                                                                    ss << "type<" << "VOID" << "> " << "id<" << $lhs << ">";  
                                                                    $decel = ss.str();   
                                                                    
                                                                    stringstream ostrm;
                                                                    ostrm << "VOID" << " " << $lhs << ";\n"; 
                                                                    // write this to output
                                                                    lexer::instance().write_ostream(ostrm.str());

                                                                    INFO("strm << " << FMT_FG_YELLOW << ss.str() << FMT_RESET);
                                                                }
    |  intregal_type[type] PTR IDENTIFIER[lhs]                  {
                                                                    INFO("decel | intregal_type[type] PTR IDENTIFIER[lhs]");
                                                                    _symbol_t lhs = { $lhs, "PTR", ePTR, new int(0) }; // new symbol, unassigned!
                                                                    _symtab[$lhs] = lhs;                   // add to symbol table, unassigned!

                                                                    // // stringstream ss;
                                                                    // // ss << "type<" << "PTR" << "> " << "id<" << $lhs << ">";  
                                                                    // // $decel = ss.str(); 
                                                                    // // // write this to output
                                                                    // // lexer::instance().write_ostream(ss.str());
                                                                    // // INFO("strm << " << FMT_FG_YELLOW << ss.str() << FMT_RESET);
                                                                }
                                                                ;
/**   
 * @name print_function   
 */   
print_function:   
    PRINT LPAREN expr RPAREN                                    {
                                                                    INFO("print_function: | PRINT LPAREN expr RPAREN"); 
                                                                    $$=$3;
                                                                };

/**
 * @name modifiers
 */
modifiers:
    %empty
    | modifiers type_modifier
    | modifiers access_modfier
    ;

/**
 * @name args
 * @type std::vector< std::string >
 */
args[list]:
    arg                                                        { $list.push_back($arg); }
    | args arg                                                 { $args.push_back($arg); $list == $args; }
    ;
/**
 * @name arg
 * @type std::string
 */
arg:
    '#' STRING_LITERAL '#'
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
                                                               
/**
 * @name intreagl_type
 * @brief intergal type
 */
intregal_type:
    INT                                                         { INFO("intergal_type: | INT");  /*$$=1*/; }
    | FLOAT                                                     { INFO("intergal_type: | FLOAT"); /*$$=FLOAT;*/ }
    | CHAR                                                      { INFO("intergal_type: | CHAR"); /*$$=CHAR;*/ }
    | STRING                                                    { INFO("intergal_type: | STRING"); /*$$=STRING;*/ }
    | VOID                                                      { INFO("intergal_type: | VOID"); /*$$=VOID;*/ }
                                                                ;
tokens:
    STRUCT
    | TYPEDEF
    | BACKSLASH
    | QUESTION_MARK
    | DOT
    | COLON
    | INDIRECT_MEMBER
    | DOUBLE_QUOTE
    | SINGLE_QUOTE
    | ASTERICK
    | ELSEIF
    | DO
    | FOR
    | BREAK
    | CONTINUE
    | RETURN
    | SWITCH
    | CASE
    | DEFAULT
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

void print_symtab()
{
    for (const auto& [key, value] : _symtab)
        std::cout << '[' << key << "] = " << (char*)(value.val) << endl;
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
