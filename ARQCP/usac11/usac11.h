#ifndef USAC11_H
#define USAC11_H
#include "circular_buffer.h"

typedef struct {
  int sensor_id;
  char type[50];
  char unit[20];
  CircularBuffer *buffer;
  int *median_array;
  int last_read_time;
  int timeout;
  int write_counter;
  int quantity;
  int possible_median;
  int window_len;
} SensorData;

int insert_sensor_data(SensorData *sensor, int sensors_len, int sensor_id,
                       CircularBuffer *buffer, int last_read_time, int timeout);
SensorData **read_config_file(char *file_path, int lines);

int extract_token(char *input, char *token, int *output);
int move_num_vec(int *array, int length, int *read, int *write, int num,
                 int *vec);
void enqueue_value(int *array, int length, int *read, int *write, int value);

void sort_array(int *vec, int num);
int mediana(int *vec, int num);
#endif
