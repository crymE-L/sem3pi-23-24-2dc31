#include <stdio.h>
#include <stdlib.h>
#include "usac07.h"

Sensor* read_config_file(char* file_path, int lines) {
    FILE* file = fopen(file_path, "r");
    char line;
    Sensor* sensors[lines];

    for (int i = 0; i < lines; i++) {
        char line = fgets(i, sizeof(line), file);
        char attributes[6][lines];

        // We need to divide the line into attributes
        char* token = strtok(line, '#');

        while (token != NULL) {
            // Store the token in the attributes array
            strncpy(attributes[i], token, lines);
            // Get the next token
            token = strtok(NULL, '#');
            i++;
        }

        // Convert attribute, buffer_size, from string to int
        int buffer_size = (int)atoi(attributes[3]);
        
        // Allocate memory for the buffer data array
        int* buffer_array = malloc(buffer_size * sizeof(int));

        // Check if array is valid
        if (buffer_array == NULL) {
            // Handle allocation failure
            printf("Error while allocating memory for the buffer array.\n");
            return NULL;
        }

        // Allocate memory for the circular buffer
        CircularBuffer* circular_buffer = (CircularBuffer*) malloc(sizeof(CircularBuffer));

        // Check if buffer is valid
        if (circular_buffer == NULL) {
            // Handle allocation failure
            printf("Error while allocating memory for the circular buffer.\n");
            return NULL;
        }

        // Initialize the buffer
        circular_buffer->array = buffer_array;
        circular_buffer->length = buffer_size;
        circular_buffer->read = 0;
        circular_buffer->write = 0;

        // Retrieve size of type and unit
        size_t type_size = strlen(attributes[1]);
        size_t unit_size = strlen(attributes[2]);

        // Allocate memory for the type and unit
        char* type_ptr = (char*) malloc((type_size + 1) * sizeof(char));
        char* unit_ptr = (char*) malloc((unit_size + 1) * sizeof(char));

        // Check if type and/or unit are valid
        if (type_ptr == NULL || unit_ptr == NULL) {
            printf("Failed to allocate memory.\n");
            return NULL;
        }

        // Copy type value to the allocated memory
        for (int j = 0; j < type_size; j++) {
            strcpy(type_ptr + j, attributes[1][j]);
        }

        // Copy unit value to the allocated memory
        for (int j = 0; j < unit_size; j++) {
            strcpy(unit_ptr + j, attributes[2][j]);
        }

        // Reserve the necessary memory for the sensor with all bits initialized to 0
        Sensor* sensor = (Sensor*) calloc(1, sizeof(Sensor));

        // Check if sensor is valid
        if (sensor == NULL) {
            printf("Failed to allocate memory for sensor.\n");
            return NULL;
        }

        // Allocate each piece of information from config file
        sensor->sensor_id = atoi(attributes[0]);
        strcpy(sensor->type, type_ptr);
        strcpy(sensor->unit, unit_ptr);
        sensor->buffer_len = buffer_size;
        sensor->window_len = atoi(attributes[4]);
        sensor->timeout = atoi(attributes[5]);

        // Store the sensor in the array
        sensors[i] = sensor;
    }
    
    return sensors;
}