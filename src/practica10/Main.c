#include <stdio.h>
#include <stdlib.h>
#include <time.h>

extern void set_bit(unsigned char *value, unsigned char bit);
extern unsigned char get_bit(unsigned char value, unsigned char bit);
int rndm(void){
    int num = (rand() % 11) - 5;
    
    return num;
}

void update_temps(int *temps){
    temps[0] += rndm();
    temps[1] += rndm();
}

void update_flags(int *temps, int *last_temps, unsigned char *flags){
    update_temps(temps);
    flags[0] = 0;
    flags[1] = 0;
    
    
    for (int i=0; i < 2 ; i++){
        int diferencia = temps[i] - last_temps[i];
        if (diferencia > 0){
            set_bit(&flags[i], 5);
            if (diferencia == 1)
                set_bit(&flags[i], 1);
            else if (diferencia == 2)
                set_bit(&flags[i], 2);
            else if (diferencia > 2)
                set_bit(&flags[i], 3);

        }
        else if (diferencia < 0){
            set_bit(&flags[i], 4);
            if (diferencia == -1)
                set_bit(&flags[i], 1);
            else if (diferencia == -2)
                set_bit(&flags[i], 2);
            else if (diferencia < -2)
                set_bit(&flags[i], 3);
            
        }
        else
            set_bit(&flags[i], 0);
    }

    last_temps[0] = temps[0];
    last_temps[1] = temps[1];

    return;

}

int main(){
    srand(time(NULL));
    unsigned char banderas[ 2 ] = {0,0};
    int ultima_lectura[ 2 ] = {25,25};
    int tem_sensores[ 2 ] = {25,25};
    int selector=0;

    do{
        for (int i = 0; i < 2; i++){
            printf("\nSENSOR %d: ~%d ºC ", i+1, tem_sensores[i]);
            if (get_bit(banderas[i], 0) == 1)
                printf("-");
            else if (get_bit(banderas[i], 5) == 1){
                if (get_bit(banderas[i], 1) == 1)
                    printf(">");
                else if (get_bit(banderas[i], 2) == 1)
                    printf(">>");
                else if(get_bit(banderas[i], 3) == 1)
                    printf(">>>");
            }
            else if (get_bit(banderas[i], 4) == 1){
                if (get_bit(banderas[i], 1) == 1)
                    printf("<");
                else if (get_bit(banderas[i], 2) == 1)
                    printf("<<");
                else if(get_bit(banderas[i], 3) == 1)
                    printf("<<<");
            }
        }

        printf("\n\n[1] Actualizar");
        printf("\n[2] Salir");
        printf("\n\n Seleccionar opcion: ");
        scanf("%d", &selector);

        switch(selector){
            case 1:
                update_flags(tem_sensores, ultima_lectura, banderas);
            break;

            case 2:
                printf("\nbye bye...");
            break;

            default:
                printf("\nOpcion Invalida...");
            break;

        }
    }while(selector != 2);

    return 0;
}

