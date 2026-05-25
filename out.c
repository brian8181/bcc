// line:1

_asm
{
    L1: move eax, [si]    ; get first operand
        adc  eax, [di]    ; get second operand
        pushf             ; save carry flag
        move [bx], eax    ; store result
        add si, 4         ; advance all 3 pointers
        add di, 4
        add bx, 4
        popf              ; restore carry flag
        jmp L1            ; repeat to count
}
// line:2

_asm
{
    L1: move eax, [si]    ; get first operand
        adc  eax, [di]    ; get second operand
        pushf             ; save carry flag
        move [bx], eax    ; store result
        add si, 4         ; advance all 3 pointers
        add di, 4
        add bx, 4
        popf              ; restore carry flag
        jmp L1            ; repeat to count
}
// line:3

_asm
{
    L1: move eax, [si]    ; get first operand
        adc  eax, [di]    ; get second operand
        pushf             ; save carry flag
        move [bx], eax    ; store result
        add si, 4         ; advance all 3 pointers
        add di, 4
        add bx, 4
        popf              ; restore carry flag
        jmp L1            ; repeat to count
}
// line:4

_asm
{
    L1: move eax, [si]    ; get first operand
        adc  eax, [di]    ; get second operand
        pushf             ; save carry flag
        move [bx], eax    ; store result
        add si, 4         ; advance all 3 pointers
        add di, 4
        add bx, 4
        popf              ; restore carry flag
        jmp L1            ; repeat to count
}
// line:5
// line:6

_asm
{
    L1: move eax, [si]    ; get first operand
        adc  eax, [di]    ; get second operand
        pushf             ; save carry flag
        move [bx], eax    ; store result
        add si, 4         ; advance all 3 pointers
        add di, 4
        add bx, 4
        popf              ; restore carry flag
        jmp L1            ; repeat to count
}

_asm
{
    L1: move eax, [si]    ; get first operand
        adc  eax, [di]    ; get second operand
        pushf             ; save carry flag
        move [bx], eax    ; store result
        add si, 4         ; advance all 3 pointers
        add di, 4
        add bx, 4
        popf              ; restore carry flag
        jmp L1            ; repeat to count
}
// line:7

_asm
{
    L1: move eax, [si]    ; get first operand
        adc  eax, [di]    ; get second operand
        pushf             ; save carry flag
        move [bx], eax    ; store result
        add si, 4         ; advance all 3 pointers
        add di, 4
        add bx, 4
        popf              ; restore carry flag
        jmp L1            ; repeat to count
}
// line:8
// line:9
// line:10
// line:11
// line:12
// line:13
// line:14
// line:15
// line:16
// line:17

_asm
{
        cmp al, op1    ; al < op1
        jng L1
        cmp al, op2
        jnge L1        ; else
        <stmt>         ; "$stmt"
    L1:                ; exit label
}
// line:18
// line:19
// line:20
// line:21
// line:22
// line:23
// line:24
// line:25
// line:26

_asm
{
    mov cx, lhs      ; load lhs in cx register
    mov bx, rhs      ; load rhs in bx register
    and cx, bx       ; and cx(dest), bx(src)
                     ; result is now in cx
}

_asm
{
    mov cx, lhs      ; load lhs in cx register
    not cx           ; not cx(dest)
                     ; result is now in cx
}
// line:27

_asm
{
    WHILE:
        cmp op1, op2    ; al < op1
        jne END
        <stmt>         ; "$stmt"
        jmp WHILE      ; continue loop
    END:                ; exit label
}
