section .text
	global ft_atoi_base
	extern ft_strlen
	extern ft_isspace

ft_atoi_base:
	push rbp
	mov rbp, rsp
	sub rsp, 24
	push rdi
	mov rdi, rsi
	call ft_strlen
	pop rdi
	cmp rax, 2
	jl return_zero_atoi_base
	mov QWORD[rsp], rax
	push rdi
	mov rdi, rsi
	call validate_base_atoi
	pop rdi
	test rax, rax
	jz return_zero_atoi_base
	mov rax, 1
	mov QWORD[rsp + 8], rax
	mov rax, 0
	mov QWORD[rsp + 16], rax
	xor rax, rax
	xor rdx, rdx
	loop_spaces_atoi_base:
		mov al, [rdi + rcx]
		push rdi
		movzx rdi, BYTE al
		call ft_isspace
		pop rdi
		test rax, rax
		jz loop_signs_atoi_base
		inc rcx
		jmp loop_spaces_atoi_base
	loop_signs_atoi_base:
		mov al, [rdi + rcx]
		push rdi
		movzx rdi, BYTE al
		call ft_issign
		pop rdi
		test rax, rax
		jz check_minus_counter
		movzx rax, BYTE[rdi + rcx]
		inc rcx
		cmp rax, 43
		je loop_signs_atoi_base
		inc rdx
		xor rax, rax
		jmp loop_signs_atoi_base
	check_minus_counter:
		test rdx, 1
		jz clear_rdx_and_continue
		mov rax, -1
		mov QWORD[rsp + 8], rax
	clear_rdx_and_continue:
		xor rdx, rdx
	calculate_number_atoi_base:
		movzx rax, BYTE[rdi + rcx]
		cmp rax, 0
		je return_calculated_number_atoi_base
		push rdi
		push rcx
		xor rcx, rcx
		mov rdi, rax
		call return_base_index_loop
		pop rcx
		pop rdi
		cmp rax, QWORD[rsp]
		je return_calculated_number_atoi_base
		push rax ; push rax moves everthing 8 spaces. So length_base is 8, Sign is 16 and prev_number is 24
		mov rax, QWORD[rsp + 24]
		xor rdx, rdx
		imul rax, QWORD[rsp + 8]
		mov QWORD[rsp + 24], rax
		pop rax
		add rax, QWORD[rsp + 16]
		mov QWORD[rsp + 16], rax
		inc rcx
		jmp calculate_number_atoi_base
	return_calculated_number_atoi_base:
		mov rax, QWORD[rsp + 16]
		xor rdx, rdx
		imul rax, QWORD[rsp + 8]
		add rsp, 24
		mov rsp, rbp
		pop rbp
		ret
	
return_zero_atoi_base:
	add rsp, 24
	mov rsp, rbp
	pop rbp
	xor rax, rax
	ret

return_one_atoi_base:
	add rsp, 24
	mov rsp, rbp
	pop rbp
	mov rax, 1
	ret

validate_base_atoi:
	push rbp
	mov rbp, rsp
	sub rsp, 24
	call loop_for_spaces_and_symbols
	xor rcx, rcx
	test rax, rax
	jnz return_zero_atoi_base
	push rsi ; -32
	call check_repeated_char_base
	pop rsi ; -24
	xor rcx, rcx
	xor r8, r8
	xor rdx, rdx
	test rax, rax
	jnz return_zero_atoi_base
	jmp return_one_atoi_base

loop_for_spaces_and_symbols:
	push rbp
	mov rbp, rsp
	sub rsp, 24
	mov al, [rdi + rcx]
	cmp al, 43
	je return_one_atoi_base
	cmp al, 45
	je return_one_atoi_base
	push rdi
	movzx rdi, BYTE al
	call ft_isspace
	pop rdi
	test rax, rax
	jnz return_one_atoi_base
	inc rcx
	mov al, [rdi + rcx]
	cmp al, 0
	je return_zero_atoi_base
	add rsp, 24
	mov rsp, rbp
	pop rbp
	jmp loop_for_spaces_and_symbols

check_repeated_char_base:
	push rbp
	mov rbp, rsp
	sub rsp, 24
	movzx rsi, BYTE[rdi + rcx]
	xor r8, r8
	xor rdx, rdx
	cmp rsi, 0
	je return_zero_atoi_base
	call loop_for_repeated_char
	test rax, rax
	jnz return_one_atoi_base
	inc rcx
	add rsp, 24
	mov rsp, rbp
	pop rbp
	jmp check_repeated_char_base

loop_for_repeated_char:
	push rbp
	mov rbp, rsp
	sub rsp, 24
	movzx rax, BYTE[rdi + r8]
	cmp rax, 0
	je return_zero_atoi_base
	inc r8
	add rsp, 24
	mov rsp, rbp
	pop rbp
	cmp rax, rsi
	jne loop_for_repeated_char
	push rbp
	mov rbp, rsp
	sub rsp, 24
	inc rdx
	cmp rdx, 2
	jge return_one_atoi_base
	add rsp, 24
	mov rsp, rbp
	pop rbp
	jmp loop_for_repeated_char

ft_issign:
	push rbp
	mov rbp, rsp
	sub rsp, 24
	cmp rdi, 43
	je return_one_atoi_base
	cmp rdi, 45
	je return_one_atoi_base
	jmp return_zero_atoi_base

return_base_index_loop:
	push rbp
	mov rbp, rsp
	sub rsp, 24
	movzx rax, BYTE[rsi + rcx]
	cmp rax, 0
	je return_base_index
	cmp rax, rdi
	je return_base_index
	inc rcx
	add rsp, 24
	mov rsp, rbp
	pop rbp
	jmp return_base_index_loop
	return_base_index:
		add rsp, 24
		mov rsp, rbp
		pop rbp
		mov rax, rcx
		ret

section .note.GNU-stack