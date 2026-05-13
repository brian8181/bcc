#include "TEST_symbol_table.hpp"
#include <cstring>
#include <iomanip>
#include <iostream>
#include <map>
#include <string>
#include <stdexcept>

using std::cout;
using std::endl;
using std::cerr;
using std::string;

//using namespace ast;

CPPUNIT_TEST_SUITE_REGISTRATION( TEST_symbol_table );

void TEST_symbol_table::setUp()
{

}

void TEST_symbol_table::tearDown()
{

}

void TEST_symbol_table::TEST_string_memory()
{
	char cstr[] = "Hello!";
	string str1( cstr );
	int len = strlen( cstr );
	CPPUNIT_ASSERT_EQUAL( 6, len );
	CPPUNIT_ASSERT_EQUAL( cstr[6], '\0' );

	char* pcstr = 0;
	pcstr = (char*)malloc( sizeof( char ) * len + 1 );
	CPPUNIT_ASSERT( pcstr != 0 );

	strcpy( pcstr, cstr );
	string str2( pcstr );
	cout << "str2 = \"" << str2 << "\"" << endl;
	cout << "pcstr = \"" << pcstr << "\"" << endl;

	free( pcstr );

	cout << "freed pcstr" << endl;
	cout << "str2 = \"" << str2 << "\"" << endl;
	CPPUNIT_ASSERT( str1 == str2 );
	CPPUNIT_ASSERT( strcmp( str1.c_str(), str2.c_str() ) == 0 );
}


void TEST_symbol_table::TEST_add_symbol_change_value()
{
	// std::map<string, symbol_base*> symbol_table_;
	// symbol_<int> s( "x", 42);
	// symbol_table_["x"] = &s;
	// auto it = symbol_table_.find( "x" );
	// if(it != symbol_table_.end())
	// {
	// 	cout << std::dec << endl;
	// 	string id = it->first;
	// 	cout << "sym=" << id << endl;
	// 	symbol_<int>* ps = ( symbol_<int>* )it->second;
	// 	cout << "result=" << *ps->m_pval << endl;
	// 	ps->set( 77 );
	// 	cout << "ps=" << *ps->m_pval << " : " << *ps->get() << endl;
	// 	*ps->m_pval = 88;
	// 	cout << "ps=" << *ps->m_pval << " : " << *ps->get() << endl;
	// }
}
