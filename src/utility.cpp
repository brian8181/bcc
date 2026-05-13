/** @name:  ./utility.cpp
 * @date: Thu Dec 21 09:06:55 AM CST 2023
 * @version    0.0.2
 */

#include <iostream>
#include <sstream>
#include <fstream>
#include <map>
#include <regex>
#include <vector>
#include <string.h>
#include <fmt/color.h>
#include <fmt/compile.h>
#include <fmt/format.h>
#include "math.h"
#include "utility.hpp"
#include "auto_ptr.hpp"

using std::ifstream;
using std::ios;
using std::map;
using std::ostringstream;
using std::pair;
using std::regex;
using std::smatch;
using std::string;
using std::stringstream;
using std::vector;

constexpr int ASCII_OFFSET = 48;

/**
 * @name esc_nl
 * @brief replace newlines with c (".")
 * @param const string& s
 * @param const string r = "\\n"
 * @return string_ptr, typedef auto_ptr<string> string_ptr
 */
string_ptr esc_nl(const string &s, const string &r)
{
    size_t index = string::npos;
    string suffix = s;
	string ret;
    // replace newlines with escapes
    while ((index = suffix.find('\n')) != string::npos)
    {
		string prefix = suffix.substr( 0, index);      // get prefix
		ret.append(prefix);                            // append prefix
        ret.append(r);                                 // replace '\n' with r
        // move suffix
        suffix = suffix.substr(index+1);               // get suffix
    }
    ret.append(suffix);
	return auto_ptr<string>(ret);
}

/**
 * @brief print color
 * @param s
 */
void color_print(const fmt::v11::text_style &ts, fmt::v11::format_string<double> fmt, double &&args)
{
    /**
     * Formats a string and prints it to stdout using ANSI escape sequences to
     * specify text formatting.
     *
     * **Example**:
     *
     *     fmt::print(fmt::emphasis::bold | fg(fmt::color::red),
     *                "Elapsed time: {0:.2f} seconds", 1.23);
     */
    fmt::print(ts, fmt, args);
}

/**
 * @name color_fmt
 * @param s
 * @param ts
 * @return string
 */
string *color_fmt(fmt::v11::format_string<int> fmt, int &&args)
{
    /**
     * Formats `args` according to specifications in `fmt` and returns the result
     * as a string.
     *
     * **Example**:
     *
     *     #include <fmt/format.h>
     *     std::string message = fmt::format("The answer is {}.", 42);
     */
    std::string message = fmt::format(fmt, args);
    return 0;
}

string to_string(long n)
{
    return fmt::to_string(n);
}

/**
 * @name   get_config
 * @param  path to config file
 * @param  config, out parmas
 * @return map<string, string>&
 */
map<string, string> &get_config(const string &path, /* out */ map<string, string> &config)
{
    ifstream file;
    file.open(path, ios::out); // open a file
    pair<string, string> config_pair;

    if (file.is_open())
    {
        string line;
        while (getline(file, line))
        {
            const size_t pos = line.find('=');
            string name = line.substr(0, pos - 1);
            name = trim(name);
            string value = line.substr(pos + 1);
            value = trim(value);
            pair p(name, value);
            config.insert(p);
        }
        file.close(); // close the file
    }
    return config;
}

/**
 * @brief  single match
 * @param  pattern
 * @param  text
 * @param  match
 * @return true if only one match & match string size equals text size
 */
bool match_single(const string &pattern, const string &text, /* out */ smatch &match)
{
    const auto rgx = regex(pattern);
    regex_match(text, match, rgx);
    if (match.size() == 1 && match.str().size() == text.size())
        return true;

    return false;
}

/**
 * @brief  single match
 * @param  pattern
 * @param  text
 * @return true if only one match & match string size equals text size
 */
bool match_single(const string &pattern, const string &text)
{
    const auto rgx = regex(pattern);
    smatch match;
    regex_match(text, match, rgx);

    if (match.size() == 1 && text.size())
        return true;
    return false;
}

/**
 * @brief  split string
 * @param  s : input string
 * @param  c : delimter
 * @return std::vector<std::string> // ???
 */
std::vector<std::string> *split(const std::string &s, const char c)
{
    std::vector<std::string> *presult = new std::vector<std::string>();
    size_t begin = 0;
    while (true)
    {
        const size_t end = s.find_first_of(c, begin);
        presult->push_back(s.substr(begin, end - begin));
        if (end == std::string::npos)
        {
            break;
        }
        begin = end + 1;
    }
    return presult;
}

/**
 * @brief  split string
 * @param  str: std::string
 * @param  regex : std::string
 * @return std::vector<std::string>
 * */
std::vector<std::string> *split(const std::string &str, const std::string &regex)
{
    const std::regex r{regex};
    std::sregex_token_iterator start{str.begin(), str.end(), r, -1};
    const std::sregex_token_iterator end;

    std::vector<std::string> *pv = new std::vector<std::string>(start, end);
    return pv;
}

/**
 * @name ndigit
 * @brief value of nth digit
 * @param x, input value
 * @param n, the nth digit
 * @return int, value of x @ nth digit, (one based)
 */
int ndigit(int x, int n)
{
    int p = pow(10, n);
    int r = (x % p) / std::pow(10, n - 1);
    return r;
}

/**
 * @name   digits10
 * @param  n, number to eval
 * @return number of base 10 digits
 */
int digits10(int n)
{
    return std::floor(std::log10(n) + 1);
}

/**
 * @name   itoa
 * @brief  int to ascii
 * @param  n, to eval
 * @param  s, out parma
 * @return void
 */
void itoa(const int &n, char *s)
{
    const int len = digits10(n);
    for (int i = 0; i < len; ++i)
    {
        int c = n / pow(10, i);
        c = std::floor(c);
        c = c % 10;
        s[len - 1 - i] = static_cast<char>(c + ASCII_OFFSET); // 0x30
    }
    s[len] = '\0';
}

/**
 * @name   itos
 * @brief  int to string
 * @param  i : number to eval
 * @return string
 */
string itos(const int i) // convert int to string
{
    std::stringstream s;
    s << i;
    return s.str();
}

/**
 * @name   atoi
 * @brief  ascii to int
 * @param  ptr
 * @return int : result
 */
int atoi(const char *ptr)
{
    int num = 0;
    const int len = strlen(ptr);
    for (int i = 0; i < len; ++i)
    {
		const int c = (int)ptr[i];
        const int digit = (c - ASCII_OFFSET);
        if (digit < 0 || digit > 9)
            return -1; // not an ascii 0-9
        num += digit * pow(10, len-(i+1));
    }
    return num;
}

/**
 * @brief  to_lower: transform string chars to lower case
 * @param  s: string parameter to transform
 * @param  r: out param same as return value
 * @return string&: same as out param
 */
string &to_lower(const string &s, /* out */ string &r)
{
    const int len = s.length();
    r.clear();
    for (int i = 0; i < len; ++i)
    {
        const int c = std::tolower(s[i]);
        r.push_back(c);
    }
    return r;
}

/**
 * @brief  to_lower: transform string chars to lower case
 * @param  s: string parameter to transform
 * @return string&
 */
string &to_lower(string &s) // in place
{
    const int len = s.length();
    for (int i = 0; i < len; ++i)
    {
        const int c = std::tolower(s[i]);
        s[i] = c;
    }
    return s;
}

/**
 * @brief  to_upper: transform string chars to upper case
 * @param  s: string parameter to transform
 * @param  r: out param same as return value
 * @return string&: same as out param
 */
string &to_upper(const string &s, /* out */ string &r)
{
    const int len = s.length();
    r.clear();
    for (int i = 0; i < len; ++i)
    {
        const int c = std::toupper(s[i]);
        r.push_back(c);
    }
    return r;
}

/**
 * @brief  to_upper: transform string chars to upper case
 * @param  s: string parameter to transform
 * @return string&
 */
string &to_upper(string &s) // in place
{
    const int len = s.length();
    for (int i = 0; i < len; ++i)
    {
        int c = std::toupper(s[i]);
        s[i] = c;
    }
    return s;
}


/**
 * @brief  left trim
 * @param  s : input string
 * @return string&
 */
// string &ltrim(std::string &s, const string& seq)
// {
// 	return s;
// }

/**
 * @brief  right trim
 * @param  s : input string
 * @return string&
 */
// string &rtrim(std::string &s, const string& seq)
// {
// 	return s;
// }

/**
 * @brief  trim left & right
 * @param  s : input string
 * @param  c : char to trim
 * @return string&
 */
// string &trim(std::string &s, const string& seq)
// {
// 	int len = s.size();
// 	if(s[len-2] == '\n' && s[len-1] == '\n')
// 		s.erase(len-1, 1);
// 	return s;
// }


/**
 * @brief  left trim
 * @param  s : input string
 * @return string&
 */
string &ltrim(std::string &s)
{
    const int len = s.size();
    int i;
    for (i = 0; i < len; ++i)
    {
        if (!std::isspace(s[i]))
            break;
    }
    const auto beg = s.begin();
    s.erase(beg, beg + i);
    return s;
}

/**
 * @brief  right trim
 * @param  s : input string
 * @return string&
 */
string &rtrim(std::string &s)
{
    const int len = s.size();
    int i = len;
    for (; i > 0; --i)
    {
        if (!std::isspace(s[i - 1]))
            break;
    }
    const auto end = s.end();
    s.erase(end - (len - i), end);
    return s;
}

/**
 * @brief  trim left & right
 * @param  s : input string
 * @return string&
 */
string &trim(std::string &s)
{
    rtrim(s);
    ltrim(s);
    return s;
}

/**
 * @brief  trim left & right
 * @param  s : input string
 * @param  c : char to trim
 * @return string&
 */
string &trim(string &s, char c)
{
	while (s[s.size()-1] == c)
        s.pop_back();
    return s;
}

/**
 * @name   read_bits
 * @param  const smatch& m
 * @return int
 */
int read_bits(const smatch &m)
{
    int len = m.size();
    unsigned int bits = 0;
    for (int i = 0; i < len && i < 32; ++i)
    {
        bits |= static_cast<int>(m[i].matched) << i;
    }
    return bits;
}
