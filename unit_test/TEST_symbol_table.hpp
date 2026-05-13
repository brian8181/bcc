#ifndef TEST_symbol_table_H
#define TEST_symbol_table_H

#include <cppunit/extensions/HelperMacros.h>
#include <cppunit/TestFixture.h>

class TEST_symbol_table : public CppUnit::TestFixture
{
    CPPUNIT_TEST_SUITE( TEST_symbol_table );
    CPPUNIT_TEST( TEST_string_memory );
    CPPUNIT_TEST( TEST_add_symbol_change_value );
    CPPUNIT_TEST_SUITE_END();

public:
    void setUp() override;
    void tearDown() override;

protected:
    void TEST_string_memory();
    void TEST_add_symbol_change_value();

private:

};

#endif // TEST_symbol_table_H