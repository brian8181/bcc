/**
 * @file    TEST_assign.hpp
 * @version 0.0.1
 * @date    Thu, 04 Dec 2025 16:15:17 +0000
 * @info    ...
 */
#ifndef _TEST_assign_HPP_
#define _TEST_assign_HPP_


#include <cppunit/extensions/HelperMacros.h>
#include <cppunit/TestFixture.h>
#include <iostream>

/**
  * @brief class TEST_assign
  */
class TEST_assign : public CppUnit::TestFixture
{
	CPPUNIT_TEST_SUITE( TEST_assign );
	CPPUNIT_TEST_SUITE_END();

public:
	void setUp();
	void tearDown();

public:
	/**
	* @brief : default ctor
	*/
	TEST_assign() {};

		/**
	* @brief : copy ctor
	*/
	TEST_assign( const TEST_assign& src )

		/**
	* @brief : destructor
	*/
	virtual ~TEST_assign() {}



	/**
	  * @brief
	  * @brief c++ comment ...
	  * @brief place future additions here ...
	  *
	*/

private:

};

#endif
