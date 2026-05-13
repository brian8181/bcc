

#include <cstring>
#include <iostream>
#include <stack>
#include <stdexcept>
#include <string>
#include "TEST_assign_expr.hpp"

using std::string;
using std::stack;
using std::cout;
using std::endl;
using std::cerr;

CPPUNIT_TEST_SUITE_REGISTRATION( TEST_assign_expr );

void TEST_assign_expr::setUp()
{

}

void TEST_assign_expr::tearDown()
{

}

void TEST_assign_expr::TEST_string_memory()
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

void TEST_assign_expr::TEST_expr_eval()
{
	// string file_name = "test_file.cpp";
	// file_scope scope( file_name );
	// cout << endl;
	// log( "file_scope scope( file_name );", __LINE__ );
	// CPPUNIT_ASSERT( scope.get_symbol( "x" ) == 0 );
	// CPPUNIT_ASSERT( scope.get_parent_scope() == 0 );

	// scope.push_symbol( symbol( "x", "int", INT ) );
	// //log( "scope.push_symbol( symbol( \"x\", \"int\", INT ) );", __LINE__ );
	// //variant* vx = scope.get_symbol( "x" )->get_value();
	// cout << "vx = " << vx << " line: " << __LINE__ << endl;
	// //log( "allocating buffer ...", __LINE__ );
	// //int* px = vx->allocate_buffer<int>();
	// log( "int* px = vx->allocate_buffer<int>();", __LINE__ );
	// *px = 25;

	// // todo!
	// /*symbol s = scope.get_symbol( "x" );
	// assign_expr<int> exp( s, 25 );*/

	// log( "*px = 25;", __LINE__ );
	// cout << "(int)(*vx) = " << (int)( *vx ) << " line: " << __LINE__ << endl;
	// CPPUNIT_ASSERT( (int)( *vx ) == 25 );
}
