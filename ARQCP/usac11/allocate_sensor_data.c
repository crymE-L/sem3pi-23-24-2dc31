#include "usac11.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

SensorData **read_config_file(char *file_path, int lines) {
  FILE *file = fopen(file_path, "r");
  if (!file) {
    perror("File opening failed");
    return NULL;
  }

  SensorData **sensors = malloc(lines * sizeof(SensorData *));
  if (!sensors) {
    fclose(file);
    printf("Memory allocation for sensors failed");
    return NULL;
  }

  char line[1024];

  int id;
  int i = 0;
  char type[50];
  char unit[20];
  int buffer_len;
  int window_len;
  int timeout;

  for (int i = 0; i < lines; i++) {
    if (fgets(line, sizeof(char) * 1024, file) == NULL) {
      printf("Invalid line: %d\n", i);
      sensors[i] = NULL; // Mark as invalid and continue
      continue;
    }

    // Remove newline character
    line[strcspn(line, "\n")] = '\0';

    if (sscanf(line, "%d#%[^#]#%[^#]#%d#%d#%d", &id, type, unit, &buffer_len,
               &window_len, &timeout) != 6) {
      printf("Invalid format for line: %d\n", i);
      sensors[i] = NULL; // Mark as invalid and continue
      continue;
    }

    SensorData *sensor = calloc(1, sizeof(SensorData));

    // Allocate each piece of information from the config file
    sensor->sensor_id = id;
    strncpy(sensor->type, type, 50);
    strncpy(sensor->unit, unit, 20);
    sensor->timeout = timeout;

    // Store the sensor in the array
    sensors[i] = sensor;
  }

  fclose(file);
  return sensors;
}
