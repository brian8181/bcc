/**
 * @file    lex.hpp
 * @version 0.0.1
 * @date    Sun, 19 Apr 2026 14:20:00 +0000
 */
#ifndef _TEST_lex_H
#define _TEST_lex_H

#include <cppunit/Test.h>

class TEST_lex : public CppUnit::TestFixture
{
private:
    CPPUNIT_TEST_SUITE(TEST_lex);
    CPPUNIT_TEST(test_initialize);
    CPPUNIT_TEST(test_get_token);
    CPPUNIT_TEST_SUITE_END();

public:
    void setUp();
    void tearDown();

    // agregate test functions
    void execute();
    void execute(int argc, char* argv[]);

protected:
    void test_initialize();
    void test_get_token();
  
private:
    int m_argc;
    char* m_argv[10];

};

#endif
