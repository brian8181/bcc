/**
 * @file    def.hpp
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
	unsigned long id;
	string name;
	string stype;
	string rexp;
	unsigned long index;
} token_t;

typedef struct state_t
{
	unsigned long id;
	string name;
	vector<token_t*> tokens;
} state_t;

typedef token_t token;
typedef parser::token_type yytoken;
typedef parser::symbol_type yysymbol;
inline auto SKIP_TOKEN = yysymbol( yytoken::SKIP_TOKEN ).kind();

/**
 * @brief token definitions : unsigned long integers
 */
#define STRING                   0x10000
#define SHORT               	 0x20000   
#define INT					     0x40000 
#define LONG					 0x80000
#define SINGLE              	 0x100000
#define FLOAT					 0x200000
#define DOUBLE				     0x400000
#define CHAR					 0x8000000
#define VOID                	 0x10000000
#define UNSIGNED				 0x20000000
#define SIGNED				     0x40000000 
#define CONST                    0x80000000 
#define STATIC					 0x200000000
#define REGISTER				 0x400000000
#define PTR						 0x800000000
#define VOLATILE				 0x1000000000
#define STRUCT                   0x2000000000

#define PRINT                     88
#define ADD 					  89   
#define DASH 					  90   
#define MUL 					  91   
#define DIV 					  92   
#define MOD 					  93   

#define LPAREN 				      94   
#define RPAREN 				      95   
#define LBRACE 				      96   
#define RBRACE 				      97   
#define LBRACKET 				  98   
#define RBRACKET 				  99  
#define DOT 					 159   
#define QUESTION_MARK 		     160   
#define BACKSLASH 			     161   
#define UNDERSCORE 			     162   
#define COMMA 				     163   
#define COLON 				     164   
#define SEMI_COLON 			     165   
#define DOUBLE_QUOTE 			 166   
#define SINGLE_QUOTE 			 167    

#define BIT_AND 				 100   
#define BIT_NOT 				 101   
#define BIT_OR 				     102   
#define BIT_XOR 				 103   
#define LSHIFT  				 104   
#define RSHIFT  				 105   
#define LSFT	  				 1040   
#define RSFT  					 1050   

#define AND 					 106   
#define OR 					     107   
#define NOT 					 108   

#define EQ 					     109   
#define NEQ                      1090
#define LT 	             		 1100   
#define GT 	            		 1110   
#define GEQ             	     1120   
#define LEQ             		 1130

#define ASSIGN              	 150  
#define INC                      1150
#define ADD_EQ                   1153
#define SUB_EQ              	 1156
#define MUL_EQ              	 1159  
#define DIV_EQ              	 1161 
#define MOD_EQ              	 1164 
#define OR_EQ              	 	 1167 
#define AND_EQ              	 1170  
#define NOT_EQ              	 1173
#define XOR_EQ              	 1176
#define LSFT_EQ              	 1179 
#define RSFT_EQ              	 1182
#define TENERARY                 1192    

#define NUMERIC_LITERAL 		 114   
#define REAL_LITERAL   		     115   
#define STRING_LITERAL 		     116   
#define HEXADECIMAL_LITERAL 	 117   
#define OCTAL_DECIMAL_LITERAL    118 
#define CHAR_LITERAL             1180

#define IF 					     119   
#define ELSE 					 120   
#define ELSEIF 				     121   
#define DO 					     122   
#define WHILE 				     123  
#define FOR 				     1230  
#define RETURN 				     1240   
#define SWITCH				     124   
#define CASE 					 125   
#define DEFAULT 				 126   
#define BREAK 				     127   
#define CONTINUE 				 128  
#define GOTO 				 	 1155   
#define LABEL 				 	 11590   

#define TRY 					 129   
#define CATCH 				     130   

#define IDENTIFIER 			     131   
#define ARRAY 				     132   
#define COMMENT 				 133   
#define INDIRECT_MEMBER 		 134   

//#define PTR					 145  
#define DEREF		 			 145 
#define ADDR		 			 1450 
#define REF					     146   
#define TYPEDEF				     148   
#define FUNCTION				 149   

#define HASH_IF					 151   
#define INCLUDE                  1520   
#define DEFINE                   153 
#define UNDEF                    1530   
#define IFDEF                    154   
#define IFNDEF	             	 155   
#define ENDIF               	 156   
#define HASH_ELSE                157   
#define HASH_ELSEIF              158   
#define PRAGMA              	 1580 
#define HASH_ERROR               1581  

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


// regex 
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
		{TEST_TOKEN, token{TEST_TOKEN, "TEST_TOKEN", S_TYPE, R"(@@@)", __LINE__}},
		{PRINT, token{PRINT, "PRINT", S_TYPE, R"(PRINT)", __LINE__}},
		{ESC_SEQ, token{ESC_SEQ, "ESC_SEQ", S_TYPE, R"(\\[^\n])", __LINE__}},
		{ESC_NLINE, token{ESC_NLINE, "ESC_NLINE", S_TYPE, R"([^\\\n])", __LINE__}},
		{WHITESPACE, token{WHITESPACE, "WHITESPACE", S_TYPE, R"([ \t\r])", __LINE__}},
		{NEWLINE, token{NEWLINE, "NEWLINE", S_TYPE, R"(\n)", __LINE__}},
		{NUMERIC_LITERAL, token{NUMERIC_LITERAL, "NUMERIC_LITERAL", S_TYPE, R_NUMERIC_LITERAL, __LINE__}},
		{REAL_LITERAL, token{REAL_LITERAL, "REAL_LITERAL", S_TYPE, R"([0-9]+\.[0-9]+)", __LINE__}},
		{STRING_LITERAL, token{STRING_LITERAL, "STRING_LITERAL", S_TYPE, R"("[A-Za-z0-9*@_.~+-/ ]+")", __LINE__}},
		{CHAR_LITERAL, token{CHAR_LITERAL, "CHAR_LITERAL", S_TYPE, R"('.')", __LINE__}},
		{IDENTIFIER, token{IDENTIFIER, "IDENTIFIER", S_TYPE, R"([A-Za-z_][A-Za-z0-9_]*)", __LINE__}},
		{FUNCTION, token{FUNCTION, "FUNCTION", S_TYPE, R"([A-Za-z_][A-Za-z0-9_]*)", __LINE__}},
		{COMMENT, token{COMMENT, "COMMENT", S_TYPE, R"(\{[ ]*\*[^*}]*\*[ ]*\})", __LINE__}},
		{DASH, token{DASH, "DASH", S_TYPE, R"([-])", __LINE__}},
		{ADD, token{ADD, "ADD", S_TYPE, R"([+])", __LINE__}},
		{MUL, token{MUL, "MUL", S_TYPE, R"([*])", __LINE__}},
		{PTR, token{PTR, "PTR", S_TYPE, R"([*])", __LINE__}},
		{DEREF, token{DEREF, "DEREF", S_TYPE, R"([*])", __LINE__}},
		{DIV, token{DIV, "DIV", S_TYPE, R"([/])", __LINE__}},
		{MOD, token{MOD, "MOD", S_TYPE, R"([%])", __LINE__}},
		{ASSIGN, token{ASSIGN, "ASSIGN", S_TYPE, R"(=)", __LINE__}},
		{ADD_EQ, token{ADD_EQ, "ADD_EQ", S_TYPE, R"(\+=)", __LINE__}},
		{SUB_EQ, token{SUB_EQ, "SUB_EQ", S_TYPE, R"(\-=)", __LINE__}},
		{MUL_EQ, token{MUL_EQ, "MUL_EQ", S_TYPE, R"(\*=)", __LINE__}},
		{DIV_EQ, token{DIV_EQ, "DIV_EQ", S_TYPE, R"(\\=)", __LINE__}},
		{MOD_EQ, token{MOD_EQ, "MOD_EQ", S_TYPE, R"(%=)", __LINE__}},
		{AND_EQ, token{AND_EQ, "AND_EQ", S_TYPE, R"(&=)", __LINE__}},
		{OR_EQ, token{OR_EQ, "OR_EQ", S_TYPE, R"(\|=)", __LINE__}},
		{XOR_EQ, token{XOR_EQ, "XOR_EQ", S_TYPE, R"(\^=)", __LINE__}},
		{NOT_EQ, token{NOT_EQ, "NOT_EQ", S_TYPE, R"(\~=)", __LINE__}},
		{LSFT_EQ, token{LSFT_EQ, "LSFT_EQ", S_TYPE, R"(<<=)", __LINE__}},
		{RSFT_EQ, token{RSFT_EQ, "RSFT_EQ", S_TYPE, R"(>>=)", __LINE__}},
		{LPAREN, token{LPAREN, "LPAREN", S_TYPE, "[(]", __LINE__}},
		{RPAREN, token{RPAREN, "RPAREN", S_TYPE, "[)]", __LINE__}},
		{LBRACKET, token{LBRACKET, "LBRACKET", S_TYPE, R"(\[)", __LINE__}},
		{RBRACKET, token{RBRACKET, "RBRACKET", S_TYPE, R"(\])", __LINE__}},
		{LBRACE, token{LBRACE, "LBRACE", S_TYPE, R"([{])", __LINE__}},
		{RBRACE, token{RBRACE, "RBRACE", S_TYPE, R"([}])", __LINE__}},
		{BACKSLASH, token{BACKSLASH, "BACKSLASH", S_TYPE, R"([\])", __LINE__}},
		{COLON, token{COLON, "COLON", S_TYPE, R"([:])", __LINE__}},
		{SEMI_COLON, token{SEMI_COLON, "SEMI_COLON", S_TYPE, R"([;])", __LINE__}},
		{QUESTION_MARK, token{QUESTION_MARK, "QUESTION_MARK", S_TYPE, R"([?])", __LINE__}},
		{COMMA, token{COMMA, "COMMA", S_TYPE, R"([,])", __LINE__}},
		{DOT, token{DOT, "DOT", S_TYPE, R"(\.)", __LINE__}},
		{EQ, token{EQ, "EQ", S_TYPE, R"(==)", __LINE__}},
		{INC, token{INC, "INC", S_TYPE, R"(\+\+)", __LINE__}},
		{NEQ, token{NEQ, "NEQ", S_TYPE, R"(!=)", __LINE__}},
		{LT, token{LT, "LT", S_TYPE, R"([<])", __LINE__}},
		{GT, token{GT, "GT", S_TYPE, R"([>])", __LINE__}},
		{GEQ, token{GEQ, "GEQ", S_TYPE, R"(>=)", __LINE__}},
		{LEQ, token{LEQ, "LEQ", S_TYPE, R"(<=)", __LINE__}},
		{AND, token{AND, "AND", S_TYPE, R"(&&)", __LINE__}},
		{OR, token{OR, "OR", S_TYPE, R"(\|\|)", __LINE__}},
		{NOT, token{NOT, "NOT", S_TYPE, R"([!])", __LINE__}},
		{BIT_AND, token{BIT_AND, "BIT_AND", S_TYPE, R"(&)", __LINE__}},
		{BIT_OR, token{BIT_OR, "BIT_OR", S_TYPE, R"([|])", __LINE__}},
		{BIT_NOT, token{BIT_NOT, "BIT_NOT", S_TYPE, R"([~])", __LINE__}},
		{BIT_XOR, token{BIT_XOR, "BIT_XOR", S_TYPE, R"(^)", __LINE__}},
		{LSHIFT, token{LSHIFT, "LSHIFT", S_TYPE, R"([<]{2})", __LINE__}},
		{RSHIFT, token{RSHIFT, "RSHIFT", S_TYPE, R"([>]{2})", __LINE__}},
		{LSFT, token{LSFT, "LSFT", S_TYPE, R"(<<)", __LINE__}},
		{RSFT, token{RSFT, "RSFT", S_TYPE, R"(>>)", __LINE__}},
		{IF, token{IF, "IF", S_TYPE, R"(if)", __LINE__}},
		{ELSE, token{ELSE, "ELSE", S_TYPE, R"(else)", __LINE__}},
		{ELSEIF, token{ELSEIF, "ELSEIF", S_TYPE, R"(elseif)", __LINE__}},
		{DO, token{DO, "DO", S_TYPE, R"(do)", __LINE__}},
		{WHILE, token{WHILE, "WHILE", S_TYPE, R"(while)", __LINE__}},
		{FOR, token{FOR, "FOR", S_TYPE, R"(for)", __LINE__}},
		{RETURN, token{RETURN, "RETURN", S_TYPE, R"(return)", __LINE__}},
		{BREAK, token{BREAK, "BREAK", S_TYPE, R"(break)", __LINE__}},
		{CONTINUE, token{CONTINUE, "CONTINUE", S_TYPE, R"(continue)", __LINE__}},
		{SWITCH, token{SWITCH, "SWITCH", S_TYPE, R"(switch)", __LINE__}},
		{CASE, token{CASE, "CASE", S_TYPE, R"(case)", __LINE__}},
		{DEFAULT, token{DEFAULT, "DEFAULT", S_TYPE, R"(default)", __LINE__}},
		{GOTO, token{GOTO, "GOTO", S_TYPE, R"(goto)", __LINE__}},
		{LABEL, token{LABEL, "LABEL", S_TYPE, R"(^[A-Za-z]\w*:)", __LINE__}},
		{STRING, token{STRING, "STRING", S_TYPE, R"(\s*\<STRING\>\s+)", __LINE__}},
		{INT, token{INT, "INT", S_TYPE, R"(\s*\<int\>\s+)", __LINE__}},
		{FLOAT, token{FLOAT, "FLOAT", S_TYPE, R"(\s*\<float\>\s+)", __LINE__}},
		{CHAR, token{CHAR, "CHAR", S_TYPE, R"(\s*\<char\>\s+)", __LINE__}},
		{VOID, token{VOID, "VOID", S_TYPE, R"(\s*\<void\>\s+)", __LINE__}},
		{STRUCT, token{STRUCT, "STRUCT", S_TYPE, R"(\s*\<struct\>\s+)", __LINE__}},
		{TYPEDEF, token{TYPEDEF, "TYPEDEF", S_TYPE, R"(\s*\<tyedef\>\s+)", __LINE__}},
		{HASH_IF, token{HASH_IF, "HASH_IF", S_TYPE, R"(#if|#IF)", __LINE__}},
		{DEFINE, token{DEFINE, "DEFINE", S_TYPE, R"(#define|#DEFINE)", __LINE__}},
		{IFDEF, token{IFDEF, "IFDEF", S_TYPE, R"(#ifdef|#IFDEF)", __LINE__}},
		{IFNDEF, token{IFNDEF, "IFNDEF", S_TYPE, R"(#ifndef|#IFNDEF)", __LINE__}},
		{HASH_ELSE, token{HASH_ELSE, "HASH_ELSE", S_TYPE, R"(#else|#ELSE)", __LINE__}},
		{HASH_ELSEIF, token{HASH_ELSEIF, "HASH_ELSEIF", S_TYPE, R"(#elseif|#ELSEIF)", __LINE__}},
		{ENDIF, token{ENDIF, "ENDIF", S_TYPE, R"(#endif|#ENDIF)", __LINE__}},
		{INCLUDE, token{INCLUDE, "INCLUDE", S_TYPE, R"(#include)", __LINE__}},
		{UNDEF, token{UNDEF, "UNDEF", S_TYPE, R"(#undef|#UNDEF)", __LINE__}},
		{UNDEF, token{UNDEF, "UNDEF", S_TYPE, R"(#undef|#UNDEF)", __LINE__}},
		{HASH_ERROR, token{HASH_ERROR, "HASH_ERROR", S_TYPE, R"(#error)", __LINE__}},
		{PRAGMA, token{PRAGMA, "PRAGMA", S_TYPE, R"(#pargma)", __LINE__}}
	};

/**
 * @brief unsigned long states
 */
constexpr unsigned long UL_INITIAL = 0x10;
constexpr unsigned long UL_PRE_PROCESSOR = 0x20;
constexpr unsigned long UL_PARSER = 0x40;


#define gt(n) &g_tokens[n]

inline state_t INITIAL = {};

/**
 * @brief state_t states
 */
inline state_t PARSER = { UL_PARSER, "PARSER", {	 				gt(TEST_TOKEN), gt(PRINT), gt(INT), gt(FLOAT), gt(CHAR), gt(VOID),
																	gt(IF), gt(ELSE), gt(WHILE), gt(DO), gt(FOR), gt(RETURN), gt(BREAK), gt(CONTINUE), gt(SWITCH), gt(CASE), gt(DEFAULT), gt(GOTO), gt(LABEL),
																	gt(SEMI_COLON), gt(ASSIGN),
																	gt(INCLUDE),
																	gt(NEWLINE), gt(WHITESPACE), gt(CHAR_LITERAL), gt(STRING_LITERAL), gt(NUMERIC_LITERAL), gt(REAL_LITERAL), gt(IDENTIFIER),
																	gt(EQ), gt(NEQ), gt(LEQ), gt(GEQ), gt(LT), gt(GT),
																	gt(INC), gt(ADD_EQ), gt(SUB_EQ), gt(MUL_EQ), gt(DIV_EQ), gt(MOD_EQ), gt(OR_EQ), gt(AND_EQ), gt(NOT_EQ), gt(XOR_EQ), gt(LSFT_EQ), gt(RSFT_EQ), 
																	gt(MUL), gt(DIV), gt(DASH), gt(ADD), gt(MOD), gt(LBRACKET), gt(RBRACKET), gt(LPAREN), gt(RPAREN), gt(LBRACE), gt(RBRACE),
																	gt(OR), gt(AND), gt(NOT), gt(BIT_OR), gt(BIT_AND), gt(BIT_NOT), gt(RSHIFT), gt(LSHIFT), gt(COMMA),
																	gt(STRUCT), gt(TYPEDEF), gt(PTR) } };


inline state_t PRE_PROCESSOR = { UL_PRE_PROCESSOR, "PRE_PROCESSOR", {  	gt(TEST_TOKEN), gt(PRINT), gt(STRING), gt(INT), gt(FLOAT), gt(CHAR), gt(VOID), gt(SEMI_COLON), gt(ASSIGN),
																	gt(INCLUDE), gt(IFDEF), gt(IFNDEF), gt(DEFINE), gt(UNDEF), gt(ENDIF), gt(PRAGMA), gt(HASH_ERROR), gt(HASH_IF), gt(HASH_ELSE), gt(HASH_ELSEIF),
																	gt(NEWLINE), gt(WHITESPACE), gt(CHAR_LITERAL), gt(STRING_LITERAL), gt(NUMERIC_LITERAL), gt(REAL_LITERAL), gt(IDENTIFIER) } };
#endif
