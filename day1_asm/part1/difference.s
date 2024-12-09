section .data
	global difference

difference:
	mov rax, rdi
	sub rax, rsi
	ret

section .note.GNU-stack
