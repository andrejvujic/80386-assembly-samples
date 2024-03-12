.section .data
	LONG_SIZE = 4
    # sorting in ascending order
    # output: 1, 3, 8, 9, 65, 76
	arr: .long 8, 9, 3, 1, 65, 76
	last_idx: .long (. - arr) / LONG_SIZE - 1
    
.section .text
.global main
main:
	movl $0, %eax
	
outer_loop:
	cmpl last_idx, %eax
	ja end
	
	movl %eax, %ebx
	incl %ebx
	
	inner_loop:
		cmpl last_idx, %ebx
		ja end_outer_loop
		
		movl arr(,%eax,LONG_SIZE), %ecx
		movl arr(,%ebx,LONG_SIZE), %edx
		
		cmpl %ecx, %edx
		jae skip_swap
		
		movl %edx, arr(,%eax,LONG_SIZE)
		movl %ecx, arr(,%ebx,LONG_SIZE)
		
	skip_swap:	
		incl %ebx
		jmp inner_loop	

	end_outer_loop:
		incl %eax
		jmp outer_loop
		
end:
	movl $1, %eax
	movl %edi, %ebx
	int $0x80