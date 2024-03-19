main: main.o allocate_data_structure.o process_sensor_data.o
	gcc -g -Wall -Wextra -fanalyzer main.o allocate_data_structure.o process_sensor_data.o -o main

main.o: main.c usac12_usac13.h
	gcc -g -Wall -Wextra -fanalyzer -c main.c -o main.o

allocate_data_structure.o: allocate_data_structure.c
	gcc -g -Wall -Wextra -fanalyzer -c allocate_data_structure.c -o allocate_data_structure.o

process_sensor_data.o: process_sensor_data.c
	gcc -g -Wall -Wextra -fanalyzer -c process_sensor_data.c -o process_sensor_data.o

run: main
	./main

clean:
	rm *.o main
