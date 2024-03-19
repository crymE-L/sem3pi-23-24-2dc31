#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <sys/time.h>
#include "usac12_usac13.h"

int periodicityInSecs;

ComponentData *componentData;

void handleAlarm() {
    // Call the processSensorData function here

    processSensorData(componentData->saidaDeDadosDirectory, componentData->farmCoordinatorDirectory);

    // Set the alarm again for periodic execution
    alarm(periodicityInSecs);
}

int main(int argc, char *argv[]) {
    // If the number of arguments is different than 4, show an error
    if (argc != 4) {
        printf("Use: %s <SaidaDeDados_directory> <FarmCoordinator_directory> <periodicity>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    char *saidaDeDadosDir = argv[1];
    char *farmCoordinatorDir = argv[2];
    int periodicity = atoi(argv[3]);

    periodicityInSecs = periodicity / 1000;

    // Initialize the component data
    componentData = initializeComponentData(saidaDeDadosDir, farmCoordinatorDir);

    // Set up the signal handler to call the handleAlarm function
    struct sigaction sa;
    sa.sa_handler = (void (*)(int))handleAlarm;
    sigaction(SIGALRM, &sa, NULL);

    // Configure the timer to fire every 'periodicityInSecs' seconds
    struct itimerval timer;
    timer.it_value.tv_sec = periodicityInSecs;
    timer.it_value.tv_usec = 0;
    timer.it_interval.tv_sec = periodicityInSecs;  // Assign the interval as well
    timer.it_interval.tv_usec = 0;

    // Start the timer
    setitimer(ITIMER_REAL, &timer, NULL);
    
    while (1) {
        sleep(1);
    }

    return 0;
}

