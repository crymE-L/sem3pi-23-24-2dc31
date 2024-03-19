main: main.o usac07.o
	gcc main.o usac07.o -z noexecstack -o main

main.o: main.c usac07.h
	gcc -g -Wall -Wextra -fanalyzer -c main.c -o main.o

usac07.o: allocate_sensor_data.c
	gcc -g -Wall -Wextra -fanalyzer -c allocate_sensor_data.c -o usac07.o

run: main
	./main

clean:
	rm *.o main
