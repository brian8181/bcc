/**
 * @file    parser.hpp
 * @version 0.0.1
 * @date    Sat, 04 Apr 2026 12:59:28 +0000
 * @info    ...
 */
#ifndef parser_HPP_
#define parser_HPP_
#include <iostream>
#include <string>
#include <string_view>
#include <list>
#include <vector>
#include <deque>
#include "context.hpp"
//#include "tokens.hpp"

namespace bkp
{
	/**
	 * @brief class parser
	 */
	class parser
	{
	public:
		/**
		 * @brief : ctor
		 */
		parser(context* ct, const string& file);

		/**
		 * @brief : copy ctor
		 */
		parser(const parser &src) = default;

		/**
		 * @brief : destructor
		 */
		~parser() = default;

		void parse();

	private:
		string m_file;
		string m_input;
		context *m_context;
		//std::list<std::string_view> rules;
		std::deque<unsigned long> rules;
	};
}
#endif
