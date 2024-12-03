section .text
	global atoi
	extern isspace
	extern isdigit

; const char *str is coming is loaded in rdi
atoi:
	push rbp
	mov rbp, rsp
	sub rsp, 32 ; 0-8 = long result, 9-16 = long sign, 17-32 = empty space JIC
	mov QWORD[rsp], 0 ; result = 0
	mov QWORD[rsp + 8], 1 ; sign = 1
	xor rcx, rcx ; initialized the index counter to 0
find_spaces_atoi: ; while (ft_isspace(str[i]))
	push rdi ; backup str
	movzx rdi, BYTE[rdi + rcx] ; load the character into rdi
	call isspace
	pop rdi ; restore the original pointer in rdi and aligns the stack again.
	test rax, rax
	jz check_plus_atoi
	inc rcx; index++
	jmp find_spaces_atoi
check_plus_atoi: ; if (str[i] == '+')
	xor rax, rax
	movzx rax, BYTE[rdi + rcx]
	cmp rax, 43
	jne check_minus_atoi
	inc rcx
	jmp loop_number_atoi
check_minus_atoi: ; if (str[i] == '-')
	cmp rax, 45
	jne loop_number_atoi
	mov QWORD[rsp + 8], -1 ; sign = -1
	inc rcx
loop_number_atoi: ; while (ft_isdigit(str[i]))
	push rdi ; backup str
	movzx rdi, BYTE[rdi + rcx] ; load the character into rdi
	call isdigit
	pop rdi
	test rax, rax
	jz return_result_atoi
	xor rax, rax
	xor rdx, rdx
	mov rax, QWORD[rsp] ; copy result to rax
	imul rax, 10 ; result * 10
	jo check_neg_overflow_atoi ; if result * 10 overflows
	movzx rdx, BYTE[rdi + rcx]
	sub rdx, 48
	add rax, rdx ;
	mov rdx, rax
	shr rdx, 63 ; Shift the number 63 bits to the right to check if the most significant bit is setted. if it is, there is an overflow (long)
	test rdx, 1 ;
	jnz check_neg_overflow_atoi ; if after plussing the symbol results in an overflow.
	mov QWORD[rsp], rax ; Copy rax to result
	inc rcx
	jmp loop_number_atoi
check_neg_overflow_atoi:
	mov rax, 1
	shl rax, 63 ; Shift 1 63 bits to the left, with this we get LONG_MIN
	cmp QWORD[rsp + 8], -1
	jne return_pos_overflow_atoi
	add rsp, 32
	mov rsp, rbp
	pop rbp
	ret
return_pos_overflow_atoi:
	xor rax, 0xFFFFFFFFFFFFFFFF ; This becomes LONG_MIN stored in rax into LONG_MAX
	add rsp, 32
	mov rsp, rbp
	pop rbp
	ret
return_result_atoi:
	mov rax, QWORD[rsp]
	xor rdx, rdx
	imul rax, QWORD[rsp + 8] ; result = result * sign
	add rsp, 32
	mov rsp, rbp
	pop rbp
	ret ; return (int)(result)

section .note.GNU-stack
