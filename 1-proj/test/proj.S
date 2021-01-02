/* -- proj1.S */
.data

/* error code if total number of charactrers exceed 10 character limit */
.balign 4
error_code: .asciz "Error Code: %d\n"

/* variables that will store the entered strings*/
.balign 4
string1: .space 11 
.balign 4
string2: .space 11

/* count characters in string and string2*/
.balign 4
char_count: .word 0
.balign 4
char_count2: .word 0

/* Message of the concatenated string */
.balign 4
output: .asciz "%s%s\nThe size of output is: %d\n"

/* fgets messages */
.balign 4
fgets_msg: .asciz "Oi, enter a string: "
.balign 4
fgets_msg2: .asciz "Enter another string: "

/* return code of program */
.balign 4
return_code: .word 0 

.text
.global main
main:
    ldr r1, =return_code    @store value of lr in return_code
    str lr, [r1]            @so the program can be propely stopped
    
    mov r5, #0              @sets error checking reg to 0   

    ldr r0, =fgets_msg      @ask user to enter first string
    bl printf

    ldr r0, =string1        @get first string from user
    bl get_string

    ldr r0, =string1
    ldr r1, =char_count        
    bl count_char           @determines if input string is <11       
    cmp r5, #111            @if <11 then output error
    beq error21
   
    ldr r0, =fgets_msg2     @ask user to input second string
    bl printf
 
    ldr r0, =string2        @receive second string from user
    bl get_string

    ldr r0, =string2
    ldr r1, =char_count2
    bl count_char           @determines if input string is <11
    cmp r5, #111            @if string2 <11 then output error
    beq error22
    
    ldr r3, =char_count     @load length of string1 
    ldr r3, [r3]
    ldr r4, =char_count2    @load length of string2
    ldr r4, [r4]
    add r3, r3, r4          @add length to get final length

    ldr r0, =output
    ldr r1, =string1        @concatenate the two inputted strings
    ldr r2, =string2        @and output the result
    bl printf

    b end

get_string:
    push {lr}               @store lr of main before calling printf
    
    mov r1, #12             @receive size of string to be inputted
    ldr r2, get_stdin       @receive address of stdin
    ldr r2, [r2]            @receive value of stdin
    bl fgets
    
    pop {lr}                @return back to main
    bx lr

count_char:
    
    mov r5, r1              @get character at index char_count/char_count2
    ldr r5, [r5]            @get value of index
    ldrb r6, [r0, r5]
    
    cmp r6, #10             @check if char='\n'
    beq get_out             @branch out

    cmp r5, #10             @if input string is >=11: error
    bge error

    add r5, r5, #1          @increment char_count
    str r5, [r1]            @store new value of char_count
     
    b count_char

get_out:
    mov r5, r1
    ldr r5, [r5]
    mov r6, #0
    strb r6, [r0, r5]       @replace newline with null 
    bx lr 

error:
    mov r5, #111            @arbitrary error value 
    bx lr

error21:
    ldr r0, =error_code 
    mov r1, #21             @display "Error Code: 21"
    bl printf
    b end 

error22:
    ldr r0, =error_code
    mov r1, #22             @dispaly "Error Code: 22"
    bl printf
    b end 

end:
    mov r0, r1
    ldr lr, =return_code    @properly end the program 
    ldr lr, [lr]            @by branching back to 
    bx lr                   @initial value of lr

get_stdin: .word stdin

/* External */
.global printf
.global fgets    
