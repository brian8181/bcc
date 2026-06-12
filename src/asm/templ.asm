; @file = <file_name>.asm
; @date = Fri Jun 12 07:48:53 CDT 2026
; @version = 0.0.1

section .data
  
section .text
    global _start

_start:
    
    ; System Call to exit the program
    mov rax, 60                     ; sys_exit system call number
    xor rdi, rdi                    ; Return status code 0 (success)
    syscall                         ; Trigger the Linux kernel
    