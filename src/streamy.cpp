// File Name:  streamy.cpp
// Build Date: Thu Dec 21 09:06:55 AM CST 2023
// Version:    0.0.2

#include <iostream>
#include <sstream>
#include <map>
#include <filesystem>
#include <regex>
#include "streamy.hpp"
#include "constants.hpp"
#include "bash_color.hpp"
#include "fileio.hpp"

using namespace std;

streamy::streamy()
{
    this->template_dir = "../streamy/templates";
    this->compile_dir = "../streamy/compile";
    this->config_dir = "../streamy/config";
    this->cache_dir = "../streamy/cache";
}

streamy::streamy(const string& template_dir, const string& compile_dir, const string& config_dir, const string& cache_dir)
{
    this->template_dir = template_dir;
    this->compile_dir = compile_dir;
    this->config_dir = config_dir;
    this->cache_dir = cache_dir;
}

void streamy::load_config(const string& path)
{
    const unsigned int ID_NAME_VALUE_PAIR = 0;
    const unsigned int ID_NAME            = 1;
    const unsigned int ID_VALUE           = 2;
    const unsigned int ID_NUMERIC_LITERAL = 2;
    const unsigned int ID_STRING_LITERAL  = 3;

    // get configuration file by lines
    vector<string> lines;
    read_lines(path, lines);
    // create one only section (global)
    string section_name = "global";
    map<string, string> section_map;
    pair<string, map<string, string>> sp(section_name, section_map);
    map_sections_config.insert(sp);

    int len = lines.size();
    for(int i = 0; i < len; ++i)
    {
        string line = lines[i];
        regex rgx = regex(CONFIG_PAIR);
        smatch match;
        regex_match(line, match, rgx);

        if(match[ID_NAME_VALUE_PAIR].matched)
        {
            // get name
            string symbol_name = match[ID_NAME].str();

            // get value
            string value = (match[ID_VALUE].matched) ?
                match[ID_NUMERIC_LITERAL].str() : match[ID_STRING_LITERAL].str();

            // create pair
            pair<string, string> p(symbol_name, value);
            map_sections_config[section_name].insert(p);
        }
    }
}

void streamy::display(const string& tmpl)
{
    string html;
    cout << "x=" << map_vars["x"] << ". y=" << map_vars["y"] << endl; 
}

string& streamy::fetch(const string& tmpl, const string& cache_id, const string& compile_id, /*out*/ string& html)
{
    return html;
}

void streamy::assign(const string& symbol_name, const string& val)
{
    pair<string, string> p(symbol_name, val);
    map_vars.insert(p);
}

void streamy::assign(const string& symbol_name, const vector<string>& vec)
{
    pair<string, vector<string>> p(symbol_name, vec);
    map_arrays.insert(p);
}

void streamy::lex(const string& src, /* out*/ vector<pair<int, string>>& escapes)
{
    string s = src;
}

void streamy::parse(vector<pair<int, string>>& tokens, /* out */ stringstream& ss)
{
    //int ilen = tokens.size();
    //string symbol_name;
}

void streamy::include_file(const string& file_name, /* out */ stringstream& ss)
{
    const string full_path = this->template_dir + "/" + file_name;
    string file_src;
    read_str(file_name, file_src);
    ss << file_src;
}

void streamy::clear_cache()
{
    // delete cache
    filesystem::path p = cache_dir;
}

map<string, map<string, string>>& streamy::get_map_config_sections()
{
    return map_sections_config;
}

map<string, string>& streamy::get_map_config()
{
    return map_config;
}

std::map<string, string>& streamy::get_map_vars()
{
    return map_vars;
}

map<string, vector<string>>& streamy::get_map_arrays()
{
    return map_arrays;
}

void streamy::clear_config()
{
    map_config.clear();
}

void streamy::clear_config(string symbol_name)
{
    map_config.erase(symbol_name);
}

void streamy::clear_assign()
{
    map_vars.clear();
}

void streamy::clear_assign(string symbol_name)
{
    map_vars.erase(symbol_name);
}

void streamy::clear_all()
{
    map_config.clear();
    map_vars.clear();
    map_arrays.clear();
}

unsigned int streamy::get_state()
{
    return state;
}
