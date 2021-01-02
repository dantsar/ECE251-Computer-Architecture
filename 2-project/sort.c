#include <stdio.h>
#include <stdlib.h>


//works
int file_lines(char file[]){

    FILE *fp = fopen(file,"r");
    int num_lines = 0; 
    int num

    while( (fscanf(fp, "%d", num)) != -1 ){
        num_lines++;
    }
     
    fclose(fp); 
    return num_lines;
}
/*
for debugging purposes:
//works
void print_array(int array[], int size){
    int *i;
    for(i = &array[0]; i < &array[size]; i++){
        printf("%d\n", *i);     
    } 

}
*/

int main() {
    char input_int[20];
    int size = file_lines("unsorted_list"); //get size of list
    int array[size];

    FILE *fp_unsorted = fopen("unsorted_list", "r");
    FILE *fp_sorted = fopen("sorted_list", "w");

    //store file into array
    int *p;
    for(p = &array[0]; p < &array[size]; p++){
        fgets(input_int, 20, fp_unsorted);
        *p = atoi(input_int);
    }

    int i, j, temp;
    for(i = 0; i < size-1; i++){
        int min_index = i;
        for( j = i+1; j < size; j++){
            if(array[j] < array[min_index]){
                min_index = j;
            }
        }        
        temp = array[i];
        array[i] = array[min_index];
        array[min_index] = temp;
    }
    
    for(p = &array[0]; p < &array[size]; p++){
        fprintf(fp_sorted, "%d\n", *p); 
    }   
 
    fclose(fp_unsorted);
    fclose(fp_sorted);

    return 0;
}
