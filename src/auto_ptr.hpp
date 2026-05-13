/**
 * @file auto_ptr.hpp
 * @version 0.0.1
 * @date Tue Apr  1 10:09:38 CDT 2025
 * @brief Smart pointer implementation with reference counting.
 */

#ifndef _AUTO_PTR_HPP__
#define _AUTO_PTR_HPP__

#include <iostream>
#include <string>
#include <utility>

/**
 * @brief smart pointer class with reference counting
 * @param T type of the managed object
 */
template <class T>
class auto_ptr
{
public:
    /**
     * @brief default constructor
     */
    auto_ptr() : ref_count_ptr(new long(1)), data_ptr(new T())
    {
    }

    /**
     * @brief construct from value via copy ctor
     * @param const T& val : value to copy
     */
    auto_ptr(const T &val) : ref_count_ptr(new long(1)), data_ptr(new T(val))
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
    auto_ptr(const T *ptr) : ref_count_ptr(new long(1))
    {
        if (ptr != 0)
        {
            data_ptr = new T(*ptr);
            ref_count_ptr = new long(1);
        }
        else
        {
            data_ptr = new T();
            ref_count_ptr = new long(1);
        }
#if TRACE_
        std::cout << " @-> " << std::hex << data_ptr << " ctor: allocated ..." << std::endl;
#endif
    }

    /**
     * @brief copy constructor
     * @param const auto_ptr<T>& ptr : auto_ptr to copy
     */
    auto_ptr(const auto_ptr<T> &ptr)
    {
        ref_count_ptr = ptr.ref_count_ptr;
        data_ptr = ptr.data_ptr;
        ++(*ref_count_ptr);
#if TRACE_
        std::cout << " @-> " << std::hex << data_ptr << " copy ctor: refed ..." << std::endl;
#endif
    }

    /**
     * @brief move constructor
     * @param const auto_ptr<T>& ptr : another auto_ptr to move from
     */
    auto_ptr(auto_ptr<T> &&ptr) noexcept : ref_count_ptr(std::move(ptr.ref_count_ptr)), data_ptr(std::move(ptr.data_ptr))
    {
#if TRACE_
        std::cout << " @-> " << std::hex << data_ptr << " copy ctor: refed ..." << std::endl;
#endif
    }

    /**
     * @brief destructor
     */
    ~auto_ptr()
    {
        dalloc();
    }

    /**
     * @brief get reference of an auto_ptr
     * @param const auto_ptr<T>& ptr : an auto_ptr
     * @return reference to an auto_ptr
     */
    auto_ptr<T> &get_ref(auto_ptr<T> &ptr)
    {
        alloc(ptr);
        return ptr;
    }

    /**
     * @brief get reference this auto_ptr
     * @return reference to auto_ptr
     */
    auto_ptr<T> &get_ref()
    {
        return *this;
    }

    /**
     * @brief assignment operator
     * @param const auto_ptr<T>& ptr : other auto_ptr
     * @return reference to this auto_ptr
     */
    auto_ptr<T> &operator=(const auto_ptr<T> &ptr)
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
     * @brief get reference count
     * @return reference count
     */
    long get_ref_count()
    {
        return *ref_count_ptr;
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
     * @param ap another auto_ptr
     * @return reference to auto_ptr
     */
    auto_ptr<T> &alloc(auto_ptr<T> &ptr)
    {
#if TRACE_
        std::cout << " @-> " << std::hex << data_ptr << " ptr.dalloc ..." << std::endl;
#endif
        ptr.dalloc();
        ptr.data_ptr = data_ptr;
        ptr.ref_count_ptr = ref_count_ptr;
        ++(*ref_count_ptr);
#if TRACE_
        std::cout << " @-> " << std::hex << data_ptr << " allocated / ref incremented ..." << std::endl;
#endif
        return ptr;
    }

    /**
     * @brief deallocate and remove reference count
     */
    void dalloc()
    {
#if TRACE_
        std::cout << " @-> " << std::hex << data_ptr << " deallocate: ... " << std::endl;
#endif
        if (data_ptr != 0)
        {
            --(*ref_count_ptr);
#if TRACE_
            std::cout << " @-> " << std::hex << data_ptr << " deallocate ref decremented ... " << std::endl;
#endif
            if (*ref_count_ptr == 0)
            {
                delete ref_count_ptr;
                delete data_ptr;
#if TRACE_
                std::cout << " @-> " << std::hex << data_ptr << " deallocate: deleted ..." << std::endl;
#endif
            }
        }
    }

private:
    /**
     * @brief reference count pointer
     */
    long *ref_count_ptr = 0;
    /**
     * @brief pointer to managed object
     */
    T *data_ptr = 0;
};

#endif
