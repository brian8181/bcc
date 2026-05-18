/**
 * @file    lexer.hpp
 * @version 0.0.1
 * @date    Fri, 26 Sep 2025 17:05:10
 */
#ifndef _DEFINITIONS_HPP_
#define _DEFINITIONS_HPP_

#ifdef _MSC_VER
#define forceinline __forceinline
#elif defined(__GNUC__)
#define forceinline inline __attribute__((__always_inline__))
#elif defined(__CLANG__)
#if __has_attribute(__always_inline__)
#define forceinline inline __attribute__((__always_inline__))
#else
#define forceinline inline
#endif
#else
#define forceinline inline
#endif

#include <iostream>
#include <iterator>
#include <map>
#include <stack>
#include <fstream>
#include <sstream>
#include <string>
#include <utility>
#include <vector>
#include <iomanip>
#include <boost/regex.hpp>
#include "pparser.tab.hpp"

using std::list;
using std::map;
using std::fstream;
using std::pair;
using std::string;
using std::stringstream;
using std::vector;
using yy::parser;

const string VALID_SYMBOL_CHARS = R"([A-Za-z0-9_])";  /** @note_to_self: ~~> \w == [A-Za-z0-9_] **/
const string VALID_CHARS        = R"([[:punct:][:alnum:]])"; // [:punct:] = !"#$%&'()*+,-./:;<=>?@[\]^_{|}~`);
const string CONFIG_STATES      = R"((?<states>^\s*(?<state>[A-Za-z][A-Za-z0-9_]*)\s*=\s*\s*\{(?<tokens>[A-Za-z][A-Za-z0-9_]*(, [A-Za-z][A-Za-z0-9_]*)*)\}\s*\s*$))";
const string CONFIG_SECTIONS    = R"(^\s*\[\s*(?<tokens>tokens)|(?<groups>groups)|(?<states>states)\s*\]\s*$)";
const string CONFIG_PAIR        = R"(\s*(?<type>" + TOKEN_TYPE_ + ")\\s+(?<name>[A-Za-z])" + VALID_SYMBOL_CHARS + R"("*)\\s*=\\s*(?<rexp>)" + VALID_CHARS + R"(*)\s*\"(?<test>.*)\"\s*)";
const string CONFIG_COMMENT     = R"(^\s*#.*$)";
const string CONFIG 			= R"((?<pairs>)" + CONFIG_PAIR + R"()|(?<comments>)" + CONFIG_COMMENT + R"())";
const string qwerty 			= R"(ABCDEFGHIJKLMNOPQRSTUVWXYZabcefghijklmnopqrstuvwxyz1234567890~!@#$%^&*()_+{}|:"<>?`-=[]\;',./')";

struct if_stmt
{
	bool _if;
	char* _then;
	char* _else;
};

struct block
{
	vector<string> src;
};

typedef struct token_t
{
	string name;
	string stype;
	string rexp;
	unsigned long index;
} token_t;

typedef struct state_t
{
	unsigned long id;
	string name;
} state_t;

typedef token_t token;
typedef parser::token_type yytoken;
typedef parser::symbol_type yysymbol;
inline auto SKIP_TOKEN = yysymbol( yytoken::SKIP_TOKEN ).kind();

/**
 * @brief token definitions : unsigned long integers
 */
#define PRINT                     88
#define ADD 					  89   
#define SUB 					  90   
#define MUL 					  91   
#define DIV 					  92   
#define MOD 					  93   
#define LPAREN 				      94   
#define RPAREN 				      95   
#define LBRACE 				      96   
#define RBRACE 				      97   
#define LBRACKET 				  98   
#define RBRACKET 				  99   
#define BIT_AND 				 100   
#define BIT_NOT 				 101   
#define BIT_OR 				     102   
#define BIT_XOR 				 103   
#define LSHIFT  				 104   
#define RSHIFT  				 105   
#define AND 					 106   
#define OR 					     107   
#define NOT 					 108   
#define EQ 					     109   
#define LESS_THAN 			     110   
#define GREATER_THAN 			 111   
#define GREATER_THAN_EQUAL 	     112   
#define LESS_THAN_EQUAL 		 113   
#define NUMERIC_LITERAL 		 114   
#define REAL_LITERAL   		     115   
#define STRING_LITERAL 		     116   
#define HEXADECIMAL_LITERAL 	 117   
#define OCTAL_DECIMAL_LITERAL    118 
#define CHAR_LITERAL             1118
#define IF 					     119   
#define ELSE 					 120   
#define ELSEIF 				     121   
#define DO 					     122   
#define WHILE 				     123   
#define SWITCH				     124   
#define CASE 					 125   
#define DEFAULT 				 126   
#define BREAK 				     127   
#define CONTINUE 				 128   
#define TRY 					 129   
#define CATCH 				     130   
#define IDENTIFIER 			     131   
#define ARRAY 				     132   
#define COMMENT 				 133   
#define INDIRECT_MEMBER 		 134   
#define SHORT               	 135   
#define INT					     136   
#define LONG					 137   
#define SINGLE              	 138   
#define FLOAT					 139   
#define DOUBLE				     140   
#define CHAR					 141   
#define VOID                	 142   
#define UNSIGNED				 143   
#define SIGNED				     144   
#define PTR					     145   
#define REF					     146   
#define STRUCT				     147   
#define TYPEDEF				     148   
#define FUNCTION				 149   
#define ASSIGN              	 150   
#define _IF					     151   
#define _INCLUDE            	 152   
#define _DEFINE             	 153   
#define _IFDEF              	 154   
#define _IFNDEF	                 155   
#define _ENDIF              	 156   
#define _ELSE               	 157   
#define _ELSEIF             	 158   
#define DOT 					 159   
#define QUESTION_MARK 		     160   
#define BACKSLASH 			     161   
#define UNDERSCORE 			     162   
#define COMMA 				     163   
#define COLON 				     164   
#define SEMI_COLON 			     165   
#define DOUBLE_QUOTE 			 166   
#define SINGLE_QUOTE 			 167   
#define ESC_SEQ      			 168   
#define ESC_NLINE           	 169   
#define ESC_BACKSLASH       	 170   
#define ESC_NEWLINE 			 171   
#define ESC_DOUBLE_QUOTE 		 172   
#define ESC_SINGLE_QUOTE 		 173   
#define ESC_TAB 				 174   
#define END_OF_FILE   		     175   
#define END_OF_FILES   		     176   
#define WHITESPACE 			     177   
#define NEWLINE 				 178   
#define SKIP_TOK 				 179   
#define UNDEFINED 			     180   
#define TEST_TOKEN          	 181   
#define S_TYPE "string"


#define R_TILDE 	   R"(~)"
#define R_EXCLAMATION  R"(!)"
#define R_NUMERIC_LITERAL R"([1-9]+[0-9]*|0)"
#define R_REAL_LITERAL R"(([0-9]+\.[0-9]*|[0-9]*\.[0-9]+)([eE][-+]?[0-9]+)?)"
#define R_VALID_ID     R"([A-Za-z_][A-Za-z0-9_]*)"
#define R_ARRAY        R"(\$[A-Za-z_][A-Za-z0-9_]*\[[^\]]\])"
#define R_SYMBOL       R"(\$[A-Za-z_][A-Za-z0-9_]*)"
#define R_CONST_SYMBOL R"(#[A-Za-z_][A-Za-z0-9_]*#)"

/**
 * @name g_tokens
 * @brief global token vector - all tokens
 */
inline map<unsigned long, token> g_tokens =
{
	{TEST_TOKEN,	    token{"TEST_TOKEN", S_TYPE, R"(@@@)", __LINE__}},
	{PRINT,	    		token{"PRINT", S_TYPE, R"(PRINT)", __LINE__}},
	{ESC_SEQ,	        token{"ESC_SEQ", S_TYPE, R"(\\[^\n])", __LINE__}},
	{ESC_NLINE,	        token{"ESC_NLINE", S_TYPE, R"([^\\\n])", __LINE__}},
	{WHITESPACE, 		token{"WHITESPACE", S_TYPE, R"([ \t\r])", __LINE__}},
	{NEWLINE,           token{"NEWLINE", S_TYPE, R"(\n)", __LINE__}},
	{NUMERIC_LITERAL,   token{"NUMERIC_LITERAL", S_TYPE, R_NUMERIC_LITERAL, __LINE__}},
	{REAL_LITERAL,      token{"REAL_LITERAL", S_TYPE, R"([0-9]+\.[0-9]+)", __LINE__}},
	{STRING_LITERAL,    token{"STRING_LITERAL", S_TYPE, R"("[A-Za-z0-9*@_.~+-/ ]+")", __LINE__}},
	{CHAR_LITERAL,      token{"CHAR_LITERAL", S_TYPE, R"("'.'")", __LINE__}},
	{IDENTIFIER,        token{"IDENTIFIER", S_TYPE, R"([A-Za-z_][A-Za-z0-9_]*)", __LINE__}},
	{COMMENT,           token{"COMMENT", S_TYPE, R"(\{[ ]*\*[^*}]*\*[ ]*\})", __LINE__}},
	{DOUBLE_QUOTE,      token{"DOUBLE_QUOTE", S_TYPE, R"(")", __LINE__}},
	{SUB,             	token{"SUB", S_TYPE, R"([-])", __LINE__}},
	{ADD,              	token{"ADD", S_TYPE, R"([+])", __LINE__}},
	{MUL,          		token{"MUL", S_TYPE, R"([*])", __LINE__}},
	{DIV,            	token{"DIV", S_TYPE, R"([/])", __LINE__}},
	{MOD,           	token{"MOD", S_TYPE, R"([%])", __LINE__}},
	{ASSIGN,            token{"ASSIGN", S_TYPE, R"([=])", __LINE__}},
	{LPAREN,            token{"LPAREN", S_TYPE, "[(]", __LINE__}},
	{RPAREN,            token{"RPAREN", S_TYPE, "[)]", __LINE__}},
	{LBRACKET,          token{"LBRACKET", S_TYPE, R"(\[)", __LINE__}},
	{RBRACKET,          token{"RBRACKET", S_TYPE, R"(\])", __LINE__}},
	{LBRACE,            token{"LBRACE", S_TYPE, R"([{])", __LINE__}},
	{RBRACE,            token{"RBRACE", S_TYPE, R"([}])", __LINE__}},
	{BACKSLASH,         token{"BACKSLASH", S_TYPE, R"([\])", __LINE__}},
	{COLON,             token{"COLON", S_TYPE, R"([:])", __LINE__}},
	{SEMI_COLON,        token{"SEMI_COLON", S_TYPE, R"([;])", __LINE__}},
	{SINGLE_QUOTE,      token{"SINGLE_QUOTE", S_TYPE, R"(['])", __LINE__}},
	{GREATER_THAN,      token{"GREATER_THAN", S_TYPE, R"([>])", __LINE__}},
	{QUESTION_MARK,     token{"QUESTION_MARK", S_TYPE, R"([?])", __LINE__}},
	{COMMA,             token{"COMMA", S_TYPE, R"([,])", __LINE__}},
	{DOT,               token{"DOT", S_TYPE, R"(\.)", __LINE__}},
	{GREATER_THAN_EQUAL,token{"GREATER_THAN_EQUAL", S_TYPE, R"(>=)", __LINE__}},
	{LESS_THAN_EQUAL,   token{"LESS_THAN_EQUAL", S_TYPE, R"(<=)", __LINE__}},
	{AND,               token{"AND", S_TYPE, R"(&&)", __LINE__}},
	{OR,                token{"OR", S_TYPE, R"(\|\|)", __LINE__}},
	{NOT,               token{"NOT", S_TYPE, R"([!])", __LINE__}},
	{EQ,                token{"EQ", S_TYPE, R"(==)", __LINE__}},
	{BIT_AND,           token{"BIT_AND", S_TYPE, R"(&)", __LINE__}},
	{BIT_OR,            token{"BIT_OR", S_TYPE, R"([|])", __LINE__}},
	{BIT_NOT,           token{"BIT_NOT", S_TYPE, R"([~])", __LINE__}},
	{BIT_XOR,           token{"BIT_XOR", S_TYPE, R"([^])", __LINE__}},
	{LSHIFT,            token{"LSHIFT", S_TYPE, R"([<]{2})", __LINE__}},
	{RSHIFT,            token{"RSHIFT", S_TYPE, R"([>]{2})", __LINE__}},
	{IF,                token{"IF", S_TYPE, R"(if)", __LINE__}},
	{ELSE,              token{"ELSE", S_TYPE, R"(else)", __LINE__}},
	{ELSEIF,            token{"ELSEIF", S_TYPE, R"(elseif)", __LINE__}},
	{WHILE,             token{"WHILE", S_TYPE, R"(while)", __LINE__}},
	{BREAK,             token{"BREAK", S_TYPE, R"(break)", __LINE__}},
	{PTR,               token{"PTR", S_TYPE, R"([*])", __LINE__}},
	{REF,               token{"REF", S_TYPE, R"([&])", __LINE__}},
	{INT,               token{"INT", S_TYPE, R"(\s*\<int\>\s+)", __LINE__}},
	{FLOAT,             token{"FLOAT", S_TYPE, R"(\s*\<float\>\s+)", __LINE__}},
	{CHAR,              token{"CHAR", S_TYPE, R"(\s*\<char\>\s+)", __LINE__}},
	{VOID,              token{"VOID", S_TYPE, R"(\s*\<void\>\s+)", __LINE__}},
	{STRUCT,            token{"STRUCT", S_TYPE, R"(\s*\<struct\>\s+)", __LINE__}},
	{TYPEDEF,           token{"TYPEDEF", S_TYPE, R"(\s*\<tyedef\>\s+)", __LINE__}},
	{_IF,               token{"_IF", S_TYPE, R"((#if|#IF)\>\s+)", __LINE__}},
	{_DEFINE,           token{"_DEFINE", S_TYPE, R"((#define|#DEFINE)\>\s+)", __LINE__}},
	{_IFDEF,            token{"_IFDEF", S_TYPE, R"((#ifdef|#IFDEF)\>\s+)", __LINE__}},
	{_IFNDEF,           token{"_IFNDEF", S_TYPE, R"((#ifndef|#IFNDEF)\>\s+)", __LINE__}},
	{_ELSE,             token{"_ELSE", S_TYPE, R"((#else|#ELSE)\>\s+)", __LINE__}},
	{_ELSEIF,           token{"_ELSEIF", S_TYPE, R"((#elseif|#ELSEIF)\>\s+)", __LINE__}},
	{_ENDIF,            token{"_ENDIF", S_TYPE, R"((#endif|#ENDIF)\>\s+)", __LINE__}},
	{_INCLUDE,          token{"_INCLUDE", S_TYPE, R"(#include\>\s)", __LINE__}}
};

/**
 * @brief unsigned long states
 */
constexpr unsigned long UL_INITIAL = 0x10;

/**
 * @brief global state IDs
 */
inline vector<unsigned long> state_ids = { UL_INITIAL };

/**
 * @brief state_t states
 */

inline state_t INITIAL = { UL_INITIAL, "INITIAL" };

/**
 * @brief global state vector
 */
inline vector<state_t> states__ = { INITIAL };

/**
 * @brief token list -> by state
 */
inline vector<unsigned long> INITIAL_TOKENS = {  TEST_TOKEN, PRINT, INT, FLOAT, CHAR, VOID, SEMI_COLON, EQ, ASSIGN, _INCLUDE, 
												 NEWLINE, WHITESPACE, CHAR_LITERAL, STRING_LITERAL, NUMERIC_LITERAL, REAL_LITERAL, IDENTIFIER,
												 MUL, DIV, SUB, ADD, MOD, LPAREN, RPAREN, LBRACE, RBRACE, 
												 OR, AND, NOT, BIT_OR, BIT_XOR, BIT_AND, BIT_NOT, RSHIFT, LSHIFT,
												STRUCT, TYPEDEF };
/**
 * @brief global state: state_id -> states
 * @name g_tokens_by_state_id
 */
inline map<unsigned long, vector<unsigned long>*> g_state_tokens {  {UL_INITIAL, &INITIAL_TOKENS} };
/**
 *
 */

typedef unsigned long type_t;
typedef unsigned long terminal_t;
typedef vector<terminal_t> terminals_t;
typedef vector<type_t> types_t;

#endif
