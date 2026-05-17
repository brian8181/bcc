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


// openB = /\[/
// closeB = /\]/
// section = /.*?(?=[\.=\[\]\r\n])/
// equal = /=/
// whitespace = /[ \t\r]+/
// dot = /\./
// id = /[0-9]*[a-zA-Z_]\w*/
// newline = /\n/
// single_quoted_string = /'[^'\\]*(?:\\.[^'\\]*)*'(?=[ \t\r]*[\n#;])/
// double_quoted_string = /"[^"\\]*(?:\\.[^"\\]*)*"(?=[ \t\r]*[\n#;])/
// tripple_quotes = /"""/
// tripple_quotes_end = /"""(?=[ \t\r]*[\n#;])/
// text = /[\S\s]/
// float = /\d+\.\d+(?=[ \t\r]*[\n#;])/
// int = /\d+(?=[ \t\r]*[\n#;])/
// maybe_bool = /[a-zA-Z]+(?=[ \t\r]*[\n#;])/
// naked_string = /[^\n]+?(?=[ \t\r]*\n)/


const string VALID_SYMBOL_CHARS = R"([A-Za-z0-9_])";  /** @note_to_self: ~~> \w == [A-Za-z0-9_] **/
const string VALID_CHARS = R"([[:punct:][:alnum:]])"; // [:punct:] = !"#$%&'()*+,-./:;<=>?@[\]^_{|}~`);
const string CONFIG_STATES = R"((?<states>^\s*(?<state>[A-Za-z][A-Za-z0-9_]*)\s*=\s*\s*\{(?<tokens>[A-Za-z][A-Za-z0-9_]*(, [A-Za-z][A-Za-z0-9_]*)*)\}\s*\s*$))";
const string CONFIG_SECTIONS = R"(^\s*\[\s*(?<tokens>tokens)|(?<groups>groups)|(?<states>states)\s*\]\s*$)";
const string CONFIG_PAIR = R"(\s*(?<type>" + TOKEN_TYPE_ + ")\\s+(?<name>[A-Za-z])" + VALID_SYMBOL_CHARS + R"("*)\\s*=\\s*(?<rexp>)" + VALID_CHARS + R"(*)\s*\"(?<test>.*)\"\s*)";
const string CONFIG_COMMENT = R"(^\s*#.*$)";
const string CONFIG = R"((?<pairs>)" + CONFIG_PAIR + R"()|(?<comments>)" + CONFIG_COMMENT + R"())";
const string qwerty = R"(ABCDEFGHIJKLMNOPQRSTUVWXYZabcefghijklmnopqrstuvwxyz1234567890~!@#$%^&*()_+{}|:"<>?`-=[]\;',./')";

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

#define R_TILDE R"(~)"
#define R_EXCLAMATION R"(!)"
#define R_REAL_LITERAL R"(([0-9]+\.[0-9]*|[0-9]*\.[0-9]+)([eE][-+]?[0-9]+)?)"
#define R_VALID_ID     R"([A-Za-z_][A-Za-z0-9_]*)"
#define R_ARRAY        R"(\$[A-Za-z_][A-Za-z0-9_]*\[[^\]]\])"
#define R_SYMBOL       R"(\$[A-Za-z_][A-Za-z0-9_]*)"
#define R_CONST_SYMBOL R"(#[A-Za-z_][A-Za-z0-9_]*#)"

/**
 * @brief token definitions : unsigned long integers
 */
#define MOD 5510ul
#define MUL 5513ul
#define SUB 5516ul
#define UNDERSCORE 17ul
#define EQUAL_SIGN 19ul
#define PLUS 5518ul
#define ADD 5518ul
#define EQUAL 5519ul
#define LPAREN 14ul
#define RPAREN 15ul
#define LBRACE 20ul
#define RBRACE 22ul
#define LBRACKET 21ul
#define RBRACKET 23ul
#define BACKSLASH 25ul
#define COLON 26ul
#define SEMI_COLON 27ul
#define DOUBLE_QUOTE 28ul
#define SINGLE_QUOTE 29ul
#define ESC_SEQ      307ul
#define ESC_NLINE      308ul
#define ESC_BACKSLASH 301ul
#define ESC_NEWLINE 302ul
#define ESC_DOUBLE_QUOTE 303ul
#define ESC_SINGLE_QUOTE 304ul
#define ESC_TAB 305ul
#define EQUALS 306ul
#define LESS_THAN 30ul
#define COMMA 31ul
#define GREATER_THAN 32ul
#define GT 32ul
#define DOT 33ul
#define QUESTION_MARK 34ul
#define DIV    5535ul
#define BIT_AND 5555ul 
#define BIT_NOT 4ul
#define BIT_OR 41ul
#define BIT_XOR 42ul
#define LSHIFT 43ul
#define RSHIFT 44ul
#define AND 45ul
#define OR 46ul
#define EXCLAMATION 6ul
#define NOT 6ul
#define EQ 48ul
#define GREATER_THAN_EQUAL 49ul
#define LESS_THAN_EQUAL 50ul
#define NUMERIC_LITERAL 51ul
#define REAL_LITERAL   0x0FFFFFFFFFFF0001ul
#define STRING_LITERAL 52ul
#define DECIMAL_LITERAL 53ul
#define HEXADECIMAL_LITERAL 54ul
#define OCTAL_DECIMAL_LITERAL 55ul
#define IF 60ul
#define ELSE 61ul
#define ELSEIF 62ul
#define FOREACH 63ul
#define DO 64ul
#define WHILE 65ul
#define SWITCH 66ul
#define CASE 67ul
#define DEFAULT 68ul
#define BREAK 69ul
#define CONTINUE 70ul
#define TRY 71ul
#define CATCH 72ul
#define VALID_CHAR 113ul
#define IDENTIFIER 1009ul
#define ARRAY 119ul
#define COMMENT 120ul
#define WHITESPACE 121ul
#define FILE_NAME 122ul
#define HAS_SIGN 123ul
#define NEWLINE 124ul
#define SKIP_TOK 125ul
#define MATCH 140
#define UNDEFINED 150
#define EMPTY_STRING 160ul
#define INDIRECT_MEMBER 170ul
#define MODIFIER 180ul
#define OFFSET 1000ul
#define INT					5003ul
#define FLOAT				5006ul
#define CHAR				5009ul
#define VOID                5011ul
#define UNSIGNED			5012ul
#define SIGNED				5016ul
#define PTR					5019ul
#define REF					5022ul
#define REF					5022ul
#define STRUCT				5025ul
#define TYPEDEF				5028ul
#define FUNCTION			5031ul
#define EQUAL_OP            5034ul
#define ASSIGN              5037ul
#define END_OF_FILE   		2003ul
#define END_OF_FILES   		2006ul
#define IDENTIFIER_CHARS    2009ul
#define VAR_OPER   			1003ul
#define CONST_VAR_OPER 		1006ul
#define TEST_TOKEN          777ul
#define _IF					6000ul				
#define _INCLUDE             6003ul
#define _DEFINE              6006ul
#define _IFDEF               6009ul
#define _IFNDEF	            6012ul
#define _ENDIF               6015ul
#define _ELSE               6018ul
#define _ELSEIF             6021ul
#define S_TYPE "string"


/**
 * @name g_tokens
 * @brief global token vector - all tokens
 */
inline map<unsigned long, token> g_tokens =
{
	{TEST_TOKEN,	    token{"TEST_TOKEN", S_TYPE, R"(@@@)", __LINE__}},
	{ESC_SEQ,	        token{"ESC_SEQ", S_TYPE, R"(\\[^\n])", __LINE__}},
	{ESC_NLINE,	        token{"ESC_NLINE", S_TYPE, R"([^\\\n])", __LINE__}},
	{WHITESPACE, 		token{"WHITESPACE", S_TYPE, R"([ \t\r])", __LINE__}},
	{NEWLINE,           token{"NEWLINE", S_TYPE, R"(\n)", __LINE__}},
	{VALID_CHAR,        token{"VALID_CHAR", S_TYPE, R"([A-Za-z0-9*@_.~+-/ ])", __LINE__}},
	{NUMERIC_LITERAL,   token{"NUMERIC_LITERAL", S_TYPE, R"([1-9]+[0-9]*|0)", __LINE__}},
	{REAL_LITERAL,      token{"REAL_LITERAL", S_TYPE, R"(([0-9]+\.[0-9]*|[0-9]*\.[0-9]+)([eE][-+]?[0-9]+)?)", __LINE__}},
	{STRING_LITERAL,    token{"STRING_LITERAL", S_TYPE, R"("[A-Za-z0-9*@_.~+-/ ]+")", __LINE__}},
	{ARRAY,             token{"ARRAY", S_TYPE, R_ARRAY, __LINE__}},
	{IDENTIFIER,        token{"IDENTIFIER", S_TYPE, R"(\<[A-Za-z_][A-Za-z0-9_]*\>)", __LINE__}},
	{COMMENT,           token{"COMMENT", S_TYPE, R"(\{[ ]*\*[^*}]*\*[ ]*\})", __LINE__}},
	{DOUBLE_QUOTE,      token{"DOUBLE_QUOTE", S_TYPE, R"(")", __LINE__}},
	{SUB,             	token{"SUB", S_TYPE, R"([-])", __LINE__}},
	{ADD,              	token{"ADD", S_TYPE, R"([+])", __LINE__}},
	{MUL,          		token{"MUL", S_TYPE, R"([*])", __LINE__}},
	{DIV,            	token{"DIV", S_TYPE, R"([/])", __LINE__}},
	{MOD,           	token{"MOD", S_TYPE, R"([%])", __LINE__}},
	{EQUAL,             token{"EQUAL", S_TYPE, R"([=])", __LINE__}},
	{ASSIGN,            token{"ASSIGN", S_TYPE, R"([=])", __LINE__}},
	{EQUALS,            token{"EQUALS", S_TYPE, R"(==)", __LINE__}},
	{EQUAL_OP,          token{"EQUAL_OP", S_TYPE, R"(==)", __LINE__}},
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
	{BIT_OR,            token{"BIT_OR", S_TYPE, R"(\|)", __LINE__}},
	{BIT_NOT,           token{"BIT_NOT", S_TYPE, R"([~])", __LINE__}},
	{BIT_XOR,           token{"BIT_XOR", S_TYPE, R"([^])", __LINE__}},
	{LSHIFT,            token{"LSHIFT", S_TYPE, R"(<<)", __LINE__}},
	{RSHIFT,            token{"RSHIFT", S_TYPE, R"(>>)", __LINE__}},
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
inline vector<unsigned long> INITIAL_TOKENS = {  TEST_TOKEN, INT, FLOAT, CHAR, SEMI_COLON, _INCLUDE, NEWLINE, WHITESPACE, STRING_LITERAL, NUMERIC_LITERAL, ASSIGN, EQUAL,
												 MUL, DIV, IDENTIFIER, SUB, ADD, MOD, LPAREN, RPAREN, LBRACE, RBRACE, 
												 OR, AND, NOT, BIT_OR, BIT_XOR, BIT_AND, BIT_NOT, RSHIFT, LSHIFT };
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
