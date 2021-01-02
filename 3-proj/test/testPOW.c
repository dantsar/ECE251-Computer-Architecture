#include <stdio.h>
#include <math.h>

int main(int argc, char *argv[]){
    float num = 2;
    for(int i = 0; i < 2; i++){
        num += 2;
    }
    num = pow(num,2);
    printf("%f", num);    
    return 0;
}
