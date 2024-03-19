#include <stdio.h>
#include "us05.h"
#include "us04.h"

int main(void) {
    int array[] = {3, 2, 20, 23};

    int num = sizeof(array) / sizeof(array[0]);

    printf("Original Array: ");
	for (int i = 0; i < num; i++) {
		printf(" %d |", array[i]);
	}
	printf("\n");

    printf("Final Value: %d\n", mediana(array, num));
}