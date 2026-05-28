// File Name:  fileio.cpp
// Build Date: Sat Nov 25 06:03:48 AM CST 2023
// Version:    3.6.7

#include <iostream>
#include <fstream>
#include <algorithm>
#include "fileio.hpp"
#include "utility.hpp"

// get file lines as vector
vector<string>& get_lines(const string& path, vector<string>& lines)
{
    ifstream file;
    file.open(path, ios::in);
    if (file.is_open())
    {
        string line;
        while (getline(file, line))
        {
            lines.push_back(line);
        }
        file.close();
    }
    return lines;
}

// read all, (default read function)
// string& read_stream(const string& path)
// {
//     std::ifstream ifstrm(path);
//     std::string output((std::istreambuf_iterator<char>(ifstrm)), std::istreambuf_iterator<char>());
//     return output;
// }

std::string& read_stream(const std::string& path, /* out */std::string& out)
{
    std::ifstream ifstrm(path);
    std::string output((std::istreambuf_iterator<char>(ifstrm)), std::istreambuf_iterator<char>());
    out = output;
    return out;
}

map<string, string> get_config(string path)
{
    ifstream file;
    file.open(path, ios::in); //open a file

    map<string, string> config;
    pair<string, string> config_pair;

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
            pair<string, string> p(name, value);
            config.insert(p);
        }
        file.close(); //close the file
    }
    return config;
}

// string& ltrim(std::string &s)
// {
//     int len = s.size();
//     int i;
//     for(i = 0; i < len; ++i)
//     {
//         if(!std::isspace(s[i]))
//             break;
//     }
//     string::iterator beg = s.begin();
//     s.erase(beg, beg+i);
//     return s;
// }

// string& rtrim(std::string &s)
// {
//     int len = s.size();
//     int i = len;
//     for(;i > 0; --i)
//     {
//         if(!std::isspace(s[i-1]))
//             break;
//     }
//     string::iterator end = s.end();
//     s.erase(end-(len-i), end);
//     return s;
// }

// string& trim(std::string &s)
// {
//     rtrim(s);
//     ltrim(s);
//     return s;
// }
