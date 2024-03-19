#include "asm.h"
#include <stdio.h>

int main() {
    char input[] = "\\sensor_id:8#type:atmospheric_temperature#value:21.60#unit:celsius#time:2470030";
    char token[] = "tame:";
    int output;

    extract_token(input, token, &output);
	
	if ((output) == 0) {
		printf ("Token não encontrado ou valor do token não aceite.\n");
	} else {
		printf("Valor do %s %d\n", token, output);
	}

    return 0;
}
