
#define STRING                   0x10000
#define SHORT               	 0x20000
#define INT					     0x40000
#define LONG					 0x80000
#define SINGLE              	 0x100000
#define FLOAT					 0x200000
#define DOUBLE				     0x400000
#define CHAR					 0x8000000
#define VOID                	 0x10000000
#define UNSIGNED				 0x20000000
#define SIGNED				     0x40000000
#define CONST                    0x80000000
#define STATIC					 0x200000000
#define REGISTER				 0x400000000
#define PTR						 0x800000000
#define VOLATILE				 0x1000000000
#define STRUCT                   0x2000000000

#define TOK(n, r) token(n, #n, S_TYPE, R(""r""), __LINE__ )
#define BEG_STATE(s) inline state_t s = {
#define END_STATE() }


CONST
STATIC
REGISTER
PTR
VOLATILE
STRUCT

BEG_STATE(PARSER)
END_STATE()

TOK(TEST1, .*)
