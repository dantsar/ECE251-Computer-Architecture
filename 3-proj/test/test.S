.data

.balign 4
str1: .asciz "1.1"
.balign 4
str2: .asciz "0.0"
.balign 4
format: .asciz "%f\n"
.balign 4
return: .word 0
.balign 4
num: .float 0.0 

.text
.global main
main:
    ldr r0, =return
    str lr, [r0] 

    ldr r0, =str1
    mov r1, #0
    bl strtof

    vmov s0, r0
    vcvt.f64.f32 d4, s0
    
    ldr r0, =str2
    mov r1, #0
    bl strtof

    vmov s0, r0
    vcvt.f64.f32 d5, s1
    
    vmov.f64 d0, d4  /* I don't understand why it's not working */
    vmov.f64 d1, d5
    bl pow
    
    vmov r2, r3, d0    

    ldr r0, =format
    bl printf
    
    
/*
    ldr r0, =str1
    mov r1, #0  
    bl strtof

    vmov s0, r0
    vcvt.f64.f32 d0, s0

    ldr r0, =format
    vmov r2,r3, d0
    bl printf
    
    ldr r0, =str2
    mov r1, #0
    bl strtof

    vmov s1, r0
    vcvt.f64.f32 d1, s1
    
    ldr r0, =format
    vmov r2,r3, d1
    bl printf

    vmov r0, r1, d0
    vmov r2, r3, d1
    bl pow

    vmov s0, r0
    vcvt.f64.f32 d0, s0
    vmov r2,r3, d0
    ldr r0, =format
    bl printf 
*/  
/*
    vmov s0, r0
    VCVT.F64.F32 D0, S0 
    vmov r2, r3, d0

    ldr r0, =format
    bl printf
*/
    ldr lr, =return
    ldr lr, [lr]
    bx lr

.global strtof
.global printf
.global pow
