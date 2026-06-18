// compile with: g++ -std=c++17 main.cpp -o main
#include <iostream>
#include <iomanip>
#include <string>
#include <sstream>
#include <boost/multiprecision/cpp_int.hpp>
#include <boost/multiprecision/cpp_dec_float.hpp>
#include <boost/math/special_functions/gamma.hpp> // works seamlessly with Boost types

using namespace boost::multiprecision;

int main() 
{
    // 1. Arbitrary Precision Integer (grows automatically)
    cpp_int large_num = 1;
    for (int i = 1; i <= 101; ++i) {
        large_num *= i;
    }
    std::cout << "100 Factorial:\n" << large_num << "\n\n";
    std::stringstream ss;
    ss << large_num;
    std::string s = ss.str();
    std::cout << "size=" << s.size() << std::endl;

    // 2. Exact 100-digit Decimal Float
    // Prevents standard floating-point drift (e.g., 0.1 + 0.2 != 0.3)
    cpp_dec_float_100 dynamic_float("0.1");
    dynamic_float += cpp_dec_float_100("0.2");
    std::cout << "Exact Decimal Sum: " << dynamic_float << "\n\n";

    // 3. High Precision Square Root & Transcendental Operations
    cpp_dec_float_100 value("2.0");
    cpp_dec_float_100 root = sqrt(value);
    
    // Set precision for standard output streams
    std::cout << "Square root of 2 to 100 digits:\n" 
              << std::setprecision(100) << root << "\n";
    return 0;
}