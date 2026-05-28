// File Name:  ./token.hpp
// Build Date: Thu Dec 21 09:06:55 AM CST 2023
// Version:    0.0.2

#ifndef _TOKENS_HPP
#define _TOKENS_HPP

#include <string>

using std::string;

// terminals
const string OPEN_CURLY_BRACE = "\\{";
const string CLOSE_CURLY_BRACE = "\\}";
const string FORWARD_SLASH = "/";
const string ASTERIK = "\\*";
const string HASH_MARK = "#";
const string DOLLAR_SIGN = "\\$";
const string DOUBLE_QUOTE_MARK = "\"";
const string SINGLE_QUOTE_MARK = "'";
const string TICK_MARK = "`";
const string UNDERSCORE = "_";
const string AT_SIGN = "@";
const string PLUS_SIGN = "+";
const string MINUS_SIGN = "-";
const string BACKWARD_SLASH = "\\";
const string EQUALS = "=";
const string V_BAR = "|";
const string COLON = ":";
const string DOT   = ".";
const string OPEN_BRACE = "[";
const string CLOSE_BRACE = "]";
const string OPEN_PAREN = "(";
const string CLOSE_PAREN = ")";
// binary operators
const string MODULO = "%";
// left unary "bitwise" operator
const string BIT_WISE_NOT = "~";
// binary "bitwise" operators
const string BIT_WISE_EXCLISIVE_OR = "^";
const string BIT_WISE_AND = "&";
const string BIT_WISE_OR = "|";
// left unary "logical" operators
const string LOGICAL_NOT = "!";
// binary "logical" operators
const string LOGICAL_AND = "&&";
const string LOGICAL_OR = "||";
const string EQUALS_LOGICAL = "==";
const string LESS_THAN_OPERATOR = "<";
const string GREATER_THAN_OPERATOR = ">";
const string NOT_OPERATOR = "!";
const string LESS_THAN_EQUAL_OPERATOR = "<=";
const string GREATER_THAN_EQUAL_OPERATOR = ">=";
const string NOT_EQUAL_OPERATOR = "!=";
const string INDIRECT_SELECTION_OPERATOR   = "->";
// valid chars
const string VALID_SYMBOL_CHARS = "[A-Za-z0-9_]";
const string VALID_ESC_CHARS = "[\\w\\s\\[\\]+-=|$><^/#@~&*.%!~`_:;\"'\\\\,()]";
const string VALID_LITERAL_CHARS = "[\\w\\s\\[\\]+-=|$><^/#@~&*.%!~`_:;'\\\\,()]";
const string VALID_FILE_CHARS = "[A-Za-z0-9_. ]";
// streamy functions, types, modifiers, keywords ...
const string VARIABLE_ESCAPES = "[*#$]";
const string BUILTIN_FUNCTION = "(insert)|(include)|(config_load)|(assign)|(fetch)|(capture)";
const string MATH = "(abs)|(ceil)|(cos)|(exp)|(floor)|(log)|(log10)|(max)|(min)|(pi)|(pow)|(rand)|(round)|(sin)|(sqrt)|(srans)|(tan)";
const string KEY_WORDS = "(if)|(else)|(elseif)|(foreach)|(foreachelse)|(literal)|(section)|(strip)|(assign)|(counter)|(cycle)|(debug)|(eval)|(fetch)|(html_checkboxes)";
const string VAR_MODIFIER = "(capitalize)|(indent)|(lower)|(upper)|(spacify)|(string_format)|(truncate)|(date_format)|(escape)";
const string CONFIG_COMMENT = "^#";
const string CONFIG_PAIR = "\\s*([A-Za-z]" + VALID_SYMBOL_CHARS + "*)\\s*=\\s*((" + VALID_SYMBOL_CHARS + "*)|(\"" + VALID_LITERAL_CHARS + "*\"))\\s*";
// lexing
const string DELIMIT_SPACE_AND_WORD_BOUNDARY = "\\s\\b";
const string ESCAPE = "\\{" + VALID_ESC_CHARS + "*\\}";
// parser & grammer constants
const string STRING_LITERAL = "[\\w\\s\\[\\]+-=|$><^/#@~&*.%!~`_:;\\\\,()]*";
const string LOGICAL_OPERATORS = "((->)|(=>)|(==)|(!=)|(<=)|(>=)|(===))";
const string OPERATORS = "([\\s,/'\"$*#=+-:!%<>|.(){}\\]\\[])";
const string FLOAT_LITERAL = "([0-9]*\\.[0-9]+)";
const string INTEGER_LITERAL = "([0-9]+)";
const string HEX_LITERAL = "(0x[0-9A-Fa-f]+)";
const string SYMBOL_NAME = "\\$?_*[A-Za-z]" + VALID_SYMBOL_CHARS + "*";
const string LITERAL = "(" + STRING_LITERAL + ")|(" + INTEGER_LITERAL + ")|(" + FLOAT_LITERAL + ")";
const string VARIABLE = "(" + DOLLAR_SIGN + "(" + SYMBOL_NAME + "))";
const string ATTRIBUTE = "(" + VALID_SYMBOL_CHARS + ")" + EQUALS + "(" + LITERAL + ")";
const string FILE_ATTRIBUTE = "(file)" + EQUALS + "(" + LITERAL + ")";
const string VARIABLE_ARRAY = "(" + DOLLAR_SIGN + "(" + SYMBOL_NAME + "))\\[((" + LITERAL + ")|(" + VARIABLE +  "))\\]";
const string VARIABLE_OBJECT = "(" + DOLLAR_SIGN + "(" + SYMBOL_NAME + "))\\[((" + LITERAL + ")|(" + VARIABLE +  "))\\]";
const string VARIABLE_MIX_EXPRESSION = "(" + DOLLAR_SIGN + "(" + SYMBOL_NAME + "))\\[((" + LITERAL + ")|(" + VARIABLE +  "))\\]";
const string VARIABLE_ASSIGMENT = "(" + DOLLAR_SIGN + "(" + SYMBOL_NAME + "))" + EQUALS + "(" + STRING_LITERAL + ")|(" + DOLLAR_SIGN + "(" + SYMBOL_NAME + "))";
const string VARIABLE_MOD = "(" + DOLLAR_SIGN + "(" + SYMBOL_NAME + "))" + V_BAR  + "(" + VAR_MODIFIER + ")";
const string VARIABLE_MOD_AND_SET = "(" + DOLLAR_SIGN + "(" + SYMBOL_NAME + "))" + V_BAR  + "(" + VAR_MODIFIER + COLON + LITERAL + ")";
const string INCLUDE_FILE = "(include)(" + FILE_ATTRIBUTE + ")";

enum token_id : unsigned long
{
    ID_IF                 = 0x1ul,
    ID_ELSE               = 0x2ul,
    ID_ELSEIF             = 0x4ul,
    ID_FOREACH            = 0x8ul,
    ID_DOUBLE_QUOTE       = 0x10ul,
    ID_SINGLE_QUOTE       = 0x20ul,
    ID_OPEN_BRACE         = 0x40ul,
    ID_CLOSE_BRACE        = 0x80ul,
    ID_FOREACHELSE        = 0x100ul,
    ID_LITERAL            = 0x200ul,
    ID_OPEN_CURLY_BRACE   = 0x400ul,
    ID_CLOSE_CURLY_BRACE  = 0x800ul,
    ID_ASTERIK            = 0x1000ul,
    ID_HASH_MARK          = 0x2000ul,
    ID_DOLLAR_SIGN        = 0x4000ul,
    ID_DOT                = 0x8000ul,
    ID_EQUAL              = 0x10000ul,
    ID_BUILTIN_FUNCTION   = 0x20000ul,
    ID_VBAR               = 0x40000ul,
    ID_COLON              = 0x80000ul,
    ID_SEMI_COLON         = 0x100000ul,
    ID_LOGICAL_NOT        = 0x200000ul,
    ID_LESS_THAN          = 0x400000ul,
    ID_GREATER_THAN       = 0x800000ul,
    ID_MINUS              = 0x1000000ul,
    ID_PLUS               = 0x2000000ul,
    ID_OPEN_PAREN         = 0x4000000ul,
    ID_CLOSE_PAREN        = 0x8000000ul,
    ID_MODULUS            = 0x10000000ul,
    ID_LOGICAL_AND        = 0x20000000ul,
    ID_LOGICAL_OR         = 0x40000000ul,
    ID_DIVIDE_OR          = 0x80000000ul,
    ID_MULTIPLY           = 0x100000000ul,
    ID_LOGICAL_EQUAL      = 0x200000000ul,
    ID_MODIFIER_CAPATIALIZE = 0x400000000ul,
    ID_MODIFIER_INDENT      = 0x600000000ul,
    ID_MODIFIER_LOWER       = 0x800000000ul,
    ID_MODIFIER_UPPER       = 0x1000000000ul,
    ID_MODIFIER_TRUNCATE    = 0x2000000000ul,
    ID_MODIFIER_SPACIFY     = 0x4000000000ul,
    ID_MODIFIER_STRINGF_FORMAT = 0x8000000000ul,
    ID_MODIFIER_DATE_FORMAT    = 0x10000000000ul,
    ID_MODIFIER_ESCAPE         = 0x20000000000ul,
    ID_UNESCAPED_TEXT          = 0x40000000000ul,
    ID_INCLUDE_FILE            = 0x80000000000ul
};

#endif

/* OCTAL_LITERAL 0[0-7]*{ILEN}?
DECIMAL_LITERAL [1-9][0-9]*{ILEN}?
HEXDECIMAL_LITERAL 0[Xx][0-9a-fA-F]+{ILEN}?

FLOAT_LITERAL ([0-9]*\.[0-9]+|[0-9]+\.){EXP}?[flFL]?
SCI_LITERAL [0-9]+{EXP}[flFL]?

HEX_FLOAT 0[Xx]([0-9a-fA-F]*\.[0-9a-fA-F]+|[0-9a-fA-F]+\.?)[Pp][-+]?[0-9]+[flFL]?
CONST_CHAR \'([^'\\]|\\['"?\\abfnrtv]|\\[0-7]{1,3}|\\[Xx][0-9a-fA-F]+|{UCN})+\'
STRING_LITERAL L?\"([^"\\]|\\['"?\\abfnrtv]|\\[0-7]{1,3}|\\[Xx][0-9a-fA-F]+|{UCN})*\" */
