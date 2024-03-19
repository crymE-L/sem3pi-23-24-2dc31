#include <stdio.h>
#include "us02.h"

int main(void)
{
	int array[5] = {1, 2, 3, 4, 5};
	int length = 5;
	int read = 0;
	int write = 0;
	int value_to_insert = 10;

	printf("Original Array: ");
	for (int i = 0; i < length; i++)
	{
		printf("%d ", array[i]);
	}
	printf("\n");

	enqueue_value(array, length, &read, &write, value_to_insert);

	printf("Updated Array: ");
	for (int i = 0; i < length; i++)
	{
		printf("%d ", array[i]);
	}
	printf("\n");

	return 0;
}
