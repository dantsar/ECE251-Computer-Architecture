/* -- proj3.S*/
.data
/* where postfix Expression will be stored */
.balign 4
postfixExp: .skip 100
/* where either an operand or operator will be returned to evalPostfix */
.balign 4
returnOp: .skip 20
/* error message */
.balign 4
syntaxErr: .asciz "ERR:SYNTAX\n"
/* format string for printf to display output */
.balign 4
output: .asciz "%f\n"
/* store the value of the link register to be used to exit */
.balign 4 
return: .word 0

.text
.global main
main:
    ldr r0, address_of_return             /* r0 <- &return  */
    str lr, [r0]                /* r0 <- r0  */ 

    ldr r4, [r1, #4]            /* r4 <- argv[1]  */ 
    bl infixToPostfix
addChar:
    strb r0, [r1, r2]           /* r0 <- r1[r2] */ 
    add r2, r2, #1              /* r2 <- r2 + 1 */ 
    bx lr
infixGetChar:
    ldrb r8, [r4, r5]           /* r8 <- r4[r5] */ 
    bx lr
infixToPostfix:
    ldr r1, address_of_postfixExp         /* r1 <- &postfixExp */
    mov r2, #0                  /* r2 <- 0 */
    mov r3, #0                  /* r3 <- 0 */
    mov r5, #0                  /* r5 <- 0 */
    mov r10, #2                 /* r10 <- 2 */

    bl infixGetChar
whileReadingInfix:
    cmp r8, #0
    beq infixReadEnd

    mov r0, r8                  /* r0 <- r8  */ 
    bl checkPrecedence          
    mov r6, r0                  /* r6 <- r0 */ 

    cmp r6, #1
    movgt r0, #' '              /* if r6 > 1: r0 <- 0  */ 
    blgt addChar

    cmp r6, #0
    beq infixDigit              

    cmp r10, #1
    cmpgt r8, #'-'
    beq negativeNum

    cmp r8, #'('
    beq infixLeftP

    cmp r8, #')'
    beq infixRightP

    b infixElse 

infixDigit:
    mov r0, r8                  /* r0 <- r8 */ 
    bl addChar
    b infixWhileEnd

infixLeftP:
    push {r8}
    add r3, r3, #1              /* r3 <- r3 + 1 */ 
    b infixWhileEnd

negativeNum:
    mov r0, #'-'
    bl addChar

    b infixWhileEnd
infixRightP:
    sub r3, r3, #1              /* r3 <- r3 - 1 */ 
    cmp r3, #0
    blt errorSyntax
    pop {r9}            
    cmp r9, #'('
    beq infixWhileEnd

    mov r0, #' '                /* r0 <- ' ' */ 
    bl addChar
    mov r0, r9                  /* r0 <- r9 */ 
    bl addChar

    b infixRightP

infixElse:
    ldr r0, [sp, #0]            /* r0 <- *sp */ 
    bl checkPrecedence

    cmp r6, r0
    blgt endInfixElse

    pop {r0}
    bl addChar
    mov r0, #' '                /* r0 <- ' ' */ 
    bl addChar 
    sub r3, r3, #1              /* r3 <- r3 + 1 */ 

    b infixElse
endInfixElse:
    push {r8}
    add r3, r3, #1              /* r3 <- r3 + 1 */ 
    b infixWhileEnd
infixWhileEnd:
    mov r10, r6
    add r5, r5, #1              /* r5 <- r5 + 1 */ 
    bl infixGetChar    
    b whileReadingInfix

infixReadEnd:
    cmp r3, #0
    blt infixEnd

    mov r0, #' '                /* r0 <- ' ' */ 
    bl addChar
    pop {r0}
    bl addChar

    sub r3, r3, #1
    b infixReadEnd
infixEnd:
    mov r0, #' '                /* r0 <- ' ' */ 
    bl addChar 

    b evalPostfix
checkPrecedence:
    cmp r0, #'^'    
    moveq r0, #4                /* if r0 == '^' { r0 <- 4} */ 
    bxeq lr
   
    cmp r0, #'*'
    cmpne r0, #'/'
    moveq r0, #3                /* if r0 == '*' || r0 == '/' { r0 <- 3} */ 
    bxeq lr
     
    cmp r0, #'+'
    cmpne r0, #'-'
    moveq r0, #2                /* if r0 == '+' || r0 == '-' { r0 <- 2} */ 
    bxeq lr

    cmp r0, #'('
    cmpne r0, #')'
    moveq r0, #1                /* if r0 == '(' || r0 == ')' { r0 <- 1} */ 
    bxeq lr
    
    mov r0, #0                  /* else{ r0 <- 0} */  
    bx lr

getOp:
    ldr r0, address_of_postfixExp         /* r0 <- &postfixExp */  
    ldrb r1, [r0, r4]           /* r1 <- r0[r4] */  
    ldr r2, address_of_returnOp           /* r2 <- &returnOp */  
    mov r3, #0                  /* r3 <- 0 */  

    cmp r1, #0
    moveq r0, #0
    bxeq lr

gettingOp:
    cmp r1, #' '
    beq passSpaces

    strb r1, [r2, r3]           /* r2[r3] <- r1 */  

    add r3, r3, #1              /* r3 <- r3 + 1 */  
    add r4, r4, #1              /* r4 <- r4 + 1 */  
    ldrb r1, [r0, r4]           /* r1 <- r0[r4] */  

    b gettingOp    
passSpaces:
    add r4, r4, #1              /* r4 <- r4 + 1 */ 
    ldrb r1, [r0, r4]           /* r1 <- r0[r4] */ 
    cmp r1, #' '
    beq passSpaces
getOpEnd:
    mov r0, #' '                /* r0 <- ' ' */ 
    strb r0, [r2, r3]           /* r2[r3] <- r0 */  
    add r5, r5, #1              /* r5 <- r5 + 1 */  
    mov r0, #1                  /* r0 <- 1 */ 
    bx lr

evalPostfix:
    mov r4, #0                  /* r4 <- 0 */  
    mov r5, #0                  /* r5 <- 0 */  
    push {r4}                    

    bl getOp
evalWhile:
    cmp r0, #0
    beq evalEnd

    ldrb r0, [r2, #0]           /* r0 <- r2[0] */ 
    ldrb r10, [r2, #1]          /* r10 <- r2[1] */

    cmp r0, #'^'
    beq pfExpon

    cmp r0, #'*'
    beq pfMul

    cmp r0, #'/'
    beq pfDiv

    cmp r0, #'+'
    beq pfAdd

    cmp r0, #'-'
    cmpeq r10, #'\0'
    beq pfSub

    cmp r0, #'('
    beq errorSyntax

    mov r0, r2      //else
    mov r1, #0
    bl strtof

    vmov s0, r0
    vpush {s0}
evalWhileEnd:
    bl getOp    
    b evalWhile 

pfExpon:
    vpop {s1}
    vpop {s0}
    vcvt.f64.f32 d0, s0         /* d0 <- s0 */ 
    vcvt.f64.f32 d1, s1         /* d1 <- s1 */
    bl pow
    
    vmov.f64 d7, d0
    vcvt.f32.f64 s0, d7
    vpush {s0}
    b evalWhileEnd
pfMul:
    vpop {s0}
    vpop {s1}
    vmul.f32 s0, s0, s1         /* s0 <- s0 * s1 */ 
    vpush {s0}
    b evalWhileEnd
pfDiv:
    vpop {s1}
    vpop {s0}

    vdiv.f32 s0, s0, s1         /* s0 <- s0 / s1 */ 
    vpush {s0}
    b evalWhileEnd
pfAdd:
    vpop {s0}
    vpop {s1}
    vadd.f32 s0, s0, s1         /* s0 <- s0 + s1 */ 
    vpush {s0}
    b evalWhileEnd
pfSub:
    vpop {s1}
    vpop {s0}
    vsub.f32 s0, s0, s1         /* s0 <- s0 - s1 */ 
    vpush {s0}
    b evalWhileEnd

evalEnd:
    vpop {s1}
    vcvt.f64.f32 d0, s1
    vmov.f64 d1, d0
    vmov r2,r3, d0

    ldr r0, address_of_output             /* r0 <- &output */ 
    bl printf    

    b end
errorSyntax:
    ldr r0, address_of_syntaxErr
    bl printf
    b end

end: 
    ldr lr, address_of_return             /* lr <- &return */ 
    ldr lr, [lr]                /* lr <- *lr */ 
    bx lr

address_of_postfixExp: .word postfixExp
address_of_returnOp: .word returnOp
address_of_syntaxErr: .word syntaxErr
address_of_output: .word output
address_of_return: .word return

.global printf
.global strtof
.global pow
