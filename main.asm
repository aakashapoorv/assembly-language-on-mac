; Mac Assembly 
; Aakash Apoorv
; ./test
; ld -o main -e mystart main.o
; nasm -f macho main.asm

section .text
global mystart               ; make the main function externally visible

mystart:
; 1 print "Mac Assembly"
    ;1a prepare the arguments for the system call to write
    ;push dword lenUserMsg  ; message length                          
    ;push dword userMsg     ; message to write
    ;push dword 1           ; file descriptor value
    
    mov eax, 3              ; sys_read system call
    push dword 1            ; input length
    push dword variable     ; address to pass to
    push dword 0            ; read from standard input
    push eax
    int 0x80                ; call the kernel
    add esp, 16             ; move back the stack pointer
    ; write a byte to stdout

    mov eax, 4              ; sys_write system call
    push dword 1            ; output length
    push dword variable     ; memory address
    push dword 1            ; write to standard output
    push eax
    int 0x80                ; call the kernel
    add esp, 16             ; move back the stack pointer
    mov eax, "4"
    sub eax, "0"
    mov ebx, "4"
    sub ebx, "0"
    add eax, ebx
    add eax, "0"
    
    mov [sum], eax
    push dword lenUserMsg   ; message length                         
    push dword userMsg      ; message to write
    push dword 1            ; file descriptor value
    mov eax, 0x4
    sub esp, 0x4
    int 0x80
    add esp, 16
    ;mov ecx, sum
    ;mov edx, 1
    ;mov ebx, 1
    push dword sum
    push dword 1
    ; 1b make the system call to write
    mov eax, 0x4              ; system call number for write
    sub esp, 0x4              ; OS X (and BSD) system calls needs "extra space" on stack
    int 0x80                  ; make the actual system call
    ; 1c clean up the stack
    add esp, 16               ; 3 args * 4 bytes/arg + 4 bytes extra space = 16 bytes
    push dword lenAnotherMsg
    push dword anotherMsg
    push dword 1
    mov eax, 0x4
    sub esp, 0x4
    int 0x80
; 2 exit the program

    ; 2a prepare the argument for the sys call to exit
    push dword 0              ; exit status returned to the operating syste
    ; 2b make the call to sys call to exit
    mov eax, 0x1              ; system call number for exit
    sub esp, 0x1                ; OS X (and BSD) system calls needs "extra space" on stack
    int 0x80                  ; make the system call
    ; 2c no need to clean up the stack because no code here would executed: already exited

section .data
  userMsg db "Please enter a number: ", 0xa  ; string with a carriage-return
  lenUserMsg equ $-userMsg             ; string length in bytes
  anotherMsg db 0xd, " this is another message ", 0xa ;
  lenAnotherMsg equ $-anotherMsg

segment .bss
  sum resb 5
  variable resb 1
