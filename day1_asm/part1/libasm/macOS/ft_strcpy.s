section .text
	global _ft_strcpy

_ft_strcpy:
	push rdi
	push rsi

_loop_cpy:
	mov al, [rsi]
	movsb
	cmp al, 0
	je _return_cpy
	jmp _loop_cpy

_return_cpy:
	pop rsi
	pop rdi
	mov rax, rdi
	ret
