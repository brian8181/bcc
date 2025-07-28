/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_BUILD2_PARSER_TAB_H_INCLUDED
# define YY_YY_BUILD2_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    INT = 258,                     /* INT  */
    FLOAT = 259,                   /* FLOAT  */
    CHAR = 260,                    /* CHAR  */
    REFERENCE = 261,               /* REFERENCE  */
    POINTER = 262,                 /* POINTER  */
    RETURN = 263,                  /* RETURN  */
    IF = 264,                      /* IF  */
    ELSE = 265,                    /* ELSE  */
    FOR = 266,                     /* FOR  */
    DO = 267,                      /* DO  */
    WHILE = 268,                   /* WHILE  */
    CONTINUE = 269,                /* CONTINUE  */
    BREAK = 270,                   /* BREAK  */
    SWITCH = 271,                  /* SWITCH  */
    CASE = 272,                    /* CASE  */
    GOTO = 273,                    /* GOTO  */
    DEFAULT = 274,                 /* DEFAULT  */
    VOID = 275,                    /* VOID  */
    PRIVATE = 276,                 /* PRIVATE  */
    PROTECTED = 277,               /* PROTECTED  */
    PUBLIC = 278,                  /* PUBLIC  */
    STATIC = 279,                  /* STATIC  */
    CONST = 280,                   /* CONST  */
    UNSIGNED = 281,                /* UNSIGNED  */
    VOLATILE = 282,                /* VOLATILE  */
    MUTABLE = 283,                 /* MUTABLE  */
    REGISTER = 284,                /* REGISTER  */
    SCOPE_RESOLUTION = 285,        /* SCOPE_RESOLUTION  */
    SHIFT_LEFT = 286,              /* SHIFT_LEFT  */
    SHIFT_RIGHT = 287,             /* SHIFT_RIGHT  */
    MODULUS = 288,                 /* MODULUS  */
    BIT_AND = 289,                 /* BIT_AND  */
    BIT_OR = 290,                  /* BIT_OR  */
    BIT_XOR = 291,                 /* BIT_XOR  */
    BIT_NOT = 292,                 /* BIT_NOT  */
    ESCAPE = 293,                  /* ESCAPE  */
    NUMBER = 294,                  /* NUMBER  */
    ID = 295,                      /* ID  */
    ARG = 296,                     /* ARG  */
    COLON = 297,                   /* COLON  */
    SPACE = 298                    /* SPACE  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif
/* Token kinds.  */
#define YYEMPTY -2
#define YYEOF 0
#define YYerror 256
#define YYUNDEF 257
#define INT 258
#define FLOAT 259
#define CHAR 260
#define REFERENCE 261
#define POINTER 262
#define RETURN 263
#define IF 264
#define ELSE 265
#define FOR 266
#define DO 267
#define WHILE 268
#define CONTINUE 269
#define BREAK 270
#define SWITCH 271
#define CASE 272
#define GOTO 273
#define DEFAULT 274
#define VOID 275
#define PRIVATE 276
#define PROTECTED 277
#define PUBLIC 278
#define STATIC 279
#define CONST 280
#define UNSIGNED 281
#define VOLATILE 282
#define MUTABLE 283
#define REGISTER 284
#define SCOPE_RESOLUTION 285
#define SHIFT_LEFT 286
#define SHIFT_RIGHT 287
#define MODULUS 288
#define BIT_AND 289
#define BIT_OR 290
#define BIT_XOR 291
#define BIT_NOT 292
#define ESCAPE 293
#define NUMBER 294
#define ID 295
#define ARG 296
#define COLON 297
#define SPACE 298

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 10 "src2/parser.y"

    int num;
    char* str;

#line 158 "build2/parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_BUILD2_PARSER_TAB_H_INCLUDED  */
