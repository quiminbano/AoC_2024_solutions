section .text
	global _ft_list_size

_ft_list_size:
	xor rcx, rcx
	test rdi, rdi
	jz _list_size_protection
	push rdi

_loop_list_size:
	test rdi, rdi
	jz _return_list_size
	inc rcx
	mov rdi, QWORD[rdi + 8]
	jmp _loop_list_size

_return_list_size:
	pop rdi
	mov rax, rcx
	xor rcx, rcx
	ret

_list_size_protection:
	xor rax, rax
	ret