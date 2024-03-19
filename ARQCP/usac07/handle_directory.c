#include <stdio.h>
#include <sys/stat.h>

int handle_directory(char *directory) {
    struct stat st = {0};

    if (stat(directory, &st) == -1) {
        if (mkdir(directory, 0700) == -1) {
            perror("mkdir");
            return 0;
        }
        printf("Directory %d was successfully created.\n", directory);
    } else {
        printf("Directory %d already exists.\n", directory);
    }

    return 1;
}