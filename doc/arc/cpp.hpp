/**
 * @file    cpp.hpp
 * @version 0.0.1
 * @date    Sat, 16 May 2026 19:22:40 +0000
 */
#ifndef _cpp_HPP_
#define _cpp_HPP_
#include <iostream>

/**
  * @brief class cpp
  */
class cpp
{
public:
	/**
	* @brief : default ctor
	*/
	cpp() = default;

		/**
	* @brief : copy ctor
	*/
	cpp( const cpp& src ) = default;
	
		/**
	* @brief : destructor
	*/
	~cpp() = default;

	void parse();

private:
};

#endif
