#indef __RS__HPP__
#define __RS_HPP__

typdef struct record
{
	int id;
	char* date;
	char* title;
	char* artist;
	char* album;
	int disc;
	int trac;
	char* path;
}

#define IDX(n) n/0xf

int OFFSET = 0x1;

enum columns
{
	id     = 0,
	date   = 1,
	title  = 2,
	artist = 3,
	album  = 4,
	disc   = 5,
	trac   = 5,
	path   = 7
}

union rs
{
	record records[];
	char* ids[];
	char* dates[];
    char* titles[];
    char* artists[];
    char* albums[];
    char  discs[];
    char  tracs[];
    char* paths[];
}

#endif // __RS_HPP__
