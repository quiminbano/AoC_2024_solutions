section .text
	global _ft_strcmp

_ft_strcmp:
	xor rcx, rcx
	xor rdx, rdx

_loop_cmp:
	mov al, [rdi + rcx]
	mov dl, [rsi + rcx]
	cmp al, 0
	je _return_cmp
	cmp dl, 0
	je _return_cmp
	cmp al, dl
	jne _return_cmp
	inc rcx
	jmp _loop_cmp

_return_cmp:
	movzx rax, BYTE[rdi + rcx]
	movzx rdx, BYTE[rsi + rcx]
	sub rax, rdx
	xor rcx, rcx
	xor rdx, rdx
	ret
