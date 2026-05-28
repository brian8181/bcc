
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
#include "on_token.hpp"
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
				0,
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
 * @param const string& file
 * @return bool
 */
bool lexer::init(const string& file)
{
	// input stream
	fs::path p = file;
	m_ifile = p.replace_extension("i");
	INFO(m_ifile);
	m_buffer.clear();
	read_str( m_ifile, m_buffer );

	// output stream
	m_ofile = p.replace_extension("asm");
	INFO(m_ofile);
	m_fstream.open(m_ofile, std::ios_base::out | std::ios::trunc);
	initalized = m_fstream.is_open();
	TRACE();
	return initalized;
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
	const unsigned long len = p_state->tokens.size();
	string e;
	//build_search_expression(p_state->tokens, g_tokens, e);
	ATTN(e);

	for( unsigned long i = 0; i < len; i++ )
	{
		token_t* ptoken = p_state->tokens[i];
		stringstream info;
		info << std::left << "#" << setw(2)  << i << "   "
			<< "id:   " << std::setw( 4 ) << std::right << ptoken->id
			<< "    ~    " << std::right << "idx: " << std::setw( 3 ) << std::left << ptoken->index
			<< "    ~    " << std::left << "name: " << std::setw( 18 ) << std::left << ptoken->name
			<< "    ~    " << std::left << "type: " << std::setw( 10 ) << ptoken->stype
			<< "    ~    " << std::left << "regex: " << std::left << std::setw( 44 ) << ptoken->rexp << std::right;

		cout << ( ( i % 2 ) ? FMT_BG_BLACK : FMT_BG_DARK_GREY ) << FMT_FG_LIGHT_YELLOW
			<< info.str() << FMT_RESET << endl;
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
	ss << gt(id).rexp;
	// get / append remaining strings
	for(int i = 1; i < sz; ++i)
	{
		token_t token = table[tokens[i]];
		ss << "|(" << token.rexp << ")";
		//ss << "|(?<" << token.name << ">" << token.rexp << ")";
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
	//TRACE();
	// if( EOFS )
	// {
	// 	return on_token( *gt(END_OF_FILES).id, 0 );
	// }

	if( m_buffer.empty() )
	{
		//EOFS = !next_file();
		return 0;  // this fucking works ...
		// parser::make_YYerror();
		// return on_token( *gt(END_OF_FILE).id, 0 );
	}

	//INFO(m_regex_str);
	auto rexp = boost::regex( m_regex_str, boost::regex::extended );
	//TRACE();
	//INFO(m_buffer.size());
	auto iter = boost::sregex_iterator( m_buffer.begin(), m_buffer.end(), rexp );
	//TRACE();
	auto end = boost::sregex_iterator();
	//TRACE();
	boost::smatch m( *iter );
	//TRACE();
	string match = m.str();
	//TRACE();
	const size_t len = m.size();

	//TRACE();
	if( iter != end )
	{
		for( int i = 1; i < len; ++i )
		{
			if( m[i].matched )
			{
				//assert(!m.prefix().matched); // unmatched, error
				if( m.prefix().matched )
				{
					ERROR("PREFIX_ERROR");
					return EOF;
				}
				// get match : by sub_match index (i)
				token_t* token =  p_state->tokens[i - 1];
				print_smatch(*token,  m );
				// set buffer to suffix
				m_buffer = m.suffix();
				return on_token( token->id, match );
			}
		}
		return parser::make_YYerror(); // no sub match?, should not happen
	}
	ATTN( "END_OF_FILE" );
	//TRACE();
	return parser::make_END_OF_FILE();
}

/**
 * @name  print_token
 * @brief print token to stdout
 * @param token_match m
 */
void lexer::print_smatch(const token_t& t, boost::smatch m)
{
	string prefix = esc_nl( m.prefix() ).get_val();
	string match = 	esc_nl( m.str() ).get_val();
	string suffix = esc_nl( m.suffix() ).get_val();

	// int pw = prefix.size();
	// int mw  = pw + match.size();
	// int sw = mw + suffix.size();

	prefix = prefix.size() != 0 ? ("\"" + prefix + "\"") : FMT_FG_RED + "null" + FMT_RESET;
	match = match.size() != 0 ? ("\"" + match + "\"")  : FMT_FG_RED + "null" + FMT_RESET;
	suffix = suffix.size() != 0 ? ("\"" + suffix + "\"")  : FMT_FG_RED +  "null" + FMT_RESET;

	INFO(FMT_FG_GREEN << "prefix" << FMT_RESET << "[ " << FMT_ITALIC  << std::right << prefix << FMT_RESET_ITALIC << " ](" << prefix.size() << ")" << FMT_RESET);
	INFO(FMT_FG_GREEN << "match " << FMT_RESET << "[ " << FMT_ITALIC  << std::right << match  << FMT_RESET_ITALIC << " ](" << match.size()  << ")" << FMT_RESET);
	INFO(FMT_FG_GREEN << "suffix" << FMT_RESET  << "[ " << FMT_ITALIC << std::right << suffix << FMT_RESET_ITALIC << " ](" << suffix.size() << ")" << FMT_RESET);
}

/**
 * @brief print_token
 *
 */
void lexer::print_token()
{
	// stringstream info;
	// 	info << std::left << "#" << setw(2)  << i << "   "
	// 		<< "id:   " << std::setw( 4 ) << std::right << id
	// 		<< "    ~    " << std::right << "idx: " << std::setw( 3 ) << std::left << ptoken->index
	// 		<< "    ~    " << std::left << "name: " << std::setw( 18 ) << std::left << ptoken->name
	// 		<< "    ~    " << std::left << "type: " << std::setw( 10 ) << ptoken->stype
	// 		<< "    ~    " << std::left << "regex: " << std::left << std::setw( 44 ) << rstr.str() << std::right;

	// 	cout << ( ( i % 2 ) ? FMT_BG_BLACK : FMT_BG_DARK_GREY ) << FMT_FG_LIGHT_YELLOW
	// 		<< info.str() << FMT_RESET << endl;
}

/**
 * @brief stream operator
 *
 * @param os
 * @param lex
 * @return std::ostream&
 */
std::ostream& operator<<(std::ostream& os, const lexer& lex)
{
    return os; // Return stream to allow chaining
}

//
