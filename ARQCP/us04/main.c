#include <stdio.h>
#include "usac04.h"

int main(void) {
    int array[] = {1, 7, 9, 14, -2};

    int size = sizeof(array) / sizeof(array[0]);

    sort_array(array, size);

    printf("Sorted array: |");
    for (int i = 0; i < size; i++){
        printf(" %d |", array[i]);
    }
    printf("\n");

	return 0;
}
