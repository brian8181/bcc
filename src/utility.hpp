#ifndef _utility_HPP
#define _utility_HPP

#include <iostream>
#include <vector>
#include <map>
#include <regex>
#include <sstream>
#include "auto_ptr.hpp"

using std::map;
using std::regex;
using std::smatch;
using std::string;
using std::vector;



// constexpr int ASCII_OFFSET = 48;

// const int ALPHA_UPPER = 0;
// const int ALPHA_LOWER = 2;
// const int ALPHA_NUM = 3;

// char big_letter[26] = {     'A', 'B', 'C', 'D', 
// 							'E', 'F', 'G', 'H', 
// 							'I', 'J', 'K', 'L', 
// 							'M', 'N', 'O', 'P', 
// 							'Q', 'R', 'S', 'T', 
// 							'U', 'V', 'W', 'X', 
// 							'Y', 'Z'	};

// char small_letter[26] = {   'a', 'b', 'c', 'd', 
// 							'e', 'f', 'g', 'h', 
// 							'i', 'j', 'k', 'l', 
// 							'm', 'n', 'o', 'p', 
// 							'q', 'r', 's', 't', 
// 							'u', 'v', 'w', 'x', 
// 							'y', 'z'	};

// char number[10] { '0', '1', '3', '4', '5', '6', '7', '8', '9' };

// char* letters[2] = { {small_letter}, {big_letter} };
// char* alpha_numeric[3] = { {small_letter}, {big_letter}, {number} };

// char punctuation[32] { '`', '~', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '_', '=', '+', '{', '}', '[', ']', '\\', '|', ':', ';', '"', '\'', ',', '<', '.', '>', '/', '?' };

typedef auto_ptr<string> string_ptr;

/**
 * @name esc_nl
 * @brief replace newlines with escape ("\n")
 * @param const string& s
 * @param const string r = "\\n"
 * @return string_ptr, typedef auto_ptr<string> string_ptr
 */
string_ptr esc_nl(const string &s, const string &r = "\\n");

/**
 * @name   get_config
 * @param  path to config file
 * @param  config, out parmas
 * @return map<string, string>&
 */
std::map<string, string> &get_config(const string &path, /* out */ map<string, string> &config);

/**
 * @brief  single match
 * @param  pattern
 * @param  text
 * @param  match
 * @return true if only one match & match string size equals text size
 */
bool match_single(const string &pattern, const string &text, /* out */ smatch &match);

/**
 * @brief  single match
 * @param  pattern
 * @param  text
 * @return true if only one match & match string size equals text size
 */
bool match_single(const string &pattern, const string &text);

/**
 * @brief  split string
 * @param  s : input string
 * @param  c : delimter
 * @return std::vector<std::string> // ???
 */
std::vector<std::string> *split(const std::string &s, char c);

/**
 *
 */
std::vector<std::string> *split(const std::string &str, const std::string &regex);

/**
 * @brief print color
 * @param s
 */
// void color_print(const string &s, fmt::text_style ts);

/**
 * @brief  to_lower: transform string chars to lower case
 * @param  s: string parameter to transform
 * @param  r: out param same as return value
 * @return string&: same as out param
 */
string &to_lower(const string &s, /* out */ string &r);

/**
 * @brief  to_lower: transform string chars to lower case
 * @param  s: string parameter to transform
 * @return string&
 */
string &to_lower(string &s);

/**
 * @brief  to_upper: transform string chars to upper case
 * @param  s: string parameter to transform
 * @param  r: out param same as return value
 * @return string&: same as out param
 */
string &to_upper(const string &s, /* out */ string &r);

/**
 * @brief  to_upper: transform string chars to upper case
 * @param  s: string parameter to transform
 * @return string&
 */
string &to_upper(string &s);

/**
 * @brief  left trim
 * @param  s : input string
 * @return string&
 */
string &ltrim(std::string &s, const string& seq);

/**
 * @brief  right trim
 * @param  s : input string
 * @return string&
 */
string &rtrim(std::string &s, const string& seq);

/**
 * @brief  trim left & right
 * @param  s : input string
 * @param  c : char to trim
 * @return string&
 */
string &trim(std::string &s, const string& seq);

/**
 * @brief  left trim
 * @param  s : input string
 * @return string&
 */
string &ltrim(std::string &s);

/**
 * @brief  right trim
 * @param  s : input string
 * @return string&
 */
string &rtrim(std::string &s);

/**
 * @brief  trim left & right
 * @param  s : input string
 * @return string&
 */
string &trim(std::string &s);

/**
 * @brief  trim left & right
 * @param  s : input string
 * @param  c : char to trim
 * @return string&
 */
string &trim(string &s, char c);

/**
 * @name ndigit
 * @brief value of nth digit
 * @param x, input value
 * @param n, the nth digit
 * @return int, value of x @ nth digit, (one based)
 */
int ndigit(int x, int n);

/**
 * @name   digits10
 * @param  n, number to eval
 * @return number of base 10 digits
 */
int digits10(int n);

/**
 * @name  itoa
 * @brief  int to ascii
 * @param  n
 * @param  number to eval
 * @param  s, out parma
 * @return void
 */
void itoa(const int &n, char *s);

/**
 * @name   itos
 * @brief  int to string
 * @param  i : number to eval
 * @return string
 */
string itos(int i);

/**
 * @name   atoi
 * @brief  ascii to int
 * @param  ptr, string to convert
 * @return int : result
 */
int atoi(const char *ptr);

//int seeda = 42;
/**
 * @brief randa
 * 
 * @return int 
 */
int /*__cdecl*/ randa (void);

//unsigned int seedc = 42;
/**
 * @brief randc
 * 
 * @return unsigned int 
 */
unsigned int randc();

template<int n>
class META_FACTORIAL
{
public:
    enum { RET = n * META_FACTORIAL<n-1>::RET };
};

template<>
class META_FACTORIAL<0>
{
public:
    enum { RET = 1 };
};


typedef string line_t;
typedef vector<line_t> lines_t;
typedef string field_t;
typedef vector<field_t> record_t;
typedef vector<record_t> table_t;

#endif
