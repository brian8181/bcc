
#include <iostream>
#include <boost/regex.hpp>
#include "lexer.hpp"
#include "log.hpp"
#include "v2/def.hpp"
#include "v2/on_token.hpp"

using std::cout;
using std::endl;

/**
 * @name  on_token
 * @brief override virtual, on_token, for each token ...
 * @param unsigned long id
 * @param string match: current match
 * @return parser::symbol_type
 */
parser::symbol_type lexer::on_token(unsigned long id, const string &match)
{
    switch(m_pstate->id)
    {
    case UL_PARSER:
    {
        switch (id)
        {
        case TEST_TOKEN:
            return parser::make_TEST_TOKEN(match);
        case DOUBLE_QUOTE:
            set_state(&PARSE_DOUBLE_QUOTE);
            return get_token();
        case STRING:
            return parser::make_STRING();
        case SHORT:
            return parser::make_SHORT();
        case INT:
            return parser::make_INT();
        case LONG:
            return parser::make_LONG();
        case SINGLE:
            return parser::make_SINGLE();
        case FLOAT:
            return parser::make_FLOAT();
        case DOUBLE:
            return parser::make_DOUBLE();
        case CHAR:
            return parser::make_CHAR();
        case VOID:
            return parser::make_VOID();
        case SIGNED:
            return parser::make_SIGNED();
        case UNSIGNED:
            return parser::make_UNSIGNED();
        case CONST:
            return parser::make_CONST();
        case STATIC:
            return parser::make_STATIC();
        case VOLATILE:
            return parser::make_VOLATILE();
        case REGISTER:
            return parser::make_REGISTER();
        case PTR:
            return parser::make_PTR();
        case STRUCT:
            return parser::make_STRUCT();
        case TYPEDEF:
            return parser::make_TYPEDEF();
        case PRINT:
            return parser::make_PRINT();

        case STRING_LITERAL:
            return parser::make_STRING_LITERAL(match);
        case NUMERIC_LITERAL:
            return parser::make_NUMERIC_LITERAL(match);
        case REAL_LITERAL:
            return parser::make_REAL_LITERAL(match);
        case CHAR_LITERAL:
            return parser::make_CHAR_LITERAL(match);

        case LBRACE:
            return parser::make_LBRACE();
        case RBRACE:
            return parser::make_RBRACE();
        case LBRACKET:
            return parser::make_LBRACKET();
        case RBRACKET:
            return parser::make_RBRACKET();
        case LPAREN:
            return parser::make_LPAREN();
        case RPAREN:
            return parser::make_RPAREN();
        case SEMI_COLON:
            return parser::make_SEMI_COLON();
        case COLON:
            return parser::make_COLON();
        case COMMA:
            return parser::make_COMMA();
        case QUESTION_MARK:
            return parser::make_QUESTION_MARK();
        case BACKSLASH:
            return parser::make_BACKSLASH();
        case DOT:
            return parser::make_DOT();
        case SINGLE_QUOTE:
            return parser::make_SINGLE_QUOTE();

        case FOR:
            return parser::make_FOR();
        case DO:
            return parser::make_DO();
        case WHILE:
            return parser::make_WHILE();
        case IF:
            return parser::make_IF();
        case RETURN:
            return parser::make_RETURN();
        case ELSE:
            return parser::make_ELSE();
        case ELSEIF:
            return parser::make_ELSEIF();
        case BREAK:
            return parser::make_BREAK();
        case CONTINUE:
            return parser::make_CONTINUE();
        case GOTO:
            return parser::make_GOTO();
        case LABEL:
            return parser::make_LABEL();

        case MOD:
            return parser::make_MOD();
        case ADD:
            return parser::make_ADD();
        case DASH:
            return parser::make_DASH();
        case MUL:
            return parser::make_MUL();
        case DIV:
            return parser::make_DIV();
        case EQ:
            return parser::make_EQ();
        case NEQ:
            return parser::make_NEQ();
        case GEQ:
            return parser::make_GEQ();
        case LEQ:
            return parser::make_LEQ();
        case GT:
            return parser::make_GT();
        case LT:
            return parser::make_LT();
        case AND:
            return parser::make_AND();
        case OR:
            return parser::make_OR();
        case NOT:
            return parser::make_NOT();
        case BIT_AND:
            return parser::make_BIT_AND();
        case BIT_OR:
            return parser::make_BIT_OR();
        case BIT_NOT:
            return parser::make_BIT_NOT();
        case BIT_XOR:
            return parser::make_BIT_XOR();
        case LSFT:
            return parser::make_LSFT();
        case RSFT:
            return parser::make_RSFT();

        case INC:
            return parser::make_INC();
        case ADD_EQ:
            return parser::make_ADD_EQ();
        case SUB_EQ:
            return parser::make_SUB_EQ();
        case MUL_EQ:
            return parser::make_MUL_EQ();
        case DIV_EQ:
            return parser::make_DIV_EQ();
        case MOD_EQ:
            return parser::make_MOD_EQ();
        case OR_EQ:
            return parser::make_OR_EQ();
        case AND_EQ:
            return parser::make_AND_EQ();
        case NOT_EQ:
            return parser::make_NOT_EQ();
        case XOR_EQ:
            return parser::make_XOR_EQ();
        case LSFT_EQ:
            return parser::make_LSFT_EQ();
        case RSFT_EQ:
            return parser::make_RSFT_EQ();
        case TENERARY:
            return parser::make_TENERARY();
        case ASSIGN:
            return parser::make_ASSIGN();

        case IDENTIFIER:
            return parser::make_IDENTIFIER(match);


        case NEWLINE:
            m_line++;
            m_fstream << "// line:" << m_line << endl;
            return get_token();
        case WHITESPACE:
            return get_token();
        case SKIP_TOK:
            TRACE();
            return get_token();
        case END_OF_FILE:
            return parser::make_END_OF_FILE();
        case END_OF_FILES:
            return parser::make_END_OF_FILES();
        default:;
        } // END switch
    }
    case UL_PARSE_DOUBLE_QUOTE:
    {
        switch(id)
        {
            case VALID_CHARS:
                static string str;
                str += match;
                return get_token();
            case DOUBLE_QUOTE:
                set_state( &PARSER );
                return parser::make_STRING_LITERAL(str);
            case ESC_BACKSLASH:
                return parser::make_ESC_BACKSLASH();
            case ESC_NEWLINE:
                return parser::make_ESC_NEWLINE();
            case ESC_DOUBLE_QUOTE:
                return parser::make_ESC_DOUBLE_QUOTE();
            case ESC_SINGLE_QUOTE:
                return parser::make_ESC_SINGLE_QUOTE();
            case ESC_TAB:
                return parser::make_ESC_TAB();
            default: ;
        }
    } // end double quote state
}
    cout << "UNDEFINED symbol found... id=" << id << ",  match=" << match << endl;
    return parser::make_UNDEFINED();
}
