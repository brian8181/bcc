/**
 * @file    bigint.hpp
 * @version 0.0.1
 * @date    Thu, 21 May 2026 08:36:45 +0000
 */
#ifndef _bigint_HPP_
#define _bigint_HPP_
#include <iostream>

/**
  * @brief class bigint
  */
class bigint
{
public:
	/**
	* @brief : default ctor
	*/
	bigint() = default;
	bigint(unsigned long digits);

		/**
	* @brief : copy ctor
	*/
	bigint( const bigint& src ) = default;
	
		/**
	* @brief : destructor
	*/
	~bigint() = default;
	
	void add(unsigned long n)
	{
		int carry_in;
		int carry_out;
		

	}



private:

unsigned int count; 
unsigned long* pdigits;

};

#endif
