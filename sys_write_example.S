.section .data
    input_buffer: .space 255

.section .text
.global main
main:
    movl $3, %eax #sys_read call
    movl $0, %ebx # stdin
    movl $input_buffer, %ecx
    movl $255, %edx
    int $0x80

    movl $0, %edx
len:
    cmpb $0x0a, (%ecx, %edx, 1) # OxOa hex for \n
    je print
    incl %edx # increment length by 1
    jmp len

print:
    movl $4, %eax # sys_write call
    movl $1, %ebx # stdout
    movl Sinput_buffer, %ecx
    incl %edx # add 1 to string's length to include \n
    int $0x80

end:
    movl $1, %eax
    movl $0, %ebx
    int $0x80