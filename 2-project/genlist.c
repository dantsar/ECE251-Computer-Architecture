#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main()
{
    FILE *fp = fopen("unsorted_list", "w");
    srand(time(0));

    int file_size = (rand() % (100)) + 1;
    int rand_int, i;
    for(i = 0; i < file_size; i++){
	    if((rand_int = rand()) == RAND_MAX){
	        if(rand() % 2 != 0){
	            rand_int = (rand_int * -1) - 1;
	        }
	    }else{
            if(rand() % 2 == 0){
                rand_int *= -1;
            }   
        }
        fprintf(fp, "%d\n", rand_int);
    } 

    fclose(fp); 
    return 0;
}
