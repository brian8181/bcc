#ifndef __THE_TABLE_
#define __THE_TABLE_
#include <set>
#include <map>
#include "definitions.hpp"

using std::set;
using std::map;

enum stype
{
	eINT,
	eFLOAT,
	eCHAR,
	eVOID
};

typedef struct _symbol
{
	string name;
	string stype;
	int type;
	void* val;
} _symbol;

map<string, _symbol> _symtab = {{"x", {"x","int", eINT, 0}}, {"y", {"y", "int", eINT, 0}}, {"z", {"z", "int", eINT, 0}}};

typedef map<string, string> symbol_table_t;
typedef map<string, void*> object_table_t;

// test
symbol_table_t symbol_table { {"global", "empty"} };

// typedef set<unsigned long> squence_t;
// sequence_t assign_numric_literal = {OPEN_BRACE, EQUALS, NUMERIC_LITERAL, CLOSE_BRACE};

#endif
