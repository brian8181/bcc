/**
 * @file    sum.hpp
 * @version 0.0.1
 * @date    Wed, 03 Jun 2026 16:54:22 +0000
 */
#ifndef _sum_HPP_
#define _sum_HPP_
#include <iostream>
#include "binary_expr.hpp"

/**
  * @brief class sum
  */
class sum : public binary_expr
{
public:
	
		/**
	* @brief : copy ctor
	*/
	sum( const sum& src ) = default;
	
		/**
	* @brief : destructor
	*/
	~sum() = default;
	
	
	
	/**
	  * @brief 
	  * @brief c++ comment ...
	  * @brief place future addtions here ...
	  *
	*/

private:
	//right assoc: abstract_expr + terminal
	//left assoc: terminal + abstract_expr
};

#endif
