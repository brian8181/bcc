/**
 * @file TEST_general.hpp
 * @version 0.0.1
 * @date Sun Apr 5 08:51:34 CDT 2026
 */
#include "TEST_general.hpp"
#include <cstring>
#include <iostream>
#include <sstream>
#include <stack>
#include <stdexcept>
#include <iomanip>

using std::stack;
using std::cout;
using std::endl;
using std::cerr;
using std::stringstream;
using std::string;

CPPUNIT_TEST_SUITE_REGISTRATION( TEST_general );

/**
 * @brief : default ctor
 */
TEST_general::TEST_general() = default;

/**
  * @brief : copy ctor
  */
TEST_general::TEST_general( const TEST_general& src ) = default;

/**
  * @brief : destructor
  */
TEST_general::~TEST_general() = default;

/**
 *
 */
void TEST_general::setUp()
{
}

/**
 *
 */
void TEST_general::tearDown()
{
}

void TEST_general::TEST_quoted()
{
    //1000101011000111001000110000010010001001111010000000000000000000
    // 0 - 999'999'999'999'999'999'9

    unsigned long MAX = 9'999'999'999'999'999'999ul;
    unsigned long digits[10000];
    

    string expected = "Hello World";
    string quoted = "\"Hello World\"";
    stringstream ss;
    string unquoted;
    ss << quoted;
    ss >> std::quoted(unquoted);
    std::cout << "\nbefore=" << quoted << ", after=" << unquoted << std::endl; 
    CPPUNIT_ASSERT(expected == unquoted);
}

/**
 *
 */
void TEST_general::TEST_assign()
{
    int b;
    b = (2 == 1);
    CPPUNIT_ASSERT(b != 1);
    CPPUNIT_ASSERT(b == 0);

    b = (1 == 1);
    CPPUNIT_ASSERT(b == 1);
    CPPUNIT_ASSERT(b != 0);

    CPPUNIT_ASSERT(1 == 1);
}
