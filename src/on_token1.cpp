
#include <iostream>
#include <boost/regex.hpp>
#include "lexer.hpp"
#include "log.hpp"
#include "def1.hpp"
#include "on_token1.hpp"

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
    //return parser::symbol_type (id);

    switch(m_pstate->id)
    {
    case UL_PARSER:
    {
        switch (id)
        {
        case parser::token::DOUBLE_QUOTE:
             set_state(&PARSE_DOUBLE_QUOTE);
            return parser::make_DOUBLE_QUOTE();
        default:;
        } // END switch
    }
    case UL_PARSE_DOUBLE_QUOTE:
    {
        switch(id)
        {
            // case VALID_CHARS:
            //     static string str;
            //     str += match;
            //     return get_token();
            // case parser::token::DOUBLE_QUOTE:
            //     set_state( &PARSER );
            //     return parser::make_STRING_LITERAL(str);
            // case ESC_BACKSLASH:
            //     return parser::make_ESC_BACKSLASH();
            // case ESC_NEWLINE:
            //     return parser::make_ESC_NEWLINE();
            // case ESC_DOUBLE_QUOTE:
            //     return parser::make_ESC_DOUBLE_QUOTE();
            // case ESC_SINGLE_QUOTE:
            //     return parser::make_ESC_SINGLE_QUOTE();
            // case ESC_TAB:
            //     return parser::make_ESC_TAB();
            default: ;
        }
    } // end double quote state
}
    cout << "UNDEFINED symbol found... id=" << id << ",  match=" << match << endl;
    return parser::make_UNDEFINED();
}
