section .text
	global ft_list_push_front
	extern malloc

ft_list_push_front:
	test rdi, rdi
	jz no_context_push_front
	push rdi
	mov rdi, rsi
	call ft_create_elem
	pop rdi
	test rax, rax
	jz no_context_push_front
	push rsi
	mov rsi, QWORD[rdi]
	mov QWORD[rax + 8], rsi
	pop rsi
	mov QWORD[rdi], rax
	xor rax, rax
	ret


ft_create_elem:
	push rdi
	push rsi
	mov rdi, 16
	call malloc wrt ..plt
	pop rsi
	pop rdi
	test rax, rax
	jz no_context_push_front
	mov QWORD[rax], rdi
	mov QWORD[rax + 8], 0
	ret

no_context_push_front:
	xor rax, rax
	ret

section .note.GNU-stack