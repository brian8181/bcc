#include <stdio.h>

int main(int argc, int* argv[])
{
    int x = 55;
    printf("x=%d\n", x);
    long y = (x == 55);
    printf("y=%d\n", y);
    y = (x != 55);
    printf("y=%d\n", y);
    if( (void*)y == NULL )
        printf("NULL\n");
}