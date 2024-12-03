section .bss
	line resb 4096
	buffer resb 2


section .text
	global _start
	extern atoi

_start:
	push rbp
	mov rbp, rsp
	sub rsp, 16
	add rsp, 16
	mov rsp, rbp
	pop rbp
	xor rax, rax
	ret

extract_line:
	push rbp
	mov rbp, rsp
	sub rsp, 16
reading_loop:
	mov rax, 0
	lea rsi, [rel buffer]
	mov rdx, 1
	syscall
	cmp rax, rdx
	jl return_value
	jmp reading_loop
return_value:
	mov rax, [rsp]
	add rsp, 16
	mov rsp, rbp
	pop rbp
	ret

section .note.GNU-stack
