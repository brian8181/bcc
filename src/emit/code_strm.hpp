/**
 * @file    code_strm.hpp
 * @version 0.0.1
 * @date    Fri, 29 May 2026 01:05:36 +0000
 */
#ifndef _code_strm_HPP_
#define _code_strm_HPP_
#include <iostream>

/**
  * @brief class code_strm
  */
class code_strm
{
public:
	/**
	* @brief : default ctor
	*/
	code_strm() = default;

		/**
	* @brief : copy ctor
	*/
	code_strm( const code_strm& src ) = default;

		/**
	* @brief : destructor
	*/
	~code_strm() = default;

	virtual string strm() = 0;

private:
};

#endif
