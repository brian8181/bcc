/**
 * @file    io.hpp
 * @version 0.0.1
 * @date    Tue, 21 Apr 2026 07:39:25 +0000
 * @info    ...
 */
#include <sstream>
#include "io.hpp"

using std::stringstream;
stringstream ss;

/**
 * @name ctor
 */
io::io(const string& ifile) : file(infile)
{

}

/**
 * @name read
 */
void io::read()
{
	stream( file, mode );
	if( stream.is_open() )
	{
		stringstream ss;
		char c;
		while( stream.get( c ) != '\n')
		{
			ss << c;
		}
		out = ss.str();
		stream.close();
		return static_cast<int>( ss.str().size() );
	}
	return -1;
}


/**
 * @name read_istream
 * @brief read input file into string object
 */
void io::read_istream( const string& file, string& s )
{
	ifstream stream( file, std::ios::in );
	if( stream.is_open() )
	{
		stringstream ss;
		char c;
		while( stream.get( c ) )
		{
			ss << c;
		}
		s = ss.str();
		stream.close();
	}
}

/**
 * @name read_istream
 * @brief read input file into string object
 */
void io::read_istream( const string& file, char* cstr )
{
	ifstream stream( file, std::ios::in );
	if( stream.is_open() )
	{
		char c;
		int i = 0;
		while( stream.get( c ) )
		{
			cstr[i++] = c;
		}
		stream.close();
	}
}


/**
 * @brief str
 */
const string& io::str()
{
	return content;
}
