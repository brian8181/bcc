#ifndef _SYMTAB_H_
#define _SYMTAB_H_


typedef struct symbol
{
    char* id;
    char *type_modifiers;
    char *type;
    void *pval;

	struct symbol *next;
    struct symbol *prev;
} symbol;

// typedef struct binary_node
// {
//     void *data;
//     struct node *left;
//     struct node *right;
// } binary_node;

// typedef struct tree_node
// {
//     void *data;
//     int count;
//     struct tree_node *nodes;
// } tree_node;

// typedef struct map_node
// {
//     int key;
//     char *name;
//     symbol *sym;
// } map_node;

// typedef struct object
// {
//     char *fields[255];
//     symbol symbols[255];
//     node *next;
// } object;

typedef struct symbol_tab
{
    symbol *head;
    struct symbol_tab *parent;
} symbol_tab;

// get root symbol table
symbol_tab* get_root_stable();

/**
 * @brief
 * @param parent
 */
symbol_tab* new_table(symbol_tab *parent);

/**
 * @brief initialize table
 * @param s
 * @param id
 * @param type_modifiers
 * @param type
 * @param val
 */
symbol* new_symbol(const char *id, const char *type_modifiers, const char *type, const char *val);

void free_symbol(symbol_tab *stab, symbol* s);
void add_symbol(symbol_tab *stab, symbol* s);
void insert_symbol(symbol_tab *stab, const int id, symbol* s);
void remove_symbol(symbol_tab *stab, const char *id);
void dump_symbols(symbol_tab *stab);
void clear_symbols(symbol_tab *stab);
symbol *find_symbol(symbol_tab *stab, symbol* s);
symbol *find_symbol_by_id(symbol_tab *stab, const char *id);
symbol *find_symbol_by_addr(symbol_tab *stab, symbol *sym);
symbol *find_tail(symbol_tab *stab);
int size(symbol_tab *stab);

#endif
