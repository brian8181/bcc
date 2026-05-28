// line:1

_asm
{
    todo
}
// line:2
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

_asm
{
    todo
}

_asm
{
    WHILE:
        cmp op1, op2   ; al < op1
        jne END
        {$stmts}       ; "$stmt"
        jmp WHILE      ; continue loop
    END:               ; exit label
}
