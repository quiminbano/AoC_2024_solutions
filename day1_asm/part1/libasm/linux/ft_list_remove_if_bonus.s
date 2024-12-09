section .text
	global ft_list_remove_if
	extern free

ft_list_remove_if:
	test rsi, rsi
	jz return_void_list_remove_if ; Return ; if the data of reference is NULL
	test rdx, rdx
	jz return_void_list_remove_if ; Return ; if Function pointer cmp is NULL
	test rcx, rcx
	jz return_void_list_remove_if ; Return ; if Function delete pointer is NULL
	test rdi, rdi
	jz return_void_list_remove_if ; Return ; if the address of the list is NULL
	mov rax, QWORD[rdi]
	test rax, rax
	jz return_void_list_remove_if ; Return ; if the size of the list is 0
	push rbp
	mov rbp, rsp
	sub rsp, 32
	push rdi ; extra -8
	mov QWORD[rsp + 8], rax ; save the address of the head of the list
	mov QWORD[rsp + 16], 0
	mov QWORD[rsp + 24], 0

remove_if_loop:
	test rax, rax
	jz prepare_return_list
	mov rdi, QWORD[rax + 8] ; Accessing the address of the next node in list stored in rax
	mov QWORD[rsp + 16], rdi ; save the address of the next node of the list
	mov rdi, QWORD[rax] ; Charge void *content to rdi
	push rax
	push rsi
	push rdx
	push rcx
	call rdx ; Call the function charged in rdx, All the registers used are backed up
	mov rdi, rax
	pop rcx
	pop rdx
	pop rsi
	pop rax
	test rdi, rdi
	jz delete_node_list ; +8 = head, +16 = next, +24 = prev
	mov QWORD[rsp + 24], rax
	mov rax, QWORD[rsp + 16]
	jmp remove_if_loop

delete_node_list:
	push rdi
	push rsi
	push rdx
	push rcx
	mov rdi, QWORD[rax]
	push rax
	call rcx
	pop rax
	mov rdi, rax
	push rax
	call free wrt ..plt
	pop rax
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	cmp rax, QWORD[rsp + 8] ; Compare the current node address with the head of the list.
	jz replace_head_list
	mov rax, QWORD[rsp + 24]
	mov rdi, QWORD[rsp + 16]
	mov QWORD[rax + 8], rdi
	mov rax, rdi
	jmp remove_if_loop

replace_head_list:
	mov rax, QWORD[rsp + 16]
	mov QWORD[rsp + 8], rax
	jmp remove_if_loop

prepare_return_list:
	pop rdi
	mov rax, QWORD[rsp]
	mov QWORD[rdi], rax
	add rsp, 32
	mov rsp, rbp
	pop rbp
	xor rax, rax
	ret

return_void_list_remove_if:
	xor rax, rax
	ret

section .note.GNU-stack