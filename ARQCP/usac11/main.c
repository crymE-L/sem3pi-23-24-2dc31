#include "usac11.h"
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <termios.h>
#include <time.h>
#include <unistd.h>

SensorData *read_data(char *filename, char *directory);
int to_int(char *str);
void write_to_file(SensorData *sensorsData, int fileLines, char *directory);
int read_raspberry(char *porta, SensorData *sensors, int quantity,
                   char *directory, FILE *file);
int count_file_lines(FILE *file);

int main(int argc, char **argv) {
  int counter;

  char *file = argv[1];
  char *directory = argv[2];
  char *string_quantity = argv[4];

  int quantity = to_int(string_quantity);

  SensorData *sensors = read_data(file, directory);

  FILE *data_file = fopen(file, "r");

  read_raspberry(argv[0], sensors, quantity, directory, data_file);

  free(sensors);
  fclose(data_file);

  return 0;
}

int to_int(char *str) {
  int result = 0;

  while (*str != '\0') {
    result = result * 10 + (*str - '0');
    str++;
  }

  return result;
}

SensorData *read_data(char *filename, char *directory) {
  FILE *testFile = fopen(filename, "r");
  DIR *testDirectory = opendir(directory);

  if (testDirectory == NULL) {
    mkdir(directory, 0777);
  } else {
    closedir(testDirectory);
  }

  if (testFile == NULL) {
    printf("Error: there's no reading file.\n");
    return NULL;
  }

  FILE *file = fopen(file, "r");

  SensorData **sensors = (SensorData *)calloc(1, sizeof(sensors));

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

  while (fgets(line, sizeof(char) * 1024, file)) {
    if (line == NULL) {
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
}

int read_raspberry(char *port, SensorData *sensors, int quantity,
                   char *directory, FILE *file) {

  printf(port);
  int serial_port = open(port, O_RDWR);

  if (serial_port == -1) {
    perror("Error: couldn't open port.");
    return 1;
  }

  struct termios tty;
  tcgetattr(serial_port, &tty);

  cfsetispeed(&tty, B9600);
  cfsetospeed(&tty, B9600);

  tcsetattr(serial_port, TCSANOW, &tty);

  char buffer[256];
  ssize_t bytes_read = read(serial_port, buffer, sizeof(buffer));

  int i;

  char *token;
  int result;
  int *output;

  while (1) {
    while (quantity > 0) {
      bytes_read = read(serial_port, buffer, sizeof(buffer));

      if (bytes_read > 1) {
        buffer[bytes_read] = '\0';

        token = "sensor_id:";
        result = 0;
        output = &result;

        extract_token(buffer, token, output);

        i = 0;
        SensorData *sensor = NULL;

        while (sensor == NULL && (sensors + i)->type != NULL) {
          if (result == (sensors + i)->sensor_id) {
            sensor = sensors + i;
          }

          i++;
        }

        printf("%s\n", sensor->type);

        if (sscanf(buffer, "%*[^#]#type:%49[^#]", sensor->type) == 1) {
          char *token2 = "time:";
          *output = 0;

          extract_token(buffer, token2, output);

          if (sensor->last_read_time == 0) {
            sensor->last_read_time = *output;
          }

          if ((*output - sensor->last_read_time) <= sensor->timeout) {
            sensor->last_read_time = *output;
            char *token3 = "value:";
            *output = 0;

            extract_token(buffer, token3, output);
            enqueue_value(sensor->buffer->array, sensor->buffer->length,
                          &sensor->last_read_time, &sensor->write_counter,
                          *output);

            sensor->write_counter++;
            quantity--;
          } else {
            sensor->last_read_time = -1;
            sensor->timeout = 1;
          }
        }

        i = 0;
      }
    }

    i = 0;

    while ((sensors + i)->type != NULL) {
      if ((sensors + i)->timeout == 1) {
        (sensors + i)->median_array = 0;

        printf("Sensor's timeout on sensor: %d\n", (sensors + i)->sensor_id);
      } else {
        int size;

        if ((sensors + i)->quantity < (sensors + i)->buffer->length) {
          size = (sensors + i)->quantity;
        } else {
          size = (sensors + i)->buffer->length;
        }

        int array[(sensors + i)->window_len];
        int medians = move_num_vec(
            (sensors + i)->buffer->array, size, &(sensors + i)->buffer->read,
            &(sensors + i)->buffer->write, (sensors + i)->window_len, array);
        int j = 0;

        if (medians == 1) {
          printf("Sensor's median: %d: ", (sensors + i)->sensor_id);

          for (j = 0; j < (sensors + i)->window_len; j++) {
            printf("%d ", array[j]);
          }

          printf("\n");
          sort_array(array, (sensors + i)->window_len);
          medians = mediana(array, (sensors + i)->window_len);

          (sensors + i)->median_array = &medians;
          (sensors + i)->write_counter++;
          (sensors + i)->possible_median = 1;
        } else {
          (sensors + i)->possible_median = 0;

          printf("Not enough data to calculate median for sensor: %d\n",
                 (sensors + i)->sensor_id);
        }
      }

      i++;
    }

    write_to_file(sensors, count_file_lines(file), directory);
  }

  if (bytes_read == -1) {
    perror("Error: couldn't read serial port.");
    return 1;
  }

  close(serial_port);

  return 0;
}

void write_to_file(SensorData *sensorsData, int fileLines, char *directory) {
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

  serializedSensorsFile = fopen(filename, "w+");

  if (serializedSensorsFile == NULL) {
    printf("Output file does not exist.\n");

    fclose(serializedSensorsFile);

    return;
  }

  SensorData *sensor;

  for (int i = 0; i < fileLines; i++) {
    sensor = &sensorsData[i];

    int length = snprintf(NULL, 0, "%d,%d,%s,%s%s", sensor->sensor_id, 1,
                          sensor->type, sensor->unit, "\n");

    serializedSensor = malloc(length + 1);

    snprintf(serializedSensor, length + 1, "%d,%d,%s,%s%s", sensor->sensor_id,
             1, sensor->type, sensor->unit, "\n");

    fputs(serializedSensor, serializedSensorsFile);

    free(serializedSensor);
  }

  fclose(serializedSensorsFile);
}

int count_file_lines(FILE *file) {
  int counter = 0;
  char line[1024];

  while (fgets(line, sizeof(char) * 1024, file)) {
    counter++;
  }

  return counter;
}
