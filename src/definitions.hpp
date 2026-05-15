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

// smarty
// commentstart = /#|;/
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

// groups
const string BUILTIN_FUNCTION = "(insert)|(include)|(config_load)|(assign)|(fetch)|(capture)";
const string MATH = "(abs)|(ceil)|(cos)|(exp)|(floor)|(log)|(log10)|(max)|(min)|(pi)|(pow)|(rand)|(round)|(sin)|(sqrt)|(srans)|(tan)";
const string KEY_WORDS = "(if)|(else)|(elseif)|(foreach)|(foreachelse)|(literal)|(section)|(strip)|(assign)|(counter)|(cycle)|(debug)|(eval)|(fetch)|(html_checkboxes)";
const string VAR_MODIFIER = "(capitalize)|(indent)|(lower)|(upper)|(spacify)|(string_format)|(truncate)|(date_format)|(escape)";

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
#define TILDE 4ul
#define TIC_MARK 5ul
#define EXCLAMATION 6ul
#define AT_SYMBOL 7ul
#define HASH_MARK 8ul
#define DOLLAR_SIGN 9ul
#define PERCENT_SIGN 10ul
#define MODULUS 5510ul
#define CARROT 11ul
#define AMPERSAND 12ul
#define ASTERISK 13ul
#define MULTIPLY 5513ul
#define OPEN_PAREN 14ul
#define CLOSE_PAREN 15ul
#define DASH 16ul
#define MINUS 5516ul
#define UNDERSCORE 17ul
#define PLUS_SIGN 18ul
#define EQUAL_SIGN 19ul
#define PLUS 5518ul
#define EQUAL 5519ul
#define OPEN_BRACE 20ul
#define OPEN_BRACKET 21ul
#define CLOSE_BRACE 22ul
#define CLOSE_BRACKET 23ul
#define VBAR 5524ul
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
#define DOT 33ul
#define QUESTION_MARK 34ul
#define SLASH 35ul
#define DIVIDE 5535ul
#define NOT 39ul
#define AND 40ul
#define OR 41ul
#define XOR 42ul
#define LEFT_SHIFT 43ul
#define RIGHT_SHIFT 44ul
#define LOGICAL_AND 45ul
#define LOGICAL_OR 46ul
#define LOGICAL_NOT 47ul
#define LOGICAL_EQUAL 48ul
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
#define SYMBOL 117ul
#define CONST_SYMBOL 118ul
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
#define UNSIGNED			5012ul
#define SIGNED				5016ul
#define PTR					5019ul
#define REF					5022ul
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
	{WHITESPACE, 		token{"WHITESPACE", S_TYPE, R"([ \t])", __LINE__}},
	{NEWLINE,           token{"NEWLINE", S_TYPE, R"(\n)", __LINE__}},
	{VALID_CHAR,        token{"VALID_CHAR", S_TYPE, R"([A-Za-z0-9*@_.~+-/ ])", __LINE__}},
	{NUMERIC_LITERAL,   token{"NUMERIC_LITERAL", S_TYPE, R"([1-9]+[0-9]*|0)", __LINE__}},
	{REAL_LITERAL,      token{"REAL_LITERAL", S_TYPE, R"(([0-9]+\.[0-9]*|[0-9]*\.[0-9]+)([eE][-+]?[0-9]+)?)", __LINE__}},
	{STRING_LITERAL,    token{"STRING_LITERAL", S_TYPE, R"("[A-Za-z0-9*@_.~+-/ ]+")", __LINE__}},
	{ARRAY,             token{"ARRAY", S_TYPE, R_ARRAY, __LINE__}},
	{IDENTIFIER,        token{"IDENTIFIER", S_TYPE, R"(\<[A-Za-z_][A-Za-z0-9_]*\>)", __LINE__}},
	{COMMENT,           token{"COMMENT", S_TYPE, R"(\{[ ]*\*[^*}]*\*[ ]*\})", __LINE__}},
	{DOUBLE_QUOTE,      token{"DOUBLE_QUOTE", S_TYPE, R"(")", __LINE__}},
	{TILDE,             token{"TILDE", S_TYPE, R"(~)", __LINE__}},
	{EXCLAMATION,       token{"EXCLAMATION", S_TYPE, R"([!])", __LINE__}},
	{AT_SYMBOL,         token{"AT_SYMBOL", S_TYPE, R"([@])", __LINE__}},
	{CARROT,            token{"CARROT", S_TYPE, R"(\^)", __LINE__}},
	{AMPERSAND,         token{"AMPERSAND", S_TYPE, R"(&)", __LINE__}},
	{ASTERISK,          token{"ASTERISK", S_TYPE, R"(\*)", __LINE__}},
	{OPEN_PAREN,        token{"OPEN_PAREN", S_TYPE, "\\(", __LINE__}},
	{CLOSE_PAREN,       token{"CLOSE_PAREN", S_TYPE, "\\)", __LINE__}},
	{MINUS,             token{"MINUS", S_TYPE, R"([-])", __LINE__}},
	{PLUS,              token{"PLUS", S_TYPE, R"([+])", __LINE__}},
	{MULTIPLY,          token{"MULTIPLY", S_TYPE, R"([*])", __LINE__}},
	{DIVIDE,            token{"DIVIDE", S_TYPE, R"([/])", __LINE__}},
	{MODULUS,           token{"MODULUS", S_TYPE, R"([%])", __LINE__}},
	{EQUAL,             token{"EQUAL", S_TYPE, R"([=])", __LINE__}},
	{EQUALS,            token{"EQUALS", S_TYPE, R"(==)", __LINE__}},
	{DASH,              token{"DASH", S_TYPE, R"([-])", __LINE__}},
	{PLUS_SIGN,         token{"PLUS_SIGN", S_TYPE, R"([+])", __LINE__}},
	{EQUAL_SIGN,        token{"EQUAL_SIGN", S_TYPE, R"([=])", __LINE__}},
	{CLOSE_BRACKET,     token{"RBRACKET", S_TYPE, R"(\])", __LINE__}},
	{OPEN_BRACE,        token{"OPEN_BRACE", S_TYPE, R"(\{)", __LINE__}},
	{CLOSE_BRACE,       token{"CLOSE_BRACE", S_TYPE, R"(\})", __LINE__}},
	{OPEN_BRACKET,      token{"LBRACKET", S_TYPE, R"(\[)", __LINE__}},
	{VBAR,              token{"VBAR", S_TYPE, R"(\|)", __LINE__}},
	{BACKSLASH,         token{"BACKSLASH", S_TYPE, R"(\\)", __LINE__}},
	{COLON,             token{"COLON", S_TYPE, R"(:)", __LINE__}},
	{SEMI_COLON,        token{"SEMI_COLON", S_TYPE, R"(;)", __LINE__}},
	{SINGLE_QUOTE,      token{"SINGLE_QUOTE", S_TYPE, R"(')", __LINE__}},
	{GREATER_THAN,      token{"GREATER_THAN", S_TYPE, R"(>)", __LINE__}},
	{QUESTION_MARK,     token{"QUESTION_MARK", S_TYPE, R"(\?)", __LINE__}},
	{COMMA,             token{"COMMA", S_TYPE, R"(\,)", __LINE__}},
	{DOT,               token{"DOT", S_TYPE, R"(\.)", __LINE__}},
	{SLASH,             token{"SLASH", S_TYPE, R"(/)", __LINE__}},
	{GREATER_THAN_EQUAL,token{"GREATER_THAN_EQUAL", S_TYPE, R"(>=)", __LINE__}},
	{LESS_THAN_EQUAL,   token{"LESS_THAN_EQUAL", S_TYPE, R"(<=)", __LINE__}},
	{IF,                token{"IF", S_TYPE, R"(if)", __LINE__}},
	{ELSE,              token{"ELSE", S_TYPE, R"(else)", __LINE__}},
	{ELSEIF,            token{"ELSEIF", S_TYPE, R"(elseif)", __LINE__}},
	{WHILE,             token{"WHILE", S_TYPE, R"(while)", __LINE__}},
	{BREAK,             token{"BREAK", S_TYPE, R"(break)", __LINE__}},
	{PTR,               token{"PTR", S_TYPE, R"(*)", __LINE__}},
	{REF,               token{"PTR", S_TYPE, R"(&)", __LINE__}},
	{INT,               token{"INT", S_TYPE, R"((^|\s)\s+\<int\>\s+)", __LINE__}},
	{FLOAT,             token{"FLOAT", S_TYPE, R"((^|\s)\s*\<float\>\s+)", __LINE__}},
	{CHAR,              token{"CHAR", S_TYPE, R"((^|\s)\s*\<char\>\s+s)", __LINE__}},
	{_IF,               token{"_IF", S_TYPE, R"(^\s(#if|#IF)\>\s+)", __LINE__}},
	{_DEFINE,           token{"_DEFINE", S_TYPE, R"(^\s(#define|#DEFINE)\>\s+)", __LINE__}},
	{_IFDEF,            token{"_IFDEF", S_TYPE, R"(^\s*(#ifdef|#IFDEF)\>\s+)", __LINE__}},
	{_IFNDEF,           token{"_IFNDEF", S_TYPE, R"(^\s*(#ifndef|#IFNDEF)\>\s+)", __LINE__}},
	{_ELSE,             token{"_ELSE", S_TYPE, R"(^\s*(#else|#ELSE)\>\s+)", __LINE__}},
	{_ELSEIF,           token{"_ELSEIF", S_TYPE, R"(^\s*(#elseif|#ELSEIF)\>\s+)", __LINE__}},
	{_ENDIF,            token{"_ENDIF", S_TYPE, R"(^\s*(#endif|#ENDIF)\>\s+)", __LINE__}},
	{_INCLUDE,          token{"_INCLUDE", S_TYPE, R"(^\s*(#INCLUDE|#include)\>\s+)", __LINE__}}
};

/**
 * @brief unsigned long states
 */
constexpr unsigned long UL_INITIAL = 0x10;
constexpr unsigned long UL_COMMENTING = 0x20;
constexpr unsigned long UL_DOUBLE_QUOTED = 0x80;
constexpr unsigned long UL_SINGLE_QUOTED = 0x100;
constexpr unsigned long UL_IF_BLOCK = 0x400;
constexpr unsigned long UL_IF_CONDITION = 0x800;

/**
 * @brief global state IDs
 */
inline vector<unsigned long> state_ids = { UL_INITIAL, UL_COMMENTING, UL_DOUBLE_QUOTED, UL_SINGLE_QUOTED, UL_IF_BLOCK, UL_IF_CONDITION };

/**
 * @brief state_t states
 */

inline state_t INITIAL = { UL_INITIAL, "INITIAL" };
inline state_t COMMENTING = { UL_COMMENTING, "COMMENT" };
inline state_t DOUBLE_QUOTED = { UL_DOUBLE_QUOTED, "DOUBLE_QUOTED" };
inline state_t SINGLE_QUOTED = { UL_SINGLE_QUOTED, "SINGLE_QUOTED" };
inline state_t IF_BLOCK = { UL_IF_BLOCK, "IF_BLOCK" };
inline state_t IF_CONDITION = { UL_IF_CONDITION, "IF_CONDITION" };
inline state_t& UNESCAPED = INITIAL;

/**
 * @brief global state vector
 */
inline vector<state_t> states__ = { INITIAL, COMMENTING, DOUBLE_QUOTED, SINGLE_QUOTED, IF_BLOCK, IF_CONDITION };

/**
 * @brief token list -> by state
 */
inline vector<unsigned long> INITIAL_TOKENS = {  TEST_TOKEN, INT, FLOAT, CHAR, SEMI_COLON, NEWLINE, WHITESPACE, STRING_LITERAL, NUMERIC_LITERAL, EQUALS, EQUAL,
												 MULTIPLY, DIVIDE, IDENTIFIER, PLUS, MODULUS, 
												 OPEN_PAREN, CLOSE_PAREN, OPEN_BRACE, CLOSE_BRACE, OPEN_BRACKET, CLOSE_BRACKET	};

inline vector<unsigned long> COMMENTING_TOKENS = { OPEN_BRACE, COMMENT };
inline vector<unsigned long> DOUBLE_QUOTED_TOKENS = { DOUBLE_QUOTE, VALID_CHAR };
inline vector<unsigned long> SINGLE_QUOTED_TOKENS = { OPEN_BRACE, COMMENT, VALID_CHAR, SINGLE_QUOTE, DOUBLE_QUOTE };
inline vector<unsigned long> IF_BLOCK_TOKENS = { CLOSE_BRACE, CLOSE_BRACE, OPEN_BRACKET, DOUBLE_QUOTE, IF, ELSE, STRING_LITERAL, NUMERIC_LITERAL, EQUAL_SIGN,
												 VBAR, COMMA, COLON, DOT, SLASH, SYMBOL, CONST_VAR_OPER };

inline vector<unsigned long> IF_CONDITION_TOKENS = { CLOSE_BRACE };

/**
 * @brief global state: state_id -> states
 * @name g_tokens_by_state_id
 */
inline map<unsigned long, vector<unsigned long>*> g_state_tokens {  {UL_INITIAL, &INITIAL_TOKENS},
																	{UL_COMMENTING, &COMMENTING_TOKENS},
																	{UL_SINGLE_QUOTED, &SINGLE_QUOTED_TOKENS},
																	{UL_DOUBLE_QUOTED, &DOUBLE_QUOTED_TOKENS},
																	{UL_IF_BLOCK, &IF_BLOCK_TOKENS},
																	{UL_IF_CONDITION, &IF_CONDITION_TOKENS} };
/**
 *
 */
typedef unsigned long type_t;
typedef unsigned long terminal_t;
typedef vector<terminal_t> terminals_t;
typedef vector<type_t> types_t;
typedef vector<unsigned long> rules_t;
typedef vector<type_t> rules_t;
typedef vector<type_t> sequence_t;
typedef vector<sequence_t> sequences_t;
typedef map < type_t, sequences_t > maps;

#endif
