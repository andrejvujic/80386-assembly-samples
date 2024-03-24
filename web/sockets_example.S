.section .data
	SYS_EXIT = 1
	SYS_WRITE = 4
	SYS_CLOSE = 6
	SYS_SOCKET = 359
	SYS_BIND = 361
	SYS_LISTEN = 363
	SYS_ACCEPT4 = 364
		
	STDOUT = 1
	
	AF_INET = 2
	SOCK_STREAM = 1
	PROTOCOL = 0
	PORT = 45845
	INADDR_ANY = 0
	BACKLOG = 5
	
	# struct sockaddr_in {
	#   sa_family_t	 sin_family;	// 16 bits
	#   in_port_t	 sin_port;	        // 16 bits
	#   struct in_addr sin_addr;	    // 32 bits
	#   uint8_t 	 sin_zero[8];       // 64 bits
	# };
	
	sockfd: .long 0
	connfd: .long 0
	
	serv_addr:
		.fill 1, 2, 0
		.fill 1, 2, 0
		.fill 1, 4, 0
		.fill 1, 8, 0
	serv_addr_size = . - serv_addr
	
	cli_addr:
		.fill 1, 2, 0
		.fill 1, 2, 0
		.fill 1, 4, 0
		.fill 1, 8, 0
	cli_addr_size: .long . - cli_addr
	
	starting: .ascii "[INFO] Starting web server...\n"
	starting_len = . - starting
	socket_trace: .ascii "[INFO] Creating a socket...\n"
	socket_trace_len = . - socket_trace
	bind_trace: .ascii "[INFO] Binding the socket...\n"
	bind_trace_len = . - bind_trace
	listen_trace: .ascii "[INFO] Listening to the socket...\n"
	listen_trace_len = . - listen_trace
	accept_trace: .ascii "[INFO] Waiting for client connections...\n"
	accept_trace_len = . - accept_trace
	ok: .ascii "[INFO] OK!\n"
	ok_len = . - ok
	
	http_response: .ascii "HTTP/1.1 200 OK\r\n"
		       .ascii "Content-Type: text/html\r\n"
		       .ascii "Connection: close\r\n"
		       .ascii "\r\n"
		       .ascii "<h1>Hello from 80836 Assembler!</h1>"	
	http_response_len = . - http_response
	
.section .text

.macro sys_exit status_code
	movl $SYS_EXIT, %eax
	movl \status_code, %ebx
	int $0x80
.endm

.macro sys_write fd, buffer, buffer_size
	movl $SYS_WRITE, %eax
	movl \fd, %ebx
	movl \buffer, %ecx
	movl \buffer_size, %edx
	int $0x80
.endm

# int socket(int domain, int type, int protocol);
.macro sys_socket domain, type, protocol
	movl $SYS_SOCKET, %eax
	movl \domain, %ebx
	movl \type, %ecx
	movl \protocol, %edx
	int $0x80
.endm

# int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
.macro sys_bind sockfd, addr, addrlen
	movl $SYS_BIND, %eax
	movl \sockfd, %ebx
	movl \addr, %ecx
	movl \addrlen, %edx
	int $0x80
.endm

# int listen(int sockfd, int backlog);
.macro sys_listen sockfd, backlog
	movl $SYS_LISTEN, %eax
	movl \sockfd, %ebx
	movl \backlog, %ecx
	int $0x80
.endm

# int accept4(int sockfd, struct sockaddr *addr, socklen_t *addrlen, int flags);
.macro sys_accept4 sockfd, addr, addrlen, flags=$0
	movl $SYS_ACCEPT4, %eax
	movl \sockfd, %ebx
	movl \addr, %ecx
	movl \addrlen, %edx
	movl \flags, %esi
	int $0x80
.endm

.macro sys_close sockfd
	movl $SYS_CLOSE, %eax
	movl \sockfd, %ebx
	int $0x80
.endm

.global main
main:
	sys_write $STDOUT, $starting, $starting_len
	
	sys_write $STDOUT, $socket_trace, $socket_trace_len
	sys_socket $AF_INET, $SOCK_STREAM, $PROTOCOL
	movl %eax, sockfd

	movw $AF_INET, serv_addr
	movw $PORT, serv_addr + 2
	movl $INADDR_ANY, serv_addr + 4
	
	sys_write $STDOUT, $bind_trace, $bind_trace_len
	sys_bind sockfd, $serv_addr, $serv_addr_size
	
	sys_write $STDOUT, $listen_trace, $listen_trace_len
	sys_listen sockfd, $BACKLOG
	
next_request:
	sys_write $STDOUT, $accept_trace, $accept_trace_len
	
	sys_accept4 sockfd, $cli_addr, $cli_addr_size
	movl %eax, connfd
	
	sys_write connfd, $http_response, $http_response_len
	sys_close connfd

	jmp next_request
	
	sys_close sockfd	
	sys_write $STDOUT, $ok, $ok_len

end:
	sys_exit $0
