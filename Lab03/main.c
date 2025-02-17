/* main.c simple program to test assembler program */

#include <stdio.h>

extern long long int test(long long int a, long long int b);

extern long long int lab03b();

extern long long int my_array[10];
extern long long int lab03c();

int main(void)
{
    //~ long long int a = test(3, 5);
    //~ printf("Result of test(3, 5) = %lld\n", a);
    
    //printf("Result of lab03b() = %lld\n", lab03b());
    lab03c();
    printf("Result of lab03c():\n");
    for (int i = 0; i < 10; i++) {
        printf("%lld ", my_array[i]);
    }
    printf("\n");
    
    return 0;
}
