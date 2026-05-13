/**
 * @file    expr.hpp
 * @version 0.0.1
 * @date    Thu, Oct 30, 2025  4:59:12 PM
 */
#ifndef _expr_HPP_
#define _expr_HPP_

#include <iostream>
#include <string>

using std::cout;
using std::endl;
using std::string;
namespace ast
{
	class expr_t
	{
	};

	/**
	 * @class expr
	 */
	class expr : expr_t
	{
	public:
		/**
		 * @brief : default ctor
		 */
		expr() = default;

		/**
		 * @brief copy ctor
		 * @param const symbol_expr& src, source copy
		 */
		expr( const expr& src ) = default;

		/**
		 * @brief destructor
		 */
		virtual ~expr() = default;

		 /**
		 * @brief  T* eval
		 * @return T*
		 */
		template< typename T >
		T* eval()
		{
			return (T*)_val;
		}
	protected:
		 void* _val;
	};

	//template< class T >
	class binary_expr : public expr
	{
	public:
		binary_expr(expr* lhs, expr* rhs) : _lhs(lhs), _rhs(rhs)
		{
		}
	protected:
		expr* _lhs;
		expr* _rhs;
	};

	template< class T >
	class literal : public expr
	{
	public:
		literal(T* n)
		{
			_val = new T;
			T* pn = (T*)_val;
			*pn = *n;
		}
	};

	template< class T >
	class add_operation : public binary_expr
	{
	public:
		add_operation(T* lhs, T* rhs) : binary_expr(literal<T>(lhs), literal<T>(rhs))
		{
		}
		add_operation(expr* lhs, expr* rhs) : binary_expr(lhs, rhs)
		{
		}
		T* eval()
		{
			_val = new T;
			T* pval = (T*)_val;
			*pval = *(_lhs->eval<T>()) + *(_rhs->eval<T>());
			return pval;
		}
	};
	template< class T >
	class subtract_operation : public binary_expr
	{
	public:
		subtract_operation(T* lhs, T* rhs) : binary_expr(literal<T>(lhs), literal<T>(rhs))
		{
		}
		subtract_operation(expr* lhs, expr* rhs) : binary_expr(lhs, rhs)
		{
		}
		T* eval()
		{
			_val = new T;
			T* pval = (T*)_val;
			*pval = *(_lhs->eval<T>()) - *(_rhs->eval<T>());
			return pval;
		}
	};

	template< class T >
	class multiply_operation : public binary_expr
	{
	public:
		multiply_operation(T* lhs, T* rhs) : binary_expr(literal<T>(lhs), literal<T>(rhs))
		{
		}
		multiply_operation(expr* lhs, expr* rhs) : binary_expr(lhs, rhs)
		{
		}
		T* eval()
		{
			_val = new T;
			T* pval = (T*)_val;
			*pval = *(_lhs->eval<T>()) * *(_rhs->eval<T>());
			return pval;
		}
	};

	template< class T >
	class divide_operation : public binary_expr
	{
	public:
		divide_operation(T* lhs, T* rhs) : binary_expr(literal<T>(lhs), literal<T>(rhs))
		{
		}
		divide_operation(expr* lhs, expr* rhs) : binary_expr(lhs, rhs)
		{
		}
		T* eval()
		{
			_val = new T;
			T* pval = (T*)_val;
			*pval = *(_lhs->eval<T>()) / *(_rhs->eval<T>());
			return pval;
		}
	};

}
#endif
