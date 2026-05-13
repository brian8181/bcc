
#include <iostream>
#include <string>
#include "log.hpp"
#include "bash_color.hpp"

using std::cout;
using std::endl;
using std::string;

void log(const string &msg, const int line_number)
{
	cout << FMT_FG_RED << "LOG INFO: " << FMT_RESET << msg << FMT_ITALIC << FMT_FG_BLUE
		 << " [line: " << line_number << "] - "
		 << FMT_FG_LIGHT_GREY << __TIMESTAMP__ << FMT_RESET << endl;
}
