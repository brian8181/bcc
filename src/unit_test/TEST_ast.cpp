/**
 * @file    lex.hpp
 * @version 0.0.1
 * @date    Sun, 19 Apr 2026 14:20:00 +0000
 */
#include <iostream>
#include <string>
#include <list>
#include <cppunit/TestCase.h>
#include <cppunit/TestFixture.h>
#include <cppunit/ui/text/TextTestRunner.h>
#include <cppunit/extensions/HelperMacros.h>
#include <cppunit/extensions/TestFactoryRegistry.h>
#include <cppunit/TestResult.h>
#include <cppunit/TestResultCollector.h>
#include <cppunit/TestRunner.h>
#include <cppunit/BriefTestProgressListener.h>
#include <cppunit/CompilerOutputter.h>
#include <cppunit/XmlOutputter.h>
#include <netinet/in.h>
#include <string.h>
#include "TEST_ast.hpp"
#include "bash_color.hpp"
#include "ast/variant.hpp"


using namespace CppUnit;
using namespace std;


CPPUNIT_TEST_SUITE_REGISTRATION( TEST_ast );
// create parser
//static yy::parser yyparser;

/**
 * @name lex
 * @return yy::parser::symbol_type
 */
// yy::parser::symbol_type lex()
// {
// 	// TRACE();
// 	//return lexer::instance().get_token();
// }


void TEST_ast::setUp()
{
}

void TEST_ast::tearDown()
{
}

void TEST_ast::test_literal()
{
    int n = 42;
    variant v1(n);

    int expected = 42;
    int actual = (int)v1;

    // long n = 42;
	// ast::literal<long> e2(&n);
	// long* r = e2.eval<long>();
    CPPUNIT_ASSERT(actual == expected);
}

void TEST_ast::test_multiply_literals()
{
    // long a = 3;
    // ast::literal<long> e1(&a);
    // e1.eval<long>();

    // long b = 2;
    // ast::literal<long> e2(&b);
    // e2.eval<long>();

    // ast::multiply_operation<long> ex(&e1, &e2);
    // long* result = ex.eval();

    // CPPUNIT_ASSERT(*result == 6);
}

void TEST_ast::execute()
{
    // on head
    char** pstr = new char*;
    *pstr = (char*)"test";    // on the heap

    char** argv = new char*[1] {*pstr};
    //argv[0] = *pstr;

    execute(1, argv);

    delete pstr;
    delete [] argv;

    // on stack
    //char* argv_[3] {(char*)"./App", (char*)"abc", (char*)"abc"};
}

void TEST_ast::execute(int argc, char* argv[])
{

}
