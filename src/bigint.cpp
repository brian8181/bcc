/**
 * @file    bigint.hpp
 * @version 0.0.1
 * @date    Thu, 21 May 2026 08:36:45 +0000
 */
#include "bigint.hpp"

bigint::bigint(unsigned long n) : count(n), pdigits( new unsigned long[n] )
{
}
