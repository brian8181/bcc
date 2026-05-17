#ifndef __THE_TABLE_
#define __THE_TABLE_
#include <set>
#include "definitions.hpp"

using std::set;

enum stype
{
	eINT,
	eFLOAT,
	eCHAR
};

typedef struct __symbol
{
	string name;
	string stype;
	int type;
	void* val;
} __symbol;

typedef map<string, __symbol> __symbol_table;
typedef map<string, string> symbol_table_t;
typedef map<string, void*> object_table_t;

// __symbol __s = {"test", 0, 0};
// __symbol_table tab = { {"x", {"x","int", 0, 0}}, {"y", {"y", "int", 0, 0}}, {"z", {"z", "int", 0, 0}} };


// test
symbol_table_t symbol_table { {"global", "empty"} };

typedef set<unsigned long> squence_t;
sequence_t assign_numric_literal = {OPEN_BRACE, EQUALS, NUMERIC_LITERAL, CLOSE_BRACE};

#endif
