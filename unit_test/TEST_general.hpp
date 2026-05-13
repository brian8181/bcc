/**
* @file TEST_general.hpp
 * @version 0.0.1
 * @date Sun Apr 5 08:51:34 CDT 2026
 */
#ifndef _TEST_general_HPP_
#define _TEST_general_HPP_
#include <iostream>

#include <cppunit/extensions/HelperMacros.h>
#include <cppunit/TestFixture.h>

/**
  * @brief class TEST_general
  */
class TEST_general : public CppUnit::TestFixture
{
public:
  /**
  * @brief : default ctor
  */
  TEST_general();
  /**
  * @brief : copy ctor
  */
  TEST_general( const TEST_general& src );

  /**
  * @brief : destructor
  */
  virtual ~TEST_general();

  CPPUNIT_TEST_SUITE( TEST_general );
  CPPUNIT_TEST( TEST_assign );
  CPPUNIT_TEST_SUITE_END();

public:
  void setUp() override;
  void tearDown() override;

protected:
  void TEST_assign();

private:


};

#endif
