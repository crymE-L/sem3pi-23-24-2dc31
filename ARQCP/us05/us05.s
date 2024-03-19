.section .text
    .global mediana
    .global sort_array

mediana:
    movl %esi, %eax                 # move array size to %eax, dividend

    cmpl $0, %eax                   # check if array size is 0
    je end

    call sort_array

    cltd                            # make sure no bits are lost

    movl $2, %ecx                   # move '2' to %ecx to divide

    idivl %ecx                      # divide, remainder is stored %edx

    cmpl $0, %edx                   # check if remainder is 0 which means the array is of even size
    je even_array                   # if true, jump to even_array

odd_array:
    movl (%rdi, %rax, 4), %eax      # store the value being pointed

    jmp end

even_array:
    movl (%rdi, %rax, 4), %r8d      # store the value being pointed

    decl %eax                       # decrement array position

    movl (%rdi, %rax, 4), %r9d      # store the value being pointed

    addl %r8d, %r9d                 # sum both values from array

    movl %r9d, %eax                 # move them to dividend, %eax

    cltd                            # make sure no bits are lost

    idivl %ecx                      # divide, quotient goes to %eax, just return it

end:
    ret