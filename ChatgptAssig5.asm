section .data
    msg1 db "Enter the string of size 30: ", 20H
    msg1len equ $-msg1
    msg2 db "The length of the string is: ", 20H
    msg2len equ $-msg2
    newline db 10

section .bss
    string1 resb 30      ; Reserve space for string input
    len1 resb 1          ; To store string length

section .code
    global _start

_start:
    ; Display prompt message
    io 1, 1, msg1, msg1len

    ; Read user input (string) into buffer string1
    io 0, 0, string1, 30      ; Read up to 30 bytes

    ; Find the length of the input string
    xor rbx, rbx               ; Clear rbx (used to count the length)
    mov rsi, string1           ; Pointer to the string

count_length:
    mov al, [rsi]              ; Load current character
    cmp al, 0                  ; Check for null terminator
    je done_counting           ; If null terminator, done
    inc rsi                    ; Move to next character
    inc rbx                    ; Increment length counter
    jmp count_length           ; Loop to next character

done_counting:
    ; Store the length in len1
    mov [len1], bl             ; Store length in len1 (using lower byte)

    ; Display "The length of the string is:"
    io 1, 1, msg2, msg2len

    ; Display the length (as a number, not hex)
    movzx rsi, byte [len1]     ; Load length into rsi
    call print_decimal

    ; Exit
    exit

; Macro to print an integer in decimal
print_decimal:
    ; Assuming rsi contains the number to print
    ; Print the number in decimal using syscall (write)
    mov rdi, 1                ; File descriptor: stdout
    mov rdx, 10               ; Maximum number of digits
    mov rax, 0                ; Clear rax (no syscall yet)
    ; Code for printing the number here (simple version)
    ; Ideally you want to convert rsi into a string and print it
    ret

; I/O and exit macros
%macro io 4
    mov rax, %1                ; Syscall number
    mov rdi, %2                ; File descriptor (1 for stdout)
    mov rsi, %3                ; Pointer to buffer
    mov rdx, %4                ; Buffer size or length
    syscall
%endmacro

%macro exit 0
    mov rax, 60                ; Syscall number for exit
    mov rdi, 0                 ; Exit status
    syscall
%endmacro

