section .text
	global ft_list_sort

ft_list_sort:
	test rdi, rdi
	jz return_nothing_list_merge ; returns ; if t_list ** is NULL
	test rsi, rsi
	jz return_nothing_list_merge ; returns ; if the cmp function pointer is NULL
	mov rax, QWORD[rdi]
	test rax, rax
	jz return_nothing_list_merge ; returns ; if the list size is 0
	cmp QWORD[rax + 8], 0
	je return_nothing_list_merge ; returns ; if the list size is 1
	push rbp
	mov rbp, rsp
	sub rsp, 24
	mov QWORD[rsp], rax ; Head of the list
	mov QWORD[rsp + 8], 0 ; Pointer to list_a setted to NULL
	mov QWORD[rsp + 16], 0 ; Pointer to list_b setted to NULL
	push rdi ; backs up the address of the list in the stack memory
	push rsi ; backs up the address of the cmp function in the stack memory
	mov rdi, QWORD[rsp + 16] ; Now: Head list = +16, list_a = +24, list_b = +32
	lea rsi, [rsp + 24]
	lea rdx, [rsp + 32]
	call split_list_sort
	pop rsi
	push rsi
	lea rdi, [rsp + 24]
	call ft_list_sort
	pop rsi
	push rsi
	lea rdi, [rsp + 32]
	call ft_list_sort
	pop rsi
	push rsi
	mov rdx, rsi
	mov rdi, QWORD[rsp + 24]
	mov rsi, QWORD[rsp + 32]
	call merge_lists
	pop rsi
	pop rdi
	mov QWORD[rdi], rax
	add rsp, 24
	mov rsp, rbp
	pop rbp
	xor rax, rax
	ret

return_nothing_list_merge:
	xor rax, rax
	ret

split_list_sort:
	push rbp
	mov rbp, rsp
	sub rsp, 16
	mov QWORD[rsp], rdi ; Stores the head of the list in slow
	mov rax, QWORD[rdi + 8] ; store the next node memory address in rax
	mov QWORD[rsp + 8], rax ; Copies the next node memory address in the stack from rax (fast)
	loop_split_list_sort:
		mov rax, QWORD[rsp + 8]
		test rax, rax
		jz assign_split_list_sort
		push rdi
		mov rdi, QWORD[rax + 8]
		mov QWORD[rsp + 16], rdi
		pop rdi
		mov rax, QWORD[rsp + 8]
		test rax, rax
		jz loop_split_list_sort
		push rdi
		mov rdi, QWORD[rax + 8]
		mov QWORD[rsp + 16], rdi
		mov rdi, QWORD[rsp + 8]
		mov rax, QWORD[rdi + 8]
		mov QWORD[rsp + 8], rax
		mov rax, QWORD[rsp + 16]
		pop rdi
		jmp loop_split_list_sort
	assign_split_list_sort:
		mov QWORD[rsi], rdi
		mov rax, QWORD[rsp]
		push rdi
		mov rdi, QWORD[rax + 8]
		mov rax, rdi
		pop rdi
		mov QWORD[rdx], rax
		mov rax, QWORD[rsp]
		mov QWORD[rax + 8], 0
		xor rax, rax
		add rsp, 16
		mov rsp, rbp
		pop rbp
		ret

merge_lists:
	test rdi, rdi
	jz return_rsi
	test rsi, rsi
	jz return_rdi
	push rbp
	mov rbp, rsp
	sub rsp, 8
	mov QWORD[rsp], 0
	push rdi
	push rsi
	push rdx
	mov rdi, QWORD[rdi]
	mov rsi, QWORD[rsi]
	xor rax, rax
	call rdx
	pop rdx
	pop rsi
	pop rdi
	cmp eax, 1
	jge resolve_b
	mov QWORD[rsp], rdi
	push rsi
	push rdx
	push rdi
	mov rdi, QWORD[rdi + 8]
	xor rax, rax
	call merge_lists
	mov rdi, QWORD[rsp + 24]
	mov QWORD[rdi + 8], rax
	pop rdi
	pop rdx
	pop rsi
	mov rax, QWORD[rsp]
	add rsp, 8
	mov rsp, rbp
	pop rbp
	ret
	resolve_b:
		mov QWORD[rsp], rsi
		push rdi
		push rdx
		push rsi
		mov rsi, QWORD[rsi + 8]
		call merge_lists
		mov rsi, QWORD[rsp + 24]
		mov QWORD[rsi + 8], rax
		pop rsi
		pop rdx
		pop rdi
		mov rax, QWORD[rsp]
		add rsp, 8
		mov rsp, rbp
		pop rbp
		ret
	return_rsi:
		mov rax, rsi
		ret
	return_rdi:
		mov rax, rdi
		ret

section .note.GNU-stack