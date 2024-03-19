#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>

typedef struct {
    int id;
    char *sensorName;
    float value;
} SensorData;

SensorData *sensorArray = NULL;
int numSensors = 0;

void addOrUpdateSensor(char *name, float value, int id) {
    for (int i = 0; i < numSensors; ++i) {
        if (sensorArray[i].id == id) {
            // Update existing sensor with the same ID
            sensorArray[i].value = value;
            free(sensorArray[i].sensorName);
            sensorArray[i].sensorName = strdup(name);
            return;
        }
    }

    // Sensor with the given ID not found, add a new one
    numSensors++;
    sensorArray = realloc(sensorArray, numSensors * sizeof(SensorData));
    if (sensorArray == NULL) {
        printf("Error reallocating memory");
        exit(EXIT_FAILURE);
    }

    sensorArray[numSensors - 1].id = id;
    sensorArray[numSensors - 1].sensorName = strdup(name);
    sensorArray[numSensors - 1].value = value;
}

void writeSensorDataToFile(char *farmCoordinatorDir) {
    // Set the output file path
    char outputFilePath[512];
    snprintf(outputFilePath, sizeof(outputFilePath), "%s/results.txt", farmCoordinatorDir);

    // Open the output file for writing
    FILE *outputFile = fopen(outputFilePath, "w");
    if (outputFile == NULL) {
        printf("Error opening output file");
        return;
    }

    // Write sensor data to the file
    for (int i = 0; i < numSensors; ++i) {
        fprintf(outputFile, "Sensor ID: %d\nSensor Name: %s\nLatest Sensor Value: %.2f\n\n",
                sensorArray[i].id, sensorArray[i].sensorName, sensorArray[i].value);
    }

    // Close the output file
    if (fclose(outputFile) != 0) {
        printf("Error closing output file");
        return;
    }
}

void processSensorData(char *saidaDeDadosDir, char *farmCoordinatorDir) {
    // Open the directory
    DIR *dir;
    struct dirent *ent;
    if ((dir = opendir(saidaDeDadosDir)) != NULL) {
        // List to store information from data files
        char dataFiles[100][512];
        int numDataFiles = 0;

        // Iterate through the files in the directory
        while ((ent = readdir(dir)) != NULL) {
            char filePath[512];
            snprintf(filePath, sizeof(filePath), "%s/%s", saidaDeDadosDir, ent->d_name);

            // Check if the file follows the naming standard
            if (strstr(ent->d_name, "sensors.txt") != NULL) {
                strcpy(dataFiles[numDataFiles], filePath);
                numDataFiles++;
            }
        }

        if (numDataFiles == 0) {
            printf("No data files found in the directory.\n");
            closedir(dir);
            return;
        }

        // Iterate through files
        for (int j = 0; j < numDataFiles; ++j) {
            FILE *file = fopen(dataFiles[j], "r");
            if (file == NULL) {
                printf("Error opening file");
                continue;
            }

            char line[256];

            // Iterate through the file
            while (fgets(line, sizeof(line), file) != NULL) {
                // Parse sensor data from the line
                int sensorId;
                float sensorValue;
                char sensorName[256];

                if (sscanf(line, "%d,%*d,%255[^,],%*[^,],%f#", &sensorId, sensorName, &sensorValue) == 3) {
                    // Update the latest value for each sensor
                    addOrUpdateSensor(sensorName, sensorValue / 100, sensorId);

                }
            }

            fclose(file);
        }

        writeSensorDataToFile(farmCoordinatorDir);
        closedir(dir);
    } else {
        printf("Error opening directory");
    }
}

