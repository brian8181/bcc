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

    std::map<string, string> stab;


    struct mytype;
    struct symbol_t;
    struct modifier_t;

    typedef std::string arg_t;
    typedef std::vector<arg_t> args_t;
    typedef std::string param_t;
    typedef std::vector<param_t> params_t;



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


%token SKIP_TOKEN UNDEFINED
%token <std::string> TEST_TOKEN
%token PRINT
%token END_OF_FILES
%token END_OF_FILE 0
%token ESC_SEQ
%token ESC_NLINE
%token ESC_BACKSLASH
%token ESC_NEWLINE
%token ESC_DOUBLE_QUOTE
%token ESC_SINGLE_QUOTE
%token ESC_TAB
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

%token AND OR NOT
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

%token CONST VOLATILE STATIC
%token UNSIGNED SIGNED LONG REGISTER SHORT
%token INT FLOAT CHAR VOID STRING DOUBLE SINGLE

%token <std::string> INDIRECT_MEMBER

%token BACKSLASH QUESTION_MARK COLON SEMI_COLON DOUBLE_QUOTE SINGLE_QUOTE
%token COMMA LBRACKET RBRACKET LBRACE RBRACE DOT PTR ASTERICK

%token <std::string> IDENTIFIER
%token <std::string> STRING_LITERAL NUMERIC_LITERAL REAL_LITERAL CHAR_LITERAL HEXADECIMAL_LITERAL OCTAL_DECIMAL_LITERAL
%nonassoc IFX
%nonassoc IF ELSE ELSEIF DO WHILE FOR BREAK CONTINUE RETURN CASE SWITCH DEFAULT LABEL GOTO
%left EQ NEQ GEQ LEQ LT GT ASSIGN
%nonassoc  LPAREN RPAREN
%left ADD DASH
%left MUL DIV MOD
%nonassoc UMINUS


%type <std::string> operand
%type <std::string> params_list
%type <std::string> case cases
%type < mytype > test;
%type <std::string> param
%type < std::vector< std::string > > params
%type < args_t > args
%type < arg_t > arg
%type <std::string> file
%type < std::vector< std::string > > files
%type <std::string> stmt
%type < std::vector< std::string > > stmts
/*
%type <std::string> block
%type < std::vector< std::string > > blocks
*/
%type <std::string> if_expr else_if_expr else_expr
%type < std::pair<std::string, std::string> >  assign_expr
%type <std::string> expr
/* %type <std::string> access_modfiers */
%type atomic_type_specifier type_qualifier function_specifier
%type <std::string> access_modfier type_modifier modifiers
%type <std::string> numeric_type
%type <std::string> lval rval value_type void_type decel_void
%type <std::string> decel decel_numeric func_param_decels param_decels function_decel function_call
/*%type <std::string> compiler*/
%start compiler


%%
/**
 * @name complier
 */
compiler:
    TEST_TOKEN                                                 {
                                                                            INFO("complier: | TEST_TOKEN=" << $1);
                                                               }
   | file  END_OF_FILE                                         {
                                                                    print_symtab();
																	INFO("compiler: files.size=" << $1.size() << " END_OF_FILES");

																	cout << "processed files ..." << endl;
																	int len = $1.size();
																	for(int i = 0; i < len; ++i)
																	{
																		cout << $1[i] << endl;
																	}

                                                                    cout << FMT_FG_DARK_GREY << "PARSER compiler: | file END_OF_FILE" << endl;
                                                                    cout << FMT_FG_DARK_GREY << "*********************** STOPPING **********************" << FMT_RESET << endl;
                                                                    cout << FMT_FG_DARK_GREY << "*                     Terminating.                    *" << FMT_RESET << endl;
                                                                    cout << FMT_FG_DARK_GREY << "************************* Done ************************" << FMT_RESET << endl;
																	SYST("system halting ...");
																	//std::exit(0);
                                                                }
                                                                ;

test:
    TEST_TOKEN                                                  { INFO("test: TEST_TOKEN"); mytype t = { 42 }; $$=t; };

/**
 * @name file
 * @brief input file
 * @type std::string : "file path"
 */
file:
	stmts
	| file stmts												{
                                                                    INFO("file: blocks.size=" << $1.size() << " END_OF_FILE");

																	// string name;
																	// lexer::instance().get_current_infile(name);
                                                                    // lexer::instance().set_state(&PARSER);


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
    | function_call SEMI_COLON                                 {
                                                                    INFO("stmt: | function_call SEMI_COLON");
                                                                }
    | decel SEMI_COLON                                          {
                                                                    INFO("stmt: | decel SEMI_COLON");
                                                                    stringstream ss;
                                                                    ss << "// " << $decel  << ";";
                                                                    //lexer::instance().write_ostream(ss.str());
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
                                                                        //lexer::instance().write_ostream(ostrm.str());
                                                                        INFO("strm << " << FMT_FG_YELLOW << ss.str() << FMT_RESET);
                                                                    }
                                                                    else
                                                                    {
                                                                        INFO("UNDEFINED symbol");
                                                                    }
                                                                }
    | WHILE LPAREN expr RPAREN stmt                             {
                                                                    INFO("expr: | WHILE LPAREN expr RPAREN stmt");

                                                                }
    | if_expr  else_if_expr                                     {
                                                                    INFO("expr: | if_expr  else_if_expr ");
                                                                  }
    | expr QUESTION_MARK expr COLON expr                        {
                                                                    INFO("expr: | expr QUESTION_MARK expr COLON expr");
                                                                }
    | FOR LPAREN stmt stmt stmt RPAREN stmt                     {
                                                                    INFO("stmt: | FOR LPAREN stmt stmt stmt RPAREN stmt");

                                                                }
    | FOR LPAREN stmt stmt stmt RPAREN LBRACKET stmts RBRACKET  {
                                                                   INFO("stmt: | FOR LPAREN stmt stmt stmt RPAREN LBRACKET stmts RBRACKET");
                                                                }
    | BREAK                                                     {
                                                                    INFO("stmt: | BREAK");
                                                                }
    | CONTINUE                                                  {
                                                                    INFO("stmt: | CONTINUE");
                                                                }
    | GOTO LABEL                                                {
                                                                    INFO("stmts | GOTO LABEL");
                                                                }
    | SWITCH LPAREN expr RPAREN RBRACE stmts LBRACE             {

                                                                }

                                                                ;

if_expr:
    IF LPAREN expr RPAREN stmt %prec IFX                       {
                                                                    INFO("if_stmt: | IF LPAREN expr RPAREN stmt %prec IFX");
                                                               }
    | IF LPAREN expr RPAREN LBRACE stmts RBRACE                {
                                                                    INFO("if_stmt: | IF LPAREN expr RPAREN stmt else_expr");
                                                               }
                                                               ;
 else_if_expr:
    ELSEIF LPAREN expr RPAREN stmt {
                                                                    INFO("else_if_stmt: | ELSEIF LPAREN expr RPAREN stmt");
                                                                }
    | ELSEIF LPAREN expr RPAREN LBRACE stmts RBRACE             {
                                                                    INFO("else_if_stmt: | ELSEIF LPAREN expr RPAREN LBRACE stmts RBRACE");
                                                                }
    | else_if_expr else_if_expr                                    {
                                                                    INFO("else_if_stmt: | else_if_expr else_if_expr");
                                                                }
   | else_if_expr else_expr                                    {
                                                                    INFO("else_if_stmt: | else_if_expr else_expr");
                                                                }
                                                                ;
 else_expr:
    ELSE stmt                                                   {
                                                                    INFO("else_stmt: | ELSE stmt");
                                                                }
    | ELSE LBRACE stmts RBRACE                                  {
                                                                    INFO("else_stmt: | ELSE LBRACE stmts RBRACE");
                                                                }
                                                                ;


cases:
    case                                                        {
                                                                    INFO("cases: | case")
                                                                }
    | cases case                                                {
                                                                    INFO("cases: | cases case");
                                                                }
                                                                ;
case:
    CASE NUMERIC_LITERAL                                        {
                                                                    INFO("case: CASE NUMERIC_LITERAL");
                                                                }
                                                                ;

/**
 * @name expr
 * @brief Numerical / logical exprssions
 */
expr[result]:
	rval
	                                                 			{
																	INFO("expr: | rval");
                                                                    //$result = $operand;
																}

   | NUMERIC_LITERAL                                              {
                                                                    INFO("expr: | NUMERIC_LITERAL");
                                                                    //$result = $operand;
                                                                }
   | expr[lhs] INC[op]                                              {
                                                                    INFO("expr: | expr INC");
                                                                    stringstream result;
                                                                    result << (std::atoi($lhs.c_str()) + 1);
                                                                    $result = result.str();
                                                                    INFO("$result=" << $result);
                                                                }
    | DASH expr %prec UMINUS                                     {
                                                                    INFO("expr: | DASH expr %prec UMINUS");
                                                                    stringstream result;
                                                                    result << -std::atoi($expr.c_str());
                                                                    $result = result.str();
                                                                    INFO("$result=" << $result);
                                                                 }
    | expr[lhs] ADD[op] expr[rhs]                               {
																	INFO("PARSER expr: | expr ADD expr");
																	stringstream result;
                                                                    result << (std::atoi($lhs.c_str()) + std::atoi($rhs.c_str()));
                                                                    $result = result.str();
                                                                   }
    | expr[lhs] DASH[op] expr[rhs]                               {
																	INFO("PARSER expr: | expr DASH expr");
																	stringstream result;
                                                                    result << (std::atoi($lhs.c_str()) + -std::atoi($rhs.c_str()));
                                                                    $result = result.str();
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
     lval LPAREN RPAREN                                  {
                                                                    INFO("function_call: IDENTIFIER LPAREN RPAREN");
                                                        }
   | lval[lhs] LPAREN params RPAREN                       		{
                                                                    INFO("function_call: IDENTIFIER[lhs] LPAREN params RPAREN");
                                                                }
                                                                ;
/**
 * @name function_decel
 */
function_decel:
    decel LPAREN RPAREN                                         {
                                                                    INFO("function_decel: | decl LPAREN_FUNC RPAREN");
                                                                }
    | decel func_param_decels                                   {
                                                                    INFO("function_decel: intregal_type[type] IDENTIFIER[lhs] params_decel_list");
                                                                }
                                                                ;
/**
 * @name pramas_list
 */
params_list:
	LBRACE params RBRACE                                       {
                                                                    INFO("params_list: LBRACKET params RBRACKET");
                                                               }
                                                                ;
/**
 * @name params
 */
params[params]:
    expr                                                        {
                                                                    INFO("params: expr");
                                                                }
    | params[list] COMMA expr                                   {
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
    lval ASSIGN expr                                           {
                                                                    INFO("assign_expr: IDENTIFIER ASSIGN expr");
                                                                    std::pair<std::string, std::string> p = { $1, $3 };
                                                                    $$ = p;
                                                                }
                                                                ;

decel_void:
    modifiers void_type lval                                       {
																	INFO("decel_numeric: | modifiers numeric_type IDENTIFIER");
																	_symbol_t sym = { $3, $2, eINT, 0 }; // new symbol, unassigned!
                                                                   	_symtab[$3] = sym;                      // add to symbol table, unassigned!
																	 stringstream ss;
                                                                	ss << "type<" << "INT" << "> " << "id<" << $3 << ">";
                                                                    $$ = ss.str();

                                                                    stringstream ostrm;
                                                                    ostrm << "INT" << " " << $3 << ";\n";
																	INFO("strm << " << FMT_FG_YELLOW << ss.str() << FMT_RESET);
																}
																;
 /**
 * @name decel
 * @brief decelration
 */
decel:
    modifiers value_type lval                           		{
																	INFO("decel: | modifiers intregal_type IDENTIFIER");
																		_symbol_t sym = { $3, $2, eINT, 0 }; // new symbol, unassigned!
																		_symtab[$3] = sym;                      // add to symbol table, unassigned!

																		stringstream ss;
																		ss << "type<" << "INT" << "> " << "id<" << $3 << ">";
																	$decel = ss.str();

																	stringstream ostrm;
																	ostrm << "INT" << " " << $3 << ";\n";
																}
    | decel LBRACKET rval RBRACKET                    			{
																	INFO("decel: | decel LBRACKET NUMERIC_LITERAL RBRACKET");
																}
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
* @name lval
*/
lval:
	IDENTIFIER
	;
/**
* @name rval
*/
rval:
	IDENTIFIER
	| NUMERIC_LITERAL
	;
/**
* @name value_type
*/
value_type:
	CHAR
	| SHORT
	| INT
	| LONG
	;
/**
 * @name void_type
 */
void_type:
    FLOAT                                                       { INFO("intergal_type: | FLOAT"); $$="FLOAT"; }
    | CHAR                                                      { INFO("intergal_type: | CHAR");  $$="CHAR"; }
    | STRING                                                    { INFO("intergal_type: | STRING"); /*$$=STRING;*/ }
    | VOID                                                      { INFO("intergal_type: | VOID"); /*$$=VOID;*/ }
    | SINGLE                                                    { INFO("intergal_type: | SINGLE"); /*$$=SINGLE;*/ }
    | DOUBLE                                                    { INFO("intergal_type: | DOUBLE"); $$="DOUBLE"; }
                                                                ;
// storage_class_specifier
// 	: TYPEDEF	/* identifiers must be flagged as TYPEDEF_NAME */
// 	| EXTERN
// 	| STATIC
// 	| THREAD_LOCAL
// 	| AUTO
// 	| REGISTER
// 	;

//     type_specifier
// 	: VOID
// 	| CHAR
// 	| SHORT
// 	| INT
// 	| LONG
// 	| FLOAT
// 	| DOUBLE
// 	| SIGNED
// 	| UNSIGNED
// 	| BOOL
// 	| COMPLEX
// 	| IMAGINARY	  	/* non-mandated extension */
// 	| atomic_type_specifier
// 	| struct_or_union_specifier
// 	| enum_specifier
// 	| TYPEDEF_NAME		/* after it has been defined as such */
// 	;

// atomic_type_specifier
// 	: ATOMIC '(' type_name ')'
// 	;

// type_qualifier
// 	: CONST
// 	| RESTRICT
// 	| VOLATILE
// 	| ATOMIC
// 	;

// function_specifier
// 	: INLINE
// 	| NORETURN
// 	;
%%

#include "table.hpp"
#undef PARSER_LOG

//typedef std::string stmt_t;
//typedef std::vector< std::string > stmts_t;
typedef std::string param_t;
typedef std::vector<param_t> params_t;
typedef std::string arg_t;
typedef std::vector<arg_t> args_t;

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

typedef struct mytype
{
    int i;
} mytype;


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
