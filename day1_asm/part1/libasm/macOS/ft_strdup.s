section .text
	global _ft_strdup
	extern _ft_strlen
	extern _ft_strcpy
	extern _malloc

_ft_strdup:
	call _ft_strlen
	inc rax
	push rdi
	mov rdi, rax
	xor rax, rax
	call _malloc
	test rax, rax
	jz _malloc_protection_dup
	mov rdi, rax
	xor rax, rax
	pop rsi
	call _ft_strcpy
	ret

_malloc_protection_dup:
	pop rdi
	xor rax, rax
	ret

