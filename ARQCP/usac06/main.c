#include "asm.h"
#include <stdio.h>

int main() {
  char input[] = "\\sensor_id:8#type:soil_humidity#value:21.60#unit:"
                 "celsius#time:2470030";
  char token[] = "time:";
  int output;

  int result = extract_token(input, token, &output);

  printf("%d\n", result);

  if (result == 0) {
    printf("Token não encontrado ou valor do token não aceite.\n");
  } else {
    printf("Valor do %s %d\n", token, output);
  }

  return 0;
}
