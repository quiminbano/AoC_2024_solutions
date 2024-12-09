section .text
	global ft_strcmp

ft_strcmp:
	xor rcx, rcx
	xor rdx, rdx

loop_cmp:
	mov al, [rdi + rcx]
	mov dl, [rsi + rcx]
	cmp al, 0
	je return_cmp
	cmp dl, 0
	je return_cmp
	cmp al, dl
	jne return_cmp
	inc rcx
	jmp loop_cmp

return_cmp:
	movzx rax, BYTE[rdi + rcx]
	movzx rdx, BYTE[rsi + rcx]
	sub rax, rdx
	xor rcx, rcx
	xor rdx, rdx
	ret

section .note.GNU-stack