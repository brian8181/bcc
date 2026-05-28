// File Name:  fileio.cpp
// Build Date: Sat Nov 25 06:03:48 AM CST 2023
// Version:    3.6.7

#ifndef _FILEIO_HPP
#define _FILEIO_HPP

#include <string>
#include <map>
#include <vector>

using namespace std;

vector<string>& get_lines(const string& path, vector<string>& lines);
//string& read_stream(const string& path);
string& read_stream(const string& path, /* out */string& out);
map<string, string> get_config(string path);

// string& ltrim(string& s);
// string& rtrim(string& s);
// string& trim(string& s);

#endif
