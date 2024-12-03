section .text
	global isspace

isspace:
	push rbp
	mov rbp, rsp
	sub rsp, 16
	cmp edi, 32
	je return_one_sp
	cmp edi, 14
	jge return_zero_sp
	cmp edi, 8
	jle return_zero_sp
	jmp return_one_sp

return_one_sp:
	add rsp, 16
	mov rsp, rbp
	pop rbp
	mov rax, 1
	ret

return_zero_sp:
	add rsp, 16
	mov rsp, rbp
	pop rbp
	xor rax, rax
	ret

section .note.GNU-stack
