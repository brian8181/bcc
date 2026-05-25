/**
 * @file    toggle.hpp
 * @version 0.0.1
 * @date    Sun, 24 May 2026 19:06:31 +0000
 */
#include <iostream>
#include "toggle.hpp"

/**
 * @brief Construct a new toggle::toggle object
 * 
 */
toggle::toggle() : _val(false), _ci(false), _co(false), _pci(&_ci)
{
    _ci = true;
    _pci = &_ci;
}

/**
	 * @brief Construct a new toggle object
	 * @param val 
	 */
toggle::toggle(bool val) : _val(val), _ci(false), _co(false), _pci(&_ci)
{
}

/**
 * @brief Construct a new toggle object
 * @param co 
 * @param ci 
 */
toggle::toggle(bool ci, bool co) : _val(false), _ci(ci), _co(co), _pci(&_ci)
{
}

/**
 * @brief Construct a new toggle object
 * @param val 
 * @param co 
 * @param ci 
 */
toggle::toggle(bool val, bool co, bool ci) : _val(val), _ci(ci), _co(co), _pci(&_ci)
{
}

void toggle::chain(toggle t)
{
    t._pci = &_co;
}

/** 
 * @brief get
 * @return bool
 */
bool toggle::get()
{
    return _val;
}

/** 
 * @brief set
 * @return bool
 */
bool toggle::set()
{
    _val = !_val;
    _co = _val && _ci;
    return _val;
}

/**
 * @brief Get the co object
 * 
 * @return true 
 * @return false 
 */
bool toggle::get_co()
{
    return _co;
}

/**
 * @brief Get the ci object
 * 
 * @return true 
 * @return false 
 */
bool toggle::get_ci()
{
    return _ci;
}

