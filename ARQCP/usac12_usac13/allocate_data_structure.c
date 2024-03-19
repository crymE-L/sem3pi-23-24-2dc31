#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <errno.h>

typedef struct {
    char *saidaDeDadosDirectory;
    char *farmCoordinatorDirectory;
} ComponentData;

ComponentData* initializeComponentData(char *saidaDeDadosDir, char *farmCoordinatorDir) {
    ComponentData *data = (ComponentData *)malloc(sizeof(ComponentData));

    if (data == NULL) {
        printf("Error allocating memory for ComponentData\n");
        exit(EXIT_FAILURE);
    }

    // Initialize the directories
    data->saidaDeDadosDirectory = saidaDeDadosDir;
    data->farmCoordinatorDirectory = farmCoordinatorDir;

    // Check if both directories exist, otherwise create them
    if (mkdir(data->saidaDeDadosDirectory, 0755) != 0 && errno != EEXIST) {
        printf("Error creating input directory\n");
        exit(EXIT_FAILURE);
    }

    if (mkdir(data->farmCoordinatorDirectory, 0755) != 0 && errno != EEXIST) {
        printf("Error creating output directory\n");
        exit(EXIT_FAILURE);
    }

    return data;
}
