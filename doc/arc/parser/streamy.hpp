// File Name:  streamy.hpp
// Build Date: Thu Dec 21 09:06:55 AM CST 2023
// Version:    0.0.2

#ifndef _streamy_HPP
#define _streamy_HPP

#include <string>
#include <sstream>
#include <vector>
#include <map>
#include <regex>
#include "fileio.hpp"
//#include "compiler.hpp"

using std::stringstream;
using std::string;
using std::map;
using std::vector;
using std::pair;

 // escapes
const int TEXT = 0x1;
const int TAG = 0x2;
const int TOKEN = 0x4;

class streamy
{
public:
    streamy();
    streamy(const string& template_dir, const string& complie_dir, const string& config_dir, const string& cache_dir);
    void load_config(const string& path);
    void display(const string& file);
    void assign(const string& name, const string& val);
    void assign(const string& name, const vector<string>& vec);
    string& fetch(const string& tmpl, const string& cache_id, const string& compile_id, /*out*/ string& html);
    map<string, string>& get_map_vars();
    map<string, string>& get_map_config();
    map<string, map<string, string>>& get_map_config_sections();
    map<string, vector<string>>& get_map_arrays();
    void clear_all();
    void clear_config();
    void clear_config(string name);
    void clear_assign();
    void clear_assign(string name);
    void clear_cache();
    unsigned int get_state();

private:
    void lex(const string& src, /* out*/ vector<pair<int, string>>& escapes);
    void parse(vector<pair<int, string>>& tokens, /* out */ stringstream& ss);
    void include_file(const string& file_name, /* out */ stringstream& ss);

    // types
    //typedef vector<pair<int, string>> token_vector;

    // map
    map<string, string> map_config;
    // todo : revert to no configuration sections!
    map<string, map<string, string>> map_sections_config;
    map<string, string> map_vars;
    map<string, string> map_const;
    map<string, vector<string>> map_arrays;
    map<string, pair<string, vector<string>>> map_objects;
    map<int, string> token_map;

    // config
    string template_dir;
    string compile_dir;
    string config_dir;
    string cache_dir;
    bool caching = false;
    bool config_overwrite = false;
    bool autoload_filters = false;

    string version = "0.0.1";
    string templ;
    string ldelm;
    string rdelm;
    // state
    unsigned int state;
};

#endif
