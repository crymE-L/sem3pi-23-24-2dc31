main: main.o us02.o
	gcc main.o us02.o -z noexecstack -o main

main.o: main.c us02.h
	gcc -g -Wall -Wextra -fanalyzer -c main.c -o main.o

asm.o: us02.s
	gcc -g -Wall -Wextra -fanalyzer -c us02.s -o us02.o

run: main
	./main

clean:
	rm *.o main
