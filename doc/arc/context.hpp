//
// Created by brian on 4/5/2026.
//

#ifndef CONTEXT_HPP
#define CONTEXT_HPP

#include <string>
#include <iostream>
#include <iomanip>
#include <sstream>
#include <list>

#include "fileio.hpp"
#include "lexer.hpp"

using std::cout;
using std::endl;

// typedef struct context_t
// {
// 	string regex_str;
// 	string search;
// 	string match;
// 	string prefix;
// 	string suffix;
// 	long pos;
// 	string buffer;
// 	boost::regex rexp;
// 	boost::sregex_iterator iter;
// 	boost::sregex_iterator end;
// 	boost::smatch* p_smatch;
// } context_t;
// context_t* p_context;

class context
{
public:
    context(const string &p)
        : state(INITIAL), path(p), beg(nullptr), end(nullptr), pos(nullptr),
          match_beg(nullptr), match_len(0), len(0), buffer(nullptr)
    {
    }

    context(const context &cp)
        : state(cp.state), path(cp.path), beg(cp.beg), end(cp.end), pos(cp.pos),
          match_beg(cp.match_beg), match_len(cp.match_len), len(cp.len), buffer(cp.buffer)
    {
        path = cp.path;
        beg = cp.beg;
        pos = cp.pos;
        end = cp.end;
        match_beg = cp.beg;
        match_len = cp.match_len;
        len = cp.len;
        state.id = cp.state.id;
        state.name = cp.state.name;
    }

    bool init()
    {
        len = file_size(path);
        buffer = new unsigned char[len + 1];
        int read = read_buf(path, buffer, len);
        if (read != len)
        {
            delete[] buffer;
            buffer = nullptr;
            len = 0;
            return false;
        }

        buffer[len] = '\0';
        beg = buffer;
        pos = beg;
        end = &buffer[len];
        return true;
    }

    void set_match_pos(int offset)
    {
        match_beg = pos; // move pos
        match_len = offset;
        pos += offset; // move pos
    }

    void replace_match(const string &replacement)
    {
        if (match_beg && match_len > 0)
        {
        }
    }

    void log()
    {

        cout << std::hex << "0x" << beg << " " << " : 0x" << pos << " : 0x" << end << " : 0x"
             << match_beg << " : " << std::dec << match_len << " : 0x" << std::hex /*pbuffer */ << " : " << std::dec << endl;
        stringstream ss;
        ss << "pos:" << (long)(pos - beg) << " ~ match_beg:" << (long)(match_beg - beg) << " ~ match_len:" << match_len << " ~ size:" << len;
        // INFO(ss.str());
    }

    state_t state;            // current lex state
    string path;              // input file path
    unsigned char *beg;       // beg of search text
    unsigned char *end;       // end of search text / beg +
    unsigned char *pos;       // search position / match_beg + match_len
    long len;                 // length of search text
    unsigned char *match_beg; // beg of match
    long match_len;           // length of match
    unsigned char *buffer;    // search text / same value as beg

    std::ostringstream output;
    std::ostringstream debug;
    // list<token_match> matches;
};

#endif // CONTEXT_HPP
