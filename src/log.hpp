/**
 * @file    log.hpp
 * @version version 0.0.2
 * @date    Tue Mar 31 13:39:39 CDT 2026
 */

#ifndef LOG_HPP_
#define LOG_HPP_

#include <iostream>
#include <iomanip>
#include <sstream>
#include <vector>
#include <fstream>
#include <boost/regex.hpp>
#include "bash_color.hpp"

using std::cout;
using std::endl;
using std::stringstream;
using std::vector;

// inline std::ofstream ostrm("log.txt", std::ios::out | std::ios::trunc);
// inline std::ostream* DEFAULT_OUT_STREAM = &ostrm;
inline std::ostream *DEFAULT_OUT_STREAM = &std::cout;
inline std::stringstream STROUT;
// namespace bkp {

void log(const std::string &msg, int line_number);

#define ITALIC(str) FMT_ITALIC << str << FMT_RESET
#define UNDERLINE(str) FMT_UNDERLINE << str << FMT_RESET
#define BOLD(str) FMT_BOLD << str << FMT_RESET
#define DIM(str) FMT_DIM << str << FMT_RESET
#define HIDDEN(str) << FMT_HIDDEN << str << FMT_RESET
#define GREEN(str) FMT_FG_GREEN << str << FMT_RESET
#define RED(str) FMT_FG_RED << str << FMT_RESET
#define BLUE(str) FMT_FG_BLUE << str << FMT_RESET
#define YELLOW(str) FMT_FG_YELLOW << str << FMT_RESET
#define GREY(str) FMT_FG_DARK_GREY << str << FMT_RESET
#define CYAN(str) FMT_FG_CYAN << str << FMT_RESET
#define MAGENTA(str) FMT_FG_MAGENTA << str << FMT_RESET
#define WHITE(str) FMT_FG_WHITE << str << FMT_RESET

#define LOGV(str) cout << "LOGV: " << "\"" << str << "\"" << str <<  endl;
#define LOG(type, color, str) *DEFAULT_OUT_STREAM << std::left << std::setw(6) << type << FMT_ITALIC << color << str << FMT_RESET << "  ---> "\
                                                  << FMT_FG_DARK_GREY << "func:\"" << __func__ << "\" ~ file:\"" << __FILE__ << "\" ~ " << "line:" << __LINE__ << " ~ "\
                                                  << " ~ " << __DATE__ << ", " << __TIME__ << FMT_RESET << endl

// tracing
#ifdef TRACING
#define TRACE(str) *DEFAULT_OUT_STREAM << FMT_FG_WHITE << std::left << std::setw(6) \
									   << "[TRCE] "     << FMT_FG_LIGHT_GREY << FMT_ITALIC \
						     		   << "func:\""    << __func__ << "\" ~ file:\"" << __FILE__ << "\" ~ "\
						               << "line:"      << __LINE__ << " ~ " << __DATE__ << ", " << __TIME__ << FMT_RESET << endl
#else
#define TRACE(str) // str
#endif

#define INFO_COLOR FMT_FG_GREEN
// #ifdef SET_COLOR
// #undef INFO_COLOR
// #define SET_COLOR(c) c
// #define INFO_COLOR SET_COLOR(c)
// #endif

#ifdef TEST_ONLY
#define ATTN(str) LOG("[ATTN] ", FMT_FG_RED, str)
#else
#define ATTN(str) // str
#endif

// #ifdef PARSER_LOG
// #undef ATTN
// #define ATTN(str) LOG("ATTN: ", FMT_FG_MAGENTA, str)
// #else
// #undef ATTN
// #define ATTN(str) // str
// #endif


// debugging
#ifdef DEBUG
#define SYST(str) LOG("[SYST] ", FMT_FG_LIGHT_GREY, str)
#define INFO(str) LOG("[INFO] ", INFO_COLOR, str)
#define WARN(str) LOG("[WARN] ", FMT_FG_YELLOW, str)
#define ERROR(str) LOG("[ERROR] ", FMT_FG_RED, str)
#elif WARNINGS
#define SYST(str) LOG("[SYST] ", FMT_FG_LIGHT_GREY, str)
#define INFO(str) // str
#define WARN(str) LOG("[WARN] ", FMT_FG_YELLOW, str)
#define ERROR(str) LOG("[ERROR] ", FMT_FG_RED, str)
#else
#define SYST(str) LOG("[SYST] ", FMT_FG_LIGHT_GREY, str)
#define INFO(str) // str
#define WARN(str) // str
#define ERROR(str) LOG("[ERROR] ", FMT_FG_RED, str)
#endif

//}

#endif
