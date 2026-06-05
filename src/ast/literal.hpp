/**
 * @file    literal.hpp
 * @version 0.0.1
 * @date    Wed, 03 Jun 2026 16:53:14 +0000
 */
#ifndef _literal_HPP_
#define _literal_HPP_
#include <iostream>
#include "terminial_expr.hpp"

/**
  * @brief class literal

  */
template< class T >
class literal : public terminial_expr<T>
{
public:
	
		/**
	* @brief : copy ctor
	*/
	literal( const literal& src ) = default;
	
		/**
	* @brief : destructor
	*/
	~literal() = default;
	
	
	
	/**
	  * @brief 
	  * @brief c++ comment ...
	  * @brief place future addtions here ...
	  *
	*/

private:

};

#endif
