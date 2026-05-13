#include <iostream>
#include <string>
#include "auto_ptr.hpp"

typedef auto_ptr<int> int_ptr;
typedef auto_ptr<std::string> string_ptr;
typedef auto_ptr<char> auto_ptr_char;
typedef auto_ptr<std::pair<int, std::string>> auto_ptr_pair;
