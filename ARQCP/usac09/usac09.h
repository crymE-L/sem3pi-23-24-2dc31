#ifndef USAC09_H
#define USAC09_H
#include "circular_buffer.h"

typedef struct {
    int sensor_id;
    char type[50];
    char unit[20];
    CircularBuffer* buffer;
    int* median_array;
    int last_read_time;
    int timeout;
    int write_counter;
} SensorData;

int insert_sensor_data(Sensor* sensor, int sensors_len, int sensor_id, CircularBuffer* buffer, int last_read_time, int timeout);

#endif
