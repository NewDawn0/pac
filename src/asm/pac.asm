	; Syscall variables (macOS)
	sys_exit    equ 0x02000001
	sys_write   equ 0x02000004

	;       Executable section
	section .text
	global  _main
	default rel

	; x86-64 Calling conv
	; Input: rdi, rsi, rdx, rcx, r8, r9
	; Output: rax

	; == MACROS ==

	;      Exit the program : inline void exit(const int)
	;      Args:
	;      -  %1 -> const int code
	%macro exit 1
	mov    rdi, dword %1
	mov    rax, dword sys_exit
	syscall
	%endmacro

	;        Prints an ascii art : inline void printArt(const char**, const char*)
	;        Args:
	;        -  %1 -> const char** art
	;        -  %2 -> const char* colour
	%macro   printArt 2
	;        Print col & save regs
	printCol %2
	push     rax
	;        Print Art
	strlen   %1
	printr   %1, rax
	add      %1, rax
	inc      %1
	;        Restore regs
	pop      rax
	%endmacro

	;      Prints a colour : inline void printCol(const char*)
	;      Clobbers:
	;      -  rax
	;      Args:
	;      -  %1 -> const char* colour
	%macro printCol  1
	;      Save state
	push   rax
	push   rsi
	;      Print colour
	lea    rsi, [%1]
	strlen rsi
	printr rsi, rax
	;      Restore state
	pop    rsi
	pop    rax
	%endmacro

	;          Prints a ghost ascii arts (Wrapper): inline void wPrintGhost(const char**, const int, const char*, const char*, const char*)
	;          Clobbers:
	;          -  al
	;          Args:
	;          -  %1 -> const char** art
	;          -  %2 -> const int line
	;          -  %3 -> const char* colour
	;          -  %4 -> const char* colour
	;          -  %5 -> const char* colour
	%macro     wPrintGhost 5
	;          Save state
	push       rax
	push       r10
	push       r11
	push       r12
	;          Get len
	strlen     %1
	;          Print all pacs
	printGhost %1, rax, %2, %3
	printGhost %1, rax, %2, %4
	printGhost %1, rax, %2, %5
	;          Inc ptr
	add        %1, rax
	inc        %1
	;          Restore state
	pop        r12
	pop        r11
	pop        r10
	pop        rax
	%endmacro

	;        Prints a ghost ascii art : inline void printGhost(const char**, const int, const int, const char*)
	;        Clobbers:
	;        -  al
	;        Args:
	;        -  %1 -> const char** art
	;        -  %2 -> const int len (art)
	;        -  %3 -> const int line
	;        -  %4 -> const char* colour
	%macro   printGhost  4
	;        Save state % print col
	printCol %4
	;        Check if eye part
	cmp      %3, 1
	je       %%eye0
	cmp      %3, 2
	je       %%eye0
	jmp      %%normal

%%eye0:
	;        Save state
	push     %1
	;        p0
	printr   %1, 4
	add      %1, 4
	;        p1
	printCol white
	printr   %1, 9
	add      %1, 9
	;        p2
	printCol %4
	printr   %1, 6
	add      %1, 6
	;        p3
	printCol white
	printr   %1, 9
	add      %1, 9
	;        p4
	printCol %4
	push     r8
	mov      r8, %2
	sub      r8, 28; 4+9+6+9
	printr   %1, r8
	pop      r8
	;        Restore state
	pop      %1
	jmp      %%done

%%normal:
	printr %1, %2

%%done:
	; Restore state
	%endmacro

	; Prints a string range : inline void printr(const char**, const int)
	; Args:
	; -  %1 -> const char** string
	; -  %2 -> const int len

	%macro printr 2
	;      Save state
	push   rax
	push   rdi
	push   rsi
	push   rcx
	push   rdx
	push   r10
	push   r11
	;      Write
	mov    r10, qword %1
	mov    r11, qword %2
	mov    rax, dword sys_write; Write
	mov    rdi, dword 1; Stdout
	mov    rsi, qword r10
	mov    rdx, qword r11
	syscall
	;      Restore state
	pop    r11
	pop    r10
	pop    rdx
	pop    rcx
	pop    rsi
	pop    rdi
	pop    rax
	%endmacro

	; Print inline bytes : inline void printb(const char* ...)
	; Args:
	; -  %1 -> const char* bytes ...

	%macro printb 1+
	jmp    %%done

%%str:
	db %1

%%done:
	push   rax
	push   rdi
	lea    rdi, [%%str]
	strlen rdi
	printr rdi, rax
	pop    rdi
	pop    rax
	%endmacro

	; Get length of str : inline int strlen(const char**)
	; Clobbers:
	; -  al
	; Args:
	; -  %1 -> const char** string
	; Output:
	; -  rax -> int len

	%macro strlen 1
	;      Save state
	push   rdi
	push   rcx
	;      Search for null
	mov    rdi, qword %1
	mov    rcx, dword -1
	xor    al, al
	repne  scasb; Search
	not    rcx
	dec    rcx
	mov    rax, qword rcx
	;      Restore state
	pop    rcx
	pop    rdi
	%endmacro

	; == Functions ==
	; Main entry point

_main:
	;    Create stack frame
	push rbp
	mov  rbp, qword rsp
	;    Main code
	call pac
	;    Restore stack frame
	mov  rsp, qword rbp
	pop  rbp
	exit 0
	;    Not necessary
	ret

	; - rdi -> art ptr
	; - rsi -> col ptr

pac:
	;    Save sate
	push rcx
	;    Setup counter
	mov  rcx, 0
	;    Load ascii
	lea  rdi, [artPac]
	lea  rsi, [artBalls]
	lea  rdx, [artGhost]

.loop:
	;           Print & increase str ptr
	printArt    rdi, yellow
	printArt    rsi, white
	wPrintGhost rdx, rcx, red, blue, pink
	;           Reset term + print newline
	printb      0x1b, "[0m", 10, 0
	;           Compare
	inc         rcx
	cmp         rcx, 6
	jl          .loop

.done:
	;   Restore sate
	pop rcx
	ret

section .data

	; == Data ==

artPac:
	db "   ▄███████▄  ", 0
	db " ▄█████████▀▀ ", 0
	db " ███████▀     ", 0
	db " ███████▄     ", 0
	db " ▀█████████▄▄ ", 0
	db "   ▀███████▀  ", 0

artBalls:
	db "            ", 0
	db "            ", 0
	db " ▄██▄  ▄██▄ ", 0
	db " ▀██▀  ▀██▀ ", 0
	db "            ", 0
	db "            ", 0

artGhost:
	db "   ▄██████▄   ", 0
	db " ▄█▀████▀███▄ ", 0
	db " █▄▄███▄▄████ ", 0
	db " ████████████ ", 0
	db " ██▀██▀▀██▀██ ", 0
	db " ▀   ▀  ▀   ▀ ", 0

red:
	db 0x1b, "[31m", 0

yellow:
	db 0x1b, "[33m", 0

blue:
	db 0x1b, "[34m", 0

pink:
	db 0x1b, "[35m", 0

white:
	db 0x1b, "[37m", 0
