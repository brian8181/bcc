#include <iostream>
#include <vector>
#include <string>
#include "ast.hpp"

using std::cout;
using std::endl;
using std::string;

#define AST_MAIN
#define AST_MAIN
#ifdef AST_MAIN
int main(int argc, char** argv)
{
	// string s = "test";
	// ast::string_literal e1(&s);
	// e1.eval<string>();

	long n = 42;
	ast::literal<long> e2(&n);
	e2.eval<long>();

	long n2 = 55;
	ast::literal<long> e3(&n2);
	e3.eval<long>();

	//ast::binary_expr be(&e2, &e3);

	ast::add_operation<long> ex(&e2, &e3);
	long* pv = ex.eval();
	cout << "*pv=" << *pv << endl;

	ast::literal e5(&n2);
	ast::literal e6(&n);
	ast::subtract_operation<long> ex2(&e5,&e6);
	long* p2 = ex2.eval();
	cout << "*p2=" << *p2 << endl;

	ast::multiply_operation<long> ex3(&e5, &e6);
	long* p3 = ex3.eval();
	cout << "*p3=" << *p3 << endl;



	//std::vector<ast::expr> vec = { e1, e2, e3, e4, e5 };

    return 0;
}
#endif
