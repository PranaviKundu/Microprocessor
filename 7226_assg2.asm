;---------------------------------------------------------------
; Problem Statement: Write an x86-64 Assembly Language Program (ALP) 
; to accept a string from the user and display its length.
;
; Author: Jatin Yadav
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
    length db 0            ; Variable to store string length
    msg1 db "Problem Statement: Write an x86-64 Assembly Language Program (ALP) to accept a string from the user and display its length.",10, "Author: Jatin Yadav, Roll No: 7226",10 ,"Enter the string: ",10  ; Message prompting user input
    msg1len equ $-msg1     ; Length of msg1
    msg2 db "Length of entered string without loop is: ",10  ; Message for direct length display
    msg2len equ $-msg2     ; Length of msg2
    msg3 db "Length of entered string with loop is: ",10  ; Message for computed length
    msg3len equ $-msg3     ; Length of msg3
    newline db 10          ; Newline character

section .bss
    string1 resb 30        ; Buffer to store user input string (max 30 bytes)
    ascii_num resb 2       ; Buffer to store ASCII converted length

section .text
    global _start

_start:
    io 1,1,msg1,msg1len     ; Display "Enter the string: " message
    io 0,0,string1,30       ; Read string input from user

    dec rax                 ; Adjusting for newline character
    mov rbx, rax            ; Store length in RBX

    io 1,1,msg2,msg2len     ; Display message for direct length
    call hex_ascii8         ; Convert and display length

    mov rsi, string1        ; Load string address into RSI for iteration

back:
    mov al, [rsi]           ; Load character from string
    cmp al, 10              ; Check for newline character
    je skip                 ; If newline, exit loop
    inc byte[length]        ; Increment length counter
    inc rsi                 ; Move to next character
    loop back               ; Repeat until end of string

skip:
    mov bl, [length]        ; Move computed length to BL
    io 1,1,msg3,msg3len     ; Display message for computed length
    call hex_ascii8         ; Convert and display length

    mov rax, 60             ; Syscall to exit program
    mov rdi, 1              ; Exit status
    syscall

hex_ascii8:
    mov rdi, ascii_num      ; Load address of ASCII buffer
    mov rcx, 2              ; Loop counter for 2-digit hex

lbl:
    rol bl, 4               ; Rotate left by 4 bits
    mov al, bl              ; Copy rotated value to AL
    and al, 0FH             ; Mask lower 4 bits
    cmp al, 9               ; Check if digit is 0-9
    jbe add30H              ; If yes, jump to add 30H
    add al, 7H              ; Adjust for A-F range

add30H:
    add al, 30H             ; Convert to ASCII
    mov [rdi], al           ; Store character in buffer
    inc rdi                 ; Move buffer pointer
    dec rcx                 ; Decrement loop counter
    jnz lbl                 ; Repeat if counter > 0

    io 1,1,ascii_num,2      ; Print ASCII number
    io 1,1,newline,1        ; Print newline
    ret                     ; Return from function

