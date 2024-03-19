main: main.o allocate_sensor_data.o
	gcc main.o allocate_sensor_data.o -z noexecstack -o main

main.o: main.c usac10.h
	gcc -g -Wall -Wextra -fanalyzer -c main.c -o main.o

allocate_sensor_data.o: allocate_sensor_data.c
	gcc -g -Wall -Wextra -fanalyzer -c allocate_sensor_data.c -o allocate_sensor_data.o

run: main
	./main

clean:
	rm *.o main
