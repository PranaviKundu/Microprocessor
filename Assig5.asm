;Assig2: Write an X86/64 ALP to accept a string and to display its length

%macro io 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro
%macro exit 0
	mov rax,60
	mov rdi, 0
	syscall
%endmacro
section .data
	msg1 db "Enter the string of size 30: ",20H
	msg1len equ $-msg1
	msg2 db "The length of the string is: ",20H
	msg2len equ $-msg2
	msg3 db "step1",10H
	msg3len equ $-msg3
	msg4 db "step 2",10H
	msg4len equ $-msg4
	newline db 10
	
section .bss
	string1 resb 30
	len1 resb 1
	len2 resb 1
	lenca resb 2
section .code
	global _start
	_start:
		io 1,1,msg1,msg1len
		io 0,0, string1, 20
		dec rax
		mov [len1],rax
		io 1,1,msg3, msg3len
		io 1,1,msg2,msg2len
		mov bl,[len1]
		call hex_ascii64
		io 1,1,msg4,msg4len
		mov rcx, [len1]
		next1:
			mov rsi,string1
			mov al,[rsi]
			mov al,10
			jne inby
			inby:
				inc byte[len2]
				loop next1
			io 1,1, msg2,msg2len
			mov bl,[len2]
			call hex_ascii64
			exit
		hex_ascii64:
			mov rsi, lenca
			mov rcx,7
			next2:
				rol rbx,4
				mov al,bl
				and al,0Fh
				cmp al,9
				jbe add30h
				add al,7H
			add30h:
				add al,30H
				mov [rsi],al
				inc rsi
			loop next2
				io 1,1,lenca,2
				io 1,1,newline,1
			ret



		
