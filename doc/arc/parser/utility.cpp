// File Name:  ./utility.cpp
// Build Date: Thu Dec 21 09:06:55 AM CST 2023
// Version:    0.0.2

#include <sstream>
#include <fstream>
#include <map>
#include <string>
#include <vector>
#include <regex>
#include "utility.hpp"

using std::regex;
using std::string;
using std::map;
using std::vector;
using std::ostringstream;
using std::ifstream;

// returns true if only one match & match string size equals text size
bool match_single(const string& pattern, const string& text, /* out */ smatch& match)
{
    regex rgx = regex(pattern);
    regex_match(text, match, rgx);

    if(match.size() == 1 && match.str().size() == text.size())
        return true;

    return false;
}

// returns true if only one match & match string size equals text size
bool match_single(const string& pattern, const string& text)
{
    regex rgx = regex(pattern);
    smatch match;
    regex_match(text, match, rgx);

    if(match.size() == 1 && text.size(), match.str().size())
        return true;

    return false;
}

int read_bits(const smatch& m)
{
    int len = m.size();
    unsigned int bits = 0;
    for(int i = 0; i < len && i < 32; ++i)
    {
        bits |= (int(m[i].matched) << i);
    }
    return bits;
}

bool file_exist(const string& path)
{
    std::fstream strm(path);
    strm.open(path, std::ios::in);
    bool ret = strm.is_open();
    strm.close();
    return ret;
}

/* retrive name value pairs from file */
map<string, string>& get_name_value_pairs(string path, /* out */ map<string, string>& pairs)
{
    std::ifstream file;
    file.open(path, std::ios::in); //open a file

    if (file.is_open())
    {
        string line;
        while(getline(file, line))
        {
            size_t pos = line.find('=');
            string name = line.substr(0, pos-1);
            name = trim(name);
            string value = line.substr(pos+1);
            value = trim(value);
            std::pair<string, string> p(name, value);
            pairs.insert(p);
        }
        file.close(); //close the file
    }
    return pairs;
}

string& trim(string &s, char c)
{
    if(s.at(s.length()-1) == c)
        s.pop_back();

    return s;
}

string& ltrim(std::string &s)
{
    int len = s.size();
    int i;
    for(i = 0; i < len; ++i)
    {
        if(!std::isspace(s[i]))
            break;
    }
    string::iterator beg = s.begin();
    s.erase(beg, beg+i);
    return s;
}

string& rtrim(std::string &s)
{
    int len = s.size();
    int i = len;
    for(;i > 0; --i)
    {
        if(!std::isspace(s[i-1]))
            break;
    }
    string::iterator end = s.end();
    s.erase(end-(len-i), end);
    return s;
}

string& trim(std::string &s)
{
    rtrim(s);
    ltrim(s);
    return s;
}
