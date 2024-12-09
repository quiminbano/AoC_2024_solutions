section .text
	global ft_list_size

ft_list_size:
	xor rcx, rcx
	test rdi, rdi
	jz list_size_protection
	push rdi

loop_list_size:
	test rdi, rdi
	jz return_list_size
	inc rcx
	mov rdi, QWORD[rdi + 8]
	jmp loop_list_size

return_list_size:
	pop rdi
	mov rax, rcx
	xor rcx, rcx
	ret

list_size_protection:
	xor rax, rax
	ret

section .note.GNU-stack