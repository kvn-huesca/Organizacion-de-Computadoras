#include <stdio.h>

#define tam 5

extern int primos(int numero);
extern int sumatoria(int* arreglo, int TAM);
extern int maximo(int* arreglo, int TAM);

int main(){
    int numero=79;
    int arreglo[tam]={10,3,5,15,20};

    printf("\nretorno de la funcion primos con el valor %d: %d\n", numero,primos(numero));
    printf("\nretorno de la funcion sumatoria: %d", sumatoria(arreglo, tam));
    printf("\nretorno de la funcion maximo: %d", maximo(arreglo, tam));
    printf("\n");
    return 0;
}