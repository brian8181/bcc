md #ifndef _TEST_MULTIPLY_EXPR_HPP_
#define _TEST_MULTIPLY_EXPR_HPP_

#include <cppunit/extensions/HelperMacros.h>
#include <cppunit/TestFixture.h>

class TEST_multiply_expr : public CppUnit::TestFixture
{
	CPPUNIT_TEST_SUITE( Test_multiply_expr );
	CPPUNIT_TEST( TEST_string_memory );
	CPPUNIT_TEST( TEST_expr_eval );
	CPPUNIT_TEST_SUITE_END();

public:
	void setUp() override;
	void tearDown() override;

protected:
	void TEST_string_memory();
	void TEST_expr_eval();

private:

};

#endif // _TEST_MULTIPLY_EXPR_HPP_
