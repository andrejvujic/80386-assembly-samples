.section .data
	LONG = 4
	arr: .long 1, 6, 8, 4, 12
	last_idx: .long (. - arr) / LONG - 1
	
.section .text
.global main
main:
	movl $0, %eax
	movl arr, %ecx # smallest element
	
loop:
	cmpl last_idx, %eax
	ja end
	
	movl arr(,%eax,LONG), %ebx
	cmpl %ecx, %ebx
	
	jae skip_min_update
	movl %ebx, %ecx
	
skip_min_update:
	incl %eax
	jmp loop
	
end:
	movl $1, %eax
	movl $0, %ebx
	int $0x80