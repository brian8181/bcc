
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtab.h"

// root sym_table
static symbol_tab* tab = 0;

/**
 * @brief get symbol table
 * @return symbol_tab*
 */
symbol_tab* get_root_stable()
{
	if (tab != 0)
        return tab;
    symbol_tab* tab = new_table(0);
    symbol* streamy_init_object = new_symbol("$streamy", "static", "object", 0);
	tab->head = streamy_init_object;
    return tab;
}

/**
 * @brief new symbol table
 * @param parent
 */
symbol_tab* new_table(symbol_tab *parent)
{
    symbol_tab* tab = (symbol_tab *)malloc(sizeof(symbol_tab));
	tab->parent = parent;
	tab->head = 0;
	return tab;
}

/**
 * @brief initialize table
 * @param s
 * @param id
 * @param type_modifiers
 * @param type
 * @param val
 */
symbol* new_symbol(const char *id, const char *type_modifiers, const char *type, const char *val)
{
    symbol* s = (symbol*)malloc(sizeof(symbol));
    s->id = (char *)malloc(strlen(id) + 1);
    strcpy(s->id, id);
    s->type = (char *)malloc(strlen(type) + 1);
    strcpy(s->type_modifiers, type_modifiers);
    s->type_modifiers = (char *)malloc(strlen(type_modifiers) + 1);
    strcpy(s->type, type);
    s->pval = (char *)malloc(strlen(val) + 1);
    strcpy(s->type, type);
	s->next = 0;
	return s;
}

/**
 * @brief add symbol to tail
 * @param stab
 * @param s
 */
void add_symbol(symbol_tab* stab, symbol* s)
{
	symbol* ns = (symbol*)malloc(sizeof(symbol));
	*ns = *s;
	// add node / symbol to tail
    symbol *tail = find_tail(stab);
	tail->next = s;
	s->prev = tail;
}

/**
 * @brief insert_symbol @ id
 * @param stab
 * @param id
 * @param s
 */
void insert_symbol(symbol_tab *stab, const int id, symbol* s)
{
    // insert
    symbol* dst = find_symbol_by_id(stab, s->id);
	s->prev = dst;
	s->next = dst->next;
	s->next->prev = s;
    dst->next = s;
}

/**
 * @brief remove @ id
 * @param stab
 * @param id
 */
void remove_symbol(symbol_tab *stab, const char *id)
{
    symbol *cur = get_root_stable()->head;
    if (stab != 0)
        cur = stab->head;
    while (cur->next != 0)
    {
        symbol *s = cur->next;
        if (strcmp((char *)s->id, id))
        {
            symbol *next_next = cur->next->next;
			free(s);
            cur->next = next_next;
        }
    }
}

/**
 * @brief dump symbols
 * @param stab
 */
void dump_symbols(symbol_tab *stab)
{
    symbol *cur = get_root_stable()->head;
    if (stab != 0)
        cur = stab->head;
    while (cur != 0)
    {
        symbol *next = cur->next;
        printf("%s, %s, %s, %s", cur->id, cur->type_modifiers, cur->type, cur->pval);
        cur = next;
    }
}

/**
 * @brief delete all
 * @param stab
 */
void clear_symbols(symbol_tab *stab)
{
    symbol *cur = get_root_stable()->head;
    if (stab != 0)
        cur = stab->head;
    while (cur != 0)
    {
        symbol *next = cur->next;
		free(cur);
        cur = next;
    }
}

/**
 * @brief find by address
 * @param stab
 * @param sym
 * @return
 */
symbol *find_symbol_by_addr(symbol_tab *stab, symbol *sym)
{
    symbol *cur = get_root_stable()->head;
    if (stab != 0)
        cur = stab->head;
    while (cur->next != 0)
    {
        symbol *s = cur;
        if (s == sym)
            return s;
        cur = cur->next;
    }
    return 0;
}

/**
 * @brief find by id
 * @param stab
 * @param id
 * @return
 */
symbol *find_symbol_by_id(symbol_tab *stab, const char *id)
{
    symbol *cur = get_root_stable()->head;
    if (stab != 0)
        cur = stab->head;
    while (cur->next != 0)
    {
        symbol *s = cur;
        if (strcmp((char *)s->id, id))
            return s;
        cur = cur->next;
    }
    return 0;
}

/**
 * @brief get/find tail
 * @param stab
 * @return
 */
symbol *find_tail(symbol_tab *stab)
{
    symbol *cur = get_root_stable()->head;
    if (stab != 0)
        cur = stab->head;
    while (cur->next != 0)
    {
        cur = cur->next;
    }
    return cur;
}

/**
 * @brief get size
 * @param stab
 * @return
 */
int size(symbol_tab *stab)
{
    int k = 0;
    symbol *cur = stab->head;
    while (cur)
    {
        cur = cur->next;
        k++;
    }
    return k;
}
