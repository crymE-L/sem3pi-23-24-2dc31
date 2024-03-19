#include "usac09.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "circular_buffer"

Sensor* find_sensor(Sensor* sensors, int sensors_len, int sensor_id) {
    // Start looping through the array of sensors
    for (int i = 0; i < sensors_len; ++i) {
        // Look for an uninitialized sensor where sensor_id is 0
        if ((sensors + i)->sensor_id == sensor_id) {
            // Return the sensor
            return sensors + i;
        }
    }
    return NULL;
}

int insert_sensor_data(Sensor* sensors, int sensors_len, int sensor_id, CircularBuffer* buffer, int last_read_time, int value) {
    // Find the sensor with the given sensor_id
    Sensor* sensor = find_sensor(sensors, sensors_len, sensor_id);
    
    // Initialize this sensor using allocate_sensor_data function
    Sensor* sensor = allocate_sensor_data(sensor_id, type, unit, buffer_len, window_len, timeout);
    
    // Check if the memory was allocated
    if (sensor == NULL) {
        printf("Error allocating memory for sensor.\n");
        return 0;
    }

    // Use the enqueue_value function to insert the value in the circular buffer
    enqueue_value(sensor->circular_buffer->array, &(sensor->circular_buffer->length), &(sensor->circular_buffer->read), sensor->circular_buffer->write, value);

    buffer->data = (int*)malloc(size * sizeof(int));

    // Update the last_read_time of the sensor
    sensor->last_timestamp = time;

    // Update the write_counter of the sensor
    sensor->write_counter += 1; 
    
    // Check if the memory was allocated
    if (buffer->data == NULL) {
        free(buffer);
        return NULL;
    }

}
