main: main.o insert_component_data.o
	gcc main.o  insert_component_data.o -z noexecstack -o main

main.o: main.c usac09.h
	gcc -g -Wall -Wextra -fanalyzer -c main.c -o main.o

insert_component_data.o: insert_component_data.c usac09.h
	gcc -g -Wall -Wextra -fanalyzer -c insert_component_data.c -o insert_component_data.o

run: main
	./main

clean:
	rm *.o main
