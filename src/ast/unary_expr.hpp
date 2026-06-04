/**
 * @file    unary_expr.hpp
 * @version 0.0.1
 * @date    Wed, 03 Jun 2026 16:54:05 +0000
 */
#ifndef _unary_expr_HPP_
#define _unary_expr_HPP_
#include <iostream>
#include "nonterminial_expr.hpp"

/**
  * @brief class unary_expr
  */
class unary_expr : public nonterminial_expr
{
public:
	
		/**
	* @brief : copy ctor
	*/
	unary_expr( const unary_expr& src ) = default;
	
		/**
	* @brief : destructor
	*/
	~unary_expr() = default;
	
	
	
	/**
	  * @brief 
	  * @brief c++ comment ...
	  * @brief place future addtions here ...
	  *
	*/

private:
};

#endif
