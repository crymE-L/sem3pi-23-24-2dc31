#ifndef CIRCULAR_BUFFER_H
#define CIRCULAR_BUFFER_H

typedef struct {
  int *array;
  int length;
  int read;
  int write;
} CircularBuffer;

CircularBuffer *initialize_buffer(int size);

#endif
