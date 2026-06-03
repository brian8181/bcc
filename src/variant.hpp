/**
 * @file    variant.hpp
 * @version 0.0.1
 * @date    Thu, Oct 30, 2025  4:59:12 PM
 */

#ifndef _variant_HPP_
#define _variant_HPP_

#include <iostream>
#include <string>

using std::cout;
using std::endl;
using std::string;

#define VOID      0x000001
#define INT       0x001000
#define CHAR      0x002000
#define FLOAT     0x004000
#define SHORT     0x008000
#define LONG      0x010000
#define DOUBLE    0x040000
#define SIGNED    0x080000
#define UNSIGNED  0x100000
#define PTR       0x200000
#define STRUCT    0x400000
#define UINT_PTR UNSIGNED | INT | PTR
#define ULONG_PTR UNSIGNED | LONG | INT | PTR
#define ULONG_PTR UNSIGNED | LONG | INT | PTR

class variant
{
    string _name;
    int _size;
    unsigned long _type;

public:
    variant() {};

    variant(  const string& name, int size, unsigned long type ) : _name(name), _size(size), _type(type) {}

    variant( const string& name, short val ) : _name(name), _type(SHORT) 
    {
        ptr = new short(val);
    }

    variant( int val ) : _name("tmp"), _type(INT) 
    {
        ptr = new int(val);
    }

    variant( long val ) : _name("tmp"), _type(LONG) 
    {
        ptr = new long(val);
    }

    variant(  unsigned int val ) : _name("tmp"), _type(UNSIGNED | INT) 
    {
        ptr = new unsigned int(val);
    }

    variant(  unsigned short val ) : _name("tmp"), _type(UNSIGNED | SHORT) 
    {
        ptr = new unsigned short(val);
    }

   variant( char val ) : _name("tmp"), _type(CHAR) 
    {
        ptr = new char(val);
    }

    variant( unsigned char val ) : _name("tmp"), _type(UNSIGNED | CHAR) 
    {
        ptr = new unsigned char(val);
    }

    variant( float val ) : _name("tmp"), _type(FLOAT) 
    {
        ptr = new float(val);
    }

    variant( double val ) : _name("tmp"), _type(DOUBLE) 
    {
        ptr = new double(val);
    }

    explicit operator int() const
    {
        return *int_ptr;
    }

    explicit operator unsigned int() const
    {
        return *uint_ptr;
    }

    explicit operator short() const
    {
        return *short_ptr;
    }

    explicit operator long() const
    {
        return *long_ptr;
    }

    explicit operator float() const
    {
        return *float_ptr;
    }
    
    explicit operator double() const
    {
        return *double_ptr;
    }
    
    explicit operator char() const
    {
        return *char_ptr;
    }

    explicit operator unsigned char() const
    {
        return *uchar_ptr;
    }

    union
    {
        char             char_;
        char*            char_ptr;
        short            short_;
        short*           short_ptr;
        int              int_;
        int*             int_ptr;
        long             long_;
        long*            long_ptr;
        unsigned char    uchar_;
        unsigned char*   uchar_ptr;
        unsigned short   ushort_;
        unsigned short*  ushort_ptr;
        unsigned int     uint_;
        unsigned int*    uint_ptr;
        float            float_;
        float*           float_ptr;
        double           double_;
        double*          double_ptr;
        void* ptr;

    };
    
    long val()
    {
        return *(long*)ptr;
    }

};

#endif