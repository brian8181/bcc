#include <iostream>
#include <string>
#include <vector>
#include "find_substrs.hpp"

using std::string;
using std::vector;
using std::cout;
using std::endl;

/**
 * @name FSM : finite state machine
 */
vector<vector<int>> FSM;
void build_fsm(const string& s)
{
    const char* pstr = s.c_str();
    long max_state = 0;
    long cur_state = 0; 
    vector<int> cols(s.begin(), s.end());
    FSM = vector<vector<int>>(1, vector<int>(256, 0)); // initialize FSM with 1 state (0) and 256 possible transitions (ASCII)
}  

/**
 * @name add_substr
 * @brief build finite state machine
 * @return void
 */
void add_substr(const string& s)
{
    const char* pstr = s.c_str(); 
    long max_state = 0;
    long cur_state = 0;

    int len = s.size();
    for(int i = 0; (i < len) && (cur_state != -1); ++i)
    {
        // special case - last character of substring
        if( i == len-1 )
        {   
            cur_state = FSM[cur_state][pstr[i]] = -1; // mark end of substring with -1
        }
        else
        {
            // add to FSM
            if(FSM[cur_state][pstr[i]] == 0)
                ++max_state;
            else // record exsiting value
                cur_state = FSM[cur_state][pstr[i]];
        }
    }
}

/**
 * @name search_str
 * @brief search string (s) for sub string
 * @return int: pos of first sub string match : or -1 no match
 */
int search_str(const string& s)
{
    const char* pstr = s.c_str(); 
    // start in state 0
    long cur_state = 0;
    long start_index = 0;
    long len = s.size();

    for(int i = 0; i < len; ++i)
    {
        // starting char, state 0 
        long prev_state = cur_state;
        if(cur_state == 0)
            start_index = i;

        // follow up the states table    
        cur_state = FSM[cur_state][pstr[i]];
        
        // found match (-1), return pos of sub string
        if( cur_state == -1 )
            return start_index;

        // false lead, now backtracking
        if( prev_state != 0 && cur_state == 0)
            i = start_index;
    }
    // no matches found
    return -1;
}

int main(int argc, char* argv[])
{
    string s = "xyzabcdefg";
    build_fsm(s);
    add_substr("abc");
    add_substr("bcd");
    add_substr("cde");
    add_substr("def");

    
    int pos = search_str(s);
    if(pos != -1)
        printf("found substring at pos: %d\n", pos);
    else
        printf("no substring found\n");

    int r = s.size();
    int c = 256;
    printf("size: %d, char: %c\n", r, c);   

    // for(int i = 0; i < r; ++i)
    // {
    //     for(int j = 0; j < c; ++j)
    //     {
    //         cout << FSM[i][j] << " ";
    //     }
    //     cout << endl; 
    // }

}