#ifndef _SYMTAB_H_
#define _SYMTAB_H_

typedef struct symbol
{
    char* id;
    char* type_modifiers;
    char* type;
    void* pval;
} symbol;

typedef struct node
{
    symbol* sym;
    struct node* next;
    struct node* prev;
} node;

typedef struct binary_node
{
    void* data;
    struct node* left;
    struct node* right;
} binary_node;

typedef struct tree_node
{
    void* data;
    int count;
    struct tree_node* nodes;
} tree_node;


typedef struct map_node
{
    int key;
    char*name;
    symbol* sym;
} map_node;

typedef struct object
{
    char* fields[255];
    symbol symbols[255];
    node* next;
} object;

typedef struct symbol_tab
{
   node* head;
   struct symbol_tab* parent;
} symbol_tab;

// get root symbol table
symbol_tab* get_stable();
void free_node(symbol_tab* stab, node* n);
void add_symbol(symbol_tab* stab, const char* id, const char* val);
void insert_symbol(symbol_tab* stab, const char* dst_id, const char* src_id, const char* src_val);
void remove_symbol(symbol_tab* stab, const char* id);
void clear_symbols(symbol_tab* stab);
symbol* find_symbol_by_addr(symbol_tab* stab, symbol* sym);
symbol* find_symbol_by_value(symbol_tab* stab, const char* id);
symbol* find_symbol(symbol_tab* stab, const char* id);
node* find_node(symbol_tab* stab, const char* id);
node* find_tail(symbol_tab* stab);
int size(symbol_tab* stab);

#endif
