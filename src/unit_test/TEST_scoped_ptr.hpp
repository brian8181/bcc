/**
 * @file    lex.hpp
 * @version 0.0.1
 * @date    Sun, 19 Apr 2026 14:20:00 +0000
 */
#ifndef _TEST_scoped_ptr_HPP_
#define _TEST_scoped_ptr_HPP_

#include <cppunit/Test.h>

class TEST_scoped_ptr : public CppUnit::TestFixture
{
private:
    CPPUNIT_TEST_SUITE(TEST_scoped_ptr);
	CPPUNIT_TEST(test_create);
    CPPUNIT_TEST(test_multiply_literals);
    CPPUNIT_TEST_SUITE_END();

public:
    void setUp();
    void tearDown();

    // agregate test functions
    void execute();
    void execute(int argc, char* argv[]);

protected:
	void test_create();
    void test_multiply_literals();

private:
    int m_argc;
    char* m_argv[10];

};

#endif
