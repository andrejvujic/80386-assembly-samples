.section .data
	LONG = 4
	arr: .long 1, 2, 3, 4, 5
	last_idx: .long (. - arr) / LONG - 1
	arr_sum: .long 0
    
.section .text
.global main
main:
	movl $0, %eax
	
loop:
	cmpl last_idx, %eax
	ja end
	
	movl arr(,%eax,LONG), %ebx
	addl %ebx, arr_sum
	
	incl %eax
	jmp loop
	
end:
	movl $1, %eax
	movl $0, %ebx
	int $0x80