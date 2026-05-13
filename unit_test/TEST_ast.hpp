/**
 * @file    lex.hpp
 * @version 0.0.1
 * @date    Sun, 19 Apr 2026 14:20:00 +0000
 */
#ifndef _TEST_ast_HPP_
#define _TEST_ast_HPP_

#include <cppunit/Test.h>

class TEST_ast : public CppUnit::TestFixture
{
private:
    CPPUNIT_TEST_SUITE(TEST_ast);
	CPPUNIT_TEST(test_literal);
    CPPUNIT_TEST_SUITE_END();

public:
    void setUp();
    void tearDown();

    // agregate test functions
    void execute();
    void execute(int argc, char* argv[]);

protected:
	void test_literal();

private:
    int m_argc;
    char* m_argv[10];

};

#endif
