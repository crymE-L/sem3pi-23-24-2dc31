# A Makefile with variables and suffix rules
# variaveis
INCLUDES = usac04.h usac05.h
SOURCES = usac04.s usac05.s main.c
OBJFILES = usac04.o usac05.o main.o
EXEC = usac05

# Suffix rules
.SUFFIXES : .c .s .o

# How to build an object .o from a code file .c ; $< -- file name
.c.o:
	gcc -g -Wall -Wextra -fanalyzer -c $<

${EXEC}: ${OBJFILES}
	gcc ${OBJFILES} -o ${EXEC}

${OBJFILES}: ${SOURCES} ${INCLUDES}

run: ${EXEC}
	./${EXEC}

clean:
	rm -f ${OBJFILES} ${EXEC}
