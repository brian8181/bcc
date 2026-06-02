#include <iostream>
#include "variant.hpp"

int main(int argc, char* argv[])
{
    variant v;
    v.ptr = new unsigned long(42);

    long* l1 = (long*)v.ptr;
    long l2 = (long)v.ptr;
    long l3 = (long)v.long_;

    std::cout << "*l1=" << *l1 << " *l2=" << *((long*)l2) << " *l3=" << *((long*)l3)  << endl;
    
    //v.long_ = 69;
    std:: cout << "long="  << v.long_ << ", getval=" << v.val() << endl;
    std::cout << "*l1=" << *l1 << " *l2=" << *((long*)l2) << " *l3=" << *((long*)l3)  << endl;

    int n = 42;
    variant v("x", n);
    
    return 0;

}