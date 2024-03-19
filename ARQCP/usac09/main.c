#include "usac09.h"
#include <stdio.h>

int main() {
    char directory_path[] = "/home/gustavo/test";

    Sensor* sensor1 = insert_component_data(1, "soil_humidity", "percentage", 50, 10, 40000);

    if (sensor1 != NULL) {
        printf("Sensor ID: %d\n", sensor1->sensor_id);
        printf("Sensor Type: %s\n", sensor1->type);
        free(sensor1);
    }

    handle_directory(directory_path);

    return 0;
}
