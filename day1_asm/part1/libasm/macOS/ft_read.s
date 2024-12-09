SYS_WRITE equ 0x2000003

section .text
	global _ft_read
	extern ___error

_ft_read:
	mov rax, SYS_WRITE
	syscall
	jc _error_read

_success_read:
	ret

_error_read:
	push rdi
	mov rdi, rax
	call ___error
	test rax, rax
	jz _error_protection_read
	mov [rax], rdi
	pop rdi
	mov rax, -1
	ret

_error_protection_read:
	pop rdi
	xor rax, rax
	ret
