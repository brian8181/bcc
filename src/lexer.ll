%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

	#include <iostream>
	#include <cstdlib>
    #include "scanner.hpp"
	#include "driver.hpp"
	#include "parser.hpp"

	using namespace std;

	/* original yyterminate() macro returns int, since we're using Bison 3 variants
	as tokens, we must redefine it to change type from `int` to `Parser::semantic_type */

	#define yyterminate() xx::Parser::make_END(xx::location());
    #define end_of_file() xx::Parser::make_END_OF_FILE(xx::location());

    // #define delete_buffer() xx::Driver::make_DELETE_BUFFER(xx::location());
    // #define switch_to_buffer(x) xx::Driver::make_SWITCH_TO_BUFFER(xx::location());
    // #define current_buffer() xx::Driver::make_CURRENT_BUFFER(xx::location());
    // #define flush_buffer(x) xx::Driver::make_FLUSH_BUFFER(xx::location());
    // #define pop_buffer() xx::Driver::make_POP_BUFFER(xx::location());
    // #define push_buffer(x) xx::Driver::make_PUSH_BUFFER(xx::location());

	// this will track current scanner location.
	// action is called when length of the token is known.
	#define YY_USER_ACTION m_driver.increaseLocation(yyleng);

    /*
       The basic source character set consists of 96 characters:
       the space character, the control characters representing horizontal tab,
       vertical tab, form feed, and new-line, plus the following 91 graphical characters
          a b c d e f g h i j k l m n o p q r s t u v w x y z
          A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
          0 1 2 3 4 5 6 7 8 9
          _ { } [ ] # ( ) < > % : ; . ? * + - / ˆ & | ˜ ! = , \ " ’ \

    */
%}

%option nodefault
%option noyywrap
%option c++
%option yyclass="Scanner"
%option prefix="xx_"

VOID                   "void"
INT                    "int"
FLOAT                  "float"
CHAR                   "char"
ADDITION               "+"
SUBTRACTION            "-"
MULTIPLICATION         "*"
DIVISION               "/"
MODULUS                "%"
INCREMENT              "++"
DECREMENT              "--"
IF                     "if"
ELSE                   "else"
FOR                    "for"
WHILE                  "while"
DO                     "do"
BREAK                  "break"
CONTINUE               "continue"
SWITCH                 "switch"
CASE                   "case"
GOTO                   "goto"
DEFAULT                "default"
RETURN                 "return"
PRIVATE                "private"
PROTECTED              "protected"
PUBLIC                 "public"
INLINE                 "inline"
STATIC                 "static"
CONST                  "const"
UNSIGNED               "unsigned"
VOLATILE               "volatile"
REGISTER               "register"
RESTRICT               "restrict"
SEMI_COLON             ";"
COMMA                  ","
SINGLE_QUOTE           "'"
EQUALS                 "=="
EQUAL                  "="
ASSIGNMENT             "="
RIGHT_CURLY            "}"
LEFT_CURLY             "{"
LEFT_PAREN             "("
RIGHT_PAREN            ")"
LEFT_BRACE             "["
RIGHT_BRACE            "]"
BIT_NOT                "~"
BIT_AND                "&"
BIT_XOR                "^"
BIT_OR                 "|"
NOT                    "!"
AND                    "&&"
OR                     "||"
LESS_THAN              "<"
GREATER_THAN           ">"
SCOPE_RESOLUTION       "::"
DIRECT_MEMBER_SELECT   "\."
INDIRECT_MEMBER_SELECT "\-\>"
INDIRECT_TO_POINTER    "\-\>\*"
DIRECT_TO_POINTER      "\.\*"
NUMBER                 [-+]?[0-9]+
ID                     [a-zA-Z_][a-zA-Z0-9_]*
WHITE_SPACE            [ \t\n]
%x COMMENT
%x END_OF_FILE

%%

\\.*\n                      {
                                cout << "lexer: COMMENT [" << yytext << "]" << endl;
                            }
{EQUALS}                    {
                                cout << "lexer: EQUALS [" << yytext << "]" << endl;
                                return xx::Parser::make_EQUALS(yytext, xx::location( /* put location data here if you want */ ));
                            }
{EQUAL}                     {
                                ECHO;
                                REJECT; // REJECT FOR ASSIGNMENT
                            }
{ASSIGNMENT}                {
                                cout << "lexer: ASSIGNMENT [" << yytext << "]" << endl;
                                return xx::Parser::make_ASSIGNMENT(yytext, xx::location( /* put location data here if you want */ ));
                            }
{ADDITION}                  {
                                cout << "lexer: ADDITION [" << yytext << "]" << endl;
                                return xx::Parser::make_ADDITION(yytext, xx::location( /* put location data here if you want */ ));
                            }
{SUBTRACTION}               {
                                cout << "lexer: SUBTRACTION [" << yytext << "]" << endl;
                                return xx::Parser::make_SUBTRACTION(yytext, xx::location( /* put location data here if you want */ ));
                            }
{MULTIPLICATION}            {
                                cout << "lexer: MULTIPLICATION [" << yytext << "]" << endl;
                                return xx::Parser::make_MULTIPLICATION(yytext, xx::location( /* put location data here if you want */ ));
                            }
{DIVISION}                  {
                                cout << "lexer: DIVISION [" << yytext << "]" << endl;
                                return xx::Parser::make_DIVISION(yytext, xx::location( /* put location data here if you want */ ));
                            }
{COMMA}                     {
                                cout << "lexer: COMMA [" << yytext << "]" << endl;
                                return xx::Parser::make_COMMA(yytext, xx::location());
                            }
{LEFT_CURLY}                {
                                cout << "lexer: operator [" << yytext << "]" << endl;
                                return xx::Parser::make_LEFT_CURLY(yytext, xx::location( /* put location data here if you want */ ));
                            }
{RIGHT_CURLY}               {
                                cout << "lexer: operator [" << yytext << "]" << endl;
                                return xx::Parser::make_RIGHT_CURLY(yytext, xx::location( /* put location data here if you want */ ));
                            }
{LEFT_BRACE}                {
                                cout << "lexer: operator [" << yytext << "]" << endl;
                                return xx::Parser::make_LEFT_BRACE(yytext, xx::location( /* put location data here if you want */ ));
                            }
{RIGHT_BRACE}               {
                                cout << "lexer: operator [" << yytext << "]" << endl;
                                return xx::Parser::make_RIGHT_BRACE(yytext, xx::location( /* put location data here if you want */ ));
                            }
{LESS_THAN}                 {
                                cout << "lexer: operator [" << yytext << "]" << endl;
                                return xx::Parser::make_LESS_THAN(yytext, xx::location( /* put location data here if you want */ ));
                            }
{GREATER_THAN}              {
                                cout << "lexer: operator [" << yytext << "]" << endl;
                                return xx::Parser::make_GREATER_THAN(yytext, xx::location( /* put location data here if you want */ ));
                            }
{MODULUS}                   {
                                cout << "lexer: operator [" << yytext << "]" << endl;
                                return xx::Parser::make_MODULUS(yytext, xx::location( /* put location data here if you want */ ));
                            }
{SINGLE_QUOTE}              {
                                cout << "lexer: operator [" << yytext << "]" << endl;
                                return xx::Parser::make_SINGLE_QUOTE(yytext, xx::location( /* put location data here if you want */ ));
                            }
{LEFT_PAREN}                {
                                cout << "lexer: '('" << endl;
                                return xx::Parser::make_LEFT_PAREN(yytext, xx::location());
                            }
{RIGHT_PAREN}               {
                                cout << "lexer: ')'" << endl;
                                return xx::Parser::make_RIGHT_PAREN(yytext, xx::location());
                            }
{BIT_NOT}                   {
                                cout << "lexer: operator [" << yytext << "]" << endl;
                                return xx::Parser::make_BIT_NOT(yytext, xx::location( /* put location data here if you want */ ));
                            }
{BIT_AND}                   {
                                cout << "lexer: operator [" << yytext << "]" << endl;
                                return xx::Parser::make_BIT_AND(yytext, xx::location( /* put location data here if you want */ ));
                            }
{BIT_XOR}                   {
                                cout << "lexer: operator [" << yytext << "]" << endl;
                                return xx::Parser::make_BIT_XOR(yytext, xx::location( /* put location data here if you want */ ));
                            }
{BIT_OR}                    {
                                cout << "lexer: operator [" << yytext << "]" << endl;
                                return xx::Parser::make_BIT_OR(yytext, xx::location( /* put location data here if you want */ ));
                            }
{SCOPE_RESOLUTION}          {
                                cout << "lexer: operator [" << yytext << "]" << endl;
                                return xx::Parser::make_SCOPE_RESOLUTION(yytext, xx::location( /* put location data here if you want */ ));
                            }
{DIRECT_MEMBER_SELECT}      {
                                cout << "lexer: operator [" << yytext << "]" << endl;
                                return xx::Parser::make_DIRECT_MEMBER_SELECT(yytext, xx::location( /* put location data here if you want */ ));
                            }
{INDIRECT_MEMBER_SELECT}    {
                                cout << "lexer: operator [" << yytext << "]" << endl;
                                return xx::Parser::make_INDIRECT_MEMBER_SELECT(yytext, xx::location( /* put location data here if you want */ ));
                            }
{DIRECT_TO_POINTER}         {
                                cout << "lexer: operator [" << yytext << "]" << endl;
                                return xx::Parser::make_DIRECT_TO_POINTER(yytext, xx::location( /* put location data here if you want */ ));
                            }
{INDIRECT_TO_POINTER}       {
                                cout << "lexer: operator [" << yytext << "]" << endl;
                                return xx::Parser::make_INDIRECT_TO_POINTER(yytext, xx::location( /* put location data here if you want */ ));
                            }
{INCREMENT}                 {
                                cout << "lexer: operator [" << yytext << "]" << endl;
                                return xx::Parser::make_INCREMENT(yytext, xx::location( /* put location data here if you want */ ));
                            }
{DECREMENT}                 {
                                cout << "lexer: operator [" << yytext << "]" << endl;
                                return xx::Parser::make_DECREMENT(yytext, xx::location( /* put location data here if you want */ ));
                            }
{NOT}                       {
                                cout << "lexer: operator [" << yytext << "]" << endl;
                                return xx::Parser::make_NOT(yytext, xx::location( /* put location data here if you want */ ));
                            }
{AND}                       {
                                cout << "lexer: operator [" << yytext << "]" << endl;
                                return xx::Parser::make_AND(yytext, xx::location( /* put location data here if you want */ ));
                            }
{OR}                        {
                                cout << "lexer: operator [" << yytext << "]" << endl;
                                return xx::Parser::make_OR(yytext, xx::location( /* put location data here if you want */ ));
                            }
{INT}                       {
                                cout << "lexer: 'INT'" << endl;
                                return xx::Parser::make_INT(yytext, xx::location());
                            }
{FLOAT}                     {
                                cout << "lexer: 'FLOAT'" << endl;
                                return xx::Parser::make_FLOAT(yytext, xx::location());
                            }
{CHAR}                      {
                                cout << "lexer: 'CHAR'" << endl;
                                return xx::Parser::make_CHAR(yytext, xx::location());
                            }
{VOID}                      {
                                cout << "lexer: 'VOID'" << endl;
                                return xx::Parser::make_VOID(yytext, xx::location());
                            }
{RETURN}                    {
                                cout << "lexer: keyword [" << yytext << "]" << endl;
                                return xx::Parser::make_RETURN(yytext, xx::location( /* put location data here if you want */ ));
                            }
{IF}                        {
                                cout << "lexer: keyword [" << yytext << "]" << endl;
                                return xx::Parser::make_IF(yytext, xx::location( /* put location data here if you want */ ));
                            }
{ELSE}                      {
                               cout << "lexer: keyword : else [" << yytext << "]" << endl;
                               return xx::Parser::make_ELSE(yytext, xx::location( /* put location data here if you want */ ));
                            }
{DO}                        {
                               cout << "lexer: keyword [" << yytext << "]" << endl;
                               return xx::Parser::make_DO(yytext, xx::location( /* put location data here if you want */ ));
                            }
{WHILE}                     {
                               cout << "lexer: keyword [" << yytext << "]" << endl;
                               return xx::Parser::make_WHILE(yytext, xx::location( /* put location data here if you want */ ));
                            }
{FOR}                       {
                               cout << "lexer: keyword [" << yytext << "]" << endl;
                               return xx::Parser::make_FOR(yytext, xx::location( /* put location data here if you want */ ));
                            }
{CONTINUE}                  {
                               cout << "lexer: keyword [" << yytext << "]" << endl;
                               return xx::Parser::make_CONTINUE(yytext, xx::location( /* put location data here if you want */ ));
                            }
{SWITCH}                    {
                               cout << "lexer: keyword [" << yytext << "]" << endl;
                               return xx::Parser::make_SWITCH(yytext, xx::location( /* put location data here if you want */ ));
                            }
{CASE}                      {
                               cout << "lexer: keyword [" << yytext << "]" << endl;
                               return xx::Parser::make_CASE(yytext, xx::location( /* put location data here if you want */ ));
                            }
{BREAK}                     {
                               cout << "lexer: keyword [" << yytext << "]" << endl;
                               return xx::Parser::make_BREAK(yytext, xx::location( /* put location data here if you want */ ));
                            }
{GOTO}                      {
                               cout << "lexer: keyword [" << yytext << "]" << endl;
                               return xx::Parser::make_GOTO(yytext, xx::location( /* put location data here if you want */ ));
                            }
{DEFAULT}                   {
                               cout << "lexer: keyword [" << yytext << "]" << endl;
                               return xx::Parser::make_DEFAULT(yytext, xx::location( /* put location data here if you want */ ));
                            }
{PRIVATE}                   {
                               cout << "lexer: keyword [" << yytext << "]" << endl;
                               return xx::Parser::make_PRIVATE(yytext, xx::location( /* put location data here if you want */ ));
                            }
{PROTECTED}                 {
                               cout << "lexer: keyword [" << yytext << "]" << endl;
                               return xx::Parser::make_PROTECTED(yytext, xx::location( /* put location data here if you want */ ));
                            }
{PUBLIC}                    {
                               cout << "lexer: keyword [" << yytext << "]" << endl;
                               return xx::Parser::make_PUBLIC(yytext, xx::location( /* put location data here if you want */ ));
                            }
{INLINE}                    {
                               cout << "lexer: keyword [" << yytext << "]" << endl;
                               return xx::Parser::make_INLINE(yytext, xx::location( /* put location data here if you want */ ));
                            }
{STATIC}                    {
                                cout << "lexer: keyword [" << yytext << "]" << endl;
                                return xx::Parser::make_STATIC(yytext, xx::location( /* put location data here if you want */ ));
                            }
{CONST}                     {
                                cout << "lexer: keyword [" << yytext << "]" << endl;
                                return xx::Parser::make_CONST(yytext, xx::location( /* put location data here if you want */ ));
                            }
{UNSIGNED}                  {
                                cout << "lexer: keyword [" << yytext << "]" << endl;
                                return xx::Parser::make_UNSIGNED(yytext, xx::location( /* put location data here if you want */ ));
                            }
{VOLATILE}                  {
                                cout << "lexer: keyword [" << yytext << "]" << endl;
                                return xx::Parser::make_VOLATILE(yytext, xx::location( /* put location data here if you want */ ));
                            }
{REGISTER}                  {
                                cout << "lexer: keyword [" << yytext << "]" << endl;
                                return xx::Parser::make_REGISTER(yytext, xx::location( /* put location data here if you want */ ));
                            }
{RESTRICT}                  {
                                cout << "lexer: keyword [" << yytext << "]" << endl;
                                return xx::Parser::make_RESTRICT(yytext, xx::location( /* put location data here if you want */ ));
                            }
{NUMBER}                    {
                                cout << "lexer: NUMBER [" << yytext << "]" << endl;
                                return xx::Parser::make_NUMBER(yytext, xx::location( /* put location data here if you want */ ));
                            }
{ID}                        {
                                cout << "lexer: ID [" << yytext << "]" << endl;
                                return xx::Parser::make_ID(yytext, xx::location( /* put location data here if you want */ ));
                            }
{SEMI_COLON}                {
                                cout << "lexer: SEMI_COLON [" << yytext << "]" << endl;
                                return xx::Parser::make_SEMI_COLON(yytext, xx::location( /* put location data here if you want */ ));
                            }
{WHITE_SPACE}               {
                                /*ignore white space*/
                            }

#.* ;
"--"[ \t].* ;
"/*"                        { BEGIN COMMENT; cout << "lexer: BEGIN COMMENT" << endl; }
<COMMENT>"*/"               { BEGIN YY_START; cout << "lexer: END COMMENT" << endl; }
<COMMENT>.|\n ;
<INITIAL><<EOF>>            {
                                cout << "lexer: <<EOF>>" << endl;
                                if(m_driver.get_current_index())
                                {
                                    cout << "lexer: END!" << endl;
                                    m_driver.get_next_stream();
                                    return xx::Parser::make_END(xx::location(/* put location data here if you want */ ));
                                }
                                else
                                {
                                    cout << "lexer: <INITIAL><<EOF>>" << endl;
                                    return xx::Parser::make_END_OF_FILES(yytext, xx::location( /* put location data here if you want */ ));
                                }
                            }
<END_OF_FILE><<EOF>>        {
                                cout << "lexer: <END_OF_FILE><<EOF>>" << endl;
                            }
.                           {   cout << "lexer: unknown character [" << yytext << "]" << endl; }
%%

#ifdef MAIN
int yywrap(void)
{
    return 1;
}

/* int main(int argc, char** argv)
{
    if ( argc > 1 )
    {
        yyin = fopen( argv[1], "r" );
    }
    else
    {
        yyin = stdin;
    }
    yylex();
} */



}
#endif
