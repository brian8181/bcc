#ifndef __THE_TABLE_
#define __THE_TABLE_
#include <set>
#include <map>
#include "definitions.hpp"

using std::set;
using std::map;

constexpr const unsigned long eINT   = 0x10;
constexpr const unsigned long eFLOAT = 0x20;
constexpr const unsigned long eCHAR  = 0x40;
constexpr const unsigned long eVOID  = 0x80;

// enum type_t
// {
// 	eINT   = 0x10,
// 	eFLOAT = 0x20,
// 	eCHAR  = 0x40,
// 	eVOID  = 0x80
// };

// struct id_t
// {
// 	string name;
// 	etype id;
// } typedef id_t;

// id_t _types[4] = 
// {
// 	{"int", eINT},
// 	{"float", eFLOAT},
// 	{"char", eCHAR},
// 	{"void", eVOID}
// }

typedef struct _symbol_t
{
	string name;
	string stype;
	int type;
	void* val;

	 // Declare the operator as a friend to access private members
    friend std::ostream& operator<<(std::ostream& os, const _symbol_t& lex);
} _symbol_t;

map<string, _symbol_t> _symtab = {{"x", {"x","int", eINT, 0}}, {"y", {"y", "int", eINT, 0}}, {"z", {"z", "int", eINT, 0}}};

typedef map<string, string> symbol_table_t;

// test
symbol_table_t symbol_table { {"global", "empty"} };

// typedef set<unsigned long> squence_t;
// sequence_t assign_numric_literal = {OPEN_BRACE, EQUALS, NUMERIC_LITERAL, CLOSE_BRACE};

#endif
