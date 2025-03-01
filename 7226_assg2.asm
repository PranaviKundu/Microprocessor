;---------------------------------------------------------------
; Problem Statement: Write an x86-64 Assembly Language Program (ALP) 
; to accept a string from the user and display its length.
;
; Author: Pranavi Kundu
; Roll No: 7226
;---------------------------------------------------------------

%macro io 4                 ; Macro for syscall-based input/output operations
    mov rax, %1            ; Syscall number
    mov rdi, %2            ; File descriptor (0: stdin, 1: stdout)
    mov rsi, %3            ; Buffer address
    mov rdx, %4            ; Buffer length
    syscall                ; Invoke syscall
%endmacro

section .data
    msg1 db "Problem Statement: Write an x86-64 Assembly Language Program (ALP) to accept a string from the user and display its length.",10, "Name: Pranavi Kundu, Roll No: 7240",10 ,"Enter the string: ",10  
    msg1len equ $-msg1

    msg2 db "Length of entered string (syscall result): ",10  
    msg2len equ $-msg2

    msg3 db "Length of entered string (loop count): ",10  
    msg3len equ $-msg3

    newline db 10          ; Newline character

section .bss
    string1 resb 30        ; Buffer to store user input string (max 30 bytes)
    length resb 1          ; Store computed length
                           ;resb stands for "Reserve Bytes".
                           ;It is used in the .bss section, which is for uninitialized variables.

section .text
    global _start

_start:
    io 1,1,msg1,msg1len     ; Display problem statement and prompt

    io 0,0,string1,30       ; Read string input from user
    mov rbx, rax            ; Store syscall result (bytes read)rax will be used for other operations later (like function calls or another syscall).
                            ;If we don’t move rax, its value might be overwritten by the next operation.
    io 1,1,string1,rbx      ; Print the user input (echo user input)


    dec rbx                 ; Adjust length (ignoring newline character when user press "enter")

    io 1,1,msg2,msg2len     ; Display message for syscall-based length
    call print_decimal      ; Print syscall-based length

    ; Reset length for manual computation
    mov rsi, string1        ; Load string address into RSI
    mov rcx, 0              ; Initialize counter

count_loop:
    mov al, [rsi]           ; Load character
    cmp al, 10              ; Check for newline character
    je done_count           ; If newline, end loop
    inc rcx                 ; Increment count
    inc rsi                 ; Move to next character
    jmp count_loop          ; Repeat

done_count:
    mov [length], cl        ; Store computed length
                            ;cl is the lowest 8 bits of rcx, which is enough to store small numbers (≤ 255).

    io 1,1,msg3,msg3len     ; Display message for computed length
    movzx rbx, byte[length] ; Load length from memory. movzx (Move with Zero-Extend) is an x86-64 instruction that moves a smaller-sized value into a larger register while filling the extra bits with zeros.
    call print_decimal      ; Print length
                            ;[length] refers to a memory location that holds a single byte (since we defined it as resb 1).
                            ;But the function print_decimal expects a number in a register (rbx).so we can not [length[in place of rbx

    mov rax, 60             ; Syscall to exit
    mov rdi, 0              ; Exit status
    syscall

;---------------------------------------------------------------
; Function: print_decimal
; Converts a number in RBX to ASCII decimal and prints it.
;---------------------------------------------------------------
print_decimal:
    mov rsi, rsp            ; Use stack as buffer
    sub rsi, 32             ; Move to a safe location
    mov rcx, 0              ; Counter for digits

convert_loop:
    mov rdx, 0              ; Clear RDX before division
    mov rax, rbx            ; Move number to RAX
    mov rbx, 10             ; Divisor
    div rbx                 ; Divide RAX by 10, quotient in RAX, remainder in RDX
    add dl, '0'             ; Convert remainder to ASCII
    dec rsi                 ; Move buffer pointer
    mov [rsi], dl           ; Store ASCII character
    inc rcx                 ; Increase digit count
    test rax, rax           ; Check if quotient is 0
    jnz convert_loop        ; If not, continue

    io 1,1,rsi,rcx          ; Print the ASCII decimal number
    io 1,1,newline,1        ; Print newline
    ret                     ; Return
