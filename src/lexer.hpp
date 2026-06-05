    /**
 * @file    lexer.hpp
 * @version 0.0.1
 * @date    Fri, 26 Sep 2025 17:05:10
 */
#ifndef _LEXER_HPP_
#define _LEXER_HPP_

#ifdef _MSC_VER
#define forceinline __forceinline
#elif defined(__GNUC__)
#define forceinline inline __attribute__((__always_inline__))
#elif defined(__CLANG__)
#if __has_attribute(__always_inline__)
#define forceinline inline __attribute__((__always_inline__))
#else
#define forceinline inline
#endif
#else
#define forceinline inline
#endif

#include <iostream>
#include <memory>
#include <iterator>
#include <map>
#include <stack>
#include <fstream>
#include <sstream>
#include <string>
#include <utility>
#include <vector>
#include <iomanip>
#include <boost/regex.hpp>
#include "fileio.hpp"


#ifdef VER2
#include "parser.tab.hpp"
#include "v2/def.hpp"
#else
#include "pparser.tab.hpp"
#include "defv1.hpp"
#endif

//#include "cpp.tab.hpp"


using std::list;
using std::map;
using std::fstream;
using std::pair;
using std::string;
using std::stringstream;
using std::vector;
using std::stack;
using yy::parser;

/**
 * ============================================================================
 * File: <singleton>.cpp
 *
 * --- NOTE:
 * "We use the Heap (via unique_ptr) when the Singleton is very large, when we
 * want to use polymorphism (deciding the implementation at runtime) or when we
 * need total control over dynamic memory. We use Meyers' Singleton for
 * lightweight and simple Singletons due to its elegance and native thread
 * safety."
 *
 * --- CONFIGURATION:
 * Toggle the definition below to switch between implementations.
 * Only ONE implementation of getInstance() will be compiled at a time,
 * preserving the "Single Instance" rule of the pattern.
 * ============================================================================
 */

// Comment or uncomment this line to switch between Meyers' and Heap version
//#define USE_HEAP_SINGLETON

/**
 * @brief class lexer (singleton)
 */
class lexer final
{
public:
	/**
     *  singleton Access Point
     *  logic changes based on the #define at the top of the file.
     */
	static lexer& instance()
	{
#ifdef USE_HEAP_SINGLETON
		// APPROACH: Heap-based singleton (Dynamic Memory)
		// Managed by std::unique_ptr for automatic cleanup.
		// We use 'new' because make_unique cannot access a private constructor.
		static std::unique_ptr<lexer> instance(new lexer());
		std::cout << "[Info] Using Heap-based implementation (unique_ptr).\n";
		return *instance;
#else
		// APPROACH: Meyers' singleton (Static/Data Segment)
		// Simplest, thread-safe (C++11+), and stack-efficient.
		static lexer instance;
		return instance;
#endif
	}


private:
	// Private constructor prevents direct instantiation.
	lexer()
	{
		std::cout << "[Info] Using Meyers' implementation (Static Segment).\n";
		std::cout << "[System] lexer instance created at address: " << this << "\n";
	}

public:
	// rule of three/five: delete copy constructor and assignment operator.
	lexer(const lexer&) = delete;
	lexer& operator=(const lexer&) = delete;

	virtual ~lexer()
	{
		std::cout << "[System] lexer instance destroyed.\n";
	}

	// singleton public interface
public:
	/**
	 * @name   load_config
	 * @param  const string& file
	 * @return void
	 */
	void load_config( const string& file );

	/**
	* @name  init
	* @brief initialize input
	* @param const string& file
	* @return bool
	*/
	bool init(const string& file);

	/**
	 * @name   set_state
	 * @brief  void set_state(state_t* pstate)
	 * @return void
	 */
	void set_state(state_t *pstate);

	/**
	 * @name build_search_expression
	 * @brief contruct a search string from tokens, denoted by id's / table
	 * @param string& s
	 * @return string&, contructed search string
	 */
	string& build_search_expression(/*out*/ string& s);

	/**
	 * @name get_current_infile
	 * @param in_name
	 * @param string& in_name
	 * @return void
	 */
	inline void get_current_infile( string& in_name ) const
	{
		in_name = m_ifile;
	}

	/**
	 * @name get_current_outfile
	 * @param name
	 * @param string& out_name
	 * @return void
	 */
	inline void get_current_outfile( /*out*/ string& name ) const
	{
		name = m_ofile;
	}

	/**
	 * @name   get_token
	 * @return int
	 */
	parser::symbol_type get_token();

	// /**
	//  * @name read_istream
	//  * @return int
	//  */
	// static void read_istream( const string& file, string& s );

	// /**
	//  * @name read_istream
	//  * @brief read input file into string object
	//  */
	// static bool read_istream( const string& file, /*out*/ char* buff, int& len);

	/**
	 * @name   write_stream
	 * @return int
	 */
	inline void write_ostream( const string &s )
	{
		m_fstream << s;
	}

	inline fstream& out_strm()
	{
		return m_fstream;
	}

	/**
	 * @name  print_smatch
	 * @brief print token to stdout
	 * @param token_match m
	 */
	void print_smatch(const token_t& t, boost::smatch m);

	/**
	 * @brief print_token
	 * 
	 */
	void print_token(const token* ptoken);

	/**
	* @brief print_tokens
	*
	*/
	void print_tokens();


	/**
	 * @name  on_token
	 * @brief override virtual, on_token, for each token ...
	 * @param id
	 * @param match
	 * @param unsigned long id
	 * @param string match: current match
	 * @return parser::symbol_type
	 */
	parser::symbol_type on_token( unsigned long id, const string& match = {} );


	

	/**
	 * @brief stream operator
	 *
	 * @param os
	 * @param lex
	 * @return std::ostream&
	 */
    friend std::ostream& operator<<(std::ostream& os, const lexer& lex);

private:

	//configuration types
	vector<token_t> m_tokens;
	map<unsigned long, token> m_tok_map;
	vector<state_t> m_states;

	bool initalized = false;

	vector<string> m_input_paths{};
	string m_ifile{};
	string m_ofile = "build/a.out";

	string m_regex_str{};
	stringstream strm_buf;
	string m_buffer{};
	string m_match{};
	fstream m_fstream{};
	//fstream ostrm;
	int m_line = 0;
//	int m_current_file_idx = 0;
	state_t* m_pstate = &INITIAL;
	stringstream g_stringstream{};
};

#endif
