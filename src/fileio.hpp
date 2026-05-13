/**
 * @file     fileio.hpp
 * @date:    Tue, Oct 28, 2025  1:47:46 PM
 * @version: 0.0.1
 */

#ifndef _FILEIO_HPP_
#define _FILEIO_HPP_

#include <string>
#include <sstream>
#include <iostream>
#include <fstream>
#include <vector>
#include <filesystem>


namespace fs = std::filesystem;

using std::string;
using std::vector;
using std::ifstream;
using std::ofstream;
using std::stringstream;
using std::ios;

/**
 *
 */
long file_size(const string& path);

/**
 * @brief  check if file exist
 * @param  const string& : path to file
 * @return bool: ture file exsit otherwise false
 */
bool file_exist(const string& path);

/**
 * @brief get an ofstream by path
 * @param path
 * @param strm
 * @return void
 */
void get_ofstream(const string& file, /*out */ofstream*& strm);


/**
 * @brief get an ifstream by path
 * @param path
 * @param srtm
 * @return void
 */
void get_ifstream(const string& file, /*out */ifstream*& strm);

/**
 *
 * @param sbuf *
 * @return char
 */
char getc(std::streambuf& sbuf);

/**
 * @brief  read a character from a file stream
 * @param  strm The file stream to read from
 * @param  c : the character to read
 * @return file stream
 */
ifstream& read_char(ifstream& stream, /* out */ char& c);

/**
 * @brief  write a character to a file stream
 * @param  strm file stream to write
 * @param  c : character to write
 * @return file stream
 */
ofstream& write_char(ofstream& stream, /* in */ const char& c);

/**
 * @brief  read a file into a buffer
 * @param  file The file to read from
 * @param  buf : The buffer to store the file contents
 * @param  len : length of the buffer
 * @return number of bytes read, or -1 on error
 */
int read_buf(const string& file, /* out */ unsigned char* buf, const int& len);

/**
 * @brief  write a buffer to a file
 * @param  file : file to write to
 * @param  buf : buffer to write
 * @param  len : length of the buffer
 * @return number of bytes written, or -1 on error
 */
int write_buf(const string& file, /* in */ const char* buf, const int& len);

/**
 * @brief  read a file into a string
 * @param  file : file to read from
 * @param  out : string to store the file contents
 * @return number of characters read, or -1 on error
 */
int read_str(const string& file, /* out */ string& out, std::ios::openmode mode = std::ios_base::in);

/**
 * @brief  write a string to a file
 * @param  file The file to write to
 * @param  in : string to write
 * @return number of characters written, or -1 on error
 */
int write_str(const string& file, /* in */ const string& out, std::ios_base::openmode mode = ios::out);

/**
 * @brief  read a file into a stringstream
 * @param  file : file to read from
 * @param  sstrm : stringstream to store the file contents
 * @return number of characters read, or -1 on error
 */
int read_sstream(const string& file, /* out */ stringstream& sstrm, std::ios_base::openmode mode = ios::in);

/**
 * @brief  write a stringstream to a file
 * @param  file : file to write to
 * @param  sstrm : stringstream to write
 * @return number of characters written, or -1 on error
 */
int write_sstream(const string& file, /* in */ const stringstream& sstrm, std::ios_base::openmode mode = ios::out | std::ofstream::trunc);

/**
 * @brief  read lines from a file into a vector of strings
 * @param  file : file to read from
 * @param  lines : vector to store the lines
 * @return number of lines written, or -1 on errors
 */
int read_line(const string& file, /* out */ const string& line);

/**
 * @brief  write lines to a file
 * @param  file : file to write to
 * @param  lines : lines to write
 * @return number of lines written, or -1 on error
 */
int write_line(const string& file, /* in */ const string& line);

/**
 * @brief  read lines from a file into a vector of strings
 * @param  file : file to read from
 * @param  lines : vector to store the lines
 * @return number of lines written, or -1 on errors
 */
int read_lines(const string &file, /* out */ vector<string>& lines);

/**
 * @brief  write lines to a file
 * @param  file : file to write to
 * @param  lines : lines to write
 * @return number of lines written, or -1 on error
 */
int write_lines(const string& file, /* in */ const vector<string>& lines);

#endif
