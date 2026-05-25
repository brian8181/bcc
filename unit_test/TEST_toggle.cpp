/**
 * @file TEST_toggle.hpp
 * @version 0.0.1
 * @date Sun Apr 5 08:51:34 CDT 2026
 */
#include <cstring>
#include <iostream>
#include <sstream>
#include <stack>
#include <stdexcept>
#include <iomanip>
#include "TEST_toggle.hpp"

using std::stack;
using std::cout;
using std::endl;
using std::cerr;
using std::stringstream;
using std::string;

CPPUNIT_TEST_SUITE_REGISTRATION( TEST_toggle );

/**
 * @brief : default ctor
 */
TEST_toggle::TEST_toggle() = default;

/**
  * @brief : copy ctor
  */
TEST_toggle::TEST_toggle( const TEST_toggle& src ) = default;

/**
  * @brief : destructor
  */
TEST_toggle::~TEST_toggle() = default;

/**
 *
 */
void TEST_toggle::setUp()
{
}

/**
 *
 */
void TEST_toggle::tearDown()
{
}

/**
 * @name TEST_set
 */
void TEST_toggle::TEST_set()
{
    toggle t;
    bool actual = t.set();
    bool expected = true;
    CPPUNIT_ASSERT(expected == actual);
    
    expected = false;
    actual = t.set();
    CPPUNIT_ASSERT(expected == actual);

    expected = true;
    actual = t.set();
    CPPUNIT_ASSERT(expected == actual);
}

/**
 * @name TEST_get
 */
void TEST_toggle::TEST_get()
{
    toggle t1(true);
    bool actual = t1.get();
    bool expected = true;
    CPPUNIT_ASSERT(expected == actual);

    toggle t2(false);
    actual = t2.get();
    expected = false;
    CPPUNIT_ASSERT(expected == actual);

    expected = true;
    t2.set();
    actual = t2.get();
    CPPUNIT_ASSERT(expected == actual);
}

/**
 * @name TEST_get_co
 */
void TEST_toggle::TEST_get_co()
{
    toggle t;
    bool expected = true;
    bool actual = true;
    CPPUNIT_ASSERT(expected == actual);
}
