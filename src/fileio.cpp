/**
 * @file     fileio.cpp
 * @date:    Tue, Oct 28, 2025  1:47:46 PM
 * @version: 0.0.1
 */

#include <cstdio>
#include <iostream>
#include <fstream>
#include <algorithm>
#include <sstream>
#include <string>
#include "fileio.hpp"

using std::ifstream;
using std::ios;
using std::ofstream;
using std::pair;
using std::stringstream;

/**
 *
 */
long file_size(const string &path)
{
    try
    {
        std::uintmax_t size = fs::file_size(path);
        return size;
    }
    catch (const fs::filesystem_error &e)
    {
        std::cerr << "Error: " << e.what() << '\n';
        return -1;
    }
    return -1;
}

/**
 * @brief  check if file exist
 * @param  const string& : path to file
 * @return bool: ture file exsit otherwise false
 */
bool file_exist(const string &path)
{
    std::fstream strm(path);
    strm.open(path.c_str(), std::ios::in);
    bool ret = strm.is_open();
    strm.close();
    return ret;
}

/**
 * @brief get an ofstream by path
 * @param path
 * @param strm
 * @return ofstream&
 */
void get_ofstream(const string &file, /*out */ ofstream *&strm)
{
    strm = new ofstream(file, std::ofstream::out);
}

/**
 * @brief get an ifstream by path
 * @param path
 * @param srtm
 * @return ifstream&
 */
void get_ifstream(const string &file, /*out */ ifstream *&strm)
{
    strm = new ifstream(file, std::ifstream::in);
}

/**
 *
 * @param sbuf *
 * @return char
 */
char getc(std::streambuf &sbuf)
{
    return static_cast<char>(sbuf.sgetc());
}

/**
 * @brief  read a character from a file stream
 * @param  ifstream& strm : The file stream to read from
 * @param  char& c : the character to read
 * @return ifstream&
 */
ifstream &read_char(ifstream &strm, /* out */ char &c)
{
    if (strm.is_open())
    {
        strm.get(c);
        if (strm.good())
            return strm;
    }
    exit(-1);
}

/**
 * @brief  write a character to a file stream
 * @param  ofstream& strm file stream to write
 * @param  const char& c : character to write
 * @return ofstream&
 */
ofstream &write_char(ofstream &strm, /* in */ const char &c)
{
    if (strm.is_open())
    {
        strm.put(c);
        if (strm.good())
            return strm;
    }
    exit(-1);
}

/**
 * @brief  read a file into a buffer
 * @param  const string& file : file to read from
 * @param  unsigned char* buf : buffer to store the file contents
 * @param  const int& len : length of the buffer
 * @return int : number bytes read, or -1 on error
 */
int read_buf(const string &file, /* out */ unsigned char *buf, const int &len)
{
    ifstream stream(file, std::ifstream::in);
    if (stream.is_open())
    {
        stream.read((char *)buf, len);
        stream.close();
        return stream.good() ? stream.gcount() : -1;
    }
    return -1;
}

/**
 * @brief  write a buffer to a file
 * @param  const string& file : file to write to
 * @param  const unsigned char* buf : buffer to write
 * @param  const int& len : length of the buffer
 * @return int : number of bytes written, or -1 on error
 */
int write_buf(const string &file, /* in */ const char *buf, const int &len)
{
    std::ofstream stream(file, std::ofstream::out | std::ofstream::binary | std::ofstream::trunc);
    if (stream.is_open())
    {
        stream.write((char *)buf, len);
        stream.close();
        return stream.good() ? len : -1;
    }
    return -1;
}

/**
 * @brief  read a file into a string
 * @param  const string& file : file to read from
 * @param  string& out : string to store the file contents
 * @return int : number of characters read, or -1 on error
 */
int read_str(const string &file, /* out */ string &out, std::ios_base::openmode mode)
{
    ifstream stream(file, mode);
    if (stream.is_open())
    {
        stringstream ss;
        char c;
        while (stream.get(c))
        {
            ss << c;
        }
        out = ss.str();
		stream.close();
        return static_cast<int>(ss.str().size());
    }
    return -1;
}

/**
 * @brief  write a string to a file
 * @param  const string& file : The file to write to
 * @param  const string& in : string to write
 * @return int : number of characters written, or -1 on error
 */
int write_str(const string &file, /* in */ const string &in, std::ios_base::openmode mode)
{
    ofstream stream;
    stream.open(file, std::ios_base::out | std::ios::out);
    if (stream.is_open())
    {
        stringstream ss;
        ss << in;
        stream << ss.str();
        stream.close();
        return static_cast<int>(ss.str().size());
    }
    return -1;
}

/**
 * @brief  read a file into a stringstream
 * @param  const string& file : file to read from
 * @param  stringstream& ostrm : stringstream to store the file contents
 * @return int : number of characters read, or -1 on error
 */
int read_sstream(const string &file, /* out */ stringstream &ostrm, std::ios_base::openmode mode)
{
    ifstream stream(file, mode);
    if (stream.is_open())
    {
        char c;
        while (stream.get(c))
        {
            ostrm << c;
        }
        stream.close();
        return ostrm.str().size();
    }
    return -1;
}

/**
 * @brief  write a stringstream to a file
 * @param  const string& file : file to write to
 * @param  const stringstream& istrm : stringstream to write
 * @return int : number of characters written, or -1 on error
 */
int write_sstream(const string &file, /* in */ const stringstream &istrm, std::ios_base::openmode mode)
{
    ofstream stream(file, mode);
    if (stream.is_open())
    {
        stream << istrm.str();
        stream.close();
        return istrm.str().size();
    }
    return -1;
}

/**
 * @brief
 * @param  file : file to read from
 * @param  lines : vector to store the lines
 * @return number of lines written, or -1 on errors
 */
ifstream *read_line(ifstream *istrm, /* out */ string &line)
{
    // if (!istrm->is_open())
    //     return -1;
    // return istrm->getline(line, 1024);
    return 0;
}

/**
 * @brief
 * @param  const string& file : file to write to
 * @param  const vector<string>& lines : lines to write
 * @return int : number of lines written, or -1 on error
 */
int write_line(ofstream *ostrm, /* in */ string &line)
{
    if (!ostrm->is_open())
        return -1;
    *ostrm << line;
    return line.size();
}

/**
 * @brief  read lines from a file into a vector of strings
 * @param  const string& file : file to read from
 * @param  vector<string>& lines : vector to store the lines
 * @return int : number of lines written, or -1 on error
 */
int read_lines(const string &file, /* out */ vector<string> &lines)
{
    ifstream stream(file, ios::in);
    if (!stream.is_open())
        return -1;
    string line;
    while (getline(stream, line))
    {
        lines.push_back(line);
    }
    stream.close();
    return lines.size();
}

/**
 * @brief  write lines to a file
 * @param  const string& file : file to write to
 * @param  const vector<string>& lines : lines to write
 * @return int : number of lines written, or -1 on error
 */
int write_lines(const string &file, /* in */ const vector<string> &lines)
{
    std::ofstream os(file, std::ofstream::out | std::ofstream::trunc);
    if (os.is_open())
    {
        string line;
        int len = lines.size();
        for (int i = 0; i < len; ++i)
        {
            line = lines[i];
            line.append("\n"); // append new line
            os.write(line.c_str(), line.size());
        }
        return len;
    }
    os.close();
    return -1;
}
