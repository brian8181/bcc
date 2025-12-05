%{

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include "parser.tab.h"

extern char *yytext;
extern YYSTYPE yylval;
extern int yylineno;
int fileno(FILE *);

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
DOUBLE_QUOTE           "\""
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
COUT                   "<<"
NUMBER                 [-+]?[0-9]+
ID                     [a-zA-Z_][a-zA-Z0-9_]*
WHITE_SPACE            [ \t\n]
%x STRING
%x COMMENT
%x LOG

%%

{EQUALS}                    {
                                ECHO;
                                printf( "lexer: EQUALS: [ %s ]\n", yytext);
                                return EQUALS;
                            }
{EQUAL}                     {
                                ECHO;
                                REJECT; // REJECT FOR ASSIGNMENT
                                // printf( "lexer: ASSIGNMENT: [ %s ]\n", yytext);
                                // return ASSIGNMENT;
                            }
{ASSIGNMENT}                {
                                ECHO;
                                printf( "lexer: ASSIGNMENT: [ %s ]\n", yytext);
                                return ASSIGNMENT;
                            }
{ADDITION}                  {
                                printf( "lexer: ADDITION [ %s ]\n", yytext);
                                return ADDITION;
                            }
{SUBTRACTION}               {
                                printf( "lexer: SUBTRACTION [ %s ]\n", yytext);
                                return SUBTRACTION;
                            }
{MULTIPLICATION}            {
                                printf( "lexer: MULTIPLICATION [ %s ]\n", yytext);
                                return MULTIPLICATION;
                            }
{DIVISION}                  {
                                printf( "lexer: DIVISION [ %s ]\n", yytext);
                                return DIVISION;
                            }
{COMMA}                     {
                                printf( "lexer: [ %s ]\n", yytext);
                                return COMMA;
                            }
{LEFT_CURLY}                {
                                printf( "lexer: [ %s ]\n", yytext);
                                return LEFT_CURLY;
                            }
{RIGHT_CURLY}               {
                                printf( "lexer: [ %s ]\n", yytext);
                                return RIGHT_CURLY;
                            }
{LEFT_BRACE}                {
                                printf( "lexer: [ %s ]\n", yytext);
                                return LEFT_BRACE;
                            }
{RIGHT_BRACE}               {
                                printf( "lexer: [ %s ]\n", yytext);
                                return RIGHT_BRACE;
                            }
{LESS_THAN}                 {
                                printf( "lexer: [ %s ]\n", yytext);
                                return LESS_THAN;
                            }
{GREATER_THAN}              {
                                printf( "lexer: [ %s ]\n", yytext);
                                return GREATER_THAN;
                            }
{MODULUS}                   {
                                printf( "lexer: [ %s ]\n", yytext);
                                return MODULUS;
                            }
{SINGLE_QUOTE}              {
                                printf( "lexer: [ %s ]\n", yytext);
                                return SINGLE_QUOTE;
                            }
{LEFT_PAREN}                {
                                printf( "lexer: [ %s ]\n", yytext);
                                return LEFT_PAREN;
                            }
{RIGHT_PAREN}               {
                                printf( "lexer: [ %s ]\n", yytext);
                                return RIGHT_PAREN;
                            }
{BIT_NOT}                   {
                                printf( "lexer: operator: [ %s ]\n", yytext );
                                return BIT_NOT;
                            }
{BIT_AND}                   {
                                printf( "lexer: operator: [ %s ]\n", yytext );
                                return BIT_AND;
                            }
{BIT_XOR}                   {
                                printf( "lexer: operator: [ %s ]\n", yytext );
                                return BIT_XOR;
                            }
{BIT_OR}                    {
                                printf( "lexer: operator: [ %s ]\n", yytext );
                                return BIT_OR;
                            }
{SCOPE_RESOLUTION}          {
                                printf( "lexer: operator: [ %s ]\n", yytext );
                                return SCOPE_RESOLUTION;
                            }
{DIRECT_MEMBER_SELECT}      {
                                printf( "lexer: operator: [ %s ]\n", yytext );
                                return DIRECT_MEMBER_SELECT;
                            }
{INDIRECT_MEMBER_SELECT}    {
                                printf( "lexer: operator: [ %s ]\n", yytext );
                                return INDIRECT_MEMBER_SELECT;
                            }
{DIRECT_TO_POINTER}         {
                                printf( "lexer: operator: [ %s ]\n", yytext );
                                return DIRECT_TO_POINTER;
                            }
{INDIRECT_TO_POINTER}       {
                                printf( "lexer: operator: [ %s ]\n", yytext );
                                return INDIRECT_TO_POINTER;
                            }
{INCREMENT}                 {
                                printf( "lexer: operator: [ %s ]\n", yytext );
                                return INCREMENT;
                            }
{DECREMENT}                 {
                                printf( "lexer: operator: [ %s ]\n", yytext );
                                return DECREMENT;
                            }
{NOT}                       {
                                printf( "lexer: operator: [ %s ]\n", yytext );
                                return NOT;
                            }
{AND}                       {
                                printf( "lexer: operator: [ %s ]\n", yytext );
                                return AND;
                            }
{OR}                        {
                                printf( "lexer: operator: [ %s ]\n", yytext );
                                return OR;
                            }
{INT}                       {
                                printf( "lexer: INT: [ %s ]\n", yytext);
                                return INT;
                            }
{FLOAT}                     {
                                printf( "lexer: FLOAT: [ %s ]\n", yytext);
                                return FLOAT;
                            }
{CHAR}                      {
                                printf( "lexer: CHAR: [ %s ]\n");
                                return CHAR;
                            }
{VOID}                      {
                                printf( "lexer: VOID\n");
                                return VOID;
                            }
{RETURN}                    {
                                printf("lexer: keyword [ %s ]\n", yytext);
                                return RETURN;
                            }
{IF}                        {
                                printf("lexer: keyword [ %s ]\n", yytext);
                                return IF;
                            }
{ELSE}                      {
                               printf( "lexer: keyword : [ %s ]\n", yytext);
                               return ELSE;
                            }
{DO}                        {
                               printf("lexer: keyword [ %s ]\n", yytext);
                               return DO;
                            }
{WHILE}                     {
                               printf("lexer: keyword [ %s ]\n", yytext);
                               return WHILE;
                            }
{FOR}                       {
                               printf("lexer: keyword [ %s ]\n", yytext);
                               return FOR;
                            }
{CONTINUE}                  {
                               printf("lexer: keyword [ %s ]\n", yytext);
                               return CONTINUE;
                            }
{SWITCH}                    {
                               printf("lexer: keyword [ %s ]\n", yytext);
                               return SWITCH;
                            }
{CASE}                      {
                               printf("lexer: keyword [ %s ]\n", yytext);
                               return CASE;
                            }
{BREAK}                     {
                               printf("lexer: keyword [ %s ]\n", yytext);
                               return BREAK;
                            }
{GOTO}                      {
                               printf("lexer: keyword [ %s ]\n", yytext);
                               return GOTO;
                            }
{DEFAULT}                   {
                               printf("lexer: keyword [ %s ]\n", yytext);
                               return DEFAULT;
                            }
{PRIVATE}                   {
                               printf("lexer: keyword [ %s ]\n", yytext);
                               return PRIVATE;
                            }
{PROTECTED}                 {
                               printf("lexer: keyword [ %s ]\n", yytext);
                               return PROTECTED;
                            }
{PUBLIC}                    {
                               printf("lexer: keyword [ %s ]\n", yytext);
                               return PUBLIC;
                            }
{INLINE}                    {
                               printf("lexer: keyword [ %s ]\n", yytext);
                               return INLINE;
                            }
{STATIC}                    {
                                printf("lexer: keyword [ %s ]\n", yytext);
                                return STATIC;
                            }
{CONST}                     {
                                printf("lexer: keyword [ %s ]\n", yytext);
                                return CONST;
                            }
{UNSIGNED}                  {
                                printf("lexer: keyword [ %s ]\n", yytext);
                                return UNSIGNED;
                            }
{VOLATILE}                  {
                                printf("lexer: keyword [ %s ]\n", yytext);
                                return VOLATILE;
                            }
{REGISTER}                  {
                                printf("lexer: keyword [ %s ]\n", yytext);
                                return REGISTER;
                            }
{RESTRICT}                  {
                                printf("lexer: keyword [ %s ]\n", yytext);
                                return RESTRICT;
                            }
{NUMBER}                    {
                                printf( "lexer: NUMBER\n");
                                printf("lexer [ %s ]\n", yytext);
                                return NUMBER;
                            }
{ID}                        {
                                printf( "lexer: ID\n");
                                printf("lexer: ID: [ %s ]\n", yytext);
                                return ID;
                            }
{SEMI_COLON}                {
                                printf("lexer: SEMI_COLON: [ %s ]\n", yytext);
                                return SEMI_COLON;
                            }
#.* ;
"--"[ \t].* ;
{DOUBLE_QUOTE}              { BEGIN STRING; }
<STRING>[^"]* ;             // todo
{COUT}[ ]?                  { BEGIN LOG; }
<LOG>[^;]*                  { printf("%s\n", yytext); }
<LOG>{SEMI_COLON}           { BEGIN INITIAL; }
"/*"                        { BEGIN COMMENT; printf("lexer: BEGIN C COMMENT\n"); }
<COMMENT>"*/"               { BEGIN INITIAL; printf("lexer: END C COMMENT\n"); }
<COMMENT>.|\n ;
{WHITE_SPACE}               {
                                /*ignore white space*/
                            }
<<EOF>>                     {
                                static int end = 0;
                                end = 1;
                                printf( "lexer: <<EOF>>\n");
                                // if(!end)
                                //     return END;
                                return END_OF_FILES;
                            }
.                           {   printf( "lexer: unknown character: [ %s ]\n", yytext); }
%%

int yywrap(void)
{
    return 1;
}

#ifdef MAIN
int main(int argc, char** argv)
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
}
#endif

#ifdef MAIN2

static int process (const char *file)
{
    int is_stdin = !file || (strcmp (file, "-") == 0);
    if (is_stdin)
    {
        input = stdin;
    }
    else
    {
        input = fopen (file, "r");
    }

    assert (input);
    int status = yyparse ();
    if (!is_stdin)
    {
        fclose (input);
    }

    return status;
}

int main (int argc, char **argv)
{
    if (getenv ("YYDEBUG"))
        yydebug = 1;

    int ran = 0;
    for (int i = 1; i < argc; ++i)
    {
        // Enable parse traces on option -p.
        if (strcmp (argv[i], "-p") == 0)
        {
            yydebug = 1;
        }
        else
        {
            int status = process (argv[i]);
            ran = 1;
            if (!status)
                return status;
        }
    }

    if (!ran)
    {
        int status = process (NULL);
        if (!status)
            return status;
    }

    return 0;
}
#endif

#ifdef MULTIPLE_FILE
/* flex example multiple file/buffers */

/* the "incl" state is used for picking up the name
* of an include file
*/
%x incl
%{
    #define MAX_INCLUDE_DEPTH 10
    YY_BUFFER_STATE include_stack[MAX_INCLUDE_DEPTH];
    int include_stack_ptr = 0;
%}
%%
include         BEGIN(incl);

[a-z]+          ECHO;

[^a-z\n]*\n?    ECHO;

<incl>[ \t]*    /* eat the whitespace */

<incl>[^ \t\n]+
        {
            /* got the include file name */
            if ( include_stack_ptr >= MAX_INCLUDE_DEPTH )
            {
                fprintf( stderr, "Includes nested too deeply" );
                exit( 1 );
            }

            include_stack[include_stack_ptr++] =
            YY_CURRENT_BUFFER;
            yyin = fopen( yytext, "r" );
            if ( ! yyin )
            error( ... );
            yy_switch_to_buffer( yy_create_buffer( yyin, YY_BUF_SIZE ) );
            BEGIN(INITIAL);
        }
<<EOF>> {
            if ( --include_stack_ptr < 0 )
            {
                yyterminate();
            }
            else
            {
                yy_delete_buffer( YY_CURRENT_BUFFER );
                yy_switch_to_buffer(
                include_stack[include_stack_ptr] );
            }
        }

#endif
