section .text
	global _ft_strlen

_ft_strlen:
	xor rcx, rcx

_loop_len:
	mov al, [rdi + rcx]
	cmp al, 0
	je _return_len
	inc rcx
	jmp _loop_len

_return_len:
	mov rax, rcx
	xor rcx, rcx
	ret
