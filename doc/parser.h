#define MAX NAME 32 /* Maximum length of a terminal or nonterminal name
#define MAXPROD 512 /* Maximum number of productions in the input grammar
#define
#define
#define
#define
#define
#define
#define
#define
#define
MINTERM
MINNONTERM
MINACT
MAX TERM
MAXNONTERM
NUMTERMS
NUMNONTERMS
USED TERMS
                     1 /* Token values assigned to terminals start here *I
                     256 /* nonterminals start here *I
                     512 /* acts start here *I
                     /* Maximum numeric values used for terminals
                     * and nonterminals (MAXTERM and MINTERM), as
                     * well as the maximum number of terminals and
                     * nonterminals (NUMTERMS and NUMNONTERMS).
                     (MINNONTERM
                     (MINACT
                     * Finally, USED_TERMS and USED_NONTERMS are
                     * the number of these actually in use (i.e.
                     * were declared in the input file).
                     *I
                     -2)
                     -1)
                     ((MAXTERM-MINTERM) +1)
                     ((MAXNONTERM-MINNONTERM)+1)
                     ( (Cur_term - MINTERM) +1)
                     USED NONTERMS ((Cur nonterm - MINNONTERM) +1)
                     277
                     *I
                     *I
                     
                     /* These macros evaluate to true if x represents
                     * a terminal (ISTERM), nonterminal (ISNONTERM)
                     #define ISTERM(x)
                     #define ISNONTERM(x)
                     #define ISACT(x)
                     * or action (ISACT)
                     *I
                     ((x) && (MINTERM <= (x)->va1 && (x)->val <= MAXTERM ))
                     ((x) && (MINNONTERM <= (x)->val && (x)->val <= MAXNONTERM))
                     ((x) && (MINACT <= (x)->val ))
                     /* Epsilon's value is one more than the largest
                     * terminal actually used. We can get away with
                     * this only because EPSILON is not used until
                     * after all the terminals have been entered
                     * into the symbol table.
                     *I
                     #define EPSILON (Cur_term+1)
                     /* The following macros are used to adjust the
                     * nonterminal values so that the smallest
                     * nonterminal is zero. (You need to do this
                     *when you output the tables,. ADJ_VAL does
                     * the adjustment, UNADJ VAL translates the