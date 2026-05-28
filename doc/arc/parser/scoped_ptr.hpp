/**
 * @file scoped_ptr.hpp
 * @version 0.0.1
 * @date Wed May 13 05:15:16 PM CDT 2026
 * @brief scoped pointer implementation with reference counting.
 */

#ifndef _SCOPED_PTR_HPP__
#define _SCOPED_PTR_HPP__

#include <iostream>
#include <string>


/**
 * @brief smart pointer class with reference counting
 * @param T type of the managed object
 */
template <class T>
class scoped_ptr
{
public:
    /**
     * @brief default constructor
     */
    scoped_ptr() : data_ptr(new T())
    {
    }

    /**
     * @brief construct from value via copy ctor
     * @param const T& val : value to copy
     */
    scoped_ptr(const T &val) : data_ptr(new T(val))
    {
#if TRACE_
        std::cout << " @-> " << std::hex << data_ptr << " ctor: allocated ..." << std::endl;
#endif
    }

    /**
     * @brief construct from pointer
     * @param const T* ptr : if ptr not null : value of ptr is copied via copy
     * ctor : otherwise default ctor T()
     */
    scoped_ptr(T *ptr) 
    {
        if (ptr != 0)
        {
            data_ptr = *ptr;
        }
        else
        {
            data_ptr = new T();
        }
#if TRACE_
        std::cout << " @-> " << std::hex << data_ptr << " ctor: allocated ..." << std::endl;
#endif
    }

//     /**
//      * @brief copy constructor
//      * @param const scoped_ptr<T>& ptr : scoped_ptr to copy
//      */
//     scoped_ptr(const scoped_ptr<T> &ptr)
//     {
//         data_ptr = ptr.data_ptr;
// #if TRACE_
//         std::cout << " @-> " << std::hex << data_ptr << " copy ctor: ..." << std::endl;
// #endif
//     }

//     /**
//      * @brief move constructor
//      * @param const scoped_ptr<T>& ptr : another scoped_ptr to move from
//      */
//     scoped_ptr(scoped_ptr<T> &&ptr) noexcept : data_ptr(std::move(ptr.data_ptr))
//     {
// #if TRACE_
//         std::cout << " @-> " << std::hex << data_ptr << " copy ctor: ..." << std::endl;
// #endif
//     }

    /**
     * @brief destructor
     */
    ~scoped_ptr()
    {
        dalloc();
    }

    /**
     * @brief assignment operator
     * @param const scoped_ptr<T>& ptr : other scoped_ptr
     * @return reference to this scoped_ptr
     */
    scoped_ptr<T> &operator=(const scoped_ptr<T> &ptr)
    {
        if (&ptr != this)
            alloc(ptr);
        return *this;
    }

    /**
     * @brief dereference operator
     * @return reference to managed object
     */
    T &operator*()
    {
        return *data_ptr;
    }

    /**
     * @brief address of operator
     * @return address of this internal pointer
     */
    T **operator&()
    {
        if (data_ptr != 0)
            return &data_ptr;
        return 0;
    }

    /**
     * @brief indirect selection operator
     * @return pointer to managed object
     */
    T *operator->()
    {
        return data_ptr;
    }

    /**
     * @brief set value
     * @param const T& val
     */
    void set_val(const T &val)
    {
        *data_ptr = val;
    }

    /**
     * @brief get value
     * @return reference to value
     */
    T &get_val()
    {
        return *data_ptr;
    }

    /**
     * @brief allocate and add reference count
     * @param ap another scoped_ptr
     * @return reference to scoped_ptr
     */
    scoped_ptr<T> &alloc(scoped_ptr<T> &ptr)
    {
        ptr.dalloc();
        ptr.data_ptr = data_ptr;
#if TRACE_
        std::cout << " @-> " << std::hex << data_ptr << " allocated  ..." << std::endl;
#endif
        return ptr;
    }

    /**
     * @brief deallocate and remove reference count
     */
    void dalloc()
    {
        if (data_ptr != 0)
        {
            delete data_ptr;
#if TRACE_
                std::cout << " @-> " << std::hex << data_ptr << " deallocate: deleted ..." << std::endl;
#endif
        }
    }

private:
   
    /**
     * @brief pointer to managed object
     */
    T *data_ptr = 0;
};

#endif
