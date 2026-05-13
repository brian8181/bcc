/**
 * @file    io.hpp
 * @version 0.0.1
 * @date    Tue, 21 Apr 2026 07:39:25 +0000
 * @info    ...
 */
#ifndef _io_HPP_
#define _io_HPP_
#include <string>
#include <fstream>

using std::string;
using std::ofstream;
using std::ifstream;

/**
  * @brief class io
  */
class io
{
public:
	/**
	* @brief : default ctor
	*/
	io(const string& infile);

	/**
	* @brief : copy ctor
	*/
	io( const io& src ) = default;

	/**
	* @brief : destructor
	*/
	~io() = default;

	void read();

	/**
	 * @name read_istream
	 * @brief read input file into string object
	 */
	static void read_istream( const string& file, string& s );

	/**
	 * @name read_istream
	 * @brief read input file into string object
	 */
	static void read_istream( const string& file, char* cstr );

	/**
	 * @brief str
	 */
	const string& str();


private:
	ifstream stream;
	string& file;
	std::ios::openmode mode = std::ios_base::in;

	string& content;

};

#endif
