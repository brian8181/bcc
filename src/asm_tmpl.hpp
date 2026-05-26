#ifndef asm_tmpl_hpp
#define asm_tmpl_hpp

stringstream ss;
ss  << "\n"
    << "_asm\n"
    << "{\n"
    << "    L1: move eax, [si]    ; get first operand\n"
    << "        adc  eax, [di]    ; get second operand\n"
    << "        pushf             ; save carry flag\n"
    << "        move [bx], eax    ; store result\n"
    << "        ${OP} si, 4         ; advance all 3 pointers\n"
    << "        ${OP} di, 4\n"
    << "        ${OP} bx, 4\n"
    << "        popf              ; restore carry flag\n"
    << "        jmp L1            ; repeat to count\n"
    << "}\n";

#endif // asm_tmpl_hpp