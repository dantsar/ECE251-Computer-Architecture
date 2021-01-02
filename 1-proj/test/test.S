/* test.S */
.data

.balign 4
string: .asciz "Hello There\n"

.balign 4
printf_msg: .asciz "Hey: %c\n"

.balign 4
num: .word 0

.balign 4
return: .word 0

.text
.global main
main:
    ldr r1, =return
    str lr, [r1]

    ldr r4, =string
    ldr r5, =num
    ldr r5, [r5]
    ldrb r6, [r4, r5] 
    
    add r5, r5, #1
    ldr r7, =num
    str r5, [r7]    

    ldr r0, =printf_msg
    mov r1, r6
    bl printf

    bl main

    ldr r1, =return
    ldr lr, [lr] 
    bx lr

.global printf
