section .text
	global ft_strlen

ft_strlen:
	xor rcx, rcx

loop_len:
	mov al, [rdi + rcx]
	cmp al, 0
	je return_len
	inc rcx
	jmp loop_len

return_len:
	mov rax, rcx
	xor rcx, rcx
	ret

section .note.GNU-stack
