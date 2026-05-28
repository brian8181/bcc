/**
 * @file    TEST_variant.hpp
 * @version 0.0.1
 * @date    Thu, 04 Dec 2025 03:49:40 +0000
  */
#ifndef _TEST_VARIANT_HPP_
#define _TEST_VARIANT_HPP_

#include "ast/variant.hpp"
#include <cppunit/extensions/HelperMacros.h>
#include <cppunit/TestFixture.h>
#include <iostream>

class TEST_variant : public CppUnit::TestFixture
{
	CPPUNIT_TEST_SUITE( TEST_variant );
	CPPUNIT_TEST( TEST_string_memory );
	CPPUNIT_TEST( TEST_variant_create_unset_set );
	CPPUNIT_TEST( TEST_variant_create_unset_set2 );
	CPPUNIT_TEST( TEST_variant_create_from_array );
	CPPUNIT_TEST( TEST_variant_create_from_array2 );
	CPPUNIT_TEST( TEST_variant_create_from_array3 );
	CPPUNIT_TEST_SUITE_END();

public:
	void setUp() override;
	void tearDown() override;

protected:
	void TEST_string_memory();
	void TEST_variant_create_unset_set();
	void TEST_variant_create_unset_set2();
	void TEST_variant_create_from_array();
	void TEST_variant_create_from_array2();
	void TEST_variant_create_from_array3();
private:

};

#endif // _TEST_VARIANT_HPP_
