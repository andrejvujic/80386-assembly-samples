.section .data
text: .ascii "Hello World!\n"
text_len: .long . - text # subtract string start address from the current address to get the string's length

.section .text
.global main
main:
    movl $4, %eax # sys_write
    movl $1, %ebx # stdout
    movl Stext, %ecx
    movl text_len, %edx
    int $0x80

end:
    movl $1, %eax
    movl $0, %ebx
    int $0x80
