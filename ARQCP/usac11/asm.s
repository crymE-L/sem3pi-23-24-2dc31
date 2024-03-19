.section .text
    .global extract_token
extract_token:
    xor %rax,%rax
    cmpb $0, (%rdi)
    je end


loop:
    movb (%rdi),%al
    cmpb $0, %al
    je end
    cmpb (%rsi) ,%al
    je iguais
    addq $1, %rdi
    jmp loop

iguais:
    pushq %rsi
    call ver_iguais
    popq %rsi
    cmpl $0, (%rdx)
    jne encontrou
    jmp loop

encontrou:
    movl $1, %eax
    ret
ver_iguais:

    cmpb $0, (%rsi)
    je sIguais
    movb (%rdi), %al
    cmpb (%rsi),%al
    jne diferentes
    addq $1, %rdi
    addq $1, %rsi
    jmp ver_iguais

end:
    ret

diferentes:
    movl $0, %ecx
    ret


sIguais:
    movl $0, %ecx
    movl %ecx,(%rdx)
    jmp retirarValor


retirarValor:
    cmpb $'#', (%rdi)
    je end
    cmpb $0, (%rdi)
    je end
    cmpb $'.', (%rdi)
    je saltar
    movb (%rdi), %al
    subb $'0', %al
    movl (%rdx),%r8d
    imull $10,%r8d
    addl %eax,%r8d
    movl %r8d,(%rdx)

saltar:
    addq $1, %rdi
    jmp retirarValor

