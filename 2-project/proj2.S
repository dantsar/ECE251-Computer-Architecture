/* -- proj2.S */ 
.data

.balign 4
unsorted_list: .asciz "unsorted_list"
.balign 4
sorted_list: .asciz "sorted_list"

.balign 4
fp_unsorted: .word 0
.balign 4
fp_sorted: .word 0

.balign 4
r_mode: .asciz "r"
.balign 4 
w_mode: .asciz "w"

.balign 4
fprintf_str: .asciz "%d\n"
.balign 4
fscanf_str: .asciz "%d"
.balign 4
buffer: .skip 20

.balign 4
list_size: .word 0
.balign 4
array: .skip 400
.balign 4
arr_num: .word 0

.balign 4 
output_empty: .asciz "How am I suppose to sort and empty list?\n"
.balign 4
output_success: .asciz "Hey psst, check sorted list\n"
.balign 4
output_error: .asciz "There is something wrong with your list\n"


.balign 4
return: .word 0 

.text
.global main
main:
    ldr r0, address_of_return        /* r0 <- &return */
    str lr, [r0]                     /* r0 <- r0  */

    ldr r0, address_of_unsorted_list /* r0 <- &unsorted_list */
    ldr r1, address_of_r_mode        /* r1 <- &r_mode */
    ldr r2, address_of_fp_unsorted   /* r2 <- &fp_unsorted */ 
    bl f_open

    bl get_array

    bl sort_array
    
    bl store_array

    ldr r0, address_of_fp_unsorted /* r0 <- &fp_unsorted */ 
    ldr r0, [r0]                   /* *r0 <- r0 */ 
    bl fclose 

    mov r4, #1
    ldr r0, address_of_output_success
    b exit

exit:
    
    bl printf

    mov r0, r4
    
    ldr lr, address_of_return      /* lr <- &return */ 
    ldr lr, [lr]                   /* *lr <- lr */ 
    bx lr 

f_open:
    push {lr}
    push {r2}
    bl fopen

    pop {r2} 
    str r0, [r2]                    /* *r2 <- r0 */
    
    pop {lr}
    bx lr 

get_array:
    push {lr} 

    ldr r0, address_of_unsorted_list  /* r0 <- &unsorted_list */
    ldr r1, address_of_r_mode         /* r1 <- &r_mode */
    ldr r2, address_of_fp_unsorted    /* r2 <- &fp_unsorted */
    bl f_open

    mov r4, #0                       /* r4 <- #0 */  
    ldr r5, address_of_array         /* r5 <- &array */  
loop_get_array:
    ldr r0, address_of_fp_unsorted   /* r0 <- &fp_unsorted */
    ldr r0, [r0]                     /* *r0 <- r0 */
    ldr r1, address_of_fscanf_str    /* r1 <- &fscanf_str */
    ldr r2, address_of_arr_num       /* r2 <- &arr_num */
    bl fscanf

    cmp r0, #0
    beq error_get_array

    cmp r0, #0
    blt got_array

    ldr r6, address_of_arr_num      /*r6 <- &arr_num */ 
    ldr r6, [r6]                    /* *r6 <- r6 */
    str r6, [r5, r4, LSL#2]         /* array[r4*4] <- r6 */
     
    add r4, r4, #1                  /* r4++ */

    b loop_get_array
got_array:
    ldr r5, address_of_list_size    /* r5 <- &list_size */
    str r4, [r5]                    /* *r5 <- r4 */ 

    ldr r0, address_of_fp_unsorted  /* r0 <- &fp_unsorted */
    ldr r0, [r0]                    /* r0 <- *r0 */
    bl fclose

    cmp r4, #0
    beq empty_get_array

    pop {lr}
    bx lr
error_get_array:
    mov r4, #404
    ldr r0, address_of_output_error
    b exit
empty_get_array:
    mov r4, #0
    ldr r0, address_of_output_empty
    b exit

sort_array:
    mov r0, #0                     /* r0 <- 0 */ 
    mov r2, #0                     /* r2 <- 0 */ 
    ldr r4, address_of_array       /* r4 <- &array */
    ldr r5, address_of_list_size   /* r5 <- &list_size */
    ldr r5, [r5]                   /* r5 <- *r5 */
    sub r6, r5, #1                 /* r6 <- r5 - 1 */
loop_outer_sort:                   
    add r1, r0, #1                 /* r1 <- r0 + 1 */ 
    mov r2, r0                     /* r2 <- r0 */

    cmp r0, r6
    beq end_sort_array
loop_inner_sort:
    cmp r1, r5
    bge swap_elements

    ldr r7, [r4, r1, LSL#2]        /* r7 <- array[r1*4] */ 
    ldr r8, [r4, r2, LSL#2]        /* r8 <- array[r2*4] */ 
    cmp r7, r8
    movlt r2, r1

    add r1, r1, #1                 /* r1++ */  
    b loop_inner_sort 
swap_elements:
    ldr r7, [r4, r0, LSL#2]        /* r7 <- array[r0*4] */ 
    mov r3, r7                     /* r3 <- r7 */  
    ldr r7, [r4, r2, LSL#2]        /* r7 <- array[r2*4] */ 
    str r7, [r4, r0, LSL#2]        /* array[r0*4] <- r7 */ 
    str r3, [r4, r2, LSL#2]        /* array[r2*4] <- r3 */

    add r0, r0, #1                 /* */
    b loop_outer_sort    
end_sort_array:
    bx lr

store_array:
    push {lr} 
    ldr r0, address_of_sorted_list      /* r0 <- &sorted_list */
    ldr r1, address_of_w_mode           /* r1 <- &w_mode */
    ldr r2, address_of_fp_sorted        /* r2 <- &fp_sorted */
    bl f_open

    mov r4, #0                          /* r4 <- 0 */
    ldr r5, address_of_array            /* r5 <- &array */
    ldr r6, address_of_list_size        /* r6 <- &list_size */
    ldr r6, [r6]                        /* r6 <- *r6 */
loop_store_array:
    cmp r4, r6
    beq end_store_array
    
    ldr r0, address_of_fp_sorted        /* r0 <- &fp_sorted */
    ldr r0, [r0]                        /* r0 <- *r0 */
    ldr r1, address_of_fprintf_str      /* r1 <- &fprintf_str */ 
    ldr r2, address_of_array            /* r2 <- &array */
    ldr r2, [r2, r4, LSL#2]             /* r2 <- array[r4*4] */
    bl fprintf

    add r4, r4, #1                      /* r4++ */    
    b loop_store_array
end_store_array:
    ldr r0, address_of_fp_unsorted      /* r0 <- &fp_unsorted */
    ldr r0, [r0]                        /* r0 <- *r0 */
    bl fclose
    
    pop {lr}
    bx lr

address_of_unsorted_list: .word unsorted_list
address_of_sorted_list: .word sorted_list
address_of_fp_unsorted: .word fp_unsorted
address_of_fp_sorted: .word fp_sorted
address_of_r_mode: .word r_mode
address_of_w_mode: .word w_mode
address_of_fprintf_str: .word fprintf_str
address_of_fscanf_str: .word fscanf_str
address_of_buffer: .word buffer
address_of_list_size: .word list_size
address_of_array: .word array
address_of_arr_num: .word arr_num 
address_of_return: .word return
address_of_output_success: .word output_success
address_of_output_error: .word output_error
address_of_output_empty: .word output_empty

/* External */
.global fopen
.global fclose
.global fscanf
.global fprintf
