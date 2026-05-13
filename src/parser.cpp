/**
 * @file    parser.hpp
 * @version 0.0.1
 * @date    Sat, 04 Apr 2026 12:59:28 +0000
 */
#include <iostream>
#include <set>
#include <map>
#include "parser.hpp"

using std::string;
using std::cout;
using std::endl;
using std::map;

namespace ast
{
	struct node
	{
		string stype;
		node* parent;
		node* left;
		node* right;
		void* val;
	};


		// struct seq
		// {
		// 	seq* next[];
		// 	seq* parent;
		// };


	struct seq
	{
		int id;
		string name;
		std::map< int, seq > next;
		seq& operator[] (int id)
		{
			return next[id];
		}
	};

	void init()
	{
		seq s;
		s.id;
		s[OPEN_BRACE][SYMBOL][EQUALS][NUMERIC_LITERAL][CLOSE_BRACE];
		s[OPEN_BRACE][SYMBOL][EQUALS][STRING_LITERAL][CLOSE_BRACE];
		s[OPEN_BRACE][SYMBOL][EQUALS][SYMBOL][CLOSE_BRACE];
		// branch* b1 = b->next[OPEN_BRACE]->next[SYMBOL]->next[EQUALS];
		// b->next[VALUE_ATTRIB]->next[SYMBOL];
		// 																b1->next[NUMERIC_LITERAL]->next[CLOSE_BRACE];
		// 																b1->next[STRING_LITERAL]->next[CLOSE_BRACE;]
		// 																b1->next[SYMBOL]->next[CLOSE_BRACE];

		//n->next[EQUALS] = new branch;

	}

}


typedef vector<string> rule;
vector<rule> rules {
		{ "OPEN_BRACE", "SYMBOL", "EQUALS", "SYMBOL", "CLOSE_BRACE" },
        { "OPEN_BRACE", "SYMBOL", "EQUALS", "STRING_LITERAL", "CLOSE_BRACE" },
		{ "OPEN_BRACE", "SYMBOL", "EQUALS", "NUMERIC_LITERAL", "CLOSE_BRACE" },
		{ "OPEN_BRACE", "SYMBOL", "EQUALS", "expr", "CLOSE_BRACE" },
		{ "VALUE_ATTRIB", "EQUAL_SIGN", "STRING_LITERAL" },
		{ "VALUE_ATTRIB", "EQUAL_SIGN", "NUMERIC_LITERAL" },
		{ "VALUE_ATTRIB", "EQUAL_SIGN", "SYMBOL" },
		{ "FILE_ATTRIB", "EQUAL_SIGN", "STRING_LITERAL" },
		{ "FILE_ATTRIB", "EQUAL_SIGN", "NUMERIC_LITERAL" },
		{ "FILE_ATTRIB", "EQUAL_SIGN", "SYMBOL" },
		{ "VAR_ATTRIB", "EQUAL_SIGN", "STRING_LITERAL" },
		{ "VAR_ATTRIB", "EQUAL_SIGN", "NUMERIC_LITERAL" },
		{ "VAR_ATTRIB", "EQUAL_SIGN", "SYMBOL" },
		{ "NAME_ATTRIB", "EQUAL_SIGN", "STRING_LITERAL" },
		{ "NAME_ATTRIB", "EQUAL_SIGN", "NUMERIC_LITERAL" },
		{ "NAME_ATTRIB", "EQUAL_SIGN", "SYMBOL" },
		{ "ASSIGN_ATTRIB", "EQUAL_SIGN", "STRING_LITERAL" },
		{ "ASSIGN_ATTRIB", "EQUAL_SIGN", "NUMERIC_LITERAL" },
		{ "ASSIGN_ATTRIB", "EQUAL_SIGN", "SYMBOL" }
	};

/**
 *
 */
bkp::parser::parser(context *ct, const string &file) : m_context(ct), m_file(file)
{
    read_str(m_file, m_input, std::ios::in);
	rules.push_back(SYMBOL);
}

/**
 * @name parse
 * @return void
 */
void bkp::parser::parse()
{
	string n = g_tokens[TILDE].name;
	// cout << "TESTING123 ....   " << g_tokens[WHITESPACE].name << endl;
	// constexpr std::string_view data { "ABCDEF" };
}
