#include "usac10.h"
#include <stdio.h>
#include <time.h>

void writeToFile();
int countFileLines(FILE *sensorsDataFile);

int main() {
  writeToFile();
  return 0;
}

void writeToFile() {
  FILE *sensorsDataFile;
  FILE *serializedSensorsFile;

  char *serializedSensor;

  time_t rawtime;
  struct tm *timeinfo;

  time(&rawtime);
  timeinfo = localtime(&rawtime);

  char timestamp[20];
  strftime(timestamp, sizeof(timestamp), "%Y%m%d%H%M%S", timeinfo);

  char filename[100];
  snprintf(filename, sizeof(filename), "%s_sensors.txt", timestamp);

  sensorsDataFile = fopen("dummy_data.txt", "r");
  serializedSensorsFile = fopen(filename, "w+");

  if (sensorsDataFile == NULL) {
    printf("Data file does not exist.\n");

    fclose(serializedSensorsFile);
    fclose(sensorsDataFile);

    return;
  }

  if (serializedSensorsFile == NULL) {
    printf("Output file does not exist.\n");

    fclose(serializedSensorsFile);
    fclose(sensorsDataFile);

    return;
  }

  int fileLines = countFileLines(sensorsDataFile);

  SensorData **sensorsData = read_config_file("dummy_data.txt", fileLines);
  SensorData *sensor;

  for (int i = 0; i < fileLines; i++) {
    sensor = sensorsData[i];

    int length = snprintf(NULL, 0, "%d,%d,%s,%s%s", sensor->sensor_id, 1,
                          sensor->type, sensor->unit, "\n");

    serializedSensor = malloc(length + 1);

    snprintf(serializedSensor, length + 1, "%d,%d,%s,%s%s", sensor->sensor_id,
             1, sensor->type, sensor->unit, "\n");

    fputs(serializedSensor, serializedSensorsFile);

    free(serializedSensor);
  }

  fclose(serializedSensorsFile);
  fclose(sensorsDataFile);
}

int countFileLines(FILE *sensorsDataFile) {
  int lines = 0;
  char lineContent[100];

  while (fgets(lineContent, sizeof(lineContent), sensorsDataFile)) {
    lines++;
  }

  return lines;
}
