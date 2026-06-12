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

    #define exp_info(op, lhs, rhs, result) lhs << " " << op << " " << rhs << " = " << result

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


%token SKIP_TOKEN UNDEFINED conditional_expression pointer direct_declarator
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
%token TYPEDEF_NAME

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
%token EXTERN
%token UNION
%token RESTRICT

%token CONST VOLATILE STATIC
%token UNSIGNED SIGNED LONG REGISTER SHORT
%token INT FLOAT CHAR VOID STRING DOUBLE SINGLE

%token <std::string> INDIRECT_MEMBER

%token BACKSLASH QUESTION_MARK COLON SEMI_COLON DOUBLE_QUOTE SINGLE_QUOTE
%token COMMA LBRACKET RBRACKET LBRACE RBRACE DOT PTR ASTERICK
%token	ALIGNAS ALIGNOF ATOMIC GENERIC NORETURN STATIC_ASSERT THREAD_LOCAL INC_OP DEC_OP SIZEOF
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
%type compound_statement
%type atomic_type_specifier type_qualifier function_specifier constant_expression enumeration_constant 
%type unary_expression unary_operator cast_expression multiplicative_expression additive_expression pointer direct_declarator
%type struct_or_union_specifier struct_or_union struct_declaration_list struct_declaration specifier_qualifier_list struct_declarator_list struct_declarator
%type declarator 
%type <std::string> storage_class_specifier type_modifier modifiers 
%type <std::string> numeric_type initial_value
%type <std::string> lval rval type_specifier decel_void
%type <std::string> decel decel_numeric func_param_decels decel_list function_decel function_call function_def
%type <std::string> compiler
%start compiler

%%
/**
 * @name complier
 */
compiler:
        file  END_OF_FILE                                         {
																	INFO("compiler: files.size=" << $1.size() << " END_OF_FILE");
																	cout << "processed files ..." << endl;
																	int len = $1.size();
																	for(int i = 0; i < len; ++i)
																	{
																		cout << $1[i] << endl;
																	}

                                                                    cout << FMT_FG_DARK_GREY << "compiler: file END_OF_FILE" << endl;
                                                                    cout << FMT_FG_DARK_GREY << "*********************** STOPPING **********************" << FMT_RESET << endl;
                                                                    cout << FMT_FG_DARK_GREY << "*                     Terminating.                    *" << FMT_RESET << endl;
                                                                    cout << FMT_FG_DARK_GREY << "************************* Done ************************" << FMT_RESET << endl;
																	SYST("system halting ...");
																	//std::exit(0);
                                                                }
                                                                ;
/**
 * @name file
 * @brief input file
 * @type std::string : "file path"
 */
file:
	stmts                                                       {
                                                                    INFO("file: stmts");
                                                                }
	| file stmts												{
                                                                    INFO("file: file stmts");
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
                                                                    INFO("stmts: stmt");
                                                                    $result.push_back($lhs);
                                                                }
    | stmts[lhs] stmt[rhs]			                            {
																	INFO("stmts: stmts stmt");
																	$lhs.push_back($rhs);
																	$result = $lhs;
																}
                                                                ;
compound_statement:
            LBRACE stmts RBRACE                                 {

                                                                }
                                                                ;
                                                                
enumeration_constant		/* before it has been defined as such */
	: IDENTIFIER
	;

unary_expression:
	//: postfix_expression
	| INC_OP unary_expression
	| DEC_OP unary_expression
	| unary_operator cast_expression
	| SIZEOF unary_expression
	//| SIZEOF '(' type_name ')'
	//| ALIGNOF '(' type_name ')'
	;

unary_operator:
 '&'
	| '*'
	| '+'
	| '-'
	| '~'
	| '!'
	;

cast_expression:
    unary_expression
	//| '(' type_name ')' cast_expression
	;

multiplicative_expression:
	cast_expression
	| multiplicative_expression '*' cast_expression
	| multiplicative_expression '/' cast_expression
	| multiplicative_expression '%' cast_expression
	;

additive_expression:
	multiplicative_expression
	| additive_expression '+' multiplicative_expression
	| additive_expression '-' multiplicative_expression
	;


/**
 * @name stmt
 * @brief statement
 */
stmt:
    expr  SEMI_COLON                                            {
                                                                    INFO("stmt: expr SEMI_COLON");
                                                                    INFO("stmt: expr=" << $expr << " SEMI_COLON");
                                                                    WARN("expr: not an l-side");
                                                                }
    | function_decel compound_statement                         {
                                                                     INFO("stmt: function_decel compound_statement"); 
                                                                }                                                              
    | function_call SEMI_COLON                                  {
                                                                    INFO("stmt: function_call SEMI_COLON");
                                                                }
    | decel SEMI_COLON                                          {
                                                                    INFO("stmt: decel SEMI_COLON");
                                                                    stringstream ss;
                                                                    ss << "// " << $decel  << ";";
                                                                    INFO("strm << " << FMT_FG_YELLOW << ss.str() << FMT_RESET);
                                                                }
    | IDENTIFIER LBRACKET NUMERIC_LITERAL RBRACKET ASSIGN expr SEMI_COLON   {

                                                                    INFO("stmt: IDENTIFIER LBRACKET NUMERIC_LITERAL RBRACKET ASSIGN expr SEMI_COLON");
                                                                }
    | function_decel SEMI_COLON                                 {
                                                                    INFO("stmt: function_decel SEMI_COLON");
                                                                }
    | decel ASSIGN expr SEMI_COLON                               {
                                                                    INFO("stmt: decel ASSIGN expr SEMI_COLON");
                                                                    _symtab[$decel].val = new int(std::atoi($expr.c_str()));
                                                                    stringstream ss;
                                                                    ss << "// " << $decel << " = " << $expr << ";";
                                                                    INFO("strm << " << FMT_FG_YELLOW << ss.str() << FMT_RESET);
                                                                }
    | decel ASSIGN params_list SEMI_COLON                       {
                                                                    INFO("stmt: decel ASSIGN params_list SEMI_COLON");
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
                                                                    INFO("expr: WHILE LPAREN expr RPAREN stmt");

                                                                }
    | if_expr                                                   {
                                                                    INFO("stmt: if_expr");
                                                                }
    | if_expr  else_if_expr                                     {
                                                                    INFO("stmt: if_expr  else_if_expr ");
                                                                }
    | expr QUESTION_MARK expr COLON expr                        {
                                                                    INFO("expr: expr QUESTION_MARK expr COLON expr");
                                                                }
    | FOR LPAREN stmt stmt stmt RPAREN stmt                     {
                                                                    INFO("stmt: FOR LPAREN stmt stmt stmt RPAREN stmt");

                                                                }
    | FOR LPAREN stmt stmt stmt RPAREN compound_statement       {
                                                                   INFO("stmt: FOR LPAREN stmt stmt stmt RPAREN compound_statement");
                                                                }
    | BREAK                                                     {
                                                                    INFO("stmt: BREAK");
                                                                }
    | CONTINUE                                                  {
                                                                    INFO("stmt: CONTINUE");
                                                                }
    | GOTO LABEL                                                {
                                                                    INFO("stmts | GOTO LABEL");
                                                                }
    | SWITCH LPAREN expr RPAREN compound_statement              {
                                                                    INFO("stmts | SWITCH LPAREN expr RPAREN compound_statement");
                                                                }

                                                                ;

if_expr:
    IF LPAREN expr RPAREN stmt %prec IFX                       {
                                                                    INFO("if_stmt: IF LPAREN expr RPAREN stmt %prec IFX");
                                                               }
    | IF LPAREN expr RPAREN compound_statement                 {
                                                                    INFO("if_stmt: IF LPAREN expr RPAREN compound_statement");
                                                               }
                                                               ;
 else_if_expr:
    ELSEIF LPAREN expr RPAREN stmt                              {
                                                                    INFO("else_if_stmt: ELSEIF LPAREN expr RPAREN stmt");
                                                                }
    | ELSEIF LPAREN expr RPAREN compound_statement              {
                                                                    INFO("else_if_stmt: ELSEIF LPAREN expr RPAREN compound_statement");
                                                                }
    | else_if_expr else_if_expr                                 {
                                                                    INFO("else_if_stmt: else_if_expr else_if_expr");
                                                                }
   | else_if_expr else_expr                                     {
                                                                    INFO("else_if_stmt: else_if_expr else_expr");
                                                                }
                                                                ;
 else_expr:
    ELSE stmt                                                   {
                                                                    INFO("else_stmt: ELSE stmt");
                                                                }
    | ELSE compound_statement                                   {
                                                                    INFO("else_stmt: ELSE compound_statement");
                                                                }
                                                                ;
cases:
    case                                                        {
                                                                    INFO("cases: case")
                                                                }
    | cases case                                                {
                                                                    INFO("cases: cases case");
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
																	INFO("expr: rval" << FMT_FG_WHITE << "(" << $1 << ")" << FMT_RESET);
                                                                    //$result = $operand;
																}

   | NUMERIC_LITERAL                                            {
                                                                    INFO("expr: NUMERIC_LITERAL" << FMT_FG_WHITE << "(" << $1 << ")" << FMT_RESET);
                                                                    //$result = $operand;
                                                                }
   | expr[lhs] INC[op]                                          {
                                                                    INFO("expr: expr INC");
                                                                    stringstream result;
                                                                    result << (std::atoi($lhs.c_str()) + 1);
                                                                    $result = result.str();
                                                                    INFO("$result=" << $result);
                                                                    INFO(exp_info("", "lhs", "++", $$));
                                                                }
    | DASH expr %prec UMINUS                                    {
                                                                    INFO("expr: DASH expr %prec UMINUS");
                                                                    stringstream result;
                                                                    result << -std::atoi($expr.c_str());
                                                                    $result = result.str();
                                                                    INFO("$result=" << $result);
                                                                    //INFO(exp_info("%", $lhs, $rhs, $$));
                                                                }
    | expr[lhs] ADD[op] expr[rhs]                               {
																	INFO("expr: expr ADD expr");
																	stringstream result;
                                                                    result << (std::atoi($lhs.c_str()) + std::atoi($rhs.c_str()));
                                                                    $result = result.str();
                                                                }
    | expr[lhs] DASH[op] expr[rhs]                              {
																	INFO("expr: expr DASH expr");
																	stringstream result;
                                                                    result << (std::atoi($lhs.c_str()) + -std::atoi($rhs.c_str()));
                                                                    $result = result.str();
                                                            	}
    | expr[lhs] MUL[op] expr[rhs]                               {
																	INFO("expr: expr MUL expr");
																	stringstream ss;
                                                                    ss << (std::atoi($lhs.c_str()) * std::atoi($rhs.c_str()));
                                                                    $result = ss.str();
                                                                    INFO(exp_info("*", $1, $3, $$));
																}
    | expr[lhs] DIV[op] expr[rhs]                               {
																	INFO("expr: expr DIV expr");
																	stringstream ss;
                                                                    ss << (std::atoi($lhs.c_str()) / std::atoi($rhs.c_str()));
                                                                    $result = ss.str();
                                                                    INFO(exp_info("/", $1, $3, $$));
																}
    | expr[lhs] MOD[op] expr[rhs]                               {
																	INFO("expr: expr MOD expr");
																	stringstream ss;
                                                                    ss << (std::atoi($lhs.c_str()) % std::atoi($rhs.c_str()));
                                                                    $result = ss.str();
                                                                    INFO(exp_info("%", $1, $3, $$));
																}
    | expr[lhs] EQ[op] expr[rhs]                                {
																	INFO(" expr: expr EQ expr");
																	$result = (std::atoi($lhs.c_str()) == std::atoi($rhs.c_str()));
                                                                    // string r = $lhs + " " $op + " " + $rhs + " = ";
                                                                    // INFO(r << $result);
                                                                    INFO(exp_info("==", $1, $3, $$));
																}
    | expr[lhs] NEQ[op] expr[rhs]                               {
																	INFO("expr: expr NEQ expr");
																	$result = (std::atoi($lhs.c_str()) != std::atoi($rhs.c_str()));
                                                                    INFO($lhs << "-" << $rhs << "=" << $result);
                                                                    INFO(exp_info("!=", $1, $3, $$));
																}
    | expr[lhs] LT[op] expr[rhs]                                {
																	INFO("expr expr LT expr");
																	$result = (std::atoi($lhs.c_str()) < std::atoi($rhs.c_str()));
                                                                    INFO("$result=" << $result);
                                                                    INFO(exp_info("<", $1, $3, $$));
																}
    | expr[lhs] GT[op] expr[rhs]                                {
																	INFO("expr: expr GT expr");
																	$result = (std::atoi($lhs.c_str()) > std::atoi($rhs.c_str()));
                                                                    INFO(exp_info(">", $1, $3, $$));
																}
    | expr[lhs] GEQ[op] expr[rhs]                               {
																	INFO("expr: expr GEQ expr ");
																	$result = (std::atoi($lhs.c_str()) >= std::atoi($rhs.c_str()));
                                                                    INFO(exp_info(">=", $1, $3, $$));
																}
    | expr[lhs] LEQ[op] expr[rhs]                               {
																	INFO("expr: expr LEQ expr");
																	$result = (std::atoi($lhs.c_str()) <= std::atoi($rhs.c_str()));
                                                                    INFO(exp_info("<=", $1, $3, $$));
																}
    | expr[lhs] AND[op] expr[rhs]                               {
																	INFO("expr: expr AND expr");
																	$result = (std::atoi($lhs.c_str()) && std::atoi($rhs.c_str()));
                                                                    INFO(exp_info("&&", $1, $3, $$));
																}
    | expr[lhs] OR[op] expr[rhs]                                {
																	INFO("expr: expr OR expr");
																	$result = (std::atoi($lhs.c_str()) || std::atoi($rhs.c_str()));
                                                                    INFO(exp_info("||", $1, $3, $$));
																}
    | NOT expr[lhs]                                             {
																	INFO("expr: NOT expr");
																	$result = !(std::atoi($lhs.c_str()));
                                                                    INFO(exp_info("!", "!", $lhs, $$));
																}
    | expr[lhs] RSHIFT[op] expr[rhs]                            {
																	INFO("expr: expr RSHIFT expr");
																	$result = (std::atoi($lhs.c_str()) >> std::atoi($rhs.c_str()));
                                                                    INFO(exp_info(">>", $lhs, $rhs, $$));
																}
    | expr[lhs] LSHIFT[op] expr[rhs]                            {
																	INFO("expr: expr LSHIFT expr");
																	$result = (std::atoi($lhs.c_str()) << std::atoi($rhs.c_str()));
                                                                    INFO(exp_info("<<", $lhs, $rhs, $$));
																}
    | expr[lhs] BIT_AND[op] expr[rhs]                           {
																	INFO("expr: expr BIT_AND expr");
																	$result = (std::atoi($lhs.c_str()) & std::atoi($rhs.c_str()));
                                                                    INFO(exp_info("&", $lhs, $rhs, $$));
                                                                }
    | expr[lhs] BIT_OR[op] expr[rhs]                            {
																	INFO("expr: expr BIT_OR expr");
																	$result = (std::atoi($lhs.c_str()) | std::atoi($rhs.c_str()));
                                                                    INFO(exp_info("|", $lhs, $rhs, $$));
                                                                }
     | expr[lhs] BIT_XOR[op] expr[rhs]                          {
																	INFO("expr: expr BIT_XOR expr");
																	$result = (std::atoi($lhs.c_str()) ^ std::atoi($rhs.c_str()));
                                                                    INFO(exp_info("^", $lhs, $rhs, $$));
                                                                }
    | BIT_NOT expr[lhs]                                         {
																	INFO("expr: BIT_NOT expr");
																	$result = ~(std::atoi($lhs.c_str()));
                                                                    INFO(exp_info("", "~", $lhs, $$));
                                                                }
    | LPAREN expr[exp] RPAREN                                   {
																	INFO("expr: LPAREN expr RPAREN");
                                                                    $result = $exp;
																}
                                                                ;
/**
 * @name function_call
 */
function_call:
     IDENTIFIER LPAREN RPAREN                                         {
                                                                    INFO("function_call: IDENTIFIER LPAREN RPAREN");
                                                                }
   | IDENTIFIER[lhs] LPAREN params RPAREN                       		{
                                                                    INFO("function_call: IDENTIFIER[lhs] LPAREN params RPAREN");
                                                                }
                                                                ;
/**
 * @name function_decel
 */
function_decel:
    decel LPAREN RPAREN                                         {
                                                                    INFO("function_decel: decl LPAREN RPAREN --> " << $decel << "()");
                                                                    $function_decel = $decel + "()";
                                                                }
    | decel LPAREN decel_list RPAREN                            {
                                                                    INFO("function_decel: decel LPAREN decel_list RPAREN --> " << $decel << "( " << $decel_list << " )");
                                                                    $function_decel = $decel + "( " + $decel_list + " )"; 
                                                                    //ATTN($func_decel)
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
    LPAREN decel_list RPAREN                                  {
                                                                    INFO("params_decel_list: LPAREN_FUNC params_decel RPAREN");
                                                                }
                                                                ;
/**
 * @name params_decel
 */
decel_list:
	decel                                                       {
                                                                    INFO("params_decel: decel=" << $decel);
                                                                }
	| decel_list COMMA decel                                  {
                                                                    INFO("params_decel: params_decel COMMA decel");
                                                                }
                                                                ;
/**
 * @name assign_expr
*/
assign_expr:
    IDENTIFIER ASSIGN expr                                            {
                                                                    INFO("assign_expr: IDENTIFIER ASSIGN expr");
                                                                    std::pair<std::string, std::string> p = { $1, $3 };
                                                                    $$ = p;
                                                                }
                                                                ;

decel_void:
    modifiers type_specifier IDENTIFIER                               {
																	INFO("decel_numeric: modifiers numeric_type IDENTIFIER");
																	sym_t sym = { $3, $2, eINT, 0 }; // new symbol, unassigned!
                                                                   	//_symtab[$3] = sym;                      // add to symbol table, unassigned!
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
    modifiers type_specifier IDENTIFIER                    	{
																	INFO("decel: modifiers type_specifier IDENTIFIER");
																	sym_t sym = { $3, $2, eINT, 0 }; // new symbol, unassigned!
																	//_symtab[$3] = sym;                      // add to symbol table, unassigned!

																	stringstream ss;
																	ss << "type<" << "INT" << "> " << "id<" << $3 << ">";
																	$decel = ss.str();

																	stringstream ostrm;
																	ostrm << "INT" << " " << $3 << ";\n";
																}
    |  modifiers type_specifier struct_or_union IDENTIFIER                    	{
																	INFO("decel: modifiers type_specifier IDENTIFIER");
                                                                }
    | decel LBRACKET NUMERIC_LITERAL RBRACKET                   { 
																	INFO("decel: decel LBRACKET NUMERIC_LITERAL RBRACKET");
																}
																;
/**
 * @name modifiers
 */
modifiers:
    %empty
    | modifiers type_modifier                                   { INFO("modifiers: modifiers type_modifier"); }
    | modifiers storage_class_specifier                         { INFO("modifiers: modifiers storage_class_specifier"); }
    ;
/**
 * @name type_modfier
 */
type_modifier:
    SIGNED                      { INFO("type_modifier: SIGNED"); }
    | UNSIGNED                  { INFO("type_modifier: UNSIGNED"); }
    ;

// initial_value:
//         IDENTIFIER                    { INFO("initial_value: IDENTIFIER"); }
//         | rval                  { INFO("initial_value: rval"); }
//         ;
/**
* @name IDENTIFIER
*/
lval:
	IDENTIFIER                 { INFO("lval: IDENTIFIER"); }
	;
/**
* @name rval
*/
rval:
	IDENTIFIER                { INFO("rval: IDENTIFIER"); }
	| NUMERIC_LITERAL         { INFO("rval: NUMERIC_LITERAL"); }
	;

    
constant_expression:
	conditional_expression	/* with constraints */
	;

storage_class_specifier:
    TYPEDEF	/* identifiers must be flagged as TYPEDEF_NAME */
	| EXTERN                         { INFO("storage_class_specifier: EXTERN"); }
	| STATIC                         { INFO("storage_class_specifier: STATIC"); }
    | REGISTER                       { INFO("storage_class_specifier: REGISTER"); }
	;

type_specifier:
    VOID                            { INFO("type_specfier: VOID"); }
	| CHAR                          { INFO("type_specfier: CHAR"); }
	| SHORT                         { INFO("type_specfier: SHORT"); }
	| INT                           { INFO("type_specfier: INT"); }
	| LONG                          { INFO("type_specfier: LONG"); }
	| FLOAT                         { INFO("type_specfier: FLOAT"); }
	| DOUBLE                        { INFO("type_specfier: DOUBLE"); }
	// | SIGNED                        { INFO("type_specfier: SIGNED"); }
	// | UNSIGNED                      { INFO("type_specfier: UNSIGNED"); }
    // | BOOL
	// | COMPLEX
	// | IMAGINARY	  	/* non-mandated extension */
	// | atomic_type_specifier
	| struct_or_union_specifier
	// | enum_specifier
	| TYPEDEF_NAME		/* after it has been defined as such */
	;

struct_or_union_specifier:
     struct_or_union '{' struct_declaration_list '}'
	| struct_or_union IDENTIFIER '{' struct_declaration_list '}'
	| struct_or_union IDENTIFIER
	;

struct_or_union:
    STRUCT                             { INFO("struct_or_union: STRUCT"); }
	| UNION                             { INFO("struct_or_union: UNION"); }
	;
struct_declaration_list:
     struct_declaration
	| struct_declaration_list struct_declaration
	;

struct_declaration:
 specifier_qualifier_list ';'	/* for anonymous struct/union */
	| specifier_qualifier_list struct_declarator_list ';'
	| static_assert_declaration
	;

specifier_qualifier_list:
     type_specifier specifier_qualifier_list
	| type_specifier
	| type_qualifier specifier_qualifier_list
	| type_qualifier
	;

struct_declarator_list:
     struct_declarator
	| struct_declarator_list ',' struct_declarator
	;

struct_declarator:
     ':' constant_expression
	| declarator ':' constant_expression
	| declarator
	;

static_assert_declaration:
 STATIC_ASSERT '(' constant_expression ',' STRING_LITERAL ')' ';'
	;


// atomic_type_specifier
// 	: ATOMIC '(' type_name ')'
// 	;

type_qualifier:
     CONST
	| RESTRICT
	| VOLATILE
	| ATOMIC
	;

// function_specifier
// 	: INLINE
// 	| NORETURN
// 	;

declarator:
    pointer direct_declarator
	| direct_declarator
	;
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


// string& get_expr_info(const string& op, const string& lhs, const string& rhs)
// {
//     stringstream ss;
//     ss << lhs << " " << op << " " << rhs;
//     return ss.str();
// }

// /**
// */
// bool get_value(const string& name, /*out*/ string& val)
// {
//     if(symbol_table.find(name) != symbol_table.end())
//     {
//         val = symbol_table[name];
//         return true;
//     }
//     INFO("symbol, (" << name << "), not found!");
//     return false;
// }

// /**
// */
// bool set_value(const string& name, const string& val)
// {
//     if(symbol_table.find(name) != symbol_table.end())
//     {
//         symbol_table[name] = val;
//         INFO("symbol updated: " << name << " = " << val);
//         return true;
//     }
//     INFO("symbol, (" << name << "), not found!");
//     return false;
// }

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
