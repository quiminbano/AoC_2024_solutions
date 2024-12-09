SYS_WRITE equ 1

section .text
	global ft_write
	extern __errno_location

ft_write:
	mov rax, SYS_WRITE
	syscall
	cmp rax, 0
	jl error_write

success_write:
	ret

error_write:
	neg rax
	push rdi
	mov rdi, rax
	call __errno_location wrt ..plt
	test rax, rax
	jz error_protection_write
	mov [rax], rdi
	pop rdi
	mov rax, -1
	ret

error_protection_write:
	pop rdi
	xor rax, rax
	ret

section .note.GNU-stack