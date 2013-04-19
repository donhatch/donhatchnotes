#include <stdio.h>
#include <stdlib.h>
#include <time.h>
int main(int argc, char **argv)
{
    if (argc != 2)
    {
        fprintf(stderr, "Arg.\n");
        return 1;
    }
    time_t t = atoi(argv[1]);
    printf("%s\n", ctime(&t));
    return 0;
}
