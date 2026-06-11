section .data
    ; %d matches a signed integer, 10 is newline (\n), 0 is null terminator
    fmt db "The value of x is: %d", 10, 0 

section .text
    global main
    extern printf

main:
    ; 1. Setup Stack Frame (Stack is 16-byte aligned here)
    push rbp
    mov rbp, rsp

    ; 2. C equivalent: int x = 5;
    push 5                  ; [rbp - 8] holds 5. (Stack becomes 8-byte misaligned)
    
    ; 3. Correct Stack Alignment & Prepare Arguments
    ; Subtracting 8 bytes of padding fixes alignment back to 16 bytes.
    sub rsp, 8              

    ; Argument 1 (RDI): Pointer to format string
    mov rdi, fmt            
    
    ; Argument 2 (RSI): The value of x read directly from the stack
    mov rsi, [rbp - 8]      
    
    ; RAX/AL must be 0 for printf when no float/vector arguments are used
    xor al, al              

    ; 4. Execute Call
    call printf

    ; 5. Clean up stack frame and exit cleanly
    mov rsp, rbp            ; Resets RSP, instantly wiping out local variable and padding
    pop rbp
    xor rax, rax            ; Return status code 0
    ret
    