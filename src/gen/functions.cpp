

#include "functions.hpp"

stringstream& VALUE(stringstream& s)
{
	return ss;
}

stringstream& LESS_THAN_EXPR(const string& lhs; const string& rhs)
{

}

stringstream& LESS_THAN(stringstream& s)
{
	return ss;
}

stringstream& IF(stringstream& ss, stringstream& condition)
{
	ss  << "\n"
		<< "_asm\n"
		<< "{\n"
		<< "        cmp al, op1    ; al < op1\n"
		<< "        jng L1\n"
		<< "        cmp al, op2\n"
		<< "        jnge L1        ; else\n"
		<< "        {$stmts}       ; \"$stmt\"\n"
		<< "    L1:                ; exit label\n"
		<< "}\n";
	return ss;
}

stringstream& ADD(stringstream ss&, const string& lhs, const string& rhs)
{
	ss  << "\n"
		<< "_asm\n"
		<< "{\n"
		<< "    L1: move eax, [si]    ; get first operand\n"
		<< "        adc  eax, [di]    ; get second operand\n"
		<< "        pushf             ; save carry flag\n"
		<< "        move [bx], eax    ; store result\n"
		<< "        add si, 4         ; advance all 3 pointers\n"
		<< "        add di, 4\n"
		<< "        add bx, 4\n"
		<< "        popf              ; restore carry flag\n"
		<< "        jmp L1            ; repeat to count\n"
		<< "}\n";
	return ss;
}

stringstream& FOR()
{
	ss  << "\n"
		<< "_asm\n"
		<< "{\n"
		<< "    .data               ; data segement\n"
		<< "     len db 10          ; data lenght\n"
		<< "    .code               ; code segement\n"
		<< "\n"
		<< "    move ecx, len\n"
		<< "    FOR:\n"
		<< "        cmp op1, len    ; al < op1\n"
		<< "        jne END\n"
		<< "        {$stmts}        ; \"$stmt\"\n"
		<< "        jmp FOR         ; continue loop\n"
		<< "    END:                ; exit label\n"
		<< "}\n";
	return ss;
}

stringstream& WHILE()
{
	ss  << "\n"
	<< "_asm\n"
	<< "{\n"
	<< "    WHILE:\n"
	<< "        cmp op1, op2   ; al < op1\n"
	<< "        jne END\n"
	<< "        {$stmts}       ; \"$stmt\"\n"
	<< "        jmp WHILE      ; continue loop\n"
	<< "    END:               ; exit label\n"
	<< "}\n";
	return ss;
}

stringstream& ELSE(stringstream& ss)
{
	ss  << "\n"
		<< "_asm\n"
		<< "{\n"
		<< "        cmp al, op1    ; al < op1\n"
		<< "        jng L1\n"
		<< "        cmp al, op2\n"
		<< "        jnge L1        ; else\n"
		<< "        {$stmts}       ; \"$stmt\"\n"
		<< "    L1:                ; exit label\n"
		<< "}\n";
	return ss;
}

string gen_if()
{
	stringstream ss;
	ss  << "\n"
		<< "_asm\n"
		<< "{\n"
		<< "        cmp al, op1    ; al < op1\n"
		<< "        jng L1\n"
		<< "        cmp al, op2\n"
		<< "        jnge L1        ; else\n"
		<< "        {$stmts}       ; \"$stmt\"\n"
		<< "    L1:                ; exit label\n"
		<< "}\n";

}

string gen_for()
{
	   stringstream ss;
		ss  << "\n"
			<< "_asm\n"
			<< "{\n"
			<< "    .data               ; data segement\n"
			<< "     len db 10          ; data lenght\n"
			<< "    .code               ; code segement\n"
			<< "\n"
			<< "    move ecx, len\n"
			<< "    FOR:\n"
			<< "        cmp op1, len    ; al < op1\n"
			<< "        jne END\n"
			<< "        {$stmts}        ; \"$stmt\"\n"
			<< "        jmp FOR         ; continue loop\n"
			<< "    END:                ; exit label\n"
			<< "}\n";
		INFO(ss.str());
}
