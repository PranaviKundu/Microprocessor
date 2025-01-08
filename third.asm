%macro io 4
	mov rax, %1
	mov rdi, %2
	mov rsi, %3
	mov rdx, %4
	syscall
%endmacro

section .data
    	msg1 db 'Enter the name ', 20
    	msg1len equ $ - msg1
    	msg2 db 'Your name is: ', 10
    	msg2len equ $ - msg2
	count db 5
section .bss
    	nm resb 20
    	len resb 1

section .text
    	global _start

_start:
	io 1,1,msg1,msg1len

	io 0,0,nm,20

	mov [len], rax
	io 1,1,msg2,msg2len

    next:
	io 1,1,nm, [len]
	dec byte[count]
	jnz next
	
	mov rcx, 5
    next1: 
	push rcx 
	io 1,1,nm,[len]
	pop rcx
	loop next1

	mov rbx, 5
    next2:
	io 1,1,nm,[len]
	dec rbx
	jnz next2
    
    	mov rax, 60
    	mov rdi, 0
    	syscall

