main: main.o usac04.o
	gcc main.o usac04.o -z noexexstack -o main

main.o: main.c usac04.h
	gcc -g -Wall -Wextra -fanalyzer -c main.c -o main.o

usac04.o: usac04.s
	gcc -g -Wall -Wextra -fanalyzer -c usac04.s -o usac04.o

run: main
	./main

clean:
	rm *.o main
