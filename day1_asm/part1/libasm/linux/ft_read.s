SYS_READ equ 0

section .text
	global ft_read
	extern __errno_location

ft_read:
	mov rax, SYS_READ
	syscall
	cmp rax, 0
	jl error_read

success_read:
	ret

error_read:
	neg rax
	push rdi
	mov rdi, rax
	call __errno_location wrt ..plt
	test rax, rax
	jz error_protection_read
	mov [rax], rdi
	pop rdi
	mov rax, -1
	ret

error_protection_read:
	pop rdi
	xor rax, rax
	ret

section .note.GNU-stack