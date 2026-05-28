/**
 * @file    abc.hpp
 * @version 0.0.1
 * @date    Wed, 27 May 2026 18:43:33 +0000
 */
#ifndef _TEST_abc_H
#define _TEST_abc_H

#include <cppunit/Test.h>

class TEST_abc : public CppUnit::TestFixture
{
private:
    CPPUNIT_TEST_SUITE(TEST_abc);
    CPPUNIT_TEST(testNoOptions);
    CPPUNIT_TEST(testOptionHelp);
    CPPUNIT_TEST(testOptionHelpLong);
    CPPUNIT_TEST(testOptionVerbose);
    CPPUNIT_TEST(testOptionVerboseLong);
    CPPUNIT_TEST_SUITE_END();

public:
    void setUp();
    void tearDown();

    // agregate test functions
    void execute();
    void execute(int argc, char* argv[]);

protected:
    void testNoOptions();
    void testOptionHelp();
    void testOptionHelpLong();
    void testOptionVerbose();
    void testOptionVerboseLong();

private:
    int m_argc;
    char* m_argv[10];

};

#endif
