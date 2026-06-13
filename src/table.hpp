#ifndef __THE_TABLE_
#define __THE_TABLE_

#include <map>

#ifdef VER2
#include "parser.tab.hpp"
#include "def2.hpp"
#else
#include "pparser.tab.hpp"
#include "def1.hpp"
#endif


constexpr const unsigned long eINT   = 0x10;
constexpr const unsigned long eFLOAT = 0x20;
constexpr const unsigned long eCHAR  = 0x40;
constexpr const unsigned long eVOID  = 0x80;
constexpr const unsigned long eFUNC   = 0x100;
constexpr const unsigned long eVAR    =  0x200;
constexpr const unsigned long eARRAY  = 0x400;
constexpr const unsigned long ePTR    = 0x800;
constexpr const unsigned long eSTRING  = 0x1000;
constexpr const unsigned long eVOID_PTR_FUNC = eVOID | ePTR | eFUNC;

typedef struct sym_t
{
	string name;
	string stype;
	unsigned long type;
	void* val;

	 // declare the operator as a friend to access private members
    friend std::ostream& operator<<(std::ostream& os, const sym_t& lex);
} sym_t;

typedef map<string, sym_t> symbol_table_t;

class scope 
{
public:
	scope() {}
	scope(scope* parent) {};
	scope(const scope& s) {};
	~scope() {};

	symbol_table_t symtab;

	scope& operator=(const scope&) {};
	sym_t operator[](const string& item) {};
	sym_t operator[](int idx) {};

private:
	scope* parent;
	vector<scope*> scopes;
};

scope g_scope((scope*)0);
// _symbol_t s = {"x","int", eINT, 0};
// //g_scope.symtab["name"] = s;
map<string, sym_t> _symtab = {{"x", {"x","int", eINT, 0}}, {"y", {"y", "int", eINT, 0}}, {"z", {"z", "int", eINT, 0}}};

#endif
