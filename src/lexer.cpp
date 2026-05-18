
/**
 * @file    lexer.cpp
 * @version 0.0.1
 * @date    Fri, 26 Sep 2025 17:05:10
 */

#define _GNU_SOURCE

#include <iostream>
#include <iomanip>
#include <map>
#include <regex>
#include <sstream>
#include <string>
#include <utility>
#include <vector>
//#include <assert>
#include <stdio.h>
#include <string.h>
#include <filesystem>
#include <boost/regex.hpp>
#include <fmt/core.h>
#include <fmt/format.h>
#include "fileio.hpp"
#include "lexer.hpp"
#include "driver.hpp"
#include "utility.hpp"
#include "bash_color.hpp"
#include "log.hpp"
namespace fs = std::filesystem;

using std::cerr;
using std::cout;
using std::endl;
using std::left;
using std::map;
using std::pair;
using std::right;
using std::setw;
using std::string;
using std::vector;
using yy::parser;

/**
 * @name   load_config
 * @def    void lexer::load_config( const string &file )
 * @brief  load_config: load configuration from file
 * @param  file
 * @param  const string& file
 * @return void
 */
void lexer::load_config( const string& file )
{
	g_config_file = file;
	string section = "none";
	string s;
	read_str( g_config_file, s );
	auto rgx = boost::regex( CONFIG_SECTIONS );
	boost::smatch terminal_match;
	// begins terminal section
	boost::regex_search( s, terminal_match, rgx, boost::match_not_bol | boost::match_not_eol );
	boost::smatch groups_match;
	// ends terminal section, begin group section
	string terminal_suffix = terminal_match.suffix();
	boost::regex_search( terminal_suffix, groups_match, rgx, boost::match_not_bol | boost::match_not_eol );
	// now get section
	string token_section = groups_match.prefix();
	// stream & parse tokens section
	std::istringstream input1;
	input1.str( token_section );
	unsigned long j = 0;
	for( std::string line; std::getline( input1, line ); j++ )
	{
		auto config_rgx = boost::regex( CONFIG );
		boost::smatch token_match;
		boost::regex_match( line, token_match, config_rgx );
		if( constexpr unsigned int ID_PAIR = 1; token_match[ID_PAIR].matched )
		{
			string name = token_match["name"].str();
			string expr = token_match["rexp"].str();
			string stype = token_match["type"].str();
			string test_val = token_match["test"].str();
			auto* ptoken = new token_t {
				string( name ),
				stype,
				string( expr ),
			};
			// copy to term to vector
			m_tokens.push_back( *ptoken );
			m_tok_map[ptoken->index] = *ptoken;
		}
	}
	// ends group section, begin states section
	string groups_suffix = groups_match.suffix();
	boost::smatch states_match;
	boost::regex_search( groups_suffix, states_match, rgx, boost::match_not_bol | boost::match_not_eol );
	string groups_section = states_match.prefix();
	string states_section = states_match.suffix();
	// stream & parse tokens section
	std::istringstream input2;
	input2.str( states_section );
	for( std::string line; std::getline( input2, line );)
	{
		auto config_states_rgx = boost::regex( CONFIG_STATES );
		boost::regex_match( line, states_match, config_states_rgx );
		if( states_match["states"].matched )
		{
			string str_state = states_match["state"].str();   // new state to create
			string str_tokens = states_match["tokens"].str(); // csv tokens for that state
			unsigned long i = 0ul;
			unsigned long state_id = 0xFFul | ( ++i * 6ul );  // generate id for new state
			state_t stat { state_id, str_state };    // create new state
			m_states.push_back( stat );
			// copy to term to vector
			vector<token_t> tokens;                           // token vector for this state
			std::stringstream ss( str_tokens );               // csv of states
			std::string str_token;                            // item in csv states
			// use get line to split on commas
			while( std::getline( ss, str_token, ',' ) )
			{
				token_t ptoken;
				m_tokens.push_back( ptoken );
			}
		}
	}
}

/**
 * @name  init
 * @brief initialize input
 * @param argc, input file count
 * @param argv, const char* file names
 * @return void
 */
bool lexer::init( const int argc, char* argv[] )
{
	for(int i = 0; i < argc; ++i)
	{
		fs::path p = argv[i];
		if(!fs::exists(p))
		{
			ERROR("file error: \"" << p << "\" does not exist. ");
			return false;
		}
		m_input_paths.push_back(p);
	}
	m_fstream.open( "build/a.out", std::ios_base::out | std::ios::trunc );
	initalized = true;
	return next_file();
}

/**
 * @name   next_file
 * @brief  moves lexer to next file
 * @return bool
 */
bool lexer::next_file()
{
	if(static int i = 0; i < m_input_paths.size() )
	{
		m_ifile = string( m_input_paths[i] );
		m_buffer.clear();
		read_str( m_ifile, m_buffer );

		// set state
		set_state( &INITIAL );
		m_line = 0;
		++m_file_count;
		++i;

		// todo close open stream & open one for next file
		fs::path p = m_ifile;
		p.replace_extension(".html");
		m_ofile = (string)p;

		INFO("output file=\"" << m_ofile << "\"");
		INFO( "initialized buffer - [ \"" << esc_nl( m_buffer ).get_val() << "\" ]" );
		return true;
	}
	// flush close current
	if( m_fstream.is_open() )
	{
		m_fstream.flush();
		m_fstream.close();
	}
	return false;
}

/**
 * @name   set_state_flag
 * @brief  void set_state(state_t* pstate)
 * @return void
 */
void lexer::set_state( state_t* pstate )
{
	ATTN( "Enter set_state ~ " << p_state->id << ":" << p_state->name << " ~~> " << pstate->id << ":" << pstate->name );
	p_state = pstate;
	// just update for now
	stringstream ss;
	const vector<unsigned long>* STATE_TOKENS = g_state_tokens[p_state->id];
	const unsigned long len = STATE_TOKENS->size();

	string e;
	build_search_expression(*STATE_TOKENS, g_tokens, e);
	ATTN(e);

	for( unsigned long i = 0; i < len; i++ )
	{
		unsigned long id = ( *STATE_TOKENS )[i];
		token_t* ptoken = &g_tokens[id];

		stringstream rstr;
		rstr << "\"" << ptoken->rexp << "\"";
		stringstream info;
		info << std::left << "#" << setw(2)  << i << "   "
			<< "id:   " << std::setw( 4 ) << std::right << id
			<< "    ~    " << std::right << "idx: " << std::setw( 3 ) << std::left << ptoken->index
			<< "    ~    " << std::left << "name: " << std::setw( 18 ) << std::left << ptoken->name
			<< "    ~    " << std::left << "type: " << std::setw( 10 ) << ptoken->stype
			<< "    ~    " << std::left << "regex: " << std::left << std::setw( 44 ) << rstr.str() << std::right;

		cout << ( ( i % 2 ) ? FMT_BG_BLACK : FMT_BG_DARK_GREY ) << FMT_FG_LIGHT_YELLOW
			<< info.str() << FMT_ITALIC << FMT_RESET << endl;

//   	ss << "(?<" << ptoken->name << ">)" << ptoken->rexp << ")|";
		ss << "(" << ptoken->rexp << ")|";
	}

	// save expression string ...
	m_regex_str = ss.str();
	m_regex_str.pop_back(); // remove extra '|' i.e. "V-BAR"
	ATTN( "Exit set_state ~ " << p_state->id << ":" << p_state->name );
}

/**
 * @name build_search_expression
 * @brief contruct a search string from tokens, denoted by id's / table
 * @param const vector<unsigned long>& tokens
 * @param const map<unsigned long, token>& table
 * @param string& s
 * @return string&, contructed search string
 */
string& lexer::build_search_expression(const vector<unsigned long>& tokens, map<unsigned long, token>& table, /*out*/ string& s)
{
	std::size_t sz = std::size(tokens);
	assert(sz > 0);
	// get / append first string
	unsigned long id = tokens[0];
	stringstream ss;
	ss << table[id].rexp;
	// get / append remaining strings 
	for(int i = 1; i < sz; ++i)
	{
		token_t token = table[tokens[i]];
		ss << "|(" << token.rexp << ")";
	}
	// set return value
	s = ss.str();
	return s;
}

/**
 * @name push_include
 * @brief prepend include file contents to beginning of buffer
 */
void lexer::push_include( const string& file )
{
	// trimming quotes ...
	string file_tmp = file;
	file_tmp.erase(file.size()-1,1);
	file_tmp.erase(0,1);

	stringstream ss; 
	read_sstream(string(file_tmp), ss);  	       // read include file
	ss << m_buffer;
	m_buffer.clear();
	m_buffer = ss.str();                           // set current buffer
}

/**
 * @name   get_token
 * @def    parser::symbol_type lexer::get_token()
 * @return int
 */
parser::symbol_type lexer::get_token()
{
	if( EOFS )
		return parser::make_END_OF_FILES();

	if( m_buffer.empty() )
	{
		EOFS = !next_file();
		return parser::make_END_OF_FILE();
	}

	auto rexp = boost::regex( m_regex_str, boost::regex::extended );
	auto iter = boost::sregex_iterator( m_buffer.begin(), m_buffer.end(), rexp );
	auto end = boost::sregex_iterator();
	boost::smatch m( *iter );
	string match = m.str();
	const size_t len = m.size();

	if( iter != end )
	{
		for( int i = 1; i < len; ++i )
		{
			if( m[i].matched )
			{
				assert(!m.prefix().matched); // unmatched, error
				if( m.prefix().matched )
				{
					ERROR("PREFIX_ERROR");
					return EOF;
				}
				// get match : by sub_match index (i)
				unsigned long id = ( *g_state_tokens[p_state->id] )[i - 1];
				token_t token = g_tokens[id];
				print_smatch(token,  m );
				// set buffer to suffix
				m_buffer = m.suffix();
				return on_token( id, match );
			}
		}
		return parser::make_YYerror(); // no sub match?, should not happen
	}
	ATTN( "END_OF_FILE" );
	return parser::make_END_OF_FILE();
}

/**
 * @name  print_token
 * @brief print token to stdout
 * @param token_match m
 */
void lexer::print_smatch(token_t t, boost::smatch m)
{
	INFO(	"match.pos:" << m.position()   << " - match.sz:"  << m.str().size()
									       << " - prefix.sz:" << m.prefix().str().size()
									       << " - suffix.sz:" << m.suffix().str().size()	);

    INFO(	"match" 								      << FMT_FG_WHITE << "[ " << t.index << " : " << t.name                     << " ] "\
												          << FMT_FG_WHITE << "[ " << "\"" << esc_nl( m.str()    ).get_val() << "\"" << " ]" << FMT_RESET \
			<< FMT_ITALIC << FMT_FG_GREEN <<  " - prefix" << FMT_FG_WHITE << "[ " << "\"" << esc_nl( m.prefix() ).get_val() << "\"" << " ]" << FMT_RESET \
			<< FMT_ITALIC << FMT_FG_GREEN <<  " - suffix" << FMT_FG_WHITE << "[ " << "\"" << esc_nl( m.suffix() ).get_val() << "\"" << " ]" << FMT_RESET		);
}

/**
 * @name  on_token
 * @brief override virtual, on_token, for each token ...
 * @param unsigned long id
 * @param string match: current match
 * @return parser::symbol_type
 */
parser::symbol_type lexer::on_token( unsigned long id, const string& match )
{
	switch( id )
	{
		case TEST_TOKEN:
			return parser::make_TEST_TOKEN( match );
		case PRINT:
			return parser::make_PRINT();
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
		case WHILE:
			return parser::make_WHILE();
		case IF:
			return parser::make_IF();
		case ELSE:
			return parser::make_ELSE();
		case _INCLUDE:
			return parser::make_INCLUDE();
		case IDENTIFIER:
			return parser::make_IDENTIFIER( match );
		case MOD:
			return parser::make_MOD();
		case ADD:
			return parser::make_ADD();
		case SUB:
			return parser::make_SUB();
		case MUL:
			return parser::make_MUL();
		case COMMA:
			return parser::make_COMMA();
		case DIV:
			return parser::make_DIV();
		case EQ:
			return parser::make_EQ();
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
			return parser::make_NUMERIC_LITERAL( match );
		case REAL_LITERAL:
			return parser::make_REAL_LITERAL( match );
		case STRING_LITERAL:
			return parser::make_STRING_LITERAL( match );
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

// Overload definition
std::ostream& operator<<(std::ostream& os, const lexer& lex) 
{
    return os; // Return stream to allow chaining
}
