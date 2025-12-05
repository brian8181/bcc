%{

    #include <stdio.h>
    #include <ctype.h>
    #include <stdlib.h>
    #include <string.h>
    /* need this for the call to atof() below */
    #include <math.h>
    //#include "add_op.hpp"
    //#include "scope.hpp"
    //#include "stmt.hpp"
    //#include "file.hpp"

    int yylex(void);
    int yyrestart(FILE* f);
    int yyerror(char* s);

    /**
    * @name   digits10
    * @param  n, number to eval
    * @return number of base 10 digits
    */
    int digits10(int n);
    /**
    * @name   atoi
    * @info:  ascii to int
    * @param  s, string to convert
    * @return int : result
    */
    int atoi(const char* s);
    /**
    * @name itoa
    * @param number to eval
    * @param s, out parma
    * @return void
    */
    void itoa(int n, char* s);
    /**
    * @brief  sum
    * @param  char* lhs, left hand side
    * @param  char* rhs, right hand side
    * @param  char** sum, lhs + rhs
    * @return int, lhs + rhs
    */
    int add(const char* lhs, const char* rhs, char** sum);
    /**
    * @brief  subtract
    * @param  char* lhs, left hand side
    * @param  char* rhs, right hand side
    * @param  char** diffrence, lhs - rhs
    * @return int, lhs - rhs
    */
    int subtract(const char* lhs, const char* rhs, char** difference);
    /**
    * @brief  multiply
    * @param  char* lhs, left hand side
    * @param  char* rhs, right hand side
    * @param  char** product, lhs - rhs
    * @return int, lhs - rhs
    */
    int multiply(const char* lhs, const char* rhs, char** product);
    /**
    * @brief  divide
    * @param  char* lhs, left hand side
    * @param  char* rhs, right hand side
    * @param  char** quotient, lhs - rhs
    * @return int, lhs - rhs
    */
    int divide(const char* lhs, const char* rhs, char** quotient);

    /*
        %left '<' '>' '=' "!=" "<=" ">="
        %left '+' '-'
        %left '*' '/'
    */

%};

%union
{
    int ival;
    char* sval;
};

%token<ival> USING NAMESPACE END END_OF_FILE END_OF_FILES
%token<sval> NUMBER ID SYMBOL STRING_LITERAL FLOAT_LITERAL
%token<sval> COMMA RIGHT_PAREN LEFT_PAREN RIGHT_BRACE LEFT_BRACE RIGHT_CURLY LEFT_CURLY COLON DOUBLE_QUOTE SINGLE_QUOTE QUESTION_MARK DOT AT_SYMBOL SEMI_COLON
%token<sval> INCLUDE DEFINE IFDEF IFNDEF ENDIF PRAGMA
%token<sval> INT SHORT LONG LONGLONG DOUBLE LONGDOUBLE SINGLE FLOAT CHAR VOID
%token<sval> ENUM UNION CLASS STRUCT TEMPLATE TYPENAME REFERENCE POINTER
%token<sval> STATIC CONST UNSIGNED SIGNED VOLATILE MUTABLE REGISTER RESTRICT INLINE
%token<sval> SHIFT_LEFT SHIFT_RIGHT MODULUS NOT AND OR BIT_AND BIT_OR BIT_XOR BIT_NOT LSHIFT RSHIFT
%token<sval> EQUALS LESS_THAN GREATER_THAN LESS_THAN_EQUAL GREATER_THAN_EQUAL
%token<sval> PUBLIC PROTECTED PRIVATE
%token<sval> ADDRESS_OF SCOPE_RESOLUTION DIRECT_TO_POINTER INDIRECT_TO_POINTER DIRECT_MEMBER_SELECT INDIRECT_MEMBER_SELECT
%token<sval> IF ELSE FOR DO WHILE CONTINUE BREAK SWITCH CASE GOTO LABEL DEFAULT RETURN
%token<sval> INCREMENT DECREMENT
%token<sval> ASSIGN ASSIGNMENT ADD_ASSIGN SUB_ASSIGN MULT_ASSIGN DIV_ASSIGN MOD_ASSIGN BIT_AND_ASSIGN BIT_OR_ASSIGN BIT_XOR_ASSIGN BIT_NOT_ASSIGN LSHIFT_ASSIGN RSHIFT_ASSIGN
%token<sval> DELETE NEW SIZEOF
%token<sval> CONST_CAST DYNAMIC_CAST STATIC_CAST REINTERPRET_CAST
%type<sval> file files scope scopes statement expr
%type<sval> if_statement
%type<sval> function
%type<sval> declaration type_name type_modifier
%type<sval> numeric_literal block blocks
%left<sval> SUBTRACTION ADDITION DIVISION MULTIPLICATION
%start program

%%

program:
    files END_OF_FILES                                              { printf("parser:program: files END_OF_FILES\n"); exit(0); };

files:
    file                                                            { printf("parser:files: file\n"); $$ = $1; }
    | files file                                                    { printf("parser:files: files file\n"); $$ = $1; };

file:
    scopes                                                          {
                                                                        printf("parser:file: scopes END\n");
                                                                       // $$ = $1;
                                                                    }
    | block                                                         {
                                                                        printf("parser:file: statements END\n");
                                                                        //$$ = $1;
                                                                    }
    | file scopes                                                   {
                                                                        printf("parser:file: scopes\n");
                                                                        //$$ = $1;
                                                                    }
    | file blocks                                                   {
                                                                        printf("parser:file: statements\n");
                                                                        //$$ = $1;
                                                                    };

scopes:
    /* empty */                                                     {   printf("parser:scopes empty\n"); }
    scope                                                           {

                                                                        printf("parser:scopes scope\n");
                                                                        //$$ = $1;
                                                                    }
    | scopes scope                                                  {
                                                                        printf("parser:scopes scopes scope\n");
                                                                        $$ = $1;
                                                                    };

if_statement:
    IF LEFT_PAREN expr RIGHT_PAREN statement                        {
                                                                        printf("parser:if_statement: IF expr : expr=%s\n", $3);
                                                                        //if(atoi($3.c_str()))
                                                                        {
                                                                            $$ = $5;
                                                                        };
                                                                    }
    | IF LEFT_PAREN expr RIGHT_PAREN scope                          {
                                                                        printf("parser:if_statement: IF LEFT_PAREN expr RIGHT_PAREN scope\n");
                                                                        $$ = $5;
                                                                    };
scope:
    blocks                                                      {
                                                                        printf("parser:scope statements\n");
                                                                        //$$ = $1;
                                                                    }
    | LEFT_CURLY block RIGHT_CURLY                             {
                                                                        //printf("parser:scope: LEFT_CURLY statements RIGHT_CURLY : statements: [ %s ]\n", $2);
                                                                        //$$ = $2;
                                                                    };
blocks:
    block;
    | block blocks;

block:
    if_statement                                                    {
                                                                        printf("parser:statements: if_statement\n");
                                                                    }
    | statement                                                     {
                                                                        printf("parser:statements: statement\n");
                                                                        // stmts_list.push_front($1);
                                                                        // //$$ = stmts_list;
                                                                        //$$ = $1;
                                                                    }
    | block statement                                               {
                                                                        printf("parser:statements: statements statement\n");
                                                                        // stmts_list.push_front($2);
                                                                        // //$$ = stmts_list;
                                                                        //$$ = $2;
                                                                    };


statement:
    expr SEMI_COLON                                                 {
                                                                        printf("parser:statement: expr SEMI_COLON: [ %s ]\n" , $1);
                                                                        //statement stmt;
                                                                        $$ = $1;
                                                                    }
    | function SEMI_COLON                                           {
                                                                        printf("parser:statement: function SEMI_COLON\n");
                                                                    }
    | declaration SEMI_COLON                                        {
                                                                        //printf("parser:statement: declaration SEMI_COLON : declaration=" , $1->getName());
                                                                        //$$ = $1->getName();
                                                                    }
    | declaration ASSIGNMENT expr SEMI_COLON                        {
                                                                        //printf("parser:statement: declaration ASSIGNMENT expr SEMI_COLON : " , $1->getName() , " = " , $3);
                                                                        // $1->setValue($3);
                                                                        // $1->str();
                                                                        //$$ = $1->getValue();
                                                                    }
    | declaration ASSIGNMENT ID SEMI_COLON                          {
                                                                        //printf("parser:statement: declaration ASSIGNMENT ID SEMI_COLON : " , $1->getName() , " = " , $3 , "(" , $3 , ")");
                                                                        // Symbol* sym = SymbolTable::get_instance().find($3);
                                                                        // $1->setValue(sym->getValue());
                                                                        // $1->str();
                                                                        // //$$ = $1->getValue();
                                                                    }
    | ID ASSIGNMENT ID SEMI_COLON                                   {
                                                                        printf("parser:statement: ID ASSIGNMENT ID SEMI_COLON : " , $1 , "=" , $3);
                                                                        // Symbol* s1  = SymbolTable::get_instance().find($1);
                                                                        // Symbol* s3  = SymbolTable::get_instance().find($3);
                                                                        // s1->setValue(s3->getValue());
                                                                        // s1->str();
                                                                        // $$ = s1->getValue();
                                                                    }
    | ID ASSIGNMENT expr SEMI_COLON                                 {
                                                                        printf("parser:statement: ID ASSIGNMENT expr SEMI_COLON : " , $1 , "=" , $3);
                                                                        // Symbol* s  = SymbolTable::get_instance().find($1);
                                                                        // s->setValue($3);
                                                                        // s->str();
                                                                        // $$ = s->getValue();
                                                                    };

expr:
    numeric_literal                                                 {
                                                                        printf("parser:expr: numeric_literal: [ %s ]\n", $1);
                                                                        $$ = $1;
                                                                    }
    | ID EQUALS expr                                                {
                                                                        // Symbol* s  = SymbolTable::get_instance().find($1);
                                                                        // if( s == nullptr )
                                                                        // {
                                                                        //     printf("Error: undefined symbol '" , $1 , "' not found in symbol table.");
                                                                        //     exit(1);
                                                                        // };
                                                                        // $$ = (s->getValue() == $3) ? "1" : "0";
                                                                        printf("parser:expr: ID: [ %s ] | EQUALS | expr: [ %s ]\n", $1, $3);
                                                                        $$ = $3;
                                                                    }
    | expr EQUALS ID                                                {
                                                                        // Symbol* s  = SymbolTable::get_instance().find($1);
                                                                        // if( s == nullptr )
                                                                        // {
                                                                        //     printf("Error: undefined symbol '" , $1 , "' not found in symbol table.");
                                                                        //     exit(1);
                                                                        // };
                                                                        // $$ = ($1 == s->getValue()) ? "1" : "0";
                                                                        printf("parser:expr: expr: [ %s ] | EQUALS | ID: [ %s ]\n", $1, $3);
                                                                        $$ = $3;
                                                                    }
    | ID EQUALS ID                                                  {
                                                                        // Symbol* s1  = SymbolTable::get_instance().find($1);
                                                                        // Symbol* s3  = SymbolTable::get_instance().find($3);
                                                                        // if( s1 == nullptr || s3 == nullptr )
                                                                        // {
                                                                        //     printf("Error: undefined symbol " , $1 , " or " , $3 , " not found in symbol table.");
                                                                        //     exit(1);
                                                                        // };
                                                                        // $$ = (s1->getValue() == s3->getValue()) ? "1" : "0";
                                                                        printf("parser:expr: ID: [ %s ] | EQUALS | ID: [ %s ]\n", $1, $3);
                                                                        $$ = $3;
                                                                    }
    | expr EQUALS expr                                              {
                                                                        printf("parser:expr: expr EQUALS expr");
                                                                        //$$ = ($1 == $3) ? "1" : "0";
                                                                        $$ = "true";
                                                                    }
    | LEFT_PAREN expr RIGHT_PAREN                                   {
                                                                        printf("parser:expr: %s\n", $2);
                                                                        //$$ = $2;
                                                                    }
    | ID MODULUS ID                                                 {
                                                                        printf("parser:expr: ID MODULUS ID:0%s\n", $3);
                                                                        //$$ = modulo($1, $3);
                                                                    }
    | ID MODULUS expr                                               {
                                                                        printf("parser:expr: ID MODULUS expr: %s\n", $3);
                                                                        //$$ = modulo($1, $3);
                                                                    }
    | expr MODULUS expr                                             {
                                                                        printf("parser:expr: expr MODULUS expr: %s\n", $3);
                                                                        //$$ = modulo($1, $3);
                                                                    }
    | ID ADDITION ID                                                {
                                                                        printf("parser:expr: ID q ID: %s + %s\n" , $1 , $3);
                                                                        //$$ = add($1, $3);
                                                                    }
    | ID ADDITION expr                                              {
                                                                        printf("parser:expr: ID ADDITION expr: %s + %s\n" , $1 , $3);
                                                                        char* out;
                                                                        add($1, $3, &out);
                                                                        $$ = out;
                                                                    }
    | expr ADDITION expr                                            {
                                                                        printf("parser:expr: expr ADDITION expr: %s + %s\n" , $1 , $3);
                                                                        char* out;
                                                                        add($1, $3, &out);
                                                                        $$ = out;
                                                                    }
    | ID SUBTRACTION ID                                             {
                                                                        printf("parser:expr: ID SUBTRACTION ID: %s - %s\n" , $1 , $3);
                                                                        // $$ = subtract($1, $3);
                                                                    }
    | ID SUBTRACTION expr                                           {
                                                                        printf("parser:expr: ID SUBTRACTION ID: %s - %s\n" , $1 , $3);
                                                                        // $$ = subtract($1, $3);
                                                                    }
    | expr SUBTRACTION expr                                         {
                                                                        printf("parser:expr: expr SUBTRACTION expr: " , $1 , " - " , $3);
                                                                        // $$ = subtract($1, $3);
                                                                    }
    | ID MULTIPLICATION ID                                          {
                                                                        printf("parser:expr: ID MULTIPLICATION ID: " , $1 , " * " , $3);
                                                                        // $$ = multiply($1, $3);
                                                                    }
    | ID MULTIPLICATION expr                                        {
                                                                        printf("parser:expr: ID MULTIPLICATION expr: " , $1 , " * " , $3);
                                                                        // $$ = multiply($1, $3);
                                                                    }
    | expr MULTIPLICATION expr                                      {
                                                                        printf("parser:expr: expr MULTIPLICATION expr: %s * %s", $1, $3);
                                                                        char* out;
                                                                        multiply($1, $3, &out);
                                                                        $$ = out;
                                                                    }
    | ID DIVISION ID                                                {
                                                                        printf("parser:expr: ID DIVISION ID : " , $1 , " / " , $3);
                                                                        // $$ = divide($1, $3);
                                                                    }
    | ID DIVISION expr                                              {
                                                                        printf("parser:expr: ID DIVISION expr : " , $1 , " / " , $3);
                                                                        // $$ = divide($1, $3);
                                                                    }
    | expr DIVISION expr                                            {
                                                                        printf("parser:expr: expr DIVISION expr : " , $1 , " / " , $3);
                                                                        // $$ = divide($1, $3);
                                                                    };

function:
    declaration '(' ')'                                             { printf("parser:function: declaration"); }

declaration:
    type_name ID                                                    {
                                                                        printf("parser:declaration: type_name [ %s ] ID [ %s ]", $1 , $2);
                                                                        // string val = "0";
                                                                        // string modifier = "";
                                                                        // // modifier, type, name, value, address
                                                                        // Symbol* ps = new Symbol(modifier, $1, $2, val, (long)ps);
                                                                        // SymbolTable::get_instance().add(*ps);
                                                                        $$ = $2;
                                                                    };
    | type_modifier type_name ID                                    {
                                                                        printf("parser:declaration: type_modifier: [ %s ] | type_name: [ %s ] | ID: [ %s ]", $1 , $2, $3);
                                                                        // string val = "0";
                                                                        // // modifier, type, name, value, address
                                                                        // Symbol* ps = new Symbol($1, $2, $3, val, (long)ps);
                                                                        // SymbolTable::get_instance().add(*ps);
                                                                        $$ = $3;
                                                                    };
type_modifier:
    STATIC                                                          { printf("parser:type_modifier: STATIC"); }
    | CONST                                                         { printf("parser:type_modifier: CONST");  };
    | UNSIGNED                                                      { printf("parser:type_modifier: UNSIGNED"); }
    | SIGNED                                                        { printf("parser:type_modifier: SIGNED");  };
    | VOLATILE                                                      { printf("parser:type_modifier: VOLATILE"); };
    | MUTABLE                                                       { printf("parser:type_modifier: MUTABLE"); }
    | REGISTER                                                      { printf("parser:type_modifier: REGISTER"); }
    | RESTRICT                                                      { printf("parser:type_modifier: RESTRICT"); }
    | INLINE                                                        { printf("parser:type_modifier: INLINE"); };

type_name:
    INT                                                             { printf("parser:type_name: INT"); }
    | SHORT                                                         { printf("parser:type_name: SHORT"); }
    | LONG                                                          { printf("parser:type_name: LONG"); }
    | LONGLONG                                                      { printf("parser:type_name: LONGLONG"); }
    | DOUBLE                                                        { printf("parser:type_name: DOUBLE"); }
    | LONGDOUBLE                                                    { printf("parser:type_name: LONGDOUBLE"); }
    | SINGLE                                                        { printf("parser:type_name: SINGLE"); }
    | FLOAT                                                         { printf("parser:type_name: FLOAT"); }
    | CHAR                                                          { printf("parser:type_name: CHAR"); }
    | VOID                                                          { printf("parser:type_name: VOID"); }
    | type_name REFERENCE                                           { printf("parser:type_name: type_name REFERENCE"); }
    | type_name POINTER                                             { printf("parser:type_name: type_name POINTER"); }
    | CLASS                                                         { printf("parser:type_name: CLASS"); }
    | STRUCT                                                        { printf("parser:type_name: STRUCT"); }
    | UNION                                                         { printf("parser:type_name: UNION"); }
    | ENUM                                                          { printf("parser:type_name: ENUM"); };

numeric_literal:
    NUMBER                                                         { printf("parser:numeric_literals: NUMBER: [ %s ]\n", $1); $$ = $1; }

%%

// typedef struct symbol
// {
//     char* _type_modifiers;
//     char* _type;
//     char* _name;
//     char* _value;
//     long _lval;
//     long _address;
// } symbol;


// typedef struct
// {
//     symbol* sym;
//     node* next;
// } node;

// typedef struct symtable
// {
//     node* head;
//     node* current;
// } symtable;

// void init_table(symtable* table)
// {
//     table->head = 0;
//     table->current = 0;
// }

// symtable table;
// //init_table( &table );
// //
// node* n = (node*)malloc( sizeof(node) );
// table.head = n;
// table.current = stable.head;

// node* next(symtable* table)
// {
//     table->current = symtable* table->current->next;
//     return current;
// }


// symbol* find(char* name)
// {
//     while(stable.current)
//     {
//         if(strcmp(name, stable.current->sym._name) == 0))
//         break;
//         stable.current = stable.current->next;
//     }
//     return &current.sym;
// }

// void add_symbol(symbol* sym)
// {
//     struct node* n = (struct node*)malloc(sizeof(struct node));
//     n->sym = *sym;
//     n->next = nullptr;
//     if(stable.head == nullptr)
//     {
//         stable.head = n;
//         stable.current = stable.head;
//     }
//     else
//     {
//         stable.current->next = n;
//         stable.current = n;
//     }
// }

const int ASCII_OFFSET = 48;

/**
 * @name   digits10
 * @param  n, number to eval
 * @return number of base 10 digits
 */
int digits10(int n)
{
    return floor(log10(n) + 1);
}

/**
 * @name   atoi
 * @info:  ascii to int
 * @param  s, string to convert
 * @return int : result
 */
int atoi(const char* s)
{
    int num = 0;
    int len = strlen(s);
    for(int i = 0; i < len; ++i)
    {
        int digit = ASCII_OFFSET - i;
        if(digit < 0 || digit > 10)
            return -1;
        num += digit * pow(10, i);
    }
    return num;
}

/**
 * @name itoa
 * @info int to ascii
 * @param number to eval
 * @param s, out parma
 * @return void
*/
void itoa(int n, char* s)
{
    int len = digits10(n);
    for(int i = 0; i < len; ++i)
    {
        int c = n / pow(10, i);
        c = floor( c );
        c = c % 10;
        s[(len-1)-i] = (char)(c + ASCII_OFFSET); // 0x30
    }
    s[len] = (char)'\0';
}

/**
* @brief  sum
* @param  char* lhs, left hand side
* @param  char* rhs, right hand side
* @param  char** sum, lhs + rhs
* @return int, lhs + rhs
*/
int add(const char* lhs, const char* rhs, char** sum)
{
    int n1 = atoi(lhs);
    int n2 = atoi(rhs);
    int r = n1 + n2;
    int len = digits10(r) + 1;
    *sum = (char*)malloc(len * sizeof(char) + 1);
    itoa(r, *sum);
    return r;
}

/**
* @brief subtract
* @param  char* lhs, left hand side
* @param  char* rhs, right hand side
* @param  char** diffrence, lhs - rhs
* @return int, lhs - rhs
*/
int subtract(const char* lhs, const char* rhs, char** difference)
{
    int n1 = atoi(lhs);
    int n2 = atoi(rhs);
    int r = n1 - n2;
    int len = digits10(r) + 1;
    *difference = (char*)malloc(len * sizeof(char) + 1);
    itoa(r, *difference);
    return r;
}

/**
* @brief  multiply
* @param  char* lhs, left hand side
* @param  char* rhs, right hand side
* @param  char** product, lhs - rhs
* @return int, lhs - rhs
*/
int multiply(const char* lhs, const char* rhs, char** product)
{
    int n1 = atoi(lhs);
    int n2 = atoi(rhs);
    int r = n1 * n2;
    int len = digits10(r) + 1;
    *product = (char*)malloc(len * sizeof(char) + 1);
    itoa(r, *product);
    return r;
}

/**
* @brief  divide
* @param  char* lhs, left hand side
* @param  char* rhs, right hand side
* @param  char** quotient, lhs - rhs
* @return int, lhs - rhs
*/
int divide(const char* lhs, const char* rhs, char** quotient)
{
    int n1 = atoi(lhs);
    int n2 = atoi(rhs);
    int r = n1 / n2;
    int len = digits10(r) + 1;
    *quotient = (char*)malloc(len * sizeof(char) + 1);
    itoa(r, *quotient);
    return r;
}


int yyerror(char *s)
{
    fprintf(stderr, "%s\n", s);
    return 0;
};

// int main(int argc, char** argv)
// {
//     printf("parsing ...\n");
//     extern FILE *yyin;
//     if ( argc > 0 )
//     {
//         yyin = fopen( argv[1], "r" );
//     }
//     else
//     {
//         yyin = stdin;
//     };
//     yyparse();
// };

int main(int argc, char** argv)
{
    if(argc < 2)
    {
        /* just read stdin */
        yyparse();
        return 0;
    }
    for(int i = 1; i < argc; i++)
    {
        FILE *f = fopen(argv[i], "r");
        if(!f)
        {
            perror(argv[i]);
            return (1);
        }
        yyrestart(f);
        yyparse();
        fclose(f);
    }
    return 0;
}
