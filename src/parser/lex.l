 %{
    #include "parser.tab2.h"
    #include <stdio.h>
    #include <string.h>

    /* include defines */
    #define MAX_INCLUDE_DEPTH 10
    YY_BUFFER_STATE include_stack[MAX_INCLUDE_DEPTH];
    int pstack = 0;

    int yylex(void);
    int yyerror(char* s);
    int fileno(FILE* f);

    extern char buf[100];
    extern char *s;
    char* strdup(char* str);

    #define YY_BUFFER YY_CURRENT_BUFFFER
%}

END_OF_FILE         \0
VALID_CHARS         _*[A-Za-z][A-Za-z0-9_]*
ID                  {VALID_CHARS}
CONST_ID            #{VALID_CHARS}#
ARRAY               {ID}\[[^\]]\]
COMMENT             \{[ \t]*\*[^*}]*\*[ \t]*\}
FILE_NAME           [A-Za-z0-9_.-~+#@]
IF                  if
END_IF              "\{/if\}"
FOREACH             foreach
END_FOREACH         "/foreach"
FOREACHELSE         foreachelse
END_FOREACHELSE     "/foreachelse"
ELSE                "else"
END_ELSE            "/else"
ELSEIF              "elseif"
END_ELSEIF          "/elseif"
VBAR                "|"
COLON               ":"
LBRACKET            "["
RBRACKET            "]"
LBRACE              "{"
RBRACE              "}"
LPAREN              "("
RPAREN              ")"
COMMA               ","
SEMI_COLON          ";"
DOUBLE_QUOTE        "\""
SINGLE_QUOTE        "'"
SLASH               "/"
BACK_SLASH          "\\"
AT                  "@"
PLUS                "+"
MINUS               "-"
ASTERIK             "*"
EQUAL               "="
NOT_EQUAL           "!="
DOT                 "."
INDIRECT_MEMBER     "->"
PERCENT             "%"
AMPERSAND           "&"
NOT                 "!"
AND                 "&&"
OR                  "||"
LESS_THAN           "<"
LESS_THAN_EQUAL     "<="
GREATER_THAN        ">"
GREATER_THAN_EQUAL  ">="
DOLLAR_SIGN         "$"
NUMERIC_LITERAL     [0-9]+
INCLUDE             "include"
REQUIRE             require
CONFIG_LOAD         config_load
INSERT              insert
FILE_ATTRIB         file
ASSIGN              assign
VAR_ATTRIB          var
VALUE_ATTRIB        value

%x DOUBLE_QUOTED
%x SINGLE_QUOTED
%x ESCAPED
%x IF_BLOCK
%x IF_CONDITION
%x INCLUDING
%x OFF
%%

<INITIAL>{
{COMMENT}                               {  /* eat up comment */ printf("LEX:COMMENT=\"%s\"", yytext); }
{LBRACE}                                {
                                            printf("LEX:LBRACE\n");
                                            printf("LEX:BEGIN ESCAPED\n");
                                            BEGIN(ESCAPED);
                                            return LBRACE;
                                        }
                                        }
<SINGLE_QUOTED,DOUBLE_QUOTED>{
\\n                                     { *s++ = '\n'; }
\\t                                     { *s++ = '\t'; }
\\\"                                    { *s++ = '\"'; }
[\n}]                                   { printf("LEX: missing closing quote"); exit(1); }
                                                                                         }
<SINGLE_QUOTED>{
{FILE_NAME}                             { *s++ = *yytext; }
{SINGLE_QUOTE}                          {
                                            printf("LEX:SINGLE_QUOTE\n");
                                            printf("LEX:BEGIN ESCAPED\n");
                                            BEGIN(ESCAPED);
                                            *s = 0;
                                            printf("LEX:STRING_LITERAL=\"%s\"\n", buf);
                                            return STRING_LITERAL;
                                        }
                                        }
<DOUBLE_QUOTED>{
{FILE_NAME}                             { *s++ = *yytext; }
{DOUBLE_QUOTE}                          {
                                            printf("LEX:DOUBLE_QUOTE\n");
                                            printf("LEX:BEGIN ESCAPED\n");
                                            BEGIN(ESCAPED);
                                            *s = 0;
                                            printf("LEX:STRING_LITERAL=\"%s\"\n", buf);
                                            return STRING_LITERAL;
                                        }
                                        }
<ESCAPED>{
{RBRACE}                                {
                                            printf("LEX:RBRACE\n");
                                            printf("LEX:BEGIN INITIAL\n");
                                            BEGIN(INITIAL);
                                            return RBRACE;
                                        }
{SINGLE_QUOTE}                          { printf("LEX:BEGIN_SINGLE_QUOTED\n"); BEGIN(SINGLE_QUOTED); s = buf; }
{DOUBLE_QUOTE}                          { printf("LEX:BEGIN_DOUBLE_QUOTED\n"); BEGIN(DOUBLE_QUOTED); s = buf; }
{NUMERIC_LITERAL}                       {
                                            printf("LEX:NUMERIC_LITERAL=%s\n", yytext);
                                            yylval.sval = strdup(yytext);
                                            return NUMERIC_LITERAL;
                                        }
{ASSIGN}                                { printf("LEX:ASSIGN\n");                         return ASSIGN;                        }
{REQUIRE}                               { printf("LEX:REQUIRE\n");                        return REQUIRE;                       }
{CONFIG_LOAD}                           { printf("LEX:CONFIG_LOAD\n");                    return CONFIG_LOAD;                   }
{INSERT}                                { printf("LEX:INSERT\n");                         return INSERT;                        }
{INCLUDE}                               { printf("LEX:INCLUDE\n"); /*BEGIN(INCLUDING);*/  return INCLUDE;                       }
{FILE_ATTRIB}                           { printf("LEX:FILE_ATTRIB\n");                    return FILE_ATTRIB;                   }
{VAR_ATTRIB}                            { printf("LEX:VAR_ATTRIB\n");                     return VAR_ATTRIB;                    }
{VALUE_ATTRIB}                          { printf("LEX:VALUE_ATTRIB\n");                   return VALUE_ATTRIB;                  }
{NOT}                                   { printf("LEX:NOT\n");                            return NOT;                           }
{AND}                                   { printf("LEX:AND\n");                            return AND;                           }
{OR}                                    { printf("LEX:OR\n");                             return OR;                            }
{LESS_THAN}                             { printf("LEX:LESS_THAN\n");                      return LESS_THAN;                     }
{LESS_THAN_EQUAL}                       { printf("LEX:LESS_THAN_EQUAL\n");                return LESS_THAN_EQUAL;               }
{GREATER_THAN}                          { printf("LEX:GREATER_THAN\n");                   return GREATER_THAN;                  }
{GREATER_THAN_EQUAL}                    { printf("LEX:GREATER_THAN_EQUAL\n");             return GREATER_THAN_EQUAL;            }
{SLASH}                                 { printf("LEX:SLASH\n");                          } // return SLASH;                    }
{BACK_SLASH}                            { printf("LEX:BACK_SLASH\n");                     } // return BACK_SLASH;               }
{VBAR}                                  { printf("LEX:VBAR\n");                           return VBAR;                          }
{AMPERSAND}                             { printf("LEX:AMPERSAND\n");                      return AMPERSAND;                     }
{DOLLAR_SIGN}                           { printf("LEX:DOLLAR_SIGN\n", yytext);            return DOLLAR_SIGN;                   }
{AT}                                    { printf("LEX:AT\n");                             } // return AT;                       }
{PLUS}                                  { printf("LEX:PLUS\n");                           return PLUS;                          }
{MINUS}                                 { printf("LEX:MINUS\n");                          return MINUS;                         }
{ASTERIK}                               { printf("LEX:ASTERIK\n");                        return ASTERIK;                       }
{EQUAL}                                 { printf("LEX:EQUAL\n");                          return EQUAL;                         }
{NOT_EQUAL}                             { printf("LEX:NOT_EQUAL\n");                      return NOT_EQUAL;                     }
{DOT}                                   { printf("LEX:DOT\n");                            return DOT;                           }
{INDIRECT_MEMBER}                       { printf("LEX:INDIRECT_MEMBER\n");                return INDIRECT_MEMBER;               }
{PERCENT}                               { printf("LEX:PERCENT\n");                        return PERCENT;                       }
{COLON}                                 { printf("LEX:COLON\n");                          return COLON;                         }
{COMMA}                                 { printf("LEX:COMMA\n");                          return COMMA;                         }
{LBRACKET}                              { printf("LEX:LBRACKET\n");                       return LBRACKET;                      }
{RBRACKET}                              { printf("LEX:RBRACKET\n");                       return RBRACKET;                      }
{LPAREN}                                { printf("LEX:LPAREN\n");                         return LPAREN;                        }
{RPAREN}                                { printf("LEX:RPAREN\n");                         return RPAREN;                        }
{SEMI_COLON}                            { printf("LEX:SEMI_COLON\n");                     return SEMI_COLON;                    }
{END_IF}                                { printf("LEX:END_IF\n"); BEGIN(ESCAPED);          } // return IF;                      }
{IF}                                    { printf("LEX:IF_BLOCK\n"); BEGIN(IF_BLOCK);       } // return IF;                      }
{ELSE}                                  { printf("LEX:ELSE_BLOCK\n"); BEGIN(IF_BLOCK);     } // return ELSE;                    }
{ELSEIF}                                { printf("LEX:ELSEIF\n"); BEGIN(IF_BLOCK);         } // return ELSEIF;                  }
{FOREACHELSE}                           { printf("LEX:FOREACHELSE\n"); BEGIN(IF_BLOCK);    } // return FOREACHELSE;             }
{FOREACH}                               { printf("LEX:FOREACH\n"); BEGIN (IF_BLOCK);       } // return FOREACH;                 }
{END_ELSE}                              { printf("LEX:ELSE_BLOCK\n"); BEGIN(ESCAPED);      } // return ELSE;                    }
{END_ELSEIF}                            { printf("LEX:END_ELSEIF\n"); BEGIN(ESCAPED);      } // return ELSEIF;                  }
{END_FOREACHELSE}                       { printf("LEX:FOREACHELSE\n"); BEGIN(ESCAPED);     } // return FOREACHELSE;             }
{END_FOREACH}                           { printf("LEX:FOREACH\n"); BEGIN(ESCAPED);         } // return FOREACH;                 }
{CONST_ID}                              { printf("LEX:[CONST_ID:%s]\n", yytext); yylval.sval = strdup(yytext); return CONST_ID; }
{ID}                                    { printf("LEX:[ID:%s]\n", yytext); yylval.sval = strdup(yytext); return ID;             }
[ \t]*                                  { /********************************** eat whitespace *********************************/ }
                                        }
<IF_CONDITION>{
{RBRACE}                                { printf("LEXIF_BLOCK"); BEGIN(IF_BLOCK); }
[^}]                                    { ECHO; }
                                        }
<IF_BLOCK>[^{]                          { ECHO; }
<INCLUDING>[^ \t\n]+                    {
                                            printf("LEX:INCLUDING \"%s\"\n", buf);
                                            /* include file name */
                                            if ( pstack >= MAX_INCLUDE_DEPTH )
                                            {
                                                fprintf( stderr, "error: includes nested too deeply" );
                                                exit( 1 );
                                            }
                                            include_stack[pstack++] = YY_CURRENT_BUFFER;

                                            yyin = fopen( yytext, "r" );
                                            if ( ! yyin )
                                            {
                                                printf( "error: could not open file, %s", yytext );
                                            }

                                            yy_switch_to_buffer( yy_create_buffer( yyin, YY_BUF_SIZE ) );
                                            printf("LEX:BEGIN INITIAL\n");
                                            BEGIN(INITIAL);
                                        }
<<EOF>>                                 {

                                            printf("LEX:<<EOF>>\n");
                                            //yyrestart( yyin );
                                            /* if ( --pstack < 0 )
                                            {
                                                yyterminate();
                                            }
                                            else
                                            {
                                                yy_delete_buffer( YY_CURRENT_BUFFER );
                                                yy_switch_to_buffer(
                                                include_stack[pstack] );
                                            } */
                                            //return 0;
                                            return END;
                                        }

%%

char* strdup(char* s)
{
    char* dup = (char*)malloc((strlen(s) * sizeof(char)) + 1);
    strcpy(dup, s);
    return dup;
}

#ifdef LEXER_EXE
int yywrap(void)
{
    return 1;
}

int yyerror(char *s)
{
    fprintf(stderr, "%s\n", s);
    return 0;
};
#endif

#ifdef MAIN_IMP
int main(int argc, char** argv)
{
    if(argc < 2)
    {
        /* just read stdin */
        yylex();
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
        yylex();
        fclose(f);
    }
    return 0;
}
#endif
