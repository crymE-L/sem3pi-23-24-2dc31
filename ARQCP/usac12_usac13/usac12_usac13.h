#ifndef USAC12_USAC13_H
#define USAC12_USAC13_H

// Define ComponentData structure
typedef struct {
    char *saidaDeDadosDirectory;
    char *farmCoordinatorDirectory;
} ComponentData;

// Structure to store sensor data
typedef struct {
    int id;
    char *sensorName;
    float value;
} SensorData;

// Function declarations
ComponentData* initializeComponentData(char *saidaDeDadosDir, char *farmCoordinatorDir);
void processSensorData(char *saidaDeDadosDir, char *farmCoordinatorDir);

#endif
