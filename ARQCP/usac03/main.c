#include <stdio.h>
#include "us03.h"

int main(void)
{
	// Define arrays and variables
	int array1[] = {1, 2, 3, 4, 5};
	int length1 = 5;
	int read = 0;
	int write = 2;
	int num_elements = 3;
	int array2[5];

	int result = move_num_vec(array1, length1, &read, &write, num_elements, array2);

	printf("Result: %d\n", result);
	printf("Updated indices - Read: %d, Write: %d\n", read, write);

	printf("Array2: ");
	for (int i = 0; i < length1; i++)
	{
		printf("%d ", array2[i]);
	}
	printf("\n");

	return 0;
}
