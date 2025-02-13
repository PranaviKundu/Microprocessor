;---------------------------------------------------------------
; Problem Statement: Write an x86-64 Assembly Language Program (ALP) 
; to accept 5 hexadecimal numbers from the user, store them in an array,
; and display the accepted numbers.
;
; Author: Pranavi Kundu
; Roll No: 7240
;---------------------------------------------------------------

%macro io 4                 ; Macro for syscall-based input/output operations
    mov rax, %1            ; Syscall number
    mov rdi, %2            ; File descriptor (0: stdin, 1: stdout)
    mov rsi, %3            ; Buffer address
    mov rdx, %4            ; Buffer length
    syscall                ; Invoke syscall
%endmacro

%macro exit 0               ; Macro for exiting the program
    mov rax,60             ; Syscall number for exit
    mov rdi,0              ; Exit status 0 (success)
    syscall                ; Invoke syscall
%endmacro

section .data
    msg1 db "Write an x86/64 ALP to accept 5 hexadecimal numbers from user and store them in an array and display the accepted numbers",10,'Name - Pranavi Kundu', 10 ,'Roll no - 7240',10
    msg1len equ $-msg1
    msg2 db "Enter 5 64-bit hexadecimal numbers (16 hex digits each, 0-9,A-F only): ", 10
    msg2len equ $-msg2
    msg3 db "5 64-bit hexadecimal numbers are: ", 10
    msg3len equ $-msg3
    newline db 10          ; Newline character

section .bss
    asciinum resb 17       ; Buffer to store ASCII input (16 hex digits + newline)
    hexnum resq 5          ; Array to store five 64-bit numbers

section .text
    global _start

_start:
    io 1,1,msg1,msg1len     ; Display problem statement and author details
    io 1,1,msg2,msg2len     ; Prompt user for input

    mov rcx,5               ; Loop counter for 5 numbers
    mov rsi,hexnum          ; Pointer to hexnum array

next1:
    push rsi                ; Save register values
    push rcx
    io 0,0,asciinum,17      ; Read hexadecimal input from user
    call ascii_hex64        ; Convert ASCII to 64-bit hex
    pop rcx                 ; Restore loop counter
    pop rsi                 ; Restore pointer
    mov [rsi],rbx           ; Store converted number in array
    add rsi,8               ; Move to next array position
    loop next1              ; Repeat for 5 numbers

    io 1,1,msg3,msg3len     ; Display message before printing stored numbers

    mov rsi,hexnum          ; Reset pointer to array
    mov rcx,5               ; Loop counter for 5 numbers

next2:
    push rsi                ; Save register values
    push rcx
    mov rbx,[rsi]           ; Load number from array
    call hex_ascii64        ; Convert and display number
    pop rcx                 ; Restore loop counter
    pop rsi                 ; Restore pointer
    add rsi,8               ; Move to next number
    loop next2              ; Repeat for 5 numbers

    exit                    ; Exit the program

;---------------------------------------------------------------
; Function: ascii_hex64
; Converts a 16-character ASCII hexadecimal string into a 64-bit number.
; Input: asciinum buffer (16 ASCII characters)
; Output: rbx (converted 64-bit number)
;---------------------------------------------------------------
ascii_hex64:
    mov rsi, asciinum      ; Load ASCII buffer address
    mov rbx,0              ; Clear rbx (to store the converted value)
    mov rcx,16             ; Loop counter for 16 hex digits
next3:
    mov al,[rsi]           ; Load a character from buffer
    cmp al,'9'             ; Check if it is a digit (0-9)
    jbe sub30h             ; If so, jump to adjust ASCII to numeric
    sub al,7h              ; Convert A-F to their numeric values
sub30h:
    sub al,'0'             ; Convert ASCII to numeric value
    and al,0Fh             ; Mask the lower nibble
    shl rbx,4              ; Shift left by 4 bits to make space for next digit
    or rbx,rax             ; Add to result
    inc rsi                ; Move to next character
    loop next3             ; Repeat for all 16 characters
    ret                    ; Return

;---------------------------------------------------------------
; Function: hex_ascii64
; Converts a 64-bit number into a 16-character ASCII hexadecimal string.
; Input: rbx (64-bit number to be converted)
; Output: asciinum buffer (ASCII representation of the number)
;---------------------------------------------------------------
hex_ascii64:
    mov rsi,asciinum      ; Load buffer address
    mov rdx,rbx           ; Copy original number to rdx
    mov rcx,16            ; Loop counter for 16 hex digits
    add rsi,15            ; Move pointer to end of buffer
    mov byte [rsi],10     ; Null terminator (new line)
    dec rsi               ; Adjust to last character position
next4:
    mov rax,rdx           ; Copy rdx to rax
    and rax,0Fh           ; Mask the lowest 4 bits
    cmp al,9              ; Check if the value is 0-9
    jbe add30h            ; If so, jump to add '0'
    add al,7h             ; Convert to A-F
add30h:
    add al,'0'            ; Convert to ASCII
    mov [rsi],al          ; Store character in buffer
    shr rdx,4             ; Shift right to get the next nibble
    dec rsi               ; Move buffer pointer backwards
    loop next4            ; Repeat for all 16 hex digits
    io 1,1,asciinum,17    ; Print the converted hexadecimal number (including newline)
    ret                    ; Return
