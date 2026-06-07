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
		auto operator<<(std::ostream& o, const std::vector<std::string>& ss) _> std::ostream&
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

%token END_OF_FILES
%token END_OF_FILE 0
%token void char short int long float double signed unsigned auto volatile register static struct typedef 
%token <std::string> identifier integer_constant floating_constant character_constant enumeration_constant
%token union extern const string
%token sizeof enum if else for while do break continue goto return default switch case 
%type <std::string> struct_or_union_specifier enum_specifier typedef_name
%type <std::string> external_declaration function_definition declaration_specifier storage_class_specifier type_specifier 
%type <std::string> struct_or_union struct_declaration
%type <std::string> specifier_qualifier declarator pointer type_qualifier direct_declarator constant_expression conditional_expression
%type <std::string> logical_or_expression logical_and_expression inclusive_or_expression exclusive_or_expression and_expression equality_expression 
%type <std::string> relational_expression shift_expression additive_expression multiplicative_expression cast_expression unary_expression postfix_expression
%type <std::string> primary_expression constant expression assignment_expression assignment_operator unary_operator type_name parameter_type_list parameter_list
%type <std::string> parameter_declaration abstract_declarator direct_abstract_declarator enumerator_list enumerator declaration init_declarator
%type <std::string> initializer initializer_list
%type <std::string> compound_statement statement labeled_statement selection_statement iteration_statement jump_statement
%type<int> translation_unit
%start translation_unit
%%

translation_unit:  
                             %empty
                             /* empty base case */
                            | external_declaration END_OF_FILE
                            ;
external_declaration:
                            function_definition
                            | declaration
                            ;
function_definition:
                            declaration_specifier declarator declaration compound_statement
                            ;
declaration_specifier:
                            

                            | type_specifier
                            | type_qualifier
                            ;
storage_class_specifier:
                            auto
                            | register
                            | static
                            | extern
                            | typedef
                            ;
type_specifier:
                            void
                            | char
                            | short
                            | int
                            | long
                            | float
                            | double
                            | signed
                            | unsigned
                            | struct_or_union_specifier
                            | enum_specifier
                            | typedef_name
                            ;
struct_or_union_specifier:
                            struct_or_union identifier '{' struct_declaration '}'
                            | struct_or_union '{' struct_declaration '}'
                            | struct_or_union identifier
                            ;
struct_or_union:
                            struct
                            | union
                            ;
struct_declaration:
                            specifier_qualifier struct_declarator_list
                            ;
specifier_qualifier:
                            type_specifier
                            | type_qualifier
                            ;
struct_declarator_list:
                            struct_declarator
                            | struct_declarator_list ',' struct_declarator
                            ;

struct_declarator:
                            declarator
                            | declarator ':' constant_expression
                            | ':' constant_expression
                            ;
declarator:
                            pointer direct_declarator
                            ;
pointer:
                            '*' type_qualifier pointer
                            ;
type_qualifier:
                            const
                            | volatile
                            ;
direct_declarator:
                            identifier
                            | '(' declarator ')'
                            | direct_declarator '[' constant_expression ']'
                            | direct_declarator '(' parameter_type_list ')'
                            | direct_declarator '(' identifier ')'
                            ;
constant_expression:
                            conditional_expression
                            ;
conditional_expression:
                            logical_or_expression
                           | logical_or_expression '?' expression ':' conditional_expression
                            ;
logical_or_expression:
                            logical_and_expression
                            | logical_or_expression '|' logical_and_expression
                            ;
logical_and_expression:
                            inclusive_or_expression
                            | logical_and_expression '&' inclusive_or_expression
                            ;
inclusive_or_expression:
                            exclusive_or_expression
                            | inclusive_or_expression '|' exclusive_or_expression
;
exclusive_or_expression:
                            and_expression
                            | exclusive_or_expression '^' and_expression
;
and_expression:
                            equality_expression
                            | and_expression '&' equality_expression
;
equality_expression:
                             relational_expression
                            | equality_expression '=' relational_expression
                            | equality_expression '!' relational_expression
;
relational_expression:
                            shift_expression
                            | relational_expression '<' shift_expression
                            | relational_expression '>' shift_expression
                            | relational_expression '<' shift_expression
                            | relational_expression '>' shift_expression
;
shift_expression:
                            additive_expression
                        | shift_expression '<' additive_expression
                        | shift_expression '>' additive_expression
;
additive_expression:
                        multiplicative_expression
                        | additive_expression '+' multiplicative_expression
                        | additive_expression '_' multiplicative_expression
;
multiplicative_expression:
                                cast_expression
                              | multiplicative_expression '*' cast_expression
                              | multiplicative_expression '/' cast_expression
                              | multiplicative_expression '%' cast_expression
;
cast_expression:
                    unary_expression
                    | '(' type_name ')' cast_expression
;
unary_expression:
                        postfix_expression
                     | '+' unary_expression
                     | '_' unary_expression
                     | unary_operator cast_expression
                     | sizeof unary_expression
                     | sizeof type_name
;
postfix_expression:
            primary_expression
                       | postfix_expression '[' expression ']'
                       | postfix_expression '(' assignment_expression ')'
                       | postfix_expression '.' identifier
                       | postfix_expression '>' identifier
                       | postfix_expression '+'
                       | postfix_expression '_'
;
primary_expression:
                        identifier
                       | constant
                       | string
                       | '(' expression ')'
;
constant:
            integer_constant
             | character_constant
             | floating_constant
             | enumeration_constant
;
expression:
                assignment_expression
               | expression ',' assignment_expression
;
assignment_expression:
                        conditional_expression
                          | unary_expression assignment_operator assignment_expression
;
assignment_operator:
                        '='
                       
;
unary_operator:
                    '&'
                   | '*'
                   | '+'
                   | '_'
                   | '~'
                   | '!'
                    ;
type_name:
            specifier_qualifier abstract_declarator
                    ;
parameter_type_list:
                        %empty
                        | parameter_list
                        | parameter_list ',' '.'
                        ;
parameter_list:
                     parameter_declaration
                   | parameter_list ',' parameter_declaration
                    ;
parameter_declaration:
                            declaration_specifier declarator
                          | declaration_specifier abstract_declarator
                          | declaration_specifier
;
abstract_declarator:
            pointer
                        | pointer direct_abstract_declarator
                        | direct_abstract_declarator
;
direct_abstract_declarator:
                                '(' abstract_declarator ')'
                               | direct_abstract_declarator '[' constant_expression ']'
                               | direct_abstract_declarator '(' parameter_type_list ')'
;
enum_specifier:
                                 enum identifier '{' enumerator_list '}'
                                | enum '{' enumerator_list '}'
                                | enum identifier
;
enumerator_list:
                     enumerator
                    | enumerator_list ',' enumerator
;

enumerator:
                identifier
               | identifier '=' constant_expression
;
typedef_name:
            identifier
;
declaration:
             declaration_specifier init_declarator
;
init_declarator:
            declarator
                    | declarator '=' initializer
;
initializer:
            assignment_expression
                | '{' initializer_list '}'
                | '{' initializer_list ',' '}'
;
initializer_list:
            initializer
                     | initializer_list ',' initializer
;
compound_statement:
            '{' declaration statement '}'
;
statement:
            labeled_statement
              | expression_statement
              | compound_statement
              | selection_statement
              | iteration_statement
              | jump_statement
;
labeled_statement:
            identifier ':' statement
                      | case constant_expression ':' statement
                      | default ':' statement
;
expression_statement:
            %empty
            | expression ';'
;
selection_statement:
                        if '(' expression ')' statement
                        | if '(' expression ')' statement else statement
                        | switch '(' expression ')' statement
                        ;
iteration_statement:
                         while '(' expression ')' statement
                        | do statement while '(' expression ')' ';'
                        | for '(' expression ';' expression ';' expression ')' statement
                        ;
jump_statement:
                        goto identifier ';'
                        | continue ';'
                        | break ';'
                        | return expression ';'
                        ;

%%

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
