%macro io 4
    mov rax,%1
    mov rdi,%2
    mov rsi,%3
    mov rdx,%4
    syscall
%endmacro

%macro exit 0
    mov rax,60      
    mov rdi,0         
    syscall
%endmacro

section .data
    msg1 db "Enter number 1:",10
    msg1len equ $-msg1
    msg2 db "Enter number 2:",10
    msg2len equ $-msg2
    menu db "******MENU******",10,"1. Addition",10,"2. Subtraction",10,"3. Multiplication",10,"4. Division",10,"5. Exit",10
    menulen equ $-menu
    result_msg db "Result: ",10
    result_msg_len equ $-result_msg

section .bss
    num1 resb 2
    num2 resb 2
    in resb 2
    result resb 2

section .text
    global _start
    _start:
        ; Get first number
        io 1,1,msg1,msg1len
        io 0,0,num1,2

        ; Get second number
        io 1,1,msg2,msg2len
        io 0,0,num2,2

    next:
        ; Display the menu
        io 1,1,menu,menulen
        io 0,0,in,2

        cmp byte [in], '1'
        je add_numbers

        cmp byte [in], '2' 
        je sub_numbers

        cmp byte [in], '3'  
        je mul_numbers

        cmp byte [in], '4' 
        je div_numbers

        cmp byte [in], '5'  
        exit
        
        jmp next
        
    add_numbers:
    	mov al,[num1]
    	sub al,'0'
    	mov bl,[num2]
    	sub bl,'0'
    	add al,bl
    	io 1,1,result_msg,result_msg_len
    	mov [result],al
    	io 1,1,result,1
    	
    sub_numbers:
    	mov al,[num1]
    	sub al,'0'
    	mov bl,[num2]
    	sub bl,'0'
    	sub al,bl
    	io 1,1,result_msg,result_msg_len
    	mov [result],al
    	io 1,1,result,1

