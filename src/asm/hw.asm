section .data
    msg db "Hello, World!", 10      ; 10 represents the newline character (\n)
    msg_len equ $ - msg             ; Calculates the length of the string dynamically

section .text
    global _start                   ; Export the entry point for the linker

_start:
    ; System Call to write to stdout
    mov rax, 1                      ; sys_write system call number
    mov rdi, 1                      ; File descriptor 1: stdout
    mov rsi, msg                    ; Pointer to our message string
    mov rdx, msg_len                ; Length of our message string
    syscall                         ; Trigger the Linux kernel

    ; System Call to exit the program
    mov rax, 60                     ; sys_exit system call number
    xor rdi, rdi                    ; Return status code 0 (success)
    syscall                         ; Trigger the Linux kernel