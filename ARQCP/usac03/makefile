main: main.o us03.o
	gcc main.o us03.o -z noexecstack -o main

main.o: main.c us03.h
	gcc -g -Wall -Wextra -fanalyzer -c main.c -o main.o

asm.o: us03.s
	gcc -g -Wall -Wextra -fanalyzer -c us03.s -o us03.o

run: main
	./main

clean:
	rm *.o main
