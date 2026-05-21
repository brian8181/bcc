
#include <iostream>
#include <boost/regex.hpp>
#include "lexer.hpp"
#include "log.hpp"
#include "definitions.hpp"
#include "on_token.hpp"

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
    switch (id)
    {
    case TEST_TOKEN:
        return parser::make_TEST_TOKEN(match);
    case PRINT:
        return parser::make_PRINT();
    case STRING:
        return parser::make_STRING();
    case INT:
        return parser::make_INT();
    case FLOAT:
        return parser::make_FLOAT();
    case CHAR:
        return parser::make_CHAR();
    case VOID:
        return parser::make_VOID();
    case SEMI_COLON:
        return parser::make_SEMI_COLON();
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

    case HASH_INCLUDE:
        return parser::make_HASH_INCLUDE();
    case IDENTIFIER:
        return parser::make_IDENTIFIER(match);
    case MOD:
        return parser::make_MOD();
    case ADD:
        return parser::make_ADD();
    case DASH:
        return parser::make_DASH();
    case MUL:
        return parser::make_MUL();
    case COMMA:
        return parser::make_COMMA();
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
    case ASSIGN:
        return parser::make_ASSIGN();
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
    case LSHIFT:
        return parser::make_LSHIFT();
    case RSHIFT:
        return parser::make_RSHIFT();
    case NUMERIC_LITERAL:
        return parser::make_NUMERIC_LITERAL(match);
    case REAL_LITERAL:
        return parser::make_REAL_LITERAL(match);
    case STRING_LITERAL:
        return parser::make_STRING_LITERAL(match);
    case CHAR_LITERAL:
        return parser::make_CHAR_LITERAL(match);
    case STRUCT:
        return parser::make_STRUCT();
    case TYPEDEF:
        return parser::make_TYPEDEF();
    case NEWLINE:
        m_line++;
        m_fstream << "// line:" << m_line << endl;
        return get_token();
    case WHITESPACE:
    case SKIP_TOK:
        TRACE();
        return get_token();
    default:;
    } // END switch
    cout << "UNDEFINED symbol found... id=" << id << ",  match=" << match << endl;
    return parser::make_UNDEFINED();
}
