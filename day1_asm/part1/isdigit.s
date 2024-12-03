section .text
	global isdigit

isdigit:
	push rbp
	mov rbp, rsp
	sub rsp, 16
	cmp edi, 48
	jl return_zero_id
	cmp edi, 57
	jg return_zero_id
	jmp return_one_id

return_one_id:
	add rsp, 16
	mov rsp, rbp
	pop rbp
	mov rax, 1
	ret

return_zero_id:
	add rsp, 16
	mov rsp, rbp
	pop rbp
	xor rax, rax
	ret

section .note.GNU-stack
