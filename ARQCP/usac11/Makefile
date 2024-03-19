main: main.o allocate_sensor_data.o asm.o us05.o us04.o us03.o us02.o
	gcc main.o allocate_sensor_data.o asm.o us05.o us04.o us03.o us02.o -z noexecstack -o main

main.o: main.c usac11.h
	gcc -g -Wall -Wextra -fanalyzer -c main.c -o main.o

allocate_sensor_data.o: allocate_sensor_data.c
	gcc -g -Wall -Wextra -fanalyzer -c allocate_sensor_data.c -o allocate_sensor_data.o

asm.o: asm.s
	gcc -g -Wall -Wextra -fanalyzer -c asm.s -o asm.o

us05.o: us05.s
	gcc -g -Wall -Wextra -fanalyzer -c us05.s -o us05.o

us04.o: us04.s
	gcc -g -Wall -Wextra -fanalyzer -c us04.s -o us04.o

us03.o: us03.s
	gcc -g -Wall -Wextra -fanalyzer -c us03.s -o us03.o

us02.o: us02.s
	gcc -g -Wall -Wextra -fanalyzer -c us02.s -o us02.o

run: main
	./main /dev/ttyACM0 config intermedio 50

clean:
	rm *.o main
