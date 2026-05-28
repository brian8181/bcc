#include "ast/file_scope.hpp"
#include "ast/symbol.hpp"
#include "ast/token.hpp"
#include "ast/variant.hpp"
#include "TEST_multiply_expr.hpp"
#include <cstring>
#include <iostream>
#include <stack>
#include <stdexcept>

using std::stack;
using std::cout;
using std::endl;
using std::cerr;
using namespace ast;

CPPUNIT_TEST_SUITE_REGISTRATION( TEST_multiply_expr );

void TEST_multiply_expr::setUp()
{

}

void TEST_multiply_expr::tearDown()
{

}

void TEST_multiply_expr::TEST_string_memory()
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

void TEST_multiply_expr::TEST_expr_eval()
{
	stringstream ss;
	add_expr<int> e( 2, 3 );
	int* pint = e.eval();
	ss << "pint = " << *pint << endl;
	LOG( ss.str() );
	CPPUNIT_ASSERT( *pint == (2 + 3) );
}
