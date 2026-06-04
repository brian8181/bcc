/**
 * @file    binary_expr.hpp
 * @version 0.0.1
 * @date    Wed, 03 Jun 2026 16:53:46 +0000
 */
#ifndef _binary_expr_HPP_
#define _binary_expr_HPP_
#include <iostream>
#include "nonterminial_expr.hpp"

/**
  * @brief class binary_expr
  */
class binary_expr : public nonterminial_expr
{
public:
	
		/**
	* @brief : copy ctor
	*/
	binary_expr( const binary_expr& src ) = default;
	
		/**
	* @brief : destructor
	*/
	~binary_expr() = default;
	
	
	
	/**
	  * @brief 
	  * @brief c++ comment ...
	  * @brief place future addtions here ...
	  *
	*/

private:
};

#endif
