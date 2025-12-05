    %skeleton "lalr1.cc" /* -*- C++ -*- */
    %require "3.2"
    %defines
    %define api.parser.class { Parser }

    %define api.token.constructor
    %define api.value.type variant
    %define parse.assert
    %define api.namespace { xx }

    %code requires
    {
        #include <iostream>
        #include <string>
        #include <vector>
        #include <list>
        #include <sstream> // For std::stringstream
        #include <stdint.h>
        #include "utility.hpp"
        #include "symbols.hpp"
        #include "stack.hpp"
        #include "scope.hpp"
        #include "add_op.hpp"
        #include "binary_op.hpp"
        #include "Stmt.hpp"
        //#include "oper.hpp"

        namespace xx {
            class Scanner;
            class Driver;
        }


    }

    // bison calls yylex() function that must be provided by us to suck tokens
    // from the scanner, this block will be placed at the beginning of IMPLEMENTATION file (cpp)
    // we define this function here (function! not method)
    // this function is called only inside bison, so we make it static to limit //core::symbol visibility for the linker
    // to avoid potential linking conflicts
    %code top
    {
        #include "parser.hpp"
        #include "driver.hpp"
        #include "location.hh"
        #include "scanner.hpp"
        #include "scope.hpp"
        #include "stack.hpp"

        std::string get_symbol_value(const std::string& sym);
        //std::string assign_symbol_value(const std::string& sym1, const std::string& sym2);
        std::string add(const std::string& str1, const std::string& str2);
        std::string subtract(const std::string& str1, const std::string& str2);
        std::string multiply(const std::string& str1, const std::string& str2);
        std::string divide(const std::string& str1, const std::string& str2);
        std::string modulo(const std::string& str1, const std::string& str2);

        // yylex() arguments are defined in parser.y
        static xx::Parser::symbol_type yylex(xx::Scanner &scanner, xx::Driver &driver)
        {
            return scanner.get_next_token();
        }

        // you can accomplish the same thing by inlining the code using preprocessor
        // x and y are same as in above static function
        // #define yylex(x, y) scanner.get_next_token()

        using namespace xx;
        using namespace std;


        list<string> Stmts_list;
    }

    %lex-param { xx::Scanner &scanner }
    %lex-param { xx::Driver &driver }
    %parse-param { xx::Scanner &scanner }
    %parse-param { xx::Driver &driver }
    %locations
    %define parse.trace
    %define parse.error verbose
    %define api.token.prefix {TOKEN_}

    %token END 0
    %token <std::string> COMMA "COMMA"
    %token <std::string> RIGHT_PAREN "RIGHT_PAREN"
    %token <std::string> LEFT_PAREN "LEFT_PAREN"
    %token <std::string> RIGHT_BRACE "RIGHT_BRACE"
    %token <std::string> LEFT_BRACE "LEFT_BRACE"
    %token <std::string> LEFT_CURLY "LEFT_CURLY"
    %token <std::string> RIGHT_CURLY "RIGHT_CURLY"

    %token <std::string> INCLUDE "INCLUDE"
    %token <std::string> DEFINE "DEFINE"
    %token <std::string> IFDEF "IFDEF"
    %token <std::string> IFNDEF "IFNDEF"
    %token <std::string> ENDIF "ENDIF"
    %token <std::string> PRAGMA "PRAGMA"

    %token <std::string> USING "USING"
    %token <std::string> NAMESPACE "NAMESPACE"

    %token <std::string> INT "INT"
    %token <std::string> SHORT "SHORT"
    %token <std::string> LONG "LONG"
    %token <std::string> LONGLONG "LONGLONG"
    %token <std::string> DOUBLE "DOUBLE"
    %token <std::string> LONGDOUBLE "LONGDOUBLE"
    %token <std::string> SINGLE "SINGLE"
    %token <std::string> FLOAT "FLOAT"
    %token <std::string> CHAR "CHAR"
    %token <std::string> VOID "VOID"

    %token <std::string> ENUM "ENUM"
    %token <std::string> UNION "UNION"
    %token <std::string> CLASS "CLASS"
    %token <std::string> STRUCT "STRUCT"
    %token <std::string> TEMPLATE "TEMPLATE"
    %token <std::string> TYPENAME "TYPENAME"
    %token <std::string> REFERENCE "REFERENCE"
    %token <std::string> POINTER "POINTER"

    %token <std::string> NUMBER "NUMBER"
    %token <std::string> ID "IDENTIFIER"
    %token <std::string> STRING_LITERAL "STRING_LITERAL"

    %token <std::string> STATIC "STATIC"
    %token <std::string> CONST "CONST"
    %token <std::string> UNSIGNED "UNSIGNED"
    %token <std::string> SIGNED "SIGNED"
    %token <std::string> VOLATILE "VOLATILE"
    %token <std::string> MUTABLE "MUTABLE"
    %token <std::string> REGISTER "REGISTER"
    %token <std::string> RESTRICT "RESTRICT"
    %token <std::string> INLINE "INLINE"
    %token <std::string> SHIFT_LEFT "SHIFT_LEFT"
    %token <std::string> SHIFT_RIGHT "SHIFT_RIGHT"
    %token <std::string> MODULUS "MODULUS"
    %token <std::string> NOT "NOT"
    %token <std::string> AND "AND"
    %token <std::string> OR "OR"
    %token <std::string> BIT_AND "BIT_AND"
    %token <std::string> BIT_OR "BIT_OR"
    %token <std::string> BIT_XOR "BIT_XOR"
    %token <std::string> BIT_NOT "BIT_NOT"
    %token <std::string> EQUALS "equals"
    %token <std::string> LESS_THAN "less than"
    %token <std::string> GREATER_THAN "greater than"
    %token <std::string> COLON "colon"
    %token <std::string> DOUBLE_QUOTE "double quote"
    %token <std::string> SINGLE_QUOTE "single quote"
    %token <std::string> QUESTION_MARK "question mark"
    %token <std::string> DOT "dot"
    %token <std::string> AT_SYMBOL "at symbol"
    %token <std::string> PRIVATE "private"
    %token <std::string> PROTECTED "protected"
    %token <std::string> PUBLIC "public"
    %token <std::string> ADDRESS_OF "address of"
    %token <std::string> SCOPE_RESOLUTION "scope resolution"
    %token <std::string> DIRECT_TO_POINTER "direct to pointer"
    %token <std::string> INDIRECT_TO_POINTER "indirect to pointer"
    %token <std::string> DIRECT_MEMBER_SELECT "direct member select"
    %token <std::string> INDIRECT_MEMBER_SELECT "indirect member select"

    %token <std::string> IF "if"
    %token <std::string> ELSE "else"
    %token <std::string> FOR "for"
    %token <std::string> DO "do"
    %token <std::string> WHILE "while"
    %token <std::string> CONTINUE "continue"
    %token <std::string> BREAK "break"
    %token <std::string> SWITCH "switch"
    %token <std::string> CASE "case"
    %token <std::string> GOTO "goto"
    %token <std::string> LABEL "LABEL"
    %token <std::string> DEFAULT "default"
    %token <std::string> RETURN "return"

    %token <std::string> ASSIGNMENT "assignment"
    %token <std::string> LSHIFT "left shift"
    %token <std::string> RSHIFT "right shift"
    %token <std::string> INCREMENT "increment"
    %token <std::string> DECREMENT "decrement"
    %token <std::string> ADD_ASSIGN "add assignment"
    %token <std::string> SUB_ASSIGN "subtract assignment"
    %token <std::string> MULT_ASSIGN "multiply assignment"
    %token <std::string> DIV_ASSIGN "divide assignment"
    %token <std::string> MOD_ASSIGN "modulus assignment"
    %token <std::string> BIT_AND_ASSIGN "bitwise and assignment"
    %token <std::string> BIT_OR_ASSIGN "bitwise or assignment"
    %token <std::string> BIT_XOR_ASSIGN "bitwise xor assignment"
    %token <std::string> BIT_NOT_ASSIGN "bitwise not assignment"
    %token <std::string> LSHIFT_ASSIGN "left shift assignment"
    %token <std::string> RSHIFT_ASSIGN "right shift assignment"
    %token <std::string> SIZEOF "sizeof"
    %token <std::string> DELETE "delete"
    %token <std::string> CONST_CAST "const_cast"
    %token <std::string> DYNAMIC_CAST "dynamic_cast"
    %token <std::string> STATIC_CAST "static_cast"
    %token <std::string> REINTERPRET_CAST "reinterpret_cast"
    %token <std::string> END_OF_FILE "end_of_file"
    %token <std::string> END_OF_FILES "end_of_files"

    %type <std::string> scopes "scopes"
    %type <std::string> scope "scope"
    %type <std::string> type_name "type_name"
    %type <std::string> type_modifier "type_modifier"
    %type <std::string> pointer_to_member "pointer_to_member"
    %type <std::string> member_select "member_select"
    %type <std::string> flow_control "flow_control"
    %type <std::string> if_statement "if_statement"
    %type <std::string> if_else_statement "if__else_statement"
    %type <std::string> for_statement "for_statement"
    %type <std::string> access_specifier "access_specifier"
    %type <std::string> expr "expr"
    %type <Symbol*> function "function"
    %type <Symbol*> declaration "declaration"
    %type <std::string> statement "statement"
    %type <std::string> statements "statements"
    %type <std::string> block "block"
    %type <std::string> file "file"
    %type <std::string> files "files"
    %type <std::string> comments "comments"
    %type <std::string> comment "comment"
    %left <std::string> SUBTRACTION "subtraction"
    %left <std::string> ADDITION "addition"
    %left <std::string> DIVISION "division"
    %left <std::string> MULTIPLICATION "multiplication"
    %token <std::string> SEMI_COLON "SEMI_COLON"
    %start program

    %%

    program:
        files END_OF_FILES                                              { cout << "parser:program: files END_OF_FILES" << endl; exit(0); };

    files:
        file                                                            { cout << "parser:files: file" << endl; };
        | files file                                                    { cout << "parser:files: files file" << endl; };

    file:
        scopes  END                                                     {
                                                                            cout << "parser:file: scopes END" << endl;
                                                                            $$ = $1;
                                                                        }
        | block END                                                     {
                                                                            cout << "parser:file: statements END" << endl;
                                                                            $$ = $1;
                                                                        }
        | file scopes                                                   {
                                                                            cout << "parser:file: scopes" << endl;
                                                                            $$ = $1;
                                                                        }
        | file block                                                    {
                                                                            cout << "parser:file: statements" << endl;
                                                                            $$ = $1;
                                                                        };

    scopes:
        scope                                                           {
                                                                            cout << "parser:scopes scope : " << endl;
                                                                            $$ = $1;
                                                                        }
        | scopes scope                                                  {
                                                                            cout << "parser:scopes scopes scope" << endl;
                                                                            $$ = $1;
                                                                        };

    scope:
        block                                                           {
                                                                            cout << "parser:scope statements : " << endl;
                                                                            $$ = $1;
                                                                        }
        | LEFT_CURLY block RIGHT_CURLY                                  {
                                                                            cout << "parser:scope: LEFT_CURLY statements RIGHT_CURLY : statements="  << $2 <<  endl;
                                                                            $$ = $2;
                                                                        };

    block:
       statement                                                       {
                                                                            cout << "parser:statements: statement : " << $1 << endl;
                                                                            Stmts_list.push_front($1);
                                                                            //$$ = Stmts_list;
                                                                            $$ = $1;
                                                                        }
        | block statement                                              {
                                                                            cout << "parser:statements: statements statement : " << $2 << endl;
                                                                            Stmts_list.push_front($2);
                                                                            //$$ = Stmts_list;
                                                                            $$ = $2;
                                                                        };

    ifndef_statement:
        IFDEF ID SEMI_COLON                                             {
                                                                            cout << "parser:ifndef_statement: IFDEF ID" << endl;
                                                                        }
        | IFNDEF ID SEMI_COLON                                          {
                                                                            cout << "parser:ifndef_statement: IFNDEF ID" << endl;

                                                                        }
        | ENDIF                                                         {
                                                                            cout << "parser:ifndef_statement: ENDIF" << endl;

                                                                        };

    statement:
        expr SEMI_COLON                                                 {
                                                                            /* cout << "parser:statement: expr SEMI_COLON : " << $1 << endl;
                                                                            $$ = $1; */
                                                                        }
        | function SEMI_COLON                                           {
                                                                            cout << "parser:statement: function SEMI_COLON" << endl;
                                                                        }
        | declaration SEMI_COLON                                        {
                                                                            cout << "parser:statement: declaration SEMI_COLON : declaration=" << $1->getName() << endl;
                                                                            $$ = $1->getName();
                                                                        }
        | declaration ASSIGNMENT expr SEMI_COLON                        {
                                                                            cout << "parser:statement: declaration ASSIGNMENT expr SEMI_COLON : " << $1->getName() << " = " << $3 << endl;
                                                                            $1->setValue($3);
                                                                            $1->str();
                                                                            $$ = $1->getValue();
                                                                        }
         | declaration ASSIGNMENT ID SEMI_COLON                         {
                                                                            cout << "parser:statement: declaration ASSIGNMENT ID SEMI_COLON : " << $1->getName() << " = " << $3 << "(" << $3 << ")" << endl;
                                                                            Symbol* sym = SymbolTable::get_instance().find($3);
                                                                            $1->setValue(sym->getValue());
                                                                            $1->str();
                                                                            $$ = $1->getValue();
                                                                        }
        | ID ASSIGNMENT ID SEMI_COLON                                   {
                                                                            cout << "parser:statement: ID ASSIGNMENT ID SEMI_COLON : " << $1 << "=" << $3 << endl;
                                                                            Symbol* s1  = SymbolTable::get_instance().find($1);
                                                                            Symbol* s3  = SymbolTable::get_instance().find($3);
                                                                            s1->setValue(s3->getValue());
                                                                            s1->str();
                                                                            $$ = s1->getValue();
                                                                        }
         | ID ASSIGNMENT expr SEMI_COLON                                {
                                                                            cout << "parser:statement: ID ASSIGNMENT expr SEMI_COLON : " << $1 << "=" << $3 << endl;
                                                                            Symbol* s  = SymbolTable::get_instance().find($1);
                                                                            s->setValue($3);
                                                                            s->str();
                                                                            $$ = s->getValue();
                                                                        };
        | if_statement                                                 {
                                                                            cout << "parser:statements: if_statement" << endl;
                                                                        }
        | if_else_statement                                            {
                                                                            cout << "parser:statements: if__else_statement" << endl;
                                                                        }
        | for_statement                                                 {
                                                                            cout << "parser:statements: for_statement" << endl;
                                                                        }

    if_statement:
        IF LEFT_PAREN expr RIGHT_PAREN statement                        {
                                                                            /* cout << "parser:if_statement: IF expr : expr=" << $3 << endl;
                                                                            //if(atoi($3.c_str()))
                                                                            {
                                                                                $$ = $5;
                                                                            } */
                                                                        }
        | IF LEFT_PAREN expr RIGHT_PAREN scope                          {
                                                                            /* cout << "parser:if_statement: IF LEFT_PAREN expr RIGHT_PAREN scope" << endl;
                                                                            $$ = $5; */
                                                                        };
    if_else_statement:
        IF LEFT_PAREN expr RIGHT_PAREN statement ELSE statement                         {
                                                                            /* cout << "parser:if_statement: IF expr : expr=" << $3 << endl;
                                                                            //if(atoi($3.c_str()))
                                                                            {
                                                                                $$ = $5;
                                                                            } */
                                                                        }
        | IF LEFT_PAREN expr RIGHT_PAREN block ELSE block                         {
                                                                            /* cout << "parser:if_statement: IF LEFT_PAREN expr RIGHT_PAREN scope" << endl;
                                                                            $$ = $5; */
                                                                        };

    for_statement:
        FOR statement                        {
                                                                            /* cout << "parser:if_statement: IF expr : expr=" << $3 << endl;
                                                                            //if(atoi($3.c_str()))
                                                                            {
                                                                                $$ = $5;
                                                                            } */
                                                                        }
        | FOR block                                                    {
                                                                            /* cout << "parser:if_statement: IF LEFT_PAREN expr RIGHT_PAREN scope" << endl;
                                                                            $$ = $5; */
                                                                        };
    expr:
        NUMBER                                                          {
                                                                            cout << "parser:expr: NUMBER: " << $1 << endl;
                                                                            $$ = $1;
                                                                        }
        | ID EQUALS expr                                                {
                                                                            Symbol* s  = SymbolTable::get_instance().find($1);
                                                                            if( s == nullptr )
                                                                            {
                                                                                cout << "Error: undefined symbol '" << $1 << "' not found in symbol table." << endl;
                                                                                exit(1);
                                                                            }
                                                                            $$ = (s->getValue() == $3) ? "1" : "0";
                                                                            cout << "parser:expr: ID EQUALS expr: = " << $$ << endl;
                                                                        }
        | expr EQUALS ID                                                {
                                                                            Symbol* s  = SymbolTable::get_instance().find($1);
                                                                            if( s == nullptr )
                                                                            {
                                                                                cout << "Error: undefined symbol '" << $1 << "' not found in symbol table." << endl;
                                                                                exit(1);
                                                                            }
                                                                            $$ = ($1 == s->getValue()) ? "1" : "0";
                                                                            cout << "parser:expr: expr EQUALS ID: = " << $$ << endl;
                                                                        }
        | ID EQUALS ID                                                  {
                                                                            Symbol* s1  = SymbolTable::get_instance().find($1);
                                                                            Symbol* s3  = SymbolTable::get_instance().find($3);
                                                                            if( s1 == nullptr || s3 == nullptr )
                                                                            {
                                                                                cout << "Error: undefined symbol " << $1 << " or " << $3 << " not found in symbol table." << endl;
                                                                                exit(1);
                                                                            }
                                                                            $$ = (s1->getValue() == s3->getValue()) ? "1" : "0";
                                                                            cout << "parser:expr: ID EQUALS ID: = " << $$ << endl;
                                                                        }
        | expr EQUALS expr                                              {
                                                                            cout << "parser:expr: expr EQUALS expr: = " << $$ << endl;
                                                                            $$ = ($1 == $3) ? "1" : "0";
                                                                        }
        | LEFT_PAREN expr RIGHT_PAREN                                   {
                                                                            cout << "parser:expr: '(' expr: " << $2 << ")" << endl;
                                                                            $$ = $2;
                                                                        }
        | ID MODULUS ID                                                 {
                                                                            cout << "parser:expr: ID MODULUS ID: " << $1 << " % " << $3 << endl;
                                                                            $$ = modulo($1, $3);
                                                                        }
        | ID MODULUS expr                                               {
                                                                            cout << "parser:expr: ID MODULUS expr: " << $1 << " % " << $3 << endl;
                                                                            $$ = modulo($1, $3);
                                                                        }
        | expr MODULUS expr                                             {
                                                                            cout << "parser:expr: expr MODULUS expr: " << $1 << " % " << $3 << endl;
                                                                            $$ = modulo($1, $3);
                                                                        }
        | ID ADDITION ID                                                {
                                                                            cout << "parser:expr: ID ADDITION ID: " << $1 << " + " << $3 << endl;
                                                                            $$ = add($1, $3);
                                                                        }
        | ID ADDITION expr                                              {
                                                                            cout << "parser:expr: ID ADDITION expr: " << $1 << " + " << $3 << endl;
                                                                            $$ = add($1, $3);
                                                                        }
        | expr ADDITION expr                                            {
                                                                            cout << "parser:expr: expr ADDITION expr: " << $1 << " + " << $3 << endl;
                                                                            $$ = add($1, $3);
                                                                        }
        | ID SUBTRACTION ID                                             {
                                                                            cout << "parser:expr: ID SUBTRACTION ID: " << $1 << " - " << $3 << endl;
                                                                            $$ = subtract($1, $3);
                                                                        }
        | ID SUBTRACTION expr                                           {
                                                                            cout << "parser:expr: ID SUBTRACTION expr: " << $1 << " - " << $3 << endl;
                                                                            $$ = subtract($1, $3);
                                                                        }
        | expr SUBTRACTION expr                                         {
                                                                            cout << "parser:expr: NUMBER SUBTRACTION NUMBER: " << $1 << " - " << $3 << endl;
                                                                            $$ = subtract($1, $3);
                                                                        }
        | ID MULTIPLICATION ID                                          {
                                                                            cout << "parser:expr: ID MULTIPLICATION ID: " << $1 << " * " << $3 << endl;
                                                                            $$ = multiply($1, $3);
                                                                        }
        | ID MULTIPLICATION expr                                        {
                                                                            cout << "parser:expr: ID MULTIPLICATION expr: " << $1 << " * " << $3 << endl;
                                                                            $$ = multiply($1, $3);
                                                                        }
        | expr MULTIPLICATION expr                                      {
                                                                            cout << "parser:expr: expr MULTIPLICATION expr: " << $1 << " * " << $3 << endl;
                                                                            $$ = multiply($1, $3);
                                                                        }
        | ID DIVISION ID                                                {
                                                                            cout << "parser:expr: ID DIVISION ID : " << $1 << " / " << $3 << endl;
                                                                            $$ = divide($1, $3);
                                                                        }
        | ID DIVISION expr                                              {
                                                                            cout << "parser:expr: ID DIVISION expr : " << $1 << " / " << $3 << endl;
                                                                            $$ = divide($1, $3);
                                                                        }
        | expr DIVISION expr                                            {
                                                                            cout << "parser:expr: expr DIVISION expr : " << $1 << " / " << $3 << endl;
                                                                            $$ = divide($1, $3);
                                                                        };

    function:
        declaration '(' ')'                                             { cout << "parser:function: declaration '(' ')': " << endl; };

    declaration:
        type_name ID                                                    {
                                                                            cout << "parser:declaration: type_name=\"" << $1 << "\" ID=\"" << $2 << "\"" << endl;
                                                                            string val = "0";
                                                                            string modifier = "";
                                                                            // modifier, type, name, value, address
                                                                            Symbol* ps = new Symbol(modifier, $1, $2, val, (long)ps);
                                                                            SymbolTable::get_instance().add(*ps);
                                                                            $$ = ps;
                                                                        }
        | type_modifier type_name ID                                    {
                                                                            cout << "parser:declaration: type_modifier=\"" << $1 << "\" type_name=\"" << $2 << "\" ID=\"" << $3 << "\"" << endl;
                                                                            string val = "0";
                                                                            // modifier, type, name, value, address
                                                                            Symbol* ps = new Symbol($1, $2, $3, val, (long)ps);
                                                                            SymbolTable::get_instance().add(*ps);
                                                                            $$ = ps;
                                                                        };

    string_literal:
        ESC_SEQ                                                         { cout << "parser:string_literal: ESC_SEQ" << endl;  };

    ESC_SEQ:
            '\\'                                                        {
                                                                            cout << "parser:ESC_SEQ: '\\'" << endl;
                                                                        }
            | '\f'                                                      {
                                                                            cout << "parser:ESC_SEQ: '\\\\'" << endl;
                                                                        }
            | '\n'                                                      {
                                                                            cout << "parser:ESC_SEQ: 'n'" << endl;
                                                                        }
            | '\r'                                                      {
                                                                            cout << "parser:ESC_SEQ: 'r'" << endl;
                                                                        }
            | '\t'                                                      {
                                                                            cout << "parser:ESC_SEQ: 't'" << endl;
                                                                        };

    comments:
        comment                                                         {
                                                                            cout << "parser:comments: comment" << endl;
                                                                        }
        | comments comment                                              {
                                                                            cout << "parser:comments: comments comment" << endl;
                                                                        };

    comment:
        STRING_LITERAL                                                  {
                                                                            cout << "parser:comment: STRING_LITERAL" << endl;
                                                                        };

    access_specifier:
        PUBLIC                                                          { cout << "parser:access_specifier: PUBLIC" << endl; }
        | PROTECTED                                                     { cout << "parser:access_specifier: PROTECTED" << endl; }
        | PRIVATE                                                       { cout << "parser:access_specifier: PRIVATE" << endl; };

    type_modifier:
        STATIC                                                          { cout << "parser:type_modifier: STATIC" << endl; $$ = $1; }
        | CONST                                                         { cout << "parser:type_modifier: CONST" << endl;  $$ = $1; }
        | UNSIGNED                                                      { cout << "parser:type_modifier: UNSIGNED" << endl; $$ = $1; }
        | SIGNED                                                        { cout << "parser:type_modifier: SIGNED" << endl; $$ = $1;  }
        | VOLATILE                                                      { cout << "parser:type_modifier: VOLATILE" << endl; $$ = $1;  }
        | MUTABLE                                                       { cout << "parser:type_modifier: MUTABLE" << endl; $$ = $1; }
        | REGISTER                                                      { cout << "parser:type_modifier: REGISTER" << endl; $$ = $1; }
        | RESTRICT                                                      { cout << "parser:type_modifier: RESTRICT" << endl; $$ = $1; }
        | INLINE                                                        { cout << "parser:type_modifier: INLINE" << endl; $$ = $1; };

    type_name:
        INT                                                             { cout << "parser:type_name: INT" << endl; $$ = $1; }
        | SHORT                                                         { cout << "parser:type_name: SHORT" << endl; $$ = $1; }
        | LONG                                                          { cout << "parser:type_name: LONG" << endl; $$ = $1; }
        | LONGLONG                                                      { cout << "parser:type_name: LONGLONG" << endl; $$ = $1; }
        | DOUBLE                                                        { cout << "parser:type_name: DOUBLE" << endl; $$ = $1; }
        | LONGDOUBLE                                                    { cout << "parser:type_name: LONGDOUBLE" << endl; $$ = $1; }
        | SINGLE                                                        { cout << "parser:type_name: SINGLE" << endl; $$ = $1; }
        | FLOAT                                                         { cout << "parser:type_name: FLOAT" << endl; $$ = $1; }
        | CHAR                                                          { cout << "parser:type_name: CHAR" << endl; $$ = $1; }
        | VOID                                                          { cout << "parser:type_name: VOID" << endl; $$ = $1; }
        | type_name REFERENCE                                           { cout << "parser:type_name: type_name REFERENCE" << endl; }
        | type_name POINTER                                             { cout << "parser:type_name: type_name POINTER" << endl; }
        | CLASS                                                         { cout << "parser:type_name: CLASS" << endl; $$ = $1; }
        | STRUCT                                                        { cout << "parser:type_name: STRUCT" << endl; $$ = $1; }
        | UNION                                                         { cout << "parser:type_name: UNION" << endl; $$ = $1; }
        | ENUM                                                          { cout << "parser:type_name: ENUM" << endl; $$ = $1; };

    flow_control:
        FOR                                                             { cout << "parser:flow_control: FOR" << endl; }
        | WHILE                                                         { cout << "parser:flow_control: WHILE" << endl; }
        | DO                                                            { cout << "parser:flow_control: DO" << endl; }
        | BREAK                                                         { cout << "parser:flow_control: BREAK" << endl; }
        | CONTINUE                                                      { cout << "parser:flow_control: CONTINUE" << endl; }
        | IF                                                            { cout << "parser:flow_control: IF" << endl; }
        | ELSE                                                          { cout << "parser:flow_control: ELSE" << endl; }
        | SWITCH                                                        { cout << "parser:flow_control: SWITCH" << endl; }
        | CASE                                                          { cout << "parser:flow_control: CASE" << endl; }
        | GOTO                                                          { cout << "parser:flow_control: GOTO" << endl; }
        | DEFAULT                                                       { cout << "parser:flow_control: DEFAULT" << endl; }
        | RETURN                                                        { cout << "parser:flow_control: RETURN" << endl; }
        | LABEL                                                         { cout << "parser:flow_control: LABEL" << endl; };

    operator:
        ASSIGNMENT                                                      { cout << "parser:operator: ASSIGNMENT" << endl; }
        | ADDITION                                                      { cout << "parser:operator: ADDITION" << endl; }
        | SUBTRACTION                                                   { cout << "parser:operator: SUBTRACTION" << endl; }
        | MULTIPLICATION                                                { cout << "parser:operator: MULTIPLICATION" << endl; }
        | DIVISION                                                      { cout << "parser:operator: DIVISION" << endl; }
        | MODULUS                                                       { cout << "parser:operator: MODULUS" << endl; }
        | LESS_THAN                                                     { cout << "parser:operator: LESS_THAN" << endl; }
        | EQUALS                                                        { cout << "parser:operator: EQUALS" << endl; }
        | GREATER_THAN                                                  { cout << "parser:operator: GREATER_THAN" << endl; }
        | BIT_AND                                                       { cout << "parser:operator: BIT_AND" << endl; }
        | BIT_OR                                                        { cout << "parser:operator: BIT_OR" << endl; }
        | BIT_XOR                                                       { cout << "parser:operator: BIT_XOR" << endl; }
        | BIT_NOT                                                       { cout << "parser:operator: BIT_NOT" << endl; }
        | NOT                                                           { cout << "parser:operator: NOT" << endl; }
        | AND                                                           { cout << "parser:operator: AND" << endl; }
        | OR                                                            { cout << "parser:operator: OR" << endl; }
        | SHIFT_LEFT                                                    { cout << "parser:operator: SHIFT_LEFT" << endl; }
        | SHIFT_RIGHT                                                   { cout << "parser:operator: SHIFT_RIGHT" << endl; }
        | LEFT_BRACE                                                    { cout << "parser:operator: LEFT_BRACE" << endl; }
        | RIGHT_BRACE                                                   { cout << "parser:operator: RIGHT_BRACE" << endl; }
        | COMMA                                                         { cout << "parser:operator: COMMA" << endl; }
        | COLON                                                         { cout << "parser:operator: COLON" << endl; }
        | DOUBLE_QUOTE                                                  { cout << "parser:operator: DOUBLE_QUOTE" << endl; }
        | SINGLE_QUOTE                                                  { cout << "parser:operator: SINGLE_QUOTE" << endl; }
        | QUESTION_MARK                                                 { cout << "parser:operator: QUESTION_MARK" << endl; }
        | DOT                                                           { cout << "parser:operator: DOT" << endl; }
        | AT_SYMBOL                                                     { cout << "parser:operator: AT_SYMBOL" << endl; }
        | ADDRESS_OF                                                    { cout << "parser:operator: ADDRESS_OF" << endl; }
        | SCOPE_RESOLUTION                                              { cout << "parser:operator: SCOPE_RESOLUTION" << endl; }
        | LSHIFT                                                        { cout << "parser:operator: LSHIFT" << endl; }
        | RSHIFT                                                        { cout << "parser:operator: RSHIFT" << endl; }
        | INCREMENT                                                     { cout << "parser:operator: INCREMENT" << endl; }
        | DECREMENT                                                     { cout << "parser:operator: DECREMENT" << endl; }
        | ADD_ASSIGN                                                    { cout << "parser:operator: ADD_ASSIGN" << endl; }
        | SUB_ASSIGN                                                    { cout << "parser:operator: SUB_ASSIGN" << endl; }
        | MULT_ASSIGN                                                   { cout << "parser:operator: MULT_ASSIGN" << endl; }
        | DIV_ASSIGN                                                    { cout << "parser:operator: DIV_ASSIGN" << endl; }
        | MOD_ASSIGN                                                    { cout << "parser:operator: MOD_ASSIGN" << endl; }
        | BIT_AND_ASSIGN                                                { cout << "parser:operator: BIT_AND_ASSIGN" << endl; }
        | BIT_OR_ASSIGN                                                 { cout << "parser:operator: BIT_OR_ASSIGN" << endl; }
        | BIT_XOR_ASSIGN                                                { cout << "parser:operator: BIT_XOR_ASSIGN" << endl; }
        | BIT_NOT_ASSIGN                                                { cout << "parser:operator: BIT_NOT_ASSIGN" << endl; }
        | LSHIFT_ASSIGN                                                 { cout << "parser:operator: LSHIFT_ASSIGN" << endl; }
        | RSHIFT_ASSIGN                                                 { cout << "parser:operator: RSHIFT_ASSIGN" << endl; }
        | TEMPLATE                                                      { cout << "parser:operator: TEMPLATE" << endl; }
        | TYPENAME                                                      { cout << "parser:operator: TYPENAME" << endl; }
        | SIZEOF                                                        { cout << "parser:operator: SIZEOF" << endl; }
        | DELETE                                                        { cout << "parser:operator: DELETE" << endl; }
        | STATIC_CAST                                                   { cout << "parser:operator: STATIC_CAST" << endl; }
        | CONST_CAST                                                    { cout << "parser:operator: CONST_CAST" << endl; }
        | DYNAMIC_CAST                                                  { cout << "parser:operator: DYNAMIC_CAST" << endl; }
        | REINTERPRET_CAST                                              { cout << "parser:operator: REINTERPRET_CAST" << endl; };

    member_select:
        DIRECT_MEMBER_SELECT                                            { cout << "parser:operator: member_select: DIRECT_MEMBER_SELECT" << endl; }
        | INDIRECT_MEMBER_SELECT                                        { cout << "parser:operator: member_select: INDIRECT_MEMBER_SELECT" << endl; }
        ;

    pointer_to_member:
        INDIRECT_TO_POINTER                                             { cout << "parser:operator: pointer_to_member: INDIRECT_TO_POINTER" << endl; }
        | DIRECT_TO_POINTER                                             { cout << "parser:operator: pointer_to_member: DIRECT_TO_POINTER" << endl; };

    scope_resolution:
        USING                                                           { cout << "parser:operator: scope_resolution: USING" << endl; }
        | NAMESPACE                                                     { cout << "parser:operator: scope_resolution: NAMESPACE" << endl; };


    %%

    /**
     * @brief get value from identifier
     * @param str the id
     * @return value of identifier
     */
    std::string get_symbol_value(const std::string& str)
    {
        /* //core::symbol* s = //core::stack::get_instance().find(str);
        return s->getValue(); */
        string s;
        return s;
    }

    /**
     * @brief assign value to identifier
     * @param str1 The first number.
     * @param str2 The second number.
     */
    void symbol_value(const std::string& str1, const std::string& str2)
    {

        /* //core::symbol* s1  = //core::stack::get_instance().find(str1);
        //core::symbol* s2  = //core::stack::get_instance().find(str2);
        s1->setValue( s2->getName() ); */

    }

    /**
     * @brief Adds two numbers.
     * @param str1 The first number.
     * @param str2 The second number.
     * @return The sum of the two numbers.
     */
    std::string add(const std::string& str1, const std::string& str2)
    {
        /* /* std::stringstream ss1(str1);
        int val1;
        ss1 >> val1;

        std::stringstream ss2(str2);
        int val2;
        ss2 >> val2; */

        /* scope s;
        add_op op( atoi( str1.c_str( ) ), atoi( str2.c_str( ) ) );
        //Stmt smt( &op ); */
        //Stmt smt;
        //s.add_Stmt( smt );

        //core::symbol* s1  = //core::stack::get_instance().find(str1);
        //core::symbol* s2  = //core::stack::get_instance().find(str2);
        /* if( s1 == nullptr || s2 == nullptr)
        {
            cout << "parser: Error: symbol '" << str1 << "' not found in symbol table." << endl;
            exit(1);
        }
        char buffer[24];
        int r = atoi(s1->getValue().c_str()) + atoi(s2->getValue().c_str());
        citoa(r, buffer, 10);
        string ans(buffer);
        return ans; */

        string s;
        return s;
    }

    /**
     * @brief Subtracts two numbers.
     * @param str1 The first number.
     * @param str2 The second number.
     * @return The difference of the two numbers.
     */
    std::string subtract(const std::string& str1, const std::string& str2)
    {
        //core::symbol* s1  = //core::stack::get_instance().find(str1);
        //core::symbol* s2  = //core::stack::get_instance().find(str2);
        /* if( s1 == nullptr || s2 == nullptr)
        {
            cout << "parser: Error: //core::symbol '" << str1 << "' not found in //core::symbol table." << endl;
            exit(1);
        }
        char buffer[24];
        int r = atoi(s1->getValue().c_str()) - atoi(s2->getValue().c_str());
        citoa(r, buffer, 10);
        string ans(buffer);
        return ans; */

        string s;
        return s;
    }

    /**
     * @brief Multiplies two numbers.
     * @param str1 The first number.
     * @param str2 The second number.
     * @return The product of the two numbers.
     */
    std::string multiply(const std::string& str1, const std::string& str2)
    {
        //core::symbol* s1  = //core::stack::get_instance().find(str1);
        //core::symbol* s2  = //core::stack::get_instance().find(str2);
        /* if( s1 == nullptr || s2 == nullptr)
        {
            cout << "parser: Error: //core::symbol '" << str1 << "' not found in //core::symbol table." << endl;
            exit(1);
        }
        char buffer[24];
        int r = atoi(s1->getValue().c_str()) * atoi(s2->getValue().c_str());
        citoa(r, buffer, 10); */
        /* string ans(buffer);
        //cout << "parser: multiply: " << str1 << " * " << str2 << " = " << ans << endl;
        return ans; */
        string s;
        return s;
    }

    /**
     * @brief Divides two numbers.
     * @param str1 The first number.
     * @param str2 The second number.
     * @return The quotient of the two numbers.
     */
    std::string divide(const std::string& str1, const std::string& str2)
    {
        //core::symbol* s1  = //core::stack::get_instance().find(str1);
        //core::symbol* s2  = //core::stack::get_instance().find(str2);
        /* if( s1 == nullptr || s2 == nullptr)
        {
            cout << "parser: Error: //core::symbol '" << str1 << "' not found in //core::symbol table." << endl;
            exit(1);
        }
        char buffer[24];
        int r = atoi(s1->getValue().c_str()) / atoi(s2->getValue().c_str());
        citoa(r, buffer, 10);
        string ans(buffer);
        return ans; */
        string s;
        return s;
    }

    /**
     * @brief Computes the modulo of two numbers.
     * @param str1 The first number.
     * @param str2 The second number.
     * @return The modulo of the two numbers.
     */
    std::string modulo(const std::string& str1, const std::string& str2)
    {
        /* symbol* s1  = //core::stack::get_instance().find(str1);
        //core::symbol* s2  = //core::stack::get_instance().find(str2);
        if( s1 == nullptr || s2 == nullptr)
        {
            cout << "parser: Error: //core::symbol '" << str1 << "' not found in //core::symbol table." << endl;
            exit(1);
        }
        char buffer[24];
        int r = atoi(s1->getValue().c_str()) % atoi(s2->getValue().c_str());
        citoa(r, buffer, 10);
        string ans(buffer);
        return ans; */
        string s;
        return s;
    }

    /**
     * @brief Reports a parser error.
     * @param loc The location of the error.
     * @param message The error message.
     */
    void xx::Parser::error(const location &loc , const std::string &message)
    {

        /* //location should be initialized inside scanner action, but is not in this example
        //Let's grab location directly from driver class
        cout << "parser: Error: " << message << endl; //<< "Error location: " << Driver::get_instance().location() << endl;

        //cout << "parser: Error: \n " << message << endl; */
    }
