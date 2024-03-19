#ifndef USAC10_H
#define USAC10_H
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
} SensorData;

int insert_sensor_data(SensorData *sensor, int sensors_len, int sensor_id,
                       CircularBuffer *buffer, int last_read_time, int timeout);
SensorData **read_config_file(char *file_path, int lines);

#endif
