/**
 * @file    variable.hpp
 * @version 0.0.1
 * @date    Wed, 03 Jun 2026 16:53:24 +0000
 */
#ifndef _variable_HPP_
#define _variable_HPP_
#include <iostream>
#include "terminial_expr.hpp"

/**
  * @brief class variable
  */
class variable : public terminial_expr
{
public:
	
		/**
	* @brief : copy ctor
	*/
	variable( const variable& src ) = default;
	
		/**
	* @brief : destructor
	*/
	~variable() = default;
	
	
	
	/**
	  * @brief 
	  * @brief c++ comment ...
	  * @brief place future addtions here ...
	  *
	*/

private:
};

#endif
