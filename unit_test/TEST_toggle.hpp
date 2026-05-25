/**
* @file TEST_toggle.hpp
 * @version 0.0.1
 * @date Sun Apr 5 08:51:34 CDT 2026
 */
#ifndef _TEST_toggle_HPP_
#define _TEST_toggle_HPP_
#include <iostream>

#include <cppunit/extensions/HelperMacros.h>
#include <cppunit/TestFixture.h>
#include "toggle.hpp"

/**
  * @brief class TEST_toggle
  */
class TEST_toggle : public CppUnit::TestFixture
{
public:
  /**
  * @brief : default ctor
  */
  TEST_toggle();
  /**
  * @brief : copy ctor
  */
  TEST_toggle( const TEST_toggle& src );

  /**
  * @brief : destructor
  */
  virtual ~TEST_toggle();

  CPPUNIT_TEST_SUITE( TEST_toggle );
  CPPUNIT_TEST( TEST_set );
  CPPUNIT_TEST( TEST_get );
  CPPUNIT_TEST( TEST_get_co );
  CPPUNIT_TEST_SUITE_END();

public:
  void setUp() override;
  void tearDown() override;

protected:
  void TEST_set();
  void TEST_get();
  void TEST_get_co();
      
private:


};

#endif
