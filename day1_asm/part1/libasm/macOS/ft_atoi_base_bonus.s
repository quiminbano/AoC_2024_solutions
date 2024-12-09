section .text
	global _ft_atoi_base
	extern _ft_strlen

_ft_atoi_base:
	push rbp
	mov rbp, rsp
	sub rsp, 24
	push rdi
	mov rdi, rsi
	call _ft_strlen
	pop rdi
	cmp rax, 2
	jl _return_zero_atoi_base
	mov QWORD[rsp], rax
	push rdi
	mov rdi, rsi
	call _validate_base_atoi
	pop rdi
	test rax, rax
	jz _return_zero_atoi_base
	mov rax, 1
	mov QWORD[rsp + 8], rax
	mov rax, 0
	mov QWORD[rsp + 16], rax
	xor rax, rax
	xor rdx, rdx
	_loop_spaces_atoi_base:
		mov al, [rdi + rcx]
		push rdi
		movzx rdi, BYTE al
		call _ft_isspace
		pop rdi
		test rax, rax
		jz _loop_signs_atoi_base
		inc rcx
		jmp _loop_spaces_atoi_base
	_loop_signs_atoi_base:
		mov al, [rdi + rcx]
		push rdi
		movzx rdi, BYTE al
		call _ft_issign
		pop rdi
		test rax, rax
		jz _check_minus_counter
		movzx rax, BYTE[rdi + rcx]
		inc rcx
		cmp rax, 43
		je _loop_signs_atoi_base
		inc rdx
		xor rax, rax
		jmp _loop_signs_atoi_base
	_check_minus_counter:
		test rdx, 1
		jz _clear_rdx_and_continue
		mov rax, -1
		mov QWORD[rsp + 8], rax
	_clear_rdx_and_continue:
		xor rdx, rdx
	_calculate_number_atoi_base:
		movzx rax, BYTE[rdi + rcx]
		cmp rax, 0
		je _return_calculated_number_atoi_base
		push rdi
		push rcx
		xor rcx, rcx
		mov rdi, rax
		call _return_base_index_loop
		pop rcx
		pop rdi
		cmp rax, QWORD[rsp]
		je _return_calculated_number_atoi_base
		push rax ; push rax moves everthing 8 spaces. So length_base is 8, Sign is 16 and prev_number is 24
		mov rax, QWORD[rsp + 24]
		xor rdx, rdx
		imul rax, QWORD[rsp + 8]
		mov QWORD[rsp + 24], rax
		pop rax
		add rax, QWORD[rsp + 16]
		mov QWORD[rsp + 16], rax
		inc rcx
		jmp _calculate_number_atoi_base
	_return_calculated_number_atoi_base:
		mov rax, QWORD[rsp + 16]
		xor rdx, rdx
		imul rax, QWORD[rsp + 8]
		add rsp, 24
		mov rsp, rbp
		pop rbp
		ret

_return_zero_atoi_base:
	add rsp, 24
	mov rsp, rbp
	pop rbp
	xor rax, rax
	ret

_return_one_atoi_base:
	add rsp, 24
	mov rsp, rbp
	pop rbp
	mov rax, 1
	ret

_validate_base_atoi:
	push rbp
	mov rbp, rsp
	sub rsp, 24
	call _loop_for_spaces_and_symbols
	xor rcx, rcx
	test rax, rax
	jnz _return_zero_atoi_base
	push rsi ; -32
	call _check_repeated_char_base
	pop rsi ; -24
	xor rcx, rcx
	xor r8, r8
	xor rdx, rdx
	test rax, rax
	jnz _return_zero_atoi_base
	jmp _return_one_atoi_base

_loop_for_spaces_and_symbols:
	push rbp
	mov rbp, rsp
	sub rsp, 24
	mov al, [rdi + rcx]
	cmp al, 43
	je _return_one_atoi_base
	cmp al, 45
	je _return_one_atoi_base
	push rdi
	movzx rdi, BYTE al
	call _ft_isspace
	pop rdi
	test rax, rax
	jnz _return_one_atoi_base
	inc rcx
	mov al, [rdi + rcx]
	cmp al, 0
	je _return_zero_atoi_base
	add rsp, 24
	mov rsp, rbp
	pop rbp
	jmp _loop_for_spaces_and_symbols

_check_repeated_char_base:
	push rbp
	mov rbp, rsp
	sub rsp, 24
	movzx rsi, BYTE[rdi + rcx]
	xor r8, r8
	xor rdx, rdx
	cmp rsi, 0
	je _return_zero_atoi_base
	call _loop_for_repeated_char
	test rax, rax
	jnz _return_one_atoi_base
	inc rcx
	add rsp, 24
	mov rsp, rbp
	pop rbp
	jmp _check_repeated_char_base

_loop_for_repeated_char:
	push rbp
	mov rbp, rsp
	sub rsp, 24
	movzx rax, BYTE[rdi + r8]
	cmp rax, 0
	je _return_zero_atoi_base
	inc r8
	add rsp, 24
	mov rsp, rbp
	pop rbp
	cmp rax, rsi
	jne _loop_for_repeated_char
	push rbp
	mov rbp, rsp
	sub rsp, 24
	inc rdx
	cmp rdx, 2
	jge _return_one_atoi_base
	add rsp, 24
	mov rsp, rbp
	pop rbp
	jmp _loop_for_repeated_char

_ft_isspace:
	push rbp
	mov rbp, rsp
	sub rsp, 24
	cmp rdi, 32
	je _return_one_atoi_base
	cmp rdi, 14
	jge _return_zero_atoi_base
	cmp rdi, 8
	jle _return_zero_atoi_base
	jmp _return_one_atoi_base

_ft_issign:
	push rbp
	mov rbp, rsp
	sub rsp, 24
	cmp rdi, 43
	je _return_one_atoi_base
	cmp rdi, 45
	je _return_one_atoi_base
	jmp _return_zero_atoi_base

_return_base_index_loop:
	push rbp
	mov rbp, rsp
	sub rsp, 24
	movzx rax, BYTE[rsi + rcx]
	cmp rax, 0
	je _return_base_index
	cmp rax, rdi
	je _return_base_index
	inc rcx
	add rsp, 24
	mov rsp, rbp
	pop rbp
	jmp _return_base_index_loop
	_return_base_index:
		add rsp, 24
		mov rsp, rbp
		pop rbp
		mov rax, rcx
		ret
