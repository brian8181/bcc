

#ifndef __BOOST_HEADERS_
#define __BOOST_HEADERS_

#ifdef BOOST_CLASSESnamespace
{
	template <class charT, class traits = regex_traits<charT>>
	class basic_regex;
	typedef basic_regex<char>
		regex;
	typedef basic_regex<wchar_t>
		wregex;
}
#endif

namespace boost
{
	template <class
		charT,
		class traits = regex_traits<charT>>
		class basic_regex
	{
	public:
		// types:
		typedef charT
			value_type;
		typedef implementation - specific
			const_iterator;
		typedef const_iterator
			iterator;
		typedef charT&
			reference;
		typedef const charT&
			const_reference;
		typedef std::ptrdiff_t
			difference_type;
		typedef std::size_t
			size_type;
		typedef regex_constants::syntax_option_type
			flag_type;
		typedef typename traits::locale_type
			locale_type;
		// constants:
		// main option selection:
		static const regex_constants::syntax_option_type normal = regex_constants::normal;
		static const regex_constants::syntax_option_type ECMAScript = normal;
		static const regex_constants::syntax_option_type JavaScript = normal;
		static const regex_constants::syntax_option_type JScript = normal;
		static const regex_constants::syntax_option_type basic = regex_constants::basic;
		static const regex_constants::syntax_option_type extended = regex_constants::extended;
		static const regex_constants::syntax_option_type awk = regex_constants::awk;
		static const regex_constants::syntax_option_type grep = regex_constants::grep;
		static const regex_constants::syntax_option_type egrep = regex_constants::egrep;
		static const regex_constants::syntax_option_type sed = basic = regex_constants::sed;
		static const regex_constants::syntax_option_type perl = regex_constants::perl;
		static const regex_constants::syntax_option_type literal = regex_constants::literal;
		// modifiers specific to perl expressions:
		static const regex_constants::syntax_option_type no_mod_m = regex_constants::no_mod_m;
		static const regex_constants::syntax_option_type no_mod_s = regex_constants::no_mod_s;
		static const regex_constants::syntax_option_type mod_s = regex_constants::mod_s;
		static const regex_constants::syntax_option_type mod_x = regex_constants::mod_x;
		// modifiers specific to POSIX basic expressions:
		static const regex_constants::syntax_option_type bk_plus_qm = regex_constants::bk_plus_qm;
		static const regex_constants::syntax_option_type bk_vbar = regex_constants::bk_vbar static const regex_constants::syntax_option_type no_char_classes = regex_constants::no_char_classes static const regex_constants::syntax_option_type no_intervals = regex_constants::no_intervals
			// common modifiers:
			static const regex_constants::syntax_option_type nosubs = regex_constants::nosubs;
		static const regex_constants::syntax_option_type optimize = regex_constants::optimize;
		static const regex_constants::syntax_option_type collate = regex_constants::collate;
		static const regex_constants::syntax_option_type newline_alt = regex_constants::newline_alt;
		static const regex_constants::syntax_option_type no_except = regex_constants::newline_alt;
		// construct/copy/destroy:
		explicit basic_regex();
		explicit basic_regex( const charT* p, flag_type f = regex_constants::normal );
		basic_regex( const charT* p1, const charT* p2,
			flag_type f = regex_constants::normal );
		basic_regex( const charT* p, size_type len, flag_type f );
		basic_regex( const basic_regex& );
		template <class ST, class SA>
		explicit basic_regex( const basic_string<charT, ST,
			SA>& p,
			flag_type f = regex_constants::normal );
		template <class InputIterator>
		basic_regex( InputIterator first,
			InputIterator last,
			flag_type f = regex_constants::normal );
		~basic_regex();
		basic_regex& operator=( const basic_regex& );
		basic_regex& operator=( const charT* ptr );
		template <class ST, class SA>
		basic_regex& operator=( const basic_string<charT, ST, SA>& p );
		// iterators:
		std::pair<const_iterator, const_iterator> subexpression( size_type n ) const;
		const_iterator begin() const;
		const_iterator end() const;
		// capacity:
		size_type size() const;
		size_type max_size() const;
		bool empty() const;
		size_type mark_count() const;
		//
		// modifiers:
		basic_regex& assign( const basic_regex& that );
		basic_regex& assign( const charT* ptr,
			flag_type f = regex_constants::normal );
		basic_regex& assign( const charT* ptr, unsigned int len, flag_type f );
		template <class string_traits, class A>
		basic_regex& assign( const basic_string<charT, string_traits, A>& s,
			flag_type f = regex_constants::normal );
		template <class InputIterator>
		basic_regex& assign( InputIterator first, InputIterator last,
			flag_type f = regex_constants::normal );
		// const operations:
		flag_type flags() const;
		int status() const;
		basic_string<charT> str() const;
		int compare( basic_regex& ) const;
		// locale:
		locale_type imbue( locale_type loc );
		locale_type getloc() const;
		// swap
		void swap( basic_regex& ) throw( );
	};

	template <class charT, class traits>
	bool operator==( const basic_regex<charT, traits>& lhs,
		const basic_regex<charT, traits>& rhs );
	template <class charT, class traits>
	bool operator!=( const basic_regex<charT, traits>& lhs,
		const basic_regex<charT, traits>& rhs );
	template <class charT, class traits>
	bool operator<( const basic_regex<charT, traits>& lhs,
		const basic_regex<charT, traits>& rhs );
	template <class charT, class traits>
	bool operator<=( const basic_regex<charT, traits>& lhs,
		const basic_regex<charT, traits>& rhs );
	template <class charT, class traits>
	bool operator>=( const basic_regex<charT, traits>& lhs,
		const basic_regex<charT, traits>& rhs );
	template <class charT, class traits>
	bool operator>( const basic_regex<charT, traits>& lhs,
		const basic_regex<charT, traits>& rhs );
	template <class charT, class io_traits, class re_traits>
	basic_ostream<charT, io_traits>&
		operator<<( basic_ostream<charT, io_traits>& os,
			const basic_regex<charT, re_traits>& e );
	template <class charT, class traits>
	void swap( basic_regex<charT, traits>& e1,
		basic_regex<charT, traits>& e2 );
	typedef basic_regex<char> regex;
	typedef basic_regex<wchar_t> wregex;
}

namespace boost
{
	namespace regex_constants
	{
		typedef implementation - specific - bitmask - type syntax_option_type;
		// these flags are standardized:
		static const syntax_option_type normal;
		static const syntax_option_type ECMAScript = normal;
		static const syntax_option_type JavaScript = normal;
		static const syntax_option_type JScript = normal;
		static const syntax_option_type perl = normal;
		static const syntax_option_type basic;
		static const syntax_option_type sed = basic;
		static const syntax_option_type extended;
		static const syntax_option_type awk;
		static const syntax_option_type grep;
		static const syntax_option_type egrep;
		static const syntax_option_type icase;
		static const syntax_option_type nosubs;
		static const syntax_option_type optimize;
		static const syntax_option_type collate;
		//
		// The remaining options are specific to Boost.Regex:
		//
		// Options common to both Perl and POSIX regular expressions:
		static const syntax_option_type newline_alt;
		static const syntax_option_type no_except;
		static const syntax_option_type
			save_subexpression_location;
		// Perl specific options:
		static const syntax_option_type no_mod_m;
		static const syntax_option_type no_mod_s;
		static const syntax_option_type mod_s;
		static const syntax_option_type mod_x;
		static const syntax_option_type no_empty_expressions;
		// POSIX extended specific options:
		static const syntax_option_type no_escape_in_lists;
		static const syntax_option_type no_bk_refs;
		// POSIX basic specific options:
		static const syntax_option_type no_escape_in_lists;
		static const syntax_option_type no_char_classes;
		static const syntax_option_type no_intervals;
		static const syntax_option_type bk_plus_qm;
		static const syntax_option_type bk_vbar;

		typedef implemenation - specific - bitmask - type match_flag_type;
		static const match_flag_type match_default = 0;
		static const match_flag_type match_not_bob;
		static const match_flag_type match_not_eob;
		static const match_flag_type match_not_bol;
		static const match_flag_type match_not_eol;
		static const match_flag_type match_not_bow;
		static const match_flag_type match_not_eow;
		static const match_flag_type match_any;
		static const match_flag_type match_not_null;
		static const match_flag_type match_continuous;
		static const match_flag_type match_partial;
		static const match_flag_type match_single_line;
		static const match_flag_type match_prev_avail;
		static const match_flag_type match_not_dot_newline;
		static const match_flag_type match_not_dot_null;
		static const match_flag_type match_posix;
		static const match_flag_type match_perl;
		static const match_flag_type match_nosubs;
		static const match_flag_type match_extra;
		static const match_flag_type format_default = 0;
		static const match_flag_type format_sed;
		static const match_flag_type format_perl;
		static const match_flag_type format_literal;
		static const match_flag_type format_no_copy;
		static const match_flag_type format_first_only;
		static const match_flag_type format_all;
	} // namespace regex_constants
} // namespace boost

#endif
