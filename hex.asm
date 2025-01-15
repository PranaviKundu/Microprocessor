%macro io 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro

section .data
	msg1 db "Enter: ",20H
	msg1len equ $-msg1
	msg2 db "Number: ",20H
	msg2len equ $-msg2

section .bss
	ascii resb 17
	num resq 1

section .code
global _start
	_start:
		io 1,1,msg1,msg1len
		io 0,0,ascii,17

		call ascii_hex64
		mov [num],rbx
		io 1,1,msg2,msg2len
		mov rbx,[num]
		call hex_ascii64

		mov rax,60
		mov rdi,0
		syscall

ascii_hex64:
	mov rsi,ascii

	mov rbx,0
	mov rcx,16

	next1:
		rol rbx,4
		mov al,[rsi]
		cmp al,39H
		jbe sub30h
		sub al,7H

		sub30h:
			sub al,30H
			add bl,al
			inc rsi
	loop next1
ret

hex_ascii64:
	mov rsi,ascii
	mov rcx,16

	next2:
		rol rbx,4
		mov al,bl
		and al,0fh
		cmp al,9
		jbe add30h
		add al,7H

		add30h:
			add al,30H
			mov [rsi],al
			inc rsi
	loop next2
		io 1,1,ascii,16
	ret


