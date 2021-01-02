/* -- fgets.S */

.data

.balign 4
msg: .asciz "Enter String: "
.balign 4
output_msg: .asciz "%s"
.balign 4
string1: .space 16

.balign 4
return: .word 0

.text
.global main
main:
    ldr r1, =return
    str lr, [r1]
    
    ldr r0, =msg
    bl printf

    ldr r0, =string1
    mov r1, #11
    ldr r2, =stdin
    ldr r2, [r2]
    bl fgets
    
    ldr r0, =output_msg
    ldr r1, =string1
    ldr r1, [r1]
    bl printf 

    ldr lr, =return
    ldr lr, [lr]
    bx lr


.global printf
.global fgets
