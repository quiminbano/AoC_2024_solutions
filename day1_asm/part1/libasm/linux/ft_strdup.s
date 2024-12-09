section .text
	global ft_strdup
	extern ft_strlen
	extern ft_strcpy
	extern malloc

ft_strdup:
	call ft_strlen
	inc rax
	push rdi
	mov rdi, rax
	xor rax, rax
	call malloc wrt ..plt
	test rax, rax
	jz malloc_protection_dup
	mov rdi, rax
	xor rax, rax
	pop rsi
	call ft_strcpy
	ret

malloc_protection_dup:
	pop rdi
	xor rax, rax
	ret

section .note.GNU-stack