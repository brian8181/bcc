#include "ast/file_scope.hpp"
#include "ast/symbol.hpp"
#include "ast/token.hpp"
#include "ast/variant.hpp"
#include "TEST_variant.hpp"
#include <cstring>
#include <iostream>
#include <stack>
#include <stdexcept>

using std::stack;
using std::cout;
using std::endl;
using std::cerr;
using namespace ast;

CPPUNIT_TEST_SUITE_REGISTRATION( TEST_variant );

void TEST_variant::setUp()
{

}

void TEST_variant::tearDown()
{

}

void TEST_variant::TEST_string_memory()
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


void TEST_variant::TEST_variant_create_unset_set()
{
	string s( "int" );
	variant var_int( s, INT );
	int* p_int = var_int.allocate_buffer<int>();
	type_t t = var_int.get_type();
	CPPUNIT_ASSERT( var_int.get_type() == INT );
	*p_int = 123;
	CPPUNIT_ASSERT( (int)var_int == 123 );
}

void TEST_variant::TEST_variant_create_unset_set2()
{
	variant var_int( 21 );
	CPPUNIT_ASSERT( (int)var_int == 21 );
	int* p_int = (int*)var_int;
	*p_int = 42;
	CPPUNIT_ASSERT( (int)var_int == 42 );
}

void TEST_variant::TEST_variant_create_from_array()
{
	int arr_int[] = { 1, 2, 3, 4, 5 };
	variant var_int_array( arr_int, 5 );
	CPPUNIT_ASSERT( var_int_array.get_type() == PTR_INT );
	double arr_double[] = { 1.1, 2.2, 3.3 };
	variant var_double_array( arr_double, 3 );
	CPPUNIT_ASSERT( var_double_array.get_type() == PTR_DOUBLE );
}

void TEST_variant::TEST_variant_create_from_array2()
{
	int arr_int[] = { 1, 2, 3, 4, 5 };
	variant var_int_array( arr_int, 5 );
	int* p_int_array = (int*)var_int_array;
	CPPUNIT_ASSERT( p_int_array[0] == 1 );
	CPPUNIT_ASSERT( p_int_array[1] == 2 );
	CPPUNIT_ASSERT( p_int_array[2] == 3 );
	CPPUNIT_ASSERT( p_int_array[3] == 4 );
	CPPUNIT_ASSERT( p_int_array[4] == 5 );
	double arr_double[] = { 1.1, 2.2, 3.3 };
	variant var_double_array( arr_double, 3 );
	double* p_double_array = (double*)var_double_array;
	CPPUNIT_ASSERT( p_double_array[0] == 1.1 );
	CPPUNIT_ASSERT( p_double_array[1] == 2.2 );
	CPPUNIT_ASSERT( p_double_array[2] == 3.3 );
}

void TEST_variant::TEST_variant_create_from_array3()
{
	int arr_int[] = { 1, 2, 3, 4, 5 };
	variant var_int_array( arr_int, 5 );
	int* p_int_array = (int*)var_int_array;
	CPPUNIT_ASSERT( p_int_array[0] == 1 );
	CPPUNIT_ASSERT( p_int_array[1] == 2 );
	CPPUNIT_ASSERT( p_int_array[2] == 3 );
	CPPUNIT_ASSERT( p_int_array[3] == 4 );
	CPPUNIT_ASSERT( p_int_array[4] == 5 );
	double arr_double[] = { 1.1, 2.2, 3.3 };
	variant var_double_array( arr_double, 3 );
	double* p_double_array = (double*)var_double_array;
	CPPUNIT_ASSERT( p_double_array[0] == 1.1 );
	CPPUNIT_ASSERT( p_double_array[1] == 2.2 );
	CPPUNIT_ASSERT( p_double_array[2] == 3.3 );
}

