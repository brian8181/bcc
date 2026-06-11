section .text
global main

main:
    ; 1. Setup Stack Frame
    push rbp            ; Save the old base pointer
    mov rbp, rsp        ; Set up a new base pointer frame

    ; 2. C equivalent: int x = 5;
    ;push 5                  ; 'x' is now stored at [rbp - 8] push qword 5 ; push qword 5; 
    push qword 5 

    ; 3. Access 'x' from the stack and add 10 to it
    mov rax, [rbp - 8]      ; Move the value (5) from stack to register RAX
    add rax, 10             ; RAX is now 15

    ; 4. Clean up the stack variable
    add rsp, 8              ; "Pop" the variable away by resetting RSP 
                            ; (Or just use 'leave' below)

    ; 5. Restore Frame and Return
    mov rsp, rbp
    pop rbp
    ret                     ; Returns RAX (15) to the OS
