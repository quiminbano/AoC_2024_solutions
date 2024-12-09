section .data
	global skip_numbers
	extern ft_isdigit

skip_numbers:
	push rbp
	mov rbp, rsp
	sub rsp, 16
	xor rcx, rcx
loop_skip_numbers:
	push rdi
	movzx rsi, BYTE[rdi + rcx]
	mov rdi, rsi
	call ft_isdigit
	pop rdi
	test eax, eax
	jz end_skip_numbers
	inc rcx
	jmp loop_skip_numbers
end_skip_numbers:
	mov rax, rdi
	add rax, rcx
	add rsp, 16
	mov rsp, rbp
	pop rbp
	ret

section .note.GNU-stack
