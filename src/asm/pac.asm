section .text
global  start
default rel

	; x86-64 Calling conv
	; Input: rdi, rsi, rdx, rcx, r8, r9
	; Output: rax

start:
	call printTest
	call exit

forLoop:
	mov rcx, rdi

.loop:
	cmp  rcx, 0
	jz   .done
	dec  rcx
	mov  rdi, rcx
	call println
	jmp  .loop

.done:
	ret

printTest:
	mov  rdi, 0
	call println
	mov  rdi, 1
	call println
	mov  rdi, 2
	call println
	mov  rdi, 3
	call println
	mov  rdi, 4
	call println
	mov  rdi, 5
	call println
	ret

exit:
	mov rax, 0x02000001
	xor rdi, rdi
	syscall
	ret

print:
	;   Print
	mov r8, rdi
	mov r9, rsi
	mov rax, 0x02000004
	mov rdi, 1
	mov rsi, r8
	mov rdx, r9
	syscall
	ret

printc:
	;    print colour
	;    rdi, rsi, rdx
	push rdx
	push rsi
	;    Print Color
	call strlen
	mov  rsi, rax
	call print
	;    Print string
	pop  rsi
	mov  rdi, rsi
	pop  rdx
	mov  rsi, rdx
	call getLn
	lea  rdi, [rax]
	call strlen
	mov  rsi, rax
	call print
	ret

println:
	mov  r8, rdi
	;    Print full line
	lea  rdi, [cols.yellow]
	lea  rsi, [pac]
	mov  rdx, r8
	push r8
	call printc

	lea  rdi, [cols.white]
	lea  rsi, [balls]
	pop  r8
	mov  rdx, r8
	push r8
	call printc

	lea  rdi, [cols.red]
	lea  rsi, [ghost]
	pop  r8
	mov  rdx, r8
	push r8
	call printc

	lea  rdi, [cols.blue]
	lea  rsi, [ghost]
	pop  r8
	mov  rdx, r8
	push r8
	call printc

	lea  rdi, [cols.pink]
	lea  rsi, [ghost]
	pop  r8
	mov  rdx, r8
	push r8
	call printc

	lea  rdi, [newline]
	mov  rsi, newline.len
	call print
	pop  r8
	ret

strlen:
	xor rax, rax
	mov r8, rdi

.nextCh:
	cmp byte [r8], 0
	jz  .done
	inc r8
	inc rax
	jmp .nextCh

.done:
	ret

getLn:
	xor rax, rax
	mov r8, rdi
	mov r9, rsi
	xor rcx, rcx

.nextCh:
	cmp byte [r8], 0
	jz  .checkSkip
	cmp rcx, r9
	je  .found
	inc r8
	jmp .nextCh

.checkSkip:
	inc rcx
	inc r8
	cmp rcx, r9
	je  .found
	cmp byte [r8], 0
	jz  .done
	jmp .nextCh

.found:
	mov rax, r8
	ret

.done:
	xor rax, rax
	ret

section .data

pac:
	db "   ▄███████▄  ", 0
	db " ▄█████████▀▀ ", 0
	db " ███████▀     ", 0
	db " ███████▄     ", 0
	db " ▀█████████▄▄ ", 0
	db "   ▀███████▀  ", 0

balls:
	db "            ", 0
	db "            ", 0
	db " ▄██▄  ▄██▄ ", 0
	db " ▀██▀  ▀██▀ ", 0
	db "            ", 0
	db "            ", 0

ghost:
	db "   ▄██████▄   ", 0
	db " ▄█▀████▀███▄ ", 0
	db " █▄▄███▄▄████ ", 0
	db " ████████████ ", 0
	db " ██▀██▀▀██▀██ ", 0
	db " ▀   ▀  ▀   ▀ ", 0

newline:
	db   10
	.len equ $ - newline

cols:
	.red    db `\x1b[31m`, 0
	.yellow db `\x1b[33m`, 0
	.blue   db `\x1b[34m`, 0
	.pink   db `\x1b[35m`, 0
	.white  db `\x1b[37m`, 0
	.nc     db `\x1b[0m`, 0
