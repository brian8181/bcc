#include <iostream>
#include "variant.hpp"
#include "utility.hpp"

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

    int n = 666;
    variant v2("x", n);

    cout << "n=" << (int)v2 << endl;

    char c = 'A';
    char unsigned uc = 21;
    int i = 22;
    unsigned int ui = 55;
    long l = -77;
    float f = -3.14;
    double d = 0.707;

    variant vc(c);
    variant vuc(uc);
    variant vi(i);
    variant vui(ui);
    variant vl(l);
    variant vf(f);
    variant vd(d);

    cout << (char)vc           << endl 
         << (unsigned char)vuc << endl 
         << (int)vi            << endl 
         << (unsigned int)vui  << endl 
         << (long)vl           << endl
         << (float)vf          << endl 
         << (double)vd         << endl;
    

    variant vc2('A');
    variant vuc2(21);
    variant vi2(22);
    variant vui2(55);
    variant vl2(-77);
    variant vf2(-3.14);
    variant vd2(0.707);

    cout << (char)vc2           << endl 
         << (unsigned char)vuc2 << endl 
         << (int)vi2            << endl 
         << (unsigned int)vui2  << endl 
         << (long)vl2           << endl
         << (float)vf2          << endl 
         << (double)vd2         << endl;

    cout << META_FACTORIAL<5>::RET << endl; 
    
    return 0;

}