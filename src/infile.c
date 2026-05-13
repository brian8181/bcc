#include <cstdio>
#include <cstdlib>
#include <stdlib.h>

int test1()
{
	int is_ok = EXIT_FAILURE;
	FILE* fp = std::fopen( "test/test.txt", "r+" );
	if( !fp )
	{
		std::perror( "File opening failed" );
		return is_ok;
	}

	int c; // Note: int, not char, required to handle EOF
	while( ( c = std::fgetc( fp ) ) != EOF ) // Standard C I/O file reading loop
		std::putchar( c );

	if( std::ferror( fp ) )
		std::puts( "I/O error when reading" );
	else if( std::feof( fp ) )
	{
		std::puts( "End of file reached successfully" );
		is_ok = EXIT_SUCCESS;
	}

	std::fclose( fp );
	return is_ok;
}

int test2( void )
{
	int ret_code = 0;
	for( char c = 'a'; ( ret_code != EOF ) && ( c != 'z' ); c++ )
		ret_code = putc( c, stdout );

	// Test whether EOF was reached.
	if( ret_code == EOF && ferror( stdout ) )
	{
		perror( "putc()" );
		fprintf( stderr, "putc() failed in file %s at line # %d\n",
			__FILE__, __LINE__ - 7 );
		exit( EXIT_FAILURE );
	}
	putc( '\n', stdout );

	return EXIT_SUCCESS;
}

int main()
{
	test1();
	test2();
}
