#ifndef USAC07_H
#define USAC07_H
#include "circular_buffer.h"

typedef struct {
    int sensor_id;
    char type[50];
    char unit[20];
    int buffer_len;
    int window_len;
    int timeout;
} Sensor;

Sensor* read_config_file(char* file_path, int lines);
int handle_directory(char *directory);

#endif
