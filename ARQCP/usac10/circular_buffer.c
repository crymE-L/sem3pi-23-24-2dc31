#include <stdio.h>
#include <stdlib.h>
#include "circular_buffer.h"

CircularBuffer* initialize_buffer(int size) {
    // Reserve the necessary memory for the circular_buffer
    CircularBuffer* circular_buffer = (CircularBuffer*)malloc(sizeof(CircularBuffer));
    if (circular_buffer == NULL) {
        // Handle allocation failure
        return NULL;
    }

    // Allocate memory for the buffer data array
    circular_buffer->array = (int*)malloc(size * sizeof(int));
    if (circular_buffer->array == NULL) {
        // Handle allocation failure
        free(circular_buffer);
        return NULL;
    }

    // Initialize the buffer
    circular_buffer->length = size;
    circular_buffer->read = 0;
    circular_buffer->write = 0;

    return circular_buffer;
}