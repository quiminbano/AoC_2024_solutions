section .bss
	line resb 4096
	buffer resb 2

section .data
	error_open db 'Error trying to read database.csv', 10, 0
	error_read db 'Error trying to process database.csv', 10, 0
	file_name db 'database.csv', 0

section .text
	global _start
	extern ft_atoi
	extern ft_list_add_front
	extern ft_list_sort
	extern skip_numbers
	extern difference

_start:
	push rbp
	mov rbp, rsp
	sub rsp, 56 ; [rsp] = fd, [rsp + 8] = return_extract_line, [rsp + 16] = number1, [rsp + 24] = number2, [rsp + 32] = list1, [rsp + 40] = list2, 48-56 = extra space stack.
opening_file:
	mov rax, 2
	lea rdi, [rel file_name]
	xor rsi, rsi
	xor rdx, rdx
	syscall
	cmp rax, 0
	jl print_error_file
	mov [rsp], rax
	mov [rsp + 32], 0 ; *list1 = NULL
	mov [rsp + 40], 0 ; *list2 = NULL
loop_extract_numbers:
	mov rdi, [rsp]
	call extract_line
	mov [rsp + 8], rax
	cmp rax, 1
	jl close_file
	lea rdi, [rel line]
	call ft_atoi
	mov [rsp + 16], rax ; number1 = ft_atoi(str)
	lea rdi, [rel line]
	call skip_numbers
	mov rdi, rax
	call ft_atoi
	mov [rsp + 24], rax ; number2 = ft_atoi(str + skipped_spaces)
	lea rdi, [rsp + 32]
	mov rsi, [rsp + 16]
	call ft_list_add_front
	lea rdi, [rsp + 40]
	mov rsi, [rsp + 24]
	call ft_list_add_front
	jmp loop_extract_numbers
close_file:
	mov rax, 3
	mov rdi, [rsp]
	syscall
	mov rax, [rsp + 8]
	test rax, rax
	jnz return_error_main
sort_lists:
	lea rdi, [rsp + 32]
	lea rsi, [rel difference]
	call ft_sort_list
end_main:
	add rsp, 56
	mov rsp, rbp
	pop rbp
	xor rax, rax
	ret
print_error_file:
	mov rax, 1
	mov rdi, 2
	lea rsi, [rel error_open]
	mov rdx, 35
	syscall
	add rsp, 56
	mov rsp, rbp
	pop rbp
	mov rax, 1
	ret
return_error_main: ; Lacking free function to frees linked lists
	mov rax, 1
	mov rdi, 2
	lea rsi, [rel error_read]
	mov rdx, 35
	syscall
	add rsp, 56
	mov rsp, rbp
	pop rbp
	mov rax, 1
	ret

extract_line:
	push rbp
	mov rbp, rsp
	sub rsp, 16
	xor rcx, rcx
reading_loop:
	mov rax, 0
	lea rsi, [rel buffer]
	mov rdx, 1
	syscall
	cmp rax, 1
	jl return_value_extracting_line
	mov al, [rel buffer]
	cmp al, 10
	je return_value_extracting_line
	mov [rel line + rcx], al
	inc rcx
	cmp rcx, 4096
	je return_error_extract_line
	jmp reading_loop
return_value_extracting_line:
	cmp rax, 0
	jl return_error_extracting_line
	mov rax, rcx
	inc rcx
	mov rsi, 0
	mov [rel line + rcx], sil
	add rsp, 16
	mov rsp, rbp
	pop rbp
	ret
return_error_extracting_line:
	mov rax, -1
	add rsp, 16
	mov rsp, rbp
	pop rbp
	ret

section .note.GNU-stack
