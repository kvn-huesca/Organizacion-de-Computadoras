#include <stdio.h>

extern int maximo(int *arreglo, int len);
extern int minimo(int *arreglo, int len);
extern int sumatoria(int *arreglo, int len);
void capturarArreglo(int *arreglo, int len){
	for(int i=0; i < len; i++){
		printf("\nIndice [%d]:  ",i + 1);
		scanf("%d", arreglo + i);
	}
}
void imprimirArreglo(int *arreglo, int len){
    printf("\n[Arreglo]\n");

    for(int i = 0; i < len; i++){
        printf("%d ", *(arreglo + i));
    }

    printf("\n");
}

int main(){
	int selector=0;
	int arreglo[5]={0};

	
	do{
		printf("\n==== MENU ====");
		printf("\n[1] Capturar Arreglo");
		printf("\n[2] Desplegar Arreglo");
		printf("\n[3] Informacion del Arreglo");
		printf("\n[4] Salir");
		printf("\nSelecciona una opcion: ");
		scanf("%d", &selector);

		switch(selector){
			case 1:
				capturarArreglo(arreglo, 5);
			break;

			case 2:
				imprimirArreglo(arreglo, 5);
			break;

			case 3:
				printf("\nSumatoria del Arreglo: %d", sumatoria(arreglo, 5));
				printf("\nValor Maximo del Arreglo: %d", maximo(arreglo, 5));
				printf("\nValor Minimo del Arreglo: %d", minimo(arreglo, 5));
			break;

			case 4:
				printf("\nbye bye...\n");
			break;

			default:
				printf("\nOpcion Invalida...");
			break;

		}
	}while(selector != 4);

	return 0;

}