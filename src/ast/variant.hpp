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
#define LONG_PTR UNSIGNED | LONG | INT | PTR
#define USHORT_PTR UNSIGNED | UNSIGNED | SHORT | INT | PTR

/// @brief 
class variant
{
    string _name;
    int _size;
    unsigned long _type;

public:
    /// @brief 
    variant() {};
    
    // Copy Constructor (Required for Copy-and-Swap)
    variant(const variant& other) //: size(other.size), data(new int[other.size]) 
    {
        //std::copy(other.data, other.data + other.size, data);
    }

    // Friend swap function
    friend void swap(variant& first, variant& second) noexcept 
    {
        using std::swap;
        //swap(first.data, second.data);
        //swap(first.size, second.size);
    }

    // Overloaded Assignment Operator (=)
    // Pass by value to automatically create a temporary copy
    variant& operator=(variant other) 
    {
        //swap(*this, other); // Swap details with the temporary copy
        return *this;       // Return a reference to allow chaining (a = b = c)
    }

    variant(  const string& name, int size, unsigned long type ) : _name(name), _size(size), _type(type) {}

    /// @brief 
    /// @param name 
    /// @param val 
    variant( const string& name, short val ) : _name(name), _type(SHORT) 
    {
        ptr = new short(val);
    }

    /// @brief 
    /// @param val 
    variant( int val ) : _name("tmp"), _type(INT) 
    {
        ptr = new int(val);
    }

    /// @brief 
    /// @param val 
    variant( long val ) : _name("tmp"), _type(LONG) 
    {
        ptr = new long(val);
    }

    variant(  unsigned int val ) : _name("tmp"), _type(UNSIGNED | INT) 
    {
        ptr = new unsigned int(val);
    }

    /// @brief 
    /// @param val 
    variant(  unsigned short val ) : _name("tmp"), _type(UNSIGNED | SHORT) 
    {
        ptr = new unsigned short(val);
    }

   /// @brief 
   /// @param val 
    variant( char val ) : _name("tmp"), _type(CHAR) 
    {
        ptr = new char(val);
    }

    /// @brief 
    /// @param val 
    variant( unsigned char val ) : _name("tmp"), _type(UNSIGNED | CHAR) 
    {
        ptr = new unsigned char(val);
    }

    /// @brief 
    /// @param val 
    variant( float val ) : _name("tmp"), _type(FLOAT) 
    {
        ptr = new float(val);
    }

    /// @brief 
    /// @param val 
    variant( double val ) : _name("tmp"), _type(DOUBLE) 
    {
        ptr = new double(val);
    }

    /// @brief 
    explicit operator int() const
    {
        return *int_ptr;
    }

    /// @brief 
    explicit operator unsigned int() const
    {
        return *uint_ptr;
    }

    /// @brief 
    explicit operator short() const
    {
        return *short_ptr;
    }

    /// @brief 
    explicit operator long() const
    {
        return *long_ptr;
    }

    /// @brief 
    explicit operator float() const
    {
        return *float_ptr;
    }
    
    /// @brief 
    explicit operator double() const
    {
        return *double_ptr;
    }
    
    /// @brief 
    explicit operator char() const
    {
        return *char_ptr;
    }

    /// @brief 
    explicit operator unsigned char() const
    {
        return *uchar_ptr;
    }

    /// @brief 
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
    
    /// @brief 
    /// @return 
    long val()
    {
        return *(long*)ptr;
    }

};

#endif