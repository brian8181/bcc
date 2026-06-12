endbr64
push   rbp
mov    rbp,rsp
lea    rax,[rip+0xeac]        # 0x2004
mov    rdi,rax
call   0x1050 <puts@plt>
mov    eax,0x0
pop    rbp
ret