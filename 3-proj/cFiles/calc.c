#include <stdio.h>
#include <stdlib.h>

char stack[100];     //for getting postfix expression
float evalStack[20]; //for evaluating postfix expression
int top = -1;
char postfix[100];   //hold the postfix expression

void push(char x){
    stack[++top] = x;
}
char pop(){
        return stack[top--]; 
}
int precedence(char operator){
    if(operator == '^'){
        return 4;
    }else if(operator == '*' || operator == '/'){
        return 3;
    }else if(operator == '+' || operator == '-'){
        return 2;
    }else if (operator == '(' || operator == ')'){
        return 1; 
    }
    return 0; //if char is not an operator
}

void addChar(char c){
    static char *pf = postfix;
    *(pf++) = c;
}
void infixToPostfix(char *infix){
    char *c = infix; 

    while(*c != '\0'){
        int prece = precedence(*c);
        char x; //place holder

        if (prece > 1) addChar(' ');

        if(prece == 0){
            addChar(*c);
        }else if(*c == '('){
            push(*c);
        }else if(*c == ')'){
            while((x = pop()) != '('){
                addChar(' ');
                addChar(x);
            }
        }else {
            while(prece <= precedence(stack[top])){
                addChar(pop());
                addChar(' ');
            }
            push(*c);
        }        
        c++;
    }
    while(top !=  -1) {
        addChar(' ');
        addChar(pop());
    }
    addChar(' ');
}

/* obsolete in assembly  */
void pushEval(float num){
    evalStack[top++] = num;
}
float popEval(){
    if(top == 0){
        printf("ERR:SYNTAX\n");
        exit(3);
    }
    return evalStack[--top];
}
char getNext(char *returnOp){ // works
    static char *iop = postfix; //iop is the index of operator expression
   
    char *p = returnOp;
    if(*iop == '\0'){
        return '\0'; //reached end of postfix expression
    }   

    while(*iop != ' '){
        *(p++) = *(iop++);
    }  
    
    while(*(++iop) == ' '); //go through spaces until beginning of next work

    *(p++) = '\0';
    return '1';
}
void evalPostfix(char *postExp){
    float op1, op2, value;
    top = 0;        //reset top variable
    char wordStore[20];

    while(getNext(wordStore) != '\0'){
        switch(*wordStore){
            case '^':
                value = 1;
                op2 = popEval();
                op1 = popEval();
                for(int i = 0; i < op2; i++) value *= op1;
                pushEval(value); 
                break;
            case '*':
                pushEval((popEval() * popEval()));
                break;
            case '/':
                if ((op2 = popEval()) == 0){
                    printf("ERR:DIVIDE BY 0\n");
                    exit(0);
                }
                pushEval((popEval() / op2));
                break;
            case '+':
                pushEval((popEval() + popEval()));
                break;
            case '-':
                op2 = popEval();
                pushEval((popEval() - op2));
                break;
            case '(':
                printf("ERR:SYNTAX\n");
                exit(2);
                return;
            default:
                pushEval(strtof(wordStore, NULL));
                break;
        }
    }
    printf("calculated value is: %f\n", popEval());
}

int main(int argc, char *argv[]){
    char *infix = argv[1];//"(1+2)*3-4"  "3+4*2-3"

    /* zero out string {NOT NEEDED IN ASSEMBLY} */    
    char *p;
    for(p = postfix; p < &postfix[100]; p++){
        *p = 0;
    }

    infixToPostfix(infix);
    evalPostfix(postfix);

    return 0;
}
