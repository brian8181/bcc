#ifndef _TESTEXPR_HPP_
#define _TESTEXPR_HPP_

#include <cppunit/extensions/HelperMacros.h>
#include <cppunit/TestFixture.h>

class TEST_expr : public CppUnit::TestFixture
{
    CPPUNIT_TEST_SUITE( TEST_expr );
    CPPUNIT_TEST( TEST_string_memory );
    CPPUNIT_TEST( TEST_expr_eval );
    CPPUNIT_TEST( TEST_add_expr_eval );
	CPPUNIT_TEST( TEST_sub_expr_eval );
	CPPUNIT_TEST( TEST_multi_expr_eval );
	CPPUNIT_TEST( TEST_mod_expr_eval );
    CPPUNIT_TEST( TEST_assign_expr_eval );
	CPPUNIT_TEST_SUITE_END();

public:
    void setUp() override;
    void tearDown() override;

protected:
    void TEST_string_memory();
    void TEST_expr_eval();
  	void TEST_add_expr_eval();
    void TEST_sub_expr_eval();
	void TEST_multi_expr_eval();
	void TEST_mod_expr_eval();
    void TEST_assign_expr_eval();

private:

};

#endif // _TESTEXPR_HPP_
