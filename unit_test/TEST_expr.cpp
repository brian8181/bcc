#include "log.hpp"
#include "TEST_expr.hpp"
#include <cstring>
#include <iostream>
#include <sstream>
#include <stack>
#include <stdexcept>

using std::stack;
using std::cout;
using std::endl;
using std::cerr;
using std::stringstream;

CPPUNIT_TEST_SUITE_REGISTRATION( TEST_expr );

void TEST_expr::setUp()
{

}

void TEST_expr::tearDown()
{

}

void TEST_expr::TEST_string_memory()
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

void TEST_expr::TEST_expr_eval()
{
	// stringstream ss;
	// add_expr<int> e( -12, 3 );
	// int* pint = e.eval();
	// ss << "pint = " << *pint << endl;
	// LOG( ss.str() );
	// CPPUNIT_ASSERT( *pint == (-12 + 3) );
}

void TEST_expr::TEST_add_expr_eval()
{
	// stringstream ss;
	// add_expr<int> e( 2, 3 );
	// int* pint = e.eval();
	// ss << "pint = " << *pint << endl;
	// LOG( ss.str() );
	// CPPUNIT_ASSERT( *pint == (2 + 3) );
}

void TEST_expr::TEST_sub_expr_eval()
{
	// stringstream ss;
	// subtract_expr<int> e( 2, 3 );
	// int* pint = e.eval();
	// ss << "pint = " << *pint << endl;
	// LOG( ss.str() );
	// CPPUNIT_ASSERT( *pint == (2 - 3) );
}

void TEST_expr::TEST_multi_expr_eval()
{
	// stringstream ss;
	// multiply_expr<int> e( 2, 3 );
	// int* pint = e.eval();
	// ss << "pint = " << *pint << endl;
	// LOG( ss.str() );
	// CPPUNIT_ASSERT( *pint == (2 * 3) );

	// multiply_expr<int> rhs(5, 6);
	// multiply_expr<int> e2( 3, rhs);
	// int* pint2 = e2.eval();
	// CPPUNIT_ASSERT( *pint2 == (3 * (5 * 6) ) );
}

void TEST_expr::TEST_mod_expr_eval()
{
	// stringstream ss;
	// mod_expr<int> e( 10, 3 );
	// int* pint = e.eval();
	// ss << "pint = " << *pint << endl;
	// LOG( ss.str() );
	// CPPUNIT_ASSERT( *pint == (10 % 3) );
}

void TEST_expr::TEST_assign_expr_eval()
{
	// stringstream ss;
	// symbol s("x", "int", INT);

	// symbol_expr<int> expr(s);
	// assign_expr<int> e( s, 3 );
	// int* pint = e.eval();
	// ss << "pint = " << *pint << endl;
	// LOG( ss.str() );
	// CPPUNIT_ASSERT( *pint == 3 );
}
