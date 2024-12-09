section .text
	global ft_strcpy

ft_strcpy:
	push rdi
	push rsi

loop_cpy:
	mov al, [rsi]
	movsb
	cmp al, 0
	je return_cpy
	jmp loop_cpy

return_cpy:
	pop rsi
	pop rdi
	mov rax, rdi
	ret

section .note.GNU-stack