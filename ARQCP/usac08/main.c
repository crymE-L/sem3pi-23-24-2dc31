#include <stdio.h>
#include <stdlib.h>

char** lerLinhasDoArquivo(const char *caminhoArquivo, int *numLinhas) {
    FILE *arquivo = fopen(caminhoArquivo, "r");
    if (!arquivo) {
        fprintf(stderr, "Erro ao abrir o arquivo %s\n", caminhoArquivo);
        exit(EXIT_FAILURE);
    }

    *numLinhas = 0;
    char buffer[256];  
    while (fgets(buffer, sizeof(buffer), arquivo) != NULL) {
        (*numLinhas)++;
    }

    rewind(arquivo);

    char** linhas = (char**)malloc(*numLinhas * sizeof(char*));
    if (!linhas) {
        fprintf(stderr, "Erro na alocação de memória.\n");
        exit(EXIT_FAILURE);
    }

    for (int i = 0; i < *numLinhas; i++) {
        linhas[i] = (char*)malloc(sizeof(buffer));
        if (!linhas[i]) {
            fprintf(stderr, "Erro na alocação de memória.\n");
            exit(EXIT_FAILURE);
        }
        fgets(linhas[i], sizeof(buffer), arquivo);
    }

    fclose(arquivo);
    return linhas;
}

int main() {
    const char *caminhoArquivo = "/home/gustavo/Documents/University/LEI/Subjects/2nd_Year/1st_Semester/LAPR3/sem3pi2023_24_g031/ARQCP/usac08/arquivo.txt";

    int numLinhas;
    char** linhas = lerLinhasDoArquivo(caminhoArquivo, &numLinhas);

    for (int i = 0; i < numLinhas; i++) {
        printf("Linha %d: %s", i + 1, linhas[i]);
    }

    for (int i = 0; i < numLinhas; i++) {
        free(linhas[i]);
    }
    free(linhas);

    return 0;
}
