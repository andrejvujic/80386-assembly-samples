section .data
text: ascii "Hello World!"
text_len:. long. - text # subtract current address from string start address

section. text
global main
main:
    movl $4, %eax # sys_write movl
    $1, %ebx # stdout
    movl Stext, %ecx
    movl text_len, %edx
    int $0x80

movl $1, %eax
movl $0, %ebx
int $0x80
