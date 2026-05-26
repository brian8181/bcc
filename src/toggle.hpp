/**
 * @file    toggle.hpp
 * @version 0.0.1
 * @date    Sun, 24 May 2026 19:06:31 +0000
 */
#ifndef _toggle_HPP_
#define _toggle_HPP_
#include <iostream>

/**
  * @brief class toggle
  */
class toggle
{
public:
	/**
	* @brief : default ctor
	*/
	toggle();

	/**
	 * @brief Construct a new toggle object
	 * @param val 
	 */
	toggle(bool val);

	/**
	 * @brief Construct a new toggle object
	 * @param ci 
	 * @param co 
	 */
	toggle(bool ci, bool co);

	/**
	 * @brief Construct a new toggle object
	 * @param val 
	 * @param co 
	 * @param ci 
	 */
	toggle(bool val, bool co, bool ci);

	/**
     * @brief : copy ctor
	 */
	toggle( const toggle& src ) = default;
	
	/**
	 * @brief : destructor
	 */
	~toggle() = default;
	
	/**
	 * @brief get
	 * @return bool 
	 */
	bool get();

		
	/**
	 * @brief Get the co object
	 * 
	 * @return true 
	 * @return false 
	 */
	bool get_co();

	/**
	 * @brief Get the ci object
	 * 
	 * @return true 
	 * @return false 
	 */
	bool get_ci();

	/**
	 * @brief set
	 * @return bool: val after set
	 */
	bool set();

	void chain(toggle t);

private:
	bool _val = false;
	bool _ci = false;
	bool _co = false;
	bool* _pci = 0;
	bool* _pco = 0;
	toggle* next = 0;
};

#endif
