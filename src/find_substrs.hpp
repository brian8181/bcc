#ifndef __FIND_SUBSTRS__
#define __FIND_SUBSTRS__

#include <string>
#include <vector>

using std::string;
using std::vector;

/**
 * @name FSM : finite state machine
 */
vector<vector<int>> FSM;

/**
 * @name build_fsm 
 */
void build_fsm();

/**
 * @name add_substr
 * @brief build finite state machine
 * @return void
 */
void add_substr(const string& s);

/**
 * @name search_str
 * @brief search string (s) for sub string
 * @return int: pos of first sub string match : or -1 no match
 */
int search_str(const string& s);



#endif // __FIND_SUBSTRS__