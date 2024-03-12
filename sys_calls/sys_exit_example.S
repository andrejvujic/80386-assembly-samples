.section .data
.section .text
.global main
main:
end:
    movl $1, %eax # sys_exit call
    movl $0, %ebx # status code (inspect with echo $? after ./a.out)
    int $0x80
